`include "cpu_defs.vh"

module op_dec(
    input  wire        reset,//未使用
    input  wire        inst_add_w,
    input  wire        inst_addi_w,
    input  wire        inst_sub_w,
    input  wire        inst_ld_w,
    input  wire        inst_ld_h,
    input  wire        inst_ld_b,
    input  wire        inst_ld_hu,
    input  wire        inst_ld_bu,
    input  wire        inst_st_w,
    input  wire        inst_st_b,
    input  wire        inst_st_h,
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
    input  wire        inst_blt,
    input  wire        inst_bge,
    input  wire        inst_bltu,
    input  wire        inst_bgeu,
    input  wire        inst_jirl,
    input  wire        inst_lu12i_w,
    input  wire        inst_mul_w,
    input  wire        inst_mulh_w,
    input  wire        inst_mulh_wu,
    input  wire        inst_div_w,
    input  wire        inst_div_wu,
    output wire [`ALU_OP_NUM-1:0] alu_op,
    output wire [`BR_OP_NUM-1:0]  br_op,
    output wire [`MEM_OP_NUM-1:0] mem_op
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

    assign alu_op[`ALU_OP_ADD] = inst_add_w | inst_addi_w | inst_jirl | inst_bl ; // 注意 st_b/st_h 也需要加法操作来计算地址
    assign alu_op[`ALU_OP_SUB] = inst_sub_w;
    assign alu_op[`ALU_OP_SLT] = inst_slt;
    assign alu_op[`ALU_OP_SLTU] = inst_sltu;
    assign alu_op[`ALU_OP_AND] = inst_and;
    assign alu_op[`ALU_OP_NOR] = inst_nor;
    assign alu_op[`ALU_OP_OR] = inst_or;
    assign alu_op[`ALU_OP_XOR] = inst_xor;
    assign alu_op[`ALU_OP_SLL] = inst_slli_w;
    assign alu_op[`ALU_OP_SRL] = inst_srli_w;
    assign alu_op[`ALU_OP_SRA] = inst_srai_w;
    assign alu_op[`ALU_OP_LUI] = inst_lu12i_w;
    assign alu_op[`ALU_OP_MUL_W] = inst_mul_w;
    assign alu_op[`ALU_OP_MULH_W] = inst_mulh_w;
    assign alu_op[`ALU_OP_MULH_WU] = inst_mulh_wu;
    assign alu_op[`ALU_OP_DIV_W] = inst_div_w;
    assign alu_op[`ALU_OP_DIV_WU] = inst_div_wu;

//分支跳转操作码生成
//inst_b 无条件跳转到目标地址，地址偏移值为i26offs26逻辑左移两位再符号拓展
//inst_bl 无条件跳转到目标地址，偏移值同上，同时将该指令的pc＋4存到rl
//inst_beq rjrd相等跳转目标地址
//inst_jirl 无条件跳转到目标地址，将pc值加＋存到rd，目标地址为i16offs16逻辑左移两位后再符号拓展加rj的值
//inst_bne 将通用寄存器 rj 和通用寄存器 rd 的值进行比较，如果两者不等则跳转到目标地址，否则不跳转。
//inst_blt 将通用寄存器 rj 和通用寄存器 rd 的值进行比较，如果 rj 的值小于 rd 的值（有符号比较），则跳转到目标地址，否则不跳转。
//inst_bge 将通用寄存器 rj 和通用寄存器 rd 的值进行比较，如果 rj 的值大于或等于 rd 的值（有符号比较），则跳转到目标地址，否则不跳转。
//inst_bltu 将通用寄存器 rj 和通用寄存器 rd 的值进行比较，如果 rj 的值小于 rd 的值（无符号比较），则跳转到目标地址，否则不跳转。
//inst_bgeu 将通用寄存器 rj 和通用寄存器 rd 的值进行比较，如果 rj 的值大于或等于 rd 的值（无符号比较），则跳转到目标地址，否则不跳转。
    assign br_op[`BR_OP_BEQ]  = inst_beq;
    assign br_op[`BR_OP_BNE]  = inst_bne;
    assign br_op[`BR_OP_JIRL] = inst_jirl;
    assign br_op[`BR_OP_BL]   = inst_bl;
    assign br_op[`BR_OP_B]    = inst_b;
    assign br_op[`BR_OP_BLT]  = inst_blt;
    assign br_op[`BR_OP_BGE]  = inst_bge;
    assign br_op[`BR_OP_BLTU] = inst_bltu;
    assign br_op[`BR_OP_BGEU] = inst_bgeu;

// mem_op操作码生成
// `define MEM_OP_LD_W     1   // load，从内存取数据写入寄存器堆（与 {inst_ld_w, inst_st_w} 对齐）
// `define MEM_OP_ST_W     0   // store，从寄存器堆数据存入内存（与 {inst_ld_w, inst_st_w} 对齐）
// `define MEM_OP_ST_B     2   // store byte，从寄存器堆数据存入内存（与 {inst_ld_b, inst_st_b} 对齐）
// `define MEM_OP_ST_H     3   // store half，从寄存器堆数据存入内存（与 {inst_ld_h, inst_st_h} 对齐）
// `define MEM_OP_LD_B     4   // load byte，从内存取数据写入寄存器堆（与 {inst_ld_b, inst_st_b} 对齐）
// `define MEM_OP_LD_H     5   // load half，从内存取数据写入寄存器堆（与 {inst_ld_h, inst_st_h} 对齐）    
// `define MEM_OP_LD_BU    6   // load byte unsigned，从内存取数据写入寄存器堆（与 {inst_ld_b, inst_st_b} 对齐）
// `define MEM_OP_LD_HU    7   // load half unsigned，从内存取数据写入寄存器堆（与 {inst_ld_h, inst_st_h} 对齐）
    assign mem_op[`MEM_OP_ST_W] = inst_st_w;
    assign mem_op[`MEM_OP_ST_B] = inst_st_b;
    assign mem_op[`MEM_OP_ST_H] = inst_st_h;
    assign mem_op[`MEM_OP_LD_W] = inst_ld_w;
    assign mem_op[`MEM_OP_LD_H] = inst_ld_h;
    assign mem_op[`MEM_OP_LD_B] = inst_ld_b;
    assign mem_op[`MEM_OP_LD_HU] = inst_ld_hu;
    assign mem_op[`MEM_OP_LD_BU] = inst_ld_bu;

endmodule