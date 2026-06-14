// ============================================================
// l1_tlb 模块（L1 微型 TLB，I 侧 / D 侧各例化一份）
// ------------------------------------------------------------
// 功能：
// - 主 TLB（tlb.v，32 项全相联）的小容量缓存（4~8 项），目的：
//   主 TLB 全相联比较链很长，是取指/访存关键路径的时序瓶颈；
//   L1 微表只比较 4~8 项，能显著缩短组合路径（mariver 实证：L1 仅 3 项）。
// - 对软件完全透明（体系结构只看得到主 TLB）；TLB 维护指令提交时
//   整表失效本表即可（fence_i 端口）。
// - 一期允许"纯透传"实现：查询请求直接转发主 TLB 查询口、结果原样返回
//   （命中逻辑后补），先保证整条翻译通路联通。
//
// 端口：
// - 上游（mmu）  ：req/vaddr 进，paddr/found/页属性 出（组合）
// - 下游（主TLB）：miss 时转发查询（一期=永远转发）
// - fence_i      ：TLB 维护指令提交后整表失效
// ============================================================
`include "mycpu.h"

module l1_tlb #(
    parameter ENTRY_NUM = 8          // 微表项数（4~8，时序与命中率折中）
)(
    input  wire          clk,
    input  wire          reset,

    // ---------------- 维护 ----------------
    input  wire          fence_i,          // TLB 维护指令提交（tlbwr/tlbfill/invtlb/asid 变化）-> 整表失效

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

//TODO: 一期最简实现（纯透传，保证翻译通路先联通）：
//      assign tlb_vppn_o     = vaddr_i[31:13];
//      assign tlb_va_bit12_o = vaddr_i[12];
//      assign found_o = tlb_found_i;  ppn/mat/v/d/plv 同理直通主表结果。
//      这样 l1_tlb 退化为一根线，功能完全正确，整核可以先跑起来。
//
//TODO: 二期加速实现（参考：mariver l1_tlb.v，3 项 FIFO 替换）：
//      1. 存储：ENTRY_NUM 项 {valid, vppn[18:0], 双页 ppn/mat/v/d/plv}，全用 reg。
//      2. 查询：组合比较 vaddr[31:13] 与各项 vppn，命中则当拍出结果（不再等主表）；
//         未命中 -> 沿用透传路径查主表，同时把主表结果"回填"进本表（FIFO 替换）。
//      3. 回填时机：主表 found 当拍回填即可（主表查询本来就是组合的，回填走时序）。
//      4. fence_i：valid 全清（TLB 写/无效化/ASID 切换后旧翻译可能失效，
//         一刀切失效最简单且正确——失效频率极低，性能无损）。
//      5. 大页支持：当前 tlb.v 主要按 4KB 页工作，本表按 4KB 页缓存即可；
//         若后续主表启用大页（PS!=12），回填时需展开或直接不缓存大页项（透传）。
//
//TODO: 坑点提示：
//      1. 本表只是缓存，任何"主表内容可能变化"的时刻（fence_i）必须失效，
//         否则出现"幽灵翻译"——程序跑飞且极难定位。宁可多失效。
//      2. 取指口与访存口各例化一份本模块（I 侧连 tlb.v 的 s0 口、D 侧连 s1 口），
//         两份互不相干。

endmodule
