package LA32r_sa.util

import spinal.core._

object RSLatch {
  def apply(set: Bool, reset:Bool, init:Bool = False):Bool = {
    val reg = RegInit(init)
    when(set){
      reg := True
    }.elsewhen(reset){
      reg := False
    }
    set | reg & !reset
  }
}
