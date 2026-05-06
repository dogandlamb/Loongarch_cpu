package LA32r_sa.Back

import spinal.core._

object Inst{
  class Decoded extends Bundle {
    val valid = Bool()
    val plv = Bool()
    val rd = Bool()
    val unit = ExUnit()
    val func = new UnionCode()
    val wb = WBDest()
    val rollback = Bool()
    val barrierAfter = Bool()//inst that change CSR
    val barrierBefore = Bool()
    val readRj = Bool()
    val readRkd = Bool()
  }

  object Decoded{
    def apply [T <: SpinalEnum] (func:SpinalEnumElement[T], wb:SpinalEnumElement[WBDest.type] = WBDest.RD,
                                 plv:Boolean = false, rd:Boolean = false, readRj:Boolean = true, readRkd:Boolean = true, barrierAfter:Boolean = false, barrierBefore:Boolean = false, rollback:Boolean = false): Decoded ={
      val res = new Decoded
      res.valid := True
      res.plv := Bool(plv); res.rd := Bool(rd); res.readRj := Bool(readRj); res.readRkd := Bool(readRkd)
      res.rollback := Bool(rollback); res.barrierAfter := Bool(barrierAfter); res.barrierBefore := Bool(barrierBefore)
      res.func.assignFromBits(func.asBits.resize(UnionCode.width.bits))
      res.wb := wb
      func.spinalEnum match {
        case _:ALUCode.type => res.unit := ExUnit.ALU
        case _:BRUCode.type => res.unit := ExUnit.BRU
        case _:LSUCode.type => res.unit := ExUnit.LSU
        case _:MULCode.type => res.unit := ExUnit.MUL
        case _:DIVCode.type => res.unit := ExUnit.DIV
        case _:TLBCode.type => res.unit := ExUnit.TLB
        case _:CSRCode.type => res.unit := ExUnit.CSR
        case _:SPCode.type => res.unit := ExUnit.SP
      }
      res
    }
  }

  abstract class InstDef {
    val code:MaskedLiteral
    def decode:Decoded
  }

