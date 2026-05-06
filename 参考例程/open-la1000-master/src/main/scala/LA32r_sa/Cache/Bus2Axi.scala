package LA32r_sa.Cache

import spinal.core._
import spinal.lib._

class Bus2Axi (id:Int, lineBurst:Int)(bus: CacheBus, axi:ChiplabAXI) extends Area {
  val axiBits = axi.w.data.getWidth
  val axiBytes = axi.w.strb.getWidth
  val unCacheBits = bus.unCacheOpReq.wdata.getWidth
  val unCacheBytes = bus.unCacheOpReq.wstrb.getWidth

  val releaseCnt = RegInit(U(0, log2Up(lineBurst).bits))
  when(bus.release.fire && bus.release.hasData){
    releaseCnt := releaseCnt + 1
  }

  val unCacheAx = axi.ar.payloadType()
  val unCacheW = axi.w.payloadType()

  unCacheAx.id := U(id * 2 + 1)
  unCacheAx.addr := bus.unCacheOpReq.addr
  unCacheAx.len := 0
  unCacheAx.size := bus.unCacheOpReq.size.resized
  unCacheAx.burst := 1
  unCacheAx.lock := 0
  unCacheAx.cache := 0
  unCacheAx.prot := 0
  unCacheW.id := U(id * 2 + 1)
  if(axiBytes <= unCacheBytes){
    assert(!(bus.unCacheOpReq.valid && bus.unCacheOpReq.wen && CountOne(bus.unCacheOpReq.wstrb) > axiBytes))
    unCacheW.data := bus.unCacheOpReq.wdata.subdivideIn(axiBits.bits)((unCacheAx.addr >> log2Up(axiBytes)).resized)
    unCacheW.strb := bus.unCacheOpReq.wstrb.subdivideIn(axiBytes.bits)((unCacheAx.addr >> log2Up(axiBytes)).resized)
  }else{
    unCacheW.data := Repeat(bus.unCacheOpReq.wdata, axiBytes / unCacheBytes)
    unCacheW.strb := B(0)
    unCacheW.strb.subdivideIn(unCacheBytes.bits)((unCacheAx.addr >> log2Up(unCacheBytes)).resized) := bus.unCacheOpReq.wstrb
  }
  unCacheW.last := True

  val cacheAR = axi.ar.payloadType()
  val cacheAW = axi.aw.payloadType()
  val cacheW = axi.w.payloadType()

  cacheAR.id := U(id * 2)
  cacheAR.addr := bus.acquire.addr
  cacheAR.len := lineBurst - 1
  cacheAR.size := log2Up(cacheW.data.getWidth / 8)
  cacheAR.burst := 2
  cacheAR.lock := 0
  cacheAR.cache := 0
  cacheAR.prot := 0

  cacheAW.id := U(id * 2)
  cacheAW.addr := bus.release.addr
  cacheAW.len := lineBurst - 1
  cacheAW.size := log2Up(cacheW.data.getWidth / 8)
  cacheAW.burst := 2
  cacheAW.lock := 0
  cacheAW.cache := 0
  cacheAW.prot := 0

  cacheW.id := U(id * 2)
  cacheW.data := bus.release.data
  cacheW.strb := ~cacheW.strb.getZero
  cacheW.last := releaseCnt.andR

  val unCacheWrite = bus.unCacheOpReq.valid && bus.unCacheOpReq.wen && bus.unCacheOpReq.wstrb.orR && releaseCnt === 0
  val unCacheRead = bus.unCacheOpReq.valid && !bus.unCacheOpReq.wen
  val unCacheWriteNone = bus.unCacheOpReq.valid && bus.unCacheOpReq.wen && bus.unCacheOpReq.wstrb === 0
  val unCacheWriteNoneReg = RegNext(unCacheWriteNone)

  axi.ar.valid := unCacheRead | bus.acquire.valid
  axi.ar.payload := Mux(unCacheRead, unCacheAx, cacheAR)
  bus.acquire.ready := axi.ar.ready && !unCacheRead

  axi.aw.valid := unCacheWrite & axi.w.ready | bus.release.valid & axi.w.ready & releaseCnt === 0 & bus.release.hasData
  axi.aw.payload assignFromBits Mux(unCacheWrite, unCacheAx.asBits, cacheAW.asBits)
  axi.w.valid := unCacheWrite & axi.aw.ready | bus.release.valid & (axi.aw.ready || releaseCnt =/= 0) & bus.release.hasData
  axi.w.payload := Mux(unCacheWrite, unCacheW, cacheW)
  bus.unCacheOpReq.ready := axi.ar.ready & unCacheRead | axi.aw.ready & axi.w.ready & unCacheWrite | unCacheWriteNone
  bus.release.ready := axi.w.ready && (axi.aw.ready || releaseCnt =/= 0) && !unCacheWrite || !bus.release.hasData

  bus.grant.valid := axi.r.valid && axi.r.id === U(id * 2)
  bus.grant.toE := True
  bus.grant.info := 0
  bus.grant.data := axi.r.data
  bus.grant.hasData := True

  bus.grantAck.ready := True

  val axiRAddr = ifGen(axiBytes > unCacheBytes)(RegNextWhen(axi.ar.addr, axi.ar.fire && unCacheRead))
  if(axiBytes <= unCacheBytes){
    bus.unCacheOpResp.payload := Repeat(axi.r.data, unCacheBytes / axiBytes)
  }else{
    bus.unCacheOpResp.payload := axi.r.data.subdivideIn(unCacheBits.bits)((axiRAddr >> log2Up(unCacheBytes)).resized)
  }
  bus.unCacheOpResp.valid := axi.r.valid && axi.r.id === U(id * 2 + 1) || axi.b.valid && axi.b.id === U(id * 2 + 1) || unCacheWriteNoneReg

  axi.r.ready := axi.r.id === U(id * 2 + 1) & bus.unCacheOpResp.ready | axi.r.id === U(id * 2) & bus.grant.ready
  axi.b.ready := !unCacheWriteNone && !unCacheWriteNoneReg &&
    (axi.b.id === U(id * 2 + 1) && bus.unCacheOpResp.ready || axi.b.id === U(id * 2) && bus.releaseAck.ready)

  bus.releaseAck.valid := axi.b.valid && axi.b.id === U(id * 2) || RegInit(False).setWhen(!bus.release.hasData && bus.release.fire).clearWhen(bus.releaseAck.fire)//RegNext(!bus.release.hasData && bus.release.fire)

  bus.probe.valid := False
  bus.probe.payload := bus.probe.payload.getZero
}
