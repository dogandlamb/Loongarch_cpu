// ============================================================
// ctrl 模块（全局冲刷/重定向仲裁与分发）
// ------------------------------------------------------------
// 功能：
// - 接收 commit 级的冲刷请求（误预测/异常/ertn/refetch），仲裁后向全核
//   广播一拍 flush 脉冲与重定向 PC。本架构（一期）所有恢复都走
//   "提交级统一冲刷"：RAT/RS/ROB/rename/dispatch/IB/IFU/FTQ 全清，
//   BPU 的 PC 重定向到 flush_pc —— 天然正确，无需任何部分恢复逻辑。
// - idle 指令支持：idle 提交后冻结取指，直到有中断到来才放行。
// - 二期预留：执行级分支重定向入口（fu_alu 算出误预测当拍冲前端，
//   需配合 RAT 检查点，见 TODO）。
//
// 端口：
// - cmt_flush_*    ：commit 冲刷请求（类型 + 目标 PC）
// - ex_redirect_*  ：二期执行级重定向入口（一期悬空）
// - flush_o/pc     ：全局冲刷广播（一拍脉冲）
// - idle_commit_i / has_int_i / fetch_stall_o ：idle 睡眠控制
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

//TODO: 实现全局控制（一期非常简单，几十行；参考：团队赛 ctrl.sv 的 flush 仲裁部分）
//
//TODO: 冲刷广播：
//      flush_o    = cmt_flush_req_i /*| ex_redirect_req_i（二期）*/;
//      flush_pc_o = cmt_flush_req_i ? cmt_flush_pc_i : ex_redirect_pc_i;
//      一期 commit 是唯一冲刷源，无需优先级仲裁；打不打一拍寄存看时序
//      （flush 扇出很大，建议在顶层对 flush 做一级寄存复制再分发，
//       commit 请求时序上留有余量——但注意打拍后 commit 侧要保证请求只发一拍）。
//
//TODO: idle 睡眠：
//      reg idle_lock;
//      idle_commit_i（伴随 FLUSH_REFETCH 冲刷）-> idle_lock <= 1（冻结取指）；
//      idle_lock && has_int_i -> idle_lock <= 0（中断到来，放行取指，
//        中断本身会在第一条新指令提交时附着触发异常入口）。
//      fetch_stall_o = idle_lock;（bpu 内 PC 保持、不产生新块；
//        实现上可直接与 ftq_full 一起作为 BPU 的停止条件，顶层已并联）
//
//TODO: 二期升级路径（执行级重定向，写给后来人）：
//      1. fu_alu 解析出分支误预测当拍 -> ex_redirect_req 冲前端（FTQ/IFU/IB 清空，
//         BPU 重定向），后端"分支之后的指令"需要选择性作废：
//         ROB tail 回滚到分支处 + RS 中比分支年轻的项作废（按 robid 年龄判断）。
//      2. RAT 恢复是难点：方案 A）分支重命名时做 RAT 快照（checkpoint，4~8 份），
//         误预测恢复快照；方案 B）等流水线排空后用"提交态重建"。先做 A 的 1 份
//         快照（同时只允许 1 条在飞分支投机）就能拿到大部分收益。
//      3. 在此之前，一期的提交级冲刷已保证功能完全正确，可放心先跑分。

reg idle_lock;

always @(posedge clk) begin
    if (reset) begin
        idle_lock <= 1'b0;
    end else if (has_int_i) begin
        idle_lock <= 1'b0;
    end else if (idle_commit_i) begin
        idle_lock <= 1'b1;
    end
end

assign flush_o = cmt_flush_req_i | ex_redirect_req_i;
assign flush_pc_o = cmt_flush_req_i ? cmt_flush_pc_i : ex_redirect_pc_i;
assign fetch_stall_o = idle_lock;

endmodule
