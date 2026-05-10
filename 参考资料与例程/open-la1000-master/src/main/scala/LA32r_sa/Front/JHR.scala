package LA32r_sa.Front

import LA32r_sa.Param
import spinal.core._
import spinal.lib._
import LA32r_sa.util._

class JHR (implicit p: Param) extends Component{
  val hr = out(new JHROut())
  val pc_go = in(Bool())
  val bt = in(new BTCancel())//Spinal should prune these to JHRUpdate
  val pr = in(new PRCancel())
  val br = in(new BRCancel())
  val wb = in(new WBCancel())
  //IO
  val jrop = bt.jrop & pc_go
  val pr_last = RegInit(U(0, p.res_width.bits))
  val br_last = RegInit(U(0, p.res_width.bits))
  val br_last_next = br.jrop ? (br.target >> 2) | br_last
  val pr_last_next = br.jrop ? (pr.target >> 2) | pr_last
  val pr_last_reset = br.cancel | wb.cancel
  when(br.jrop){
    br_last := br.target >> 2
  }
  when(pr_last_reset){
    pr_last := br_last_next
  }.elsewhen(pr.jrop){
    pr_last := pr.target >> 2
  }
  val bt_path = RegInit(B(0, (p.jhr.width+p.jhr.pr_reserve*p.jhr.blk_width).bits))
  val br_path = RegInit(B(0, (p.jhr.width+p.jhr.wb_reserve*p.jhr.blk_width).bits))
  val wb_path = Bits(p.jhr.width.bits)
  val pr_path = Bits(p.jhr.width.bits)
  val br_reset = clockDomain.readResetWire | wb.cancel
  val bt_reset = clockDomain.readResetWire | wb.cancel | br.cancel | pr.cancel
  val wb_path_ptr = gen_ptr(br_reset, br.jrop, wb.jrop)
  val pr_path_ptr = gen_ptr(bt_reset, bt.jrop, pr.jrop)
  pr_path := sel(br_path, wb_path_ptr, pr.jrop, p.jhr.pr_reserve)
  wb_path := sel(br_path, wb_path_ptr, wb.jrop, p.jhr.wb_reserve)
  val br_path_next = Mux(br.jrop, (br_path ## br.target(2, p.jhr.blk_width.bits)).resize(p.jhr.width), br_path.resize(p.jhr.width))
  when(wb.cancel){
    br_path := wb_path.resized
  }.elsewhen(br.jrop){
    br_path := (br_path ## br.target(2, p.jhr.blk_width.bits)).resized
  }
  when(wb.cancel){
    bt_path := wb_path.resized
  }.elsewhen(br.cancel){
    bt_path := br_path_next.resized
  }.elsewhen(pr.cancel){
    bt_path := pr_path.resized
  }.elsewhen(jrop){
    bt_path := (bt_path ## bt.target(2, p.jhr.blk_width.bits)).resized
  }
  hr.last.br := br_last
  hr.last.pr := pr_last
  hr.path.bt := bt_path.resized
  hr.path.br := br_path.resized

  //func
  def gen_ptr(reset:Bool, jrop_i:Bool, jrop_o:Bool):UInt ={
    val ptr = Reg(UInt(2.bits))
    when(reset){
      ptr := 0
    }.elsewhen(jrop_i & ~jrop_o){
      ptr := ptr + 1
    }.elsewhen(jrop_o & ~jrop_i){
      ptr := ptr - 1
    }
    ptr
  }
  def sel(data: Bits, sft:UInt, minus:Bool, n:Int):Bits = {
    val cond = (sft === 0) +: (1 until n).map(i => {
      Mux(minus, sft === i - 1, sft === i)
    })
    val dataPart = (0 until n).map(i =>{
      data(i * p.jhr.blk_width, p.jhr.width.bits)
    })
    (cond zip dataPart).map{case (c,d) => d.validIf(c)}.reduceBalancedTree(_|_)
  }
}

class JHROut(implicit p: Param) extends Bundle{
  val path = new Bundle{
    val br = Bits(p.jhr.width.bits)
    val bt = Bits(p.jhr.width.bits)
  }
  val last = new Bundle{
    val pr = UInt(p.res_width.bits)
    val br = UInt(p.res_width.bits)
  }
}
