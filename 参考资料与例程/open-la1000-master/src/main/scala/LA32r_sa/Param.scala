package LA32r_sa

import LA32r_sa.Back.ExcpCode
import LA32r_sa.Cache.{DCacheParam, ICacheParam}
import LA32r_sa.Front._
import LA32r_sa.TLB.TLBParam
import spinal.core._

case class Param(
                  core_id : Int = 0,
                  inst_num: Int = 4,
                  iqueue_ptr_width: Int = 2,
                  raminit_width: Int = 8,
                  PA_width:Int = 36,
                  btb: BTBParam = BaseBTB(),
                  jhr: JHRParam = JHRParam(),
                  jtb: JTBParam = BaseJTB(),
                  bht: BHTParam = TageBHT(),
                  phr:PHRParam = PHRParam(),
                  dCache:DCacheParam = DCacheParam(),
                  iCache:ICacheParam = ICacheParam(),
                  tlb:TLBParam = TLBParam(),
                  rand_width: Int = 16,
                  rand_seed: Int = 0x1a,
                  ex2BRU: Boolean = false,
                  cancelStage: Boolean = true,
                  csrStage: Boolean = true,
                  intStage: Boolean = true,
                  pullRAMS: Boolean = false
                ) {
  require(!csrStage || cancelStage)
//  require(!pullRAMS)
  val isa_width: Int = 32
  val dataWidth:Int = 64
  val dCacheParam = dCache.copy(PABits = PA_width, VABits = isa_width, dataWidth = 64)
  val iCacheParam = iCache.copy(PABits = PA_width, VABits = isa_width, instNum = inst_num,
    busWidth = dCacheParam.busWidth, infoWidth = dCacheParam.infoWidth)
  val tlbParam = tlb.copy(PALen = PA_width)
  val cache_align = iCacheParam.offsetBits - 2

  val tlbidx_width = tlbParam.IDXBit
  val excpCode_width: Int = ExcpCode.codeWidth
  val port_num: Int = 3
  val res_width = isa_width - 2
  val count_width_nz = log2Up(inst_num)
  val ppn_width = PA_width - 12
  val vppn_width = isa_width - 13
  def hint_width = math.max(bht.hint_width(this), jtb.hint_width(this)) + 2 * count_width_nz
  def bhr_width = bht.bhr_width(this)
  val use_jhr = Seq(btb, bht, jtb).map(_.use_jhr).reduce(_ | _)
  val use_bhr = Seq(btb, bht, jtb).map(_.use_bhr).reduce(_ | _)
  val use_phr = Seq(btb, bht, jtb).map(_.use_phr).reduce(_ | _)
  val use_rand = Seq(btb, bht, jtb).map(_.use_rand).reduce(_ | _)
  val ras_res_width = isa_width - 2
  val ras_ptr_widths = Seq(2,1,4)
}

object Param{
  val chipLabParam = Param(
    dCache = DCacheParam(busWidth = 64, lgnBank = 1, offsetBits = 6, idxBits = 6),
    iCache = ICacheParam(lgnBank = 2, offsetBits = 6, idxBits = 6),
    tlb = TLBParam(L1Size = 8, L2Way = 4, L2Set = 4),
    csrStage = false,
    cancelStage = false,
    intStage = false,
  )
  val FPGAParam = Param(
    dCache = DCacheParam(lgnBank = 1, offsetBits = 4, idxBits = 8),
    iCache = ICacheParam(lgnBank = 2, offsetBits = 4, idxBits = 8),
    tlb = TLBParam(L1Size = 8),
    csrStage = false,
    // cancelStage = false,
  )
  val funcParam = Param(
    dCache = DCacheParam(busWidth = 64, lgnBank = 1, offsetBits = 7, idxBits = 5),
    iCache = ICacheParam(lgnBank = 2, offsetBits = 7, idxBits = 5),
    tlb = TLBParam(L1Size = 8, L2Way = 16, L2Set = 1),
  )
  val ASICParam = Param(
    dCache = DCacheParam(lgnBank = 1, offsetBits = 4, idxBits = 8),
    iCache = ICacheParam(lgnBank = 2, offsetBits = 4, idxBits = 8),
    tlb = TLBParam(L1Size = 8),
    csrStage = false,
    cancelStage = false,
    intStage = false,
    pullRAMS = true
  )
}