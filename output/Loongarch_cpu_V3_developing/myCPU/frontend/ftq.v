// ============================================================
// ftq 模块（Fetch Target Queue，取指目标队列）
// ------------------------------------------------------------
// 功能：
// - 前端的"调度中枢"：BPU 产生的预测块先进队列，IFU 按自己的节奏消费，
//   实现 BPU 与 IFU 解耦（BPU 可以跑在 IFU 前面）。
// - 暂存每个块的 BPU 训练元数据（meta），等后端提交该块后把
//   训练包回送给 BPU（保证只用"确定正确"的结果训练预测器）。
// - 三指针环形队列（`FTQ_SIZE=8 项）：
//   * bpu_ptr：BPU 写入位置（P0 当拍写入；P1 覆盖 bpu_ptr-1 处上一拍的块）
//   * ifu_ptr：IFU 读取位置
//   * cmt_ptr：提交释放位置（后端整块提交完毕后前移）
// - 满判断：bpu_ptr+1 == cmt_ptr（最多缓冲 8 块 × 4 条 = 32 条，与 ROB 对齐）。
//
// 端口：
// - p0_* / p1_*       ：BPU 写入口（p1 为覆盖写）
// - ifu_*             ：IFU 取块口（valid/accept 握手）
// - predec_redirect_i ：IFU 预译码重定向（回退 bpu_ptr 到出错块之后并修正块信息）
// - cmt_*             ：commit 提交信息入口（推进 cmt_ptr + 取出 meta 产生训练包）
// - train_*           ：送往 BPU 的训练包
// - flush_i           ：提交级全局冲刷（整个队列清空）
// ============================================================
`include "mycpu.h"

module ftq(
    input  wire                       clk,
    input  wire                       reset,
    input  wire                       flush_i,             // 全局冲刷：三指针清零、全部作废

    // ---------------- BPU 写入口 ----------------
    input  wire                       p0_valid_i,          // 当拍基础块写入 bpu_ptr
    input  wire [31:0]                p0_pc_i,
    input  wire [`BLK_LEN_W-1:0]      p0_length_i,
    input  wire                       p0_taken_i,
    input  wire [31:0]                p0_target_i,
    input  wire [`BR_TYPE_W-1:0]      p0_br_type_i,

    input  wire                       p1_valid_i,          // 覆盖 bpu_ptr-1 处的块（主预测修正）
    input  wire [31:0]                p1_pc_i,
    input  wire [`BLK_LEN_W-1:0]      p1_length_i,
    input  wire                       p1_taken_i,
    input  wire [31:0]                p1_target_i,
    input  wire [`BR_TYPE_W-1:0]      p1_br_type_i,
    input  wire [`BPU_META_W-1:0]     p1_meta_i,           // BPU 训练元数据，存入该块

    output wire                       ftq_full_o,          // 满反压 BPU

    // ---------------- IFU 取块口 ----------------
    output wire                       ifu_valid_o,         // 有块可取
    output wire [31:0]                ifu_pc_o,            // 块起始 PC
    output wire [`BLK_LEN_W-1:0]      ifu_length_o,        // 块长
    output wire                       ifu_taken_o,         // 块末预测跳转
    output wire [31:0]                ifu_target_o,        // 预测目标（仅 taken 时有意义）
    output wire [`FTQ_W-1:0]          ifu_ftq_id_o,        // 该块的 FTQ 编号（随指令流入后端）
    input  wire                       ifu_accept_i,        // IFU 收下本块（ifu_ptr++）

    // ---------------- IFU 预译码重定向 ----------------
    input  wire                       predec_redirect_i,    // 预译码发现漏预测的直接跳转
    input  wire [`FTQ_W-1:0]          predec_redirect_id_i, // 出错块的 FTQ 编号
    input  wire [`BLK_LEN_W-1:0]      predec_length_i,      // 修正后的块长（截断到跳转指令）
    input  wire                       predec_taken_i,       // 修正后的方向（恒 1）
    input  wire [31:0]                predec_target_i,      // 修正后的目标
    input  wire [`BR_TYPE_W-1:0]      predec_br_type_i,

    // ---------------- 提交信息入口（来自 commit）----------------
    input  wire                       cmt_valid_i,          // 本拍有指令提交
    input  wire [`FTQ_W-1:0]          cmt_ftq_id_i,         // 提交指令所在块编号
    input  wire                       cmt_is_last_i,        // 是否为块内最后一条（整块提交完毕->cmt_ptr++）
    input  wire                       cmt_is_branch_i,      // 提交的是分支
    input  wire                       cmt_taken_i,          // 实际方向
    input  wire                       cmt_mispred_i,        // 是否误预测
    input  wire [31:0]                cmt_target_i,         // 实际跳转目标
    input  wire [`BR_TYPE_W-1:0]      cmt_br_type_i,
    input  wire [31:0]                cmt_pc_i,             // 分支指令 PC

    // ---------------- commit 误预测比对查询口（组合）----------------
    input  wire [`FTQ_W-1:0]          cmt_query_id_i,       // commit 用提交分支的块编号查预测目标
    output wire [31:0]                cmt_blk_target_o,     // 该块当时的预测跳转目标

    // ---------------- 训练包出口（送 BPU）----------------
    output wire                       train_valid_o,
    output wire [31:0]                train_pc_o,           // 块起始 PC（FTB/uBTB 用块 PC 训练）
    output wire                       train_is_branch_o,
    output wire                       train_taken_o,
    output wire                       train_mispred_o,
    output wire [31:0]                train_target_o,
    output wire [`BR_TYPE_W-1:0]      train_br_type_o,
    output wire [31:0]                train_fall_through_o, // 块顺序出口（= 块PC + 4*块长）
    output wire [`BPU_META_W-1:0]     train_meta_o          // 暂存的 meta 原样回送
);

