package LA32r_sa.Cache

import LA32r_sa.Cache.MetaUtil.MatchTag
import LA32r_sa.Param
import LA32r_sa.util.DLatch
import spinal.core._
import spinal.lib._
import spinal.lib.fsm._

class ICache(p:CacheParam, pullRAM:Boolean = false) extends Component  {
  def this()(implicit p:Param){
    this(p.iCacheParam, p.pullRAMS)
  }
  implicit val param = p
  val io = new Bundle{
    val port = slave(new ICachePort(p.PABits, p.VABits, p.dataWidth))
    val cacop = slave(new ICacheCacop(p.PABits, p.VABits))
    val mshr_empty = out(Bool())
    val bus = master(new CacheBus(p.PABits, p.busWidth,32 , p.infoWidth, p.pageColorBits))
  }


  implicit class AddrConvert(addr:UInt){
    def alignData:UInt = addr & ~U((1 << p.dataOffsetBits) - 1, addr.getWidth.bits)
    def alignBus:UInt = addr & ~U((1 << p.busOffsetBits) - 1, addr.getWidth.bits)
    def toDataIdx:UInt = addr(p.bankOffsetBits until p.idxBits + p.offsetBits)
    def toMetaIdx:UInt = addr(p.offsetBits until p.idxBits + p.offsetBits)
    def Tag:UInt = addr.drop(p.piBits).asUInt
    def pageColor:UInt = addr(12, p.pageColorBits.bits)
    def lineAddr:UInt = addr.drop(p.offsetBits).asUInt
    def toIndex(pageColor:UInt):UInt = pageColor @@ addr(p.offsetBits until p.piBits)
  }

  val datum = Seq.fill(p.nWay)(new BankedRAM(p.bankIdxBits, p.lgnBank, Bits(p.bankWidth.bits), pullRAM,
    BankedRAMPortParam(p.dataWidth / p.bankWidth, p.offsetBits - p.bankOffsetBits),
    BankedRAMPortParam(p.busWidth / p.bankWidth),
  ))
  def S0DataPort = datum.map(_.ports(0))//r
  def RefillDataPort = datum.map(_.ports(1))//w
  val meta = Seq.fill(p.nWay)(new BankedRAM1W1R(p.idxBits, 0, DataMeta(), pullRAM,
    BankedRAMPortParam(1, read = false),
    BankedRAMPortParam(1, write = false),
    BankedRAMPortParam(1, read = false),
    BankedRAMPortParam(1, write = false),
    BankedRAMPortParam(1, read = false),
  ))
  def S2MetaPort = meta.map(_.ports(0))//w
  def S0MetaPort = meta.map(_.ports(1))//r
  def ReleaseMetaWritePort = meta.map(_.ports(2))//w
  def ReleaseMetaReadPort = meta.map(_.ports(3))//r
  def RefillMetaPort = meta.map(_.ports(4))//w

  val replace = new Area{
    val stateRAM = RAMPort1W1R(p.idxBits, TreeLRU(p.nWay).getBitsWidth, forward = false)
    val access = Bool()
    val accessIdx = UInt(p.idxBits.bits)
    val accessWay = Bits(p.nWay.bits) // If none accessed, it is replace, access chooseWay
    val chooseWay = stateRAM.rdata.as(TreeLRU(p.nWay)).choose

    val accessWayReg = RegNext(accessWay)
    stateRAM.ren := access
    stateRAM.raddr := accessIdx
    stateRAM.wen := RegNext(access)
    stateRAM.waddr := RegNext(accessIdx)
    stateRAM.wdata := stateRAM.rdata.as(TreeLRU(p.nWay)).access(accessWayReg.orR ? accessWayReg | chooseWay).asBits
  }

