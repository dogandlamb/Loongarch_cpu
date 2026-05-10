package LA32r_sa.Front

import LA32r_sa.Param
import spinal.core._

class IQueueJ (implicit p:Param) extends Bundle{
  val inst = Vec(Bits(32.bits), p.inst_num)
  val ex = Bool()
  val unCache = Bool()
  val count = UInt(p.count_width_nz.bits)
  val valid = Bool()
  val pc = UInt(p.isa_width.bits)
  val seq = UInt(p.res_width.bits)
  val is_seq = Bool()
  val hint = if(p.btb.hint_width > 0) Bits(p.btb.hint_width.bits) else null
}
