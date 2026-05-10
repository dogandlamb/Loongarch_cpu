package LA32r_sa.TLB

import spinal.core._
import spinal.lib._
import LA32r_sa.LISA
import LA32r_sa.Back.{CsrTLBELO, CsrTLBELONoG}

import scala.language.postfixOps

class L2TLBSrchFet extends Bundle
{
  val vppn    = UInt(LISA.VPNLen+1    bits)
  //val srch_id = UInt(LISA.TLB.SRCH_ID_WIDTH bits)
}

class L2TLBSrchData extends L2TLBSrchFet
{
  val st = Bool()
}

class L2TLBReq extends L2TLBSrchData
{
  val srch_type = ReqType()
}

class L2ToL1TLB(p:TLBParam) extends Bundle with IMasterSlave
{
  val fillback   = Bool()
  val invalidate = Bool()
  val entry      = new TlbEntry(p.PPNLen)
  val idx        = Bits(p.L1Size bits)
  val plru_idx   = Bits(p.L1Size bits)
  
  override def asMaster():Unit = {
    out(fillback, invalidate)
    out(entry, idx)
    in (plru_idx)
  }
}

class TlbEntry(PPNLen:Int) extends Bundle{
    val hi:TlbEHi      = new TlbEHi()
    val lo:Vec[CsrTLBELONoG] = Vec(HardType(new CsrTLBELONoG(PPNLen)),2)
}

class TlbEHi() extends Bundle{
    val vppn:UInt = UInt(LISA.VPNLen.bits)
    val ps  :Bool = Bool()//:UInt = UInt(6  bits)
    val g   :Bool = Bool()
    val asid:UInt = UInt(LISA.w_asid bits)
    val e   :Bool = Bool()
}

class L2TLBEHI(L2TagBit: Int) extends Bundle
{
  val e       = Bool()
  val vppn    = UInt(L2TagBit bits)
  val g       = Bool()
  val asid    = UInt(LISA.w_asid bits)
  /** False: smallest PS, True: the other PS */
  val ps      = Bool()
}

class L2TLBEntry(L2TagBit: Int, PPNLen:Int) extends Bundle
{
  def this()(implicit p: TLBParam){ this(p.L2TagBit, p.PPNLen) }
  val hi = HardType(new L2TLBEHI(L2TagBit))()
  val lo:Vec[CsrTLBELONoG] = Vec(HardType(new CsrTLBELONoG(PPNLen)),2)
}

object L2TLBEntry{
  def apply()(implicit p: TLBParam):L2TLBEntry = {
    HardType(new L2TLBEntry())()
  }
}

class L2TLBRespFet() extends Bundle
{
  val hit      = Bool()
  //val srch_id  = UInt(LISA.TLB.SRCH_ID_WIDTH bits)
}

class L2TLBRespMem(PPNLen:Int) extends Bundle
{
  val mat       = Bits(2 bits)
  val ex        = Bool()
  //val robid     = UInt(LISA.ROB_BIT   bits)
  val ecode:UInt = LISA.Ex.Code
  val esubc:UInt = LISA.Ex.Subc
  val ptag      = UInt(PPNLen bits)
  //val srch_id   = UInt(LISA.TLB.SRCH_ID_WIDTH bits)
}
class TlbRW extends Bundle with IMasterSlave{
  val valid:Bool = Bool()
  val ready:Bool = Bool()
  val finish:Bool = Bool()

  val srch:Bool = Bool()
  val rd  :Bool = Bool()
  val wr  :Bool = Bool()
  val fill:Bool = Bool()
  val inv: Bool = Bool()
  val invInfo = HardType(new Bundle{
    val op  :UInt = UInt(5 bits)
    val va  :UInt = LISA.GPR
    val asid:UInt = UInt(LISA.w_asid bits)
  })()
  def en:Bool = wr || fill
  def fire:Bool = ready && valid
  override def asMaster():Unit = {
      out(valid,srch,rd,wr,fill,inv, invInfo)
      in(ready,finish)
  }
}

