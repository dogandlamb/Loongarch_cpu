// ============================================================
// fu_mdu 模块（乘除/CSR读/rdcnt/TLB维护打包 杂项执行单元，多周期非流水）
// ------------------------------------------------------------
// 参考实现说明：
// - IDLE/BUSY/WB 状态机，非流水（busy 反压 rs_mdu）；
// - 乘法走 mul.v（3 拍），除法走 div.v（CLZ 迭代）；
// - CSR 类：执行级读旧值（csr_raddr_o 组合读），csrwr/csrxchg 在
//   执行级合成"将写入 CSR 的新值"放 result2（提交级真正写入）；
// - rdcntvl/vh/id：读稳定计数器/TID；
// - invtlb：result2 = {vppn(19), pad(3), asid(10)} 打包；
// - tlbsrch/tlbrd/tlbwr/tlbfill：执行级直接完成（提交级落地）；
// - flush_i 强制回 IDLE 并打断除法器。
// ============================================================
`include "mycpu.h"

module fu_mdu(
    input  wire                       clk,
    input  wire                       reset,
    input  wire                       flush_i,

    // ---------------- 发射入口（来自 rs_mdu）----------------
    input  wire                       issue_valid_i,
    input  wire [`ROB_W-1:0]          issue_robid_i,
    input  wire [`ALU_OP_NUM-1:0]     issue_alu_op_i,     // 乘除位有效
    input  wire [`CSR_OP_NUM-1:0]     issue_csr_op_i,
    input  wire [13:0]                issue_csr_num_i,
    input  wire [`TLB_OP_NUM-1:0]     issue_tlb_op_i,
    input  wire [`WB_SRC_NUM-1:0]     issue_wb_src_op_i,  // rdcnt 类选择
    input  wire [31:0]                issue_src0_i,       // rj 值
    input  wire [31:0]                issue_src1_i,       // rk/rd 值
    output wire                       mdu_ready_o,        // 空闲（rs_mdu 发射条件）

    // ---------------- CSR 读口（组合读 csr handler）----------------
    output wire [13:0]                csr_raddr_o,
    input  wire [31:0]                csr_rdata_i,

    // ---------------- 计时器 ----------------
    input  wire [63:0]                timer_64_i,
    input  wire [31:0]                csr_tid_i,

    // ---------------- 写回 ROB ----------------
    output wire                       wb_valid_o,
    output wire [`ROB_W-1:0]          wb_robid_o,
    output wire [31:0]                wb_data_o,          // 写回 rd 的值
    output wire [31:0]                wb_data2_o          // CSR 新值 / invtlb {asid,vppn} 打包
);

localparam S_IDLE = 2'd0;
localparam S_BUSY = 2'd1;   // 等乘/除法器 done
localparam S_WB   = 2'd2;   // 写回一拍

reg [1:0]              state;
reg [`ROB_W-1:0]       r_robid;
reg [`ALU_OP_NUM-1:0]  r_alu_op;
reg [`CSR_OP_NUM-1:0]  r_csr_op;
reg [13:0]             r_csr_num;
reg [`TLB_OP_NUM-1:0]  r_tlb_op;
reg [`WB_SRC_NUM-1:0]  r_wb_src;
reg [31:0]             r_src0, r_src1;
reg [31:0]             r_data, r_data2;

// ---------------- 指令分类（发射拍组合）----------------
wire is_mul = issue_alu_op_i[`ALU_OP_MUL_W] | issue_alu_op_i[`ALU_OP_MULH_W]
            | issue_alu_op_i[`ALU_OP_MULH_WU];
wire is_div = issue_alu_op_i[`ALU_OP_DIV_W] | issue_alu_op_i[`ALU_OP_DIV_WU]
            | issue_alu_op_i[`ALU_OP_MOD_W] | issue_alu_op_i[`ALU_OP_MOD_WU];

wire accept = (state == S_IDLE) && issue_valid_i && !flush_i;
assign mdu_ready_o = (state == S_IDLE);

// ---------------- 乘法器 ----------------
wire        mul_start = accept && is_mul;
wire [63:0] mul_result;
wire        mul_done;
mul u_mul(
    .clk        (clk),
    .reset      (reset),
    .valid_i    (mul_start),
    .a_i        (issue_src0_i),
    .b_i        (issue_src1_i),
    .is_signed_i(issue_alu_op_i[`ALU_OP_MUL_W] | issue_alu_op_i[`ALU_OP_MULH_W]),
    .result_o   (mul_result),
    .done_o     (mul_done)
);

// ---------------- 除法器 ----------------
wire        div_start = accept && is_div;
wire [31:0] div_quot, div_rem;
wire        div_done, div_busy;
div u_div(
    .clk        (clk),
    .reset      (reset),
    .flush_i    (flush_i),
    .valid_i    (div_start),
    .dividend_i (issue_src0_i),
    .divisor_i  (issue_src1_i),
    .is_signed_i(issue_alu_op_i[`ALU_OP_DIV_W] | issue_alu_op_i[`ALU_OP_MOD_W]),
    .quotient_o (div_quot),
    .remainder_o(div_rem),
    .done_o     (div_done),
    .busy_o     (div_busy)
);

// ---------------- CSR 读口（锁存号组合读，BUSY/WB 拍数据稳定）----------------
assign csr_raddr_o = (state == S_IDLE) ? issue_csr_num_i : r_csr_num;

// ---------------- 单拍类结果（发射拍组合算好）----------------
wire is_csr   = |issue_csr_op_i;
wire is_rdcnt = issue_wb_src_op_i[`WB_SRC_CNTVL] | issue_wb_src_op_i[`WB_SRC_CNTVH]
              | issue_wb_src_op_i[`WB_SRC_TID];
