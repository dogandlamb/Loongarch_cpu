package LA32r_sa.Cache

import spinal.core._
import spinal.lib._


abstract class AxiA(addrW:Int) extends Bundle
{
  val id     = UInt(4.bits)
  val addr   = UInt(addrW.bits)
  val len    = UInt(8.bits)
  val size   = UInt(3.bits)
  val burst  = UInt(2.bits)
  val lock   = UInt(2.bits)
  val cache  = UInt(4.bits)
  val prot   = UInt(3.bits)
}

class AxiAW(addrW:Int) extends AxiA(addrW)

class AxiAR(addrW:Int) extends AxiA(addrW)

class AxiW(dataW:Int) extends Bundle
{
  val id   = UInt(4.bits)
  val data = Bits(dataW.bits)
  val strb = Bits((dataW/8).bits)
  val last = Bool()
}

class AxiR(dataW:Int) extends Bundle
{
  val id   = UInt(4.bits)
  val data = Bits(dataW.bits)
  val resp = UInt(2.bits)
  val last = Bool()
}

class AxiB extends Bundle
{
  val id   = UInt(4.bits)
  val resp = UInt(2.bits)
}

class ChiplabAXI(addrW:Int, dataW:Int) extends Bundle with IMasterSlave
{
  val aw = Stream(new AxiAW(addrW))
  val w  = Stream(new AxiW(dataW) )
  val b  = Stream(new AxiB )
  val ar = Stream(new AxiAR(addrW))
  val r  = Stream(new AxiR(dataW) )

  override def asMaster(): Unit = {
    master(aw)
    master(w)
    slave(b)
    master(ar)
    slave(r)
  }
}
