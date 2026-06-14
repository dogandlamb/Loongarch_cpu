// ============================================================
// rs_alu 模块（ALU 保留站，`RS_ALU_SIZE=4 项，乱序发射，顶层例化 2 份）
// ------------------------------------------------------------
// 参考实现说明：
// - 4 项全比较保留站：监听 4 路写回总线唤醒+捕获数据；
// - prior 年龄时间戳（0=最老）选择最老就绪项发射（oldest-first）；
// - 入站同拍旁路：push 数据先过一遍总线比较再写入（防错过唤醒死锁）；
// - 发射数据带同拍唤醒旁路（本拍总线值直接出现在 issue_src 上）；
// - 一期忽略 early 提前唤醒总线（恒 0 输入）。
// ============================================================
`include "mycpu.h"

module rs_alu(
    input  wire                       clk,
    input  wire                       reset,
    input  wire                       flush_i,

    // ---------------- 入站（dispatch）----------------
    input  wire                       push_valid_i,
    input  wire [`ROB_W-1:0]          push_robid_i,
    input  wire [31:0]                push_pc_i,
    input  wire [`ALU_OP_NUM-1:0]     push_alu_op_i,
    input  wire [`BR_OP_NUM-1:0]      push_br_op_i,
    input  wire                       push_src0_ready_i,
    input  wire [31:0]                push_src0_val_i,
    input  wire [`ROB_W-1:0]          push_src0_robid_i,
    input  wire                       push_src1_ready_i,
    input  wire [31:0]                push_src1_val_i,
    input  wire [`ROB_W-1:0]          push_src1_robid_i,
    input  wire [31:0]                push_imm_i,
    input  wire                       push_use_imm_i,
    input  wire [31:0]                push_br_offs_i,

    output wire                       can_accept_o,      // 有空位
    output wire [2:0]                 occupancy_o,       // 当前占用项数（dispatch 负载均衡）

    // ---------------- 写回唤醒总线 ×4（带数据）----------------
    input  wire                       wb0_valid_i,       // fu_alu0 写回
    input  wire [`ROB_W-1:0]          wb0_robid_i,
    input  wire [31:0]                wb0_data_i,
    input  wire                       wb1_valid_i,       // fu_alu1 写回
    input  wire [`ROB_W-1:0]          wb1_robid_i,
    input  wire [31:0]                wb1_data_i,
    input  wire                       wb2_valid_i,       // lsu 写回
    input  wire [`ROB_W-1:0]          wb2_robid_i,
    input  wire [31:0]                wb2_data_i,
    input  wire                       wb3_valid_i,       // fu_mdu 写回
    input  wire [`ROB_W-1:0]          wb3_robid_i,
    input  wire [31:0]                wb3_data_i,

    // 提交拍唤醒（与 wb 总线并列，仅唤醒 RS 不等价于 ROB complete）
    input  wire                       cmt_wake0_valid_i,
    input  wire [`ROB_W-1:0]          cmt_wake0_robid_i,
    input  wire [31:0]                cmt_wake0_data_i,
    input  wire                       cmt_wake1_valid_i,
    input  wire [`ROB_W-1:0]          cmt_wake1_robid_i,
    input  wire [31:0]                cmt_wake1_data_i,

    input  wire [`ROB_SIZE-1:0]       rob_done_i,
    input  wire [32*`ROB_SIZE-1:0]    rob_result_flat_i,

    // ---------------- 提前唤醒总线 ×3（无数据，二期接入）----------------
    input  wire                       early0_valid_i,    // fu_alu0 发射拍唤醒
    input  wire [`ROB_W-1:0]          early0_robid_i,
    input  wire                       early1_valid_i,    // fu_alu1 发射拍唤醒
    input  wire [`ROB_W-1:0]          early1_robid_i,
    input  wire                       early2_valid_i,    // lsu AGU 级投机唤醒
    input  wire [`ROB_W-1:0]          early2_robid_i,

    // ---------------- 发射口（到 fu_alu，组合）----------------
    output wire                       issue_valid_o,
    output wire [`ROB_W-1:0]          issue_robid_o,
    output wire [31:0]                issue_pc_o,
    output wire [`ALU_OP_NUM-1:0]     issue_alu_op_o,
    output wire [`BR_OP_NUM-1:0]      issue_br_op_o,
    output wire [31:0]                issue_src0_o,      // 已捕获的最终操作数值
    output wire [31:0]                issue_src1_o,
    output wire [31:0]                issue_imm_o,
    output wire                       issue_use_imm_o,
    output wire [31:0]                issue_br_offs_o
);

