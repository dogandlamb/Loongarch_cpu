package LA32r_sa

import LA32r_sa.Back.{CSRCache, CsrFile, Dividor, IFU, LSU, MUL, RegFile, StageDE, StageEX1, StageEX2, StageIS, StageWB}
import LA32r_sa.Cache.{DCachePort, ICacheCacop, ICachePort}
import LA32r_sa.TLB.{AddrTrans, AddrTransConfig, L2TLB, ReqType}
import spinal.core._
import spinal.lib._

class PipeLine (implicit p: Param) extends Component {
  //TODO: remake front
  val front = new Front.Front()
  val de = new StageDE()
  val is = new StageIS()
  val ex1 = new StageEX1()
  val ex2 = new StageEX2()
  val wb = new StageWB()
  val reg = new RegFile(6,2)
  val mul = new MUL()
  val div = new Dividor()
  val lsu = new LSU()
  val ifu = new IFU()
  val csr = new CsrFile()
  val iTrans = new AddrTrans(p.tlbParam, AddrTransConfig(1, ReqType.fetch))
  val dTrans = new AddrTrans(p.tlbParam, AddrTransConfig(1, ReqType.data))
  val tlb = new L2TLB(p.tlbParam, p.pullRAMS)

  val interrupt = in(Bits(8.bits))

  val iCache = master(new ICachePort(p.iCacheParam))
  val dCache = master(new DCachePort(p.dCacheParam))
  val iCacop = master(new ICacheCacop(p.iCacheParam))
  val dMSHREmpty, iMSHREmpty = in(Bool())
  val llb = master(new CSRCache())

  front.pc_init := U(0x1c000000)
  val br = HardType(new Front.BRCancel())()
  if(p.ex2BRU) when(ex2.br.cancel){ br := ex2.br }.otherwise{ br := ex1.br } else br := ex1.br
  front.br := (if(p.cancelStage) RegNext(br) else br)
  front.wb := (if(p.cancelStage) RegNext(wb.cancel) else wb.cancel)
  front.inst <> ifu.front

  de.front <> front.o
  de.cancel := front.br.cancel || front.wb.cancel || br.cancel || wb.cancel.cancel
  de.plv := (if(p.csrStage) RegNext(csr.isaStat.crmd_plv === 0) else csr.isaStat.crmd_plv === 0)

  is.is <> de.is
  is.wbCancel := wb.cancel.cancel
  is.ex1Cancel := ex1.br.cancel
  is.ex2Cancel := (if(p.ex2BRU) ex2.br.cancel else False)
  is.ex1SBCancel := ex1.SBCancel
  is.ex2SBCancel := (if(p.ex2BRU) ex2.SBCancel else B(0))
  is.interrupt := csr.int
  is.stall := ex1.stallOut || ex2.stallOut || wb.stallOut
  is.mshrEmpty := dMSHREmpty && iMSHREmpty
  is.reg <> reg.r

  ex1.forward := Vec(ex2.result.reverseIterator ++ wb.result.reverseIterator)
  ex1.cancel := wb.cancel.cancel || (if(p.ex2BRU) ex2.br.cancel else False)
  ex1.stallIn := ex2.stallOut || wb.stallOut
  ex1.ex1 := is.ex1
  mul.mulI <> ex1.mul
  div.io.i <> ex1.div
  csr.r <> ex1.csr

  ex2.forward := Vec(wb.result.reverseIterator)
  ex2.cancel := wb.cancel.cancel
  ex2.stallIn := ex1.stallOut || wb.stallOut
  ex2.ex2 := ex1.ex2
  ex2.mul <> mul.mulO
  ex2.div <> div.io.o
  ex2.llbR := llb.r
  ex2.llbS := llb.s
  div.io.cancel := ex2.divCancel

  wb.wb := ex2.wb
  wb.reg <> reg.w
  wb.excpTarget := (if(p.csrStage) RegNext(csr.excpTarget) else csr.excpTarget)
  wb.stallIn := ex1.stallOut || ex2.stallOut
  csr.w <> wb.csrWR
  tlb.io.from.rw <> wb.tlbRW



  lsu.ex1 <> ex1.lsu
  lsu.ex2 <> ex2.lsu
  lsu.l1TLBReq <> dTrans.io.from.request.head
  lsu.l1TLBResp <> dTrans.io.to.response.head
  lsu.l2TLBReq <> tlb.io.from.data_srch
  lsu.l2TLBResp <> tlb.io.to.data.resp
  lsu.l2TLBWillResp <> tlb.io.to.data.will_resp
  lsu.dCache <> dCache
  lsu.iCacop <> iCacop.req
  lsu.iResp <> iCacop.resp
  lsu.iCancel <> iCacop.cancel
  //TODO: L2 cache
  val sCacopDone = RegInit(False).clearWhen(lsu.sResp.ready || lsu.sCancel).setWhen(lsu.sCacop.valid)
  lsu.sCacop.ready := True
  lsu.sResp.valid := sCacopDone

  ifu.iCache <> iCache
  ifu.l1TLBReq <> iTrans.io.from.request.head
  ifu.l1TLBResp <> iTrans.io.to.response.head
  ifu.l2TLBReq <> tlb.io.from.fet_srch
  ifu.l2TLBResp <> tlb.io.to.fe.resp

  csr.tlbrd := tlb.io.to.rd
  csr.tlbsrch := tlb.io.to.srch
  csr.cache assignSomeByName wb.csrLLB
  csr.excp := wb.csrExcp
  csr.core.intr := (if(p.intStage) RegNext(interrupt.asUInt) else interrupt.asUInt)
  csr.core.id := p.core_id
  //TODO: IPI
  csr.core.ipi := False

  iTrans.io.from.csr := (if(p.csrStage) RegNext(csr.csr2tlb) else csr.csr2tlb)
  iTrans.io.from.l2_tlb <> tlb.io.to.fe.l1_tlb

  dTrans.io.from.csr := csr.csr2tlb
  dTrans.io.from.l2_tlb <> tlb.io.to.data.l1_tlb

  tlb.io.csr := (if(p.csrStage) RegNext(csr.csr2tlb) else csr.csr2tlb)
  tlb.io.core_control.br.cancel := front.br.cancel
  tlb.io.core_control.ex.cancel := front.wb.cancel

  llb.llb := csr.cache.llb

//  assert(is.scoreBoard(0).dest.pull() === ex1.forwarded.wb(1).port.dest.pull())
//  assert(is.scoreBoard(1).dest.pull() === ex1.forwarded.wb(0).port.dest.pull())
//  assert(is.scoreBoard(2).dest.pull() === ex2.forwarded.wb(1).port.dest.pull())
//  assert(is.scoreBoard(3).dest.pull() === ex2.forwarded.wb(0).port.dest.pull())
}

object GenPipeLine {
  def main(args: Array[String]): Unit = {
    SpinalConfig(mode = Verilog, removePruned = true).generate(new PipeLine()(Param())).printPruned()
  }
}