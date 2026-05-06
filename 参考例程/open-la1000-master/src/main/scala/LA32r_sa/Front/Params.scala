package LA32r_sa.Front

import LA32r_sa.Param
import spinal.core.{Bits, Bool}

trait Use {
  val use_phr = false
  val use_bhr = false
  val use_jhr = false
  val use_rand = false
}

case class PHRParam(
                     blk_width: Int = 4,
                     blk_count: Int = 2,
                     mark_width: Int = 4
                   ) {
  val width = blk_width * blk_count
}

case class JHRParam(
                     blk_width: Int = 8,
                     blk_count: Int = 8,
                     pr_reserve: Int = 2,
                     wb_reserve: Int = 2
                   ) {
  val width = blk_width * blk_count
}

abstract class BTBParam() extends Use {
  def hint_width(implicit p: Param): Int = 0

  def get_brops(hint: Bits)(implicit p: Param): Bits

  def get_jrop(hint: Bits)(implicit p: Param): Bool

  def get_brop(hint: Bits)(implicit p: Param): Bool

  def get(implicit p: Param): BTB
  //  def get(ramInit: RAMInit, iq: PipeCtrl, bt: BTCancel, bt_pc: UInt, pr: PRCancel, ra: UInt)(implicit p: Param): Unit
}

abstract class BHTParam() extends Use {
  def hint_width(implicit p: Param): Int = 0

  def bhr_width(implicit p: Param): Int = 0

  //  def get(bt_pc: UInt, pc_go: Bool, iq_go: Bool, br: BRCancel, pr_cancel: Bool, buf_cancel: Bool, o: BHTOut,
  //          ramInit: RAMInit, bhr: BHROut, phr: PHROut, randVal: UInt)(implicit p: Param): Unit
  def get(implicit p: Param): BHT
}

abstract class JTBParam() extends Use {
  def hint_width(implicit p: Param): Int = 0

  def get(implicit p: Param): JTB
}