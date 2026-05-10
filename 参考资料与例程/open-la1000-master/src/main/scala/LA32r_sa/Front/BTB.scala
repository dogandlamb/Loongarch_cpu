package LA32r_sa.Front

import LA32r_sa.Param
import spinal.core._

class BTB (implicit p: Param)extends Component {
  val ramInit = in(new RAMInit())
  val iq = in(new PipeCtrl())
  val bt = out(new BTCancel())
  val bt_pc = in(UInt(p.isa_width.bits))
  val pr = in(new PRCancel())
  val ra = in(UInt(p.res_width.bits))
  //IO
//  p.btb.get(ramInit, iq, bt, bt_pc, pr, ra)
}
