package LA32r_sa

import LA32r_sa.Cache.{Bus2Axi, ChiplabAXI, DCacheParam, ICacheParam}
import LA32r_sa.TLB.TLBParam
import spinal.core._
import spinal.lib._

class AXITop(useDiff:Boolean = true)(implicit p: Param) extends Component {
  val interrupt = in(Bits(8.bits))
  val axi = master(new ChiplabAXI(p.PA_width, p.dCacheParam.busWidth))
  val diff = if(useDiff) out(new Difftest(3, p.tlbidx_width)) else null

  val core = new Top(useDiff)
  if(useDiff) diff := core.diff
  core.interrupt := interrupt

  val dAxi = new ChiplabAXI(p.PA_width, p.dCacheParam.busWidth)
  val iAxi = new ChiplabAXI(p.PA_width, p.dCacheParam.busWidth)

  val dTrans = new Bus2Axi(0, p.dCacheParam.lineBurst)(core.dBus, dAxi)
  val iTrans = new Bus2Axi(1, p.iCacheParam.lineBurst)(core.iBus, iAxi)

  axi.ar <> StreamArbiterFactory.lowerFirst.noLock.onArgs(dAxi.ar, iAxi.ar)
  axi.aw <> dAxi.aw.queueLowLatency(1)
  axi.w <> dAxi.w.queueLowLatency(1)
  iAxi.aw.ready := False
  iAxi.w.ready := False
  axi.r.ready := axi.r.id >> 1 === 0 & dAxi.r.ready | axi.r.id >> 1 === 1 & iAxi.r.ready
  axi.b.ready := axi.b.id >> 1 === 0 & dAxi.b.ready | axi.b.id >> 1 === 1 & iAxi.b.ready
  dAxi.r.payload := axi.r.payload
  dAxi.r.valid := axi.r.valid
  dAxi.b.payload := axi.b.payload
  dAxi.b.valid := axi.b.valid
  iAxi.r.payload := axi.r.payload
  iAxi.r.valid := axi.r.valid
  iAxi.b.payload := axi.b.payload
  iAxi.b.valid := axi.b.valid
}
object GenAXITopChipLab {
  def main(args: Array[String]): Unit = {
    SpinalConfig(mode = Verilog).generate(new AXITop(useDiff = true)(Param.chipLabParam)).printPruned()
  }
}
object GenAXITopFPGA {
  def main(args: Array[String]): Unit = {
    SpinalConfig(mode = Verilog).generate(new AXITop(useDiff = false)(Param.FPGAParam))//.printPruned()
  }
}
object GenAXITopFunc {
  def main(args: Array[String]): Unit = {
    SpinalConfig(mode = Verilog).generate(new AXITop(useDiff = true)(Param.funcParam))//.printPruned()
  }
}
object GenAXITopASIC {
  def main(args: Array[String]): Unit = {
    SpinalConfig(mode = Verilog).generate(new AXITop(useDiff = false)(Param.ASICParam))//.printPruned()
  }
}