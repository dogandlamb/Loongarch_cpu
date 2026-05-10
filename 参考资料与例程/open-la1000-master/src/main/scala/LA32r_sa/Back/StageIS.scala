package LA32r_sa.Back

import LA32r_sa.Param
import LA32r_sa.util.SeqAsBits
import spinal.core._
import spinal.lib._

class StageIS(implicit p: Param) extends Component {
  val is = Vec(slave(Stream(DEOutData())), 3)
  val ex1Cancel, ex2Cancel, wbCancel = in(Bool())
  val ex1SBCancel, ex2SBCancel = in(Bits(2.bits))
  val interrupt = in(Bool())
  val ex1 = out(IS2EX1())
  val stall = in(Bool())
  val mshrEmpty = in(Bool())
  val reg = Vec(master(new RegRead), 6)

  val timer = Counter(64.bits, True)

  class ScoreBoard extends Bundle {
    val dest = UInt(5.bits)
    val delay = UInt(2.bits)
  }

  val scoreBoard = Reg(Vec(new ScoreBoard, 4))
  val newScoreBoard = Vec(new ScoreBoard, 3)
  val useWb = Bits(3.bits)

  val info = is.zipWithIndex.map { case (inst, i) => new Area {
    val rd = inst.inst(0 to 4).asUInt
    val rj = inst.inst(5 to 9).asUInt
    val rk = inst.inst(10 to 14).asUInt
    val i12 = inst.inst(10 to 21).asUInt
    val i14 = inst.inst(10 to 23).asUInt
    val i20 = inst.inst(5 to 24).asUInt << 12
    val offset16 = inst.inst(10 to 25) << 2
    val offset26 = inst.inst(0 to 9) ## inst.inst(10 to 25) << 2
    val csrAddr = inst.inst(10 to 23).asUInt

    val rkd = Mux(inst.rd, rd, rk)
    val readRj = inst.readRj
    val readRkd = inst.readRkd
    val ertn = inst.unit === ExUnit.SP && inst.func.sp === SPCode.ERTN
    val idle = inst.unit === ExUnit.SP && inst.func.sp === SPCode.IDLE

    val wbDest = inst.wbDest
    useWb(i) := inst.useWb
    val wbFinish = inst.unit === ExUnit.SP && (inst.func.sp === SPCode.RDCNTVH || inst.func.sp === SPCode.RDCNTVL)
    val wbData = Mux(!wbFinish, inst.unit.asBits.asUInt.resized,
      Mux(inst.func.sp === SPCode.RDCNTVH, timer.takeHigh(32).asUInt, timer.takeLow(32).asUInt))

    def forward(raw: DataPort, addr: UInt) =
      (newScoreBoard.take(i).reverseIterator ++ scoreBoard).zipWithIndex.foldRight(raw) { case ((sb, j), d) =>
        val forwarded = DataPort()
        forwarded.valid := False
        forwarded.data.assignDontCare()
        forwarded.data(forwarded.data.getBitsWidth - 1) := sb.delay(0)
        forwarded.data(forwarded.data.getBitsWidth - 2) := sb.delay(1)
        forwarded.data(4) := False
        forwarded.data(0 until 3) := (if (i == 2 && j == 0) Mux(useWb(0), U(0), U(1)).resized else U(2-i+j).resized)
        Mux(sb.dest === addr && addr =/= 0, forwarded, d)
      }

    val rjRaw = DataPort()
    rjRaw.valid := False
    rjRaw.data := i * 2 + 0x10 // reg file read port addr + from reg mark
    //if timing fail, remove same cycle forward or remove EX2 ALU?
    val rjRes = forward(rjRaw, rj)
    val rkdRaw = DataPort()
    rkdRaw.valid := False
    rkdRaw.data := i * 2 + 1 + 0x10 // reg file read port addr + from reg mark
    val rkdRes = forward(rkdRaw, rkd)

    val resultDelay = inst.unit === ExUnit.LSU || inst.unit === ExUnit.MUL || inst.unit === ExUnit.DIV ||
      inst.unit === ExUnit.ALU && ((readRj && rjRes.delay) || (readRkd && rkdRes.delay)) ||
      (if(p.ex2BRU) inst.unit === ExUnit.BRU && readRj && rjRes.delay else False)
    newScoreBoard(i).dest := wbDest
    newScoreBoard(i).delay := Mux(wbFinish, U(0), Mux(resultDelay, U(2), U(1)))

    val alu = new Bundle {
      val a, b = DataPort()
      val op = inst.func.alu
    }
    val aluAImm = DataPort(Mux(alu.op === ALUCode.PCADDU12I, inst.pc, U(0)))
    alu.a := Mux(readRj, rjRes, aluAImm)
    val aluBImm = DataPort(alu.op.mux(
      ALUCode.SLL -> rk.resize(p.isa_width),
      ALUCode.SRL -> rk.resize(p.isa_width),
      ALUCode.SRA -> rk.resize(p.isa_width),
      ALUCode.PCADDU12I -> i20.asSInt.resize(p.isa_width).asUInt,
      ALUCode.LU12I -> i20.asSInt.resize(p.isa_width).asUInt,
      ALUCode.AND -> i12.resize(p.isa_width),
      ALUCode.OR -> i12.resize(p.isa_width),
      ALUCode.XOR -> i12.resize(p.isa_width),
      default -> i12.asSInt.resize(p.isa_width).asUInt
    ))
    alu.b := Mux(readRkd, rkdRes, aluBImm)
    val aluNeedBubble = inst.unit === ExUnit.ALU & (alu.a.delay2 | alu.b.delay2)

    val bru = new Bundle {

      import LA32r_sa.Back.BRUCode._

      //    val delay = Bool()
      val a, b = DataPort()
      val op = inst.func.bru
      val offset = op.mux(BRUCode.BL -> offset26.asSInt.resize(p.isa_width),
        default -> offset16.asSInt.resize(p.isa_width))
      val link = wbDest === 1
      val jrra = op === JR && rj === 1
      val jrop = op === JR && rj =/= 1
      val brop = op =/= JR && op =/= BL
    }
    bru.a := Mux(inst.readRj, rjRes, DataPort(U(0)))
    bru.b := Mux(inst.readRkd, rkdRes, DataPort(U(0)))
    val bruNeedBubble = inst.unit === ExUnit.BRU & (
      if(p.ex2BRU) bru.op =/= BRUCode.BL & rjRes.delay2 | bru.op =/= BRUCode.BL & bru.op =/= BRUCode.JR & rkdRes.delay2
      else bru.op =/= BRUCode.BL & rjRes.delay | bru.op =/= BRUCode.BL & bru.op =/= BRUCode.JR & rkdRes.delay
    )

    val mul = new Bundle {
      val op = inst.func.mul
      val a, b = DataPort()
    }
    mul.a := rjRes
    mul.b := rkdRes
    val mulNeedBubble = inst.unit === ExUnit.MUL & (rjRes.delay | rkdRes.delay)

    val div = new Bundle {
      val op = inst.func.div
      val a, b = DataPort()
    }
    div.a := rjRes
    div.b := rkdRes
    val divNeedBubble = inst.unit === ExUnit.DIV & (rjRes.delay | rkdRes.delay)

    val lsu = new Bundle {
      val op = inst.func.lsu
      val base, wdata = DataPort()
      val offset = op.mux(
        LSUCode.SC_W -> (i14 << 2).asSInt.resize(p.isa_width).asUInt,
        LSUCode.LL_W -> (i14 << 2).asSInt.resize(p.isa_width).asUInt,
        default -> i12.asSInt.resize(p.isa_width).asUInt,
      )
      val cacop = rd
    }
    lsu.base := rjRes
    lsu.wdata := Mux(inst.readRkd, rkdRes, DataPort(U(0)))
    val lsuNeedBubble = inst.unit === ExUnit.LSU & (lsu.base.delay | lsu.wdata.delay2)

    val tlb = new Bundle {
      val op = inst.func.tlb
      val invASID, invVA = DataPort()
      val invop = rd
    }
    tlb.invASID := Mux(inst.readRj, rjRes, DataPort(U(0)))
    tlb.invVA := Mux(inst.readRkd, rkdRes, DataPort(U(0)))
    // tlb exec at wb, no bubble

    val csr = new Bundle {
      val data, mask = DataPort()
      val csr = Mux(inst.func.csr === CSRCode.RDCNTID, U(0x40), csrAddr)
    }
    csr.data := Mux(inst.readRkd, rkdRes, DataPort(U(0)))
    csr.mask := inst.func.csr.muxListDc(Seq(
      CSRCode.CSRRD -> DataPort(U(0)),
      CSRCode.CSRWR -> DataPort(UInt(p.isa_width.bits).setAll()),
      CSRCode.CSRXCHG -> rjRes,
      CSRCode.RDCNTID -> DataPort(U(0)),
    ))
    // csr exec at wb, no bubble

    val needBubble = aluNeedBubble | bruNeedBubble | mulNeedBubble | divNeedBubble | lsuNeedBubble
  }
  }

