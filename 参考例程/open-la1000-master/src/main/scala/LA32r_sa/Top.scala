package LA32r_sa

import LA32r_sa.Back._
import LA32r_sa.Cache.{CacheBus, CacheOpStage, DCache, ICache}
import LA32r_sa.util._
import spinal.core._
import spinal.lib._

class Top(useDiff:Boolean = false) (implicit p: Param) extends  Component{
  val mainPipe = new PipeLine()
  val iCache = new ICache()
  val dCache = new DCache()

  val interrupt = in(Bits(8.bits))
  val dBus = master(new CacheBus()(p.dCacheParam))
  val iBus = master(new CacheBus()(p.iCacheParam))
  val diff = if(useDiff) out(new Difftest(3, p.tlbidx_width)) else null

  mainPipe.interrupt := interrupt

  mainPipe.iCache <> iCache.io.port

  mainPipe.dCache <> dCache.io.port

  mainPipe.dMSHREmpty := dCache.io.mshr_empty
  mainPipe.iMSHREmpty := iCache.io.mshr_empty//TODO: := True?
  dCache.io.llb := mainPipe.llb.llb
  mainPipe.llb.r := dCache.io.llbR
  mainPipe.llb.s := dCache.io.llbS

//  iCache.io.cacop <> mainPipe.iCacop

  val iCacopStage = new CacheOpStage(mainPipe.iCacop, iCache.io.cacop)

  dCache.io.bus <> dBus
  iCache.io.bus <> iBus

  def moveInfoWB[T <: Data](data: T) = RegNext(data.validIf(!mainPipe.wb.stall.pull()))
  def moveInfoEx2[T <: Data](data: T) = moveInfoWB(
    RegNextWhen(Mux(mainPipe.wb.cancel.cancel.pull(), data.getZero, data), !mainPipe.wb.stall.pull()).setCompositeName(data, "moveEx2")
  )
  def moveInfoEx1[T <: Data](data: T) = new Composite(data){
    val moveEx1 = Reg(data)
    when(mainPipe.ex2.cancel.pull()){
      moveEx1 := data.getZero
    }.elsewhen(!mainPipe.ex2.stall.pull()){
      when(if(p.ex2BRU) mainPipe.ex2.br.cancel.pull() else False){
        moveEx1 := data.getZero
      }.otherwise{
        moveEx1 := data
      }
    }
    val res = moveInfoEx2(moveEx1)
  }.res
  def moveInfoIS[T <: Data](data: T) = new Composite(data){
    val moveIS = Reg(data)
    when(mainPipe.ex1.cancel.pull()){
      moveIS := data.getZero
    }.elsewhen(!mainPipe.ex1.stallIn.pull() && !mainPipe.ex1.stallOut.pull()){
      when(mainPipe.ex1.br.cancel.pull()){
        moveIS := data.getZero
      }.otherwise{
        moveIS := data
      }
    }
    val res = moveInfoEx1(moveIS)
  }.res
  val inst_is = ifGen(useDiff)(Vec(HardType(new DifftestInstrCommit(p.tlbidx_width)), 3))
  val wbSel = ifGen(useDiff)(moveInfoIS(mainPipe.is.wbSel.pull()))
  val lsuCancelPos = ifGen(useDiff)(moveInfoEx2(Mux(!mainPipe.ex2.lsuCancel.pull(), U(3, 2.bits), mainPipe.ex2.ex2Reg.lsu.port.pull())))
  val bruCancelPos = ifGen(useDiff)(moveInfoEx2(Mux(!mainPipe.ex2.bruCancel.pull(), U(3, 2.bits), mainPipe.ex2.ex2Reg.bru.port.pull())))

