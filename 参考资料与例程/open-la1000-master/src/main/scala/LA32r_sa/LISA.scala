package LA32r_sa

import spinal.core._

import scala.language.postfixOps

object LISA {
  var w_gpr = 32
  val w_asid = 10

  val PSMin = 12
  val PSHuge = 21

  val VPNLen = w_gpr - PSMin - 1

  def GPR = UInt(w_gpr.bits)

  trait ExFactory{
    def code:UInt
    def subc:UInt
  }
  class Ex(val v_code:Int,val v_subc:Int) extends ExFactory{
    def code:UInt = Ex.Code(v_code)
    def subc:UInt = Ex.Subc(v_subc)
  }
  case class CondEx(cond:Bool,whenT:Ex,whenF:Ex) extends ExFactory{
    override def code:UInt = Mux(cond,whenT.code,whenF.code)
    override def subc:UInt = Mux(cond,whenT.subc,whenF.subc)
  }
  object Ex{
    val w_code:Int = 6
    val w_subc:Int = 9
    def Code(id:Int):UInt = U(id, w_code bits)
    def Subc(id:Int):UInt = U(id, w_subc bits)
    def Code:UInt = UInt(w_code bits)
    def Subc:UInt = UInt(w_subc bits)
    def apply(code:Int,subc:Int=0):Ex = new Ex(code,subc)
    val INT :Ex = Ex(0x0)
    val PIL :Ex = Ex(0x1)
    val PIS :Ex = Ex(0x2)
    val PIF :Ex = Ex(0x3)
    val PME :Ex = Ex(0x4)
    val PPI :Ex = Ex(0x7)
    val ADE :Ex = Ex(0x8)
    val ADEF:Ex = Ex(0x8,0x0)
    val ADEM:Ex = Ex(0x8,0x1)
    val ALE :Ex = Ex(0x9)
    val SYS :Ex = Ex(0xb)
    val BRK :Ex = Ex(0xc)
    val INE :Ex = Ex(0xd)
    val IPE :Ex = Ex(0xe)
    val FPD :Ex = Ex(0xf)
    val FPE :Ex = Ex(0x12,0x0)
    val TLBR:Ex = Ex(0x3f)
    def PISL(st:Bool) = CondEx(st,PIS,PIL)
    def isMem(code:UInt):Bool = code.orR && code <= ALE.code
    def isTlb(code:UInt):Bool = code.orR && code <= PPI.code
  }
}
