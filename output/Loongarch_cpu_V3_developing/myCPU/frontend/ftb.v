// ============================================================
// ftb 模块（Fetch Target Buffer，取指目标缓冲）
// ------------------------------------------------------------
// 功能：
// - 以"基本块"为单位存储分支信息：用块起始 PC 查询，命中则给出
//   该块内第一条分支的（类型 / 跳转目标 / 顺序出口 fall-through）。
// - BPU 据此算出真实块长（fall_through - start_pc）和预测方向来源
//   （COND 用 TAGE 方向；CALL/UNCOND 恒跳；RET 目标用 RAS）。
// - `FTB_NWAY（4）路组相联 × `FTB_NSET（1024）组，BRAM 实现，
//   查询有 1 拍延迟（结果在 BPU 的 P1 级使用）。
// - 只在基本块"提交"时训练/更新（保证存入的信息永远正确，
//   推测路径不会污染 FTB —— 参考团队赛报告 2.2.1.2 节）。
//
// 端口：
// - query_pc_i           ：预测块起始 PC（本拍发起，下一拍出结果）
// - hit_o / entry 各字段 ：下一拍返回的命中信息
// - update_*             ：提交训练口
// ============================================================
`include "mycpu.h"

module ftb(
    input  wire                       clk,
    input  wire                       reset,

    // ---------------- 查询口（BRAM，1 拍延迟）----------------
    input  wire                       query_valid_i,
    input  wire [31:0]                query_pc_i,          // 块起始 PC

    output wire                       hit_o,               // （相对查询晚 1 拍）
    output wire [31:0]                jump_target_o,       // 块内分支的跳转目标
    output wire [31:0]                fall_through_o,      // 块顺序出口地址（start_pc + 4*块长）
    output wire [`BR_TYPE_W-1:0]      br_type_o,           // 分支类型

    // ---------------- 更新口（提交训练）----------------
    input  wire                       update_valid_i,
    input  wire [31:0]                update_block_pc_i,   // 块起始 PC
    input  wire [31:0]                update_jump_target_i,
    input  wire [31:0]                update_fall_through_i,
    input  wire [`BR_TYPE_W-1:0]      update_br_type_i,
    input  wire                       update_alloc_i       // 1=新分配（未命中过/信息错需重写），0=仅更新
);

//TODO: 实现 4 路 × 1024 组 FTB（参考：团队赛 ftb.sv、满洋 BPU/components/ftb.sv）
//
//TODO: 条目格式（每路每组一项）：
//      { valid(1), tag(约19~20bit), br_type(2), jump_target(32 或压缩位宽),
//        fall_through 的低位(块长最多 4 条 -> 只需存 fall_through[4:2] 与
//        start_pc 的差值 3bit，可大幅省 BRAM；也可以直接存 32 位图省事) }
//      索引：query_pc_i[2 +: `FTB_INDEX_W]（pc[11:2..]，按字对齐后取 10 位）
//      tag ：query_pc_i 的高位（pc[31:12] 附近，自行划分）
//
//TODO: 存储介质：
//      用"可推断 BRAM 的双口 RAM 模板"（一读一写，读口 1 拍延迟），每路一块；
//      不要用 .xci IP（chiplab/verilator 仿真不便、参数不可调）。
//      模板写法：always @(posedge clk) begin rdata <= mem[raddr]; if(we) mem[waddr] <= wdata; end
//
//TODO: 查询逻辑：
//      本拍发地址 -> 下一拍 4 路数据/tag 出来 -> 与打拍后的 query_pc tag 比较 -> 命中选路。
//      注意 tag 比较用的 PC 必须与 BRAM 数据同拍（query_pc 打一拍），否则错位。
//
//TODO: 更新逻辑（仅提交训练，update_valid_i 时）：
//      - update_alloc_i=1：选 victim 路写入整个新条目。victim 选择：无效路优先，
//        否则 LFSR 随机（例化已有思路即可，团队赛用 lfsr.sv）。
//      - update_alloc_i=0：命中路原地更新（目标/类型变化时）。
//      - 更新条件由 bpu.v 训练通路判断（首次 taken 的条件分支 / 无条件分支 /
//        目标错误 / 类型错误），本模块只管执行写入。
//
//TODO: 坑点提示：
//      1. BRAM 读写同地址冲突：查询与更新同组同拍时，读出的可能是旧数据，
//         需要 bypass（本拍写的数据直接旁路给读口）或接受 1 次小误差（预测器可容忍）。
//      2. fall_through 必须严格 = 块起始 PC + 4*实际块长，BPU 用它算 P1 块长，
//         算错会导致取指切块错位（指令流错乱，难查！）。
//      3. 复位时 valid 清零即可，BRAM 内容不用清。

endmodule
