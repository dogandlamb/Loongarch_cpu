package LA32r_sa.Front

import LA32r_sa.Param
import spinal.core._
import spinal.lib._
import LA32r_sa.util._

class Front(implicit p: Param) extends Component {
  val pc_init = in(UInt(p.isa_width.bits))
  val inst = master(new ICacheInterface())
  val br = in(new BRCancel())
  val wb = in(new WBCancel())
  val o = master(new IQueueO())
  //IO

  val bt = new BTCancel()
  val bt_pc = UInt(p.isa_width.bits)//TODO: put this in bt and use connectAllByName to connect
  val pr = new PRCancel()
  val pc_go = Bool()
  val fe = new PipePCData()
  val iq = new PipeCtrl()
  val ra = UInt(p.ras_res_width.bits)
  val buf_cancel = Bool()

  val ram_init = new RAMInit().deploy()

  val randVal = if(p.use_rand) {
    val rand = new RandGen()
    rand.pc_go := pc_go
    rand.iq_go := iq.go
    rand.randVal
  } else null

  val pipe_pc = new PipePC()
  pipe_pc.pc_init := pc_init
  pipe_pc.bt := bt
  bt_pc := pipe_pc.bt_pc
  pipe_pc.pr := pr
  pipe_pc.br := br
  pipe_pc.wb := wb
  pipe_pc.pc_go := pc_go
  fe <> pipe_pc.fe
  pipe_pc.iq := iq
  inst.addr := pipe_pc.inst_addr

  val jhr = if(p.use_jhr){
    val jhr = new JHR()
    jhr.pc_go := pc_go
    jhr.bt := bt
    jhr.pr := pr
    jhr.br := br
    jhr.wb := wb
    jhr.hr
  } else null

  val phr = if(p.use_phr){
    val phr = new PHR()
    phr.pc_go := pc_go
    phr.bt.assignSomeByName(bt)
    phr.bt_pc := bt_pc
    phr.pr.assignSomeByName(pr)
    phr.br.assignSomeByName(br)
    phr.wb.assignSomeByName(wb)
    phr.iq_go := iq.go
    phr.hr
  } else null

  val bhr = if(p.use_bhr){
    val bhr = new BHR()
    bhr.pc_go := pc_go
    bhr.bt.assignSomeByName(bt)
    bhr.pr.assignSomeByName(pr)
    bhr.br.assignSomeByName(br)
    bhr.wb.assignSomeByName(wb)
    bhr.hr
  } else null

  val btb = p.btb.get
  btb.ramInit := ram_init
  btb.iq := iq
  btb.bt_pc := bt_pc
  btb.pr := pr
  btb.ra := ra
  bt := btb.bt

  val bht = {
    val bht = p.bht.get
    bht.setName("bht")
    bht.ramInit := ram_init
    bht.bt_pc := bt_pc
    bht.buf_cancel := buf_cancel
    bht.pr_cancel := pr.cancel
    bht.iq_go := iq.go
    bht.pc_go := pc_go
    bht.br := br
    if(p.use_bhr) bht.bhr := bhr
    if(p.use_phr) bht.phr := phr
    if(p.use_rand) bht.randVal := randVal
    bht.o
  }
  
  val jtb = {
    val jtb = p.jtb.get
    jtb.setName("jtb")
    jtb.ramInit := ram_init
    jtb.bt_pc := bt_pc
    jtb.buf_cancel := buf_cancel
    jtb.pr_cancel := pr.cancel
    jtb.iq_go := iq.go
    jtb.pc_go := pc_go
    jtb.br := br
    if(p.use_bhr) jtb.jhr := jhr
    if(p.use_phr) jtb.phr := phr
    if(p.use_rand) jtb.randVal := randVal
    jtb.o
  }

  val ras = new RAS()
  ras.ramInitValid := ram_init.valid
  ras.pr := pr
  ras.br := br
  ras.wb := wb
  ra := ras.ra

  val instQueue = new InstQueue()
  pc_go := instQueue.pc_go
  instQueue.ramInitValid := ram_init.valid
  instQueue.fe <> fe
  iq := instQueue.iq
//  instQueue.inst <> inst
  instQueue.inst.connectAllByName(inst)
  instQueue.o <> o
  pr := instQueue.pr
  instQueue.br_cancel := br.cancel
  instQueue.wb_cancel := wb.cancel
  instQueue.ra := ra
  instQueue.bht := bht
  instQueue.jtb <> jtb
  buf_cancel := instQueue.buf_cancel

//  val ramPorts = p.RAMS.getOrElse(Set()).map { ram =>
//    val port = master(ram.copy())
//    port <> ram
//    port.nameMe()
//    port
//  }
}

object GenFront {
  def main(args: Array[String]): Unit = {
    SpinalConfig(mode = Verilog, removePruned = true).generate(new Front()(Param(pullRAMS = true)))
  }
}