class TlbSrchRes(IDXBit:Int) extends Bundle{
    val valid = Bool()
    val hit   = Bool()
    val index = UInt(IDXBit bits)
}

class TlbRdRes(PPNLen:Int) extends Bundle{
    val valid  = Bool()
    val e      = Bool()
    class RdData extends Bundle{
        val vppn   = UInt(LISA.VPNLen bits)
        val asid   = UInt(LISA.w_asid bits)
        val ps     = UInt(6 bits)
        val lo     = Vec(new CsrTLBELO(PPNLen), 2)
        def cleared:this.type = {
            vppn := U(0)
            asid := U(0)
            ps   := U(0)
            lo.foreach(_.cleared)
            this
        }
    }
    val dat = new RdData

}
/** we use unified L2TLB here.*/
class L2TLB(p:TLBParam, pullRAM:Boolean) extends Component
{
  implicit val param = p
  val io = new Bundle{
    val csr  = in(new TlbCsr(p.IDXBit, p.PPNLen))
    val core_control = in(new Bundle{
      val br, ex = new Bundle{
        val cancel = Bool()
      }
    })
    val from = new Bundle{
      val data_srch = slave(Stream(new L2TLBSrchData()))
      val fet_srch = slave(Stream(new L2TLBSrchFet()))
      val rw  :TlbRW = slave(new TlbRW)
    }
    val to = new Bundle{
      val srch:TlbSrchRes = out(new TlbSrchRes(p.IDXBit))
      val rd  :TlbRdRes = out(new TlbRdRes(p.PPNLen))
      val data = new Bundle{
        val l1_tlb    = master(new L2ToL1TLB(p))
        val resp      = master(Flow(new L2TLBRespMem(p.PPNLen)))
        val will_resp = out(Bool())
      }
      val fe = new Bundle{
        val l1_tlb = master(new L2ToL1TLB(p))
        val resp   = master(Flow(new L2TLBRespFet()))
      }
    }
  }

  /** some aliases */
  val ex       = io.core_control.ex
  val br       = io.core_control.br
  //val rob_head = io.from.rob_head
  val csr      = io.csr
  val control  = io.from.rw

