package LA32r_sa.Cache

import spinal.core._
import spinal.core.sim._
import spinal.lib._

import scala.util.Random

abstract class Replacement extends Bundle {
  def access(way:Bits): Replacement = this
  def choose: Bits
  def release(way:Bits):Replacement = this
}

case class TreeLRU(nWay: Int) extends Replacement{
  require((nWay & (nWay - 1)) == 0, "nWay must be power of 2")
  val state = B(0,(nWay - 1).bits)
  def nextState(state:Bits, way:Bits):(Bool, Bits) = {
    require(way.getWidth == state.getWidth + 1)
    val size = way.getWidth
    if(size <= 2){
      (way(0) | way(1), (state(0) & ~way(1) | way(0)).asBits)
    }else{
      val (lAcc, lState) = nextState(state.dropLow(size/2), way.dropLow(size/2))
      val (rAcc, rState) = nextState(state.dropHigh(size/2), way.dropHigh(size/2))
      (lAcc | rAcc, Cat(lState, state(size/2 - 1) & ~lAcc | rAcc, rState))
    }
  }
  override def access(way: Bits):TreeLRU = {
    val next = TreeLRU(nWay)
    next.state.removeAssignments()
    next.state := nextState(state, way)._2
    next
  }

  override def choose:Bits = {
    def recurse(state:Bits, choose:Bool):Bits = {
      val size = state.getWidth
      if(size <= 1){
        Cat(state(0) & choose, ~state(0) & choose)
      }else{
        Cat(recurse(state.takeHigh(size/2), state(size/2) & choose), recurse(state.takeLow(size/2), ~state(size/2) & choose))
      }
    }
    recurse(state, True)
  }
}

case class LRUAlter(nWay:Int) extends Replacement{
  require((nWay & (nWay - 1)) == 0, "nWay must be power of 2")
  val state = Vec.tabulate(nWay)(U(_, log2Up(nWay).bits))
  override def access(way: Bits):LRUAlter = {
    assert((way.asUInt & (way.asUInt - U(1))) === 0, "way should be one hot")
    val hit_way = OHMux.or(way, state)
    val next = LRUAlter(nWay)
    next.state.removeAssignments()
    (next.state zip state zip way.asBools).foreach{case ((next, now), hit) =>
      next := Mux(hit, U(nWay - 1), Mux(now > hit_way, now - 1, now) )
    }
    next
  }

  override def choose:Bits = {
    Cat(state.map(_ === 0))
  }
}

case class LRU(nWay:Int) extends Replacement{
  val state = Vec.tabulate(nWay)(U(_, log2Up(nWay).bits))
  override def access(way: Bits):LRU = {
    val idx = OHToUInt(way)
    val hit = state.map(_ === idx)
    val shift = hit.tail.scanLeft(hit.head)(_|_)
    val next = LRU(nWay)
    next.state.removeAssignments()
    (next.state.iterator zip (state :+ idx).sliding(2) zip shift.iterator).foreach{
      case ((state, Seq(cur, next)), shift) => state := Mux(shift, next, cur)
    }
    next
  }

  override def choose:Bits = {
    UIntToOh(state.head)
  }
}

object ReplacementTest{
  def apply(gen:Int => Replacement, nWays:Int = 8, accessRatio:Double = 0.5, tolerance:Int = -1, testSize:Int = 100, repeat:Int = 1):Unit = {
    val compiled = SimConfig.compile(new Module {
      val way = in(Bits(nWays.bits))
      val access = in(Bool())
      val rep:Replacement = RegInit(gen(nWays))
      rep := Mux(access, rep.access(way), rep.release(way))
//      when(access){rep := rep.access(way)}
      val choose = out(rep.choose)
    })
    (0 until repeat).foreach(i => compiled.doSim("Test"+i){ dut =>
      dut.clockDomain.forkStimulus(period = 10)
      val acctime = scala.collection.mutable.Seq.fill(nWays)(0)
      val rank_cnt = scala.collection.mutable.Seq.fill(nWays)(0)
      for (time <- 1 to testSize){
        val way = Random.nextInt(nWays)
        dut.way #= 1 << way
        val access = Random.nextDouble() < accessRatio
        dut.access #= access
        dut.clockDomain.waitSampling()
        val choose = dut.choose.toInt
        assert((choose & (choose - 1)) == 0 && choose != 0, "choose multiple way")
        val age_rank = acctime.count(_ < acctime(log2Up(choose)))
        println(acctime, way, log2Up(choose), age_rank)
        assert(tolerance < 0 || age_rank <= tolerance, "choose bad result")
        rank_cnt.update(age_rank, rank_cnt(age_rank) + 1)
        acctime.update(way, if(access) time else 0)
      }
      println(rank_cnt)
    })
  }
}

object TestReplacement {
  def main(args: Array[String]): Unit = {
    ReplacementTest(TreeLRU, 8, 0.5, 4, 100000,5)
  }
}
