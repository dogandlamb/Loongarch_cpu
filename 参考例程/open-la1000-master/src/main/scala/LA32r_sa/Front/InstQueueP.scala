package LA32r_sa.Front

import LA32r_sa.Param
import spinal.core._
import spinal.lib._
import LA32r_sa.util._

class InstQueueP(w:Int = 39, n:Int = 2, m:Int = 3)(implicit p: Param) extends Component {
  val k = 2
  val cancel = in(Bool())
  val head = in(UInt((n + k + 1).bits))
  val tail = out(Reg(UInt((n + k + 1).bits), init = U(0)))
  val tail_inc = in(UInt(k.bits))
  val push = in(Bool())
  val i = in(Vec(Flow(Bits(w.bits)), 1 << k))
  val full = out(Bits(2.bits))
  val o_data = out(Vec(Bits(w.bits), m))

  val data = Seq.fill(4)(Reg(Vec(Bits(w.bits), 1 << n)))
  val tail_next = tail + tail_inc + 1
  val we = Seq.tabulate(4){j =>
    Seq.tabulate(4){k =>
      i(k).valid && tail.take(2).asUInt === U((4 + j - k) % 4)
    }.reduceBalancedTree(_|_)
  }
  val wdata = Seq.tabulate(4){j =>
    Seq.tabulate(4){k =>
      i((4 + j - k) % 4).payload.validIf(tail.take(2).asUInt === U(k))
    }.reduceBalancedTree(_|_)
  }
  val waddr = Seq.tabulate(4){j =>
    tail(2, n.bits) + Mux(tail.take(2).asUInt > U(j), U(1, n.bits), U(0, n.bits))
  }
  val raddr = Seq.tabulate(4){j =>
    head(2, n.bits) + Mux(head.take(2).asUInt > U(j), U(1, n.bits), U(0, n.bits))
  }
  val read = (data zip raddr).map{case (d, a) => d(a)}
  full(0) :=
    tail > head && (False ## tail).asUInt + 4 > Cat(head.msb, ~head.msb, head.dropHigh(1)).asUInt |
    tail < head && (True ## tail).asUInt + 4 > Cat(head.msb, ~head.msb, head.dropHigh(1)).asUInt
  full(1) :=
    tail > head && (False ## tail).asUInt + 8 > Cat(head.msb, ~head.msb, head.dropHigh(1)).asUInt |
    tail < head && (True ## tail).asUInt + 8 > Cat(head.msb, ~head.msb, head.dropHigh(1)).asUInt
  o_data := Vec.tabulate(m){i =>
    read.zipWithIndex.map{case (d, j) => d.validIf(head.take(2) === B((4 + j - i) % 4))}.reduceBalancedTree(_|_)
  }
  (we zip data zip waddr zip wdata).foreach{case(((e, d), a), w) =>
    when(e){ d(a) := w }
  }
  when(cancel){
    tail := head
  }.elsewhen(push){
    tail := tail_next
  }
}
