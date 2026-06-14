// ============================================================
// ctrl 模块（全局冲刷/重定向仲裁与分发）
// ------------------------------------------------------------
// 参考实现说明：
// - 一期 commit 是唯一冲刷源：flush 组合直通广播（一拍脉冲）；
// - idle 睡眠：idle 提交置 idle_lock 冻结取指，中断到来解锁；
// - 二期执行级重定向入口已预留（一期恒 0，参与 lint 吸收）。
// ============================================================
`include "mycpu.h"

module ctrl(
    input  wire                       clk,
    input  wire                       reset,

    // ---------------- commit 冲刷请求 ----------------
    input  wire                       cmt_flush_req_i,     // 提交级请求冲刷（一拍）
    input  wire [`FLUSH_TYPE_W-1:0]   cmt_flush_type_i,    // FLUSH_MISPRED/EXCP/ERTN/REFETCH
    input  wire [31:0]                cmt_flush_pc_i,      // 冲刷后取指目标

    // ---------------- 二期：执行级分支重定向（预留，一期接 0）----------------
    input  wire                       ex_redirect_req_i,
    input  wire [31:0]                ex_redirect_pc_i,

    // ---------------- idle 睡眠控制 ----------------
    input  wire                       idle_commit_i,       // idle 指令提交（随 flush 同拍）
    input  wire                       has_int_i,           // CSR 有未屏蔽中断

    // ---------------- 全局广播 ----------------
    output wire                       flush_o,             // 全局冲刷（一拍脉冲，接所有模块 flush_i）
    output wire [31:0]                flush_pc_o,          // 重定向 PC（接 bpu.flush_pc_i）
    output wire                       fetch_stall_o        // idle 睡眠期间冻结 BPU 取指
);

// 一期：commit 唯一冲刷源，组合直通
assign flush_o    = cmt_flush_req_i;
assign flush_pc_o = cmt_flush_req_i ? cmt_flush_pc_i : ex_redirect_pc_i;

// idle 睡眠锁
reg idle_lock;
always @(posedge clk) begin
    if (reset)
        idle_lock <= 1'b0;
    else if (idle_commit_i)
        idle_lock <= 1'b1;
    else if (has_int_i)
        idle_lock <= 1'b0;
end

assign fetch_stall_o = idle_lock;

// lint 吸收（二期接口与冲刷类型暂未使用）
wire ctrl_lint = ex_redirect_req_i | (|cmt_flush_type_i);

endmodule