  object RDCNTIDW extends InstDef {
    val code = M"0000000000000000011000-----00000"
    def decode = Decoded(CSRCode.RDCNTID, WBDest.RJ, readRj = false, readRkd = false)
  }
  object RDCNTVLW extends InstDef{
    val code = M"000000000000000001100000000-----"
    def decode = Decoded(SPCode.RDCNTVL, readRj = false, readRkd = false)
  }
  object RDCNTVHW extends InstDef{
    val code = M"000000000000000001100100000-----"
    def decode = Decoded(SPCode.RDCNTVH, readRj = false, readRkd = false)
  }
  object ADDW extends InstDef{
    val code = M"00000000000100000---------------"
    def decode = Decoded(ALUCode.ADD)
  }
  object SUBW extends InstDef{
    val code = M"00000000000100010---------------"
    def decode = Decoded(ALUCode.SUB)
  }
  object SLT extends InstDef{
    val code = M"00000000000100100---------------"
    def decode = Decoded(ALUCode.SLT)
  }
  object SLTU extends InstDef{
    val code = M"00000000000100101---------------"
    def decode = Decoded(ALUCode.SLTU)
  }
  object NOR extends InstDef{
    val code = M"00000000000101000---------------"
    def decode = Decoded(ALUCode.NOR)
  }
  object AND extends InstDef{
    val code = M"00000000000101001---------------"
    def decode = Decoded(ALUCode.AND)
  }
  object OR extends InstDef{
    val code = M"00000000000101010---------------"
    def decode = Decoded(ALUCode.OR)
  }
  object XOR extends InstDef{
    val code = M"00000000000101011---------------"
    def decode = Decoded(ALUCode.XOR)
  }
  object SLLW extends InstDef{
    val code = M"00000000000101110---------------"
    def decode = Decoded(ALUCode.SLL)
  }
  object SRLW extends InstDef{
    val code = M"00000000000101111---------------"
    def decode = Decoded(ALUCode.SRL)
  }
  object SRAW extends InstDef{
    val code = M"00000000000110000---------------"
    def decode = Decoded(ALUCode.SRA)
  }
  object MULW extends InstDef{
    val code = M"00000000000111000---------------"
    def decode = Decoded(MULCode.MUL_W)
  }
  object MULHW extends InstDef{
    val code = M"00000000000111001---------------"
    def decode = Decoded(MULCode.MULH_W)
  }
  object MULHWU extends InstDef{
    val code = M"00000000000111010---------------"
    def decode = Decoded(MULCode.MULH_WU)
  }
  object DIVW extends InstDef{
    val code = M"00000000001000000---------------"
    def decode = Decoded(DIVCode.DIV_W)
  }
  object MODW extends InstDef{
    val code = M"00000000001000001---------------"
    def decode = Decoded(DIVCode.MOD_W)
  }
  object DIVWU extends InstDef{
    val code = M"00000000001000010---------------"
    def decode = Decoded(DIVCode.DIV_WU)
  }
  object MODWU extends InstDef{
    val code = M"00000000001000011---------------"
    def decode = Decoded(DIVCode.MOD_WU)
  }
  object BREAK extends InstDef{
    val code = M"00000000001010100---------------"
    def decode = Decoded(SPCode.NOP, readRj = false, readRkd = false)
  }
  object SYSCALL extends InstDef{
    val code = M"00000000001010110---------------"
    def decode = Decoded(SPCode.NOP, readRj = false, readRkd = false)
  }
  object SLLIW extends InstDef{
    val code = M"00000000010000001---------------"
    def decode = Decoded(ALUCode.SLL, readRkd = false)
  }
  object SRLIW extends InstDef{
    val code = M"00000000010001001---------------"
    def decode = Decoded(ALUCode.SRL, readRkd = false)
  }
  object SRAIW extends InstDef{
    val code = M"00000000010010001---------------"
    def decode = Decoded(ALUCode.SRA, readRkd = false)
  }
  object SLTI extends InstDef{
    val code = M"0000001000----------------------"
    def decode = Decoded(ALUCode.SLT, readRkd = false)
  }
  object SLTUI extends InstDef{
    val code = M"0000001001----------------------"
    def decode = Decoded(ALUCode.SLTU, readRkd = false)
  }
  object ADDIW extends InstDef{
    val code = M"0000001010----------------------"
    def decode = Decoded(ALUCode.ADD, readRkd = false)
  }
  object ANDI extends InstDef{
    val code = M"0000001101----------------------"
    def decode = Decoded(ALUCode.AND, readRkd = false)
  }
  object ORI extends InstDef{
    val code = M"0000001110----------------------"
    def decode = Decoded(ALUCode.OR, readRkd = false)
  }
  object XORI extends InstDef{
    val code = M"0000001111----------------------"
    def decode = Decoded(ALUCode.XOR, readRkd = false)
  }
  object CSRRD extends InstDef{
    val code = M"00000100--------------00000-----"
    def decode = Decoded(CSRCode.CSRRD, plv = true, readRj = false, readRkd = false)
  }
  object CSRWR extends InstDef{
    val code = M"00000100--------------00001-----"
    def decode = Decoded(CSRCode.CSRWR, plv = true, rollback = true, readRj = false, rd = true)
  }
  object CSRXCHG extends InstDef{
    val code = M"00000100------------------------"
    def decode = Decoded(CSRCode.CSRXCHG, plv = true, rollback = true, rd = true)
  }
  object CACOP extends InstDef{
    val code = M"0000011000-----------------0----"
    def decode = Decoded(LSUCode.CACOP, WBDest.R0, plv = true, rollback = false, readRkd = false)
  }
  object CACOPUSR extends InstDef{
    val code = M"0000011000-----------------1----"
    def decode = Decoded(LSUCode.CACOP, WBDest.R0, rollback = false, readRkd = false)
  }
  object TLBSRCH extends InstDef{
    val code = M"00000110010010000010100000000000"
    def decode = Decoded(TLBCode.TLBSRCH, WBDest.R0, plv = true, barrierAfter = true, readRj = false, readRkd = false)
  }
  object TLBRD extends InstDef{
    val code = M"00000110010010000010110000000000"
    def decode = Decoded(TLBCode.TLBRD, WBDest.R0, plv = true, barrierAfter = true, readRj = false, readRkd = false)
  }
  object TLBWR extends InstDef{
    val code = M"00000110010010000011000000000000"
    def decode = Decoded(TLBCode.TLBWR, WBDest.R0, plv = true, rollback = true, readRj = false, readRkd = false)
  }
  object TLBFILL extends InstDef{
    val code = M"00000110010010000011010000000000"
    def decode = Decoded(TLBCode.TLBFILL, WBDest.R0, plv = true, rollback = true, readRj = false, readRkd = false)
  }
  object ERTN extends InstDef{
    val code = M"00000110010010000011100000000000"
    def decode = Decoded(SPCode.ERTN, WBDest.R0, barrierAfter = true, readRj = false, readRkd = false)
  }
  object IDLE extends InstDef{
    val code = M"00000110010010001---------------"
    def decode = Decoded(SPCode.IDLE, WBDest.R0, barrierAfter = true, readRj = false, readRkd = false)
  }
  object INVTLB extends InstDef{
    val code = M"00000110010010011----------00---"
    def decode = Decoded(TLBCode.INVTLB, WBDest.R0, plv = true, rollback = true)
  }
  object BADINVTLB extends InstDef{
    val code = M"00000110010010011----------00111"
    def decode = invalidInst
  }
  object LU12IW extends InstDef{
    val code = M"0001010-------------------------"
    def decode = Decoded(ALUCode.LU12I, readRj = false, readRkd = false)
  }
  object PCADDU12I extends InstDef{
    val code = M"0001110-------------------------"
    def decode = Decoded(ALUCode.PCADDU12I, readRj = false, readRkd = false)
  }
  object LLW extends InstDef{
    val code = M"00100000------------------------"
    def decode = Decoded(LSUCode.LL_W, barrierAfter = true, readRkd = false)
  }
  object SCW extends InstDef{
    val code = M"00100001------------------------"
    def decode = Decoded(LSUCode.SC_W, rd = true)
  }
  object LDB extends InstDef{
    val code = M"0010100000----------------------"
    def decode = Decoded(LSUCode.LD_B, readRkd = false)
  }
  object LDH extends InstDef{
    val code = M"0010100001----------------------"
    def decode = Decoded(LSUCode.LD_H, readRkd = false)
  }
  object LDW extends InstDef{
    val code = M"0010100010----------------------"
    def decode = Decoded(LSUCode.LD_W, readRkd = false)
  }
  object STB extends InstDef{
    val code = M"0010100100----------------------"
    def decode = Decoded(LSUCode.ST_B, WBDest.R0, rd = true)
  }
  object STH extends InstDef{
    val code = M"0010100101----------------------"
    def decode = Decoded(LSUCode.ST_H, WBDest.R0, rd = true)
  }
  object STW extends InstDef{
    val code = M"0010100110----------------------"
    def decode = Decoded(LSUCode.ST_W, WBDest.R0, rd = true)
  }
  object LDBU extends InstDef{
    val code = M"0010101000----------------------"
    def decode = Decoded(LSUCode.LD_BU, readRkd = false)
  }
  object LDHU extends InstDef{
    val code = M"0010101001----------------------"
    def decode = Decoded(LSUCode.LD_HU, readRkd = false)
  }
  object PRELD extends InstDef{
    val code = M"0010101011----------------------"
    def decode = Decoded(LSUCode.PRELD, WBDest.R0, readRkd = false)
  }
  object DBAR extends InstDef{
    val code = M"00111000011100100---------------"
    def decode = Decoded(SPCode.NOP, WBDest.R0, barrierBefore = true, readRj = false, readRkd = false)
  }
  object IBAR extends InstDef{
    val code = M"00111000011100101---------------"
    def decode = Decoded(SPCode.NOP, WBDest.R0, barrierBefore = true, rollback = true, readRj = false, readRkd = false)
  }
  object JIRL extends InstDef{
    val code = M"010011--------------------------"
    def decode = Decoded(BRUCode.JR, readRkd = false)
  }
  object B extends InstDef{
    val code = M"010100--------------------------"
    def decode = Decoded(BRUCode.BL, WBDest.R0, readRj = false, readRkd = false)
  }
  object BL extends InstDef{
    val code = M"010101--------------------------"
    def decode = Decoded(BRUCode.BL, WBDest.R1, readRj = false, readRkd = false)
  }
  object BEQ extends InstDef{
    val code = M"010110--------------------------"
    def decode = Decoded(BRUCode.EQ, WBDest.R0, rd = true)
  }
  object BNE extends InstDef{
    val code = M"010111--------------------------"
    def decode = Decoded(BRUCode.NE, WBDest.R0, rd = true)
  }
  object BLT extends InstDef{
    val code = M"011000--------------------------"
    def decode = Decoded(BRUCode.LT, WBDest.R0, rd = true)
  }
  object BGE extends InstDef{
    val code = M"011001--------------------------"
    def decode = Decoded(BRUCode.GE, WBDest.R0, rd = true)
  }
  object BLTU extends InstDef{
    val code = M"011010--------------------------"
    def decode = Decoded(BRUCode.LTU, WBDest.R0, rd = true)
  }
  object BGEU extends InstDef{
    val code = M"011011--------------------------"
    def decode = Decoded(BRUCode.GEU, WBDest.R0, rd = true)
  }

