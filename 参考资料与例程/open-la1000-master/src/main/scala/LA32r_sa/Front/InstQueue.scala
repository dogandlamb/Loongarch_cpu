package LA32r_sa.Front

import LA32r_sa.Param
import spinal.core._
import spinal.lib._
import LA32r_sa.util._

class InstQueue (implicit p: Param) extends Component {
  val pc_go = out(Bool())
  val ramInitValid = in(Bool())
  val fe = master(new PipePCData())
  val iq = out(new PipeCtrl())
  val inst = master(new ICacheInterface(hasAddr = false))
  val o = master(new IQueueO())
  val pr = out(new PRCancel())
  val br_cancel = in(Bool())
  val wb_cancel = in(Bool())
  val ra = in(UInt(p.ras_res_width.bits))
  val bht = in(new BHTOut())
  val jtb = master(new JTBOut())
  val buf_cancel = out(br_cancel | wb_cancel)

  val reset = ClockDomain.current.readResetWire

  val count = UInt(p.count_width_nz.bits)
  val judge = Reg(new IQueueJ())
  val exception = new Bundle {
    val ever = Reg(Bool())
    val code = Reg(Bits(p.excpCode_width.bits))
  }

  pc_go := inst.req & inst.addr_ok
  fe.go := inst.valid
  inst.cancel := pr.cancel|br_cancel|wb_cancel|reset
  when(inst.valid){
    judge.seq := fe.seq
    judge.is_seq := fe.is_seq
    judge.hint := fe.hint
    judge.pc := fe.cur
    judge.inst := inst.rdata.subdivideIn(32.bits)
    judge.ex := inst.exception
    judge.count := inst.count
    judge.unCache := inst.unCache
  }

  val inst_judge = new InstJudge(judge,fe.target,pr,bht,jtb,ra,count)
  val o_go = o.map(_.fire)//Fix: Add &!cancel ?
//merge hint
  val enc_brop_lack = Seq(
    B(0),
    pr.brops_raw(0).asBits,
    pr.brops_raw.take(2).andR ## pr.brops_raw.take(2).xorR,
    (pr.brops_raw.take(2).andR | pr.brops_raw(2) & pr.brops_raw.take(2).orR) ## pr.brops_raw.take(3).xorR
  ).map(_.resize(p.count_width_nz))
  val hint = Bits((p.hint_width * p.inst_num).bits)
  (0 until p.inst_num).foreach { i =>
    val base = i * p.hint_width
    hint(base, p.count_width_nz.bits) := B(i, p.count_width_nz.bits)
    hint(base + p.count_width_nz, p.count_width_nz.bits) := enc_brop_lack(i)
  }
  if(p.bht.hint_width > 0 || p.jtb.hint_width > 0){
    val minw = Math.min(p.bht.hint_width, p.jtb.hint_width)
    val more = if(p.bht.hint_width > p.jtb.hint_width) bht.hint else jtb.hint
    (0 until p.inst_num).foreach { i =>
      val base = i * p.hint_width + 2 * p.count_width_nz
      val last = (i + 1) * p.hint_width
      val base_b = i * p.bht.hint_width
      val base_j = i * p.jtb.hint_width
      if(minw > 0) hint(base, minw.bits) := Mux(jtb.jrops(i), jtb.hint(base_j, minw.bits).asBits, bht.hint(base_b, minw.bits).asBits)
      hint(base + minw until last) := more(base_b + minw until base_b + p.bht.hint_width)
    }
  }

//  buf_cancel := br_cancel | wb_cancel

  class Data extends Bundle{
    val hint = Bits(p.hint_width.bits)
    val inst = Bits(32.bits)
    val exception = Bool()
    val taken = Bool()

    def this(bits: Bits) {
      this()
      this.assignFromBits(bits)
    }
  }

