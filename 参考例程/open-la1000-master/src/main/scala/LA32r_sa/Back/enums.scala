package LA32r_sa.Back

import spinal.core._

object ALUCode extends SpinalEnum(binarySequential) {
  val PCADDU12I, LU12I, ADD, SUB, AND, OR, XOR, NOR, SLT, SLTU, SLL, SRL, SRA = newElement()
}

object BRUCode extends SpinalEnum(binarySequential) {
  val IDLE, EQ, NE, LT, GE, JR, EQZ, NEZ, LTU, GEU, BL = newElement()
}

object LSUCode extends SpinalEnum(binarySequential) {
  val IDLE, LD_B, LD_BU, LD_H, LD_HU, LD_W, ST_B, ST_H, ST_W, PRELD, LL_W, SC_W, CACOP,///LA32
  LD_D, ST_D//LA32 float
  = newElement()
}

object MULCode extends SpinalEnum(binarySequential) {
  val IDLE, MUL_W, MULH_WU, MULH_W
  = newElement()
}

object DIVCode extends SpinalEnum(binarySequential) {
  val DIV_W, MOD_W, DIV_WU, MOD_WU, IDLE
  = newElement()
}

object TLBCode extends SpinalEnum(binarySequential) {
  val IDLE, TLBSRCH, TLBRD, TLBFILL, TLBWR, INVTLB
  = newElement()
}

object CSRCode extends SpinalEnum(binarySequential) {
  // CSRXCHG == 0 == !CSRRD & !CSRWR
  val CSRXCHG, CSRWR, CSRRD, IDLE = newElement()
  def RDCNTID = IDLE
}

object SPCode extends SpinalEnum(binarySequential) {
  val ERTN, IDLE, NOP, RDCNTVL, RDCNTVH = newElement()
}

class UnionCode extends Bundle{
  val code = Bits(UnionCode.width.bits)
  def alu = { val res = ALUCode(); res.assignFromBits(code.resized); res }
  def mul = { val res = MULCode(); res.assignFromBits(code.resized); res }
  def div = { val res = DIVCode(); res.assignFromBits(code.resized); res }
  def lsu = { val res = LSUCode(); res.assignFromBits(code.resized); res }
  def bru = { val res = BRUCode(); res.assignFromBits(code.resized); res }
  def tlb = { val res = TLBCode(); res.assignFromBits(code.resized); res }
  def csr = { val res = CSRCode(); res.assignFromBits(code.resized); res }
  def sp = { val res = SPCode(); res.assignFromBits(code.resized); res }
}

object UnionCode {
  val width = Seq(MULCode(),DIVCode(), LSUCode(), BRUCode(), TLBCode(), ALUCode(), CSRCode(), SPCode()).map(_.getBitsWidth).max
}

object ExUnit extends SpinalEnum(binarySequential) {
  val ALU0, ALU1, BRU, LSU, MUL, DIV, TLB, CSR = newElement()
  def ALU = ALU1
  def SP = ALU0
}

object WBDest extends SpinalEnum(binarySequential) {
  val R0, R1, RD, RJ = newElement()
}

object ExcpCode {
  def codeWidth = 6
  def subCodeWidth = 3

  def INT = B"6'h00"

  def PIL = B"6'h01"

  def PIS = B"6'h02"

  def PIF = B"6'h03"

  def PWE = B"6'h04"

  def PNR = B"6'h05"

  def PNE = B"6'h06"

  def PPI = B"6'h07"

  def ADEF = B"6'h08"

  def ADEM = B"6'h08"

  def ALE = B"6'h09"

  def BCE = B"6'h0a"

  def SYS = B"6'h0b"

  def BRK = B"6'h0c"

  def INE = B"6'h0d"

  def IPE = B"6'h0e"

  def FPD = B"6'h0f"

  def SXD = B"6'h10"

  def ASXD = B"6'd11"

  def FPE = B"6'd12"

  def VFPE = B"6'd12"

  def WPEF = B"6'h13"

  def WPEM = B"6'h13"

  def BTD = B"6'h14"

  def BTE = B"6'h15"

  def GSPR = B"6'h16"

  def HYP = B"6'h17"

  def GCSC = B"6'h18"

  def GCHC = B"6'h18"

  def CACHEERR = B"6'h1e"

  def ERROR = B"6'h3e"

  def TLBR = B"6'h3f"

  def NONE = B"6'h30"
}