package LA32r_sa.util

import spinal.core._
import spinal.lib._

object ValidIf {
  def apply[T <: Data](data: T, cond: Bool):T = {
    (data.asBits & Cat(Seq.fill(widthOf(data))(cond))).as(data)
  }
}
