package LA32r_sa.Back

import LA32r_sa.Param
import spinal.core._
import spinal.lib._


case class DivI(w:Int=32) extends Bundle with IMasterSlave{
  val valid:Bool = Bool()
  val ready:Bool = Bool()
  val sign :Bool = Bool()
  val a    :UInt = UInt(w bits)
  val b    :UInt = UInt(w bits)
  override def asMaster():Unit = {
    out(valid,sign,a,b)
    in(ready)
  }
  def this()(implicit p:Param){this(p.isa_width)}
}
case class DivO(w:Int=32) extends Bundle with IMasterSlave{
  val valid:Bool = Bool()
  val ready:Bool = Bool()
  val q    :UInt = UInt(w bits)
  val r    :UInt = UInt(w bits)
  override def asMaster():Unit = {
    out(valid,q,r)
    in(ready)
  }
  def this()(implicit p:Param){this(p.isa_width)}
}
class Dividor(val w:Int=32) extends Component{
  val io = new Bundle{
    val i = slave (DivI(w))
    val o = master(DivO(w))
    val cancel = in(Bool())
  }
  def negWhen(value:UInt,cond:Bool):UInt = Mux(cond,(~value)+U(1),value)
  class IDat extends Bundle{
    val sign:Bool = Bool()
    val abs :UInt = UInt(w bits)
    def assignedFrom(value:UInt):this.type = {
      sign := io.i.sign && value.msb
      abs  := negWhen(value,sign)
      this
    }
  }
  class DivBuf extends Bundle{
    val r_sign:Bool = Bool()
    val q_sign:Bool = Bool()
    val r:UInt = UInt(w bits)
    val q:UInt = UInt(w bits)
    val d:UInt = UInt(w bits)
    val p:UInt = UInt(5 bits)
  }
  val work:Bool = RegInit(False)
  val done:Bool = Bool()
  io.i.ready := !work
  io.o.valid := work && done
  val recv:Bool = io.i.valid && io.i.ready
  val send:Bool = io.o.valid && io.o.ready
  when(io.cancel){
    work := False
  }.elsewhen(recv){
    work := True
  }.elsewhen(send){
    work := False
  }

  val a:IDat = new IDat assignedFrom io.i.a
  val b:IDat = new IDat assignedFrom io.i.b

  val req:DivBuf = new DivBuf
  val buf:DivBuf = Reg(new DivBuf)
  req.r_sign := a.sign
  req.q_sign := a.sign ^ b.sign
  req.r := U(0, (w-1) bits) @@ a.abs.msb.asUInt
  req.q := a.abs(w-2 downto 0) @@ U(0, 1 bits)
  req.p := U(31, 5 bits)
  req.d := b.abs
  val last:Bool = buf.p === U(0)
  val sub:UInt = buf.r.expand - buf.d.expand
  val pos:Bool = !sub.msb
  val next:UInt = Mux(pos,sub.resized,buf.r)
  val newr:UInt = Mux(last,next,(next @@ buf.q.msb.asUInt)(buf.r.bitsRange))
  val q_still:UInt = buf.q(w-1 downto 1) @@ pos.asUInt
  val newq:UInt = Mux(last,q_still,q_still |<< 1)
  val newp:UInt = Mux(last,U(0),buf.p - U(1))
  when(recv){
    buf := req
  }.elsewhen(!done){
    buf.p := newp
    buf.r := newr
    buf.q := newq
  }
  done := last && !pos || buf.d === U(0)
  io.o.q := negWhen(buf.q,buf.q_sign)
  io.o.r := negWhen(buf.r,buf.r_sign)

}
