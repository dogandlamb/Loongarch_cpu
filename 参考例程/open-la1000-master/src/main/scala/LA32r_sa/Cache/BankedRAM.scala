package LA32r_sa.Cache

import spinal.core._
import spinal.lib._

case class BankedRAMPortParam(size:Int, border:Int = -1, read:Boolean = true, write:Boolean = true){
  require(size > 0 && (size <= (1 << border) || border == -1))
}

class BankedRAM[T <: Data](idxBits:Int, bankBits:Int, bankType:HardType[T], pullRAMs:Boolean, portParams:BankedRAMPortParam*) extends Component {
  def this(idxBits:Int, bankBits:Int, bankType: HardType[T], portParams:BankedRAMPortParam*){
    this(idxBits, bankBits, bankType, false, portParams:_*)
  }
  require(portParams.forall(p => p.border == -1 || p.border >= bankBits))
  val bankSize = bankType.getBitsWidth
  val addrBits = idxBits + bankBits
  val bankNum = 1 << bankBits
  val ports = Vec(portParams.map(p => slave(BankedRAMPort(addrBits, bankType, p))))
  val banks = Vec(RAMPort(idxBits, bankSize), bankNum)
  if(!pullRAMs) banks.foreach(_.deploy())
  else banks.foreach(_.toTop())
  // bankSel[ports][port offset][bank]
  val bankSelExt = Vec(ports.map { p =>
    require(p.p.size <= (1 << bankBits))
    val addrShift = p.addr(0 until bankBits)
    Vec.tabulate(p.p.size){ i =>
      val shift = B(1 << i, (2 * bankNum).bits) |<< addrShift
      shift & Cat(Repeat(!p.truncate, bankNum), Repeat(True, bankNum))
    }
  })
  val bankSel = bankSelExt.map(_.map(b => b.take(bankNum) | b.drop(bankNum)))
  val bankEn = (bankSel zip ports).foldLeft(B(0, bankNum.bits)){case(bankUse, (bankSel, p)) =>
    val targetBank = bankSel.reduce(_|_)
    p.ready := (bankUse & targetBank) === 0
    Mux(p.fire, bankUse | targetBank, bankUse)
  }
  val bankAccess = (bankSelExt zip ports).map{case(sel, p) => sel.map(_.asBools.map(_ & p.fire))}
  (0 until bankNum).foreach { i =>
    val access = bankAccess.map(_.map(_ (i)))
    val accessWrap = bankAccess.map(_.map(_ (i + bankNum)))
    banks(i).en := bankEn(i)
    banks(i).addr := MuxOH.or(access.map(_.reduce(_|_)) ++ accessWrap.map(_.reduce(_|_)),
      ports.map(_.addr.drop(bankBits).asUInt) ++ ports.map(_.addr.drop(bankBits).asUInt + 1))
    banks(i).wen := MuxOH.or((access.map(_.reduce(_|_)) zip accessWrap.map(_.reduce(_|_))).map { case (a,b) => a|b },
      ports.map(_.wen))
    banks(i).wdata := MuxOH.or((access.flatten zip accessWrap.flatten).map{case(a,b) => a | b},
      ports.flatMap(_.wdata)).asBits
  }
  (bankSel zip ports).foreach{case (sel, p) =>
    (sel zip p.rdata).foreach{ case (sel, data) =>
      data assignFromBits MuxOH.or(RegNext(sel), banks.map(_.rdata))
    }
  }
}

class BankedRAM1W1R[T <: Data](idxBits:Int, bankBits:Int, bankType:HardType[T], pullRAMs:Boolean, portParams:BankedRAMPortParam*) extends Component {
  def this(idxBits:Int, bankBits:Int, bankType: HardType[T], portParams:BankedRAMPortParam*){
    this(idxBits, bankBits, bankType, false, portParams:_*)
  }
  val bankSize = bankType.getBitsWidth
  val addrBits = idxBits + bankBits
  val bankNum = 1 << bankBits
  val ports = Vec(portParams.map(p => slave(BankedRAMPort(addrBits, bankType, p))))
  val banks = Vec(RAMPort1W1R(idxBits, bankSize), bankNum)
  if(!pullRAMs) banks.foreach(_.deploy())
  else banks.foreach(_.toTop())

