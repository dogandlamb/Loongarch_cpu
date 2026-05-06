package LA32r_sa.Front

import LA32r_sa.Param
import spinal.core._
import spinal.lib._

class PHR (implicit p: Param) extends Component{
  trait More extends Reset with Restore with HR
  val pc_go = in(Bool())
  val iq_go = in(Bool())
  val bt = in(new BTCancel() with More)
  val bt_pc = in(UInt(p.isa_width.bits))
  val pr = in(new PRCancel() with More)
  val br = in(new BRCancel() with More)
  val wb = in(new WBCancel() with More)
  val hr = out(new PHROut())

  Seq(bt,pr,br,wb).foreach(_.hr = Some(Reg(Bits(p.phr.width.bits))))
  GenRestore.reg(wb,br,pr,bt)
  val sel = Seq((wb.restore, wb.hr.get),(br.restore, br.hr.get),(pr.restore, pr.hr.get),(!bt.reset, bt.hr.get))
    .map{case (c,d) => Bits(p.bhr_width.bits).setAllTo(c) & d.resize(p.bhr_width)}.reduceBalancedTree(_|_)
  when(wb.reset){
    wb.hr.get := B(0)
  }.elsewhen(wb.taken){
    wb.hr.get := (wb.hr.get ## wb.pc(6, p.phr.width.bits)).resized
  }
  when(br.reset){
    br.hr.get := wb.hr.get
  }.elsewhen(br.taken){
    br.hr.get := (br.hr.get ## br.pc(6, p.phr.width.bits)).resized
  }
  when(pr.reset){
    pr.hr.get := hr.bt
  }.elsewhen(iq_go & pr.taken){
    pr.hr.get := (pr.hr.get ## pr.pc(6, p.phr.width.bits)).resized
  }
  when(bt.reset){
    bt.hr.get := hr.bt
  }.elsewhen(pc_go & bt.cancel){
    bt.hr.get := (bt.hr.get ## bt_pc(6, p.phr.width.bits)).resized
  }
  hr.bt := sel
  hr.br := br.hr.get
  hr.br_next := br.taken ? (br.hr.get ## br.pc(6, p.phr.width.bits)).resized | br.hr.get
}

class PHROut(implicit p: Param) extends Bundle{
  val bt = Bits(p.phr.width.bits)
  val br = Bits(p.phr.width.bits)
  val br_next = Bits(p.phr.width.bits)
}