  val buf = new Bundle{
    def cancel = buf_cancel

    //buf.w.collect

    val w = new Bundle{
      def taken = pr.takens
      def pc = judge.pc
      def ex = judge.ex
      def inst = judge.inst
      val data = (hint.subdivideIn(p.hint_width.bits) zip inst zip taken.asBools).map{case ((h, i), t) =>
        val d = new Data
        d.hint := h
        d.inst := i
        d.exception := ex
        d.taken := t
        d.asBits
      }
      def inflight = fe.valid
      val target = Mux(pr.cancel, pr.target.drop(2).asUInt, fe.target)
      val valid = Reg(Bool())

      def num = p.inst_num
      def align = p.cache_align
      def width = 1 + 1 + 32 + p.hint_width

      val go = Bool()
    }

//decl_queue

    val p_module = new InstQueueP(w = w.width, n = p.iqueue_ptr_width, m = p.port_num)

    val p_head = Reg(UInt((p.iqueue_ptr_width + 3).bits), init = U(0))
    val p_head_add = Seq.tabulate(4)(p_head + _)
    val p_head_next = p_head.validIf(cancel)|
      p_head_add(1).validIf(~o_go(1) & ~ cancel)|
      (2 until p.port_num).map{ i=>
        p_head_add(i).validIf(o_go(i - 1) & ~o_go(i) & ~ cancel)
      }.reduceBalancedTree(_|_)|
      p_head_add.last.validIf(o_go.last & ~ cancel)
    when(o_go.head){ p_head := p_head_next }
    p_module.head := p_head
    def p_read = p_module.o_data
    def p_tail = p_module.tail
    def p_i = p_module.i
    val p_read_takens = p_read.map(new Data(_).taken)

    val full = Bits(2.bits)
    p_module.push := w.valid & ~full(0)
    p_module.i.zipWithIndex.foreach{case (pi, i) => pi.valid := p_module.push && count >= U(i)}
    p_module.cancel := cancel
    (p_module.i zip w.data).foreach{case (pi, d) => pi.payload := d}
    p_module.tail_inc := count
    val p_empty = p_module.head === p_module.tail
    val pc = Reg(Vec(UInt(p.isa_width.bits), 1 << p.iqueue_ptr_width))
    val pc_head = Reg(UInt((p.iqueue_ptr_width + 1).bits), init = U(0))
    val pc_head_inc1 = pc_head + 1
    val pc_head_inc2 = pc_head + 2

    val pc_head_o = collection.mutable.ArrayBuffer(
      pc_head,
      pc_head + o(0).taken.asUInt,
      pc_head + Cat(o(0).taken & o(1).taken, o(0).taken ^ o(1).taken).asUInt
    )
    if(p.port_num > 2){
      pc_head_o += pc_head + Cat(
        o(0).taken & o(1).taken | o(1).taken & o(2).taken | o(2).taken & o(0).taken,
        o(0).taken ^ o(1).taken ^ o(2).taken
      ).asUInt
    }

    val pc_head_next = pc_head.validIf(cancel)|
      pc_head_o(1).validIf(~o_go(1) & ~ cancel)|
      (2 until p.port_num).map{ i=>
        pc_head_o(i).validIf(o_go(i - 1) & ~o_go(i) & ~ cancel)
      }.reduceBalancedTree(_|_)|
      pc_head_o.last.validIf(o_go.last & ~ cancel)
    when(o_go.head){ pc_head := pc_head_next }

    val pc_jumped = RegInit(True)
    w.go := w.valid & ~ full(0)
    val pc_tail = Reg(UInt((p.iqueue_ptr_width + 1).bits), init = U(0))
    val pc_tail_inc = pc_jumped & w.go
    val pc_tail_inc1 = pc_tail + 1
    when(cancel){
      pc_tail := pc_head
    }.elsewhen(pc_tail_inc){
      pc_tail := pc_tail_inc1
    }

    when(pc_tail_inc){
      pc(pc_tail.resize(p.iqueue_ptr_width)) := w.pc
    }
    val pc_full = Bits(2.bits)
    pc_full(0) := (pc_head.msb ^ pc_tail.msb) & (pc_head.dropHigh(1) === pc_tail.dropHigh(1))
    pc_full(1) := (pc_head.msb ^ pc_tail_inc1.msb) & (pc_head.dropHigh(1) === pc_tail_inc1.dropHigh(1))
    val pc_dual = pc_head_inc2 === pc_tail
    val pc_single = pc_head_inc1 === pc_tail
    val pc_empty = pc_head === pc_tail
    val pc_read = pc(pc_head.resize(p.iqueue_ptr_width), 3, true)
    full := p_module.full | pc_full
    when(cancel){
      pc_jumped := True
    }.elsewhen(w.go){
      pc_jumped := pr.taken
    }
    val pc_filled = pc_full(0) | pc_full(1) | pc_dual
    val pc_more = pc_full(0) | pc_full(1)

    val pc_consumed = UInt(p.res_width.bits)
    val pc_consumed_next = UInt(p.res_width.bits)
    val pc_consumed_saved = Reg(UInt(p.res_width.bits))

    val pc_consumed_valid = RegInit(B(0, p.port_num.bits))
    val pc_consumed_valid_next = Bits(p.port_num.bits)
    if(p.port_num == 2){
      pc_consumed(0) := (pc_consumed_saved(0) & pc_consumed_valid(0) | pc_consumed_valid(1)) & ~pc_empty
      pc_consumed(1 until p.res_width) := pc_consumed_saved(1 until p.res_width).validIf(pc_consumed_valid(0) & ~pc_empty)
      pc_consumed_valid_next(0) := ~(o(0).taken | o(1).taken & o_go(1))
      pc_consumed_valid_next(1) := o_go(1) & o(0).taken & ~o(1).taken
    }
    else if(p.port_num == 3){
      pc_consumed(0 to 1) := pc_consumed_saved.takeLow(2).validIf(pc_consumed_valid(0) & ~pc_empty).asUInt |
        pc_consumed_valid.takeHigh(2).validIf(~pc_empty).asUInt
      pc_consumed(2 until p.res_width) := pc_consumed_saved(2 until p.res_width).validIf(pc_consumed_valid(0) & ~pc_empty)
      pc_consumed_valid_next(0) := ~(o(0).taken | o(1).taken & o_go(1) | o(2).taken & o_go(2))
      pc_consumed_valid_next(1) := (o_go(2) & o(1).taken & ~o(2).taken | o_go(1) & o(0).taken & ~o(1).taken & ~o_go(2))
      pc_consumed_valid_next(2) := o_go(2) & o(0).taken & ~o(1).taken & ~o(2).taken
    }
    when(o_go(0)|cancel){
      pc_consumed_valid := pc_consumed_valid_next.validIf(!cancel)
    }
    val pc_consumed_next_lo =
      ((pc_consumed.resize(2) +^ 0).validIf(~o_go(0)) +:
      (1 until p.port_num).map{ i => (pc_consumed.resize(2) +^ i).validIf(o_go(i - 1) & ~o_go(i)) } :+
      (pc_consumed.resize(2) +^ 3).validIf(o_go(2))).reduceBalancedTree(_|_)
    pc_consumed_next(0 until p.count_width_nz) := pc_consumed_next_lo(0 until p.count_width_nz)
    pc_consumed_next(p.count_width_nz until p.res_width) := Mux(pc_consumed_next_lo.msb,
      pc_consumed.drop(p.count_width_nz).asUInt + 1,
      pc_consumed.drop(p.count_width_nz).asUInt)
//    when(o_go(0)){
      pc_consumed_saved := pc_consumed_next
//    }

    //form output

    val p_valid = Bits(p.port_num.bits)
    p_valid(0) := p_head =/= p_tail
    if(p.port_num > 1){
      p_valid(1) := p_head =/= p_tail & p_head_add(1) =/= p_tail
    }
    if(p.port_num > 2){
      p_valid(2) := p_head =/= p_tail & p_head_add(1) =/= p_tail & p_head_add(2) =/= p_tail & ~(p_read_takens(0) & p_read_takens(1))
    }
    (o zip p_i zip p_valid.asBools).foreach{case ((o, pi), pv) => o.valid := Mux(p_empty, pi.valid, pv)}
    val data = Mux(p_empty, Vec(w.data.take(p.port_num)), p_read)
    (o zip data).foreach{case (o, d) => o.payload.assignSomeByName(new Data(d))}

    val pc_offset = pc_consumed @@ U(0, 2.bits)
    val pc_sel0 = pc_read.head
    val pc_sel0_a0 = pc_sel0 + pc_offset
    val pc_sel0_a1 = pc_sel0 + pc_offset + 4
    val pc_sel0_a2 = if(p.port_num > 2) pc_sel0 + pc_offset + 8 else null
    val pc_sel1 = pc_read(1)
    val pc_sel1_a0 = pc_sel1
    val pc_sel1_a1 = pc_sel1 + 4
    val w_pc_a0 = w.pc
    val w_pc_a1 = Cat(w.pc.drop(2 + p.cache_align), w.pc(2 until 2 + p.cache_align) + 1, w.pc.take(2)).asUInt
    val w_pc_a2 = if(p.port_num > 2) Cat(w.pc.drop(2 + p.cache_align), w.pc(3 until 2 + p.cache_align) + 1, w.pc.take(3)).asUInt else null

    val o_q_target = Mux(w.valid, w.pc.drop(2).asUInt, fe.target)
    o(0).pc := Mux(p_empty, w_pc_a0, pc_sel0_a0)
    o(0).target := Mux(p_empty, w.target, Mux(pc_single, o_q_target, pc_read(1).drop(2).asUInt))
    o(1).pc := w_pc_a1.validIf(p_empty) |
      pc_sel1_a0.validIf(~p_empty & p_read_takens(0)) |
      pc_sel0_a1.validIf(~p_empty & ~p_read_takens(0))
    o(1).target := Mux(p_empty, w.target,
      o_q_target.validIf(p_read_takens(0) & ~pc_more | ~p_read_takens(0) & ~pc_filled) |
        pc_read(2).drop(2).asUInt.validIf(p_read_takens(0) & pc_more) |
        pc_read(1).drop(2).asUInt.validIf(~p_read_takens(0) & pc_filled)
    )
    if(p.port_num > 2){
      o(2).pc := w_pc_a2.validIf(p_empty) |
        pc_sel0_a2.validIf(~p_empty & ~p_read_takens(0) & ~p_read_takens(1))|
        pc_sel1_a1.validIf(~p_empty & p_read_takens(0) & ~p_read_takens(1))|
        pc_sel1_a0.validIf(~p_empty & ~p_read_takens(0) & p_read_takens(1))
      o(2).target := Mux(p_empty, w.target,
        o_q_target.validIf((p_read_takens(0) | p_read_takens(1)) & ~pc_more | ~(p_read_takens(0) | p_read_takens(1)) & ~pc_filled) |
          pc_read(2).drop(2).asUInt.validIf((p_read_takens(0) | p_read_takens(1)) & pc_more) |
          pc_read(1).drop(2).asUInt.validIf(~(p_read_takens(0) | p_read_takens(1)) & pc_filled)
      )
    }
  }

