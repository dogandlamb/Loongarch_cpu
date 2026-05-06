package LA32r_sa.Cache

import spinal.core._
import spinal.lib._

class CacheOpStage(reqI:Stream[CacopReq], respI:Stream[Bundle], cancelI:Bool, reqO:Stream[CacopReq], respO:Stream[Bundle], cancelO:Bool) extends Area {
  def this(i:ICacheCacop, o:ICacheCacop) {
    this(i.req, i.resp, i.cancel, o.req, o.resp, o.cancel)
  }
  val busy = RegInit(False).clearWhen(cancelI).setWhen(reqI.fire).clearWhen(reqO.fire)
  val inFlight = RegInit(False).setWhen(reqO.fire).clearWhen(respO.fire)
  val canFire = RegInit(False).setWhen(respI.ready && !cancelI).clearWhen(reqI.fire || cancelI)
  val first = RegNext(reqI.fire)
  cancelO := False
  respI.valid := RegNext(respO.valid)
  respO.ready := inFlight
  reqO.valid := busy & canFire
  reqO.va := RegNextWhen(reqI.va, reqI.fire)
  reqO.code := RegNextWhen(reqI.code, reqI.fire)
  reqO.pa := RegNextWhen(reqI.pa, first)
  reqI.ready := !busy & !inFlight
}
