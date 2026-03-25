module IDport (
    input  wire        clk,
    input  wire        reset,
    input  wire        valid,

    input  wire [31:0] inst,
    input  wire [31:0] src1_rdata,
    input  wire [31:0] src2_rdata,

    input  wire [31:0] pc_in,

    output reg         allowIn,
    output reg         readyGo,

    output reg  [4:0]  src1_addr,
    output reg  [4:0]  src2_addr,

    output reg  [4:0]  wb_reg_addr,
    output reg  [31:0] alu_src1,
    output reg  [31:0] alu_src2,
    output reg  [31:0] br_imm,
    output reg  [11:0] alu_op,
    output reg  [4:0]  br_op,
    output reg  [1:0]  mem_op,
    output reg         wb_op
);
// ============================================================
// 模块功能：
// ID 译码阶段。输入指令后完成寄存器地址解析、立即数/分支信息生成、
// ALU 控制信号生成，并输出给 EXE 前级寄存器。
//
// 端口定义：
// - 时序与握手：
//   - clk     : 时钟信号。
//   - reset   : 复位信号。
//   - valid   : 当前 ID 级输入有效标志。
//   - allowIn : 本级是否允许上一级写入新数据。
//   - readyGo : 本级是否已就绪，可向下一级传递数据。
// - 输入：
//   - inst : 待译码的 32 位指令。
//   - src1_rdata : 源寄存器 1 读数据（来自 regfile）。
//   - src2_rdata : 源寄存器 2 读数据（来自 regfile）。
// - 输出（寄存器读地址）：
//   - src1_addr : 源寄存器 1 地址（读寄存器堆端口 A）。
//   - src2_addr : 源寄存器 2 地址（读寄存器堆端口 B）。
// - 输出（送往 EXE）：
//   - wb_reg_addr : 目的寄存器地址。
//   - alu_src1    : ALU 源操作数 1。
//   - alu_src2    : ALU 源操作数 2。
//   - br_imm      : 分支立即数/偏移量。
//   - alu_op      : ALU 操作控制码。
//   - br_op       : 分支控制码。
//   - mem_op      : 访存控制。
//   - wb_op       : 写回使能控制。
//
// TODO：
// 1) 译码：补全指令覆盖并维护 inst_dec/op_dec 对齐关系（就是位宽对齐）。
// 2) 数据：完善 mem_op/wb_op 编码规范文档。
// 3) 流水：在需要时接入真实反压（当前可先常开）。
// 4) 验证：指令到控制信号的一致性。
// ============================================================
// 时序规则：
// 1. 同步复位时，本级输出全部清零。
// 2. valid=0 时，内部数据保持，readyGo/allowIn 拉低。
// 3. valid=1 时，正常译码并锁存输出。
// ============================================================
////////////////////////////////////////////////
//以下为指令标志
wire inst_add_w;//rj+rk写入rd
wire inst_addi_w;//rj+12位立即数扩展为32位，写入rd
wire inst_sub_w;
wire inst_ld_w;//从内存中取出32位，存入rd
wire inst_st_w;//word访问内存，32位数据，目标地址为rj寄存器数据加上12位立即数扩展到32位的结果之和，储存数据为rd寄存器的数据
wire inst_bne;
wire inst_slt;//有符号数比较，src1<src2为1，否则为0
wire inst_sltu;//无符号数比较，同上

wire inst_and;//与
wire inst_or;//或
wire inst_nor;//同或
wire inst_xor;//异或

wire inst_slli_w;//rj数据逻辑左移ui5，存入rd
wire inst_srli_w;//rj数据逻辑右移ui5，存入rd
wire inst_srai_w;//rj数据算术右移ui5，存入rd

wire inst_b;//无条件跳转到目标地址，地址偏移值为i26offs26逻辑左移两位再符号拓展
wire inst_bl;//无条件跳转到目标地址，偏移值同上，同时将该指令的pc＋4存到rl
wire inst_beq;//rjrd相等跳转目标地址
wire inst_jirl;//无条件跳转到目标地址，将pc值加＋存到rd，目标地址为i16offs16逻辑左移两位后再符号拓展加rj的值
wire inst_lu12i_w;//用于将20位bit立即数链接上12bit0后写入rd

wire [11:0] alu_op_w;
wire [4:0]  br_op_w;
wire [31:0] alu_imm_w;
wire [31:0] br_imm_w;
wire [31:0] alu_src1_w;
wire [31:0] alu_src2_w;

inst_dec u_inst_dec(
    .reset        (reset),
    .inst         (inst),
    .inst_add_w   (inst_add_w),
    .inst_addi_w  (inst_addi_w),
    .inst_sub_w   (inst_sub_w),
    .inst_ld_w    (inst_ld_w),
    .inst_st_w    (inst_st_w),
    .inst_bne     (inst_bne),
    .inst_slt     (inst_slt),
    .inst_sltu    (inst_sltu),
    .inst_and     (inst_and),
    .inst_or      (inst_or),
    .inst_nor     (inst_nor),
    .inst_xor     (inst_xor),
    .inst_slli_w  (inst_slli_w),
    .inst_srli_w  (inst_srli_w),
    .inst_srai_w  (inst_srai_w),
    .inst_b       (inst_b),
    .inst_bl      (inst_bl),
    .inst_beq     (inst_beq),
    .inst_jirl    (inst_jirl),
    .inst_lu12i_w (inst_lu12i_w)
);