  val metaMatch = new Area{
    val tag = UInt(p.tagBits.bits)
    val way = S0MetaPort.map(_.rdata(0)).matchTag(tag).asBits
    val data = MuxOH.or(way, S0DataPort.map(x => Cat(x.rdata)))
  }
  //=============probe==============
  val probe = new StateMachine{
    val idle = makeInstantEntry()
    val read, buf, release = new State
    val req = Reg(io.bus.probe.payloadType)
    val index = req.addr.toIndex(req.pageColor)
    val way = Reg(Bits(p.nWay.bits))
    val releaseBegin = Bool()

    idle.whenIsActive{
      when(io.bus.probe.fire){
        req := io.bus.probe.payload
        goto(read)
      }
    }
    read.whenIsActive{
      when(S0MetaPort.map(_.fire).andR){
        goto(buf)
      }
    }
    buf.whenIsActive{
      way := metaMatch.way
      goto(release)
    }
    release.whenIsActive{
      when(releaseBegin){
        goto(idle)
      }
    }
  }
  io.bus.probe.ready := probe.isActive(probe.idle)

  //============S1replay============
  val s1replay = new Area{
    val valid = Bool()
    val va = UInt(p.VABits.bits)
  }

  //===============S0===============
  val s0 = new Area{
    val s1ready = Bool()
    val begin = (io.port.req.valid || io.cacop.req.valid) && s1ready
    val va = Mux(io.cacop.req.valid, io.cacop.req.va, io.port.req.va)

    val noData = io.cacop.req.valid
    val noMeta = io.cacop.req.valid && !io.cacop.req.code.msb
    val s1valid = (io.port.req.valid || io.cacop.req.valid) && !probe.isActive(probe.read) && !s1replay.valid &&
      (noMeta || S0MetaPort.map(_.fire).andR) && (noData || S0DataPort.map(_.fire).andR)
    io.port.req.ready := s1ready && !io.cacop.req.valid && !probe.isActive(probe.read) && !s1replay.valid &&
      S0MetaPort.map(_.fire).andR && S0DataPort.map(_.fire).andR
    io.cacop.req.ready := s1ready && !probe.isActive(probe.read) && !s1replay.valid &&
      (!io.cacop.req.code.msb || S0MetaPort.map(_.fire).andR)
  }
  S0DataPort.foreach{port =>
    port.valid := ((s0.begin && !s0.noData) || s1replay.valid) && !probe.isActive(probe.read)
    port.addr := Mux(s1replay.valid, s1replay.va, s0.va).toDataIdx
    port.wen := False
    port.wdata.assignDontCare()
  }
  S0MetaPort.foreach{port =>
    port.valid := (s0.begin && !s0.noMeta) || s1replay.valid || probe.isActive(probe.read)
    port.addr := Mux(probe.isActive(probe.read), probe.index, Mux(s1replay.valid, s1replay.va, s0.va).toMetaIdx)
    port.wen := False
    port.wdata.assignDontCare()
  }

  //============S2states============
  val s2 = new Area{
    val valid = Reg(Bool())
    val metaIdx = Reg(UInt(p.idxBits.bits))
    val newMeta = Reg(DataMeta())
    val way = Reg(Bits(p.nWay.bits))
  }