  val tlbop = new Area{
    val finish        = Bool()
    val receive_tlbop = Bool()
    val working       = RegInit(False)

    working.riseWhen(receive_tlbop)
    working.fallWhen(finish       )

    control.finish := finish

    val rw = new Area{
      val tlbrd   = control.fire && control.rd
      val tlbwr   = control.fire && control.wr
      val tlbfill = control.fire && control.fill
      val valid   = tlbrd || tlbwr

      val finish = RegInit(False)
      finish := tlbrd || tlbwr

      val wdata = L2TLBEntry()
      val addr  = csr.tlbidx.index( 0, p.L2SetBit bits)
      val way   = csr.tlbidx.index(p.L2SetBit, p.L2WayBit bits)
      val en    = UIntToOh(way)

      wdata.hi.vppn := csr.tlbehi.vppn(p.L2SetBit, p.L2TagBit bits)
      wdata.hi.g    := csr.tlbelo(0).g && csr.tlbelo(1).g
      wdata.hi.e    := True
      wdata.hi.ps   := csr.tlbidx.ps=/=U(LISA.PSMin)
      wdata.hi.asid := csr.asid.asid
        /** assign entry lo*/
      wdata.lo(0).assignSomeByName(csr.tlbelo(0))
      wdata.lo(1).assignSomeByName(csr.tlbelo(1))

      when((tlbfill || tlbwr) && csr.estat.ecode === U"h3F"){
        wdata.hi.e    := True
      }.otherwise{
        wdata.hi.e    := !csr.tlbidx.ne
      }

      val fillback = new Area{
        val valid  = RegInit(False)
        val entry  = new TlbEntry(p.PPNLen) setAsReg()
        val l2_idx = UInt(p.IDXBit bits) setAsReg()

        valid         := tlbwr //&& wdata.hi.e
        entry.hi.vppn := csr.tlbehi.vppn
        entry.hi.g    := wdata.hi.g
        entry.hi.e    := wdata.hi.e
        entry.hi.asid := wdata.hi.asid
        entry.hi.ps   := wdata.hi.ps
        entry.lo(0)   := wdata.lo(0)
        entry.lo(1)   := wdata.lo(1)
        l2_idx        := csr.tlbidx.index
      } 

      val to_csr = new Area{
       val valid = RegInit(False)
       val way   = UInt(p.L2WayBit bits) setAsReg()
       val addr  = UInt(p.L2SetBit bits) setAsReg()
       val entry = L2TLBEntry()

       io.to.rd.valid := valid

       when(entry.hi.e){
         when(entry.hi.ps){
           io.to.rd.dat.vppn := entry.hi.vppn.takeHigh(p.L2TagBitHuge).asUInt @@
                                          addr @@ U(0, LISA.PSHuge - LISA.PSMin bits)
           io.to.rd.dat.ps   := LISA.PSHuge
         }.otherwise{
           io.to.rd.dat.vppn := entry.hi.vppn @@ addr
           io.to.rd.dat.ps   := LISA.PSMin
         }
         io.to.rd.e := True
         /** TLBELO */
         io.to.rd.dat.lo(0).assignSomeByName(entry.lo(0))
         io.to.rd.dat.lo(1).assignSomeByName(entry.lo(1))
         io.to.rd.dat.lo(0).g := entry.hi.g
         io.to.rd.dat.lo(1).g := entry.hi.g
         io.to.rd.dat.asid      := entry.hi.asid
       }.otherwise{
         io.to.rd.e := False
         io.to.rd.dat.cleared
       }
      }
      to_csr.way   := way
      to_csr.valid := tlbrd
      to_csr.addr  := addr

    }

    val fill = new Area{
      val valid    = control.fire && control.fill 
      val finish   = RegInit(False)
      val en       = Bits(p.L2Way bits) setAsReg() init(1)
      //TODO: current method is so naive
      when(valid){
        en := en.rotateLeft(1)
      }

      finish := valid

      val addr = UInt(p.L2SetBit bits)
      when(csr.tlbidx.ps === LISA.PSHuge){
        addr := csr.tlbehi.vppn(LISA.PSHuge - LISA.PSMin, p.L2SetBit bits)
      }.otherwise{
          addr:= csr.tlbehi.vppn( 0, p.L2SetBit bits)
      }
      

      val fillback = new Area{
        val valid  = RegInit(False)
        val l2_idx = UInt(p.IDXBit bits) setAsReg()

        l2_idx := OHToUInt(en) @@ addr
      } 
      fillback.valid := valid //&& rw.wdata.hi.e
    }

    val srch = new Area{
      val valid    = control.fire && control.srch
      val finish   = Bool()
      val hit      = RegInit(False)
      //val is_cacop = RegInit(False)
      val l2_idx   = UInt(p.IDXBit bits) setAsReg()

      val to_csr_valid = finish
      //val to_csr       = new L2TLBToCSR()

      io.to.srch.valid := finish
      io.to.srch.hit := hit
      io.to.srch.index := l2_idx
    }

    val inv = new Area{
      val valid   = Bool()
      val working = Bool() setAsReg() init(False)
      val op      = UInt(5 bits) setAsReg()
      val asid    = UInt(LISA.w_asid.bits) setAsReg()
      val va      = LISA.GPR setAsReg()

      val addr    = UInt(p.L2SetBit bits) setAsReg()
      val way     = Bits(p.L2Way bits)

      val wdata   = L2TLBEntry().getZero
      val finish  = Bool()
      val write  = Bool()

      //TODO:
      //1. any inv op will invalidate all L1 TLB
      //2. all inv op will traverse tlb index , read all way, then decide to inv which ways at once.
      op := control.invInfo.op
      asid := control.invInfo.asid
      va := control.invInfo.va

      valid  := control.inv && control.fire

      finish := working && write && addr.andR  //finish in next clock actually
      working.riseWhen(valid )
      working.fallWhen(finish)

      when(valid){
        addr := U(0)
      }.elsewhen(write){
        if(addr.getWidth > 0) addr := addr + U(1)
      }

      object InvState extends SpinalEnum{
        val sIdle, sRead, sWrite = newElement()
      }
      import InvState.{sIdle, sRead, sWrite}
      val s = Reg(InvState()) init sIdle

      val way_op2 = Bits(p.L2Way.bits)
      val way_op3 = Bits(p.L2Way.bits)
      val way_op4 = Bits(p.L2Way.bits)
      val way_op5 = Bits(p.L2Way.bits)
      val way_op6 = Bits(p.L2Way.bits)

      val ram_out = Vec(new L2TLBEntry(), p.L2Way)

      for(i <- 0 until p.L2Way){
        val ram_vppn_huge  = ram_out(i).hi.vppn.takeHigh(p.L2TagBitHuge) ## addr
        val ram_vppn_basic = ram_out(i).hi.vppn.takeHigh(p.L2TagBit) ## addr
        val hit = Mux(ram_out(i).hi.ps, ram_vppn_huge === va.takeHigh(p.VPNLenHuge), ram_vppn_basic === va.takeHigh(p.VPNLen))
        way_op2(i) := ram_out(i).hi.g
        way_op3(i) := !ram_out(i).hi.g
        way_op4(i) := !ram_out(i).hi.g && ram_out(i).hi.asid === asid
        way_op5(i) := !ram_out(i).hi.g && ram_out(i).hi.asid === asid && hit
        way_op6(i) := (ram_out(i).hi.g || ram_out(i).hi.asid === asid) && hit
      }

      switch(s){
        is(sIdle){
          when(valid){
            s := control.invInfo.op.mux(U(0) -> sWrite(), U(1) -> sWrite(), default -> sRead())
          }
          write := False
          way := B(0)
        }
        is(sRead){
          write := False
          way :=  B("1" * p.L2Way)
          s := sWrite
        }
        is(sWrite){
          write := True
          way := op.mux(
            U(2) -> way_op2,
            U(3) -> way_op3,
            U(4) -> way_op4,
            U(5) -> way_op5,
            U(6) -> way_op6,
            default -> B("1"*p.L2Way)
          )

          when(finish){
            s := sIdle
          }.otherwise{
            s := op.mux(U(0) -> sWrite(), U(1) -> sWrite(), default -> sRead())
          }
        }
      }

      val l2_idx = OHToUInt(way) @@ addr

    }

    receive_tlbop := rw.valid || fill.valid || srch.valid || inv.valid
    finish        := rw.finish || fill.finish || srch.finish || inv.finish
  }

