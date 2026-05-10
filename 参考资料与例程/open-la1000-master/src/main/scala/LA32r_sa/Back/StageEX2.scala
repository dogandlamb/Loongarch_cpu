package LA32r_sa.Back

import LA32r_sa.Front.BRCancel
import LA32r_sa.Param
import spinal.core._
import spinal.lib._

class StageEX2 (implicit p: Param) extends Component {
  val forward = in(Vec(WbPort(), 2))
  val result = out(Vec(WbPort(), 2))
  val cancel = in(Bool())  // wb cancel && !stall
  val stallIn = in(Bool())
  val stallOut = out(Bool())
  val ex2 = in(EX12EX2())
  val wb = out(EX22WB())
  val mul = slave(MulO())
  val div = slave(DivO())
  val divCancel = out(Bool())
  val lsu = master(new LSUex2(p.dataWidth, p.isa_width))
  val br = if(p.ex2BRU) out(new BRCancel()) else null
  val SBCancel = if(p.ex2BRU) out(Bits(2.bits)) else null
  val llbS, llbR = in(Bool())

  val stall = stallOut || stallIn

  val ex2Init = EX12EX2()
  ex2Init.default(ex2Init.getZero)
  ex2Init.wb.foreach(_.port.finish := True)
  if(p.ex2BRU) ex2Init.bru.op := BRUCode.IDLE
  ex2Init.tlb.op := TLBCode.IDLE

  val ex2Reg = RegInit(ex2Init)
  when(cancel){
    ex2Reg := ex2Init
  }.elsewhen(!stall){
    if(p.ex2BRU) when(br.cancel){
      ex2Reg := ex2Init
    }.otherwise{
      ex2Reg := ex2
    } else ex2Reg := ex2
  }

  result := Vec(ex2Reg.wb.map(_.port))
  implicit val forwardAll = Vec(ex2Reg.wb.map(_.port).reverseIterator ++ forward)
  val forwarded = EX12EX2()
  ForwardData(forwarded, ex2Reg, 1)

  val ex2Out = EX22WB()

  //alu0
  val alu0 = new ALU()
  alu0.a := forwarded.alu(0).a.data
  alu0.b := forwarded.alu(0).b.data
  alu0.op := forwarded.alu(0).op

  //alu1
  val alu1 = new ALU()
  alu1.a := forwarded.alu(1).a.data
  alu1.b := forwarded.alu(1).b.data
  alu1.op := forwarded.alu(1).op

  val aluResValid = forwarded.alu.map(alu => alu.a.valid && alu.b.valid)

  //bru
  val bru = if(p.ex2BRU) new BRU() else null
  val bruResValid = if(p.ex2BRU) forwarded.bru.a.valid && forwarded.bru.b.valid else null
  if(p.ex2BRU) assert(bru.i.op === BRUCode.IDLE || bruResValid)
  val canceled = if(p.ex2BRU) RegInit(False).setWhen(br.cancel).clearWhen(cancel || !stall) else null
  if(p.ex2BRU){
    bru.i.a := forwarded.bru.a.data
    bru.i.b := forwarded.bru.b.data
    bru.i.op := forwarded.bru.op
    bru.i.taken := forwarded.bru.taken
    bru.i.pc := forwarded.bru.pc
    bru.i.target := forwarded.bru.target
    bru.i.offset := forwarded.bru.offset.asUInt
    bru.i.cancel_allow := !canceled && !forwarded.bru.canceled && bruResValid//bru op =/= IDLE

    br.cancel  := bru.o.cancel
    br.target  := bru.o.target
    br.taken   := bru.o.taken
    br.link_pc := bru.o.link_pc >> 2
    br.pc      := bru.i.pc
    br.sign    := bru.i.offset.msb
    br.brop    := forwarded.bru.brop
    br.jrop    := forwarded.bru.jrop
    br.jrra    := forwarded.bru.jrra
    br.link    := forwarded.bru.link
    br.hint    := forwarded.bru.hint

    SBCancel := Cat(forwarded.wb.zipWithIndex.map{case(f,i) =>
      br.cancel && forwarded.bru.port < (f.pos.asUInt(2.bits) + i)
    })
  }
  ex2Out.bru assignSomeByName forwarded.bru
  ex2Out.bru.wbPort := forwarded.bru.port === 2 || forwarded.bru.port === 1 && !forwarded.wb.last.pos

  val bruCancel = if(p.ex2BRU) canceled || br.cancel || forwarded.bru.canceled else forwarded.bru.canceled

  //lsu
  val lsuFinish = RegInit(False).setWhen(lsu.fire || lsu.cancel || lsu.exception && lsu.ready).clearWhen(cancel || !stall)
  val lsuRes = RegNextWhen(lsu.result, lsu.fire)
  val lsuStall = lsu.valid && !lsu.ready
  assert(forwarded.lsu.wdata.valid || !forwarded.lsu.valid)
  lsu.wdata := forwarded.lsu.wdata.data.resized
  lsu.valid := forwarded.lsu.valid && !lsuFinish
  lsu.cancel := forwarded.lsu.valid && !lsuFinish && bruCancel && forwarded.bru.port < forwarded.lsu.port || cancel

  val lsuCancel = forwarded.lsu.valid && Mux(lsuFinish, lsuRes.exception, lsu.exception && lsu.ready)

