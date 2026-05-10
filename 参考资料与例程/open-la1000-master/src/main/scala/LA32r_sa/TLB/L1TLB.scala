package LA32r_sa.TLB

import LA32r_sa.LISA
import LA32r_sa.Back.CsrTLBELONoG
import spinal.core._
import spinal.lib._

import scala.language.postfixOps


class L1TLBReq(cat: ReqType.E) extends Bundle {
  val vaddr = LISA.GPR
  val st = ifGen(cat == ReqType.data)(Bool())
  val size = ifGen(cat != ReqType.fetch)(UInt(2.bits))
}

class L1TLB(p: TLBParam, cat: ReqType.E) extends Component {
  val io = new Bundle {
    val csr = in(new TlbCsr(p.IDXBit, p.PPNLen))
    val from = new Bundle {
      val srch = slave(Flow(new L1TLBReq(cat)))
      val l2_tlb = slave(new L2ToL1TLB(p))
    }
    val to = new Bundle {
      val resp = out(new AddrTransResp(p.PPNLen))
    }
  }

  val csr = io.csr
  val manage = io.from.l2_tlb

  val entry_hi = Vec(new TlbEHi(), p.L1Size) setAsReg()
  val entry_lo = Vec(Vec(HardType(new CsrTLBELONoG(p.PPNLen)), 2), p.L1Size) setAsReg()

  for (i <- 0 until p.L1Size) {
    entry_hi(i).e.init(False)
  }

  val s0 = new Area {
    val req = io.from.srch

    val src_vppn_basic = req.vaddr(p.VALen - 1 downto LISA.PSMin + 1)
    val src_vppn_huge = req.vaddr(p.VALen - 1 downto LISA.PSHuge + 1)

    val tgt_vppn_basic = Vec(UInt(p.VPNLen bits), p.L1Size)
    val tgt_vppn_huge = Vec(UInt(p.VPNLenHuge bits), p.L1Size)

    val check_exist = Bits(p.L1Size bits)
    val check_tgt = Bits(p.L1Size bits)
    val check_field = Bits(p.L1Size bits)
    val entry_hit = Bits(p.L1Size bits)

    for (i <- 0 until p.L1Size) {
      tgt_vppn_basic(i) := entry_hi(i).vppn.takeHigh(p.VPNLen).asUInt
      tgt_vppn_huge(i) := entry_hi(i).vppn.takeHigh(p.VPNLenHuge).asUInt

      check_exist(i) := entry_hi(i).e
      check_tgt(i) := Mux(entry_hi(i).ps, src_vppn_huge === tgt_vppn_huge(i),
        src_vppn_basic === tgt_vppn_basic(i))
      check_field(i) := entry_hi(i).g || csr.asid.asid === entry_hi(i).asid

      entry_hit(i) := check_exist(i) &&
        check_tgt(i) &&
        check_field(i)
    }

    val new_coming = new Bundle {
      val vppn_basic = manage.entry.hi.vppn.takeHigh(p.VPNLen).asUInt
      val vppn_huge = manage.entry.hi.vppn.takeHigh(p.VPNLenHuge).asUInt

      val check_exist = manage.entry.hi.e
      val check_tgt = Mux(manage.entry.hi.ps, src_vppn_huge === vppn_huge,
        src_vppn_basic === vppn_basic)
      val check_field = manage.entry.hi.g || csr.asid.asid === manage.entry.hi.asid

      val hit = check_exist &&
        check_tgt &&
        check_field
    }

    for (i <- 0 until p.L1Size) {
      when(manage.invalidate && manage.idx(i)) {
        entry_hi(i).e := False
      }.elsewhen(manage.fillback && manage.idx(i)) {
        entry_hi(i) := manage.entry.hi
      }
      when(manage.fillback && manage.idx(i)) {
        entry_lo(i) := manage.entry.lo
      }
    }
    /*
        assert(
          assertion = IsOneHot.or0(entry_hit),
          message   = "[L1TLB] multi way hit in L1TLB!",
          severity  = FAILURE
        )
    */
  }