  //===============S1===============
  io.port.resp.valid := False
  io.cacop.resp.valid := False
  val s1 = new StateMachine{
    val idle = makeInstantEntry()
    val first, instHit, cacopHit, miss, replay, unCacheFire, unCacheWait = new State
    val func = Reg(UInt(2.bits))//cacop012, inst
    val va = Reg(UInt(p.VABits.bits))
    val (pTag, pTagReg) = DLatch.withReg(Mux(func === U(3), io.port.req.pa, io.cacop.req.pa).Tag, RegNext(io.port.req.fire))
    val (pa, paReg) = (pTag @@ va(0 until p.piBits), pTagReg @@ va(0 until p.piBits))
    val unCache = DLatch(io.port.req.unCache, RegNext(io.port.req.fire))
    val unCacheCanceled = RegInit(False)

    val waitMSHR = Bool()
    val releasing = Bool()
    val canReplay = Bool()

    val rawData = DLatch(metaMatch.data.asUInt, isActive(first))
    val (way, wayReg) = DLatch.withReg(metaMatch.way, isActive(first))
    val metaHit = way.orR
    val cacopIdx = Mux(func === 2, va.toMetaIdx, va(p.offsetBits, p.idxBits.bits))
    val cacopWay = Mux(func === 2, wayReg, UIntToOh(va.resize(p.wayBits)))

    val unCacheResp = io.bus.unCacheOpResp.clone()
    val unCacheReq = io.bus.unCacheOpReq.clone()
    unCacheReq.valid := False

    val missWay = DLatch(Mux(wayReg.orR, wayReg, replace.chooseWay), RegNext(isActive(first)))

    always{when(s0.s1ready && s0.s1valid){
      va := s0.va
      func := Mux(io.cacop.req.valid, Min(io.cacop.req.code, U(2)), U(3))
      goto(first)
    }.elsewhen(func === U(3) && (io.port.resp.fire || io.port.cancel) ||
      func =/= U(3) && (io.cacop.resp.fire || io.cacop.cancel)){
      goto(idle)
    }}
    always{when(unCacheResp.fire){
      unCacheCanceled := False
    }}
    //idle do nothing
    first.whenIsActive{
      when(func =/= U(3)){
        goto(cacopHit)
      }.elsewhen(unCache){
        unCacheReq.valid := !io.port.cancel && !unCacheCanceled
        when(unCacheReq.fire){
          goto(unCacheWait)
        }.otherwise{
          goto(unCacheFire)
        }
      }.otherwise{// load store
        when(metaHit && !waitMSHR && !releasing){
          io.port.resp.valid := True
          goto(instHit)
        }.elsewhen(canReplay){
          goto(replay)
        }.otherwise{
          goto(miss)
        }
      }
    }
    instHit.whenIsActive{ io.port.resp.valid := True }
    cacopHit.whenIsActive{ io.cacop.resp.valid := True }
    miss.whenIsActive{ when(canReplay){ goto(replay) }}
    val probe_read = probe.isActive(probe.read)
    replay.whenIsActive{
      when(!probe_read && S0MetaPort.map(_.fire).andR && S0DataPort.map(_.fire).andR){
        goto(first)
      }
    }
    unCacheFire.whenIsActive{
      unCacheReq.valid := !io.port.cancel && !unCacheCanceled
      when(unCacheReq.fire){
        goto(unCacheWait)
      }
    }
    unCacheWait.whenIsActive{
      when(io.port.cancel){
        unCacheCanceled := True
      }
      io.port.resp.valid := unCacheResp.valid && !io.port.cancel && !unCacheCanceled
      when(unCacheResp.fire){
        goto(idle)
      }
    }

    val rdata = Mux(isActive(unCacheWait), unCacheResp.payload.asUInt.resized, rawData)

  }
  metaMatch.tag := Mux(probe.isActive(probe.buf), probe.req.addr.Tag, s1.pa.Tag)
  s0.s1ready := s1.isActive(s1.idle) ||
    s1.func === U(3) && (io.port.resp.fire || io.port.cancel) ||
    s1.func =/= U(3) && (io.cacop.resp.fire || io.cacop.cancel)
  s1replay.va := s1.va
  s1replay.valid := s1.isActive(s1.replay)
  s1.unCacheReq >-> io.bus.unCacheOpReq
  io.bus.unCacheOpResp >-> s1.unCacheResp
  s1.unCacheResp.ready := True
  s1.unCacheReq.addr := s1.pa
  s1.unCacheReq.wen := False
  s1.unCacheReq.wdata.assignDontCare()
  s1.unCacheReq.wstrb.assignDontCare()
  s1.unCacheReq.size := U(2)
  io.port.resp.rdata := s1.rdata
  io.port.resp.count := Mux(s1.isActive(s1.unCacheWait), U(0), S0DataPort(0).count(s1.va.toDataIdx, p.offsetBits - p.bankOffsetBits))
  io.port.resp.unCache := s1.isActive(s1.unCacheWait)