  val bankSelExt = Vec(ports.map { p =>
    require(p.p.size <= (1 << bankBits))
    val addrShift = p.addr(0 until bankBits)
    Vec.tabulate(p.p.size){ i =>
      val shift = B(1 << i, (2 * bankNum).bits) |<< addrShift
      shift & Cat(Repeat(!p.truncate, bankNum), Repeat(True, bankNum))
    }
  })
  val bankSel = bankSelExt.map(_.map(b => b.take(bankNum) | b.drop(bankNum)))
  val bankEn = (bankSel zip ports).foldLeft((B(0, bankNum.bits), B(0, bankNum.bits))){case((rUse, wUse), (sel, p)) =>
    val targetBank = sel.reduce(_|_)
    val use = (p.p.read, p.p.write) match {
      case (true, true) => Mux(p.wen, wUse, rUse)
      case (true, false) => rUse
      case (false, true) => wUse
      case (false, false) => Bits(bankNum.bits).setAll()
    }
    p.ready := (use & targetBank) === 0
    (if(p.p.read) Mux(p.fire & !p.wen, rUse | targetBank, rUse) else rUse,
      if(p.p.write) Mux(p.fire & p.wen, wUse | targetBank, wUse) else wUse)
  }
  val bankRead = (bankSelExt zip ports).map{case(sel, p) => sel.map(_.asBools.map(s => if(p.p.read) s & p.fire & !p.wen else False))}
  val bankWrite = (bankSelExt zip ports).map{case(sel, p) => sel.map(_.asBools.map(s => if(p.p.write) s & p.fire & p.wen else False))}
  (0 until bankNum).foreach { i =>
    val RAccess = bankRead.map(_.map(_ (i)))
    val RAccessWrap = bankRead.map(_.map(_ (i + bankNum)))
    val WAccess = bankWrite.map(_.map(_ (i)))
    val WAccessWrap = bankWrite.map(_.map(_ (i + bankNum)))
    banks(i).ren := bankEn._1(i)
    banks(i).raddr := MuxOH.or(RAccess.map(_.reduce(_|_)) ++ RAccessWrap.map(_.reduce(_|_)),
      ports.map(_.addr.drop(bankBits).asUInt) ++ ports.map(_.addr.drop(bankBits).asUInt + 1))
    banks(i).wen := bankEn._2(i)
    banks(i).waddr := MuxOH.or(WAccess.map(_.reduce(_|_)) ++ WAccessWrap.map(_.reduce(_|_)),
      ports.map(_.addr.drop(bankBits).asUInt) ++ ports.map(_.addr.drop(bankBits).asUInt + 1))
    banks(i).wdata := MuxOH.or((WAccess.flatten zip WAccessWrap.flatten).map{case(a,b)=>a|b},
      ports.flatMap(_.wdata)).asBits
  }
  (bankSel zip ports).foreach{case (sel, p) =>
    (sel zip p.rdata).foreach{ case (sel, data) =>
      data assignFromBits MuxOH.or(RegNext(sel), banks.map(_.rdata))
    }
  }
}

case class BankedRAMPort[T <: Data](addrBits:Int, bankType:HardType[T], p: BankedRAMPortParam) extends Bundle with IMasterSlave {
  val valid = Bool()
  val ready = Bool()
  val addr = UInt(addrBits.bits)
  val wen = Bool()
  val rdata = Vec(bankType, p.size)
  val wdata = Vec(bankType, p.size)

  override def asMaster(): Unit = {
    out(this)
    in(ready, rdata)
  }
  def truncate = if(p.border == -1) False else addr(log2Up(p.size) until p.border).andR
  def count = Mux(truncate, ~addr.resize(log2Up(p.size)) ,U(p.size - 1))
  def count(addr:UInt, border:Int) =
    Mux(addr(log2Up(p.size) until border).andR, ~addr.resize(log2Up(p.size)) ,U(p.size - 1))
  def fire = valid & ready

  if(!p.read) when(valid) {assert(wen)}
  if(!p.write) when(valid) {assert(!wen)}
}

case class RAMPort(addrBits:Int, dataBits:Int) extends Bundle with IMasterSlave {
  val en = Bool()
  val addr = UInt(addrBits.bits)
  val wen = Bool()
  val rdata = Bits(dataBits.bits)
  val wdata = Bits(dataBits.bits)

  override def asMaster(): Unit = {
    out(this)
    in(rdata)
  }

  def deploy():Unit = {
    val mem = Mem(Bits(dataBits.bits), 1 << addrBits).setCompositeName(this, "RAM")
    rdata := mem.readWriteSync(addr, wdata, en, wen)
  }

  def toTop():Unit = {
    Pull.toTopOutput(en)
    Pull.toTopOutput(addr)
    Pull.toTopOutput(wen)
    Pull.toTopOutput(wdata)
    Pull.driveFromTopInput(rdata)
  }
}

case class RAMPort1W1R(addrBits:Int, dataBits:Int, forward:Boolean = true) extends Bundle with IMasterSlave {
  val ren = Bool()
  val raddr = UInt(addrBits.bits)
  val rdata = Bits(dataBits.bits)
  val wen = Bool()
  val waddr = UInt(addrBits.bits)
  val wdata = Bits(dataBits.bits)

  override def asMaster(): Unit = {
    out(this)
    in(rdata)
  }

  def deploy():Unit = {
    val mem = Mem(Bits(dataBits.bits), 1 << addrBits).setCompositeName(this, "RAM")
    if(forward) rdata := Mux(RegNext(wen && waddr === raddr), RegNext(wdata), mem.readSync(raddr, ren))
    else rdata := mem.readSync(raddr, ren)
    mem.write(waddr, wdata, wen)
  }

  def toTop():Unit = {
    Pull.toTopOutput(ren)
    Pull.toTopOutput(raddr)
    Pull.toTopOutput(wen)
    Pull.toTopOutput(wdata)
    Pull.toTopOutput(waddr)
    Pull.driveFromTopInput(rdata)
  }
}

object GenBankedRAM {
  def main(args: Array[String]): Unit = {
    SpinalConfig(mode = Verilog, removePruned = true).generate(new BankedRAM(8,0, UInt(32.bits), BankedRAMPortParam(1))).printPruned()
  }
}