  class PSPredictor() extends Area{
    /** counter.msb === 1: use huge page */
    /** counter.msb === 0: use basic page */
    val counter = UInt(2 bits) setAsReg() init(0)
    def res = counter.msb
    val update_en = Bool()
    val update_ps = Bool()

    when(update_en){
      when(update_ps && counter =/= U(3)){
        counter := counter + U(1)
      }.elsewhen(!update_ps && counter =/= U(0)){
        counter := counter - U(1)
      }
    }
  }

  val data_last_hit_ps = new PSPredictor()
  val fe_last_hit_ps = new PSPredictor()

  val resrch = new Area{
    val valid  = RegInit(False)
    val req    = new L2TLBReq() setAsReg()
    val ps     = RegInit(False)
    val cancel = ex.cancel ||
                 br.cancel && req.srch_type===ReqType.fetch
    val real_valid = valid && !cancel
  }


  /**Shakehands with each channels */
  /**Priority: resrch > tlbop > data_srch > fet_srch */
  val l2_tlb_busy = resrch.real_valid    || 
                    tlbop.working        ||  //only tlbinv will rise this signal
                    control.valid 

  io.from.data_srch.ready := !l2_tlb_busy
  io.from.fet_srch.ready :=  io.from.data_srch.ready &&
                            !io.from.data_srch.valid

