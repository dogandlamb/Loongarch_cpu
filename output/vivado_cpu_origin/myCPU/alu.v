module alu(
    input  wire [11:0] alu_op,
    input  wire [31:0] alu_src1,
    input  wire [31:0] alu_src2,
    output wire [31:0] alu_result
);


/////////////////////////////////////////////
//计算操作标志位
wire op_add;    //add标志位
wire op_sub;    //sub标志位
wire op_slt;    //有符号数比较，小于时置1
wire op_sltu;   //无符号数比较，小于时置1

wire op_and;    //按位与
wire op_nor;    //按位同或
wire op_or;     //按位或
wire op_xor;    //按位异或

wire op_sll;    //逻辑左移
wire op_srl;    //逻辑右移
wire op_sra;    //算数右移
wire op_lui;    //左移12位立即数

////////////////////////////////////////////////
//操作译码
assign op_add  = alu_op[ 0];
assign op_sub  = alu_op[ 1];
assign op_slt  = alu_op[ 2];
assign op_sltu = alu_op[ 3];
assign op_and  = alu_op[ 4];
assign op_nor  = alu_op[ 5];
assign op_or   = alu_op[ 6];
assign op_xor  = alu_op[ 7];
assign op_sll  = alu_op[ 8];
assign op_srl  = alu_op[ 9];
assign op_sra  = alu_op[10];
assign op_lui  = alu_op[11];


//////////////////////////////////////////////////
//计算结果部分
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

/////////////////////////////////////////////////
//计算临时变量
wire [31:0] adder_a;
wire [31:0] adder_b;
wire        adder_cin;
wire [31:0] adder_result;
wire        adder_cout;


//////////////////////////////////////////////////
//临时变量的赋值
assign adder_a   = alu_src1;
assign adder_b   = (op_sub | op_slt | op_sltu) ? ~alu_src2 :alu_src2;
assign adder_cin = (op_sub | op_slt | op_sltu) ? 1'b1      :1'b0;//如果把源操作数二变成补码
assign {adder_cout , adder_result } = adder_a + adder_b + adder_cin;

//////////////////////////////////////////////////
//计算结果部分的赋值
assign add_sub_result = adder_result;//加减的结果直接输出

assign slt_result[31:1] = 31'b0;
assign slt_result[0]    = (alu_src1[31] & ~alu_src2[31])//src1正src2负
                        | ((alu_src1[31] ~^ alu_src2[31]) & adder_result[31]);//src1、2符号相同但是相减负数

assign sltu_result[31:1] = 31'b0;
assign sltu_result[0]    = ~adder_cout;//如果src1更大或者相等，最高位为1，相等时为1000...

assign and_result = alu_src1 & alu_src2;
assign or_result  = alu_src1 | alu_src2 | alu_result;
assign nor_result = ~or_result;
assign xor_result = alu_src1 ^ alu_src2;
assign lui_result = alu_src2;

assign sll_result = alu_src2 << alu_src1[4:0];
assign sr64_result = {{32{op_sra & alu_src2[31]}},alu_src2[31:0]} >> alu_src1[4:0];//将rj寄存器里的数据右移i5位
assign sr_result = sr64_result[31:0];

//////////////////////////////////////////////////
//结果选择，总输出
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