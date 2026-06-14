// ============================================================
// l1_tlb 模块（L1 微型 TLB，一期纯透传实现）
// ------------------------------------------------------------
// 参考实现说明：
// - 一期最简实现：查询请求直接转发主 TLB、结果原样返回（功能完全正确）；
// - 二期再加 ENTRY_NUM 项缓存与 FIFO 替换（见框架 TODO 路线）；
// - 注意：参考 CPU 顶层未例化本模块（tlb_manager 直连主 TLB），
//   本文件为单元测试与二期升级保留。
// ============================================================
`include "mycpu.h"

module l1_tlb #(
    parameter ENTRY_NUM = 8          // 微表项数（4~8，时序与命中率折中）
)(
    input  wire          clk,
    input  wire          reset,

    // ---------------- 维护 ----------------
    input  wire          fence_i,          // TLB 维护指令提交 -> 整表失效（透传版无表可失效）

    // ---------------- 上游查询口（mmu，组合）----------------
    input  wire          req_valid_i,
    input  wire [31:0]   vaddr_i,
    output wire          found_o,          // 翻译命中（本表命中 或 主表命中）
    output wire [19:0]   ppn_o,            // 物理页号（4KB 页：paddr = {ppn, vaddr[11:0]}）
    output wire [1:0]    mat_o,            // 页存储访问类型
    output wire          v_o,              // 页有效位
    output wire          d_o,              // 页脏位
    output wire [1:0]    plv_o,            // 页特权等级

    // ---------------- 下游主 TLB 查询口（连 tlb.v 的 s0 或 s1 口）----------------
    output wire [18:0]   tlb_vppn_o,       // 主表查询 vppn（vaddr[31:13]）
    output wire          tlb_va_bit12_o,   // vaddr[12]（双页选择）
    input  wire          tlb_found_i,
    input  wire [19:0]   tlb_ppn_i,
    input  wire [1:0]    tlb_mat_i,
    input  wire          tlb_v_i,
    input  wire          tlb_d_i,
    input  wire [1:0]    tlb_plv_i
);

// 一期纯透传：查询直接转发主表，结果原样返回
assign tlb_vppn_o     = vaddr_i[31:13];
assign tlb_va_bit12_o = vaddr_i[12];

assign found_o = req_valid_i & tlb_found_i;
assign ppn_o   = tlb_ppn_i;
assign mat_o   = tlb_mat_i;
assign v_o     = tlb_v_i;
assign d_o     = tlb_d_i;
assign plv_o   = tlb_plv_i;

// lint 吸收（透传版未用的时钟/维护口）
wire l1tlb_lint = clk | reset | fence_i | (ENTRY_NUM == 0);

endmodule
