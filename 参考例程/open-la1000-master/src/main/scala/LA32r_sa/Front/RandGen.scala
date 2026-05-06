package LA32r_sa.Front

import LA32r_sa.Param
import spinal.core._
import spinal.lib._

class RandGen (implicit p: Param) extends Component {
  val randVal = out(RegInit(U(1,p.rand_width.bits)))
  val pc_go = in(Bool())
  val iq_go = in(Bool())
  when(pc_go | iq_go){
    when(randVal.msb){
      randVal := (randVal @@ U(0,1.bits)).resized
    }.otherwise{
      randVal := ((randVal @@ U(0,1.bits)) ^ U(p.rand_seed)).resized
    }
  }
}
