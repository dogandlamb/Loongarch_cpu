package LA32r_sa.Back

import LA32r_sa.Cache.{CacopReq, DCacheFunc, DCachePort}
import LA32r_sa.Param
import LA32r_sa.TLB._
import LA32r_sa.util.DLatch
import spinal.core._
import spinal.lib._
import spinal.lib.fsm._

class LSUex1(VAW:Int = 32) extends Bundle{
  val op = LSUCode()
  val base, offset = in(UInt(VAW.bits))
  val cacop = UInt(5.bits)
  val cancel = Bool()
}

class LSUex2(dataW:Int = 64, VAW:Int = 32) extends Bundle with IMasterSlave {
  val valid = Bool()
  val ready = Bool()
  val wdata = UInt(dataW.bits)
  val rdata = UInt(dataW.bits)
  val exception = Bool()
  val excpCode = UInt(ExcpCode.codeWidth.bits)
  val excpSubCode = UInt(ExcpCode.subCodeWidth.bits)
  val badVA = UInt(VAW.bits)
  val cancel = Bool()

  def fire = (ready & valid).setCompositeName(this, "fire", true)
  def asMaster(): Unit = {
    in(this)
    out(valid, wdata, cancel)
  }
  def result = {
    val res = HardType(new Bundle{
      val rdata = UInt(dataW.bits)
      val exception = Bool()
      val excpCode = UInt(ExcpCode.codeWidth.bits)
      val excpSubCode = UInt(ExcpCode.subCodeWidth.bits)
      val badVA = UInt(VAW.bits)
    })()
    res assignSomeByName this
    res
  }
}

class LSU(PAW:Int, dataW:Int = 64, VAW:Int = 32) extends Component {
  def this()(implicit p:Param){ this(p.PA_width, p.dataWidth, p.isa_width) }
  val ex1 = slave(Stream(new LSUex1(VAW)))
  val ex2 = slave(new LSUex2(dataW, VAW))
  val l1TLBReq = master(Stream(new AddrTransReq(ReqType.data)))
  val l1TLBResp = in(new AddrTransResp(PAW - 12))
  val l2TLBReq = master(Stream(new L2TLBSrchData()))
  val l2TLBResp = slave(Flow(new L2TLBRespMem(PAW - 12)))
  val l2TLBWillResp = in(Bool())
  val dCache = master(new DCachePort(PAW, VAW, dataW))
  val sCacop, iCacop = master(Stream(new CacopReq(PAW, VAW)))
  val iResp, sResp = slave(Stream(new Bundle{}))
  val iCancel, sCancel = out(Bool())

