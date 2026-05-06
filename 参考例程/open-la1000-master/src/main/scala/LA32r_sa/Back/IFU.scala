package LA32r_sa.Back

import LA32r_sa.Cache.ICachePort
import LA32r_sa.Param
import LA32r_sa.TLB._
import LA32r_sa.util.DLatch
import spinal.core._
import spinal.lib._
import spinal.lib.fsm._

class IFU(implicit p: Param) extends Component {
  //inst fetch unit
  val front = slave(new LA32r_sa.Front.ICacheInterface())
  val iCache = master(new ICachePort(p.iCacheParam))
  val l1TLBReq = master(Stream(new AddrTransReq(ReqType.fetch)))
  val l1TLBResp = in(new AddrTransResp(p.ppn_width))
  val l2TLBReq = master(Stream(new L2TLBSrchFet()))
  val l2TLBResp = slave(Flow(new L2TLBRespFet()))

  val s2Ready = Bool()
  val s1 = new Area{
    val fire = iCache.req.fire
//    val busy = RegInit(False).setWhen(front.req && front.addr_ok).clearWhen(front.cancel || fire & s2Ready)
//    val valid = busy || front.req
    val valid = front.req
//    val va = DLatch(front.addr, front.req && front.addr_ok)
    val va = front.addr
    val cancel = RegNext(front.cancel)
  }
  //S2
  val s2Replay = Bool()
  val s2 = new StateMachine{
    val idle = makeInstantEntry()
    val first, refillFirst, refillWait, replay, second, excp = new State()
    val badVA = Reg(UInt(p.isa_width.bits))
    val excpCode = Reg(UInt(ExcpCode.codeWidth.bits))
    l2TLBReq.valid := isActive(refillFirst) && !front.cancel
    l2TLBReq.vppn := badVA.dropLow(12).asUInt
    always{when(front.cancel){
      goto(idle)
    }}
    idle.whenIsActive{
      when(s1.fire){
        badVA := l1TLBReq.va
        goto(first)
      }
    }
    first.whenIsActive{
      when(front.valid && s1.fire){
        badVA := l1TLBReq.va
      }.elsewhen(l1TLBResp.ex){
        excpCode := l1TLBResp.ecode
        goto(excp)
      }.elsewhen(!l1TLBResp.hit){
        goto(refillFirst)
      }.otherwise{
        goto(idle)
      }
    }
    refillFirst.whenIsActive{
      when(l2TLBReq.fire){
        goto(refillWait)
      }
    }
    refillWait.whenIsActive{
      when(l2TLBResp.valid){
        when(l2TLBResp.hit){
          when(iCache.req.fire){
            goto(second)
          }.otherwise{
            goto(replay)
          }
        }.otherwise{
          excpCode := ExcpCode.TLBR.asUInt
          goto(excp)
        }
      }
    }
    replay.whenIsActive{
      when(iCache.req.fire){
        goto(second)
      }
    }
    second.whenIsActive{
      assert(l1TLBResp.hit)
      when(front.valid && s1.fire){
        badVA := l1TLBReq.va
        goto(first)
      }.elsewhen(l1TLBResp.ex){
        excpCode := l1TLBResp.ecode
        goto(excp)
      }.otherwise{
        goto(idle)
      }
    }
    excp.whenIsActive{
      goto(idle)
    }

    val cancel = (isActive(first) || isActive(second)) && (l1TLBResp.ex || !l1TLBResp.hit)
    s2Ready := front.valid || isActive(idle)
    s2Replay := isActive(replay) || isActive(refillWait) && l2TLBResp.valid && l2TLBResp.hit
  }
//  front.addr_ok := !s1.busy && (s2.isActive(s2.idle) || iCache.resp.fire)
  front.addr_ok := iCache.req.ready && (s2.isActive(s2.idle) || front.valid)
  front.valid := iCache.resp.fire && !s2.cancel && !s1.cancel && !s2.isActive(s2.refillFirst) && !s2.isActive(s2.refillWait) || s2.isActive(s2.excp)
  front.count := iCache.resp.count
  front.unCache := iCache.resp.unCache
  front.rdata := iCache.resp.rdata.asBits
  front.exception := s2.isActive(s2.excp)
  front.excpCode := s2.excpCode.asBits

  iCache.req.valid := s1.valid && (s2.isActive(s2.idle) || iCache.resp.fire) || s2Replay
  iCache.req.va := Mux(s2Replay, s2.badVA, s1.va)
  iCache.req.pa := l1TLBResp.pt @@ s2.badVA(0 until 12)
  iCache.req.unCache := l1TLBResp.mat === 0
  iCache.cancel := s2Replay || s2.cancel || s1.cancel

  iCache.resp.ready := True

  l1TLBReq.valid := s1.valid || s2Replay
  l1TLBReq.va := Mux(s2Replay, s2.badVA, s1.va)
}
