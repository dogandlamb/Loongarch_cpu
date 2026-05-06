package LA32r_sa.Front

import LA32r_sa.Param
import spinal.core._
import spinal.lib._
import LA32r_sa.util._

class InstJudge(iqj: IQueueJ, fe_tgt: UInt, pr: PRCancel, bht: BHTOut, jtb: JTBOut, ra: UInt, count:UInt) (implicit p: Param) extends Area {

  val align = p.cache_align

  val lo = (0 to p.inst_num).map(iqj.pc(2, align.bits) + _).map(_.resize(align))
  val hi = iqj.pc.drop(28).asUInt
  val hi_carry = hi + 1
  val hi_borrow = hi - 1
  val hi_same = hi === fe_tgt.drop(26).asUInt
  val hi_carry_same = hi_carry === fe_tgt.drop(26).asUInt
  val hi_borrow_same = hi_borrow === fe_tgt.drop(26).asUInt

  val pre_decode = iqj.inst.map(new PreDecode(_))

  val taken_brop = (bht.taken ^ Cat(pre_decode.map(_.sign))) & Cat(pre_decode.map(_.brop))
  val taken_bxop = taken_brop | Cat(pre_decode.map(_.bl_b))
  val taken = taken_brop | Cat(pre_decode.map(_.must))
  val taken_valid = taken.orR

  val base = iqj.pc.drop(2 + align) ## PriorityMux(taken, lo.dropRight(1))

  val endline_cached = iqj.pc(2, align.bits) >= ((1 << align) - p.inst_num)
  val endline = endline_cached & (iqj.pc(2, align.bits).andR | ~iqj.unCache)

  val seq = Mux(endline, iqj.seq.drop(align), iqj.pc.drop(align + 2)) ##
    Mux(iqj.unCache, lo(1).asBits, iqj.seq.take(align))

  val lnlo = PriorityMux(pre_decode.map(_.link), lo.drop(1))
  val lnlo_carry = lnlo === 0

  val link = SelBitFirstMaskedIncluded(taken, pre_decode.map(_.link).asBits())
  val link_pc = Mux(lnlo_carry, iqj.seq.drop(align), iqj.pc.drop(align + 2)) ## lnlo

  val jrra = SelBitFirstMaskedIncluded(taken, pre_decode.map(_.jrra).asBits())
  val jrra_same = fe_tgt === ra

  val jrop = SelBitFirstMaskedIncluded(taken, pre_decode.map(_.jrop).asBits())
  val jrop_same = fe_tgt === jtb.target
  jtb.jrops := pre_decode.map(_.jrop).asBits()

  val brop = SelBitFirstMaskedIncluded(taken, taken_brop)
  val bxop = SelBitFirstMaskedIncluded(taken, taken_bxop)
  val bxop_b = PriorityMux(taken, pre_decode.map(_.sign))
  val bxop_offs = PriorityMux(taken, pre_decode.map(_.offs))
  val check_pc = new Area{
    val next = fe_tgt.take(26)
    val base_ = base.take(26)
    val c = base_ & bxop_offs | base_ & ~next | bxop_offs & ~next
    val s = base_ ^ bxop_offs ^ ~next
    val lo = base_.asUInt +^ bxop_offs.asUInt
    val same = Mux(c(25) ^ bxop_offs(25), Mux(bxop_offs(25), hi_borrow_same, hi_carry_same), hi_same) & s(0) & (s.drop(1) ^ c.dropHigh(1)).andR
  }
  val bxop_c = check_pc.lo(26)
  val bxop_same = check_pc.same
  val bxop_target = (hi.validIf(~bxop_b ^ bxop_c) | hi_carry.validIf(bxop_c & ~bxop_b) | hi_borrow.validIf(~bxop_c & bxop_b)) @@ check_pc.lo.dropHigh(1).asUInt

  val taken_first = OHToUInt(OHMasking.first(~taken.dropHigh(1).orR ## taken.dropHigh(1)))//TODO: make a better implementation?
  count := Mux(taken_valid, taken_first, iqj.count)

  pr.valid := iqj.valid
  pr.jrop := iqj.valid & jrop
  pr.jrra := iqj.valid & jrra
  pr.link := iqj.valid & link
  pr.brop := iqj.valid & brop
  pr.brops := pre_decode.map(_.brop).asBits() & ~(taken |<< 1).asBools.paraScan(_ | _).asBits()
  pr.brops_raw := pre_decode.map(_.brop).asBits()
  pr.pc := iqj.pc
  pr.link_pc := link_pc.asUInt
  pr.base := base.asUInt
  pr.dofs := taken_first
  pr.taken := taken_valid
  pr.takens := taken
  pr.target :=
    (jtb.target.validIf(jrop)|
    bxop_target.validIf(bxop)|
    ra.validIf(jrra)|
    seq.validIf(~taken_valid).asUInt) @@ U(0, 2.bits)
  pr.hint := iqj.hint

  val pr_cancel_path = iqj.valid & (
      bxop & ~bxop_same |
      jrop & ~jrop_same |
      jrra & ~jrra_same |
      ~taken_valid & ~iqj.is_seq |
      iqj.unCache)
  val hint_brops = p.btb.get_brops(iqj.hint)
  val hint_brop = p.btb.get_brop(iqj.hint)
  val hint_jrop = p.btb.get_jrop(iqj.hint)
  val pr_cancel_hint = iqj.valid & ((hint_jrop ^ pr.jrop) | (hint_brop ^ pr.brop) | hint_brops =/= pr.brops)
  pr.cancel := pr_cancel_hint | pr_cancel_path

  //TODO: monitor
}
