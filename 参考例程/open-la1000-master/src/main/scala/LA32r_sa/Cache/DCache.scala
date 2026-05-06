package LA32r_sa.Cache

import LA32r_sa.Cache.MetaUtil.MatchTag
import LA32r_sa.Param
import LA32r_sa.util.DLatch
import spinal.core._
import spinal.lib._
import spinal.lib.fsm._

class DCache(p:CacheParam, pullRAM:Boolean = false) extends Component  {
  def this()(implicit p:Param){
    this(p.dCacheParam, p.pullRAMS)
  }
  implicit val param = p
  val io = new Bundle{
    val port = slave(new DCachePort(p.PABits, p.VABits, p.dataWidth))
    val mshr_empty = out(Bool())
    val llb = in(Bool())
    val llbS, llbR = out(Bool())
    val bus = master(new CacheBus())
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
    BankedRAMPortParam(p.dataWidth / p.bankWidth),
    BankedRAMPortParam(p.dataWidth / p.bankWidth),
    BankedRAMPortParam(p.busWidth / p.bankWidth),
    BankedRAMPortParam(p.busWidth / p.bankWidth),
  ))
  def S2DataPort = datum.map(_.ports(0))//w
  def S0DataPort = datum.map(_.ports(1))//r
  def ReleaseDataPort = datum.map(_.ports(2))//r
  def RefillDataPort = datum.map(_.ports(3))//w
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
    val state = MuxOH.or(way, S0MetaPort.map(_.rdata(0).state))//should be Inv(0) when tag not hit
    val info = MuxOH.or(way, S0MetaPort.map(_.rdata(0).info))
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
    import DCacheFunc._
    val s1ready = Bool()
    val begin = io.port.addr.valid && s1ready
    val va = io.port.addr.va
    val func = io.port.addr.func

    val needData = !func.noData
    val needMeta = !func.noMeta
    val s1valid = io.port.addr.valid && !probe.isActive(probe.read) && !s1replay.valid &&
      (!needMeta || S0MetaPort.map(_.fire).andR) && (!needData || S0DataPort.map(_.fire).andR)
    io.port.addr.ready := s1ready && !probe.isActive(probe.read) && !s1replay.valid &&
      (!needMeta || S0MetaPort.map(_.fire).andR) && (!needData || S0DataPort.map(_.fire).andR)
  }
  S0DataPort.foreach{port =>
    port.valid := ((s0.begin && s0.needData) || s1replay.valid) && !probe.isActive(probe.read)
    port.addr := Mux(s1replay.valid, s1replay.va, s0.va).alignData.toDataIdx
    port.wen := False
    port.wdata.assignDontCare()
  }
  S0MetaPort.foreach{port =>
    port.valid := (s0.begin && s0.needMeta) || s1replay.valid || probe.isActive(probe.read)
    port.addr := Mux(probe.isActive(probe.read), probe.index, Mux(s1replay.valid, s1replay.va, s0.va).toMetaIdx)
    port.wen := False
    port.wdata.assignDontCare()
  }

  //============S2states============
  val s2 = new Area{
    val valid = Reg(Bool())
    val dataIdx = Reg(S2DataPort.head.addr)
    def metaIdx = dataIdx.takeHigh(p.idxBits).asUInt
    val newMeta = Reg(DataMeta())
    val newData = Reg(Bits(p.dataWidth.bits))
    val way = Reg(Bits(p.nWay.bits))
  }

  //===============S1===============
  io.port.data.ready := False
  val s1 = new StateMachine{
    import DCacheFunc._
    val idle = makeInstantEntry()
    val first, hit, miss, replay, unCacheFire, unCacheWait, release = new State
    val va = Reg(UInt(p.VABits.bits))
    val (pTag, pTagReg) = DLatch.withReg(io.port.addr.pTag, RegNext(io.port.addr.fire))
    val (pa, paReg) = (pTag @@ va(0 until 12), pTagReg @@ va(0 until 12))
    val unCache = DLatch(io.port.addr.unCache, RegNext(io.port.addr.fire))
    val func = new Area{ // If timing failed, move decode to S0
      val code = Reg(DCacheFunc())
      val size = code.size
      val signed = code.signed
      val write = code.write
      val noData = code.noData
      val preop = code.preop
      val wb = code.wb
      val cacop0 = code === CACOP0
      val cacop1 = code === CACOP1
      val cacop2 = code === CACOP2
      val sc = code === SC_W
      val ll = code === LL_W
    }

    val waitMSHR = Bool()
    val releasing = Bool()
    val canReplay = Bool()
    val releaseBegin = Bool()

    val fwdMeta = s2.valid && s2.metaIdx === va.toMetaIdx && metaMatch.way === s2.way
    val fwdData = s2.valid && s2.dataIdx === va.alignData.toDataIdx && metaMatch.way === s2.way

    val metaState = Mux(fwdMeta, s2.newMeta.state, metaMatch.state)
    val rawData = DLatch(Mux(fwdData, s2.newData, metaMatch.data).asUInt, isActive(first))
    val info = RegNextWhen(Mux(fwdMeta, s2.newMeta.info, metaMatch.info), isActive(first))
    val (way, wayReg) = DLatch.withReg(metaMatch.way, isActive(first))
    val metaHit = metaState =/= DataState.I && (metaState =/= DataState.S || !func.write)
    val scFail = func.sc && !io.llb
    val cacopIdx = Mux(func.cacop2, va.toMetaIdx, va(p.offsetBits, p.idxBits.bits))
    val cacopWay = Mux(func.cacop2, wayReg, UIntToOh(va.resize(p.wayBits)))

    val unCacheResp = io.bus.unCacheOpResp.clone()
    val unCacheReq = io.bus.unCacheOpReq.clone()
    unCacheReq.valid := False

    val wdata = new Area{
      val rep = func.size.muxList((0 until 4).map(i => i -> Repeat(io.port.data.wdata.take(8<<i), p.dataWidth / (8<<i))))
      val strobe = func.size.muxList((0 until 4).map(i => i -> B((1 << (1 << i)) - 1, 8.bits))) |<< va(0 until 3)
      val result = Cat((rawData.asBits.subdivideIn(8.bits) zip rep.subdivideIn(8.bits) zip strobe.asBools).map{
        case ((o, n), s) => Mux(s, n.asBits, o)
      })
    }
    val rdata = new Area{
      val sft = Mux(isActive(unCacheWait), unCacheResp.payload.asUInt, rawData) >> (va(0 until 3) @@ U(0, 3.bits))
      val clip = Seq(8,16,32,64).map(sft.take)
      val ext = clip.map(d => Mux(func.signed, d.asSInt.resize(p.dataWidth).asUInt, d.asUInt.resize(p.dataWidth)))
      val result = Mux(func.sc, io.llb.asUInt, ext(func.size))
    }

    val missWay = DLatch(Mux(wayReg.orR, wayReg, replace.chooseWay), RegNext(isActive(first)))

    always{when(s0.s1ready && s0.s1valid){
      va := s0.va
      func.code := s0.func
      goto(first)
    }.elsewhen(io.port.data.fire || io.port.cancel){
      goto(idle)
    }}
    //idle do nothing
    first.whenIsActive{
      assert(func.code.noMeta || ((way.asUInt - 1) & way.asUInt) === 0,"DCache multiple way hit")
      when(unCache){
        when(func.noData){
          io.port.data.ready := True
          goto(hit)
        }.otherwise{
          goto(unCacheFire)
        }
      }.elsewhen(func.preop){
        io.port.data.ready := True
        goto(hit)
      }.elsewhen(func.cacop0){
        io.port.data.ready := True
        goto(hit)
      }.elsewhen(func.cacop1){
          goto(release)
      }.elsewhen(func.cacop2){
        when(metaHit){
          goto(release)
        }.otherwise{
          io.port.data.ready := True
          goto(hit)
        }
      }.otherwise{// load store
        when(metaHit && !waitMSHR && !releasing){
          io.port.data.ready := True
          goto(hit)
        }.elsewhen(canReplay){
          goto(replay)
        }.otherwise{
          goto(miss)
        }
      }
    }
    hit.whenIsActive{ io.port.data.ready := True }
    miss.whenIsActive{ when(canReplay){ goto(replay) }}//TODO: do read when can replay?
    val probe_read = probe.isActive(probe.read)
    replay.whenIsActive{
      when(!probe_read && S0MetaPort.map(_.fire).andR && S0DataPort.map(_.fire).andR){
        goto(first)
      }
    }
    unCacheFire.whenIsActive{
      unCacheReq.valid := io.port.data.valid && !io.port.cancel
      when(unCacheReq.fire){
        goto(unCacheWait)
      }
    }
    unCacheWait.whenIsActive{
      io.port.data.ready := unCacheResp.valid
      assert(io.port.data.valid)
    }
    release.whenIsActive{
      when(releaseBegin){
        goto(hit)
      }
    }

  }
  metaMatch.tag := Mux(probe.isActive(probe.buf), probe.req.addr.Tag, s1.pa.Tag)
  s0.s1ready := s1.isActive(s1.idle) || io.port.cancelFast || io.port.data.fire
  s1replay.va := s1.va
  s1replay.valid := s1.isActive(s1.replay)
  s1.unCacheReq >-> io.bus.unCacheOpReq
  io.bus.unCacheOpResp >-> s1.unCacheResp
  s1.unCacheResp.ready := True
  s1.unCacheReq.addr := s1.pa
  s1.unCacheReq.wen := s1.func.write
  s1.unCacheReq.wdata := s1.wdata.result
  s1.unCacheReq.wstrb := s1.wdata.strobe
  s1.unCacheReq.size := s1.func.size
  io.port.data.rdata := s1.rdata.result

  //===============S2===============
  when(io.port.data.fire && !io.port.cancel && (s1.func.write && !s1.scFail && !s1.func.preop || s1.func.cacop0)){
    s2.valid := True
    when(s1.func.cacop0){
      s2.dataIdx := (s1.va(p.offsetBits, p.idxBits.bits) << p.lgnBank).resized
      s2.way := UIntToOh(s1.va.resize(p.wayBits))
      s2.newMeta := DataMeta().getZero
    }.otherwise{
      s2.dataIdx := s1.va.alignData.toDataIdx
      s2.way := s1.way
      s2.newMeta.tag := s1.pa.Tag
      s2.newMeta.info := s1.info
      s2.newMeta.state := DataState.M
      s2.newData := s1.wdata.result
    }
  }.otherwise{//S2 has priority 0, no stall
    s2.valid := False
  }
  (S2DataPort zip s2.way.asBools).foreach{case (port, sel) =>
    port.valid := s2.valid & sel
    port.addr := s2.dataIdx
    port.wen := True
    port.wdata assignFromBits s2.newData
  }
  (S2MetaPort zip s2.way.asBools).foreach{case (port, sel) =>
    port.valid := s2.valid & sel
    port.addr := s2.metaIdx
    port.wen := True
    port.wdata(0) := s2.newMeta
  }

  //============prefetch============
  val prefetch = new Area{
    val valid = RegInit(False)
    val first = RegInit(False)
    val addr = Reg(UInt(p.PABits.bits))
    val pageColor = Reg(UInt(p.pageColorBits.bits))
    val toE, isS = Reg(Bool())
    val way = DLatch(s1.missWay, first)
    val mshrReceive = Bool()

    when(mshrReceive || s1.isActive(s1.first) && s1.func.wb || io.port.cancel){
      valid := False
      first := False
    }.elsewhen(s1.isActive(s1.first) && !s1.metaHit && !s1.waitMSHR && !s1.unCache && s1.func.preop){
      first := True
      addr := s1.pa.alignBus
      pageColor := s1.va.pageColor
      toE := s1.func.write
      isS := metaMatch.way.orR
    }.otherwise{
      valid := first | valid
      first := False
    }
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
    val release, acquire, refill = new State
    val metaWrote = Reg(Bool())
    val addr = Reg(UInt(p.PABits.bits))
    val pageColor = Reg(UInt(p.pageColorBits.bits))
    val index = addr.toIndex(pageColor)
    val way = Reg(Bits(p.nWay.bits))
    val toE, isS = Reg(Bool())
    val refillMask = RegInit(B(0, p.lineBurst.bits))
    val refillMaskNext = Mux(refillMask.orR, refillMask | Cat(refillMask.dropHigh(1), refillMask.takeHigh(1)),
      !io.bus.grant.hasData ? Repeat(True, p.lineBurst) |
        (U(1, p.lineBurst.bits) |<< addr(p.busOffsetBits until p.offsetBits)).asBits
    )
    val newMeta = Reg(DataMeta())

    val upgrade = s1.wayReg.orR
    val releaseBegin = Bool()
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
        addr := s1.paReg.alignData.alignBus
        pageColor := s1.va.pageColor
        way := s1.missWay
        toE := s1.func.write
        isS := upgrade
        refillMask := 0
        when(s1.paReg.lineAddr === prefetch.addr.lineAddr){
          prefetch.mshrReceive := True
        }
        when(upgrade){
          goto(acquire)
        }.otherwise{
          goto(release)
        }
      }.elsewhen(prefetch.valid){
        addr := prefetch.addr
        pageColor := prefetch.pageColor
        way := prefetch.way
        toE := prefetch.toE
        isS := prefetch.isS
        refillMask := 0
        prefetch.mshrReceive := True
        when(prefetch.isS){
          goto(acquire)
        }.otherwise{
          goto(release)
        }
      }
    }
    release.whenIsActive{
      when(releaseBegin){
        goto(acquire)
      }
    }
    acquire.whenIsActive{
      acquireBus.valid := !releasing
      acquireBus.addr := addr
      acquireBus.pageColor := pageColor
      acquireBus.toE := toE
      acquireBus.isS := isS
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
  val s1AccessBits = B((1 << (p.dataWidth/p.busWidth max 1)) - 1, p.lineBurst.bits)
  val s1AccessBitsShift = s1AccessBits |<< s1.va.alignData(p.busOffsetBits until p.offsetBits)
  val s1hitMSHR = !mshr.isActive(mshr.idle) && s1.pa.Tag === mshr.addr.Tag &&
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
//  ReleaseDataPort.foreach{port =>
//    port.valid := False
//    port.addr.assignDontCare()
//    port.wen.assignDontCare()
//    port.wdata.assignDontCare()
//  }
  val release = new StateMachine{
    object Src extends SpinalEnum(binarySequential){
      val none, probe, cacop, mshr = newElement()
    }

    val readMeta = makeInstantEntry()
    val releaseFirst, releaseRest, ack = new State

    val buffer = Reg(Vec(Bits(p.busWidth.bits), p.lineBurst))
    val readCounter = Reg(UInt(log2Up(p.lineBurst).bits))
    val readDone, metaWrote = Reg(Bool())
    val wbCounter = Reg(UInt(log2Up(p.lineBurst).bits))
    val indexReg = Reg(UInt(p.idxBits.bits))
    val wayReg = Reg(Bits(p.nWay.bits))
    val srcReg = Reg(Src())
    val toS = Reg(Bool())
    val offset = Reg(UInt(log2Up(p.lineBurst).bits))


    val metaRead = ReleaseMetaReadPort.map(_.fire).reduce(_|_)
    val metaWrite = ReleaseMetaWritePort.map(_.fire).reduce(_|_)
    val dataRead = ReleaseDataPort.map(_.fire).reduce(_|_)

    val releaseBus = io.bus.release.clone()
    val releaseAckBus = io.bus.releaseAck.clone()
    releaseBus.valid := False
    releaseBus.payload.assignDontCare()
    releaseAckBus.ready := False

    val releasing = isActive(releaseRest) || isActive(ack)

    val fromProbe = probe.isActive(probe.release)
    val fromCacop = s1.isActive(s1.release)
    val fromMSHR = mshr.isActive(mshr.release)
    val src = Mux(fromProbe, Src.probe, Mux(fromCacop, Src.cacop, Mux(fromMSHR, Src.mshr, Src.none)))
    val way = Mux(fromProbe, probe.way, Mux(fromCacop, s1.cacopWay, mshr.way))
    val index = Mux(fromProbe, probe.index, Mux(fromCacop, s1.cacopIdx, mshr.index))
    val refilling = mshr.isActive(mshr.refill) && mshr.refillMask.orR && way === mshr.way && index === mshr.index
    val writing = s2.valid && s2.way === way && s2.metaIdx === index || s1.isActive(s1.hit) && s1.wayReg === way && s1.va.toMetaIdx === index
    val srcChange = src =/= srcReg
    val releaseNothing = !way.orR && fromProbe
    val hasData = DLatch(MuxOH.or(way, ReleaseMetaReadPort.map(_.rdata(0).state)) === DataState.M || srcReg === Src.probe && probe.req.needData, RegNext(metaRead && isActive(readMeta)))
    val (tag, tagReg) = DLatch.withReg(MuxOH.or(way, ReleaseMetaReadPort.map(_.rdata(0).tag)), RegNext(metaRead && isActive(readMeta)))
    val info = DLatch(MuxOH.or(way, ReleaseMetaReadPort.map(_.rdata(0).info)), RegNext(metaRead && isActive(readMeta)))

    val readCounterNext = readCounter + 1
    val dataAvailable = RegNext(dataRead)
    val data = MuxOH.or(wayReg, ReleaseDataPort.map(_.rdata)).asBits

    probe.releaseBegin := False
    s1.releaseBegin := False
    mshr.releaseBegin := False

    //here we judge if the line to be access is releasing
    s1.releasing := releasing && s1.way === wayReg && s1.va.toMetaIdx === indexReg
    //thanks to offset, we don't have the judge by line, but still have to judge by addr
    mshr.releasing := releasing && mshr.addr.lineAddr === (tagReg @@ (indexReg @@ offset << p.busOffsetBits)(0 until p.piBits)).lineAddr//TODO: better judge?

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
        toS := fromProbe && probe.req.toS//|| fromCacop && s1.func.code === DCacheFunc.PROBE_S
        offset := Mux(src === Src.mshr, mshr.addr(p.busOffsetBits until p.offsetBits), U(0))
        goto(releaseFirst)
      }
    }
    releaseFirst.whenIsActive{
      when(refilling || writing || srcChange){
        goto(readMeta)
      }.otherwise{
        releaseBus.valid := !readCounter.andR || readDone || !hasData
        releaseBus.addr := tag @@ (index @@ offset << p.busOffsetBits)(0 until p.piBits)
        releaseBus.info := info
        releaseBus.data := Mux(dataAvailable && !readCounter.orR, data, buffer(0))
        releaseBus.hasData := hasData
        releaseBus.toS := toS
        releaseBus.probeAck := srcReg === Src.probe
        when(releaseBus.fire){
          probe.releaseBegin := srcReg === Src.probe
          s1.releaseBegin := srcReg === Src.cacop
          mshr.releaseBegin := srcReg === Src.mshr
          metaWrote := False
          when(hasData){
            wbCounter := 1
            goto(releaseRest)
          }.otherwise{
            goto(ack)
          }
        }
      }
    }

    (ReleaseDataPort zip wayReg.asBools).foreach{case (port,sel) =>
      port.valid := sel & !readDone & !isActive(readMeta) & !(isActive(releaseFirst) && (refilling || writing || srcChange))
      port.addr := indexReg @@ ((readCounterNext + offset) << (p.busOffsetBits - p.bankOffsetBits))
      port.wen := False
      port.wdata.assignDontCare()
    }
    when(dataAvailable){
      buffer(readCounter) := data
    }
    when(!releasing && (refilling || writing || srcChange)){
      readCounter.setAll()
      readDone := False
    }.elsewhen(isActive(releaseFirst) && !hasData){
      readDone := True
    }.elsewhen(dataRead){
      readCounter := readCounterNext
      when(readCounterNext.andR){
        readDone := True
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

    releaseRest.whenIsActive{
      releaseBus.valid := wbCounter <= readCounter
      releaseBus.addr := tag @@ (indexReg @@ (wbCounter + offset) << p.busOffsetBits)(0 until p.piBits)
      releaseBus.info := info
      releaseBus.data := Mux(dataAvailable && wbCounter === readCounter, data, buffer(wbCounter))
      releaseBus.hasData := hasData
      releaseBus.toS := toS
      releaseBus.probeAck := srcReg === Src.probe
      updateMeta()
      when(releaseBus.fire){
        wbCounter := wbCounter + 1
        when(wbCounter.andR){
          goto(ack)
        }
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

  val llAddr = RegNextWhen(io.port.addr.pTag.lineAddr, io.port.data.fire & s1.func.ll)
  io.llbS := io.port.data.fire & !io.port.cancel & s1.func.ll
  io.llbR := io.port.data.fire & !io.port.cancel & s1.func.sc ||
    probe.req.addr.lineAddr === llAddr & probe.req.clearLLB & probe.releaseBegin

  replace.access := s1.isActive(s1.first) && !s1.func.noData
  replace.accessIdx := s1.va.toMetaIdx
  replace.accessWay := s1.way

  io.mshr_empty := mshr.isActive(mshr.idle) && release.isActive(release.readMeta)
  replace.stateRAM.deploy()

}

object DCacheFunc extends SpinalEnum{
  val LD_BU, LD_HU, LD_WU, LD_DU,
  LD_B, LD_H, LD_W, LD_D,
  ST_B, ST_H, ST_W, ST_D,
  PRELD, PREST, LL_W, SC_W,
  CACOP0, CACOP1, CACOP2,NOP = newElement()
  defaultEncoding = SpinalEnumEncoding("staticEncoding")(
    ST_B  -> 0x0, ST_H  -> 0x1, ST_W  -> 0x2, ST_D  -> 0x3,

    LD_BU -> 0x8, LD_HU -> 0x9, LD_WU -> 0xa, LD_DU -> 0xb,
    LD_B  -> 0xc, LD_H  -> 0xd, LD_W  -> 0xe, LD_D  -> 0xf,
    PREST -> 0x10,              SC_W  -> 0x12,
    PRELD -> 0x14,              LL_W  -> 0x16,

    CACOP0 -> 0x1c, CACOP1 -> 0x1d,  CACOP2 -> 0x1e, NOP -> 0x1f,
  )
  implicit class FuncAttr(func:C){
    def write = func.asBits(3 to 4) === 0 || func.asBits(2 to 4) === 4
    def preop = func.asBits(3 to 4) === 2 && !func.asBits(1)
    def noData = func.asBits(3 to 4) === 3 || preop
    def noMeta = func === CACOP0 || func === CACOP1
    def wb = Seq(CACOP1, CACOP2).map(func === _).orR
    def size = (func.asBits(0 to 1) & Repeat(!noData,2)).asUInt
    def signed = func.asBits(2)
  }
}

class DCachePort(PAW:Int = 32, VAW:Int = 32, DW:Int = 32) extends Bundle with IMasterSlave {
  val addr = new DCacheAddr(PAW, VAW)
  val data = new DCacheData(DW)
  val cancelSlow = Bool()
  val cancelFast = Bool()
  def cancel = cancelSlow | cancelFast

  override def asMaster(): Unit = {
    master(addr, data)
    out(cancelSlow, cancelFast)
  }
  def this(p:CacheParam){
    this(p.PABits, p.VABits, p.dataWidth)
  }
}

class DCacheAddr(PAW:Int = 32, VAW:Int = 32) extends Bundle with IMasterSlave {
  val valid, ready = Bool()
  val va = UInt(VAW.bits)
  val func = DCacheFunc()
  val pTag = UInt((PAW - 12).bits)//delay 1 cycle
  val unCache = Bool()//delay 1 cycle

  override def asMaster(): Unit = {
    out(this)
    in(ready)
  }
  def fire = (valid & ready).setCompositeName(this, "fire", weak = true)
}

class DCacheData(DW:Int = 32)extends Bundle with IMasterSlave{
  val valid, ready = Bool()//if not cancel, should raise valid and hold
  val rdata, wdata = UInt(DW.bits)

  override def asMaster(): Unit = {
    in(ready, rdata)
    out(valid, wdata)
  }
  def fire = (valid & ready).setCompositeName(this, "fire", weak = true)
}

object GenDCache {
  def main(args: Array[String]): Unit = {
    SpinalConfig(mode = Verilog).generate(new DCache(DCacheParam())).printPruned()
  }
}