// ============================================================
// inst_buffer 模块（指令缓冲，前后端解耦 FIFO）
// ------------------------------------------------------------
// 参考实现说明：
// - 16 项环形 FIFO：前端 ≤4 条/拍写入（连续有效），后端 ≤2 条/拍读出；
// - 灵活判满：can_push 按本拍实际写入条数判断（组合依赖 push*_valid）；
// - 约定：rename 收槽 1 必先收槽 0（head 推进量 = pop0_ready+pop1_ready）；
// - flush 清空。
// ============================================================
`include "mycpu.h"

module inst_buffer(
    input  wire                       clk,
    input  wire                       reset,
    input  wire                       flush_i,

    // ---------------- 前端写入口（最多 4 条/拍）----------------
    input  wire                       push0_valid_i,
    input  wire [31:0]                push0_pc_i,
    input  wire [31:0]                push0_inst_i,
    input  wire                       push0_pred_taken_i,
    input  wire                       push0_is_last_i,
    input  wire [`FTQ_W-1:0]          push0_ftq_id_i,
    input  wire [`EXCP_NUM-1:0]       push0_excp_i,

    input  wire                       push1_valid_i,
    input  wire [31:0]                push1_pc_i,
    input  wire [31:0]                push1_inst_i,
    input  wire                       push1_pred_taken_i,
    input  wire                       push1_is_last_i,
    input  wire [`FTQ_W-1:0]          push1_ftq_id_i,
    input  wire [`EXCP_NUM-1:0]       push1_excp_i,

    input  wire                       push2_valid_i,
    input  wire [31:0]                push2_pc_i,
    input  wire [31:0]                push2_inst_i,
    input  wire                       push2_pred_taken_i,
    input  wire                       push2_is_last_i,
    input  wire [`FTQ_W-1:0]          push2_ftq_id_i,
    input  wire [`EXCP_NUM-1:0]       push2_excp_i,

    input  wire                       push3_valid_i,
    input  wire [31:0]                push3_pc_i,
    input  wire [31:0]                push3_inst_i,
    input  wire                       push3_pred_taken_i,
    input  wire                       push3_is_last_i,
    input  wire [`FTQ_W-1:0]          push3_ftq_id_i,
    input  wire [`EXCP_NUM-1:0]       push3_excp_i,

    output wire                       can_push_o,         // 本拍可接收 ifu 给出的全部有效条目

    // ---------------- 后端读出口（2 槽，槽 0 更老）----------------
    output wire                       pop0_valid_o,
    output wire [31:0]                pop0_pc_o,
    output wire [31:0]                pop0_inst_o,
    output wire                       pop0_pred_taken_o,
    output wire                       pop0_is_last_o,
    output wire [`FTQ_W-1:0]          pop0_ftq_id_o,
    output wire [`EXCP_NUM-1:0]       pop0_excp_o,
    input  wire                       pop0_ready_i,       // rename 级本拍收走槽 0

    output wire                       pop1_valid_o,
    output wire [31:0]                pop1_pc_o,
    output wire [31:0]                pop1_inst_o,
    output wire                       pop1_pred_taken_o,
    output wire                       pop1_is_last_o,
    output wire [`FTQ_W-1:0]          pop1_ftq_id_o,
    output wire [`EXCP_NUM-1:0]       pop1_excp_o,
    input  wire                       pop1_ready_i        // rename 级本拍收走槽 1（收 1 必先收 0）
);

// 条目打包宽度：excp + ftq_id + is_last + pred_taken + inst + pc
localparam ENTRY_W = `EXCP_NUM + `FTQ_W + 1 + 1 + 32 + 32;

reg [ENTRY_W-1:0] mem [0:`IB_SIZE-1];
reg [`IB_W-1:0]   head, tail;
reg [`IB_W:0]     count;

