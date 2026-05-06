package LA32r_sa.Back

import LA32r_sa.Front.WBCancel
import LA32r_sa.Param
import LA32r_sa.TLB.TlbRW
import spinal.core._
import spinal.lib._

class StageWB (implicit p: Param) extends Component {
  val result = out(Vec(WbPort(), 2))
  val stallOut = out(Bool())
  val stallIn = in(Bool())
  val wb = in(EX22WB())
  val cancel = out(HardType(new WBCancel())())
  val reg = Vec(master(new RegWrite()), 2)
  val csrWR = out(new CSRWrite())
  val csrExcp = out(new CSRExcp())
  val csrLLB = out(new Bundle{
    val r, s = Bool()
  })
  val tlbRW = master(new TlbRW)
  val excpTarget = in(new CSRExcpTarget())

  val stall = stallOut || stallIn && !cancel.cancel

  val wbInit = EX22WB()
  wbInit.default(wbInit.getZero)
  wbInit.wb.foreach(_.port.finish := True)
  wbInit.tlb.op := TLBCode.IDLE

  val wbReg = RegInit(wbInit)
  //TODO: ignore Ex1 stall if Ex2 has a Exception
  when(!stall){
    when(cancel.cancel){
      wbReg := wbInit
    }.otherwise{
      wbReg := wb
    }
  }

  result := Vec(wbReg.wb.map(_.port))
  implicit val forwardAll = Vec(wbReg.wb.map(_.port).reverseIterator)
  val forwarded = EX22WB()
  ForwardData(forwarded, wbReg, 2)

  val canceled = RegInit(False).setWhen(cancel.cancel && !stallOut).clearWhen(!stall)

  cancel.default(cancel.getZero)
  cancel.cancel := (forwarded.info.exception || forwarded.info.rollback || forwarded.info.ertn) && !canceled
  cancel.target := PriorityMux(Seq(
    forwarded.info.exception -> Mux(forwarded.info.excpCode === ExcpCode.TLBR,
      excpTarget.tlbrentry.getValue(),
      excpTarget.eentry.getValue()),
    forwarded.info.rollback -> (forwarded.info.era + 4),
    forwarded.info.ertn -> excpTarget.era.pc
  ))
  cancel assignSomeByName forwarded.bru.getZero
  when(!cancel.cancel) {
    cancel assignSomeByName forwarded.bru
  }
  cancel.link_pc := Mux(forwarded.bru.wbPort, forwarded.wb.head.port.data, forwarded.wb.last.port.data).dropLow(2).asUInt

  reg zip forwarded.wb foreach{ case (r, w) =>
    r.en := True
    r.addr := w.port.dest
    r.data := w.port.data
  }

  csrWR.en := True
  csrWR.data := forwarded.csr.data.data
  csrWR.mask := forwarded.csr.mask.data
  csrWR.addr := forwarded.csr.csr

  csrExcp.exception := forwarded.info.exception
  csrExcp.eret := forwarded.info.ertn && ~forwarded.info.exception
  csrExcp.code := forwarded.info.excpCode
  csrExcp.subCode := forwarded.info.excpSubCode.lsb
  csrExcp.epc := forwarded.info.era
  csrExcp.badVAddr := forwarded.info.badv

  csrLLB.r := forwarded.llb.r
  csrLLB.s := forwarded.llb.s

  val tlbFired = RegInit(False).setWhen(tlbRW.fire).clearWhen(!stall)
  val tlbFinish = RegInit(False).setWhen(tlbRW.finish).clearWhen(!stall)
  tlbRW.valid := forwarded.tlb.op =/= TLBCode.IDLE && !tlbFired
  tlbRW.srch := forwarded.tlb.op === TLBCode.TLBSRCH
  tlbRW.rd := forwarded.tlb.op === TLBCode.TLBRD
  tlbRW.wr := forwarded.tlb.op === TLBCode.TLBWR
  tlbRW.fill := forwarded.tlb.op === TLBCode.TLBFILL
  tlbRW.inv := forwarded.tlb.op === TLBCode.INVTLB
  tlbRW.invInfo.op := forwarded.tlb.invop
  tlbRW.invInfo.va := forwarded.tlb.invVA.data
  tlbRW.invInfo.asid := forwarded.tlb.invASID.data.resized

  stallOut := forwarded.tlb.op =/= TLBCode.IDLE && !(tlbRW.finish || tlbFinish)
}

object GenStageWB {
  def main(args: Array[String]): Unit = {
    SpinalConfig(mode = Verilog).generate(new StageWB()(Param())).printPruned()
  }
}