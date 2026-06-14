// ============================================================
// rs_mdu 模块（乘除/杂项保留站，`RS_MDU_SIZE=2 项，FIFO 顺序发射）
// ------------------------------------------------------------
// 功能：
// - 缓存乘/除/取模、CSR 读类（csrrd/csrwr/csrxchg 的读旧值+算新值）、
//   rdcnt 类、TLB 维护类（执行级只打包 invtlb 的 asid/vpn）指令。
// - FIFO 严格顺序发射（MDU 非流水多周期，且 CSR 读必须按序——
//   虽然 CSR 写会触发 refetch 冲刷保证了顺序，但保守起见仍按序发射）。
// - 容量 2 项即可（这类指令频率低，mariver 同款配置）。
//
// 端口：与 rs_mem 同构，差异：
// - bundle 为 alu_op（乘除位）/csr_op/csr_num/tlb_op/wb_src_op
// - 发射口对接 fu_mdu，mdu_ready_i 反压（MDU 多周期忙）
// ============================================================
`include "mycpu.h"

module rs_mdu(
    input  wire                       clk,
    input  wire                       reset,
    input  wire                       flush_i,

    // ---------------- 入站（dispatch）----------------
    input  wire                       push_valid_i,
    input  wire [`ROB_W-1:0]          push_robid_i,
    input  wire [`ALU_OP_NUM-1:0]     push_alu_op_i,       // 乘除位有效
    input  wire [`CSR_OP_NUM-1:0]     push_csr_op_i,
    input  wire [13:0]                push_csr_num_i,
    input  wire [`TLB_OP_NUM-1:0]     push_tlb_op_i,
    input  wire [`WB_SRC_NUM-1:0]     push_wb_src_op_i,    // rdcnt 类选择
    input  wire                       push_src0_ready_i,   // src0 = rj（csrxchg 的 mask / invtlb 的 asid / 乘除源1）
    input  wire [31:0]                push_src0_val_i,
    input  wire [`ROB_W-1:0]          push_src0_robid_i,
    input  wire                       push_src1_ready_i,   // src1 = rk/rd（csr 写值 / invtlb 的 va / 乘除源2）
    input  wire [31:0]                push_src1_val_i,
    input  wire [`ROB_W-1:0]          push_src1_robid_i,

    output wire                       can_accept_o,
    output wire [1:0]                 occupancy_o,

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

    // ---------------- 发射口（到 fu_mdu）----------------
    output wire                       issue_valid_o,
    output wire [`ROB_W-1:0]          issue_robid_o,
    output wire [`ALU_OP_NUM-1:0]     issue_alu_op_o,
    output wire [`CSR_OP_NUM-1:0]     issue_csr_op_o,
    output wire [13:0]                issue_csr_num_o,
    output wire [`TLB_OP_NUM-1:0]     issue_tlb_op_o,
    output wire [`WB_SRC_NUM-1:0]     issue_wb_src_op_o,
    output wire [31:0]                issue_src0_o,
    output wire [31:0]                issue_src1_o,
    input  wire                       mdu_ready_i          // MDU 空闲可接收
);

//TODO: 实现 2 项 FIFO 顺序发射保留站（参考：mariver station.v 的 MDU 保留站部分）
//      结构与 rs_mem 完全同构（head/tail FIFO + 唤醒捕获 + 队头发射），
//      只是容量 2 项、bundle 字段不同、反压来自 mdu_ready_i。
//      建议先写完 rs_mem 再复制改字段，二十分钟的事。
//
//TODO: 坑点提示：
//      1. csrxchg 同时用 rj(mask) 和 rd(写值) 两个源，都要等唤醒。
//      2. invtlb 的 asid 来自 rj[9:0]、va 来自 rk —— 也是双源指令。
//      3. rdcnt 类无源操作数（use_src=0，rename 已置 ready=1），入站即可发射。

endmodule
