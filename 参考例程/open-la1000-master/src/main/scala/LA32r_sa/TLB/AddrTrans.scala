package LA32r_sa.TLB

import LA32r_sa.Back._
import LA32r_sa.LISA
import spinal.core._
import spinal.lib._

import scala.language.postfixOps

case class AddrTransConfig(srch_port: Int,
                           cat: ReqType.E) extends Bundle {
}

class AddrTransReq(cat: ReqType.E) extends Bundle {
  val va = UInt(LISA.w_gpr.bits) //vaddr
  val st = ifGen(cat == ReqType.data)(Bool())
  val size = ifGen(cat != ReqType.fetch)(UInt(2.bits))
}

class TlbCsr(IDXBit: Int, PPNBit: Int) extends Bundle {
  val crmd = new CsrCRMD
  val tlbidx = new CsrTLBIDX(IDXBit)
  val asid = new CsrASID
  val tlbehi = new CsrTLBEHI
  val estat = new CsrESTAT
  val tlbelo = Vec(new CsrTLBELO(PPNBit), 2)
  val dmw = Vec(new CsrDMW, 2)

  def toTlbEHi(): TlbEHi = {
    val hi = new TlbEHi
    hi.e := !tlbidx.ne || estat.ecode === LISA.Ex.INT.code
    hi.vppn := tlbehi.vppn
    hi.ps := tlbidx.ps === LISA.PSHuge
    hi.asid := asid.asid
    hi.g := tlbelo.map(_.g).reduce(_ && _)
    hi
  }

  def collect(csr: Csr) {
    crmd := csr.crmd
    estat := csr.estat
    tlbidx := csr.tlbidx
    asid := csr.asid
    tlbehi := csr.tlbehi
    tlbelo(0) := csr.tlbelo0
    tlbelo(1) := csr.tlbelo1
    dmw(0) := csr.dmw0
    dmw(1) := csr.dmw1
  }
}

class AddrTransResp(PPNLen: Int) extends Bundle {
  val hit = Bool()
  val pt: UInt = UInt(PPNLen.bits) //ptag
  val mat = UInt(2 bits)
  val ex = Bool()
  val ecode: UInt = LISA.Ex.Code
  val esubc: UInt = LISA.Ex.Subc

  def assignedFrom(pa: UInt, mat: UInt, hit: Bool): this.type = {
    this.hit := hit
    this.pt := pa(pa.high downto pa.getWidth - PPNLen)
    this.mat := mat
    this.ex := False
    this.ecode := U(0)
    this.esubc := U(0)
    this
  }
}

class AddrTrans(param: TLBParam, config: AddrTransConfig) extends Component {
  val io = new Bundle {
    val from = new Bundle {
      val csr = in(new TlbCsr(param.IDXBit, param.PPNLen))
      val request = Vec(slave(Stream(new AddrTransReq(config.cat))), config.srch_port)
      val l2_tlb = slave(new L2ToL1TLB(param))
    }
    val to = new Bundle {
      val response = Vec(out(new AddrTransResp(param.PPNLen)), config.srch_port)
    }
  }

  val DMW_NUM = io.from.csr.dmw.size

  val csr = io.from.csr
  /** entities of L1TLB */
  val l1_tlb = Array.fill(config.srch_port)(new L1TLB(param, cat = config.cat))

  val s0 = new Bundle {
    for (i <- 0 until config.srch_port) { //trans to L1 srch
      io.from.request(i).ready := True
      l1_tlb(i).io.from.srch.valid := io.from.request(i).valid
      l1_tlb(i).io.from.srch.vaddr := io.from.request(i).va
      if (config.cat != ReqType.fetch) { l1_tlb(i).io.from.srch.size := io.from.request(i).size }
      if (config.cat == ReqType.data) { l1_tlb(i).io.from.srch.st := io.from.request(i).st }
      l1_tlb(i).io.from.l2_tlb.fillback := io.from.l2_tlb.fillback
      l1_tlb(i).io.from.l2_tlb.invalidate := io.from.l2_tlb.invalidate
      l1_tlb(i).io.from.l2_tlb.entry := io.from.l2_tlb.entry
      l1_tlb(i).io.from.l2_tlb.idx := io.from.l2_tlb.idx

      l1_tlb(i).io.csr := csr
    }
    val dmw_hit = Vec(Bits(DMW_NUM bits), config.srch_port)

    for (i <- 0 until config.srch_port) {
      for (j <- 0 until DMW_NUM) {
        dmw_hit(i)(j) := csr.dmw(j).compare(io.from.request(i).va, csr.crmd.plv)
      }
    }
  }