  (reg.sliding(2, 2).toIndexedSeq zip info).foreach { case (Seq(r1, r2), i) =>
    r1.addr := i.rj
    r2.addr := i.rkd
  }

  //TODO: barrierAfter is for CSR RAW, so if a inst don't read CSR, we can fire it
  val barrierAfter = RegInit(False)
  val bubbleCount = RegInit(U(3, 2.bits))
  val battierAfterFire = is.map(inst => inst.fire && inst.barrierAfter).orR
  val barrierAfterRelease = bubbleCount >= 2 && !stall
  when(battierAfterFire) {
    barrierAfter := True
  }.elsewhen(barrierAfterRelease) {
    barrierAfter := False
  }
  when(wbCancel && !stall) {
    bubbleCount := 3
  }.elsewhen(wbCancel || ex2Cancel && !stall) {
    bubbleCount := 2
  }.elsewhen(ex2Cancel || ex1Cancel && !stall) {
    bubbleCount := 1
  }.elsewhen(is(0).fire) {
    bubbleCount := 0
  }.elsewhen(bubbleCount =/= 3 && !stall) {
    bubbleCount := bubbleCount + 1
  }
  val BarrierBeforeRelease = bubbleCount === 3 & mshrEmpty
  val idleBarrier = RegInit(False).setWhen((is.map(_.fire) & info.map(_.idle)).orR).clearWhen(interrupt && !stall || wbCancel || ex2Cancel || ex1Cancel)
//  val idleBarrier = is(0).unit === ExUnit.SP && is(0).func.sp === SPCode.IDLE
  val barrierBefore = is(0).barrierBefore
  val barrier = barrierBefore & !BarrierBeforeRelease || barrierAfter & !barrierAfterRelease || idleBarrier

