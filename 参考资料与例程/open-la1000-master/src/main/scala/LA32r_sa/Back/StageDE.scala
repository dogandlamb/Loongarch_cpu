package LA32r_sa.Back

import LA32r_sa.Front.IQueueO
import LA32r_sa.Param
import spinal.core._
import spinal.lib._

class StageDE(implicit p: Param) extends Component {
  val cancel = in(Bool())
  val front = slave(new IQueueO())
  val is = Vec(master(Stream(new DEOutData())),3)
  val plv = in(Bool())

  val de = front.map { i =>
    //TODO: judge if csr inst need rollback?
    val rd = i.inst(0 to 4).asUInt
    val rj = i.inst(5 to 9).asUInt
    val rk = i.inst(10 to 14).asUInt

    val res = DEOutData()
    res assignSomeByName i.payload

    val decode = i.inst.muxList(Inst.la32r.map{inst => (inst.code, inst.decode)} :+ (default -> Inst.invalidInst))
    res assignSomeByName decode

    res.wbDest := decode.wb.mux(WBDest.R0 -> U(0, 5.bits), WBDest.R1 -> U(1, 5.bits), WBDest.RJ -> rj, WBDest.RD -> rd)
    res.useWb := res.wbDest.orR

    when(!i.exception){
      when(!decode.valid){
        res.exception := True
        res.excpCode := ExcpCode.INE
      }.elsewhen(decode.plv && !plv){
        res.exception := True
        res.excpCode := ExcpCode.IPE
      }.elsewhen(i.inst === Inst.BREAK.code){
        res.exception := True
        res.excpCode := ExcpCode.BRK
      }.elsewhen(i.inst === Inst.SYSCALL.code){
        res.exception := True
        res.excpCode := ExcpCode.SYS
      }
    }
    res
  }

  //try shift first
  val buffer = Reg(Vec(DEOutData(), 3))
  val cnt = Reg(UInt(2.bits))
  is.zipWithIndex.foreach{ case (o, i) => o.valid := cnt > i; o.payload := buffer(i)}
  val consumed = is.zipWithIndex.foldLeft(U(0, 2.bits)){case (n, (is, i)) => Mux(is.fire, U(i+1), n)}
  val residue = cnt - consumed
  buffer.zipWithIndex.foreach{ case (data, i) => data := Mux(residue > i, buffer(consumed + i), de(i - residue))}
  val canAccept = ~residue //3 - residue
  front.zipWithIndex.foreach{ case (f, i) => f.ready := canAccept > i && f.valid}
  val provided = front.zipWithIndex.foldLeft(U(0, 2.bits)){case (n, (f, i)) => Mux(f.fire, U(i+1), n)}
  cnt := cnt - consumed + provided
  when(cancel){
    cnt := 0
  }
}

case class DEOutData(implicit p: Param) extends Bundle{
  val pc = UInt(p.isa_width.bits)
  val target = UInt(p.res_width.bits)
  val inst = Bits(32.bits)
  val taken = Bool()
  val exception = Bool()
  val excpCode = Bits(p.excpCode_width.bits)
  val hint = Bits((1 max p.hint_width).bits)
  val rd = Bool()
  val unit = ExUnit()
  val func = new UnionCode()
  val useWb = Bool()
  val wbDest = UInt(5.bits)
  val rollback = Bool()
  val barrierAfter = Bool()
  val barrierBefore = Bool()
  val readRj = Bool()
  val readRkd = Bool()
}

object GenStageDE {
  def main(args: Array[String]): Unit = {
    SpinalConfig(mode = Verilog).generate(new StageDE()(Param())).printPruned()
  }
}