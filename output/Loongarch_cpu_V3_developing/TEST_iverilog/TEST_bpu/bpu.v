// ============================================================
// bpu 模块（分支预测单元顶层）
// ------------------------------------------------------------
// 功能：
// - 维护取指 PC，每周期对一个起始 PC 预测出一个"基本块"（最多 `FETCH_WIDTH 条指令）。
// - 两级覆盖式预测（参考 团队赛/满洋 的解耦前端 + 香山思想）：
//   * P0（当拍）：先查 uBTB；uBTB 命中则当拍给出跳转块，否则默认给出
//     "顺序取满 4 条（行边界截断）"的基础块。当拍写入 FTQ，保证取指无空泡。
//   * P1（下一拍）：FTB/TAGE 的 BRAM 查表结果返回。若 FTB 命中且与 P0
//     给出的块不同（块长/方向/目标不同），则用 P1 块"覆盖"FTQ 中上一拍
//     写入的块，并把内部 PC 重定向到正确的下一块起始地址。
// - 内部例化 4 个子模块：ubtb.v / ftb.v / tage.v / ras.v（端口均已定义好）。
// - 提交级训练：FTQ 在基本块提交后把暂存的训练包（实际方向/目标/meta）送回，
//   本模块据此更新 FTB/TAGE/uBTB；RAS 由提交栈恢复机制保证正确。
//
// 端口：
// - flush_i/flush_pc_i        ：提交级全局冲刷（误预测/异常/ertn/refetch），PC 重置
// - predec_redirect_i/pc_i    ：IFU 预译码发现漏预测的直接跳转，前端自重定向
// - ftq_full_i                ：FTQ 满反压，PC 冻结、停止产生新块
// - p0_*                      ：当拍基础预测块 -> FTQ
// - p1_*                      ：下一拍主预测覆盖块 -> FTQ（带 BPU 训练 meta）
// - train_*                   ：来自 FTQ 的提交后训练包
// - cmt_is_call/ret/retaddr_i ：提交级 call/ret 信息，维护 RAS 提交栈
// ============================================================
`include "mycpu.h"

module bpu(
    input  wire                       clk,
    input  wire                       reset,

    // ---------------- 冲刷 / 重定向 ----------------
    input  wire                       flush_i,            // 提交级全局冲刷
    input  wire [31:0]                flush_pc_i,         // 冲刷后重定向 PC
    input  wire                       predec_redirect_i,  // 预译码前端自重定向
    input  wire [31:0]                predec_redirect_pc_i,

    // ---------------- FTQ 反压 ----------------
    input  wire                       ftq_full_i,

    // ---------------- P0 基础预测块（当拍）----------------
    output wire                       p0_valid_o,
    output wire [31:0]                p0_pc_o,            // 块起始 PC
    output wire [`BLK_LEN_W-1:0]      p0_length_o,        // 块长（1~FETCH_WIDTH，行边界截断）
    output wire                       p0_taken_o,         // uBTB 命中时可为 1
    output wire [31:0]                p0_target_o,        // uBTB 给出的跳转目标
    output wire [`BR_TYPE_W-1:0]      p0_br_type_o,

    // ---------------- P1 主预测覆盖块（下一拍）----------------
    output wire                       p1_valid_o,         // 1=用本块覆盖 FTQ 中上一拍写入的块
    output wire [31:0]                p1_pc_o,
    output wire [`BLK_LEN_W-1:0]      p1_length_o,
    output wire                       p1_taken_o,
    output wire [31:0]                p1_target_o,
    output wire [`BR_TYPE_W-1:0]      p1_br_type_o,
    output wire [`BPU_META_W-1:0]     p1_meta_o,          // TAGE/FTB 训练元数据，FTQ 暂存

    // ---------------- 提交后训练（来自 FTQ）----------------
    input  wire                       train_valid_i,
    input  wire [31:0]                train_pc_i,          // 分支指令 PC
    input  wire                       train_is_branch_i,   // 该提交块内是否含分支
    input  wire                       train_taken_i,       // 实际方向
    input  wire                       train_mispred_i,     // 是否误预测
    input  wire [31:0]                train_target_i,      // 实际跳转目标
    input  wire [`BR_TYPE_W-1:0]      train_br_type_i,
    input  wire [31:0]                train_fall_through_i,// 块顺序出口地址（FTB 用）
    input  wire [`BPU_META_W-1:0]     train_meta_i,        // 预测时暂存的 meta 原样回传

    // ---------------- RAS 提交栈维护（来自 commit）----------------
    input  wire                       cmt_is_call_i,
    input  wire                       cmt_is_ret_i,
    input  wire [31:0]                cmt_call_retaddr_i
);