  val inst1UnitStall = is(1).unit === is(0).unit && is(1).unit =/= ExUnit.ALU
  val inst2UnitStall = is.map(_.unit === ExUnit.ALU).andR ||
    is(2).unit =/= ExUnit.ALU && (is(2).unit === is(1).unit || is(2).unit === is(0).unit) ||
    info.map(_.wbDest.orR).andR

  val inst0Issue = !info(0).needBubble && !interrupt
  val inst1Issue = !info(1).needBubble && !inst1UnitStall && !is(0).barrierAfter && !is(0).rollback && !is(0).exception && !is(1).barrierBefore && inst0Issue
  val inst2Issue = !info(2).needBubble && !inst2UnitStall && !is(1).barrierAfter && !is(1).rollback && !is(1).exception && !is(2).barrierBefore && inst1Issue
  val issue = Cat(inst2Issue, inst1Issue, inst0Issue)

  (is zip issue.asBools).foreach { case (is, issue) => is.ready := !stall && (!barrier || interrupt) && issue }
  val fire = is.map(_.fire).asBits()

  val isOut = IS2EX1()
  isOut.info.ertn := (info.map(_.ertn).asBits & fire).orR
  isOut.info.rollback := (is.map(_.rollback).asBits & fire).orR
  isOut.info.exception := (is.map(_.exception).asBits & fire).orR || interrupt && is(0).valid
  isOut.info.excpCode := Mux(interrupt, ExcpCode.INT, MuxOH(is.map(_.exception).asBits & fire, is.map(_.excpCode)))
  isOut.info.era := MuxOH(is.map(i => i.exception || i.rollback).asBits & fire | interrupt.asBits.resized, is.map(_.pc))

