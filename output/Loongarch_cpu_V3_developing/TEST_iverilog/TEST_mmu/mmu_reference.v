`include "mycpu.h"

// ============================================================
// mmu 模块（地址翻译门面：I/D 双通道整形 + 异常向量打包）
// ------------------------------------------------------------
// 参考实现说明（纯组合薄层）：
// - I/D 通道请求透传 tlb_manager，结果透传回 ifu/lsu；
// - 本地检测取指 ADEF（vaddr[1:0]!=0）；ADEM 一期接 0；
// - 分立 TLB 异常位打包成 `TLB_EX_NUM 向量（req 门控防 X 污染）。
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
    input  wire        tlbm_inst_ex_adef_i,  // <- tlb_manager.inst_ex_adef（PLV3 取指越界）
    input  wire        tlbm_inst_ex_tlbr_i,
    input  wire        tlbm_inst_ex_pif_i,
    input  wire        tlbm_inst_ex_ppi_i,
    input  wire [31:0] tlbm_data_paddr_i,
    input  wire [1:0]  tlbm_data_mat_i,
    input  wire        tlbm_data_ex_tlbr_i,
    input  wire        tlbm_data_ex_pil_i,
    input  wire        tlbm_data_ex_pis_i,
    input  wire        tlbm_data_ex_ppi_i,
    input  wire        tlbm_data_ex_pme_i,
    input  wire        tlbm_data_ex_adem_i   // <- tlb_manager.data_ex_adem（PLV3 越界）
);

// ---------------- 请求透传 ----------------
assign tlbm_inst_req_o      = i_req_i;
assign tlbm_inst_vaddr_o    = i_vaddr_i;
assign tlbm_data_req_o      = d_req_i;
assign tlbm_data_is_store_o = d_is_store_i;
assign tlbm_data_vaddr_o    = d_vaddr_i;

// ---------------- 结果透传与本地异常 ----------------
assign i_paddr_o     = tlbm_inst_paddr_i;
assign i_mat_o       = tlbm_inst_mat_i;
// ADEF = 取指非对齐（本地）| PLV3 越界（tlb_manager 检测透传）
assign i_excp_adef_o = ((i_req_i === 1'b1) && (i_vaddr_i[1:0] != 2'b00))
                     || ((i_req_i === 1'b1) && (tlbm_inst_ex_adef_i === 1'b1));
assign d_paddr_o     = tlbm_data_paddr_i;
assign d_mat_o       = tlbm_data_mat_i;
assign d_excp_adem_o = (d_req_i === 1'b1) && (tlbm_data_ex_adem_i === 1'b1);

// ---------------- 异常向量打包（req 门控防 X）----------------
wire i_req_ok = (i_req_i === 1'b1);
wire d_req_ok = (d_req_i === 1'b1);

assign i_tlb_ex_o = {`TLB_EX_NUM{1'b0}}
                  | ({{(`TLB_EX_NUM-1){1'b0}}, i_req_ok && (tlbm_inst_ex_tlbr_i === 1'b1)} << `TLB_EX_TLBR)
                  | ({{(`TLB_EX_NUM-1){1'b0}}, i_req_ok && (tlbm_inst_ex_pif_i  === 1'b1)} << `TLB_EX_PIF)
                  | ({{(`TLB_EX_NUM-1){1'b0}}, i_req_ok && (tlbm_inst_ex_ppi_i  === 1'b1)} << `TLB_EX_PPI);

assign d_tlb_ex_o = {`TLB_EX_NUM{1'b0}}
                  | ({{(`TLB_EX_NUM-1){1'b0}}, d_req_ok && (tlbm_data_ex_tlbr_i === 1'b1)} << `TLB_EX_TLBR)
                  | ({{(`TLB_EX_NUM-1){1'b0}}, d_req_ok && (tlbm_data_ex_pil_i  === 1'b1)} << `TLB_EX_PIL)
                  | ({{(`TLB_EX_NUM-1){1'b0}}, d_req_ok && (tlbm_data_ex_pis_i  === 1'b1)} << `TLB_EX_PIS)
                  | ({{(`TLB_EX_NUM-1){1'b0}}, d_req_ok && (tlbm_data_ex_ppi_i  === 1'b1)} << `TLB_EX_PPI)
                  | ({{(`TLB_EX_NUM-1){1'b0}}, d_req_ok && (tlbm_data_ex_pme_i  === 1'b1)} << `TLB_EX_PME);

endmodule
