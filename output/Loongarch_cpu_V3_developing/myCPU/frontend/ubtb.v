// ============================================================
// ubtb 模块（micro-BTB，当拍返回的小型分支目标缓冲）
// ------------------------------------------------------------
// 功能：
// - `UBTB_SIZE（16）项全相联小表，用触发器/LUTRAM 实现，查询当拍组合返回。
// - 解决"taken bubble"问题：FTB/TAGE 走 BRAM 有 1 拍延迟，且 FTB 只在提交时
//   训练（小循环里 FTB 还没学会，BPU 就已经又预测到该分支了）。uBTB 在
//   分支提交训练时立即回填"向回跳转"的分支，使下一次循环 P0 当拍即可命中。
// - 仅由 bpu.v 内部例化，不直接连顶层。
//
// 端口：
// - query_pc_i      ：当前预测块起始 PC（组合查询）
// - hit_o/taken_o…  ：当拍命中信息（给 P0 块）
// - update_*        ：提交训练回填口（仅回填回跳分支）
// ============================================================
`include "mycpu.h"

module ubtb(
    input  wire                       clk,
    input  wire                       reset,

    // ---------------- 查询口（组合，当拍返回）----------------
    input  wire [31:0]                query_pc_i,        // 预测块起始 PC
    output wire                       hit_o,             // 命中
    output wire                       taken_o,           // 命中项的方向（uBTB 一般只存恒跳/强跳分支）
    output wire [31:0]                target_o,          // 跳转目标
    output wire [`BLK_LEN_W-1:0]      length_o,          // 块长（起始 PC 到分支指令的条数）
    output wire [`BR_TYPE_W-1:0]      br_type_o,

    // ---------------- 更新口（提交训练时回填）----------------
    input  wire                       update_valid_i,    // 本拍有训练
    input  wire [31:0]                update_block_pc_i, // 块起始 PC（作为 tag）
    input  wire                       update_taken_i,
    input  wire [31:0]                update_target_i,
    input  wire [`BLK_LEN_W-1:0]      update_length_i,
    input  wire [`BR_TYPE_W-1:0]      update_br_type_i
);

//TODO: 实现 16 项全相联 uBTB（参考：团队赛报告 2.2.1.3 节 uBTB 设计；代码中无实现需自写）
//
//TODO: 存储结构（全部用 reg，保证当拍组合读出）：
//      reg [`UBTB_SIZE-1:0]        valid;
//      reg [31:0]                  tag   [0:`UBTB_SIZE-1];  // 直接存完整块起始 PC 做精确匹配
//      reg [31:0]                  target[0:`UBTB_SIZE-1];
//      reg [`BLK_LEN_W-1:0]        length[0:`UBTB_SIZE-1];
//      reg [`BR_TYPE_W-1:0]        btype [0:`UBTB_SIZE-1];
//      （16 项很小，tag 存满 32 位没压力；也可以学团队赛用 pc 低位索引+高位 tag）
//
//TODO: 查询逻辑（纯组合）：
//      hit = |（valid[i] && tag[i]==query_pc_i）；命中项输出 target/length/btype，taken 恒 1
//      （uBTB 只回填"实际发生跳转"的分支，所以命中即预测跳转）
//
//TODO: 更新逻辑（时序）：
//      仅当 update_valid_i && update_taken_i && (update_target_i < update_block_pc_i)
//      （即向回跳转的循环分支）时写入：
//        - 已有同 tag 项 -> 原地更新
//        - 否则 -> 选一个 invalid 项写入；全满则用 LFSR/计数器随机替换一项
//
//TODO: 坑点提示：
//      1. uBTB 与 FTB 给出的信息冲突时，以 P1（FTB）覆盖为准——bpu.v 已有覆盖机制，
//         本模块不需要管。
//      2. 一期可先不实现（hit_o 恒 0），整个前端仍可正常工作，只是小循环每次
//         多 1 拍 taken bubble；建议前端跑通后再启用本模块对比性能。

endmodule
