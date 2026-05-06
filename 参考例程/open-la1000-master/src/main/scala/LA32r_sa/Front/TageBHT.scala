package LA32r_sa.Front

import LA32r_sa.Param
import spinal.core._
import spinal.lib._
import LA32r_sa.util._

case class TageBHT() extends BHTParam()  {
  override val use_bhr = true
  override def hint_width(implicit p: Param) = 1
  override def bhr_width(implicit p: Param) = 21

  val tbl0_depth=6
  val tbl1_depth=8
  val tag_width=8
  def align(implicit p: Param) = p.cache_align
  def ram_width(implicit p: Param) = 1 << align

  class Hint(implicit p: Param) extends Bundle {
    val dofs = Bits(p.count_width_nz.bits)
    val blck = UInt(p.count_width_nz.bits)
    val index = Bool()

    override def asBits = index ## blck ## dofs

    override def assignFromBits(bits: Bits): Unit = {
      dofs := bits.take(p.count_width_nz)
      blck := bits(p.count_width_nz, p.count_width_nz.bits).asUInt
      index := bits.msb
    }
  }

  class State(value: Bool) extends Bool{
    this := value
    val attr = collection.mutable.Map.empty[String, Bits]
}
  override def get(implicit p: Param): BHT= {
    new BHT{
      this.definitionName = "TageBHT"
      def computeAddr(sig: State):Unit = {
        require(bhr_width == 21 && tbl1_depth == 8 && tag_width == 8)
        val dyna = if(sig.attr.contains("dofs")){
          sig.attr("addr").drop(align) ## (br.pc(2, align.bits) + (~sig.attr("dofs").resize(align)).asUInt + 1)
        }else{
          sig.attr("addr")
        }
        val hist = sig.attr("hist")
        sig.attr += (
          //        "dyna" -> dyna,
          "cmp1" -> (hist(0 until 8) ^ hist(8 until 16) ^ (hist(18 until 21) ## hist(16 until 21))),
          "idx1" -> (dyna.take(tbl1_depth) ^ hist(0 until 8) ^ hist(6 until 14) ^ hist(13 until 21)),
          "idx0" -> sig.attr("addr")(align, tbl0_depth.bits),
          "offs" -> sig.attr("addr").take(align)
        )
      }

      val tag1 = MaskSPRAM(tbl1_depth, p.inst_num * tag_width, "bht_tag1")
      val cnt1_hi = MaskSPRAM(tbl1_depth, p.inst_num, "bht_cnt1_hi")
      val cnt1_lo = MaskSPRAM(tbl1_depth, p.inst_num, "bht_cnt1_lo")
      val cnt0_hi = MaskSPRAM(tbl0_depth, ram_width, "bht_cnt0_hi")
      val cnt0_lo = MaskSPRAM(tbl0_depth, ram_width, "bht_cnt0_lo")
      val rams = Set(tag1,      cnt1_hi,        cnt1_lo,        cnt0_hi,        cnt0_lo)
      if(p.pullRAMS) rams.foreach(_.toTop()) else rams.foreach(_.deploy())

      val br_hint = new Hint()
      br_hint.assignFromBits(br.hint)
      val bhr_br_pred = bhr.br.drop(1) >> br_hint.blck
      val bhr_br_next = bhr.br.take(bhr_width)
      val berr = br.brop & br.cancel
      val corr = br.brop & ~br.cancel

      val modify = RegInit(False)
      val modify_idx0 = Reg(Bits(tbl0_depth.bits))
      val modify_idx1 = Reg(Bits(tbl1_depth.bits))
      val modify_cmp1 = Reg(Bits(tag_width.bits))
      val modify_offs = Reg(Bits(align.bits))
      val modify_mark = Reg(Bool())
      val modify_index = Reg(Bool())
      val modify_dofs  = Reg(Bits(p.count_width_nz.bits))
      val modify_cnt0_hi = Bool()
      val modify_cnt0_lo = Bool()
      val modify_cnt1_hi = Bool()
      val modify_cnt1_lo = Bool()

      val read = RegInit(False)
      val read_idx0 = Reg(Bits(tbl0_depth.bits))
      val read_idx1 = Reg(Bits(tbl1_depth.bits))
      val read_cmp1 = Reg(Bits(tag_width.bits))
      val read_offs = Reg(Bits(align.bits))

      val state_b = new State(br.brop & !ramInit.valid)
      val state_c = new State(corr & !ramInit.valid)
      val state_i = new State(ramInit.valid)
      val state_m = new State(modify & !ramInit.valid)
      val state_w = new State(berr & !ramInit.valid)
      val state_p = new State(!berr & !modify & !ramInit.valid)

      state_b.attr += (
        "dofs" -> br_hint.dofs,
        "addr" -> br.pc.drop(2),
        "hist" -> bhr_br_pred.take(p.bhr_width)
      )
      state_w.attr += (
        "addr" -> br.target.drop(2),
        "hist" -> bhr_br_next
      )
      state_p.attr += (
        "addr" -> bt_pc.drop(2),
        "hist" -> bhr.bt
      )
      state_i.attr += (
        "idx0" -> ramInit.index.take(tbl0_depth),
        "idx1" -> ramInit.index.take(tbl1_depth),
        "cmp1" -> B(0,tag_width.bits),
        "offs" -> B(0, align.bits)
      )
      state_m.attr += ("idx0" -> modify_idx0,
        "idx1" -> modify_idx1,
        "cmp1" -> modify_cmp1,
        "offs" -> modify_offs
      )

      Seq(state_b, state_w, state_p).foreach(computeAddr)

      when(berr){
        modify := True
      }.otherwise{
        modify := False
      }

      val br_mark = br.taken ^ br.sign
      when(berr){
        modify_idx0 := state_b.attr("idx0")
        modify_idx1 := state_b.attr("idx1")
        modify_cmp1 := state_b.attr("cmp1")
        modify_offs := state_b.attr("offs")
        modify_dofs := br_hint.dofs
        modify_mark := br_mark
        modify_index := br_hint.index
      }
      val cnt0_lo_rd_sel = cnt0_lo.rd(modify_offs.asUInt)
      val cnt1_lo_rd_sel = cnt1_lo.rd(modify_dofs.asUInt)
      modify_cnt0_hi := cnt0_lo_rd_sel
      val modify_cnt0_lo_more = if(use_rand){
        cnt0_lo_rd_sel =/= modify_mark & !randVal.take(4).orR
      } else False
      modify_cnt0_lo := br_mark & !modify | !(cnt0_lo_rd_sel ^ modify_cnt0_lo_more) & modify
      modify_cnt1_hi := cnt1_lo_rd_sel & modify_index | modify_mark & !modify_index
      modify_cnt1_lo := br_mark & !modify | !cnt1_lo_rd_sel & modify & modify_index | !modify_mark & modify & !modify_index

      val req = Bool()
      val req_t = collection.mutable.Map.empty[String, Bits]
      val req_h = collection.mutable.Map.empty[String, Bits]
      Seq("idx0","idx1","cmp1","offs").foreach{name =>
        req_t += name -> Seq(state_p, state_w, state_m, state_i).map{s =>
          s.attr(name).validIf(s)
        }.reduceBalancedTree(_|_)
        req_h += name -> Seq(state_b, state_m, state_i).map{s =>
          s.attr(name).validIf(s)
        }.reduceBalancedTree(_|_)
      }
      val req_h_offs_dec = UIntToOh(req_h("offs").asUInt)
      val modify_offs_dec = UIntToOh(modify_offs.asUInt)
      val modify_dofs_dec = UIntToOh(modify_dofs.asUInt)
      val br_hint_dofs_dec = UIntToOh(br_hint.dofs.asUInt)

      //set tables
      cnt0_hi.ce := pc_go | ramInit.valid | modify & !modify_index
      cnt0_hi.en := pc_go | ramInit.valid | modify & !modify_index
      cnt0_hi.a := req_t("idx0").asUInt
      cnt0_hi.we := modify_offs_dec.validIf(state_m) | state_i.rep(ram_width)
      cnt0_hi.wd := Cat(Seq.fill(ram_width)(modify_cnt0_hi & !state_i))

      cnt0_lo.ce := state_b & !br_hint.index | modify & !modify_index | state_i
      cnt0_lo.en := state_b & !br_hint.index | modify & !modify_index | state_i
      cnt0_lo.a := req_h("idx0").asUInt
      cnt0_lo.we := req_h_offs_dec.validIf(state_c | state_m) | state_i.rep(ram_width)
      cnt0_lo.wd := Cat(Seq.fill(ram_width)(modify_cnt0_lo & !state_i))

      tag1.ce := pc_go | ramInit.valid | modify & !modify_index
      tag1.en := pc_go | ramInit.valid | modify & !modify_index
      tag1.a := req_t("idx1").asUInt
      tag1.we := Cat(modify_dofs_dec.asBools.map(b => (b & modify).rep(tag_width))) | state_i.rep(tag1.we.getWidth)
      tag1.wd := (modify_cmp1.validIf(~state_i)).rep(p.inst_num)

      cnt1_hi.ce := pc_go | ramInit.valid | modify & modify_index
      cnt1_hi.en := pc_go | ramInit.valid | modify & modify_index
      cnt1_hi.a := req_t("idx1").asUInt
      cnt1_hi.we := modify_dofs_dec.validIf(state_m) | state_i.rep(p.inst_num)
      cnt1_hi.wd := (modify_cnt1_hi & !state_i).rep(p.inst_num)

      cnt1_lo.ce := state_b & br_hint.index | state_m & modify_index | state_i
      cnt1_lo.en := state_b & br_hint.index | state_m & modify_index | state_i
      cnt1_lo.a := req_h("idx1").asUInt
      cnt1_lo.we := br_hint_dofs_dec.validIf(state_c) | modify_dofs_dec.validIf(state_m) | state_i.rep(p.inst_num)
      cnt1_lo.wd := (modify_cnt1_lo & !state_i).rep(p.inst_num)

      req := state_w | pc_go & !modify & !pr_cancel & !buf_cancel
      when(req){
        read := True
        //  }.elsewhen(read){
      }.otherwise{
        read := False
      }

      when(req){
        read_idx0 := req_t("idx0")
        read_idx1 := req_t("idx1")
        read_cmp1 := req_t("cmp1")
        read_offs := req_t("offs")
      }

      val ptr_w = RegInit(U(0,1.bits))
      val ptr_r = RegInit(U(0,1.bits))
      val data_width = p.inst_num * 2
      val buf_data = Reg(Vec(Bits(data_width.bits),2))
      val buf_read = buf_data(ptr_r)
      val buf_next = Bits(data_width.bits)
      when(iq_go){
        ptr_r := ~ptr_r
      }
      when(buf_cancel){
        ptr_w := ptr_r ^ iq_go.asUInt
      }.elsewhen(pr_cancel){
        ptr_w := ~ptr_r
      }.elsewhen(read){
        ptr_w := ~ptr_w
      }
      when(read){
        buf_data(ptr_w) := buf_next
      }

      val pred_conf0 = modify_offs_dec.validIf(modify & modify_idx0 === read_idx0 & !modify_index)
      val pred_conf1 = modify_dofs_dec.validIf(modify & modify_idx1 === read_idx1)
      val pred_hit1 = Cat((0 until p.inst_num).map{i => tag1.rd(i*tag_width,tag_width.bits) === read_cmp1})
      val modify_hit1 = modify_cmp1 === read_cmp1
      val pred_hit1_fw = pred_conf1.validIf(modify_hit1) | pred_hit1 & ~pred_conf1
      val pred_cnt0_hi_fw = pred_conf0.validIf(modify_cnt0_hi) | cnt0_hi.rd & ~pred_conf0
      val pred_cnt1_hi_fw = pred_conf1.validIf(modify_cnt1_hi) | cnt1_hi.rd & ~pred_conf1
      val pred_cnt0_hi_sel = pred_cnt0_hi_fw(read_offs.asUInt, p.inst_num.bits)
      buf_next := pred_hit1_fw ## (pred_cnt1_hi_fw & pred_hit1_fw | pred_cnt0_hi_sel & ~pred_hit1_fw)
      o.taken := buf_read.take(p.inst_num)
      o.hint := buf_read.drop(p.inst_num)

      //try to name some sig
      (Seq(state_b, state_c, state_i, state_m, state_w, state_p) zip "bcimwp").foreach{ case (state, c) =>
        state.attr.foreach{ case (str, bits) =>
          if(bits.isUnnamed)
            bits.setName(c.toString + '_' + str)
        }
      }
    }
  }
}

object GenTageBHT {
  def main(args: Array[String]): Unit = {
    SpinalConfig(mode = Verilog, removePruned = true).generate {
      implicit val par = LA32r_sa.Param(bht = new TageBHT)
      Param().bht.get
    }
  }
}