  val s1 = new Area {
    val valid = RegInit(False)
    val vaddr = UInt(p.VALen bits) setAsReg()
    val size = ifGen(cat != ReqType.fetch)(RegNext(s0.req.size))
    val st = ifGen(cat == ReqType.data)(
      Bool() setAsReg()
    )
    val hit_mask = Bits(p.L1Size bits) setAsReg()

    valid := s0.req.valid
    vaddr := s0.req.vaddr
    hit_mask := s0.entry_hit
    if (cat == ReqType.data) {
      st := s0.req.st
    }

    val new_coming = new Area {
      val valid = RegInit(False)
      val hit = RegInit(False)
      val idx = Bits(p.L1Size bits) setAsReg()
      val entry_lo = Vec(HardType(new CsrTLBELONoG(p.PPNLen)), 2) setAsReg()
      val entry_ps = RegInit(False)
      val rw_conf = Bool()

      valid := manage.fillback
      hit := s0.new_coming.hit && manage.fillback
      idx := manage.idx
      entry_lo := manage.entry.lo
      entry_ps := manage.entry.hi.ps
      rw_conf := valid && idx === hit_mask
    }

//    val hit_entry_ps = MuxOH.or(hit_mask, entry_hi.map(_.ps))
//    val hit_entry_lo = MuxOH.or(hit_mask, entry_lo)

    val hit_entry_ps = RegNext(MuxOH.or(s0.entry_hit, entry_hi.map(_.ps)))
    val hit_entry_lo = RegNext(MuxOH.or(s0.entry_hit, entry_lo))

    val ps = Bool()
    val hit = Bool()
    val sel = Bool()
    val found_lo = new CsrTLBELONoG(p.PPNLen)
    val ptag = UInt(p.PPNLen bits)

    hit := new_coming.hit || hit_mask.orR && !new_coming.rw_conf
    when(new_coming.hit) {
      ps := new_coming.entry_ps
      sel := Mux(new_coming.entry_ps, vaddr(LISA.PSHuge),
        vaddr(LISA.PSMin))
      found_lo := new_coming.entry_lo(sel.asUInt)
    }.otherwise {
      ps := hit_entry_ps
      sel := Mux(hit_entry_ps, vaddr(LISA.PSHuge),
        vaddr(LISA.PSMin))
      found_lo := hit_entry_lo(sel.asUInt)
    }

    when(ps) {
      ptag := found_lo.ppn.dropLow(LISA.PSHuge - LISA.PSMin).asUInt @@
        vaddr(LISA.PSHuge - 1 downto LISA.PSMin)
    }.otherwise {
      ptag := found_lo.ppn @@ vaddr(LISA.PSMin - 1 downto LISA.PSMin)
    }

    val mat = found_lo.mat
    val ex = Bool()
    val ecode = LISA.Ex.Code
    val esubc = LISA.Ex.Subc

    val page_ade = isADE
    val page_ale = isALE
    val page_invalid = hit && !found_lo.v
    val page_ppi = hit && found_lo.plv < csr.crmd.plv
    val page_modify = ifGen(cat == ReqType.data) {
      hit && !found_lo.d && st
    }

    if (cat == ReqType.fetch) {
      ex := page_ade || page_invalid || page_ppi
      when(page_ade) {
        ecode := LISA.Ex.ADEF.code
        esubc := LISA.Ex.ADEF.subc
      }.elsewhen(page_invalid) {
        ecode := LISA.Ex.PIF.code
        esubc := LISA.Ex.PIF.subc
      }.elsewhen(page_ppi) {
        ecode := LISA.Ex.PPI.code
        esubc := LISA.Ex.PPI.subc
      }.otherwise {
        ecode := U(0)
        esubc := U(0)
      }
    } else {
      ex := page_ade || page_ale || page_invalid || page_ppi || page_modify
      when(page_ade) {
        ecode := LISA.Ex.ADEM.code
        esubc := LISA.Ex.ADEM.subc
      }.elsewhen(page_ale) {
        ecode := LISA.Ex.ALE.code
        esubc := LISA.Ex.ALE.subc
      }.elsewhen(page_invalid) {
        when(st) {
          ecode := LISA.Ex.PIS.code
          esubc := LISA.Ex.PIS.subc
        }.otherwise {
          ecode := LISA.Ex.PIL.code
          esubc := LISA.Ex.PIL.subc
        }
      }.elsewhen(page_ppi) {
        ecode := LISA.Ex.PPI.code
        esubc := LISA.Ex.PPI.subc
      }.elsewhen(page_modify) {
        ecode := LISA.Ex.PME.code
        esubc := LISA.Ex.PME.subc
      }.otherwise {
        ecode := U(0)
        esubc := U(0)
      }
    }

    def isADE: Bool = {
      //TODO: cross 0x0... and 0x8... at plv3 should ADE, but if 0x8 hit dwm, ALE
      if (cat != ReqType.fetch) False//csr.crmd.plv === U(3) && vaddr.msb
      else vaddr(0, 2 bits).orR//csr.crmd.plv === U(3) && vaddr.msb || vaddr(0, 2 bits).orR
    }

    def isALE: Bool = {
      ifGen(cat != ReqType.fetch)(Vec.tabulate(4)(i => vaddr(0, i.bits).orR)(size))
    }

  }
  io.to.resp.hit := s1.hit
  io.to.resp.pt := s1.ptag
  io.to.resp.mat := s1.mat
  io.to.resp.ex := s1.ex
  io.to.resp.ecode := s1.ecode
  io.to.resp.esubc := s1.esubc

}