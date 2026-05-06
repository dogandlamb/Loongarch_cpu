package LA32r_sa.Back

import LA32r_sa.Param
import spinal.core._
import spinal.lib._

import scala.collection.mutable.ArrayBuffer

case class MulI (width:Int = 32) extends Stream(HardType(new MulIData(width))){
  def this()(implicit p:Param){this(p.isa_width)}
}

class MulIData(width:Int = 32) extends Bundle{
  val a, b = UInt(width.bits)
  val high, sign = Bool()
}

case class MulO(width:Int = 32) extends Stream(HardType(UInt(width.bits))){
  def this()(implicit p:Param){this(p.isa_width)}
}

class MUL(width:Int = 32) extends Component {
  def this()(implicit p:Param){this(p.isa_width)}

  val mulI = slave(MulI())
  val mulO = master(MulO())

  val ea = ((mulI.sign && mulI.a.msb) ## mulI.a).asSInt
  val eb = ((mulI.sign && mulI.b.msb) ## mulI.b).asSInt
  val bt = new BoothEncode(ea,eb)
  val wt = new WallaceTree(bt)

  val wt_res = RegNextWhen(wt.res, mulI.fire)
  val high = RegNextWhen(mulI.high, mulI.fire)

  val mul_res = wt_res.reduce(_+_)
  mulO.payload := high ? mul_res.drop(width).asUInt | mul_res.take(width).asUInt
  mulO.valid.setAsReg()
  when(mulI.fire){
    mulO.valid := True
  }.elsewhen(mulO.fire){
    mulO.valid := False
  }
  mulI.ready := mulO.fire | ~mulO.valid
}


class BoothEncode(val a:SInt,val b:SInt,val cut:Int=1) extends Area{
  val v:SInt = if(a.getWidth > b.getWidth) a else b
  val f:SInt =(if(a.getWidth > b.getWidth) b else a)
  val w:Int = v.getWidth
  val n:Int = f.getWidth
  val odd :Int = w & 1
  val even:Int = 1 - odd
  val pos1:Bits = (~(f |>> 1) &( f ^  (f |<< 1))).asBits
  val pos2:Bits = (~(f |>> 1) &  f &  (f |<< 1) ).asBits
  val neg1:Bits = ( (f |>> 1) &( f ^  (f |<< 1))).asBits
  val neg2:Bits = ( (f |>> 1) & ~f & ~(f |<< 1) ).asBits
  val neg :Bits = neg1 | neg2
  val pos :Bits = pos1 | pos2
  val ext :Bits = Mux(v.msb,pos,neg)
  val cnt :Int  = (n>>1)+odd
  val pp = Vec(UInt(w+2 bits),cnt)

  // the last partial product is to reduce CSA number
  val pz = UInt((w + n - cut - 1) bits)
  for(i <- Range(0,n,2)){
    val oh:Array[Bool] = Array(pos1(i),pos2(i),neg2(i),neg1(i))
    val vs:Array[SInt] = Array(v,v|<<1,~(v|<<1),~v)
    pp(i>>1) := U(if(i==0) "11" else "10")@@ MuxOH.or(oh,vs).asUInt
  }
  val w_lo:Int = 2 * cnt - 1
  pz(0, w_lo bits) := (U("1" + "01" * (cnt-1)) & neg.asUInt).resized
  pz(pz.high downto w)   := (U("1" + "01" * (cnt-1)) & ~ext.asUInt).resized
  if (2 * cnt - 1 < w)
    pz(w downto 2 * cnt - 1) := U(0)
  if (w + 2 * cnt - 1 < pz.getWidth)
    pz(pz.high downto w + 2 * cnt - 1) := U(0)
}

class WallaceTree(val pp:Vec[UInt],val pz:UInt) extends Area{
  def this(booth:BoothEncode){
    this(booth.pp,booth.pz)
  }
  def this(a:SInt,b:SInt,cut:Int=1){
    this(new BoothEncode(a,b,cut))
  }
  def getSumSim:Vec[UInt] = {
    val res:Vec[UInt] = Vec(UInt(pz.getWidth bits), 2)
    res(0) := (for(i <- 0 until pp.length) yield (pp(i)<<(2*i)).resized).fold(pz)(_+_)
    res(1) := U(0)
    return res
  }
  def getSumSyn:Vec[UInt] = {
    val w:Int = pz.getWidth
    val n:Int = pp.length
    val tmp:IndexedSeq[ArrayBuffer[Bool]] = for(i <- 0 until w) yield ArrayBuffer[Bool](pz(i))
    for(i <- 0 until n;j <- 0 until pp(i).getWidth;if 2 * i + j < w){
      tmp(2*i+j).append(pp(i)(j))
    }
    val buf:IndexedSeq[Bits] = for(i <- 0 until w) yield Bits(tmp(i).length bits)
    for(i <- 0 until w;j <- 0 until tmp(i).length){
      buf(i)(j) := tmp(i)(j)
    }
    val csa:IndexedSeq[Bits] = genCSA(buf)
    val res:Vec[UInt] = Vec(UInt(pz.getWidth bits), 2)
    for(i <- 0 until csa.length;j <- 0 to 1){
      res(j)(i) := (if(j < csa(i).getWidth) csa(i)(j) else False)
    }
    return res
  }
  def getResultBits(buf:IndexedSeq[Bits],i:Int):Bits = {
    val n:Int = buf(i).getWidth
    val c:Int = if(i==0) 0 else buf(i-1).getWidth/3
    if(n < 3 && c == 0)return buf(i)
    return Bits((n - 2*(n/3) + c) bits)
  }
  def genFullAdder(b:Bits):(Bits,Bits,Option[Bits]) = {
    val w  :Int = b.getWidth
    val n  :Int = w / 3
    val rem:Int = w % 3
    val a:Array[Bits] = Array(b(0,n bits),b(n,n bits),b(2*n,n bits))
    val s:Bits = a(0) ^ a(1) ^ a(2)
    val c:Bits = (a(0) & a(1)) | (a(1) & a(2)) | (a(2) & a(0))
    val r:Option[Bits] = if(rem > 0) Some(b(b.high downto 3*n)) else None
    return (s,c,r)
  }
  def setS(t:Bits,s:Bits):Unit = {
    val low:Int = t.getWidth - s.getWidth
    t(t.high downto low) := s
  }
  def genCSA(buf:IndexedSeq[Bits]):IndexedSeq[Bits] = {
    val max_width:Int = buf.map(_.getWidth).max
    if(max_width <= 2)return buf
    val lv:IndexedSeq[Bits] = for(i <- 0 until buf.length) yield getResultBits(buf,i)
    for(i <- 0 until lv.length;if buf(i) ne lv(i)){
      val w  :Int = buf(i).getWidth
      if(w >= 3){
        val (s,c,ro):(Bits,Bits,Option[Bits]) = genFullAdder(buf(i))
        if(ro.nonEmpty){
          val r:Bits = ro.get
          lv(i)(r.bitsRange) := r
        }
        if(i + 1 < lv.length){
          val rem:Int = buf(i+1).getWidth % 3
          lv(i+1)(rem,c.getWidth bits) := c
        }
        setS(lv(i),s)
      }
      else{
        lv(i)(buf(i).bitsRange) := buf(i)
      }
    }
    return genCSA(lv)
  }
  val res:Vec[UInt] = getSumSyn
}