localparam N = `RS_ALU_SIZE;

reg                   valid   [0:N-1];
reg [`ROB_W-1:0]      robid   [0:N-1];
reg [31:0]            pc      [0:N-1];
reg [`ALU_OP_NUM-1:0] alu_op  [0:N-1];
reg [`BR_OP_NUM-1:0]  br_op   [0:N-1];
reg                   s0_rdy  [0:N-1];
reg [31:0]            s0_val  [0:N-1];
reg [`ROB_W-1:0]      s0_id   [0:N-1];
reg                   s1_rdy  [0:N-1];
reg [31:0]            s1_val  [0:N-1];
reg [`ROB_W-1:0]      s1_id   [0:N-1];
reg [31:0]            imm     [0:N-1];
reg                   use_imm [0:N-1];
reg [31:0]            br_offs [0:N-1];
reg [1:0]             prior   [0:N-1];   // 年龄：0=最老

reg [2:0] count;
assign occupancy_o  = count;
assign can_accept_o = (count < N[2:0]);

// 一期未用的提前唤醒总线（防 lint 悬空）
wire early_unused = early0_valid_i | early1_valid_i | early2_valid_i
                  | (|early0_robid_i) | (|early1_robid_i) | (|early2_robid_i);

// ---------------- 写回总线匹配（唤醒/捕获共用）----------------
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