  val s1Ready = Bool()
  //this sucks, should just use 1 fsm
  //S0
  val s0 = new Area{
    import LSUCode._
    val fire = dCache.addr.fire || iCacop.fire || sCacop.fire
    val busy = RegInit(False).clearWhen(ex2.cancel).setWhen(ex1.fire && !ex1.cancel).clearWhen(fire & s1Ready)
    val cancel = RegNext(ex1.fire && fire && ex1.cancel)
    val valid = busy || ex1.valid
    // cut ready backpressure path
    val op = DLatch(ex1.op, ex1.fire)
    val va = DLatch(ex1.base + ex1.offset, ex1.fire)
    val cacop = DLatch(ex1.cacop, ex1.fire)

    val noTrans = op === CACOP && !cacop.msb
    val isPre = op === PRELD
    val needS1 = valid && fire && s1Ready && !ex1.cancel
    ex1.ready := !busy
    assert(l1TLBReq.ready)
    l1TLBReq.valid := valid
    l1TLBReq.va := va
    l1TLBReq.st := op.mux(ST_B -> True, ST_H -> True, ST_W -> True, ST_D -> True, SC_W -> True, default -> False)
    l1TLBReq.size := op.mux(
      LD_H -> U(1), LD_HU -> U(1), LD_W -> U(2), LD_D -> U(3), ST_H -> U(1), ST_W -> U(2), ST_D -> U(3), LL_W -> U(2), SC_W -> U(2), default -> U(0)
    )
  }
  //S1
  val s1 = new StateMachine{
    val idle = makeInstantEntry()
    val first, l2Send, l2Wait, replayFirst, waitPipe, needCancel, fireCancel = new State()
    val badVA = Reg(UInt(VAW.bits))
    val op = Reg(LSUCode())
    val cacop = Reg(UInt(5.bits))
    val st = Reg(Bool())
    val preld = Reg(Bool())
    val exceptionReg = Reg(Bool())
    val excpCodeReg = Reg(UInt(ExcpCode.codeWidth.bits))
    val exception = Mux(isActive(first), l1TLBResp.ex, Mux(isActive(replayFirst), l2TLBResp.ex, exceptionReg))
    val excpCode = Mux(isActive(first), l1TLBResp.ecode, Mux(isActive(replayFirst), l2TLBResp.ecode, excpCodeReg))
    val isI = op === LSUCode.CACOP && cacop.take(3) === 0
    val isD = op =/= LSUCode.CACOP || cacop.take(3) === 1
    val isS = op === LSUCode.CACOP && cacop.take(3).asUInt >= 2
    def copyS1(): Unit = {
      badVA := l1TLBReq.va
      preld := s0.isPre
      st := l1TLBReq.st
      op := s0.op
      cacop := s0.cacop
      exceptionReg := False
      when(s0.noTrans){
        goto(waitPipe)
      }.otherwise{
        goto(first)
      }
    }
    val cancel = isActive(first) && (l1TLBResp.ex || !l1TLBResp.hit) || isActive(replayFirst) && l2TLBResp.ex || isActive(fireCancel)
    val replay = isActive(l2Wait) && l2TLBWillResp
    s1Ready := ex2.fire || isActive(idle) || isActive(fireCancel) //|| ex2.cancel && !replay
    l2TLBReq.valid := isActive(l2Send) && !ex2.cancel
    l2TLBReq.st := st
    l2TLBReq.vppn := badVA.dropLow(12).asUInt
    always{when(ex2.cancel){
      //when there's only one req in LSU and ex2 want cancel, cancel the req at s0
      when(isActive(idle) && s0.fire || replay){
        goto(fireCancel)
      }.elsewhen(s0.needS1){
        copyS1()
      }.otherwise{
        goto(idle)
      }
    }}
    idle.whenIsActive{
      when(s0.needS1){
        copyS1()
      }
    }
    first.whenIsActive{
      when(ex2.fire && s0.needS1){
        copyS1()
      }.elsewhen(ex2.fire){
        goto(idle)
      }.elsewhen(l1TLBResp.ex){
        exceptionReg := True
        excpCodeReg := l1TLBResp.ecode
        goto(waitPipe)
      }.elsewhen(!l1TLBResp.hit){
        goto(l2Send)
      }.otherwise{
        goto(waitPipe)
      }
    }
    l2Send.whenIsActive{
      when(l2TLBReq.fire){
        goto(l2Wait)
      }
    }
    l2Wait.whenIsActive{
      when(l2TLBWillResp){
//        assert(dCache.addr.ready)
        when(ex2.cancel){
          goto(fireCancel)
        }.otherwise{
          goto(replayFirst)
        }
      }
    }
    replayFirst.whenIsActive{
      when(ex2.fire && s0.needS1){
        copyS1()
      }.elsewhen(ex2.fire){
        goto(idle)
      }.elsewhen(l2TLBResp.ex){
        exceptionReg := True
        excpCodeReg := l2TLBResp.ecode
        goto(waitPipe)
      }.otherwise{
        goto(waitPipe)
      }
    }
    waitPipe.whenIsActive{
      when(ex2.fire && s0.needS1){
        copyS1()
      }.elsewhen(ex2.fire){
        goto(idle)
      }
    }
    needCancel.whenIsActive{
      when(s0.fire){
        goto(fireCancel)
      }
    }
    fireCancel.whenIsActive{
      when(s0.needS1){
        copyS1()
      }.otherwise{
        goto(idle)
      }
    }
  }