wire is_invtlb = issue_tlb_op_i[`TLB_OP_INVTLB_0] | issue_tlb_op_i[`TLB_OP_INVTLB_1]
               | issue_tlb_op_i[`TLB_OP_INVTLB_2] | issue_tlb_op_i[`TLB_OP_INVTLB_3]
               | issue_tlb_op_i[`TLB_OP_INVTLB_4] | issue_tlb_op_i[`TLB_OP_INVTLB_5]
               | issue_tlb_op_i[`TLB_OP_INVTLB_6];

wire [31:0] csr_old = csr_rdata_i;     // 发射拍 csr_raddr_o=issue_csr_num_i，组合返回旧值
wire [31:0] fast_data = is_csr   ? csr_old
                      : issue_wb_src_op_i[`WB_SRC_CNTVL] ? timer_64_i[31:0]
                      : issue_wb_src_op_i[`WB_SRC_CNTVH] ? timer_64_i[63:32]
                      : issue_wb_src_op_i[`WB_SRC_TID]   ? csr_tid_i
                      : 32'b0;
wire [31:0] fast_data2 = issue_csr_op_i[`CSR_OP_CSRWR]   ? issue_src1_i
                       : issue_csr_op_i[`CSR_OP_CSRXCHG] ? ((csr_old & ~issue_src0_i) | (issue_src1_i & issue_src0_i))
                       : is_invtlb ? {issue_src1_i[31:13], 3'b0, issue_src0_i[9:0]}
                       : 32'b0;

// ---------------- 状态机 ----------------
always @(posedge clk) begin
    if (reset || flush_i) begin
        state <= S_IDLE;
    end else begin
        case (state)
            S_IDLE: begin
                if (issue_valid_i) begin
                    r_robid  <= issue_robid_i;
                    r_alu_op <= issue_alu_op_i;
                    r_csr_op <= issue_csr_op_i;
                    r_csr_num<= issue_csr_num_i;
                    r_tlb_op <= issue_tlb_op_i;
                    r_wb_src <= issue_wb_src_op_i;
                    r_src0   <= issue_src0_i;
                    r_src1   <= issue_src1_i;
                    if (is_mul || is_div) begin
                        state <= S_BUSY;
                    end else begin
                        // CSR/rdcnt/TLB 类单拍完成
                        r_data  <= fast_data;
                        r_data2 <= fast_data2;
                        state   <= S_WB;
                    end
                end
            end
            S_BUSY: begin
                if (mul_done) begin
                    r_data <= r_alu_op[`ALU_OP_MUL_W] ? mul_result[31:0] : mul_result[63:32];
                    r_data2<= 32'b0;
                    state  <= S_WB;
                end else if (div_done) begin
                    r_data <= (r_alu_op[`ALU_OP_DIV_W] | r_alu_op[`ALU_OP_DIV_WU]) ? div_quot : div_rem;
                    r_data2<= 32'b0;
                    state  <= S_WB;
                end
            end
            S_WB: begin
                state <= S_IDLE;
            end
            default: state <= S_IDLE;
        endcase
    end
end

// ---------------- 写回 ----------------
assign wb_valid_o = (state == S_WB);
assign wb_robid_o = r_robid;
assign wb_data_o  = r_data;
assign wb_data2_o = r_data2;

// lint
wire fu_mdu_lint = div_busy | (|r_src0) | (|r_src1);

endmodule