  if(useDiff){

    inst_is zip moveInfoIS(mainPipe.is.is.pull()) foreach { case (diff, is) =>
      diff.valid := is.fire && !is.exception
      diff.pc := is.pc
      diff.instr := is.inst
      diff.is_TLBFILL := is.unit === ExUnit.TLB && is.func.tlb === TLBCode.TLBFILL
      diff.TLBFILL_index := RegNextWhen(mainPipe.tlb.tlbop.fill.fillback.l2_idx.pull(), mainPipe.tlb.io.from.rw.pull().fire)
      diff.is_CNTinst := is.unit === ExUnit.SP && (is.func.sp === SPCode.RDCNTVH || is.func.sp === SPCode.RDCNTVL) ||
        is.unit === ExUnit.CSR && is.func.csr === CSRCode.RDCNTID
      diff.timer_64_value := moveInfoIS(mainPipe.is.timer.value.pull())
      diff.wen := is.useWb
      diff.wdest := is.wbDest
      diff.csr_rstat := is.unit === ExUnit.CSR && is.func.csr =/= CSRCode.IDLE && is.inst(10 to 23) === new CsrESTAT().id
      diff.csr_data := moveInfoEx1(mainPipe.ex1.csr.data.pull())
    }
    inst_is(0).wdata := moveInfoWB(mainPipe.wb.result(0).data.pull())
    inst_is(1).wdata := moveInfoWB(Mux(wbSel(0), mainPipe.wb.result(1).data.pull(), mainPipe.wb.result(0).data.pull()))
    inst_is(2).wdata := moveInfoWB(mainPipe.wb.result(1).data.pull())

    diff.inst default inst_is
    diff.inst(0).valid := inst_is(0).valid && lsuCancelPos =/= 0
    diff.inst(1).valid := inst_is(1).valid && lsuCancelPos > 1 && bruCancelPos > 0
    diff.inst(2).valid := inst_is(2).valid && lsuCancelPos > 2 && bruCancelPos > 1

    diff.excp.excp_valid := moveInfoWB(mainPipe.wb.wbReg.info.exception.pull())
    diff.excp.eret := moveInfoWB(mainPipe.wb.wbReg.info.ertn.pull())
    diff.excp.intrNo := moveInfoWB(mainPipe.csr.estat.pull()(2 to 12))
    diff.excp.cause := moveInfoWB(mainPipe.wb.csrExcp.code.pull())
    diff.excp.exceptionPC := moveInfoWB(mainPipe.wb.csrExcp.epc.pull())
    diff.excp.exceptionInst := MuxOH(diff.inst.map(_.pc === diff.excp.exceptionPC), diff.inst.map(_.instr))

    val dCacheFired = RegInit(False).setWhen(dCache.io.port.data.fire && !dCache.io.port.cancel).clearWhen(!mainPipe.ex2.stall.pull())
    val dCacheVA = moveInfoEx2(DLatch(dCache.s1.va.pull(), dCache.io.port.data.fire))
    val dCachePA = moveInfoEx2(DLatch(dCache.s1.pa.pull(), dCache.io.port.data.fire))
    val LSValid = moveInfoEx2(dCacheFired || dCache.io.port.data.fire && !dCache.io.port.cancel)
    diff.store.valid := moveInfoEx1(Cat(B(0, 4.bits),
      mainPipe.ex1.ex1Reg.lsu.op.pull() === LSUCode.SC_W,
      mainPipe.ex1.ex1Reg.lsu.op.pull() === LSUCode.ST_W,
      mainPipe.ex1.ex1Reg.lsu.op.pull() === LSUCode.ST_H,
      mainPipe.ex1.ex1Reg.lsu.op.pull() === LSUCode.ST_B
    )) & Repeat(LSValid, 8) & ~ moveInfoEx2((~mainPipe.llb.llb.asBits << 3).resize(8))
    diff.store.storePAddr := dCachePA.resized
    diff.store.storeVAddr := dCacheVA
    val raw_data = Cat((dCache.s1.wdata.rep.pull().subdivideIn(8.bits) zip dCache.s1.wdata.strobe.pull().asBools).map{ case (d, e) => d.asBits & Repeat(e, 8)}).splitAt(32)
    diff.store.storeData := moveInfoEx2(DLatch(raw_data._1 | raw_data._2, dCache.io.port.data.fire)).resized

    diff.load.valid := moveInfoEx1(Cat(B(0, 2.bits),
      mainPipe.ex1.ex1Reg.lsu.op.pull() === LSUCode.LL_W,
      mainPipe.ex1.ex1Reg.lsu.op.pull() === LSUCode.LD_W,
      mainPipe.ex1.ex1Reg.lsu.op.pull() === LSUCode.LD_HU,
      mainPipe.ex1.ex1Reg.lsu.op.pull() === LSUCode.LD_H,
      mainPipe.ex1.ex1Reg.lsu.op.pull() === LSUCode.LD_BU,
      mainPipe.ex1.ex1Reg.lsu.op.pull() === LSUCode.LD_B
    )) & Repeat(LSValid, 8)
    diff.load.paddr := dCachePA.resized
    diff.load.vaddr := dCacheVA

    diff.csr.crmd := mainPipe.csr.crmd.pull()
    diff.csr.prmd := mainPipe.csr.prmd.pull()
    diff.csr.euen := mainPipe.csr.euen.pull()
    diff.csr.ecfg := mainPipe.csr.ecfg.pull()
    diff.csr.estat := mainPipe.csr.estat.pull()
    diff.csr.era := mainPipe.csr.era.pull()
    diff.csr.badv := mainPipe.csr.badv.pull()
    diff.csr.eentry := mainPipe.csr.eentry.pull()
    diff.csr.tlbidx := mainPipe.csr.tlbidx.pull()
    diff.csr.tlbehi := mainPipe.csr.tlbehi.pull()
    diff.csr.tlbelo0 := mainPipe.csr.tlbelo0.pull()
    diff.csr.tlbelo1 := mainPipe.csr.tlbelo1.pull()
    diff.csr.asid := mainPipe.csr.asid.pull()
    diff.csr.pgdl := mainPipe.csr.pgdl.pull()
    diff.csr.pgdh := mainPipe.csr.pgdh.pull()
    diff.csr.save0 := mainPipe.csr.save0.pull()
    diff.csr.save1 := mainPipe.csr.save1.pull()
    diff.csr.save2 := mainPipe.csr.save2.pull()
    diff.csr.save3 := mainPipe.csr.save3.pull()
    diff.csr.tid := mainPipe.csr.tid.pull()
    diff.csr.tcfg := mainPipe.csr.tcfg.pull()
    diff.csr.tval := mainPipe.csr.tval.pull()
    diff.csr.ticlr := mainPipe.csr.ticlr.pull()
    diff.csr.llbctl := mainPipe.csr.llbctl.pull()
    diff.csr.tlbrentry := mainPipe.csr.tlbrentry.pull()
    diff.csr.dmw0 := mainPipe.csr.dmw0.pull()
    diff.csr.dmw1 := mainPipe.csr.dmw1.pull()

    diff.reg.zipWithIndex.foreach{case (r, i) => r := mainPipe.reg.reg.pull()(i)}
  }
}

object GenTop {
  def main(args: Array[String]): Unit = {
    SpinalConfig(mode = Verilog).generate(new Top()(Param())).printPruned()
  }
}