  //===============S2===============
  when(io.cacop.resp.fire){
    s2.valid := True
    s2.metaIdx := s1.cacopIdx
    s2.way := s1.cacopWay
    s2.newMeta := DataMeta().getZero
  }.otherwise{//S2 has priority 0, no stall
    s2.valid := False
  }
  (S2MetaPort zip s2.way.asBools).foreach{case (port, sel) =>
    port.valid := s2.valid & sel
    port.addr := s2.metaIdx
    port.wen := True
    port.wdata(0) := s2.newMeta
  }

  //============prefetch============
  val prefetch = new Area{
    //TODO: ICache prefetch
    val valid = False
    val addr = UInt(p.PABits.bits).assignDontCare()
    val pageColor = UInt(p.pageColorBits.bits).assignDontCare()
    val way = Bits(p.nWay.bits).assignDontCare()
    val mshrReceive = Bool()
  }

  //==============MSHR==============
  RefillMetaPort.foreach{port =>
    port.valid := False
    port.addr.assignDontCare()
    port.wen.assignDontCare()
    port.wdata.assignDontCare()
  }
  RefillDataPort.foreach{port =>
    port.valid := False
    port.addr.assignDontCare()
    port.wen.assignDontCare()
    port.wdata.assignDontCare()
  }
  val mshr = new StateMachine{
    val idle = makeInstantEntry()
    val acquire, refill = new State
    val metaWrote = Reg(Bool())
    val addr = Reg(UInt(p.PABits.bits))
    val pageColor = Reg(UInt(p.pageColorBits.bits))
    val index = addr.toIndex(pageColor)
    val way = Reg(Bits(p.nWay.bits))
    val refillMask = RegInit(B(0, p.lineBurst.bits))
    val refillMaskNext = Mux(refillMask.orR, refillMask | Cat(refillMask.dropHigh(1), refillMask.takeHigh(1)),
      !io.bus.grant.hasData ? Repeat(True, p.lineBurst) |
        (U(1, p.lineBurst.bits) |<< addr(p.busOffsetBits until p.offsetBits)).asBits
    )
    val newMeta = Reg(DataMeta())

    val releasing = Bool()

    prefetch.mshrReceive := False

    val acquireBus = io.bus.acquire.clone()
    val grantBus = io.bus.grant.clone()
    val grantAckBus = io.bus.grantAck.clone()
    acquireBus.valid := False
    acquireBus.payload.assignDontCare()
    grantBus.ready := False
    grantAckBus.valid := False

    val s1_miss = s1.isActive(s1.miss)
    idle.whenIsActive{
      when(s1_miss){
        addr := s1.paReg.alignBus
        pageColor := s1.va.pageColor
        way := s1.missWay
        refillMask := 0
        when(s1.paReg.lineAddr === prefetch.addr.lineAddr){
          prefetch.mshrReceive := True
        }
        goto(acquire)
      }.elsewhen(prefetch.valid){
        addr := prefetch.addr
        pageColor := prefetch.pageColor
        way := prefetch.way
        refillMask := 0
        prefetch.mshrReceive := True
        goto(acquire)
      }
    }
    acquire.whenIsActive{
      acquireBus.valid := !releasing
      acquireBus.addr := addr
      acquireBus.pageColor := pageColor
      acquireBus.toE := False
      acquireBus.isS := False
      when(acquireBus.fire){
        metaWrote := False
        goto(refill)
      }
    }
    refill.whenIsActive{
      (RefillDataPort zip way.asBools).foreach{case (port, way) =>
        port.valid := way && grantBus.valid && grantBus.hasData
        port.addr := index @@ OHToUInt(refillMaskNext & ~refillMask) << (p.busOffsetBits - p.bankOffsetBits)
        port.wen := True
        port.wdata assignFromBits grantBus.data
      }
      (RefillMetaPort zip way.asBools).foreach{case (port, way) =>
        port.valid := way && refillMask.orR && !metaWrote
        port.addr := index
        port.wen := True
        port.wdata(0) := newMeta
      }
      grantBus.ready := MuxOH.or(way.asBools, RefillDataPort).ready || !grantBus.hasData
      when(grantBus.fire){
        newMeta.tag := addr.Tag
        newMeta.info := grantBus.info
        newMeta.state := grantBus.toE ? DataState.E | DataState.S
      }
      when(grantBus.fire){
        refillMask := refillMaskNext
      }
      when(MuxOH.or(way.asBools, RefillMetaPort).fire){
        metaWrote := True
      }
      grantAckBus.valid := refillMask.andR && metaWrote
      when(grantAckBus.fire){
        goto(idle)
      }
    }

  }
  //TODO: resp when we have the first inst (need change front)
  val s1AccessBits = B((1 << (p.dataWidth/p.busWidth max 1)) - 1, p.lineBurst.bits) | (s1.va.take(p.busOffsetBits).orR.asBits << (p.dataWidth/p.busWidth)).resized
  val s1AccessBitsShift = s1AccessBits |<< s1.va(p.busOffsetBits until p.offsetBits)
  val s1hitMSHR = mshr.isActive(mshr.refill) && s1.pa.Tag === mshr.addr.Tag &&
    s1.va(p.offsetBits until p.piBits) === mshr.index(0 until (p.piBits - p.offsetBits))
  s1.waitMSHR := s1hitMSHR && (s1AccessBitsShift & mshr.refillMask) =/= s1AccessBitsShift
  s1.canReplay := s1hitMSHR && mshr.metaWrote && (s1AccessBitsShift & mshr.refillMask) === s1AccessBitsShift

