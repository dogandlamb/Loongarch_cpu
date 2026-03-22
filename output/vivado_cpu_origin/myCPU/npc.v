module npc(
    input  wire        valid,
    input  wire        rj_eq_rd,
    input  wire [ 4:0] br_op,
    input  wire [31:0] br_offs,
    input  wire [31:0] rj_value,
    input  wire [31:0] pc,
    output wire [31:0] nextpc
);

//分支跳转
wire [31:0] br_target;//跳转的目标地址
wire [31:0] seq_pc;//pc+4的值，顺序执行时的下一条指令地址
wire        br_taken;//需要跳转的标志位


/////////////////////////////////////////////////////////////////////
//EX:分支跳转地址的计算
//寄存器读地址和写地址的生成
//br_op = {inst_jirl , inst_b , inst_bl , inst_beq , inst_bne};
assign br_taken  = ((br_op[1] &  rj_eq_rd)
                 |  (br_op[0] & !rj_eq_rd)
                 |   br_op[4]
                 |   br_op[2]
                 |   br_op[3])
                 & valid;//bne比较rj和rd的值，如果不相等跳转到指定地址
//下一指令地址赋值
assign seq_pc = pc + 32'h4;
assign nextpc = br_taken ? br_target : pc + 4;//每个指令占32位，四个字节
assign br_target = (br_op[4]) ? (rj_value + br_offs) : (pc + br_offs);//jirl跳转指定地址，其它转到偏移量

endmodule