//TODO: 实现三指针环形 FTQ（参考：团队赛 ftq.sv、满洋 frontend/ftq.sv）
//
//TODO: 存储结构（LUTRAM/reg，当拍读）：
//      reg [`FTQ_SIZE-1:0]      valid;
//      reg [31:0]               blk_pc    [0:`FTQ_SIZE-1];
//      reg [`BLK_LEN_W-1:0]     blk_len   [0:`FTQ_SIZE-1];
//      reg                      blk_taken [0:`FTQ_SIZE-1];
//      reg [31:0]               blk_target[0:`FTQ_SIZE-1];
//      reg [`BR_TYPE_W-1:0]     blk_btype [0:`FTQ_SIZE-1];
//      reg [`BPU_META_W-1:0]    blk_meta  [0:`FTQ_SIZE-1];
//      reg [`FTQ_W-1:0]         bpu_ptr, ifu_ptr, cmt_ptr;
//
//TODO: 写入/覆盖：
//      - p0_valid_i：写 blk_*[bpu_ptr]，bpu_ptr++（meta 先写 0）。
//      - p1_valid_i：覆盖 blk_*[bpu_ptr-1]（即上一拍 P0 写入的块）并写入 meta。
//        注意：若 P1 修正了块边界（块变短/方向变跳），且 IFU 恰好已把旧块取走
//        （ifu_ptr 已越过该块），必须把 ifu_ptr 拉回该块位置并通知 IFU 作废在途请求
//        （输出一个 ifu 重取脉冲，或约定 IFU 只在 ifu_valid 稳定 1 拍后才 accept，
//        团队赛用 to_ifu_redirect 信号处理，建议同样加一根线——一期可先约定
//        "P1 覆盖只发生在 IFU 尚未取走该块时"（IFU accept 比 BPU 慢一拍即可保证））。
//
//TODO: IFU 取块：
//      ifu_valid_o = valid[ifu_ptr] && (ifu_ptr != bpu_ptr 的空判断)；
//      输出 blk_*[ifu_ptr] + ifu_ftq_id_o = ifu_ptr；ifu_accept_i 时 ifu_ptr++。
//
//TODO: 预译码重定向：
//      predec_redirect_i 时：
//        - 用 predec_* 修正 blk_*[predec_redirect_id_i]（块长截断、taken=1、目标/类型更新）
//        - bpu_ptr 回退到 predec_redirect_id_i + 1（丢弃其后所有推测块）
//        - ifu_ptr 不动（出错块本身已被 IFU 正确截断送出）
//
//TODO: 提交与训练：
//      - cmt_valid_i && cmt_is_last_i：cmt_ptr++（该块全部指令提交完毕，槽位释放）。
//      - cmt_valid_i && cmt_is_branch_i：产生训练包：
//          train_pc_o          = blk_pc[cmt_ftq_id_i]（块起始 PC）
//          train_fall_through_o= blk_pc + 4*实际块长（实际块长=分支在块内的位置+1，
//                                可由 cmt_pc_i - blk_pc 算出，更稳妥）
//          train_taken/mispred/target/br_type = cmt_* 直通
//          train_meta_o        = blk_meta[cmt_ftq_id_i]
//        训练包可以当拍直通（组合）或打一拍再给 BPU（时序更松，推荐打一拍）。
//
//TODO: commit 查询口（纯组合）：
//      cmt_blk_target_o = blk_target[cmt_query_id_i];
//      （提交时该块槽位必然还未释放——cmt_ptr 只有在块提交后才推进，
//        所以这里读到的就是预测当时存入的目标，供 commit 判"目标误预测"。）
//
//TODO: 满/空判断：
//      ftq_full_o = (bpu_ptr+1 == cmt_ptr)；空 = (bpu_ptr == ifu_ptr 且无 valid)。
//      指针都是 `FTQ_W 位环形回绕，注意用 valid 位辅助区分满/空。
//
//TODO: 坑点提示：
//      1. flush_i 时三指针同时清零、valid 全清——提交级冲刷意味着 ROB 已空，
//         FTQ 里所有块都是错误路径或已提交完，直接全清是安全的。
//      2. cmt_ptr 的推进依赖"块内最后一条提交"标记（cmt_is_last_i），该标记由
//         IFU 切块时打在每条指令上、随流水带到 ROB，commit 提交时回传，别丢。
//      3. 一期不做 FTQ 引导预取；二期可在 ifu_ptr 之后的块上向 icache 发预取
//        （AXI 优化约定，详见计划，接口可后加）。

endmodule
