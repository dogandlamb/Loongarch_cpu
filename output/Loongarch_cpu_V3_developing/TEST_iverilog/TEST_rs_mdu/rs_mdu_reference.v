// ============================================================
// rs_mdu 模块（乘除/杂项保留站，`RS_MDU_SIZE=2 项，FIFO 顺序发射）
// ------------------------------------------------------------
// 参考实现说明：
// - 与 rs_mem 同构的 head/tail FIFO（容量 2，1bit 指针）；
// - bundle 为 alu_op（乘除位）/csr_op/csr_num/tlb_op/wb_src_op；
// - 发射条件含 mdu_ready_i 反压（MDU 多周期非流水）。
// ============================================================
`include "mycpu.h"

module rs_mdu(
    input  wire                       clk,
    input  wire                       reset,
    input  wire                       flush_i,

    // ---------------- 入站（dispatch）----------------
    input  wire                       push_valid_i,
    input  wire [`ROB_W-1:0]          push_robid_i,
    input  wire [`ALU_OP_NUM-1:0]     push_alu_op_i,       // 乘除位有效
    input  wire [`CSR_OP_NUM-1:0]     push_csr_op_i,
    input  wire [13:0]                push_csr_num_i,
    input  wire [`TLB_OP_NUM-1:0]     push_tlb_op_i,
    input  wire [`WB_SRC_NUM-1:0]     push_wb_src_op_i,    // rdcnt 类选择
    input  wire                       push_src0_ready_i,   // src0 = rj
    input  wire [31:0]                push_src0_val_i,
    input  wire [`ROB_W-1:0]          push_src0_robid_i,
    input  wire                       push_src1_ready_i,   // src1 = rk/rd
    input  wire [31:0]                push_src1_val_i,
    input  wire [`ROB_W-1:0]          push_src1_robid_i,

    output wire                       can_accept_o,
    output wire [1:0]                 occupancy_o,

    // ---------------- 写回唤醒总线 ×4 ----------------
    input  wire                       wb0_valid_i,
    input  wire [`ROB_W-1:0]          wb0_robid_i,
    input  wire [31:0]                wb0_data_i,
    input  wire                       wb1_valid_i,
    input  wire [`ROB_W-1:0]          wb1_robid_i,
    input  wire [31:0]                wb1_data_i,
    input  wire                       wb2_valid_i,
    input  wire [`ROB_W-1:0]          wb2_robid_i,
    input  wire [31:0]                wb2_data_i,
    input  wire                       wb3_valid_i,
    input  wire [`ROB_W-1:0]          wb3_robid_i,
    input  wire [31:0]                wb3_data_i,

    input  wire                       cmt_wake0_valid_i,
    input  wire [`ROB_W-1:0]          cmt_wake0_robid_i,
    input  wire [31:0]                cmt_wake0_data_i,
    input  wire                       cmt_wake1_valid_i,
    input  wire [`ROB_W-1:0]          cmt_wake1_robid_i,
    input  wire [31:0]                cmt_wake1_data_i,

    // ---------------- 提前唤醒总线 ×3（二期）----------------
    input  wire                       early0_valid_i,
    input  wire [`ROB_W-1:0]          early0_robid_i,
    input  wire                       early1_valid_i,
    input  wire [`ROB_W-1:0]          early1_robid_i,
    input  wire                       early2_valid_i,
    input  wire [`ROB_W-1:0]          early2_robid_i,

    // ---------------- 发射口（到 fu_mdu）----------------
    output wire                       issue_valid_o,
    output wire [`ROB_W-1:0]          issue_robid_o,
    output wire [`ALU_OP_NUM-1:0]     issue_alu_op_o,
    output wire [`CSR_OP_NUM-1:0]     issue_csr_op_o,
    output wire [13:0]                issue_csr_num_o,
    output wire [`TLB_OP_NUM-1:0]     issue_tlb_op_o,
    output wire [`WB_SRC_NUM-1:0]     issue_wb_src_op_o,
    output wire [31:0]                issue_src0_o,
    output wire [31:0]                issue_src1_o,
    input  wire                       mdu_ready_i          // MDU 空闲可接收
);

localparam N = `RS_MDU_SIZE;     // 2 项 -> 1bit 指针

reg                   valid    [0:N-1];
reg [`ROB_W-1:0]      robid    [0:N-1];
reg [`ALU_OP_NUM-1:0] alu_op   [0:N-1];
reg [`CSR_OP_NUM-1:0] csr_op   [0:N-1];
reg [13:0]            csr_num  [0:N-1];
reg [`TLB_OP_NUM-1:0] tlb_op   [0:N-1];
reg [`WB_SRC_NUM-1:0] wb_src_op[0:N-1];
reg                   s0_rdy   [0:N-1];
reg [31:0]            s0_val   [0:N-1];
reg [`ROB_W-1:0]      s0_id    [0:N-1];
reg                   s1_rdy   [0:N-1];
reg [31:0]            s1_val   [0:N-1];
reg [`ROB_W-1:0]      s1_id    [0:N-1];

