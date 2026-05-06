package LA32r_sa.Back

import LA32r_sa.Param
import spinal.core._
import spinal.lib._
import LA32r_sa.util._

class RegFile(nRead:Int = 6, nWrite:Int = 2, dataW:Int = 32, addrW:Int = 5) extends Component{
  def this(nRead:Int, nWrite:Int)(implicit p:Param){this(nRead, nWrite, p.isa_width)}
  val w = Vec(slave(new RegWrite(dataW, addrW)), nWrite)
  val r = Vec(slave(new RegRead(dataW, addrW)), nRead)

  val reg = Reg(Vec(UInt(32.bits), 32))

  r.foreach { r =>
    //change this order?
    r.data := w.foldLeft(reg(r.addr)){ case (d, w) =>
      (r.addr === w.addr && w.en && w.addr.orR)? w.data | d
    }
  }

  //in verilog, last assign win, solve write conflict
  w.foreach{ w =>
    when(w.en & w.addr.orR){
      reg(w.addr) := w.data
    }
  }
}

class RegRead(dataW:Int = 32, addrW:Int = 5) extends Bundle with IMasterSlave {
  def this()(implicit p:Param){this(p.isa_width)}
  val addr = UInt(addrW.bits)
  val data = UInt(dataW.bits)

  override def asMaster(): Unit = {
    out(addr)
    in(data)
  }
}

class RegWrite(dataW:Int = 32, addrW:Int = 5) extends Bundle with IMasterSlave {
  def this()(implicit p:Param){this(p.isa_width)}
  val addr = UInt(addrW.bits)
  val en = Bool()
  val data = UInt(dataW.bits)

  override def asMaster(): Unit = {
    out(this)
  }
}

object GenReg {
  def main(args: Array[String]): Unit = {
    SpinalConfig(mode = Verilog, removePruned = true).generate(new RegFile())
  }
}