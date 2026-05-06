package LA32r_sa.Front

import LA32r_sa.Param
import spinal.core._
import spinal.lib._

trait Restore{val restore = Bool()}
trait Reset{val reset = Bool()}
trait HR{var hr:Option[Bits] = None}//We Don't know width, and parameterized trait requires Scala 3

object MaskOps{
  def apply(raw:Bits, dofs:UInt, taken:Bool)= {
    raw.asBools.zipWithIndex.map{case (r, i) => r & (dofs >= i | !taken)}.asBits()
  }
}

class PCCancel(hasC: Boolean = true, hasT: Boolean = true)(implicit p: Param) extends Bundle {
  //  (in V1.6) spinal can prune unused IO if they are submodules, we can also prune them manually (not yet)
  //  OK to assign a full Bundle to a pruned Bundle
  val cancel = if (hasC) Bool() else null
  val target = if (hasT) UInt(p.isa_width.bits) else null
}

class BTCancel(hasC: Boolean = true, hasT: Boolean = true, hasJ: Boolean = true, hasB: Boolean = true, hasH: Boolean = true)
              (implicit p: Param) extends PCCancel(hasC, hasT) {
  //  we take pc out and treat this as btb response so this only drive by btb
  //  val pc = UInt(p.isa_width.bits)
  val jrop = if (p.use_jhr && hasJ) Bool() else null
  val brop = if (p.use_bhr && hasB) Bool() else null
  val brops = if (p.use_bhr && hasB) Bits(p.inst_num.bits) else null
  val hint = if (p.btb.hint_width > 0 && hasH) Bits(p.btb.hint_width.bits) else null
}

class SomeCancel(implicit p: Param) extends PCCancel {
  val brop = Bool()
  val jrop = Bool()
  val jrra = Bool()
  val link = Bool()
  val taken = Bool()
  val link_pc = UInt(p.res_width.bits)
  val pc = UInt(p.isa_width.bits)
}

class PRCancel(implicit p: Param) extends SomeCancel {
  val valid = Bool()
  val dofs = UInt(p.count_width_nz.bits)
  val base = UInt(p.res_width.bits)
  val brops = Bits(p.inst_num.bits)
  val brops_raw = Bits(p.inst_num.bits)
  val takens = Bits(p.inst_num.bits)
  val hint = Bits(p.btb.hint_width.bits)
}

class WBCancel(implicit p: Param) extends SomeCancel

class BRCancel(implicit p: Param) extends SomeCancel {
  val hint = Bits(p.hint_width.bits)
  val sign = Bool()
//  val brop0 = Bool()
//  val brop1 = Bool()
//  val taken0 = Bool()
//  val taken1 = Bool()
//  val jrop0 = Bool()
//  val jrop1 = Bool()
//  val target0 = UInt(p.isa_width.bits)
//  val target1 = UInt(p.isa_width.bits)
//  val jrra0 = Bool()
//  val jrra1 = Bool()
//  val link0 = Bool()
//  val link1 = Bool()
}