package LA32r_sa.Front

import LA32r_sa.Param
import spinal.core._
import spinal.lib._
import LA32r_sa.util._

case class BaseJTB(bypass: Boolean = true) extends JTBParam {
  override def hint_width(implicit p: Param) = 0
  override val use_jhr = true
  def align(implicit p: Param) = p.cache_align
  override def get(implicit p: Param): JTB = {
    new JTB{
      this.definitionName = "BaseJTB"
      val line = Reg(Vec(Bits(40.bits), 1<<align))
      val data = line(bt_pc(2,align.bits), p.inst_num)
      val hit = Cat(data.map{d => d(0) & (d(1,9.bits) === bt_pc(6,9.bits).asBits)})

      val read = new Area{
        val hit = Reg(Bits(p.inst_num.bits))
        val data = Reg(Vec(Bits(30.bits), p.inst_num))
        val valid = RegInit(False)
      }
      when(pc_go){
        read.hit := hit
        (read.data zip data).foreach{ case (r, d) => r := d(10, 30.bits)}
      }
      when(buf_cancel | pr_cancel){
        read.valid := False
      }.elsewhen(pc_go){
        read.valid := True
      }.otherwise{
        read.valid := False
      }

      val ptr = new Area{
        val r = RegInit(False)
        val w = RegInit(False)
      }
      val buf = new Area{
        val hit0 = Reg(Bits(p.inst_num.bits))
        val data0 = Reg(Vec(Bits(30.bits), p.inst_num))
        val hit1 = Reg(Bits(p.inst_num.bits))
        val data1 = Reg(Vec(Bits(30.bits), p.inst_num))
        val hit = Mux(ptr.r, hit1, hit0)
        val data = Mux(ptr.r, data1, data0)
      }
      val res = new Area{
        val hit = PriorityMux(o.jrops, buf.hit.asBools)
        val data = PriorityMux(o.jrops, buf.data)
      }
      when(read.valid){
        when(ptr.w){
          buf.hit1 := read.hit
          buf.data1 := read.data
        }.otherwise{
          buf.hit0 := read.hit
          buf.data0 := read.data
        }
      }
      when(iq_go){
        ptr.r := ~ptr.r
      }
      when(buf_cancel){
        ptr.w := ptr.r ^ iq_go
      }.elsewhen(pr_cancel){
        ptr.w := ~ptr.r
      }.elsewhen(read.valid){
        ptr.w := ~ptr.w
      }

      val pred = Mux(res.hit, res.data, jhr.last.pr.take(30))
      o.target := jhr.last.pr
      o.target.allowOverride
      o.target(0, 30.bits) := pred.asUInt

      when(ramInit.valid){
        line(ramInit.index.resize(align)) := B(0, 40.bits)
      }.elsewhen(br.jrop & br.cancel){
        line(br.pc(2,align.bits)) := Cat(br.target(2,30.bits), br.pc(2+align, 9.bits), jhr.last.br =/= br.target.drop(2).asUInt)
      }
    }
  }
}

object GenBaseJTB {
  def main(args: Array[String]): Unit = {
    SpinalConfig(mode = Verilog, removePruned = true).generate {
      implicit val par = LA32r_sa.Param(jtb = BaseJTB())
      Param().jtb.get
    }
  }
}
