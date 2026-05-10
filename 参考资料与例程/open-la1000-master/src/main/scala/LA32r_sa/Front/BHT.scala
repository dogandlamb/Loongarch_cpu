package LA32r_sa.Front

import LA32r_sa.Param
import spinal.core._
import spinal.lib._

class BHT(implicit p: Param) extends Component {
  val bt_pc = in(UInt(p.isa_width.bits))
  val pc_go = in(Bool())
  val iq_go = in(Bool())
  val br = in(new BRCancel())
  val pr_cancel = in(Bool())
  val buf_cancel = in(Bool())
  val o = out(new BHTOut())
  val ramInit = in(new RAMInit())
  val bhr = if(p.use_bhr && p.bht.use_bhr) in(new BHROut()) else null
  val phr = if(p.use_phr && p.bht.use_phr) in(new PHROut()) else null
  val randVal = if(p.use_rand && p.bht.use_rand) in(UInt(p.rand_width.bits)) else null
}
