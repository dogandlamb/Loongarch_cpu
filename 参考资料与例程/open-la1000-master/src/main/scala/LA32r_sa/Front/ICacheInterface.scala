package LA32r_sa.Front

import LA32r_sa.Param
import spinal.core._
import spinal.lib._


class ICacheInterface(hasAddr:Boolean = true)(implicit p: Param)extends Bundle with IMasterSlave {
  val addr    = if(hasAddr) UInt(p.isa_width.bits) else null
  val addr_ok = Bool
  val cancel  = Bool
  val count   = UInt(2.bits)
  val exception      = Bool
  val excpCode = Bits(p.excpCode_width.bits)
  val rdata   = Bits((32*p.inst_num).bits)
  val req     = Bool
  val unCache = Bool
  val valid   = Bool
  def asMaster(): Unit = {
    if(hasAddr) out(addr)
    out(cancel, req)
    in(addr_ok, count, exception, excpCode, rdata, unCache, valid)
  }
}
