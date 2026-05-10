package LA32r_sa.TLB

import LA32r_sa.LISA
import spinal.core._
import spinal.lib._

case class TLBParam (
                    PALen:Int = 32,
                    L1Size:Int = 8,
                    L2Way:Int = 2,
                    L2Set:Int = 64,
                    ){
  require((L1Size & (L1Size - 1)) == 0, "L1Size" + L1Size + " not power of 2")
  require((L2Way & (L2Way - 1)) == 0, "L2Way" + L2Way + " not power of 2")
  require((L2Set & (L2Set - 1)) == 0, "L2Set" + L2Set + " not power of 2")
  val VALen = LISA.w_gpr
  val PS = LISA.PSMin
  val PSHuge = LISA.PSHuge
  val VPNLen = VALen - PS - 1
  val VPNLenHuge = VALen - PSHuge - 1
  val PPNLen = PALen - PS
  val L1Bit = log2Up(L1Size)
  val L2WayBit = log2Up(L2Way)
  val L2SetBit = log2Up(L2Set)
  val IDXBit = L2WayBit + L2SetBit
  val L2TagBit = VPNLen - L2SetBit
  val L2TagBitHuge = VPNLenHuge - L2SetBit
}

object ReqType extends SpinalEnum{
  val fetch, data, search = newElement()
}
