package LA32r_sa.Front

import LA32r_sa.Param
import spinal.core._
import spinal.lib._
import LA32r_sa.util._

class PreDecode(inst: Bits)(implicit p: Param) extends Area {
  val bseg = inst(30 until 32) === 1
  val jirl = inst(26 until 30) === 3
  val cmpz = inst(27 until 30) === 0
  val bunc = inst(27 until 30) === 2
  val cond = inst(27 until 30) === 3 | inst(28 until 30) === 2
  val sign = cond & inst(25) | cmpz & inst(4) | bunc & inst(9)
  val offs = Mux(bunc, inst(5, 5.bits), sign.rep(5)) ## Mux(cond, sign.rep(5), inst(0, 5.bits)) ## inst(10, 16.bits)
  val rdra = inst(0, 5.bits) === 1
  val rjra = inst(0, 26.bits) === 0x20
  val blop = bunc & inst(26)
  val bl_b = bseg & bunc
  val must = bseg & (bunc | jirl)
  val brop = bseg & (cmpz | cond)
  val link = bseg & (blop | jirl & rdra)
  val jrop = bseg & jirl & ~rjra
  val jrra = bseg & jirl & rjra
}
