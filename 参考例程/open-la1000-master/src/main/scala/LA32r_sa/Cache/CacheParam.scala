package LA32r_sa.Cache

import spinal.core.log2Up

trait CacheParam{
  def nWay: Int = 2
  def idxBits: Int = 8
  def offsetBits: Int = 6
  def lgnBank: Int = 3
  def bankWidth:Int = 32
  def dataWidth: Int = 64
  def busWidth: Int = 32
  def unCacheWidth: Int = dataWidth
  def infoWidth: Int = 4
  def VABits: Int = 32
  def PABits: Int = 32
  def wayBits = log2Up(nWay)
  def lgWaySize = idxBits + offsetBits
  def nBank = 1 << lgnBank
  def bankOffsetBits = log2Up(bankWidth / 8)
  def bankIdxBits = lgWaySize - lgnBank - bankOffsetBits
  def dataOffsetBits = log2Up(dataWidth / 8)
  def dataIdxBits = lgWaySize - bankOffsetBits
  def busOffsetBits= log2Up(busWidth / 8)
  def lineBurst = (8 << offsetBits) / busWidth
  def unCacheBurst = (dataWidth + busWidth - 1) / busWidth
  def piBits = Math.min(lgWaySize, 12)
  def tagBits = PABits - piBits
  def pageColorBits = lgWaySize - piBits //Math.max(idxBits + offsetBits - 12, 0)
  require(dataWidth % bankWidth == 0)
  require(busWidth % bankWidth == 0)
  require((nWay & (nWay - 1)) == 0, "nWay not power of 2")
}

case class ICacheParam(
                        instNum:Int = 4,
                        override val nWay: Int = 2,
                        override val idxBits: Int = 8,
                        override val offsetBits: Int = 6,
                        override val lgnBank: Int = 3,
                        override val bankWidth:Int = 32,
                        override val busWidth: Int = 32,
                        override val infoWidth: Int = 4,
                        override val VABits: Int = 32,
                        override val PABits: Int = 32
                      ) extends CacheParam {
  override val unCacheWidth: Int = 32
  override val dataWidth: Int = instNum * 32

}

case class DCacheParam(
                        override val nWay: Int = 2,
                        override val idxBits: Int = 8,
                        override val offsetBits: Int = 6,
                        override val lgnBank: Int = 3,
                        override val bankWidth:Int = 32,
                        override val dataWidth: Int = 64,
                        override val busWidth: Int = 32,
                        override val infoWidth: Int = 4,
                        override val VABits: Int = 32,
                        override val PABits: Int = 32
                      ) extends CacheParam {

}
