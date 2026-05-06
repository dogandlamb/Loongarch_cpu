package LA32r_sa.Front

import LA32r_sa.Param
import spinal.core._
import spinal.lib._

class IQueueOData(implicit p:Param) extends Bundle{
  val pc = UInt(p.isa_width.bits)
  val target = UInt(p.res_width.bits)
  val inst = Bits(32.bits)
  val taken = Bool()
  val exception = Bool()
  val excpCode = Bits(p.excpCode_width.bits)
  val hint = Bits((1 max p.hint_width).bits)
}

//class IQueueO(implicit p:Param) extends Bundle {
//  val allow = Bits(p.port_num.bits)
//  val valid = new Bool()
//  val port = (0 until p.port_num).map(_ => new IQueueOData)
//}

class IQueueO(implicit p:Param) extends Vec(Stream(new IQueueOData), Vector.fill(p.port_num)(Stream(new IQueueOData))) with IMasterSlave {
  override def asMaster(): Unit = {
    this.foreach(master(_))
  }
}