  //mul
  val mulFinish = RegInit(False).setWhen(mul.fire).clearWhen(cancel || !stall)
  val mulRes = RegNextWhen(mul.payload, mul.fire)
  val mulStall = !mul.valid && mul.ready //mul won't stall, can remove this
  mul.ready := forwarded.mul.valid && !mulFinish

  //div
  val divFinish = RegInit(False).setWhen(div.ready && div.valid || divCancel).clearWhen(cancel || !stall)
  val divRes = RegNextWhen(Mux(forwarded.div.mod, div.r, div.q), div.ready && div.valid)
  val divStall = !div.valid && div.ready
  div.ready := forwarded.div.valid && !divFinish
  divCancel := cancel || forwarded.div.valid && !divFinish &&
    (bruCancel && forwarded.bru.port < forwarded.div.port || lsuCancel && forwarded.lsu.port < forwarded.div.port)

  //tlb
  ex2Out.tlb assignSomeByName forwarded.tlb
  when(bruCancel && forwarded.bru.port < forwarded.tlb.port || lsuCancel && forwarded.lsu.port < forwarded.tlb.port){
    ex2Out.tlb.op := TLBCode.IDLE
  }

  //csr
  ex2Out.csr assignSomeByName forwarded.csr
  when(bruCancel && forwarded.bru.port < forwarded.csr.port || lsuCancel && forwarded.lsu.port < forwarded.csr.port){
    ex2Out.csr.mask := DataPort(U(0))
  }

  //wb
  (ex2Out.wb zip forwarded.wb).zipWithIndex.foreach{case ((o, f), i) =>
    import LA32r_sa.Back.ExUnit._
    o.port.dest := f.port.dest
    when(bruCancel && forwarded.bru.port < (f.pos.asUInt(2.bits) + i) || lsuCancel && forwarded.lsu.port <= (f.pos.asUInt(2.bits) + i)){
      o.port.dest := 0
    }
    o.port.finish := True
    o.port.data := Mux(!f.port.finish, f.port.src.muxListDc(Seq(
      ALU0 -> alu0.result,
      ALU1 -> alu1.result,
      LSU -> Mux(lsuFinish, lsuRes.rdata, lsu.rdata).resize(p.isa_width),
      MUL -> Mux(mulFinish, mulRes, mul.payload),
      DIV -> Mux(divFinish, divRes, Mux(forwarded.div.mod, div.r, div.q))
    ) ++ (if(p.ex2BRU) Seq(BRU -> bru.o.link_pc) else Seq())), f.port.data)
  }

  //info
  when(lsuCancel && !(bruCancel && forwarded.bru.port < forwarded.lsu.port)){
    ex2Out.info.exception := True
    ex2Out.info.ertn := False
    ex2Out.info.rollback := False
    ex2Out.info.excpCode := Mux(lsuFinish, lsuRes.excpCode.asBits, lsu.excpCode.asBits)
    ex2Out.info.excpSubCode := Mux(lsuFinish, lsuRes.excpSubCode.asBits, lsu.excpSubCode.asBits)
    ex2Out.info.era := forwarded.lsu.pc
    ex2Out.info.badv := Mux(lsuFinish, lsuRes.badVA, lsu.badVA)
  }.elsewhen(bruCancel){
    ex2Out.info assignSomeByName ex2Init.info
    ex2Out.info.badv := ex2Init.info.era
    ex2Out.info.excpSubCode := 0
  }.otherwise{
    ex2Out.info assignSomeByName forwarded.info
    ex2Out.info.badv := forwarded.info.era
    ex2Out.info.excpSubCode := 0
  }

  //llb
  ex2Out.llb.s := Reg(Bool()).setWhen(llbS).clearWhen(!stall) || llbS
  ex2Out.llb.r := Reg(Bool()).setWhen(llbR).clearWhen(!stall) || llbR

  stallOut := lsuStall || divStall || mulStall

  wb := ex2Out
}

case class EX22WB(implicit p: Param) extends Bundle {
  val info = HardType(new Bundle{
    val ertn = Bool()
    val rollback = Bool()
    val exception = Bool()
    val excpCode = Bits(ExcpCode.codeWidth.bits)
    val excpSubCode = Bits(ExcpCode.subCodeWidth.bits)
    val era = UInt(p.isa_width.bits)
    val badv = UInt(p.isa_width.bits)
  })()
  val wb = Vec(HardType(new Bundle{
    val port = WbPort()
  })(), 2)
  val bru = HardType(new Bundle{
    val hint = Bits((1 max p.hint_width).bits)
    val link, jrra, jrop, brop = Bool()
    val wbPort = Bool()
  })()
  val tlb = HardType(new Bundle{
    val op = TLBCode()
    val invASID, invVA = DataPort()
    val invop = UInt(5.bits)
  })()
  val csr = HardType(new Bundle{
//    val valid = Bool()
    val data, mask = DataPort()
    val csr = UInt(14.bits)
  })()
  val llb = HardType(new Bundle{
    val s,r = Bool()
  })()
}

object GenStageEX2 {
  def main(args: Array[String]): Unit = {
    SpinalConfig(mode = Verilog).generate(new StageEX2()(Param())).printPruned()
  }
}