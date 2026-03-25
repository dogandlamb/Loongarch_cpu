module op_dec(
    input  wire        reset,//未使用
    input  wire        inst_add_w,
    input  wire        inst_addi_w,
    input  wire        inst_sub_w,
    input  wire        inst_ld_w,
    input  wire        inst_st_w,
    input  wire        inst_bne,
    input  wire        inst_slt,
    input  wire        inst_sltu,
    input  wire        inst_and,
    input  wire        inst_or,
    input  wire        inst_nor,
    input  wire        inst_xor,
    input  wire        inst_slli_w,
    input  wire        inst_srli_w,
    input  wire        inst_srai_w,
    input  wire        inst_b,
    input  wire        inst_bl,
    input  wire        inst_beq,
    input  wire        inst_jirl,
    input  wire        inst_lu12i_w,
    output wire [11:0] alu_op,
    output wire [ 4:0] br_op
);


//todo:生成alu操作码和分支跳转操作码
/////////////////////////////////////////////////////////////
//ALU操作的生成
//alu_op[ 0]       加法操作   
//alu_op[ 1]       减法操作
//alu_op[ 2：3]    比较操作
//alu_op[ 4：7]    逻辑运算
//alu_op[ 8：10]   移位操作
//alu_op[ 11]      高位立即数加载

    assign alu_op[ 0] = inst_add_w | inst_addi_w | inst_ld_w | inst_st_w 
                    | inst_jirl | inst_bl;
    assign alu_op[ 1] = inst_sub_w;
    assign alu_op[ 2] = inst_slt;
    assign alu_op[ 3] = inst_sltu;
    assign alu_op[ 4] = inst_and;
    assign alu_op[ 5] = inst_nor;
    assign alu_op[ 6] = inst_or;
    assign alu_op[ 7] = inst_xor;
    assign alu_op[ 8] = inst_slli_w;
    assign alu_op[ 9] = inst_srli_w;
    assign alu_op[10] = inst_srai_w;
    assign alu_op[11] = inst_lu12i_w;

//分支跳转操作码生成
//inst_b 无条件跳转到目标地址，地址偏移值为i26offs26逻辑左移两位再符号拓展
//inst_bl 无条件跳转到目标地址，偏移值同上，同时将该指令的pc＋4存到rl
//inst_beq rjrd相等跳转目标地址
//inst_jirl 无条件跳转到目标地址，将pc值加＋存到rd，目标地址为i16offs16逻辑左移两位后再符号拓展加rj的值
//inst_bne 将通用寄存器 rj 和通用寄存器 rd 的值进行比较，如果两者不等则跳转到目标地址，否则不跳转。
    assign br_op      = {inst_jirl , inst_b , inst_bl , inst_beq , inst_bne};

endmodule