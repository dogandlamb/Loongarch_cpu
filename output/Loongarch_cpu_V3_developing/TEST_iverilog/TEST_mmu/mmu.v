`include "mycpu.h"

// ============================================================
// mmu 模块（地址翻译门面：I/D 双通道整形 + 异常向量打包）
// ------------------------------------------------------------
// 功能（新架构角色）：
// - 在 ifu/lsu 与 tlb_manager 之间做薄封装：
//   * I 通道：ifu 的取指 vaddr -> tlb_manager s0 -> paddr/mat/取指异常向量
//   * D 通道：lsu 的访存 vaddr -> tlb_manager s1 -> paddr/mat/访存异常向量
// - 本地检测 ADEF（取指地址非对齐 vaddr[1:0]!=0）；ADEM 预留（接 0）。
// - 把 tlb_manager 的分立异常位打包成 `TLB_EX_NUM 向量（ifu/lsu 端口格式）。
// - 旧设计中的"数据透传（bridge_*）"通路已被 cache 直连取代，删除。
//
// 端口：
// - i_*  ：I 通道（连 ifu 的 mmu_i_*）
// - d_*  ：D 通道（连 lsu 的 mmu_d_*）
// - tlbm_*：tlb_manager 的翻译输入/输出透传
// ============================================================
module mmu (
    // ---------------- I 通道（ifu）----------------
    input  wire        i_req_i,
    input  wire [31:0] i_vaddr_i,
    output wire [31:0] i_paddr_o,
    output wire [1:0]  i_mat_o,
    output wire        i_excp_adef_o,
    output wire [`TLB_EX_NUM-1:0] i_tlb_ex_o,

    // ---------------- D 通道（lsu）----------------
    input  wire        d_req_i,
    input  wire        d_is_store_i,
    input  wire [31:0] d_vaddr_i,
    output wire [31:0] d_paddr_o,
    output wire [1:0]  d_mat_o,
    output wire        d_excp_adem_o,
    output wire [`TLB_EX_NUM-1:0] d_tlb_ex_o,

    // ---------------- tlb_manager 翻译通道透传 ----------------
    output wire        tlbm_inst_req_o,      // -> tlb_manager.inst_req
    output wire [31:0] tlbm_inst_vaddr_o,    // -> tlb_manager.inst_vaddr
    output wire        tlbm_data_req_o,      // -> tlb_manager.data_req
    output wire        tlbm_data_is_store_o, // -> tlb_manager.data_is_store
    output wire [31:0] tlbm_data_vaddr_o,    // -> tlb_manager.data_vaddr

    input  wire [31:0] tlbm_inst_paddr_i,    // <- tlb_manager.inst_paddr
    input  wire [1:0]  tlbm_inst_mat_i,
    input  wire        tlbm_inst_ex_tlbr_i,
    input  wire        tlbm_inst_ex_pif_i,
    input  wire        tlbm_inst_ex_ppi_i,
    input  wire [31:0] tlbm_data_paddr_i,
    input  wire [1:0]  tlbm_data_mat_i,
    input  wire        tlbm_data_ex_tlbr_i,
    input  wire        tlbm_data_ex_pil_i,
    input  wire        tlbm_data_ex_pis_i,
    input  wire        tlbm_data_ex_ppi_i,
    input  wire        tlbm_data_ex_pme_i
);

//TODO: 本模块为纯组合薄层，按下面三步实现（多数是连线，半小时内可完成）：
//
//TODO: 第一步——请求透传：
//      tlbm_inst_req_o   = i_req_i;   tlbm_inst_vaddr_o = i_vaddr_i;
//      tlbm_data_req_o   = d_req_i;   tlbm_data_vaddr_o = d_vaddr_i;
//      tlbm_data_is_store_o = d_is_store_i;
//
//TODO: 第二步——结果透传与本地异常：
//      i_paddr_o = tlbm_inst_paddr_i;  i_mat_o = tlbm_inst_mat_i;
//      i_excp_adef_o = i_req_i && (i_vaddr_i[1:0] != 2'b00);   // 取指非对齐
//      d_paddr_o/d_mat_o 同理；d_excp_adem_o 一期接 1'b0（ADEM 检测可后补：
//      PLV3 访问内核地址段等场景，chiplab 功能测试未覆盖时可先不做）。
//
//TODO: 第三步——异常向量打包（位序见 mycpu.h 的 TLB_EX_*）：
//      i_tlb_ex_o[`TLB_EX_TLBR] = i_req_i & tlbm_inst_ex_tlbr_i;
//      i_tlb_ex_o[`TLB_EX_PIF]  = i_req_i & tlbm_inst_ex_pif_i;
//      i_tlb_ex_o[`TLB_EX_PPI]  = i_req_i & tlbm_inst_ex_ppi_i;  其余位 0。
//      d_tlb_ex_o 同理打包 TLBR/PIL/PIS/PPI/PME（注意用 d_req_i 门控，
//      防 X 污染——旧实现用 === 比较的防御式写法可以保留参考）。
//
//TODO: 坑点提示：
//      1. 有取指/访存异常时，ifu/lsu 自己负责"不发 cache 请求"，本模块
//         不再做请求压制（旧设计在这里压请求，新架构职责移到了发起方）。
//      2. ADEF 优先级高于 TLB 异常（地址都非法就别查 TLB 了），ifu 侧
//         合并异常时注意先后。

endmodule
