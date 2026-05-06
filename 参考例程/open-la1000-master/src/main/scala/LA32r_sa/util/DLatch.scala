package LA32r_sa.util

import spinal.core._

object DLatch {
  def apply[T <: Data](next: T, cond: Bool,init: T = null.asInstanceOf[T]):T = {
    val ret = cloneOf(next)
    val reg = RegNextWhen(next, cond, init).setCompositeName(ret, "DLatch", weak = true)
    ret := Mux(cond, next, reg)
    ret
  }
  def withReg[T <: Data](next: T, cond: Bool,init: T = null.asInstanceOf[T]):(T, T) = {
    val ret = cloneOf(next)
    val reg = RegNextWhen(next, cond, init).setCompositeName(ret, "DLatch", weak = true)
    ret := Mux(cond, next, reg)
    (ret, reg)
  }
}
