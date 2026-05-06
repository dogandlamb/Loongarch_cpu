package LA32r_sa.Back

import LA32r_sa.Param
import LA32r_sa.util._
import spinal.core._

class BRUI(width: Int = 32) extends Bundle{
  val a, b = UInt(width.bits)
  val op = BRUCode()
  val taken = Bool()
  val pc, target, offset = UInt(width.bits)
  val cancel_allow = Bool()
}

class BRUO(width: Int = 32) extends Bundle {
  val cancel, taken = Bool()
  val target, link_pc = UInt(width.bits)
}

class BRU(width: Int = 32) extends Component {
  def this()(implicit p:Param){this(p.isa_width)}

  import BRUCode._

  val i = in(new BRUI(width))
  val o = out(new BRUO(width))

  //BRANCHop decoder
  val op_beqz = i.op === EQZ
  val op_bnez = i.op === NEZ
//  val op_bnc = i.op === JR
  val op_beq = i.op === EQ
  val op_bne = i.op === NE
  val op_blt = i.op === LT
  val op_bge = i.op === GE
  val op_bltu = i.op === LTU
  val op_bgeu = i.op === GEU
  val op_jirl = i.op === JR
//  val op_bl = i.op === BL

  val from_s = op_beqz || op_bnez

  val need_eqx = op_beq
  val need_nex = op_bne
  val need_ltx = op_blt || op_bltu
  val need_gex = op_bge || op_bgeu
  val need_eqz = op_beqz
  val need_nez = op_bnez

  val need_any = need_eqx || need_nex || need_gex || need_ltx || need_eqz || need_nez
  val need_compute = op_jirl

  ////func
  //condition judge
  val compare_unsigned = op_bgeu || op_bltu
  val compare_ltx_u = i.a < i.b
  val compare_ltx_s = i.a.asSInt < i.b.asSInt

  val cond_ltx = compare_unsigned ? compare_ltx_u | compare_ltx_s
  val cond_eqx = i.a === i.b
  val cond_seqz = !i.a.orR
  val cond_eqz = from_s && cond_seqz

  //overall condition
  val take = (!need_eqz || cond_eqz) &&
    (!need_nez || !cond_eqz) &&
    (!need_eqx || cond_eqx) &&
    (!need_nex || !cond_eqx) &&
    (!need_ltx || cond_ltx) &&
    (!need_gex || !cond_ltx)

  val cancel = need_any && take =/= i.taken || need_compute && o.target =/= i.target

  // jump target calculate
  val target_next = (i.pc(2 until width) + 1) << 2
  val target_true = (i.pc(2 until width) << 2) + i.offset
  val target_jr = i.a + i.offset

  o.target := MuxOHDefault.zero(
    (!op_jirl && take) -> target_true,
    (!op_jirl && !take) -> target_next,
    op_jirl -> target_jr
  )
  o.cancel := cancel && i.cancel_allow
  o.taken := take
  o.link_pc := target_next
}

object GenBRU {
  def main(args: Array[String]): Unit = {
    SpinalConfig(mode = Verilog, removePruned = true).generate(new BRU()(Param()))
  }
}
