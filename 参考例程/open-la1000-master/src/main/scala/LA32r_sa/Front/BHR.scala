package LA32r_sa.Front

import LA32r_sa.Param
import spinal.core._
import spinal.lib._

class BHR (implicit p: Param) extends Component{
  trait More extends Reset with Restore with HR
  val pc_go = in(Bool())
  val bt = in(new BTCancel with More)
  val pr = in(new PRCancel with More)
  val br = in(new BRCancel with More)
  val wb = in(new WBCancel with More)
  val hr = out(new BHROut())
  //IO
  GenRestore.reg(wb, br, pr, bt)
  Seq(wb, pr, bt).foreach(_.hr = Some(Reg(Bits(p.bhr_width.bits))))
  br.hr = Some(Reg(Bits((p.bhr_width + p.inst_num - 1).bits)))
  Seq(wb, br, pr, bt).foreach{c => 
    c.restore.setName(c.getName() + "_restore")
    c.reset.setName(c.getName() + "_reset")
    c.hr.get.setName(c.getName() + "_hr")
  }

  when(wb.reset){
    wb.hr.get := 0
  }.elsewhen(wb.brop){
    wb.hr.get := (wb.hr.get ## wb.taken).resize(wb.hr.get.getWidth)
  }

  when(br.reset) {
    br.hr.get := wb.hr.get.resized
  }.elsewhen(br.brop){
    br.hr.get := (br.hr.get ## br.taken).resize(br.hr.get.getWidth)
  }

  val pr_hr_sel = Seq((wb.restore, wb.hr.get),(br.restore, br.hr.get),(!pr.reset, pr.hr.get))
    .map{case (c,d) => Bits(p.bhr_width.bits).setAllTo(c) & d.resize(p.bhr_width)}.reduceBalancedTree(_|_)
  val pr_hr_sft = shiftBits(pr_hr_sel, pr.brops)
  when(pr.reset){
    pr.hr.get := pr_hr_sel
  }.elsewhen(pr.valid){
    pr.hr.get := pr_hr_sft.drop(1) ## (pr.brop | pr_hr_sft(0))
  }

  val bt_hr_sel = Seq((wb.restore, wb.hr.get),(br.restore, br.hr.get),(pr.restore, pr.hr.get),(!bt.reset, bt.hr.get))
    .map{case (c,d) => Bits(p.bhr_width.bits).setAllTo(c) & d.resize(p.bhr_width)}.reduceBalancedTree(_|_)
  val bt_hr_sft = shiftBits(bt_hr_sel, bt.brops)
  when(pc_go){
    bt.hr.get := bt_hr_sft.drop(1) ## (bt.brop | bt_hr_sft(0))
  }.elsewhen(bt.reset){
    bt.hr.get := bt_hr_sel
  }

  hr.bt := bt_hr_sel
  hr.br := br.hr.get ## br.taken

  //func
  def shiftBits(sel:Bits, brops:Bits):Bits ={
    require((brops.getWidth & 1) == 0)
    brops.asBools.sliding(2,2).foldLeft(sel){case(l,b)=>
      Mux(b.head & b.last, (l << 2).resize(l.getWidth), Mux(b.head | b.last, (l << 1).resize(l.getWidth), l))
    }
  }
}

class BHROut(implicit p: Param) extends Bundle{
  val bt = Bits(p.bhr_width.bits)
  val br = Bits((p.bhr_width + p.inst_num).bits)
}
