package LA32r_sa.Back

import LA32r_sa.Front.BRCancel
import LA32r_sa.Param
import spinal.core._
import spinal.lib._

class StageEX1 (implicit p: Param) extends Component {
  val forward = in(Vec(WbPort(), 4))
  val cancel = in(Bool())
  val stallIn = in(Bool())
  val stallOut = out(Bool())
  val ex1 = in(IS2EX1())
  val ex2 = out(EX12EX2())
  val mul = master(MulI())
  val div = master(DivI())
  val lsu = master(Stream(new LSUex1(p.isa_width)))
  val br = out(new BRCancel())
  val SBCancel = out(Bits(2.bits))
  val csr = master(new CSRRead())

  val ex1Init = IS2EX1()
  ex1Init.default(ex1Init.getZero)
  ex1Init.wb.foreach(_.port.finish := True)
  ex1Init.bru.op := BRUCode.IDLE
  ex1Init.mul.op := MULCode.IDLE
  ex1Init.div.op := DIVCode.IDLE
  ex1Init.lsu.op := LSUCode.IDLE
  ex1Init.tlb.op := TLBCode.IDLE

  val ex1Reg = RegInit(ex1Init)
  when(cancel){
    ex1Reg := ex1Init
  }.elsewhen(!stallIn && !stallOut){
    when(br.cancel){
      ex1Reg := ex1Init
    }.otherwise{
      ex1Reg := ex1
    }
  }

  implicit val forwardAll = Vec(ex1Reg.wb.map(_.port).reverseIterator ++ forward)

  val forwarded = IS2EX1()
  ForwardData(forwarded, ex1Reg, 0)

  val ex1Out = EX12EX2()

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
  ex1Out.alu zip forwarded.alu foreach{case (a,b) => a assignSomeByName b}

  //bru
  val bru = new BRU()
  val bruResValid = if(p.ex2BRU) forwarded.bru.a.valid && forwarded.bru.b.valid else True
  if(p.ex2BRU) assert(forwarded.bru.op =/= BRUCode.IDLE || forwarded.bru.a.valid && forwarded.bru.b.valid)
  val canceled = RegInit(False).setWhen(br.cancel).clearWhen(cancel || !(stallIn || stallOut))
  bru.i.a := forwarded.bru.a.data
  bru.i.b := forwarded.bru.b.data
  bru.i.op := forwarded.bru.op
  bru.i.taken := forwarded.bru.taken
  bru.i.pc := forwarded.bru.pc
  bru.i.target := forwarded.bru.target
  bru.i.offset := forwarded.bru.offset.asUInt
  bru.i.cancel_allow := bruResValid && !canceled //bru op =/= IDLE

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

  ex1Out.bru.assignSomeByName(forwarded.bru)
  ex1Out.bru.canceled := br.cancel || canceled

  //lsu
  val lsuFinish = RegInit(False).setWhen(lsu.fire).clearWhen(cancel || !(stallIn || stallOut))
  assert(forwarded.lsu.base.valid || !lsu.fire)
  val lsuStall = lsu.valid && !lsu.ready // && bru not canceled ?
  lsu.valid := !lsuFinish && forwarded.lsu.op =/= LSUCode.IDLE
  lsu.op := forwarded.lsu.op
  lsu.base := forwarded.lsu.base.data
  lsu.offset := forwarded.lsu.offset
  lsu.cacop := forwarded.lsu.cacop
  lsu.cancel := cancel

  ex1Out.lsu.payload.assignSomeByName(forwarded.lsu)
  ex1Out.lsu.valid := forwarded.lsu.op =/= LSUCode.IDLE

  //mul
  val mulFinish = RegInit(False).setWhen(mul.valid && mul.ready).clearWhen(cancel || !(stallIn || stallOut))
  assert(forwarded.mul.a.valid && forwarded.mul.b.valid || !(mul.valid && mul.ready))
  val mulStall = !mulFinish && forwarded.mul.op =/= MULCode.IDLE && !mul.ready // && bru not canceled ?
  mul.valid := !mulFinish && !cancel && forwarded.mul.op =/= MULCode.IDLE
  mul.a := forwarded.mul.a.data
  mul.b := forwarded.mul.b.data
  mul.sign := forwarded.mul.op.muxListDc(Seq(
    MULCode.MUL_W -> True,
    MULCode.MULH_W -> True,
    MULCode.MULH_WU -> False,
  ))
  mul.high := forwarded.mul.op.muxListDc(Seq(
    MULCode.MUL_W -> False,
    MULCode.MULH_W -> True,
    MULCode.MULH_WU -> True,
  ))