  val aluSel = is.map(_.unit === ExUnit.ALU).asBits & fire & ~is.map(_.exception).asBits.resized
  isOut.alu(0).a := Mux(aluSel(0), info(0).alu.a, info(1).alu.a)
  isOut.alu(0).b := Mux(aluSel(0), info(0).alu.b, info(1).alu.b)
  isOut.alu(0).op := Mux(aluSel(0), info(0).alu.op, info(1).alu.op)
  isOut.alu(1).a := Mux(aluSel(2), info(2).alu.a, info(1).alu.a)
  isOut.alu(1).b := Mux(aluSel(2), info(2).alu.b, info(1).alu.b)
  isOut.alu(1).op := Mux(aluSel(2), info(2).alu.op, info(1).alu.op)

  val bruSel = is.map(_.unit === ExUnit.BRU).asBits & fire & ~is.map(_.exception).asBits.resized
  isOut.bru.a := MuxOH.or(bruSel, info.map(_.bru.a))
  isOut.bru.b := MuxOH.or(bruSel, info.map(_.bru.b))
  isOut.bru.op := Mux(bruSel.orR, MuxOH.or(bruSel, info.map(_.bru.op)), BRUCode.IDLE)
  isOut.bru.taken := MuxOH.or(bruSel, is.map(_.taken))
  isOut.bru.target := MuxOH.or(bruSel, is.map(_.target << 2))
  isOut.bru.hint := MuxOH.or(bruSel, is.map(_.hint))
  isOut.bru.offset := MuxOH.or(bruSel, info.map(_.bru.offset))
  isOut.bru.pc := MuxOH.or(bruSel, is.map(_.pc))
  isOut.bru.brop := MuxOH.or(bruSel, info.map(_.bru.brop))
  isOut.bru.jrop := MuxOH.or(bruSel, info.map(_.bru.jrop))
  isOut.bru.jrra := MuxOH.or(bruSel, info.map(_.bru.jrra))
  isOut.bru.link := MuxOH.or(bruSel, info.map(_.bru.link))
  isOut.bru.port := OHToUInt(bruSel)

  val mulSel = is.map(_.unit === ExUnit.MUL).asBits & fire & ~is.map(_.exception).asBits.resized
  isOut.mul.a := MuxOH.or(mulSel, info.map(_.mul.a))
  isOut.mul.b := MuxOH.or(mulSel, info.map(_.mul.b))
  isOut.mul.op := Mux(mulSel.orR, MuxOH.or(mulSel, info.map(_.mul.op)), MULCode.IDLE)

  val divSel = is.map(_.unit === ExUnit.DIV).asBits & fire & ~is.map(_.exception).asBits.resized
  isOut.div.a := MuxOH.or(divSel, info.map(_.div.a))
  isOut.div.b := MuxOH.or(divSel, info.map(_.div.b))
  isOut.div.op := Mux(divSel.orR, MuxOH.or(divSel, info.map(_.div.op)), DIVCode.IDLE)
  isOut.div.port := OHToUInt(divSel)

