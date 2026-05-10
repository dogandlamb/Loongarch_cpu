package LA32r_sa.Front

import LA32r_sa.Param
import spinal.core._
import spinal.lib._
import LA32r_sa.util._

class RAS (implicit p: Param) extends Component {
  val ramInitValid = in(Bool)
  val pr = in(new PRCancel())
  val br = in(new BRCancel())
  val wb = in(new WBCancel())
  val ra = out(UInt(p.ras_res_width.bits))
  val reset = ClockDomain.current.readResetWire

  val num = p.ras_ptr_widths.size
  val ptr = p.ras_ptr_widths.max

  val pr_index = RegInit(U(0, ptr.bits))
  val pr_index_next = pr.jrra ? (pr_index - 1) | (pr_index + 1)
  val br_index = RegInit(U(0, ptr.bits))
  val br_index_next = br.jrra ? (br_index - 1) | (br_index + 1)
  val wb_index = RegInit(U(0, ptr.bits))
  val wb_index_next = wb.jrra ? (wb_index - 1) | (wb_index + 1)

  val pr_reset = reset | br.cancel | wb.cancel
  val pr_index_valid = RegNext(~pr_reset, False)
  val br_reset = reset | wb.cancel
  val br_index_valid = RegNext(~br_reset, False)

  val pr_index_recov = br_index_valid ? br_index | wb_index
  val br_index_recov = wb_index

  val pr_index_we = pr.link | pr.jrra
  val br_index_we = br.link | br.jrra
  val wb_index_we = wb.link | wb.jrra | ramInitValid

  when(~pr_index_valid){
    pr_index := pr_index_recov
  }.elsewhen(pr_index_we){
    pr_index := pr_index_next
  }
  when(~br_index_valid){
    br_index := br_index_recov
  }.elsewhen(br_index_we){
    br_index := br_index_next
  }
  when(wb_index_we){
    wb_index := wb_index_next
  }

  val res_width = p.ras_res_width

  case class Data(res_width:Int, tag_width:Int) extends Bundle{
    val res = UInt(res_width.bits)
    val tag = UInt(tag_width.bits)
  }

  val pr_width = p.ras_ptr_widths.head
  val pr_tag_width = ptr - pr_width

  val pr_index_idx = pr_index.take(pr_width).asUInt
  val pr_index_tag = pr_index.drop(pr_width).asUInt
  val pr_valid = Reg(Bits((1 << pr_width).bits))
  val pr_stack = Reg(Vec(Data(res_width, pr_tag_width), 1 << pr_width))
  val pr_rdata = pr_stack(pr_index_idx)
  val pr_res = pr_rdata.res
  val pr_hit = pr_valid(pr_index_idx) & pr_rdata.tag === pr_index_tag

  when(pr.link){
    pr_stack(pr_index_idx + 1).res := pr.link_pc
    pr_stack(pr_index_idx + 1).tag := Mux(pr_index_idx.andR, pr_index_tag + 1, pr_index_tag)
  }
  when(pr_reset){
    pr_valid := 0
  }.elsewhen(pr.link){
    pr_valid(pr_index_idx + 1) := True
//  }.elsewhen(pr.jrra){
//    pr_valid(pr_index_idx) := False
  }

  val br_width = p.ras_ptr_widths(1)
  val br_tag_width = ptr - br_width

  val br_index_idx = br_index.take(br_width).asUInt
  val br_index_tag = br_index.drop(br_width).asUInt
  val br_valid = Reg(Bits((1 << br_width).bits))
  val br_stack = Reg(Vec(Data(res_width, br_tag_width), 1 << br_width))
  val br_rdata = br_stack(pr_index_idx.resized)
  val br_res = br_rdata.res
  val br_hit = br_valid(pr_index_idx.resized) & br_rdata.tag === pr_index.drop(br_width).asUInt

  when(br.link){
    br_stack(br_index_idx + 1).res := br.link_pc
    br_stack(br_index_idx + 1).tag := Mux(br_index_idx.andR, br_index_tag + 1, br_index_tag)
  }
  when(br_reset){
    br_valid := 0
  }.elsewhen(br.link){
    br_valid(br_index_idx + 1) := True
    //  }.elsewhen(br.jrra){
    //    br_valid(br_index_idx) := False
  }

  val wb_stack = Reg(Vec(UInt(res_width.bits), 1 << ptr))
  when(wb.link | ramInitValid){
    wb_stack(wb_index + 1) := ramInitValid ? U(0) | wb.link_pc
  }

  ra := PriorityMux(Seq(
    pr_hit -> pr_res,
    br_hit -> br_res,
    True -> wb_stack(pr_index)
  ))
}

object GenRAS {
  def main(args: Array[String]): Unit = {
    SpinalConfig(mode = Verilog, removePruned = true, netlistFileName = "RAS.v").generate {
      implicit val p = LA32r_sa.Param(bht = new TageBHT)
      new Module {
        this.definitionName = "RASWrapper"
        val ramInitValid = in(Bool)
        val pr = in(new PRCancel())
        val br = in(new BRCancel())
        val wb = in(new WBCancel())
        val ra = out(UInt(p.ras_res_width.bits))
        val ras = new RAS()
        ras.ramInitValid := ramInitValid
        ras.pr := pr
        ras.br := br
        ras.wb := wb
        ra := ras.ra
      }
    }
  }
}
