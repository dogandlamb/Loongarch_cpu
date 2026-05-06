package LA32r_sa.Front

import LA32r_sa.Param
import spinal.core._
import spinal.lib._

object GenRestore {
  //  def reg(wbc:WBCancel, brc:BRCancel, prc:PRCancel, btc:BTCancel = null): (Bundle, Bundle) ={
  //    val restore = new Bundle{
  //      val wb = Reg(Bool(), init = True, next = wbc.cancel)
  //      val br = Reg(Bool(), init = False, next = !wbc.cancel & brc.cancel)
  //      val pr = if(btc != null) Reg(Bool(), init = False, next = !wbc.cancel & !brc.cancel & prc.cancel) else null
  //    }
  //    val reset = new Bundle{
  //      val wb = ClockDomain.current.reset
  //      val br = restore.wb
  //      val pr = restore.wb | restore.br
  //      val bt = if(btc != null) restore.wb | restore.br | restore.pr
  //    }
  //    (restore,reset)
  //  }
  def reg(cancels: PCCancel with Restore with Reset*): Unit = {
    cancels.dropRight(1).foldLeft(False) { case (left, c) =>
      c.restore.setAsReg().init(False)
      c.restore := !left & c.cancel
      left | c.cancel
    }
    cancels.head.restore.init(True)
    cancels.head.reset := ClockDomain.current.readResetWire
//    cancels.reduceLeft { case (left, right) =>
//      right.reset := left.reset | left.restore
//      right
//    }
    cancels.sliding(2).foreach{case Seq(left, right) => right.reset := left.reset | left.restore}
    cancels.last.restore := !cancels.last.reset
  }
}

case class MaskSPRAM(addrWidth:Int, dataWidth:Int, setName:String = "") extends Bundle with IMasterSlave{
  val ce = Bool()
  val en = Bool()
  val a = UInt(addrWidth.bits)
  val rd = Bits(dataWidth.bits)
  val we = Bits(dataWidth.bits)
  val wd = Bits(dataWidth.bits)

  override def asMaster(): Unit = {
    out(this)
    in(rd)
  }

  def deploy(): Unit ={
    val mem = Mem(Bits(dataWidth.bits), a.maxValue + 1)
    rd := mem.readWriteSync(a, wd, ce & en, we.orR, we)
  }

  def toTop():Unit = {
    Pull.toTopOutput(en)
    Pull.toTopOutput(ce)
    Pull.toTopOutput(a)
    Pull.toTopOutput(we)
    Pull.toTopOutput(wd)
    Pull.driveFromTopInput(rd)
  }

  def nameMe(): Unit = {
    ce.setName(setName + '_' + "ce")
    en.setName(setName + '_' + "en")
    a.setName(setName + '_' + "a")
    rd.setName(setName + '_' + "rd")
    we.setName(setName + '_' + "we")
    wd.setName(setName + '_' + "wd")
  }
}

class BHTOut(hasHint:Boolean = true)(implicit p:Param) extends Bundle{
  val taken = Bits(p.inst_num.bits)
  val hint = if(hasHint && p.bht.hint_width > 0) Bits((p.inst_num * p.bht.hint_width).bits) else null
}

class JTBOut(hasHint:Boolean = true)(implicit p:Param) extends Bundle with IMasterSlave {
  val jrops = Bits(p.inst_num.bits)
  val target = UInt(p.res_width.bits)
  val hint = if(hasHint && p.jtb.hint_width > 0) Bits(p.jtb.hint_width.bits) else null

  override def asMaster(): Unit = {
    in(target)
    if(hint != null) in(hint)
    out(jrops)
  }
}