reg       head, tail;
reg [1:0] count;

assign occupancy_o  = count;
assign can_accept_o = (count < N[1:0]);

wire early_unused = early0_valid_i | early1_valid_i | early2_valid_i
                  | (|early0_robid_i) | (|early1_robid_i) | (|early2_robid_i);

// ---------------- 写回总线匹配 ----------------
function wb_hit;
    input [`ROB_W-1:0] id;
    begin
        wb_hit = (wb0_valid_i && (wb0_robid_i == id))
               | (wb1_valid_i && (wb1_robid_i == id))
               | (wb2_valid_i && (wb2_robid_i == id))
               | (wb3_valid_i && (wb3_robid_i == id))
               | (cmt_wake0_valid_i && (cmt_wake0_robid_i == id))
               | (cmt_wake1_valid_i && (cmt_wake1_robid_i == id));
    end
endfunction

function [31:0] wb_data;
    input [`ROB_W-1:0] id;
    begin
        if      (wb0_valid_i && (wb0_robid_i == id)) wb_data = wb0_data_i;
        else if (wb1_valid_i && (wb1_robid_i == id)) wb_data = wb1_data_i;
        else if (wb2_valid_i && (wb2_robid_i == id)) wb_data = wb2_data_i;
        else if (wb3_valid_i && (wb3_robid_i == id)) wb_data = wb3_data_i;
        else if (cmt_wake0_valid_i && (cmt_wake0_robid_i == id)) wb_data = cmt_wake0_data_i;
        else                                         wb_data = cmt_wake1_data_i;
    end
endfunction

wire        h_s0_rdy = s0_rdy[head] | wb_hit(s0_id[head]);
wire [31:0] h_s0_val = s0_rdy[head] ? s0_val[head] : wb_data(s0_id[head]);
wire        h_s1_rdy = s1_rdy[head] | wb_hit(s1_id[head]);
wire [31:0] h_s1_val = s1_rdy[head] ? s1_val[head] : wb_data(s1_id[head]);

// ---------------- 发射（仅队头）----------------
assign issue_valid_o    = valid[head] && h_s0_rdy && h_s1_rdy && mdu_ready_i && !flush_i;
assign issue_robid_o    = robid[head];
assign issue_alu_op_o   = alu_op[head];
assign issue_csr_op_o   = csr_op[head];
assign issue_csr_num_o  = csr_num[head];
assign issue_tlb_op_o   = tlb_op[head];
assign issue_wb_src_op_o= wb_src_op[head];
assign issue_src0_o     = h_s0_val;
assign issue_src1_o     = h_s1_val;

wire do_issue = issue_valid_o;
wire do_push  = push_valid_i && can_accept_o;

wire        push_s0_rdy = push_src0_ready_i | wb_hit(push_src0_robid_i);
wire [31:0] push_s0_val = push_src0_ready_i ? push_src0_val_i : wb_data(push_src0_robid_i);
wire        push_s1_rdy = push_src1_ready_i | wb_hit(push_src1_robid_i);
wire [31:0] push_s1_val = push_src1_ready_i ? push_src1_val_i : wb_data(push_src1_robid_i);

integer k;
always @(posedge clk) begin
    if (reset || flush_i) begin
        for (k = 0; k < N; k = k + 1) valid[k] <= 1'b0;
        head  <= 1'b0;
        tail  <= 1'b0;
        count <= 2'd0;
    end else begin
        for (k = 0; k < N; k = k + 1) begin
            if (valid[k]) begin
                if (!s0_rdy[k] && wb_hit(s0_id[k])) begin
                    s0_rdy[k] <= 1'b1;
                    s0_val[k] <= wb_data(s0_id[k]);
                end
                if (!s1_rdy[k] && wb_hit(s1_id[k])) begin
                    s1_rdy[k] <= 1'b1;
                    s1_val[k] <= wb_data(s1_id[k]);
                end
            end
        end
        if (do_issue) begin
            valid[head] <= 1'b0;
            head        <= head + 1'b1;
        end
        if (do_push) begin
            valid[tail]    <= 1'b1;
            robid[tail]    <= push_robid_i;
            alu_op[tail]   <= push_alu_op_i;
            csr_op[tail]   <= push_csr_op_i;
            csr_num[tail]  <= push_csr_num_i;
            tlb_op[tail]   <= push_tlb_op_i;
            wb_src_op[tail]<= push_wb_src_op_i;
            s0_rdy[tail]   <= push_s0_rdy;
            s0_val[tail]   <= push_s0_val;
            s0_id[tail]    <= push_src0_robid_i;
            s1_rdy[tail]   <= push_s1_rdy;
            s1_val[tail]   <= push_s1_val;
            s1_id[tail]    <= push_src1_robid_i;
            tail           <= tail + 1'b1;
        end
        count <= count + {1'b0, do_push} - {1'b0, do_issue};
    end
end

wire rs_mdu_lint = early_unused;

endmodule
