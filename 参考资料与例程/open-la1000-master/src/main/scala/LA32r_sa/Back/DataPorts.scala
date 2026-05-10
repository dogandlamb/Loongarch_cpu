package LA32r_sa.Back

import LA32r_sa.Param
import spinal.core._

class WbPort(width:Int) extends Bundle{
  val dest = UInt(5.bits) // have dest info in scoreboard, remove this?
  val finish = Bool()
  val data = UInt(width.bits)
  def src = {
    val res = ExUnit()
    res.assignFromBits(data.asBits.resize(res.getBitsWidth))
    res
  }
}

object WbPort{
  def apply()(implicit p: Param): WbPort = {
    HardType(new WbPort(p.isa_width))()
  }
}

class DataPort(width:Int) extends Bundle{
  val valid = Bool()
  val data = UInt(width.bits)
  def delay = !valid & data.takeHigh(2).orR
  def delay2 = !valid & data.takeHigh(2).lsb
  def fromReg = !valid & data(4)
  @deprecated("use the version with loc")
  def forward(implicit wb:Vec[WbPort]):DataPort = {
    assert(valid || data.dropHigh(2).asUInt < wb.size)
    val choosePort = wb(data.resized)
    val forwarded = new DataPort(width)
    forwarded.valid := True
    forwarded.data := choosePort.data
    Mux(valid || !choosePort.finish, this, forwarded)
  }
  def forward(loc:Int)(implicit wb:Vec[WbPort]):DataPort = {
    assert(valid || data.dropHigh(2).asUInt < wb.size)
    val choosePort = wb(data.resized)
    val forwarded = new DataPort(width)
    forwarded.valid := True
    forwarded.data := choosePort.data
    Mux(valid || Seq(delay, delay2, False)(loc), this, forwarded)
  }
}

object DataPort{
  def apply()(implicit p: Param): DataPort = {
    HardType(new DataPort(p.isa_width))()
  }
  def apply(value:UInt)(implicit p: Param): DataPort = {
    val res = HardType(new DataPort(p.isa_width))()
    res.valid := True
    res.data := value
    res
  }
}

object ForwardData{
  def apply[T <: Bundle](to: T, from: T)(implicit wb:Vec[WbPort]):Unit = {
    to.elements.foreach{ case (name, data) =>
      val other = from.find(name)
      if(other != null){
        data match {
          case vec: Vec[Bundle] => vec zip other.as(vec) foreach{ case (a, b) => apply(a,b) }
          case data: DataPort => data := other.as(data).forward
          case data: Bundle => apply(data, other.asInstanceOf[Bundle])
          case _ => data := other
        }
      }
    }
  }
  def apply[T <: Bundle](to: T, from: T, loc:Int)(implicit wb:Vec[WbPort]):Unit = {
    to.elements.foreach{ case (name, data) =>
      val other = from.find(name)
      if(other != null){
        data match {
          case vec: Vec[Bundle] => vec zip other.as(vec) foreach{ case (a, b) => apply(a,b) }
          case data: DataPort => data := other.as(data).forward(loc)
          case data: Bundle => apply(data, other.asInstanceOf[Bundle])
          case _ => data := other
        }
      }
    }
  }
}