  dCache.cancelSlow := ex2.cancel
  dCache.cancelFast := s1.replay || s1.cancel || s0.cancel
  iCancel := ex2.cancel || s1.replay || s1.cancel || s0.cancel
  sCancel := ex2.cancel || s1.replay || s1.cancel || s0.cancel

  ex2.ready := (dCache.data.ready && s1.isD || iResp.valid && s1.isI || sResp.valid && s1.isS) &&
    !s1.cancel && !s1.isActive(s1.l2Send) && !s1.isActive(s1.l2Wait) || s1.exception
  ex2.rdata := dCache.data.rdata
  ex2.exception := s1.exception && !s1.preld
  ex2.excpCode := s1.excpCode
  ex2.excpSubCode := (s1.excpCode === ExcpCode.ADEM.asUInt) ? U(1, 3.bits) | U(0, 3.bits)
  ex2.badVA := s1.badVA

  val opSel = Mux(s1.replay, s1.op, s0.op)
  val vaSel = Mux(s1.replay, s1.badVA, s0.va)
  val cacopSel = Mux(s1.replay, s1.cacop, s0.cacop)

  //TODO: try fire req when l1 tlb miss
  dCache.addr.valid := (s0.valid && s1Ready || s1.replay) && !(opSel === LSUCode.CACOP && cacopSel.take(3) =/= 1)
  dCache.addr.va := vaSel
  dCache.addr.pTag := Mux(s1.isActive(s1.replayFirst), l2TLBResp.ptag, l1TLBResp.pt)
  dCache.addr.unCache := Mux(s1.isActive(s1.replayFirst), l2TLBResp.mat === 0, l1TLBResp.mat === 0)
  dCache.addr.func assignFromBits opSel.muxListDc(Seq(
    LSUCode.LD_B  -> DCacheFunc.LD_B.asBits,
    LSUCode.LD_BU -> DCacheFunc.LD_BU.asBits,
    LSUCode.LD_H  -> DCacheFunc.LD_H.asBits,
    LSUCode.LD_HU -> DCacheFunc.LD_HU.asBits,
    LSUCode.LD_W  -> DCacheFunc.LD_W.asBits,
    LSUCode.ST_B  -> DCacheFunc.ST_B.asBits,
    LSUCode.ST_H  -> DCacheFunc.ST_H.asBits,
    LSUCode.ST_W  -> DCacheFunc.ST_W.asBits,
    LSUCode.PRELD -> Mux(cacopSel(3), DCacheFunc.PREST.asBits, DCacheFunc.PRELD.asBits),
    LSUCode.CACOP -> cacopSel.drop(3).mux(
      0 -> DCacheFunc.CACOP0.asBits,
      1 -> DCacheFunc.CACOP1.asBits,
      2 -> DCacheFunc.CACOP2.asBits,
      3-> DCacheFunc.NOP.asBits),
    LSUCode.LL_W  -> DCacheFunc.LL_W.asBits,
    LSUCode.SC_W  -> DCacheFunc.SC_W.asBits,
    LSUCode.LD_D  -> DCacheFunc.LD_D.asBits,
    LSUCode.ST_D  -> DCacheFunc.ST_D.asBits
  ))

  dCache.data.valid := ex2.valid && !s1.isActive(s1.l2Send) && !s1.isActive(s1.l2Wait) && s1.isD
  dCache.data.wdata := ex2.wdata

  iResp.ready := ex2.valid && !s1.isActive(s1.l2Send) && !s1.isActive(s1.l2Wait) && s1.isI
  sResp.ready := ex2.valid && !s1.isActive(s1.l2Send) && !s1.isActive(s1.l2Wait) && s1.isS

  iCacop.valid := (s0.valid && s1Ready || s1.replay) && (opSel === LSUCode.CACOP && cacopSel.take(3) === 0)
  sCacop.valid := (s0.valid && s1Ready || s1.replay) && (opSel === LSUCode.CACOP && cacopSel.take(3).asUInt >= 2)

  iCacop.va := vaSel
  iCacop.code := cacopSel.drop(3).asUInt
  iCacop.pa := dCache.addr.pTag @@ UInt(12.bits).assignDontCare()
  sCacop.payload := iCacop.payload
}