  judge.valid.init(False)
  when(buf_cancel){
    judge.valid := False
  }.elsewhen(inst.valid){
    judge.valid := ~pr.cancel
  }.elsewhen(judge.valid){
    judge.valid := False
  }
  buf.w.valid.init(False)
  when(buf_cancel){
    buf.w.valid := False
  }.elsewhen(inst.valid){
    buf.w.valid := ~pr.cancel
  }.elsewhen(~buf.full(0)){
    buf.w.valid := False
  }

  iq.go := buf.w.valid & ~buf.full(0)
  iq.cancel := pr.cancel | br_cancel | wb_cancel
  inst.req := (~buf.full(1) | ~fe.valid) & ~buf.full(0) & ~(buf.w.valid & judge.unCache) & ~ramInitValid & ~exception.ever

  exception.ever.init(False)
  when(buf_cancel){
    exception.ever := False
  }.elsewhen(inst.exception & ~pr.cancel){
    exception.ever := True
  }
  when(inst.exception & ~exception.ever){
    exception.code := inst.excpCode
  }
  o.foreach(_.excpCode := exception.code)
}

object GenInstQueue {
  def main(args: Array[String]): Unit = {
    SpinalConfig(mode = Verilog, removePruned = true, netlistFileName = "InstQueue.v").generate {
      implicit val p = Param()
      new Module {
        this.definitionName = "InstQueueWrapper"
        val pc_go = out(Bool())
        val ramInitValid = in(Bool())
        val fe = master(new PipePCData())
        val iq = out(new PipeCtrl())
        val inst = master(new ICacheInterface(hasAddr = false))
        val o = master(new IQueueO())
        val pr = out(new PRCancel())
        val br_cancel = in(Bool())
        val wb_cancel = in(Bool())
        val ra = in(UInt(p.ras_res_width.bits))
        val bht = in(new BHTOut())
        val jtb = master(new JTBOut())
        val buf_cancel = out(Bool())
        val instQueue = new InstQueue()
        pc_go := instQueue.pc_go
        instQueue.ramInitValid := ramInitValid
        instQueue.fe <> fe
        iq := instQueue.iq
        instQueue.inst <> inst
        instQueue.o <> o
        pr := instQueue.pr
        instQueue.br_cancel := br_cancel
        instQueue.wb_cancel := wb_cancel
        instQueue.ra := ra
        instQueue.bht := bht
        instQueue.jtb <> jtb
        buf_cancel := instQueue.buf_cancel
      }
    }
  }
}