  val s0 = new Area{
    val valid     = Bool()
    val req       = new L2TLBReq()
    val used_ps   = Bool()
    val srch_addr = UInt(p.L2SetBit bits)

    valid := resrch.real_valid       ||
             tlbop.srch.valid        ||
            (io.from.data_srch.valid || 
             io.from.fet_srch.valid  ) && !l2_tlb_busy

    when(resrch.real_valid){
      req     := resrch.req 
      used_ps := resrch.ps
    }.elsewhen(tlbop.srch.valid){
      req.vppn := csr.tlbehi.vppn @@ U(0, 1 bits)
      req.srch_type := ReqType.search
      req.st    := False
      used_ps       := True
    }.elsewhen(io.from.data_srch.valid){
      req.assignSomeByName(io.from.data_srch.payload)
      req.srch_type := ReqType.data
      used_ps       := data_last_hit_ps.res
    }.otherwise{
      req.assignSomeByName(io.from.fet_srch.payload)
      req.srch_type := ReqType.fetch
      req.st    := False
      used_ps       := fe_last_hit_ps.res
    }

    when(used_ps){
      srch_addr := req.vppn(LISA.PSHuge - LISA.PSMin + 1, p.L2SetBit bits)
    }.otherwise{
      srch_addr := req.vppn(1, p.L2SetBit bits)
    }

    val ram_en    = Bits(p.L2Way bits)
    val ram_wen   = Bits(p.L2Way bits)
    val ram_addr  = UInt(p.L2SetBit bits)
    val ram_wdata = L2TLBEntry()

    ram_en := Mux(   tlbop.rw.valid, tlbop.rw.en,
              Mux( tlbop.fill.valid, tlbop.fill.en,
              Mux(tlbop.inv.working, tlbop.inv.way,
              Mux(            valid, B("1"*p.L2Way),
                                              B(0)))))

    ram_wen := Mux(   tlbop.rw.tlbwr, tlbop.rw.en,
               Mux( tlbop.fill.valid, tlbop.fill.en,
               Mux(tlbop.inv.write, tlbop.inv.way,
                                      B(0))))

    ram_addr := Mux(            valid, srch_addr,
                Mux(   tlbop.rw.valid, tlbop.rw.addr,
                Mux( tlbop.fill.valid, tlbop.fill.addr,
                Mux(tlbop.inv.working, tlbop.inv.addr,
                                       U(0)))))

    ram_wdata := Mux(tlbop.inv.working, tlbop.inv.wdata,
                                        tlbop.rw .wdata)

  }


  val ram = if(!pullRAM) Array.fill(p.L2Way)(Mem(L2TLBEntry(), p.L2Set)) else null

