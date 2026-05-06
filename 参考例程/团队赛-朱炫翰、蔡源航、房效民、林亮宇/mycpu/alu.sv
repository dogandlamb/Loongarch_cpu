`include "mycpu.vh"
`include "pipeline_types.sv"
`include "core_defines.sv"
module alu
    import core_defines::*;
    import pipeline_types::*;
(
  input  wire [ 3:0] alu_op,
  input  wire [31:0] alu_src1,
  input  wire [31:0] alu_src2,
  output wire [31:0] alu_result
);

wire op_add;   //add operation
wire op_sub;   //sub operation
wire op_slt;   //signed compared and set less than
wire op_sltu;  //unsigned compared and set less than
wire op_and;   //bitwise and
wire op_nor;   //bitwise nor
wire op_or;    //bitwise or
wire op_xor;   //bitwise xor
wire op_sll;   //logic left shift
wire op_srl;   //logic right shift
wire op_sra;   //arithmetic right shift
wire op_lui;   //Load Upper Immediate
wire op_pcaddu12i;

// control code decomposition
assign op_add  = (alu_op == ADD);
assign op_sub  = (alu_op == SUB);
assign op_slt  = (alu_op == SLT);
assign op_sltu = (alu_op == SLTU);
assign op_and  = (alu_op == AND);
assign op_nor  = (alu_op == NOR);
assign op_or   = (alu_op == OR);
assign op_xor  = (alu_op == XOR);
assign op_sll  = (alu_op == SLL);
assign op_srl  = (alu_op == SRL);
assign op_sra  = (alu_op == SRA);
assign op_lui  = (alu_op == LUI);

wire [31:0] add_sub_result;
wire [31:0] slt_result;
wire [31:0] sltu_result;
wire [31:0] and_result;
wire [31:0] nor_result;
wire [31:0] or_result;
wire [31:0] xor_result;
wire [31:0] lui_result;
wire [31:0] sll_result;
wire [63:0] sr64_result;
wire [31:0] sr_result;


// 32-bit adder
wire [31:0] adder_a;
wire [31:0] adder_b;
wire        adder_cin;
wire [31:0] adder_result;
wire        adder_cout;

assign adder_a   = alu_src1;
assign adder_b   = (op_sub | op_slt | op_sltu) ? ~alu_src2 : alu_src2;  //src1 - src2 rj-rk
assign adder_cin = (op_sub | op_slt | op_sltu) ? 1'b1      : 1'b0;
assign {adder_cout, adder_result} = adder_a + adder_b + adder_cin;

// ADD, SUB result
assign add_sub_result = adder_result;

// SLT result
assign slt_result[31:1] = 31'b0;   //rj < rk 1
assign slt_result[0]    = (alu_src1[31] & ~alu_src2[31])
                        | ((alu_src1[31] ~^ alu_src2[31]) & adder_result[31]);

// SLTU result
assign sltu_result[31:1] = 31'b0;
assign sltu_result[0]    = ~adder_cout;

// bitwise operation
assign and_result = alu_src1 & alu_src2;
assign or_result  = alu_src1 | alu_src2;  //这里是个错误怎么还要和结果做与运算哈哈哈
assign nor_result = ~or_result;
assign xor_result = alu_src1 ^ alu_src2;
assign lui_result = alu_src2;

// SLL result
//SLL表示逻辑左移位，这里用<<这种抽象的命令，实际上就是让EDA工具自己的电路库来实现
assign sll_result = alu_src1 << alu_src2[4:0];   //rj << i5

// SRL, SRA result
//补充：
//逻辑右移高位补0，算数右移高位补充符号位
//Vivado中“>>”运算实际上是逻辑右移，自动补0，但是无法处理算数移位中需要高位补1的情况
//解决办法是对操作数进行高位扩展
//如果当前需要执行srl，或者sra但是移位的是正数，那么op_sra & alu_src1[31]使得高位补足0
//如果当前执行的是sra而且是负数，那么高32位补足1，然后使用自带的“>>”将高位补充的数移位到低32位中
//最后结果取sr64_result的低32位
assign sr64_result = {{32{op_sra & alu_src1[31]}}, alu_src1[31:0]} >> alu_src2[4:0]; //这里也是个错误，要用操作数2的低五位
                                                                                    //不过说实话我看不懂这里是什么意思呃呃呃

assign sr_result   = sr64_result[31:0];   //这里也是个错误，要取32位的嗷

// final result mux
assign alu_result = ({32{op_add|op_sub}} & add_sub_result)
                  | ({32{op_slt       }} & slt_result)
                  | ({32{op_sltu      }} & sltu_result)
                  | ({32{op_and       }} & and_result)
                  | ({32{op_nor       }} & nor_result)
                  | ({32{op_or        }} & or_result)
                  | ({32{op_xor       }} & xor_result)
                  | ({32{op_lui       }} & lui_result)
                  | ({32{op_sll       }} & sll_result)
                  | ({32{op_srl|op_sra}} & sr_result);

endmodule
