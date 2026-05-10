package LA32r_sa.Back

import LA32r_sa.Param
import LA32r_sa.util._
import spinal.core._

class ALU(width:Int = 32) extends Component {
  def this()(implicit p:Param){
    this(p.isa_width)
  }
  import ALUCode._
  val a, b= in(UInt(width.bits))
  val op = in(ALUCode())
  val result = out(UInt(width.bits))

  // op decoder
  private val alu_lu12i      = op === LU12I
  private val alu_add        = op === ADD || op === PCADDU12I
  private val alu_sub        = op === SUB
  private val alu_and        = op === AND
  private val alu_or         = op === OR
  private val alu_xor        = op === XOR
  private val alu_nor        = op === NOR
  private val alu_slt        = op === SLT
  private val alu_sltu       = op === SLTU
  private val alu_sll        = op === SLL
  private val alu_srl        = op === SRL
  private val alu_sra        = op === SRA

  // lui res
  // val lu32i_res =a(0 to 31);
  // val lu52i_res =Cat(b(52 to 63),a(0 to 51));
  val lu12i_res =b

  // invert b for subtractions (sub & slt)
  val invb = alu_sub | alu_slt | alu_sltu
  // select addend according to invb
  val addend =invb ? (~b) | b

  // result for addition and subtraction
  val add_sub_res_d = UInt((width + 1).bits)
  val add_sub_res = UInt(width.bits)
  // carryout flag for addition
  def cf = add_sub_res_d.msb
  // do addition (invb as carryin in subtraction)
  add_sub_res_d := a +^ addend + invb.asUInt(width.bits)
  add_sub_res :=  add_sub_res_d(0 until width)
  // calculate overflow flag
  val of = a.msb ^ addend.msb^ cf ^ add_sub_res.msb
  // do and operation
  val and_res =a & b
  // do andn operation
//  val andn_res =a & (~b)
  // do or operation
  val or_res =a | b
  // do or operation
//  val orn_res =a | (~b)
  // do xor operation
  val xor_res =a ^ b
  // do nor operation
  val nor_res = ~or_res
  // set slt/sltu result according to subtraction result
  val slt_res =(add_sub_res.msb ^ of).asUInt(width.bits)
  val sltu_res =(!cf).asUInt(width.bits)
  // do sll operation
  val sll_res = a |<< b(0 to 4)
  // do srl&sra operation
  val sr_temp =Cat((alu_sra & a.msb).rep(width), a) >> b(0 to 4)
  val sr_res = sr_temp(0 until width).asUInt

  result := MuxOHDefault.zero(
    alu_lu12i -> lu12i_res ,
    alu_and -> and_res ,
    alu_or -> or_res ,
    alu_xor -> xor_res ,
    alu_nor -> nor_res ,
    alu_add  -> add_sub_res ,
    alu_sub -> add_sub_res ,
    alu_slt -> slt_res ,
    alu_sltu -> sltu_res ,
    alu_sll -> sll_res ,
    alu_srl -> sr_res ,
    alu_sra -> sr_res
  )
}