  val s1 = new Area{
    val valid     = RegInit(False)
    val req       = new L2TLBReq() setAsReg()
    val used_ps   = RegInit(False)
    val is_resrch = RegInit(False)
    val ram_dout  = Vec(L2TLBEntry(), p.L2Way)

    val hit       = Bool()
    val way_hit   = Bits(p.L2Way bits)
    val hit_entry = L2TLBEntry()

    valid     := s0.valid
    req       := s0.req
    used_ps   := s0.used_ps
    is_resrch := resrch.real_valid
    
    val need_br_cancel = req.srch_type===ReqType.fetch
    val cancel = ex.cancel || br.cancel && need_br_cancel

    val real_valid = valid && !cancel

    if(!pullRAM){
      for(i <- 0 until p.L2Way) {
        ram_dout(i) := ram(i).readWriteSync(s0.ram_addr,
          s0.ram_wdata,
          s0.ram_en(i),
          s0.ram_wen(i))
      }
    }else{
      Pull.toTopOutput(s0.ram_addr)
      Pull.toTopOutput(s0.ram_wdata.asBits.setCompositeName(s0.ram_wdata))
      Pull.toTopOutput(s0.ram_en)
      Pull.toTopOutput(s0.ram_wen)
      ram_dout.foreach{o =>
        o assignFromBits Pull.driveFromTopInput(Bits(o.getBitsWidth.bits).setCompositeName(o))
      }
    }

    tlbop.rw.to_csr.entry := ram_dout(tlbop.rw.to_csr.way)
    tlbop.inv.ram_out := ram_dout

    for(i <- 0 until p.L2Way){
      val src_tag_basic = req.vppn.takeHigh(p.L2TagBit)
      val src_tag_huge  = req.vppn.takeHigh(p.L2TagBitHuge )
      val tgt_tag_basic = ram_dout(i).hi.vppn.takeHigh(p.L2TagBit)
      val tgt_tag_huge  = ram_dout(i).hi.vppn.takeHigh(p.L2TagBitHuge )

      val check_exist = ram_dout(i).hi.e
      val check_tgt   = Mux(used_ps, src_tag_huge  === tgt_tag_huge ,
                                     src_tag_basic === tgt_tag_basic)
      val check_field = ram_dout(i).hi.g || 
                        csr.asid.asid === ram_dout(i).hi.asid
      val check_ps    = ram_dout(i).hi.ps === used_ps
      way_hit(i) := check_exist && 
                    check_tgt   &&
                    check_field &&
                    check_ps
    }
    hit       := way_hit.orR
    hit_entry := MuxOH.or(way_hit, ram_dout)

    val sel      = Mux(used_ps, req.vppn(LISA.PSHuge - LISA.PSMin), req.vppn(0))
    val found_lo = hit_entry.lo(sel.asUInt)

    val check_ex = new Area{
      val ecode:UInt = LISA.Ex.Code
      val esubc:UInt = LISA.Ex.Subc
  
      val page_refill  = !hit
      val page_invalid = !found_lo.v
      //val page_nx      = req.srch_type===ReqType.fetch && found_lo.nx
      val page_ppi     = found_lo.plv < csr.crmd.plv
      val page_modify  = req.st && !found_lo.d
      val ex = page_refill || page_invalid || page_ppi || page_modify
  
      when(page_refill){
        ecode := LISA.Ex.TLBR.code
        esubc := LISA.Ex.TLBR.subc
      }.elsewhen(page_invalid){
        /** the following oder shouldn't be changed
         *  because when cacop srch tlb, if there is page invalid,
         *  tlb should raise PIL*/
        when(req.srch_type===ReqType.fetch){
          ecode := LISA.Ex.PIF.code
          esubc := LISA.Ex.PIF.subc 
        }.otherwise{
          ecode := LISA.Ex.PISL(req.st).code
          esubc := LISA.Ex.PISL(req.st).subc
        
        }
      }.elsewhen(page_ppi){
        ecode := LISA.Ex.PPI.code
        esubc := LISA.Ex.PPI.subc
      }.elsewhen(page_modify){
        ecode := LISA.Ex.PME.code
        esubc := LISA.Ex.PME.subc
      }.otherwise{
        ecode := U(0)
        esubc := U(0)
      }
    }
    val fillback = new Area{
      val valid  = Bool()
      val idx_lo = UInt(p.L2SetBit bits) setAsReg()
      val entry  = new TlbEntry(p.PPNLen)
      val l2_idx = UInt(p.IDXBit bits)

      valid  := real_valid && hit && req.srch_type=/=ReqType.search

      idx_lo := s0.srch_addr
      l2_idx := OHToUInt(way_hit) @@ idx_lo

      entry.hi.vppn := req.vppn(1, p.VPNLen bits)
      entry.hi.g    := hit_entry.hi.g
      entry.hi.e    := hit_entry.hi.e
      entry.hi.asid := hit_entry.hi.asid
      entry.hi.ps   := used_ps
      entry.lo(0)   := hit_entry.lo(0)
      entry.lo(1)   := hit_entry.lo(1)
    }

    tlbop.srch.hit    := hit
    tlbop.srch.l2_idx := fillback.l2_idx

    val ptag  = UInt(p.PPNLen bits)
    when(used_ps){
      ptag := found_lo.ppn.takeHigh(p.PALen-LISA.PSHuge).asUInt @@
              req.vppn.takeLow(LISA.PSHuge - LISA.PSMin).asUInt
    }.otherwise{
      ptag := found_lo.ppn @@ req.vppn.takeLow(LISA.PSMin - LISA.PSMin).asUInt
    }

    val trans_result = new L2TLBRespMem(p.PPNLen)

    trans_result.mat       := found_lo.mat.asBits
    trans_result.ex        := check_ex.ex
    trans_result.ecode     := check_ex.ecode
    trans_result.esubc     := check_ex.esubc
    trans_result.ptag      := ptag
    //trans_result.robid     := req.robid
    //trans_result.srch_id   := req.srch_id
  
    /** update last_hit_ps*/

    data_last_hit_ps.update_en := is_resrch && hit && 
                                req.srch_type===ReqType.data
    data_last_hit_ps.update_ps := used_ps

    fe_last_hit_ps.update_en := is_resrch && hit && 
                                req.srch_type===ReqType.fetch
    fe_last_hit_ps.update_ps := used_ps

    /** set up resrch req*/
    resrch.valid := real_valid && !(hit || is_resrch)
    resrch.req   := req
    resrch.ps    := !used_ps

    io.to.data.will_resp := valid && (hit || is_resrch) && req.srch_type===ReqType.data

    assert(
      assertion = !hit || hit_entry.hi.e,
      message   = "[L2TLB]: hit WRONG!",
      severity  = FAILURE
    )
  }

