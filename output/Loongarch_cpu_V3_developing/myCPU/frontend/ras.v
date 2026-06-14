// ============================================================
// ras 模块（Return Address Stack，返回地址栈，双栈结构）
// ------------------------------------------------------------
// 功能：
// - 预测函数返回指令（jirl rd=r0, rj=r1）的目标地址。
// - 双栈结构（参考团队赛 ras_my.sv）：
//   * 前端推测栈：BPU 预测到 CALL 时 push（返回地址 = call 块的 fall_through），
//     预测到 RET 时 pop 并把栈顶作为预测目标。会被错误路径污染。
//   * 提交栈：commit 级提交真正的 call/ret 时维护，永远正确。
//   * 全局冲刷（flush）时：前端栈整体复制提交栈内容，消除推测污染。
// - 仅由 bpu.v 内部例化。
//
// 端口：
// - spec_push/pop  ：前端推测维护（BPU P1 级预测 CALL/RET 时）
// - top_addr_o     ：前端栈栈顶（RET 的预测目标）
// - cmt_push/pop   ：提交栈维护（commit 提交 call/ret 时）
// - flush_i        ：冲刷时前端栈 <= 提交栈
// ============================================================
`include "mycpu.h"

module ras(
    input  wire                clk,
    input  wire                reset,

    // ---------------- 冲刷恢复 ----------------
    input  wire                flush_i,            // 前端栈整体复制提交栈

    // ---------------- 前端推测栈 ----------------
    input  wire                spec_push_i,        // BPU 预测到 CALL
    input  wire [31:0]         spec_push_addr_i,   // 返回地址（call 块 fall_through）
    input  wire                spec_pop_i,         // BPU 预测到 RET
    output wire [31:0]         top_addr_o,         // 栈顶（RET 预测目标）
    output wire                empty_o,            // 栈空（空时 RET 退化用 FTB fall_through）

    // ---------------- 提交栈 ----------------
    input  wire                cmt_push_i,         // commit 提交 call
    input  wire [31:0]         cmt_push_addr_i,    // 真实返回地址（call PC+4）
    input  wire                cmt_pop_i           // commit 提交 ret
);

//TODO: 实现双栈 RAS（参考：团队赛 ras_my.sv 的 pre_train_lutram + BU_lutram 双栈方案）
//
//TODO: 存储结构（LUTRAM/reg，当拍读栈顶）：
//      reg [31:0]        spec_stack[0:`RAS_DEPTH-1];  reg [`RAS_W-1:0] spec_ptr;  // 前端栈
//      reg [31:0]        cmt_stack [0:`RAS_DEPTH-1];  reg [`RAS_W-1:0] cmt_ptr;   // 提交栈
//      可以各加一个计数器/空标志位实现 empty_o。
//
//TODO: 前端栈操作：
//      spec_push_i: spec_stack[spec_ptr+1] <= spec_push_addr_i; spec_ptr <= spec_ptr+1;
//      spec_pop_i : spec_ptr <= spec_ptr-1;
//      同拍 push+pop（call 和 ret 不会同拍出现在同一个预测块，无需处理）。
//      栈满回绕覆盖最旧项（环形指针自然处理，深调用链超过 32 层时精度下降可接受）。
//
//TODO: 提交栈操作：cmt_push_i / cmt_pop_i 同理维护 cmt_stack/cmt_ptr。
//
//TODO: 冲刷恢复：
//      flush_i 时：spec_ptr <= cmt_ptr; 且 spec_stack 内容整体复制 cmt_stack。
//      32 项 ×32bit 的整体复制用 generate-for 一拍完成（LUTRAM 阵列对拷，
//      团队赛就是这样做的；面积可接受）。
//
//TODO: 坑点提示：
//      1. "返回地址"定义务必统一：BPU 推测 push 的是预测块的 fall_through，
//         commit push 的是 call 指令 PC+4 —— 两者必须是同一个值
//         （call 一定是块内最后一条指令，fall_through == call_pc+4，自行确保）。
//      2. flush 与 cmt_push/pop 同拍时：先完成提交栈更新、再用更新后的值恢复
//         前端栈（即恢复用 cmt_ptr 的"新值"），否则会差一层。

endmodule