op_dec u_op_dec(
    .reset        (reset),
    .inst_add_w   (inst_add_w),
    .inst_addi_w  (inst_addi_w),
    .inst_sub_w   (inst_sub_w),
    .inst_ld_w    (inst_ld_w),
    .inst_st_w    (inst_st_w),
    .inst_bne     (inst_bne),
    .inst_slt     (inst_slt),
    .inst_sltu    (inst_sltu),
    .inst_and     (inst_and),
    .inst_or      (inst_or),
    .inst_nor     (inst_nor),
    .inst_xor     (inst_xor),
    .inst_slli_w  (inst_slli_w),
    .inst_srli_w  (inst_srli_w),
    .inst_srai_w  (inst_srai_w),
    .inst_b       (inst_b),
    .inst_bl      (inst_bl),
    .inst_beq     (inst_beq),
    .inst_jirl    (inst_jirl),
    .inst_lu12i_w (inst_lu12i_w),
    .alu_op       (alu_op_w),
    .br_op        (br_op_w)
);

imm_generator u_imm_generator(
    .reset        (reset),
    .inst         (inst),
    .inst_add_w   (inst_add_w),
    .inst_addi_w  (inst_addi_w),
    .inst_sub_w   (inst_sub_w),
    .inst_ld_w    (inst_ld_w),
    .inst_st_w    (inst_st_w),
    .inst_bne     (inst_bne),
    .inst_slt     (inst_slt),
    .inst_sltu    (inst_sltu),
    .inst_and     (inst_and),
    .inst_or      (inst_or),
    .inst_nor     (inst_nor),
    .inst_xor     (inst_xor),
    .inst_slli_w  (inst_slli_w),
    .inst_srli_w  (inst_srli_w),
    .inst_srai_w  (inst_srai_w),
    .inst_b       (inst_b),
    .inst_bl      (inst_bl),
    .inst_beq     (inst_beq),
    .inst_jirl    (inst_jirl),
    .inst_lu12i_w (inst_lu12i_w),
    .alu_imm      (alu_imm_w),
    .br_imm       (br_imm_w)
);

ALU_srcGenerator u_ALU_srcGenerator(
    .reset        (reset),
    .inst_add_w   (inst_add_w),
    .inst_addi_w  (inst_addi_w),
    .inst_sub_w   (inst_sub_w),
    .inst_ld_w    (inst_ld_w),
    .inst_st_w    (inst_st_w),
    .inst_bne     (inst_bne),
    .inst_slt     (inst_slt),
    .inst_sltu    (inst_sltu),
    .inst_and     (inst_and),
    .inst_or      (inst_or),
    .inst_nor     (inst_nor),
    .inst_xor     (inst_xor),
    .inst_slli_w  (inst_slli_w),
    .inst_srli_w  (inst_srli_w),
    .inst_srai_w  (inst_srai_w),
    .inst_b       (inst_b),
    .inst_bl      (inst_bl),
    .inst_beq     (inst_beq),
    .inst_jirl    (inst_jirl),
    .inst_lu12i_w (inst_lu12i_w),
    .rj_value     (src1_rdata),
    .rkd_value    (src2_rdata),
    .imm          (alu_imm_w),
    .pc           (pc_in),
    .alu_src1     (alu_src1_w),
    .alu_src2     (alu_src2_w)
);

always @(posedge clk) begin
    if (reset) begin
        allowIn     <= 1'b1;
        readyGo     <= 1'b1;
        src1_addr   <= 5'b0;
        src2_addr   <= 5'b0;
        wb_reg_addr <= 5'b0;
        alu_src1    <= 32'b0;
        alu_src2    <= 32'b0;
        br_imm      <= 32'b0;
        alu_op      <= 12'b0;
        br_op       <= 5'b0;
        mem_op      <= 2'b0;
        wb_op       <= 1'b0;
    end
    else if (valid) begin
        allowIn     <= 1'b1;
        readyGo     <= 1'b1;
        src1_addr   <= inst[9:5];
        src2_addr   <= inst[14:10];
        wb_reg_addr <= inst_bl ? 5'd1 : inst[4:0];
        alu_src1    <= alu_src1_w;
        alu_src2    <= alu_src2_w;
        br_imm      <= br_imm_w;
        alu_op      <= alu_op_w;
        br_op       <= br_op_w;
        mem_op      <= {inst_ld_w, inst_st_w};
        wb_op       <= ~(inst_st_w | inst_beq | inst_bne | inst_b);
    end
    else if (!valid) begin
        allowIn     <= 1'b0;
        readyGo     <= 1'b0;
        src1_addr   <= src1_addr;
        src2_addr   <= src2_addr;
        wb_reg_addr <= wb_reg_addr;
        alu_src1    <= alu_src1;
        alu_src2    <= alu_src2;
        br_imm      <= br_imm;
        alu_op      <= alu_op;
        br_op       <= br_op;
        mem_op      <= mem_op;
        wb_op       <= wb_op;
    end
    else begin
        allowIn     <= 1'b0;
        readyGo     <= 1'b0;
        src1_addr   <= 5'b0;
        src2_addr   <= 5'b0;
        wb_reg_addr <= 5'b0;
        alu_src1    <= 32'b0;
        alu_src2    <= 32'b0;
        br_imm      <= 32'b0;
        alu_op      <= 12'b0;
        br_op       <= 5'b0;
        mem_op      <= 2'b0;
        wb_op       <= 1'b0;
    end
end

endmodule
