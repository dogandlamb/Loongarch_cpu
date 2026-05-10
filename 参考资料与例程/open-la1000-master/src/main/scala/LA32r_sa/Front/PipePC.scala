package LA32r_sa.Front

import LA32r_sa.Param
import spinal.core._
import spinal.lib._

class PipePC(implicit p: Param) extends Component {
  val bt = in(new BTCancel())
  val bt_pc = out(UInt(p.isa_width.bits))
  val pr = in(new PCCancel())
  val br = in(new PCCancel())
  val wb = in(new PCCancel())
  val pc_go = in(Bool)
  val pc_init = in(UInt(p.isa_width.bits))
  val fe = slave(new PipePCData(true))
  val iq = in(new PipeCtrl())
  val inst_addr = out(UInt(p.isa_width.bits))
  //IO
//  separate pc for convenience
  val pc_next_en = Seq(wb, br, pr).map(_.cancel).reduce(_ || _) || pc_go
  val pc_cur = RegInit(pc_init)
  val pc_seq = Mux(pc_cur(2, p.cache_align.bits) >= ((1<<p.cache_align) - p.inst_num),
    (pc_cur(p.cache_align + 2 until pc_cur.getWidth) + U(1))<<p.cache_align,
    pc_cur(p.cache_align + 2 until pc_cur.getWidth) @@ (pc_cur(2 until p.cache_align + 2) + p.inst_num).resize(p.cache_align)
  )
  val pc_next = Seq(wb, br, pr, bt).foldRight(pc_seq << 2)((cancel, pc) => {
    cancel.cancel ? cancel.target | pc
  })
  when(pc_next_en) {
    pc_cur := pc_next
  }
  bt_pc := pc_cur
  //IDEA report error, is IDEA's bug
  fe.target := fe.valid ? fe.cur(2 until fe.cur.getWidth) | pc_cur(2 until pc_cur.getWidth)
  inst_addr := pc_cur
  when(pc_go) {
    fe.cur := pc_cur
    fe.seq := pc_seq
    fe.hint := bt.hint
    fe.is_seq := !bt.cancel
  }
  fe.valid.init(false)
  when(iq.cancel){
    fe.valid := False
  }.elsewhen(pc_go){
    fe.valid := True
  }.elsewhen(fe.go){
    fe.valid := False
  }
}

class PipePCData(setReg: Boolean = false)(implicit p: Param) extends Bundle with IMasterSlave {
  val go = Bool() //seems always have go = true
  val cur = UInt(p.isa_width.bits)
  val valid = Bool()
  val seq = UInt(p.res_width.bits)
  val target = UInt(p.res_width.bits)
  val is_seq = Bool()
  val hint = Bits(p.btb.hint_width.bits)
  if (setReg) {
    cur.setAsReg()
    valid.setAsReg()
    seq.setAsReg()
    is_seq.setAsReg()
    hint.setAsReg()
  }

  override def asMaster(): Unit = {
    in(this)
    out(go)
  }
}

class PipeCtrl(hasGo: Boolean = true) extends Bundle {
  val go = if (hasGo) Bool() else null
  val cancel = Bool()
}