function [31:0] rob_result_at;
    input [`ROB_W-1:0] id;
    begin
        rob_result_at = rob_result_flat_i[{id, 5'b0} +: 32];
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
        else if (cmt_wake1_valid_i && (cmt_wake1_robid_i == id)) wb_data = cmt_wake1_data_i;
        else                                                     wb_data = rob_result_at(id);
    end
endfunction

// ---------------- 本拍有效就绪视图（含同拍唤醒旁路）----------------
wire        eff_s0_rdy [0:N-1];
wire [31:0] eff_s0_val [0:N-1];
wire        eff_s1_rdy [0:N-1];
wire [31:0] eff_s1_val [0:N-1];

genvar g;
generate
for (g = 0; g < N; g = g + 1) begin : gen_eff
    wire s0_done = rob_done_i[s0_id[g]];
    wire s1_done = rob_done_i[s1_id[g]];
    assign eff_s0_rdy[g] = s0_rdy[g] | wb_hit(s0_id[g]) | s0_done;
    assign eff_s0_val[g] = s0_rdy[g] ? s0_val[g]
                         : wb_hit(s0_id[g]) ? wb_data(s0_id[g])
                         : rob_result_at(s0_id[g]);
    assign eff_s1_rdy[g] = s1_rdy[g] | wb_hit(s1_id[g]) | s1_done;
    assign eff_s1_val[g] = s1_rdy[g] ? s1_val[g]
                         : wb_hit(s1_id[g]) ? wb_data(s1_id[g])
                         : rob_result_at(s1_id[g]);
end
endgenerate

// ---------------- 发射选择（oldest-first：prior 最小的就绪项）----------------
wire cand0 = valid[0] && eff_s0_rdy[0] && eff_s1_rdy[0];
wire cand1 = valid[1] && eff_s0_rdy[1] && eff_s1_rdy[1];
wire cand2 = valid[2] && eff_s0_rdy[2] && eff_s1_rdy[2];
wire cand3 = valid[3] && eff_s0_rdy[3] && eff_s1_rdy[3];

reg [1:0] sel;
reg       sel_valid;
integer i;
always @(*) begin
    sel = 2'd0;
    sel_valid = 1'b0;
    for (i = N-1; i >= 0; i = i - 1) begin
        if ((i == 0 ? cand0 : i == 1 ? cand1 : i == 2 ? cand2 : cand3)
            && (!sel_valid || (prior[i[1:0]] <= prior[sel]))) begin
            // 倒序扫描 + <=，保证选到 prior 最小者
            sel = i[1:0];
            sel_valid = 1'b1;
        end
    end
end

assign issue_valid_o  = sel_valid && !flush_i;
assign issue_robid_o  = robid[sel];
assign issue_pc_o     = pc[sel];
assign issue_alu_op_o = alu_op[sel];
assign issue_br_op_o  = br_op[sel];
assign issue_src0_o   = eff_s0_val[sel];
assign issue_src1_o   = eff_s1_val[sel];
assign issue_imm_o    = imm[sel];
assign issue_use_imm_o= use_imm[sel];
assign issue_br_offs_o= br_offs[sel];

wire do_issue = issue_valid_o;   // ALU 恒可接收，发射即出队

// ---------------- 空位选择（registered valid 的优先编码）----------------
wire [1:0] free_idx = !valid[0] ? 2'd0 :
                      !valid[1] ? 2'd1 :
                      !valid[2] ? 2'd2 : 2'd3;
wire do_push = push_valid_i && can_accept_o;

// 入站同拍旁路（push 时总线上恰有它等的 robid；仅 tag 等待时用 rob_done）
wire        push_s0_wait = !push_src0_ready_i;
wire        push_s1_wait = !push_src1_ready_i;
wire        push_s0_rdy  = push_src0_ready_i
                        | (push_s0_wait && (wb_hit(push_src0_robid_i) | rob_done_i[push_src0_robid_i]));
wire [31:0] push_s0_val  = push_src0_ready_i ? push_src0_val_i : wb_data(push_src0_robid_i);
wire        push_s1_rdy  = push_src1_ready_i
                        | (push_s1_wait && (wb_hit(push_src1_robid_i) | rob_done_i[push_src1_robid_i]));
wire [31:0] push_s1_val  = push_src1_ready_i ? push_src1_val_i : wb_data(push_src1_robid_i);

// 新入站项的年龄 = 本拍发射后的占用数
wire [1:0] push_prior = do_issue ? (count[1:0] - 2'd1) : count[1:0];

integer k;
always @(posedge clk) begin
    if (reset || flush_i) begin
        for (k = 0; k < N; k = k + 1) valid[k] <= 1'b0;
        count <= 3'd0;
    end else begin
        // 唤醒捕获 + 发射出队 + 年龄维护
        for (k = 0; k < N; k = k + 1) begin
            if (valid[k]) begin
                if (do_issue && (sel == k[1:0])) begin
                    valid[k] <= 1'b0;
                end else begin
                    s0_rdy[k] <= eff_s0_rdy[k];
                    s1_rdy[k] <= eff_s1_rdy[k];
                    if (!s0_rdy[k] && eff_s0_rdy[k]) s0_val[k] <= eff_s0_val[k];
                    if (!s1_rdy[k] && eff_s1_rdy[k]) s1_val[k] <= eff_s1_val[k];
                    if (do_issue && (prior[k] > prior[sel])) prior[k] <= prior[k] - 2'd1;
                end
            end
        end
        // 入站（与发射可同拍；free_idx 基于寄存 valid，不会撞上发射项）
        if (do_push) begin
            valid[free_idx]   <= 1'b1;
            robid[free_idx]   <= push_robid_i;
            pc[free_idx]      <= push_pc_i;
            alu_op[free_idx]  <= push_alu_op_i;
            br_op[free_idx]   <= push_br_op_i;
            s0_rdy[free_idx]  <= push_s0_rdy;
            s0_val[free_idx]  <= push_s0_val;
            s0_id[free_idx]   <= push_src0_robid_i;
            s1_rdy[free_idx]  <= push_s1_rdy;
            s1_val[free_idx]  <= push_s1_val;
            s1_id[free_idx]   <= push_src1_robid_i;
            imm[free_idx]     <= push_imm_i;
            use_imm[free_idx] <= push_use_imm_i;
            br_offs[free_idx] <= push_br_offs_i;
            prior[free_idx]   <= push_prior;
        end
        count <= count + {2'b0, do_push} - {2'b0, do_issue};
    end
end

// lint 吸收
wire rs_alu_lint = early_unused;

endmodule