  val PLRU = new Area {
    val idx = Bits(param.L1Size.bits) setAsReg() init (1)
    //FIXME: will use Pseudo Least Recent Use Algorithm
    idx := idx.rotateRight(1)

    io.from.l2_tlb.plru_idx := idx
  }

  val s1 = new Bundle {
    val valid = Bits(config.srch_port bits) setAsReg() init (0)
    val vaddr = Vec(LISA.GPR, config.srch_port) setAsReg()
    val size = ifGen(config.cat != ReqType.fetch)(RegNext(Vec(io.from.request.map(req => req.size))))

    valid := io.from.request.map(req => req.fire).asBits
    vaddr := Vec(io.from.request.map(req => req.va))

    val addr_trans_resp = Vec(new AddrTransResp(param.PPNLen), config.srch_port)

    val dmw_hit = RegNext(s0.dmw_hit)
    val dmw_hit_mat = Vec(UInt(2 bits), config.srch_port)
    val dmw_hit_pseg = Vec(UInt(3 bits), config.srch_port)
    val dmw_mat = Range(0, DMW_NUM).map(i => csr.dmw(i).mat)
    val dmw_pseg = Range(0, DMW_NUM).map(i => csr.dmw(i).pseg)

    for (i <- 0 until config.srch_port) {
      dmw_hit_mat(i) := MuxOH.or(dmw_hit(i), dmw_mat)
      dmw_hit_pseg(i) := MuxOH.or(dmw_hit(i), dmw_pseg)
    }

    for (i <- 0 until config.srch_port) {
      when(io.from.csr.crmd.da) {
        addr_trans_resp(i).hit := True
        if (config.cat == ReqType.fetch) {
          addr_trans_resp(i).mat := csr.crmd.datf
        } else {
          addr_trans_resp(i).mat := csr.crmd.datm
        }
        addr_trans_resp(i).pt := vaddr(i).drop(LISA.PSMin).asUInt.resized

      }.elsewhen(dmw_hit(i).orR) {
        addr_trans_resp(i).hit := True
        addr_trans_resp(i).mat := dmw_hit_mat(i)
        addr_trans_resp(i).pt := (dmw_hit_pseg(i) @@ vaddr(i).drop(LISA.PSMin).dropHigh(3).asUInt).resized
      }.otherwise {
        addr_trans_resp(i).hit := l1_tlb(i).io.to.resp.hit
        addr_trans_resp(i).mat := l1_tlb(i).io.to.resp.mat
        addr_trans_resp(i).pt := l1_tlb(i).io.to.resp.pt
      }

      when(csr.crmd.da || dmw_hit(i).orR) {
        val ale = isALE(i)
        addr_trans_resp(i).ex := ale
        when(ale) {
          if (config.cat == ReqType.fetch) {
            addr_trans_resp(i).ex := True
            addr_trans_resp(i).ecode := LISA.Ex.ADEF.code
            addr_trans_resp(i).esubc := LISA.Ex.ADEF.subc
          } else {
            addr_trans_resp(i).ex := True
            addr_trans_resp(i).ecode := LISA.Ex.ALE.code
            addr_trans_resp(i).esubc := LISA.Ex.ALE.subc
          }
        }.otherwise {
          addr_trans_resp(i).ex := False
          addr_trans_resp(i).ecode := U(0)
          addr_trans_resp(i).esubc := U(0)
        }
      }.otherwise {
        addr_trans_resp(i).ex := l1_tlb(i).io.to.resp.ex
        addr_trans_resp(i).ecode := l1_tlb(i).io.to.resp.ecode
        addr_trans_resp(i).esubc := l1_tlb(i).io.to.resp.esubc
      }
    }

    def isALE(idx: Int): Bool = {
      if (config.cat != ReqType.fetch) {
        Vec.tabulate(4)(i => vaddr(idx)(0, i.bits).orR)(size(idx))
      } else {
        vaddr(idx)(0, 2 bits).orR
      }
    }

    assert(
      assertion = io.from.csr.crmd.da ^ io.from.csr.crmd.pg,
      message = "[Csr]: da & pg not set correctly!",
      severity = FAILURE
    )

  }
  io.to.response := s1.addr_trans_resp
}