integer ib_i;
initial begin
    head  = {`IB_W{1'b0}};
    tail  = {`IB_W{1'b0}};
    count = {(`IB_W+1){1'b0}};
    for (ib_i = 0; ib_i < `IB_SIZE; ib_i = ib_i + 1)
        mem[ib_i] = {ENTRY_W{1'b0}};
end

wire reset_active = (reset === 1'b1);
wire flush_active = (flush_i === 1'b1);

wire [`IB_W:0] count_now = reset_active ? {(`IB_W+1){1'b0}} : count;

// ---------------- 写入（灵活判满）----------------
wire push0_v = (push0_valid_i === 1'b1);
wire push1_v = (push1_valid_i === 1'b1);
wire push2_v = (push2_valid_i === 1'b1);
wire push3_v = (push3_valid_i === 1'b1);
wire [2:0] push_n_raw = {2'b0, push0_v} + {2'b0, push1_v}
                      + {2'b0, push2_v} + {2'b0, push3_v};
wire [2:0] push_n = (push_n_raw === 3'bx || push_n_raw === 3'bz) ? 3'd0 : push_n_raw;
wire [`IB_W-1:0] push_n_w = {{(`IB_W-3){1'b0}}, push_n};
// 按“最多 4 条/拍”判满，避免与 IFU push_valid 组合成环
assign can_push_o = !reset_active && (count_now <= (`IB_SIZE - `FETCH_WIDTH));

wire do_push = can_push_o && (push_n != 3'd0);

wire [`IB_W-1:0] tail_next = tail + push_n_w;
wire [`IB_W:0]   count_next = count_now + (do_push ? {2'b0, push_n} : {(`IB_W+1){1'b0}})
                              - {{(`IB_W-1){1'b0}}, pop_n_eff};
wire [`IB_W-1:0] head_next = (count_next == {(`IB_W+1){1'b0}})
                           ? tail_next
                           : (head + {{(`IB_W-2){1'b0}}, pop_n_eff});

wire [ENTRY_W-1:0] e0 = {push0_excp_i, push0_ftq_id_i, push0_is_last_i, push0_pred_taken_i, push0_inst_i, push0_pc_i};
wire [ENTRY_W-1:0] e1 = {push1_excp_i, push1_ftq_id_i, push1_is_last_i, push1_pred_taken_i, push1_inst_i, push1_pc_i};
wire [ENTRY_W-1:0] e2 = {push2_excp_i, push2_ftq_id_i, push2_is_last_i, push2_pred_taken_i, push2_inst_i, push2_pc_i};
wire [ENTRY_W-1:0] e3 = {push3_excp_i, push3_ftq_id_i, push3_is_last_i, push3_pred_taken_i, push3_inst_i, push3_pc_i};

// ---------------- 读出 ----------------
wire pop0_ok = (pop0_ready_i === 1'b1);
wire pop1_ok = pop0_ok && (pop1_ready_i === 1'b1);
wire [1:0] pop_n = {1'b0, pop1_ok} + {1'b0, pop0_ok};

assign pop0_valid_o = !reset_active && (count_now >= 1);
assign pop1_valid_o = !reset_active && (count_now >= 2);

wire [ENTRY_W-1:0] h0 = mem[head];
wire [ENTRY_W-1:0] h1 = mem[head + {{(`IB_W-1){1'b0}}, 1'b1}];

assign {pop0_excp_o, pop0_ftq_id_o, pop0_is_last_o, pop0_pred_taken_o, pop0_inst_o, pop0_pc_o} = h0;
assign {pop1_excp_o, pop1_ftq_id_o, pop1_is_last_o, pop1_pred_taken_o, pop1_inst_o, pop1_pc_o} = h1;

// 丢弃 pc=0 && inst=0 的占位项；push 同拍不做 drop（NBA 写尚未可见）
wire h0_garbage = (pop0_pc_o === 32'h0) && (pop0_inst_o === 32'h0);
wire drop_garbage = !reset_active && !flush_active && !do_push
                  && (count_now >= 1) && h0_garbage && !pop0_ok;
wire [1:0] pop_n_eff = pop_n + {1'b0, drop_garbage};

always @(posedge clk) begin
    if (reset_active || flush_active) begin
        head  <= {`IB_W{1'b0}};
        tail  <= {`IB_W{1'b0}};
        count <= {(`IB_W+1){1'b0}};
    end else begin
        if (do_push) begin
            // ifu 保证 push0..n-1 连续有效
            if (push0_v) mem[tail]                              <= e0;
            if (push1_v) mem[tail + {{(`IB_W-2){1'b0}}, 2'd1}] <= e1;
            if (push2_v) mem[tail + {{(`IB_W-2){1'b0}}, 2'd2}] <= e2;
            if (push3_v) mem[tail + {{(`IB_W-2){1'b0}}, 2'd3}] <= e3;
            tail <= tail_next;
        end
        head  <= head_next;
        count <= count_next[`IB_W:0];
        if (pop0_ok)
            mem[head] <= {ENTRY_W{1'b0}};
        if (pop1_ok)
            mem[head + {{(`IB_W-1){1'b0}}, 1'b1}] <= {ENTRY_W{1'b0}};
        if (drop_garbage)
            mem[head] <= {ENTRY_W{1'b0}};
`ifdef CODEX_DEBUG_SIM
        if (do_push)
            $display("DBG_IB_WR do=1 pn=%d cnt=%d->%d tail=%d->%d head=%d->%d p0=%b p1=%b pc0=%h inst0=%h",
                     push_n, count_now, count_next[`IB_W:0],
                     tail, tail_next, head, head_next,
                     push0_v, push1_v, push0_pc_i, push0_inst_i);
        if (drop_garbage)
            $display("DBG_IB_DROP cnt=%d head=%d", count_now, head);
`endif
    end
end

endmodule
