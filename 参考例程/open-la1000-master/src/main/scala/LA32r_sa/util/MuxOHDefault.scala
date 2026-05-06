package LA32r_sa.util

import spinal.core._
import spinal.lib._
import LA32r_sa.util._

object MuxOHDefault {
  def apply[T <: Data](dft: T, pairs: (Bool, T)*):T = {
    Mux(pairs.map(_._1).reduceBalancedTree(_|_),
      pairs.map{case (cond, data) =>
        data.validIf(cond).asBits
      }.reduceBalancedTree(_|_),
      dft.asBits
    ).as(dft)
  }
  def zero[T <: Data](pairs: (Bool, T)*):T = {
    pairs.map{case (cond, data) =>
        data.validIf(cond).asBits
      }.reduceBalancedTree(_|_).as(pairs.head._2)
  }
}