  ex1Out.mul.valid := forwarded.mul.op =/= MULCode.IDLE

  //div
  val divFinish = RegInit(False).setWhen(div.valid && div.ready).clearWhen(cancel || !(stallIn || stallOut))
  assert(forwarded.div.a.valid && forwarded.div.b.valid || !(div.valid && div.ready))
  val divStall = !divFinish && forwarded.div.op =/= DIVCode.IDLE && !div.ready // && bru not canceled ?
  div.valid := !divFinish && !cancel && forwarded.div.op =/= DIVCode.IDLE
  div.a := forwarded.div.a.data
  div.b := forwarded.div.b.data
  div.sign := forwarded.div.op.muxListDc(Seq(
    DIVCode.DIV_W -> True,
    DIVCode.MOD_W -> True,
    DIVCode.DIV_WU -> False,
    DIVCode.MOD_WU -> False,
  ))

  ex1Out.div.valid := forwarded.div.op =/= DIVCode.IDLE
  ex1Out.div.mod := forwarded.div.op.muxListDc(Seq(
    DIVCode.DIV_W -> False,
    DIVCode.MOD_W -> True,
    DIVCode.DIV_WU -> False,
    DIVCode.MOD_WU -> True,
  ))
  ex1Out.div.port := forwarded.div.port

  //tlb
  ex1Out.tlb assignSomeByName forwarded.tlb

  //csr
  ex1Out.csr assignSomeByName forwarded.csr
  csr.addr := forwarded.csr.csr

  //wb
  ex1Out.wb zip forwarded.wb foreach{case(o, f) =>
    import LA32r_sa.Back.ExUnit._
    o.pos := f.pos
    o.port.dest := f.port.dest
    o.port.finish := f.port.finish || f.port.src.mux(
      ALU0 -> aluResValid(0),
      ALU1 -> aluResValid(1),
      BRU -> bruResValid,
      CSR -> True,
      default -> False,
    )
    o.port.data := Mux(o.port.finish && !f.port.finish, f.port.src.muxListDc(Seq(
      ALU0 -> alu0.result,
      ALU1 -> alu1.result,
      BRU -> bru.o.link_pc,
      CSR -> csr.data,
    )), f.port.data)
  }

  //info
  ex1Out.info assignSomeByName forwarded.info

  stallOut := lsuStall || divStall || mulStall

  ex2 := ex1Out

}

case class EX12EX2(implicit p: Param) extends Bundle {
  val info = HardType(new Bundle{
    val ertn = Bool()
    val rollback = Bool()
    val exception = Bool()
    val excpCode = Bits(p.excpCode_width.bits)
    val era = UInt(p.isa_width.bits)
    //badv = era
  })()
  val wb = Vec(HardType(new Bundle{
    val port = WbPort()
    val pos = Bool() //when true, inst1 -> wb0, inst2 -> wb1
  })(), 2)
  val alu = Vec(HardType(new Bundle{
    val a,b = DataPort()
    val op = ALUCode()
  })(), 2)
  val bru = HardType(new Bundle{
    //    val delay = Bool()
    val canceled = Bool()
    val a,b = if(p.ex2BRU) DataPort() else null
    val op = if(p.ex2BRU) BRUCode() else null
    val taken = if(p.ex2BRU) Bool() else null
    val target = if(p.ex2BRU) UInt(p.isa_width.bits) else null
    val hint = Bits((1 max p.hint_width).bits)
    val offset = if(p.ex2BRU) SInt(p.isa_width.bits) else null
    val pc = if(p.ex2BRU) UInt(p.isa_width.bits) else null
    val link, jrra, jrop, brop = Bool()
    val port = UInt(2.bits)
  })()
  val div = Flow(new Bundle{
    val mod = Bool()
    val port = UInt(2.bits)
  })
  val mul = Flow(new Bundle)
  val lsu = Flow(new Bundle{
    val wdata = DataPort()
    val pc = UInt(p.isa_width.bits)
    val port = UInt(2.bits)
  })
  val tlb = HardType(new Bundle{
    val op = TLBCode()
    val invASID, invVA = DataPort()
    val invop = UInt(5.bits)
    val port = UInt(2.bits)
  })()
  val csr = HardType(new Bundle{
    val data, mask = DataPort()
    val csr = UInt(14.bits)
    val port = UInt(2.bits)
  })()
}

object GenStageEX1 {
  def main(args: Array[String]): Unit = {
    SpinalConfig(mode = Verilog).generate(new StageEX1()(Param())).printPruned()
  }
}
