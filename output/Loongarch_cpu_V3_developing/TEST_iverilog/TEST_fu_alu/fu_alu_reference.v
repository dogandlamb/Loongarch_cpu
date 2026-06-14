// ============================================================
// fu_alu 模块（ALU 执行单元，单周期，含分支判断；顶层例化 2 份）
// ------------------------------------------------------------
// 参考实现说明：
// - 发射拍锁存进执行寄存器，执行拍组合计算并写回（共 1 拍延迟）；
// - 运算核例化 alu.v（纯组合版）；链接类（bl/jirl）结果旁路为 pc+4；
// - 分支：方向比较 + 目标计算（jirl: src0+offs；其余: pc+offs）；
// - 一期 early_wakeup / ex_redirect 输出恒 0。
// ============================================================
`include "mycpu.h"

module fu_alu(
    input  wire                       clk,
    input  wire                       reset,
    input  wire                       flush_i,

    // ---------------- 发射入口（来自 rs_alu，组合）----------------
    input  wire                       issue_valid_i,
    input  wire [`ROB_W-1:0]          issue_robid_i,
    input  wire [31:0]                issue_pc_i,
    input  wire [`ALU_OP_NUM-1:0]     issue_alu_op_i,
    input  wire [`BR_OP_NUM-1:0]      issue_br_op_i,
    input  wire [31:0]                issue_src0_i,
    input  wire [31:0]                issue_src1_i,
    input  wire [31:0]                issue_imm_i,
    input  wire                       issue_use_imm_i,
    input  wire [31:0]                issue_br_offs_i,

    // ---------------- 写回 ROB ----------------
    output wire                       wb_valid_o,
    output wire [`ROB_W-1:0]          wb_robid_o,
    output wire [31:0]                wb_data_o,         // 运算结果 / 链接值(pc+4)
    output wire                       wb_br_taken_o,     // 分支实际方向（非分支恒 0）
    output wire [31:0]                wb_br_target_o,    // 分支实际目标（taken 时有效）

    // ---------------- 提前唤醒广播（发射拍，二期接入 RS）----------------
    output wire                       early_wakeup_valid_o,
    output wire [`ROB_W-1:0]          early_wakeup_robid_o,

    // ---------------- 二期：执行级重定向（一期输出恒 0）----------------
    output wire                       ex_redirect_valid_o,
    output wire [31:0]                ex_redirect_pc_o
);

// ---------------- 执行寄存器（发射拍锁存）----------------
reg                    ex_valid;
reg [`ROB_W-1:0]       ex_robid;
reg [31:0]             ex_pc;
reg [`ALU_OP_NUM-1:0]  ex_alu_op;
reg [`BR_OP_NUM-1:0]   ex_br_op;
reg [31:0]             ex_src0, ex_src1;
reg [31:0]             ex_imm;
reg                    ex_use_imm;
reg [31:0]             ex_br_offs;

always @(posedge clk) begin
    if (reset || flush_i) begin
        ex_valid <= 1'b0;
    end else begin
        ex_valid <= issue_valid_i;
        if (issue_valid_i) begin
            ex_robid   <= issue_robid_i;
            ex_pc      <= issue_pc_i;
            ex_alu_op  <= issue_alu_op_i;
            ex_br_op   <= issue_br_op_i;
            ex_src0    <= issue_src0_i;
            ex_src1    <= issue_src1_i;
            ex_imm     <= issue_imm_i;
            ex_use_imm <= issue_use_imm_i;
            ex_br_offs <= issue_br_offs_i;
        end
    end
end

// ---------------- 运算核（纯组合）----------------
wire [31:0] alu_result;
wire        alu_result_valid_unused;

alu u_alu(
    .clk             (clk),
    .reset           (reset),
    .alu_op          (ex_alu_op),
    .alu_src1        (ex_src0),
    .alu_src2        (ex_use_imm ? ex_imm : ex_src1),
    .exe_pc          (ex_pc),
    .alu_result      (alu_result),
    .alu_result_valid(alu_result_valid_unused)
);

// ---------------- 分支处理 ----------------
wire br_beq  = ex_br_op[`BR_OP_BEQ];
wire br_bne  = ex_br_op[`BR_OP_BNE];
wire br_jirl = ex_br_op[`BR_OP_JIRL];
wire br_bl   = ex_br_op[`BR_OP_BL];
wire br_b    = ex_br_op[`BR_OP_B];
wire br_blt  = ex_br_op[`BR_OP_BLT];
wire br_bge  = ex_br_op[`BR_OP_BGE];
wire br_bltu = ex_br_op[`BR_OP_BLTU];
wire br_bgeu = ex_br_op[`BR_OP_BGEU];

wire is_branch = |ex_br_op;
wire is_link   = br_jirl | br_bl;             // 写 rd = pc+4

wire eq  = (ex_src0 == ex_src1);
wire ltu = (ex_src0 <  ex_src1);
wire lt  = ($signed(ex_src0) < $signed(ex_src1));

wire br_taken = (br_beq  &  eq)
              | (br_bne  & ~eq)
              | (br_blt  &  lt)
              | (br_bge  & ~lt)
              | (br_bltu &  ltu)
              | (br_bgeu & ~ltu)
              |  br_b | br_bl | br_jirl;

wire [31:0] br_target = br_jirl ? ((ex_src0 + ex_br_offs) & 32'hffff_fffe)
                                : (ex_pc + ex_br_offs);

// ---------------- 写回 ----------------
assign wb_valid_o     = ex_valid;
assign wb_robid_o     = ex_robid;
assign wb_data_o      = is_link ? (ex_pc + 32'd4) : alu_result;
assign wb_br_taken_o  = is_branch & br_taken;
assign wb_br_target_o = br_target;

// ---------------- 一期恒 0 输出 ----------------
assign early_wakeup_valid_o = 1'b0;
assign early_wakeup_robid_o = {`ROB_W{1'b0}};
assign ex_redirect_valid_o  = 1'b0;
assign ex_redirect_pc_o     = 32'b0;

endmodule