  val s2 = new Area{
    val valid        = RegInit(False) 
    val hit          = RegInit(False)
    val trans_result = new L2TLBRespMem(p.PPNLen) setAsReg()
    val req          = new L2TLBReq() setAsReg()

    valid        := s1.real_valid && (s1.hit || s1.is_resrch)
    hit          := s1.hit
    req          := s1.req
    trans_result := s1.trans_result

    tlbop.srch.finish := valid && req.srch_type===ReqType.search

    //control.trans.assignSomeByName(trans_result)

    val cancel = ex.cancel ||
                 br.cancel && req.srch_type===ReqType.fetch
    val real_valid = valid && !cancel

    io.to.data.resp.valid   := valid && req.srch_type===ReqType.data
    io.to.data.resp.payload := trans_result

    io.to.fe.resp.valid   := valid && req.srch_type===ReqType.fetch
    //io.to.fe.resp.srch_id := req.srch_id
    io.to.fe.resp.hit     := hit

    val l1_tlb_management = new Area{
      val tlbop_fill   = RegInit(False)
      val srch_fill    = RegInit(False)
      val invalidate   = RegInit(False)
      val entry        = new TlbEntry(p.PPNLen) setAsReg()
      val l2_idx       = UInt(p.IDXBit bits) setAsReg()

      srch_fill  := s1.fillback.valid
      tlbop_fill := tlbop.rw.fillback.valid   || 
                    tlbop.fill.fillback.valid

      invalidate := tlbop.inv.working

      when(tlbop.rw.fillback.valid || tlbop.fill.fillback.valid){
        entry := tlbop.rw.fillback.entry
      }.otherwise{
        entry := s1.fillback.entry
      }

      when(tlbop.fill.fillback.valid){
        l2_idx := tlbop.fill.fillback.l2_idx
      }.elsewhen(tlbop.rw.fillback.valid){
        l2_idx := tlbop.rw.fillback.l2_idx
      }.elsewhen(s1.fillback.valid){
        l2_idx := s1.fillback.l2_idx
      }.otherwise{
        l2_idx := tlbop.inv.l2_idx
      }

      val data_cam = new L2IDX_CAM(p)
      data_cam.io.from.l2_idx     := l2_idx
      data_cam.io.from.srch_fill  := srch_fill && req.srch_type===ReqType.data
      data_cam.io.from.tlbop_fill := tlbop_fill 
      data_cam.io.from.invalidate := invalidate
      data_cam.io.from.plru_idx   := io.to.data.l1_tlb.plru_idx

      val fe_cam = new L2IDX_CAM(p)
      fe_cam.io.from.l2_idx     := l2_idx
      fe_cam.io.from.srch_fill  := srch_fill && req.srch_type===ReqType.fetch
      fe_cam.io.from.tlbop_fill := tlbop_fill 
      fe_cam.io.from.invalidate := invalidate
      fe_cam.io.from.plru_idx   := io.to.fe.l1_tlb.plru_idx

      io.to.data.l1_tlb.fillback   := data_cam.io.to.fillback
      io.to.data.l1_tlb.invalidate := data_cam.io.to.invalidate
      io.to.data.l1_tlb.entry      := entry
      io.to.data.l1_tlb.idx        := data_cam.io.to.l1_idx

      io.to.fe.l1_tlb.fillback   := fe_cam.io.to.fillback
      io.to.fe.l1_tlb.invalidate := fe_cam.io.to.invalidate
      io.to.fe.l1_tlb.entry      := entry
      io.to.fe.l1_tlb.idx        := fe_cam.io.to.l1_idx

      assert(
        assertion = !((srch_fill||tlbop_fill)&& invalidate),
        message   = "[]L2TLB: cann't have fillback & invalidate at the same time",
        severity  = FAILURE
      )
    }
  }

