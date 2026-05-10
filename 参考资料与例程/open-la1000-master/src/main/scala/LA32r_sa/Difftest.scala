package LA32r_sa

import spinal.core._
import spinal.lib._

class Difftest (commitNum:Int, tlbidxW:Int) extends Bundle{
  val inst  = Vec(HardType(new DifftestInstrCommit(tlbidxW))(), commitNum)
  val excp  = new DifftestExcpEvent()
  val store = new DifftestStoreEvent()
  val load  = new DifftestLoadEvent()
  val csr = new DifftestCSRRegState()
  val reg = Vec(UInt(32.bits), 32)
}

class DifftestInstrCommit(tlbidxW:Int) extends Bundle{
  val valid = Bool()
  val pc = UInt(32.bits)
  val instr = Bits(32.bits)
  val is_TLBFILL = Bool()
  val TLBFILL_index = UInt(tlbidxW.bits)
  val is_CNTinst = Bool()
  val timer_64_value = UInt(64.bits)
  val wen = Bool()
  val wdest = UInt(5.bits)
  val wdata = UInt(32.bits)
  val csr_rstat = Bool()
  val csr_data = UInt(32.bits)
}

class DifftestExcpEvent extends Bundle{
  val excp_valid = Bool()
  val eret = Bool()
  val intrNo = UInt(11.bits)
  val cause = Bits(6.bits)
  val exceptionPC = UInt(32.bits)
  val exceptionInst = Bits(32.bits)
}

class DifftestStoreEvent extends Bundle{
  val valid = Bits(8.bits)
  val storePAddr = UInt(32.bits)
  val storeVAddr = UInt(32.bits)
  val storeData = Bits(64.bits)
}

class DifftestLoadEvent extends Bundle{
  val valid = Bits(8.bits)
  val paddr = UInt(32.bits)
  val vaddr = UInt(32.bits)
}

class DifftestCSRRegState extends Bundle{
  val crmd = UInt(32.bits)
  val prmd = UInt(32.bits)
  val euen = UInt(32.bits)
  val ecfg = UInt(32.bits)
  val estat = UInt(32.bits)
  val era = UInt(32.bits)
  val badv = UInt(32.bits)
  val eentry = UInt(32.bits)
  val tlbidx = UInt(32.bits)
  val tlbehi = UInt(32.bits)
  val tlbelo0 = UInt(32.bits)
  val tlbelo1 = UInt(32.bits)
  val asid = UInt(32.bits)
  val pgdl = UInt(32.bits)
  val pgdh = UInt(32.bits)
  val save0 = UInt(32.bits)
  val save1 = UInt(32.bits)
  val save2 = UInt(32.bits)
  val save3 = UInt(32.bits)
  val tid = UInt(32.bits)
  val tcfg = UInt(32.bits)
  val tval = UInt(32.bits)
  val ticlr = UInt(32.bits)
  val llbctl = UInt(32.bits)
  val tlbrentry = UInt(32.bits)
  val dmw0 = UInt(32.bits)
  val dmw1 = UInt(32.bits)
}
