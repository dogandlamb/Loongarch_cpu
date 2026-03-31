// ============================================================
// 模块功能：
// 根据已译码的指令类型，组合生成寄存器堆两路读地址 `rf_raddr1/2`。
// 该模块只负责“读地址选择规则”，不参与数据读取与时序控制。
//
// 端口定义：
// - 输入：
//   - inst：当前指令字。
//   - inst_*：来自译码器的指令类型标志（用于判断是否需要读取 rj/rk/rd）。
// - 输出：
//   - rf_raddr1：读端口1地址（通常对应 rj）。
//   - rf_raddr2：读端口2地址（通常对应 rk，或在 st/beq/bne 时对应 rd）。
//
// 与 top 的关系：
// - 由 `IDport` 实例化并驱动 `src1_addr/src2_addr`，
//   再由 `mycpu_top` 连接到 `regfile.raddr1/raddr2`。
// ============================================================
module get_reg_read_addr(
    input  wire        reset,
    input  wire [31:0] inst,
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
    input  wire        inst_mul_w,     //乘法
    input  wire        inst_mulh_w,    //有符号乘法高位结果
    input  wire        inst_mulh_wu,   //有符号/无符号混合乘法高位结果
    input  wire        inst_div_w,     //有符号除法
    input  wire        inst_div_wu,    //无符号除法
    output wire [ 4:0] rf_raddr1,
    output wire [ 4:0] rf_raddr2
);

wire [ 4:0] rd; // rd 字段
wire [ 4:0] rj; // rj 字段
wire [ 4:0] rk; // rk 字段
wire need_rj;
wire need_rk;
wire src_reg_is_rd;
wire inst_ori;

assign rd       = inst[ 4: 0];
assign rj       = inst[ 9: 5];
assign rk       = inst[14:10];
assign inst_ori = (inst[31:26] == 6'h00) && (inst[25:22] == 4'he);

assign need_rj = inst_add_w  | inst_addi_w | inst_sub_w | inst_ld_w | inst_st_w
               | inst_slt    | inst_sltu   | inst_and   | inst_or   | inst_nor
               | inst_xor    | inst_slli_w | inst_srli_w| inst_srai_w
               | inst_beq    | inst_bne    | inst_jirl  | inst_ori
               | inst_mul_w  | inst_mulh_w | inst_mulh_wu
               | inst_div_w  | inst_div_wu;

assign need_rk = inst_add_w | inst_sub_w | inst_slt | inst_sltu
               | inst_and   | inst_or    | inst_nor | inst_xor
               | inst_mul_w | inst_mulh_w | inst_mulh_wu
               | inst_div_w | inst_div_wu;

assign src_reg_is_rd = inst_st_w | inst_beq | inst_bne; // 第二源来自 rd 的指令

assign rf_raddr1 = need_rj ? rj : 5'd0;
assign rf_raddr2 = src_reg_is_rd ? rd : (need_rk ? rk : 5'd0);

endmodule