  val la32r = Vector(RDCNTIDW, RDCNTVLW, RDCNTVHW,
    ADDW, SUBW, SLT, SLTU, NOR, AND, OR, XOR, SLLW, SRLW, SRAW, MULW, MULHW, MULHWU, DIVW, MODW, DIVWU, MODWU,
    BREAK, SYSCALL, SLLIW, SRLIW, SRAIW, SLTI, SLTUI, ADDIW, ANDI, ORI, XORI, LU12IW, PCADDU12I,
    CSRRD, CSRWR, CSRXCHG, CACOPUSR, CACOP, TLBSRCH, TLBRD, TLBWR, TLBFILL, BADINVTLB, INVTLB, ERTN, IDLE,
    LLW, SCW, LDB, LDH, LDW, STB, STH, STW, LDBU, LDHU, PRELD, DBAR, IBAR, JIRL, B, BL, BEQ, BNE, BLT, BGE, BLTU, BGEU)

  def invalidInst:Decoded = {
    val res = new Decoded
    res.assignDontCare()
    res.valid.removeAssignments() := False
    res
  }
}

object InstTest {
  import Inst.B
  def main(args: Array[String]): Unit = {
    SpinalConfig(mode = Verilog).generate(new Module {
      val o = out(B.decode)
    }).printPruned()
  }
}


