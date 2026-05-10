package LA32r_sa.Cache

import spinal.core._
import spinal.lib._

object DataState extends SpinalEnum {
  val M, E, S, I = newElement()
  defaultEncoding = SpinalEnumEncoding("StateEncode")(
    M -> 3,
    E -> 2,
    S -> 1,
    I -> 0
  )
}

class DataMeta(tagBits:Int, infoBits:Int) extends Bundle{
  val state = DataState()
  val tag = UInt(tagBits.bits)
  val info = Bits(infoBits.bits)
  def this()(implicit p:CacheParam){
    this(p.tagBits, p.infoWidth)
  }
}

object DataMeta{
  def apply(tagBits:Int, infoBits:Int):DataMeta = HardType(new DataMeta(tagBits, infoBits))()
  def apply()(implicit p:CacheParam):DataMeta = HardType(new DataMeta(p.tagBits, p.infoWidth))()
}

object MetaUtil{
  implicit class MatchTag(metas: Seq[DataMeta]){
    def matchTag(tag:UInt) = metas.map( m => m.tag === tag && m.state =/= DataState.I).toIndexedSeq
    def verifyState(wr:Bool) = metas.map(m => m.state.asBits(1) || !wr && m.state === DataState.S).toIndexedSeq
    def matchTag(tag:UInt, wr:Bool) = metas.map(m => m.tag === tag && (m.state.asBits(1) || !wr && m.state === DataState.S)).toIndexedSeq
  }
}

class UnCacheOpReq(PABits:Int, dataBits:Int = 64) extends Bundle{
  val addr = UInt(PABits.bits)
  val wen = Bool()
  val wdata = Bits(dataBits.bits)
  val wstrb = Bits((dataBits / 8).bits)
  val size = UInt(2.bits)//B H W D

  def this()(implicit p:CacheParam){
    this(p.PABits, p.busWidth)
  }
}

//class UnCacheOpResp(dataBits:Int = 64) extends Bits{
//  setWidth(dataBits)
//  def this()(implicit p:CacheParam){
//    this(p.busWidth)
//  }
//}

class Acquire(PABits:Int, pageColorBits:Int) extends Bundle{
  val addr = UInt(PABits.bits)
  val pageColor = UInt(pageColorBits.bits)
  val toE = Bool()
  val isS = Bool()

  def this()(implicit p:CacheParam){
    this(p.PABits, p.pageColorBits)
  }
}

class Grant(dataBits:Int, infoBits:Int) extends Bundle{
  val toE = Bool()
  val info = Bits(infoBits.bits)
  val data = Bits(dataBits.bits)
  val hasData = Bool()

  def this()(implicit p:CacheParam){
    this(p.busWidth, p.infoWidth)
  }
}

class Release(PABits:Int, dataBits:Int, infoBits:Int) extends Bundle{
  val addr = UInt(PABits.bits)
  val info = Bits(infoBits.bits)
  val data = Bits(dataBits.bits)
  val hasData = Bool()
  val toS = Bool()
  val probeAck = Bool()

  def this()(implicit p:CacheParam){
    this(p.PABits, p.busWidth, p.infoWidth)
  }
}

class Probe(PABits:Int, pageColorBits:Int) extends Bundle{
  val addr = UInt(PABits.bits)
  val pageColor = UInt(pageColorBits.bits)
  val toS = Bool()
  val needData = Bool()
  val clearLLB = Bool()

  def this()(implicit p:CacheParam){
    this(p.PABits, p.pageColorBits)
  }
}

class CacheBus(PABits:Int, dataBits:Int,unCacheBits:Int, infoBits:Int, pageColorBits:Int) extends Bundle with IMasterSlave {
  val unCacheOpReq  = Stream(new UnCacheOpReq(PABits, unCacheBits))
  val unCacheOpResp = Stream(Bits(unCacheBits.bits))
  val acquire       = Stream(new Acquire(PABits, pageColorBits))
  val grant         = Stream(new Grant(dataBits, infoBits))
  val grantAck      = Stream(new Bundle{})
  val release       = Stream(new Release(PABits, dataBits, infoBits))
  val releaseAck    = Stream(new Bundle{})
  val probe         = Stream(new Probe(PABits, pageColorBits))

  override def asMaster(): Unit = {
    master(unCacheOpReq)
    slave(unCacheOpResp)
    master(acquire)
    slave(grant)
    master(grantAck)
    master(release)
    slave(releaseAck)
    slave(probe)
  }

  def this()(implicit p:CacheParam){
    this(p.PABits, p.busWidth,p.unCacheWidth, p.infoWidth, p.pageColorBits)
  }
}

class CacopReq(PAW:Int = 32, VAW:Int = 32) extends Bundle{
  val code = UInt(2.bits)
  val va = UInt(VAW.bits)
  val pa = UInt(PAW.bits)
}