  mshr.acquireBus >> io.bus.acquire
  io.bus.grant >/-> mshr.grantBus
  mshr.grantAckBus >> io.bus.grantAck

  //=============release============
  ReleaseMetaReadPort.foreach{ port =>
    port.valid := False
    port.addr.assignDontCare()
    port.wen.assignDontCare()
    port.wdata.assignDontCare()
  }
  ReleaseMetaWritePort.foreach{ port =>
    port.valid := False
    port.addr.assignDontCare()
    port.wen.assignDontCare()
    port.wdata.assignDontCare()
  }
  val release = new StateMachine{
    object Src extends SpinalEnum(binarySequential){
      val none, probe = newElement()
    }

    val readMeta = makeInstantEntry()
    val releaseFirst, ack = new State

    val metaWrote = Reg(Bool())
    val indexReg = Reg(UInt(p.idxBits.bits))
    val wayReg = Reg(Bits(p.nWay.bits))
    val srcReg = Reg(Src())
    val toS = Reg(Bool())
    val offset = U(0, log2Up(p.lineBurst).bits)

    val metaRead = ReleaseMetaReadPort.map(_.fire).reduce(_|_)
    val metaWrite = ReleaseMetaWritePort.map(_.fire).reduce(_|_)

    val releaseBus = io.bus.release.clone()
    val releaseAckBus = io.bus.releaseAck.clone()
    releaseBus.valid := False
    releaseBus.payload.assignDontCare()
    releaseAckBus.ready := False

    val releasing = isActive(ack)

    val fromProbe = probe.isActive(probe.release)

    val src = Mux(fromProbe, Src.probe, Src.none)
    val way = probe.way
    val index = probe.index
    val refilling = mshr.isActive(mshr.refill) && mshr.refillMask.orR && way === mshr.way && index === mshr.index
    val writing = s2.valid && s2.way === way && s2.metaIdx === index
    val srcChange = src =/= srcReg
    val releaseNothing = !way.orR && fromProbe
    val (tag, tagReg) = DLatch.withReg(MuxOH.or(way, ReleaseMetaReadPort.map(_.rdata(0).tag)), RegNext(metaRead && isActive(readMeta)))
    val info = DLatch(MuxOH.or(way, ReleaseMetaReadPort.map(_.rdata(0).info)), RegNext(metaRead && isActive(readMeta)))

    probe.releaseBegin := False

    s1.releasing := releasing && s1.way === wayReg && s1.va.toMetaIdx === indexReg
    mshr.releasing := releasing && mshr.addr.lineAddr === (tagReg @@ (indexReg @@ offset << p.busOffsetBits)(0 until p.piBits)).lineAddr

    readMeta.whenIsActive{
      when(!refilling && src =/= Src.none){
        (ReleaseMetaReadPort zip way.asBools).foreach{case (port,sel) =>
          port.valid := sel
          port.addr := index
          port.wen := False
          port.wdata.assignDontCare()
        }
      }
      when(metaRead || releaseNothing){
        srcReg := src
        indexReg := index
        wayReg := way
        toS := fromProbe && probe.req.toS
        goto(releaseFirst)
      }
    }
    releaseFirst.whenIsActive{
      when(refilling || writing || srcChange){
        goto(readMeta)
      }.otherwise{
        releaseBus.valid := True
        releaseBus.addr := tag @@ (index @@ offset << p.busOffsetBits)(0 until p.piBits)
        releaseBus.info := info
        releaseBus.hasData := False
        releaseBus.toS := toS
        releaseBus.probeAck := srcReg === Src.probe
        when(releaseBus.fire){
          probe.releaseBegin := srcReg === Src.probe
          metaWrote := False
          goto(ack)
        }
      }
    }

    def updateMeta():Unit = {
      (ReleaseMetaWritePort zip wayReg.asBools).foreach{case (port,sel) =>
        port.valid := sel && !metaWrote
        port.addr := indexReg
        port.wen := True
        port.wdata(0).state := toS ? DataState.S | DataState.I
      }
      when(metaWrite){
        metaWrote := True
      }
    }

    ack.whenIsActive{
      releaseAckBus.ready := metaWrote && srcReg =/= Src.probe
      updateMeta()
      when(releaseAckBus.fire || srcReg === Src.probe && metaWrote){
        srcReg := Src.none
        goto(readMeta)
      }
    }
  }