//TODO: 本模块为分支预测单元顶层，请按下面的步骤实现（参考：团队赛 bpu.sv、满洋 BPU/bpu.sv）
//
//TODO: 第一步——维护取指 PC 寄存器（这是整个前端的源头）：
//      reg [31:0] pc;
//      复位值 32'h1c000000（LA32R 复位入口）。
//      每拍 PC 更新优先级（从高到低）：
//        1) flush_i           -> pc <= flush_pc_i;（提交级冲刷，最高优先级）
//        2) predec_redirect_i -> pc <= predec_redirect_pc_i;（预译码重定向）
//        3) p1 覆盖重定向     -> pc <= P1 块的下一地址（taken ? target : fall_through）
//        4) ftq_full_i        -> pc 保持不动（FTQ 满，前端停）
//        5) 正常              -> pc <= P0 块的下一地址（taken ? ubtb目标 : pc + 4*length）
//
//TODO: 第二步——生成 P0 基础块（纯组合，当拍有效）：
//      - 用当前 pc 查 ubtb（组合返回 hit/taken/target/length）。
//      - 块长计算：默认取满 4 条，但不能跨 cache 行（行 `CACHE_LINE_BYTES 字节）：
//          行内剩余字数 = (`CACHE_LINE_BYTES - pc[`CACHE_LINE_W-1:0]) >> 2
//          p0_length = min(4, 行内剩余字数)；uBTB 命中且其记录的块更短则取 uBTB 的长度。
//        （跨行截断的意义：保证 IFU 一次 icache 整行读就能切出整个块，参考团队赛 bpu.sv 61-77 行）
//      - p0_valid = ~ftq_full_i &（无冲刷）。
//
//TODO: 第三步——生成 P1 覆盖块（时序，比 P0 晚一拍）：
//      - 把 pc 打一拍得 pc_r；FTB/TAGE 的 BRAM 查表结果本拍返回（查表地址是上一拍的 pc）。
//      - 若 ftb_hit：
//          * 块长 = (ftb_fall_through - pc_r) >> 2（FTB 存的顺序出口算出真实块长）
//          * 方向：br_type==COND ? tage_taken : 1'b1（CALL/RET/UNCOND 恒跳）
//          * 目标：br_type==RET ? ras_top : ftb_target
//          * 与上一拍 P0 块比较，若（块长/taken/目标）任一不同 -> p1_valid=1 发起覆盖，
//            并将内部 pc 重定向（见第一步优先级 3）。
//          * RAS 前端栈推测维护：预测到 CALL -> push(fall_through)；预测到 RET -> pop。
//      - p1_meta_o 打包 TAGE 的 provider 编号/altpred/各表 ctr 等（格式由 tage.v 实现者定，
//        FTQ 只负责原样暂存、提交后原样送回 train_meta_i）。
//
//TODO: 第四步——例化 4 个子模块并连线（端口已在各自文件中定义好）：
//      ubtb u_ubtb(...);   // 查询口接 pc；更新口接 train_*（仅回跳/误预测的分支回填）
//      ftb  u_ftb (...);   // 查询口接 pc（BRAM 1 拍延迟）；更新口接 train_*
//      tage u_tage(...);   // 查询口接 pc；训练口接 train_*
//      ras  u_ras (...);   // 前端栈推测 push/pop；提交栈接 cmt_*；flush 时用提交栈覆盖前端栈
//
//TODO: 第五步——训练通路：
//      - train_valid_i 有效时：
//          * FTB：未命中过的分支首次 taken / 目标错 / 类型变化 -> 写入或更新 FTB 条目
//          * TAGE：仅条件分支训练（train_br_type==COND），误预测时按 TAGE 规则分配长历史表项
//          * uBTB：仅回填"向回跳转的短循环分支"（target < pc），弥补 FTB 提交训练慢的问题
//      - GHR（全局历史）一期建议只在提交训练时更新（简单正确）；
//        二期优化为预测时投机更新 + 冲刷时恢复（需要 GHR 快照，见香山文档）。
//
//TODO: 注意事项（坑点提示）：
//      1. P1 覆盖只能覆盖"上一拍 P0 写入 FTQ 的那一项"，FTQ 侧已有对应处理逻辑；
//         若上一拍因 ftq_full 没写入，则本拍 P1 也必须作废（用打拍的 ftq_full_r 屏蔽）。
//      2. flush_i 当拍必须把 P0/P1 全部作废（否则错误路径的块会写进 FTQ）。
//      3. uBTB 是可选优化（团队赛报告中有设计但复赛代码未合入），可以先把 uBTB 的
//         hit 恒接 0 跑通整个前端，再开启 uBTB 调试。
//      4. RAS 恢复策略：flush 时前端栈整体复制提交栈（双栈方案，参考团队赛 ras_my.sv）。

endmodule
