// ============================================================
// tage 模块（TAGE 条件分支方向预测器）
// ------------------------------------------------------------
// 功能：
// - 预测条件分支的跳转方向（taken / not-taken），是 BPU 的主方向预测器。
// - 结构：1 个基础表（`TAGE_BASE_DEPTH=8192 项 2bit 饱和计数器，PC 直接索引）
//   + `TAGE_TAG_NUM=4 个标记表（各 `TAGE_TAG_DEPTH=1024 项，12bit tag +
//   3bit 计数器 + 2~3bit useful），4 个标记表使用不同的全局历史长度
//   （`TAGE_HIST_LEN0~3 = 11/23/53/112），索引 = PC 与折叠后 GHR 的异或哈希。
// - 预测时选"历史最长且 tag 命中"的表作为 provider；都未命中用基础表。
// - 训练在提交级进行（FTQ 回传 meta），误预测时向更长历史的表分配新项。
// - BRAM 实现，查询 1 拍延迟（结果在 BPU 的 P1 级使用）。
//
// 端口：
// - query_*  ：本拍发起查询，下一拍返回方向 + meta
// - train_*  ：提交训练（meta 原样回传）
// ============================================================
`include "mycpu.h"

module tage(
    input  wire                       clk,
    input  wire                       reset,

    // ---------------- 查询口（1 拍延迟）----------------
    input  wire                       query_valid_i,
    input  wire [31:0]                query_pc_i,         // 预测块起始 PC

    output wire                       taken_o,            // 方向预测（晚 1 拍）
    output wire [`BPU_META_W-1:0]     meta_o,             // 训练元数据（provider/altpred/ctr/useful 等打包）

    // ---------------- 训练口（提交级，仅条件分支）----------------
    input  wire                       train_valid_i,
    input  wire [31:0]                train_pc_i,
    input  wire                       train_taken_i,      // 实际方向
    input  wire                       train_mispred_i,    // 是否误预测
    input  wire [`BPU_META_W-1:0]     train_meta_i        // 预测时的 meta 原样回传
);

//TODO: 实现 TAGE 预测器（参考：团队赛 tage_predictor.sv + tagged_predictor.sv +
//      base_predictor.sv + csr_hash.sv；满洋的 16 分量版本结构相同只是表更多）
//
//TODO: 第一步——基础表（bimodal）：
//      8192 项 × 2bit 饱和计数器，BRAM 实现，索引 = query_pc_i[2 +: 13]。
//      预测 = ctr[1]；训练 = 实际方向饱和加减。
//
//TODO: 第二步——全局历史寄存器 GHR：
//      reg [`GHR_LEN-1:0] ghr;
//      一期：仅在提交训练时移入实际方向（train_valid 时 ghr <= {ghr[..], train_taken_i}），
//            简单且永远正确，代价是预测用的历史略陈旧（竞赛足够）。
//      二期 TODO：预测时投机更新 + 冲刷恢复（需要 GHR 检查点，精度更高）。
//
//TODO: 第三步——4 个标记表：
//      每表 1024 项 { tag(12bit), ctr(3bit), useful(2bit) }，BRAM 实现。
//      索引哈希：idx_i = fold(ghr[HIST_LENi-1:0], 10) ^ pc[11:2] ^ pc[21:12]
//      tag 哈希 ：tag_i = fold(ghr[HIST_LENi-1:0], 12) ^ pc[13:2]（与 idx 用不同折叠）
//      fold（折叠）建议用 CSR 哈希（循环移位寄存器增量折叠，团队赛 csr_hash.sv），
//      也可一期先用纯组合异或折叠（简单但比 CSR 哈希略差）。
//
//TODO: 第四步——预测合成（查表结果在下一拍）：
//      provider = 命中的表中历史最长者；altpred = 次长命中者（无则基础表）。
//      taken_o = provider 的 ctr[2]（USE_ALT_ON_NA 优化：若 provider 是
//      "新分配的弱项"（ctr 处于弱态且 useful==0），用 altpred —— 二期再加）。
//      meta_o 打包：{provider 编号, 各表是否命中, provider ctr, altpred 方向,
//                    各表 idx/tag（训练时免重算，也可回传后重算）, 基础表 ctr}
//      打包格式自定，总宽不超过 `BPU_META_W（64bit），不够就加宽宏。
//
//TODO: 第五步——训练（train_valid_i 且为条件分支）：
//      1) provider 表 ctr 按实际方向饱和加减；基础表同步训练（或仅 provider==基础表时）。
//      2) 方向正确且 provider!=altpred 的预测 -> provider 的 useful++；
//      3) 误预测（train_mispred_i）：向比 provider 历史更长的表中找 useful==0 的项
//         分配新项（tag=新 tag，ctr=弱方向，useful=0）；若都没有空位，把这些表的
//         useful 全部减 1（衰减腾位）。分配概率/选择可用 LFSR 随机化。
//
//TODO: 坑点提示：
//      1. 查询与训练共用 BRAM 端口会打架：标记表用"双口 RAM"（A 口读查询、B 口读改写训练）。
//      2. meta 的打包/解包必须 predict 端与 train 端严格一致（建议写两个 function）。
//      3. 一期可以先只实现基础表（标记表 hit 全 0），前端能跑通后再逐个加标记表，
//         每加一个表用 chiplab 性能测试对比分支误预测率。

endmodule
