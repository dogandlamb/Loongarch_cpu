// ============================================================
// inst_buffer 模块（指令缓冲，前后端解耦 FIFO）
// ------------------------------------------------------------
// 功能：
// - `IB_SIZE（16）项 FIFO：前端每拍最多写入 `FETCH_WIDTH（4）条，
//   后端每拍最多读出 `MACHINE_WIDTH（2）条去译码/重命名。
// - 吸收前端（4 宽突发取指）与后端（2 宽消费）的速率差，
//   前端 icache miss 时后端可继续消费存量，后端阻塞时前端可继续取指。
// - 每项内容：{pc, inst, pred_taken, is_last_in_block, ftq_id, 取指异常向量}。
// - "灵活判满"：按本拍实际要写入的条数动态判断是否还有空间
//   （而不是永远保留 4 个空位），提高缓冲利用率（参考团队赛 inst_buffer.sv）。
//
// 端口：
// - push0~3_*    ：前端写入口（ifu 的 ib_push* 直连）
// - can_push_o   ：本拍可写入（给 ifu 反压）
// - pop0/1_*     ：后端读出口（两槽，0 槽更老）
// - pop0/1_ready ：后端收走使能（rename 级反压）
// - flush_i      ：全局冲刷清空
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

//TODO: 实现 16 项环形 FIFO（参考：团队赛 inst_buffer.sv、满洋 instr_buffer.sv 多通道方案）
//
//TODO: 存储结构（reg/LUTRAM，当拍读）：
//      每项打包成一个宽位向量存放：{excp, ftq_id, is_last, pred_taken, inst, pc}
//      reg [ENTRY_W-1:0] mem[0:`IB_SIZE-1];  reg [`IB_W-1:0] head, tail;  reg [`IB_W:0] count;
//      （用 count 计数器判满/空最直观，4 入 2 出位宽给足）
//
//TODO: 写入（灵活判满）：
//      本拍写入条数 n = push0_valid + push1_valid + push2_valid + push3_valid（ifu 保证连续）；
//      can_push_o = (count + n <= `IB_SIZE)。注意 can_push 是对"本拍这批"的判断，
//      组合依赖 push*_valid，ifu 端用它做整批写/不写（不能拆半批）。
//      写入时按 tail 依次放入 n 条，tail += n，count += n。
//
//TODO: 读出：
//      pop0 = mem[head]，pop1 = mem[head+1]；valid 由 count 决定（>=1、>=2）。
//      head 推进量 = pop0_ready + pop1_ready（约定 rename 收 1 必先收 0，
//      即 pop1_ready=1 时必有 pop0_ready=1，双发射时同时收两条）。
//      count 同拍按 入-出 增减。
//
//TODO: 冲刷：flush_i 时 head/tail/count 全清（IB 中全是错误路径或未发射指令，
//      提交级冲刷语义下直接丢弃是安全的）。
//
//TODO: 坑点提示：
//      1. 同拍又读又写时 count 的增减要合并到一个 always 块里算总账，
//         分开写会综合出多驱动。
//      2. pop 端口直接组合读 mem[head]，head 是 reg，没有读延迟问题；
//         别把 mem 推断成 BRAM（保持 reg 数组+异步读写法，Vivado 会用 LUTRAM）。

endmodule
