package LA32r_sa.Front

import LA32r_sa.Param
import spinal.core._
import spinal.lib._
import LA32r_sa.util._

case class BaseBTB(
                    ptr_width: Int = 3,
                    tag_width: Int = 30,
                    bitmap_depth: Int = 10
                  ) extends BTBParam() {

  class Hint(implicit p: Param) extends Bundle {
    val valid = Bool()
    val cnt = Bits(cnt_width.bits)
    val index = UInt(ptr_width.bits)
    val brops_raw = Bits(p.inst_num.bits)
    val jrra = Bool()
    val link = Bool()
    val dofs = UInt(p.count_width_nz.bits)
    val jrop = if (p.use_jhr) Bool() else null
    val brop = if (p.use_bhr) Bool() else null
  }
  override def get_brops(hintBits: Bits)(implicit p: Param) = {
    val hint = new Hint
    hint.assignFromBits(hintBits)
    MaskOps(hint.brops_raw, hint.dofs, hint.valid & (hint.cnt.msb | !hint.brop))
  }
  override def get_jrop(hintBits: Bits)(implicit p: Param) = {
    val hint = new Hint
    hint.assignFromBits(hintBits)
    hint.jrop
  }
  override def get_brop(hintBits: Bits)(implicit p: Param) = {
    val hint = new Hint
    hint.assignFromBits(hintBits)
    hint.brop
  }

  class Read(implicit p: Param) extends Bundle {
    val jrra = Bool()
    val link = Bool()
    val dofs = UInt(p.count_width_nz.bits)
    val jrop = if (p.use_jhr) Bool() else null
    val brop = if (p.use_bhr) Bool() else null
  }

  object Read{
    def apply(b:Bits)(implicit p: Param) = {
      val r = new Read
      r.assignFromBits(b)
      r
    }
    def apply(c:PRCancel)(implicit p: Param) = {
      val r = new Read
      r.assignSomeByName(c)
      r
    }
  }

  val cnt_width: Int = 2

  def read_width(implicit p: Param) = new Read().getBitsWidth

  override def hint_width(implicit p: Param) = new Hint().getBitsWidth

  override def get(implicit p: Param): BTB = {
    new BTB{
      this.definitionName = "BaseBTB"
      val num_entry = 1 << ptr_width
      val res_width = p.res_width + read_width

      val pr_hint = new Hint()
      pr_hint.assignFromBits(pr.hint)

      val tagV = Reg(Vec(UInt(tag_width.bits), num_entry))
      val cntV = Reg(Vec(Bits(cnt_width.bits), num_entry))
      val resV = Reg(Vec(Bits(res_width.bits), num_entry))
      val indexO = Counter(num_entry)

      val bitMap = new BitMap(bitmap_depth, p.count_width_nz, 4)
      val brops = bitMap.read.data
      bitMap.read.addr := bt_pc(2, bitmap_depth.bits)
      bitMap.write.addr := ramInit.valid ? (ramInit.index << 2).resize(bitmap_depth) otherwise pr.pc(2, bitmap_depth.bits)
      bitMap.write.data := pr.brops_raw.validIf(!ramInit.valid)
      bitMap.write.mask := (pr.brops_raw ^ pr_hint.brops_raw).validIf(pr.valid) | ramInit.valid.rep(p.inst_num)

      val write = new Area {
        val pad_width = tag_width - p.raminit_width
        val tag = Flow(UInt(tag_width.bits))
        val cnt = Flow(Bits(cnt_width.bits))
        val res = Flow(Bits(res_width.bits))
        val index = !ramInit.valid ? (pr_hint.valid ? pr_hint.index | indexO) otherwise ramInit.index.resize(ptr_width)
        val cnt_next = (pr_hint.cnt(0) ## !pr_hint.cnt(0)).validIf(pr_hint.cnt(1) ^ pr.taken) | (pr.taken & pr_hint.cnt(1)).rep(cnt_width)
        cnt.payload := (pr_hint.valid ? cnt_next otherwise pr.taken ## !pr.brop).validIf(!ramInit.valid)
        tag.payload := ramInit.valid ? (ramInit.index @@ U(0, pad_width.bits)) otherwise pr.pc(2,tag_width.bits)
        res.payload := Read(pr).asBits ## pr.target.drop(2)
        cnt.valid := ramInit.valid | pr.valid & pr_hint.valid | pr.cancel
        tag.valid := ramInit.valid | pr.cancel & pr.taken & ~ pr_hint.valid
        res.valid := ramInit.valid | pr.cancel & pr.taken

        Seq(tag -> tagV, cnt -> cntV, res -> resV).foreach { case (p, v) => when(p.valid) {
          v(index).assignFromBits(p.payload.asBits)
        }
        }
      }

      when(write.tag.valid) {
        indexO.increment()
      }

      val read = new Area {
        val cmp = tagV.map(_ === bt_pc(2, tag_width.bits)).asBits()

        val res = MuxOH.or(cmp, resV)
        val hint = new Hint()
        hint.cnt := MuxOH.or(cmp, cntV)
        hint.index := OHToUInt(OHMasking.first(~cmp.dropHigh(1).orR ## cmp.dropHigh(1)))
        hint.valid := cmp.orR
        hint.brops_raw := brops
        val target = U(res.resize(p.res_width))
        //      val read = new Read
        //      read.assignFromBits(res.drop(res_width))
        //      hint.assignSomeByName(read)
        hint.assignSomeByName(Read(res.drop(p.res_width)))

        bt.cancel := hint.valid & (hint.cnt.msb | !hint.brop)
        bt.target := (hint.jrra ? ra otherwise target) @@ U(0, 2.bits)
        bt.brop := hint.cnt.msb & hint.brop
        bt.jrop := hint.jrop
        bt.brops := MaskOps(brops, hint.dofs, bt.cancel)
        bt.hint := hint.asBits
      }
    }
  }

}

object GenBaseBTB {
  def main(args: Array[String]): Unit = {
    SpinalConfig(mode = Verilog, removePruned = true).generate {
      implicit val par = LA32r_sa.Param(btb = BaseBTB())
      Param().btb.get
    }
  }
}