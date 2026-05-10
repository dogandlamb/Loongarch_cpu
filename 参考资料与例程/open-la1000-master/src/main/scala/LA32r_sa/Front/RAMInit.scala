package LA32r_sa.Front

import LA32r_sa.Param
import spinal.core._

class RAMInit(implicit p: Param) extends Bundle {
  val index = UInt(p.raminit_width.bits)
  val valid = Bool()
  def deploy():RAMInit = {
    index.setAsReg().init(0)
    valid.setAsReg().init(true)
    when(valid) {
      index := index + 1
    }
    when(index.andR) {
      valid := False
    }
    this
  }
}