  val lsuSel = is.map(_.unit === ExUnit.LSU).asBits & fire & ~is.map(_.exception).asBits.resized
  isOut.lsu.base := MuxOH.or(lsuSel, info.map(_.lsu.base))
  isOut.lsu.wdata := MuxOH.or(lsuSel, info.map(_.lsu.wdata))
  isOut.lsu.op := Mux(lsuSel.orR, MuxOH.or(lsuSel, info.map(_.lsu.op)), LSUCode.IDLE)
  isOut.lsu.offset := MuxOH.or(lsuSel, info.map(_.lsu.offset))
  isOut.lsu.cacop := MuxOH.or(lsuSel, info.map(_.lsu.cacop))
  isOut.lsu.pc := MuxOH.or(lsuSel, is.map(_.pc))
  isOut.lsu.port := OHToUInt(lsuSel)

  val tlbSel = is.map(_.unit === ExUnit.TLB).asBits & fire & ~is.map(_.exception).asBits.resized
  isOut.tlb.op := Mux(tlbSel.orR, MuxOH.or(tlbSel, info.map(_.tlb.op)), TLBCode.IDLE)
  isOut.tlb.invVA := MuxOH.or(tlbSel, info.map(_.tlb.invVA))
  isOut.tlb.invASID := MuxOH.or(tlbSel, info.map(_.tlb.invASID))
  isOut.tlb.invop := MuxOH.or(tlbSel, info.map(_.tlb.invop))
  isOut.tlb.port := OHToUInt(tlbSel)

  val csrSel = is.map(_.unit === ExUnit.CSR).asBits & fire & ~is.map(_.exception).asBits.resized
  isOut.csr.data := MuxOH.or(csrSel, info.map(_.csr.data))
  isOut.csr.mask := Mux(csrSel.orR, MuxOH.or(csrSel, info.map(_.csr.mask)), DataPort(U(0)))
  isOut.csr.csr := MuxOH.or(csrSel, info.map(_.csr.csr))
  isOut.csr.port := OHToUInt(csrSel)

  val wbSel = useWb & fire & ~is.map(_.exception).asBits.resized
  require(ExUnit.ALU == ExUnit.ALU1)
  isOut.wb(0).port.dest := Mux(wbSel(0), info(0).wbDest, Mux(wbSel(1), info(1).wbDest, U(0)))
  isOut.wb(0).port.finish := Mux(wbSel(0), info(0).wbFinish, Mux(wbSel(1), info(1).wbFinish, True))
  isOut.wb(0).port.data := Mux(wbSel(0),
    Mux(is(0).unit === ExUnit.ALU, ExUnit.ALU0.asBits.asUInt.resized, info(0).wbData),
    Mux(is(1).unit === ExUnit.ALU && !aluSel(0), ExUnit.ALU0.asBits.asUInt.resized, info(1).wbData))
  isOut.wb(0).pos := !wbSel(0)
  isOut.wb(1).port.dest := Mux(wbSel(2), info(2).wbDest, Mux(wbSel(1), info(1).wbDest, U(0)))
  isOut.wb(1).port.finish := Mux(wbSel(2), info(2).wbFinish, Mux(wbSel(1), info(1).wbFinish, True))
  isOut.wb(1).port.data := Mux(wbSel(2), info(2).wbData,
    Mux(is(1).unit === ExUnit.ALU && !aluSel(0), ExUnit.ALU0.asBits.asUInt.resized, info(1).wbData))
  isOut.wb(1).pos := wbSel(2)
  when(ex2SBCancel(0) || wbCancel || (ex1SBCancel(0) || ex2Cancel) && !stall) {
    scoreBoard(3).dest := U(0)
  }.elsewhen(!stall) {
    scoreBoard(3).dest := scoreBoard(1).dest
    scoreBoard(3).delay := scoreBoard(1).delay |>> 1
  }
  when(ex2SBCancel(1) || wbCancel || (ex1SBCancel(1) || ex2Cancel) && !stall) {
    scoreBoard(2).dest := U(0)
  }.elsewhen(!stall) {
    scoreBoard(2).dest := scoreBoard(0).dest
    scoreBoard(2).delay := scoreBoard(0).delay |>> 1
  }
  when(ex1SBCancel(0) || ex2Cancel || wbCancel || ex1Cancel && !stall) {
    scoreBoard(1).dest := U(0)
  }.elsewhen(!stall) {
    scoreBoard(1).dest := Mux(wbSel(0), newScoreBoard(0).dest, Mux(wbSel(1), newScoreBoard(1).dest, U(0)))
    scoreBoard(1).delay := Mux(wbSel(0), newScoreBoard(0).delay, newScoreBoard(1).delay) |>> 1
  }
  when(ex1SBCancel(1) || ex2Cancel || wbCancel || ex1Cancel && !stall) {
    scoreBoard(0).dest := U(0)
  }.elsewhen(!stall) {
    scoreBoard(0).dest := Mux(wbSel(2), newScoreBoard(2).dest, Mux(wbSel(1), newScoreBoard(1).dest, U(0)))
    scoreBoard(0).delay := Mux(wbSel(2), newScoreBoard(2).delay, newScoreBoard(1).delay) |>> 1
  }

