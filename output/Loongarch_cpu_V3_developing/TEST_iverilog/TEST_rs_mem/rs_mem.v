// ============================================================
// rs_mem 模块（访存保留站，`RS_MEM_SIZE=4 项，FIFO 严格顺序发射）
// ------------------------------------------------------------
// 功能：
// - 缓存等待操作数的访存类指令（load/store/ll/sc/cacop）。
// - 与 ALU 保留站的本质区别：**严格按程序序发射**（FIFO）——
//   队头指令操作数没就绪时，后面的指令即使就绪也不能发射。
//   原因：访存指令乱序需要 load/store 地址消歧（LSQ），一期不做；
//   保持访存程序序 + store 提交后写（store buffer）即可天然保证正确性。
// - 唤醒机制与 rs_alu 相同（4 路写回总线 + 预留提前唤醒）。
//
// 端口：与 rs_alu 同构，差异：
// - bundle 为 mem_op/is_cacop/imm（无 br 相关）
// - 发射口对接 lsu，lsu_ready_i 反压（LSU 两级流水可能停顿）
// ============================================================
`include "mycpu.h"

module rs_mem(
    input  wire                       clk,
    input  wire                       reset,
    input  wire                       flush_i,

    // ---------------- 入站（dispatch）----------------
    input  wire                       push_valid_i,
    input  wire [`ROB_W-1:0]          push_robid_i,
    input  wire [31:0]                push_pc_i,
    input  wire [`MEM_OP_NUM-1:0]     push_mem_op_i,
    input  wire                       push_is_cacop_i,
    input  wire                       push_src0_ready_i,   // src0 = 基址 rj
    input  wire [31:0]                push_src0_val_i,
    input  wire [`ROB_W-1:0]          push_src0_robid_i,
    input  wire                       push_src1_ready_i,   // src1 = store 数据 rd
    input  wire [31:0]                push_src1_val_i,
    input  wire [`ROB_W-1:0]          push_src1_robid_i,
    input  wire [31:0]                push_imm_i,          // si12/si14 偏移

    output wire                       can_accept_o,
    output wire [2:0]                 occupancy_o,

    // ---------------- 写回唤醒总线 ×4 ----------------
    input  wire                       wb0_valid_i,
    input  wire [`ROB_W-1:0]          wb0_robid_i,
    input  wire [31:0]                wb0_data_i,
    input  wire                       wb1_valid_i,
    input  wire [`ROB_W-1:0]          wb1_robid_i,
    input  wire [31:0]                wb1_data_i,
    input  wire                       wb2_valid_i,
    input  wire [`ROB_W-1:0]          wb2_robid_i,
    input  wire [31:0]                wb2_data_i,
    input  wire                       wb3_valid_i,
    input  wire [`ROB_W-1:0]          wb3_robid_i,
    input  wire [31:0]                wb3_data_i,

    // ---------------- 提前唤醒总线 ×3（二期）----------------
    input  wire                       early0_valid_i,
    input  wire [`ROB_W-1:0]          early0_robid_i,
    input  wire                       early1_valid_i,
    input  wire [`ROB_W-1:0]          early1_robid_i,
    input  wire                       early2_valid_i,
    input  wire [`ROB_W-1:0]          early2_robid_i,

    // ---------------- 发射口（到 lsu）----------------
    output wire                       issue_valid_o,
    output wire [`ROB_W-1:0]          issue_robid_o,
    output wire [31:0]                issue_pc_o,
    output wire [`MEM_OP_NUM-1:0]     issue_mem_op_o,
    output wire                       issue_is_cacop_o,
    output wire [31:0]                issue_base_o,        // 基址（src0 捕获值）
    output wire [31:0]                issue_wdata_o,       // store 数据（src1 捕获值）
    output wire [31:0]                issue_imm_o,
    input  wire                       lsu_ready_i          // LSU 本拍可接收（AGU 级空闲）
);

//TODO: 实现 4 项 FIFO 顺序发射保留站（参考：mariver station.v 的 MU 保留站部分，
//      "MU和MDU必须顺序发射"——只允许队头发射）
//
//TODO: 存储结构：
//      与 rs_alu 类似（valid/robid/op/双源/imm），但组织成 FIFO：
//      reg [`SB_W...] 不需要 prior，改用 head/tail 指针（4 项 -> 2bit 指针）。
//      入站写 tail 项，tail++；发射出队 head 项，head++。
//
//TODO: 唤醒与数据捕获：与 rs_alu 完全相同（4 路 wb 总线逐项逐源比较捕获，
//      入站同拍旁路同样要做）。
//
//TODO: 发射（仅队头）：
//      issue_valid_o = valid[head] && s0_ready[head] && s1_ready[head] && lsu_ready_i;
//      发射成功（issue_valid && lsu_ready）当拍出队。
//      注意 store 即使 src1（数据）未就绪也不能让位给后面的 load —— 这就是
//      顺序发射强制保证的"无地址消歧的正确性"。
//
//TODO: 冲刷：flush_i 清空 head/tail/valid。
//
//TODO: 坑点提示：
//      1. lsu_ready_i 为 0 时队头保持，不要丢发射（脉冲式发射 + not-ready 丢失
//         是常见 bug，发射条件里与上 lsu_ready 即可避免）。
//      2. 二期若做"load 提前唤醒"（lsu AGU 级 early2 总线），唤醒的是
//         依赖 load 结果的 ALU 指令，本站自身的唤醒逻辑不变。
//      3. 二期若想 load/store 之间乱序（load 越过前面的 store），必须加
//         store 地址比较（内存消歧）+ 违例恢复，工作量大，务必先评估收益。

endmodule
