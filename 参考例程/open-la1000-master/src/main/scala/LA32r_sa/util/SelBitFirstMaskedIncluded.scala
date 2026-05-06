package LA32r_sa.util

import spinal.core._
import spinal.lib._
import LA32r_sa.util._

object SelBitFirstMaskedIncluded {
  def apply(sel: Bits, bits: Bits): Bool = {
    require(sel.getWidth == bits.getWidth)
    (~(sel |<< 1).asBools.paraScan(_ | _).asBits() & bits).orR
  }
}
