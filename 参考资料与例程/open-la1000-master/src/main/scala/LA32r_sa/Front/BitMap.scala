package LA32r_sa.Front

import spinal.core._
import spinal.lib._

class BitMap(depth: Int, width: Int = 2, align: Int = 4) extends Component {
  val dataWidth = 1 << width

  val read = new Bundle {
    val addr = in(UInt(depth.bits))
    val data = out(Bits(dataWidth.bits))
  }
  val write = new Bundle {
    val addr = in(UInt(depth.bits))
    val data = in(Bits(dataWidth.bits))
    val mask = in(Bits(dataWidth.bits))
  }
  val tile = (0 until dataWidth).map(_ => Reg(Bits((1 << (depth - width)).bits)))

  val (raMask, raOff) = maskAndOff(read.addr)
  val rd = (tile zip raOff zip raMask.map(!_ || !read.addr(width until align).andR) :+ True).map { case ((t, o), m) =>
    t(U(read.addr.drop(align)) @@ o) & m
  }
  read.data := rd.asBits().rotateRight(read.addr.resize(width))

  val (_, waOff) = maskAndOff(write.addr)
  val wd = write.data.rotateLeft(write.addr.resize(width))
  val wm = write.mask.rotateLeft(write.addr.resize(width))
  (tile zip waOff zip wd.asBools zip wm.asBools).foreach { case (((t, o), d), m) =>
    when(m) {
      t(U(write.addr.drop(align)) @@ o) := d
    }
  }

  def maskAndOff(addr: UInt) = {
    val mask = (1 until dataWidth).map(addr.resize(width) >= _)
    val addrPart = addr(width until align)
    val off = mask.map(Mux(_, addrPart + 1, addrPart)) :+ addrPart
    (mask, off)
  }
}

object GenBitMap {
  def main(args: Array[String]): Unit = {
    SpinalConfig(mode = Verilog, removePruned = true).generate(new BitMap(10))
  }
}