  control.ready := !resrch.real_valid && !s1.valid && !s2.valid

}

class L1TLBProperty(IDXBit:Int) extends Bundle
{
  val valid  = Bool()
  val l2_idx = UInt(IDXBit bits)
}

class L2IDX_CAM(p:TLBParam) extends Component{
  val io = new Bundle{
    val from = new Bundle{
      val invalidate = in(Bool())
      val srch_fill  = in(Bool())
      val tlbop_fill = in(Bool())
      val plru_idx   = in(Bits(p.L1Size bits))
      val l2_idx     = in(UInt(p.IDXBit bits))
    }
    val to = new Bundle{
      val invalidate = out(Bool())
      val fillback   = out(Bool())
      val l1_idx     = out(Bits(p.L1Size bits))
    }
  }

  val cam = Vec(new L1TLBProperty(p.IDXBit),p.L1Size) setAsReg()

  for(i <- 0 until p.L1Size){
    cam(i).valid.init(False)
  }

  val lookup_hits = Bits(p.L1Size bits)
  for(i <- 0 until p.L1Size){
    lookup_hits(i) := cam(i).l2_idx === io.from.l2_idx &&
                      cam(i).valid
  }

  when(io.from.invalidate){
    io.to.l1_idx.setAll()
  }.elsewhen(lookup_hits.orR){
    io.to.l1_idx := lookup_hits
  }.otherwise{
    io.to.l1_idx := io.from.plru_idx
  }
  io.to.invalidate := io.from.invalidate// &&
                      //lookup_hits.orR
  io.to.fillback   := io.from.srch_fill ||
                      io.from.tlbop_fill && lookup_hits.orR

  for(i <- 0 until p.L1Size){
    when(io.from.invalidate && lookup_hits(i)){
      cam(i).valid := False
    }.elsewhen(io.to.fillback && io.to.l1_idx(i)){
      cam(i).valid  := True
      cam(i).l2_idx := io.from.l2_idx
    }
  }

}