  def assignRegRecurse[T <: Bundle](to: T, from: T): Unit = {
    to.elements.foreach { case (name, data) =>
      val other = from.find(name)
      require(other != null, name + "not find")
      data match {
        case vec: Vec[Bundle] =>
          vec zip other.as(vec) foreach { case (a, b) => assignRegRecurse(a, b) }
        case data: DataPort =>
          data.valid := other.as(data).valid | other.as(data).fromReg
          data.data := Mux(other.as(data).fromReg, reg(other.as(data).data.resized).data, other.as(data).data)
        case data: Bundle =>
          assignRegRecurse(data, other.asInstanceOf[Bundle])
        case _ => data := other
      }
    }
  }

  assignRegRecurse(ex1, isOut)
}

case class IS2EX1(implicit p: Param) extends Bundle {
  val info = HardType(new Bundle {
    val ertn = Bool()
    val rollback = Bool()
    val exception = Bool()
    val excpCode = Bits(p.excpCode_width.bits)
    val era = UInt(p.isa_width.bits)
    //if ertn/excp/rollback, is last inst, don't need port
    //badv = era
  })()
  val wb = Vec(HardType(new Bundle {
    val port = WbPort()
    val pos = Bool() //when true, inst1 -> wb0, inst2 -> wb1
  })(), 2)
  val alu = Vec(HardType(new Bundle {
    val a, b = DataPort()
    val op = ALUCode()
  })(), 2)
  val bru = HardType(new Bundle {
    //    val delay = Bool()
    val a, b = DataPort()
    val op = BRUCode()
    val taken = Bool()
    val target = UInt(p.isa_width.bits)
    val hint = Bits((1 max p.hint_width).bits)
    val offset = SInt(p.isa_width.bits)
    val pc = UInt(p.isa_width.bits)
    val link, jrra, jrop, brop = Bool()
    val port = UInt(2.bits)
  })()
  val mul = HardType(new Bundle {
    val op = MULCode()
    val a, b = DataPort()
  })()
  val div = HardType(new Bundle {
    val op = DIVCode()
    val a, b = DataPort()
    val port = UInt(2.bits)
  })()
  val lsu = HardType(new Bundle {
    val op = LSUCode()
    val base, wdata = DataPort()
    val offset = UInt(p.isa_width.bits)
    val cacop = UInt(5.bits)
    val pc = UInt(p.isa_width.bits)
    val port = UInt(2.bits)
  })()
  val tlb = HardType(new Bundle {
    val op = TLBCode()
    val invASID, invVA = DataPort()
    val invop = UInt(5.bits)
    val port = UInt(2.bits)
  })()
  val csr = HardType(new Bundle {
    val data, mask = DataPort()
    val csr = UInt(14.bits)
    val port = UInt(2.bits)
  })()
}

object GenStageIS {
  def main(args: Array[String]): Unit = {
    SpinalConfig(mode = Verilog).generate(new StageIS()(Param())).printPruned()
  }
}