  release.releaseBus >-> io.bus.release
  io.bus.releaseAck >> release.releaseAckBus

  replace.access := s1.isActive(s1.first) && s1.func === U(3)
  replace.accessIdx := s1.va.toMetaIdx
  replace.accessWay := s1.way

  io.mshr_empty := mshr.isActive(mshr.idle) && release.isActive(release.readMeta)
  replace.stateRAM.deploy()

}

class ICacheReq(PAW:Int = 32, VAW:Int = 32) extends Bundle with IMasterSlave {
  val valid, ready = Bool()
  val va = UInt(VAW.bits)
  val pa = UInt(PAW.bits)//delay 1 cycle
  val unCache = Bool()//delay 1 cycle

  override def asMaster(): Unit = {
    out(this)
    in(ready)
  }
  def fire = (valid & ready).setCompositeName(this, "fire", weak = true)
}

class ICacheResp(dataW:Int = 32)extends Bundle with IMasterSlave{
  val valid, ready = Bool()
  val rdata = UInt(dataW.bits)
  val count   = UInt(2.bits)
  val unCache = Bool()

  override def asMaster(): Unit = {
    out(valid, rdata, count, unCache)
    in(ready)
  }
  def fire = (valid & ready).setCompositeName(this, "fire", weak = true)
}

class ICachePort(PAW:Int = 32, VAW:Int = 32, dataW:Int = 32) extends Bundle with IMasterSlave {
  val req = new ICacheReq(PAW, VAW)
  val resp = new ICacheResp(dataW)
  val cancel = Bool()

  override def asMaster(): Unit = {
    master(req)
    slave(resp)
    out(cancel)
  }
  def this(p:CacheParam){
    this(p.PABits, p.VABits, p.dataWidth)
  }
}

class ICacheCacop(PAW:Int = 32, VAW:Int = 32) extends Bundle with IMasterSlave {
  val req = Stream(new CacopReq(PAW, VAW))
  val resp = Stream(new Bundle{})
  val cancel = Bool()
  override def asMaster(): Unit = {
    master(req)
    slave(resp)
    out(cancel)
  }
  def this(p:CacheParam){
    this(p.PABits, p.VABits)
  }
}

object GenICache {
  def main(args: Array[String]): Unit = {
    SpinalConfig(mode = Verilog).generate(new ICache(ICacheParam())).printPruned()
  }
}

