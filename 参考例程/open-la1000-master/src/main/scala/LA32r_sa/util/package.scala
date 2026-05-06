package LA32r_sa

import spinal.core._
import spinal.lib._

import scala.collection.Seq

package object util {
  implicit class WithValidIf[T <: Data](data: T){
    def validIf(cond: Bool): T = {
      (data.asBits & cond.rep(data.asBits.getWidth)).as(data)
    }
  }
  implicit class WithRep[T <: Data](data: T){
    def rep(times: Int): Bits = {
      assert(times <= 0xffff, "rep too many times")
      Cat(Seq.fill(times)(data))
    }
  }
  implicit class SelVec[T <: Data](vec: Vec[T]){
    def apply(addr: UInt, count: Int, wrap:Boolean = false): Vec[T] ={
      val width = vec.head.getBitsWidth
      require(vec.forall(_.getBitsWidth == width))
      val extend = if(wrap){
        Cat(Seq.tabulate(count + (1 << addr.getWidth) - 1){ i => vec(i % vec.size) })
      }else{
        vec.asBits.resize((count + (1 << addr.getWidth) - 1) * width)
      }
      Vec(addr.asBools.zipWithIndex.foldRight(extend){case ((b, i), v) =>
        Mux(b, v((1 << i) * width, ((count + (1 << i) - 1) * width).bits), v(0, ((count + (1 << i) - 1) * width).bits))
      }.subdivideIn(width.bits).map(_.as(vec.head)))
    }
  }
  implicit class WithParaScan[T <: Data](data: Seq[T]){
    val size = data.size
    def paraScan(op: (T,T)=>T): Seq[T] = {
      if(size <= 1){
        data
      }
      else{
        val left = data.take(size / 2).paraScan(op)
        val right = data.drop(size / 2).paraScan(op)
        left ++ right.map(op(_,left.last))
      }
    }
  }
  implicit class WithConnectAllByName[T <: Bundle](a: T){
    def connectAllByName(b: T): Unit = {
      a.elements.foreach{ case (name, data) =>
        val other = b.find(name)
        require(other != null, name + "not find")
        data match {
          case data: Bundle => data.connectAllByName(other.asInstanceOf[Bundle])
          case _ =>
            require(!data.isDirectionLess, name + "has no direction")
            if(data.isInput) data := other
            if(data.isOutput) other := data
        }
      }
    }
  }
  implicit class SeqAsBits(a:Seq[Bool]){
    def |(b:Seq[Bool]) = {
      (a zip b).map{case(a,b) => a|b}
    }
    def &(b:Seq[Bool]) = {
      (a zip b).map{case(a,b) => a&b}
    }
  }
}
