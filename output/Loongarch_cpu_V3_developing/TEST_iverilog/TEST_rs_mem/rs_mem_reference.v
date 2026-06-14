// ============================================================
// rs_mem 模块（访存保留站，`RS_MEM_SIZE=4 项，FIFO 严格顺序发射）
// ------------------------------------------------------------
// 参考实现说明：
// - head/tail 环形 FIFO；只允许队头发射（程序序访存，无地址消歧）；
// - 唤醒/数据捕获与 rs_alu 相同（4 路写回总线 + 入站同拍旁路）；
// - 发射条件含 lsu_ready_i 反压（不丢发射）。
// ============================================================
`include "mycpu.h"

module rs_mem(
    input  wire                       clk,
    input  wire                       reset,
    input  wire                       flush_i,

    // ---------------- 入站（dispatch）----------------
    input  wire                       push_valid_i,
    input  wire [`ROB_W-1:0]          push_robid_i,
    input  wire [31:0]                push_pc_i,
    input  wire [`MEM_OP_NUM-1:0]     push_mem_op_i,
    input  wire                       push_is_cacop_i,
    input  wire                       push_src0_ready_i,   // src0 = 基址 rj
    input  wire [31:0]                push_src0_val_i,
    input  wire [`ROB_W-1:0]          push_src0_robid_i,
    input  wire                       push_src1_ready_i,   // src1 = store 数据 rd
    input  wire [31:0]                push_src1_val_i,
    input  wire [`ROB_W-1:0]          push_src1_robid_i,
    input  wire [31:0]                push_imm_i,          // si12/si14 偏移

    output wire                       can_accept_o,
    output wire [2:0]                 occupancy_o,

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

    // ---------------- 发射口（到 lsu）----------------
    output wire                       issue_valid_o,
    output wire [`ROB_W-1:0]          issue_robid_o,
    output wire [31:0]                issue_pc_o,
    output wire [`MEM_OP_NUM-1:0]     issue_mem_op_o,
    output wire                       issue_is_cacop_o,
    output wire [31:0]                issue_base_o,        // 基址（src0 捕获值）
    output wire [31:0]                issue_wdata_o,       // store 数据（src1 捕获值）
    output wire [31:0]                issue_imm_o,
    input  wire                       lsu_ready_i          // LSU 本拍可接收（AGU 级空闲）
);

localparam N  = `RS_MEM_SIZE;
localparam PW = 2;                  // $clog2(N)

reg                   valid   [0:N-1];
reg [`ROB_W-1:0]      robid   [0:N-1];
reg [31:0]            pc      [0:N-1];
reg [`MEM_OP_NUM-1:0] mem_op  [0:N-1];
reg                   is_cacop[0:N-1];
reg                   s0_rdy  [0:N-1];
reg [31:0]            s0_val  [0:N-1];
reg [`ROB_W-1:0]      s0_id   [0:N-1];
reg                   s1_rdy  [0:N-1];
reg [31:0]            s1_val  [0:N-1];
reg [`ROB_W-1:0]      s1_id   [0:N-1];
reg [31:0]            imm     [0:N-1];

reg [PW-1:0] head, tail;
reg [2:0]    count;

assign occupancy_o  = count;
assign can_accept_o = (count < N[2:0]);

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

// 队头本拍有效就绪视图（含同拍唤醒旁路）
wire        h_s0_rdy = s0_rdy[head] | wb_hit(s0_id[head]);
wire [31:0] h_s0_val = s0_rdy[head] ? s0_val[head] : wb_data(s0_id[head]);
wire        h_s1_rdy = s1_rdy[head] | wb_hit(s1_id[head]);
wire [31:0] h_s1_val = s1_rdy[head] ? s1_val[head] : wb_data(s1_id[head]);

// ---------------- 发射（仅队头，顺序）----------------
assign issue_valid_o   = valid[head] && h_s0_rdy && h_s1_rdy && lsu_ready_i && !flush_i;
assign issue_robid_o   = robid[head];
assign issue_pc_o      = pc[head];
assign issue_mem_op_o  = mem_op[head];
assign issue_is_cacop_o= is_cacop[head];
assign issue_base_o    = h_s0_val;
assign issue_wdata_o   = h_s1_val;
assign issue_imm_o     = imm[head];

wire do_issue = issue_valid_o;       // lsu_ready 已含在条件中
wire do_push  = push_valid_i && can_accept_o;

// 入站同拍旁路
wire        push_s0_rdy = push_src0_ready_i | wb_hit(push_src0_robid_i);
wire [31:0] push_s0_val = push_src0_ready_i ? push_src0_val_i : wb_data(push_src0_robid_i);
wire        push_s1_rdy = push_src1_ready_i | wb_hit(push_src1_robid_i);
wire [31:0] push_s1_val = push_src1_ready_i ? push_src1_val_i : wb_data(push_src1_robid_i);

integer k;
always @(posedge clk) begin
    if (reset || flush_i) begin
        for (k = 0; k < N; k = k + 1) valid[k] <= 1'b0;
        head  <= {PW{1'b0}};
        tail  <= {PW{1'b0}};
        count <= 3'd0;
    end else begin
        // 唤醒捕获（包括队头未发射时）
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
            valid[tail]   <= 1'b1;
            robid[tail]   <= push_robid_i;
            pc[tail]      <= push_pc_i;
            mem_op[tail]  <= push_mem_op_i;
            is_cacop[tail]<= push_is_cacop_i;
            s0_rdy[tail]  <= push_s0_rdy;
            s0_val[tail]  <= push_s0_val;
            s0_id[tail]   <= push_src0_robid_i;
            s1_rdy[tail]  <= push_s1_rdy;
            s1_val[tail]  <= push_s1_val;
            s1_id[tail]   <= push_src1_robid_i;
            imm[tail]     <= push_imm_i;
            tail          <= tail + 1'b1;
        end
        count <= count + {2'b0, do_push} - {2'b0, do_issue};
    end
end

wire rs_mem_lint = early_unused;

endmodule
