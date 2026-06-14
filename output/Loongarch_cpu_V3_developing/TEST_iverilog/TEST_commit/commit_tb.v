`timescale 1ns/1ps
`include "mycpu.h"
`include "tb_macros.vh"
module commit_tb;
  reg  clk;
  reg  reset;
  reg [`ROB_W-1:0] head_robid0_i;
  reg  cmt0_valid_i;
  reg  cmt0_complete_i;
  reg [31:0] cmt0_pc_i;
  reg [31:0] cmt0_inst_i;
  reg  cmt0_rf_we_i;
  reg [4:0] cmt0_rd_i;
  reg [31:0] cmt0_result_i;
  reg [31:0] cmt0_result2_i;
  reg  cmt0_is_load_i;
  reg  cmt0_is_store_i;
  reg [31:0] cmt0_paddr_i;
  reg [31:0] cmt0_vaddr_i;
  reg [3:0] cmt0_wstrb_i;
  reg [2:0] cmt0_size_i;
  reg  cmt0_uncached_i;
  reg  cmt0_is_branch_i;
  reg [`BR_TYPE_W-1:0] cmt0_br_type_i;
  reg  cmt0_pred_taken_i;
  reg  cmt0_br_taken_i;
  reg [31:0] cmt0_br_target_i;
  reg  cmt0_is_last_i;
  reg [`FTQ_W-1:0] cmt0_ftq_id_i;
  reg [`PRIV_NUM-1:0] cmt0_priv_vec_i;
  reg [13:0] cmt0_csr_num_i;
  reg [`TLB_OP_NUM-1:0] cmt0_tlb_op_i;
  reg [4:0] cmt0_cacop_code_i;
  reg [`EXCP_NUM-1:0] cmt0_excp_i;
  reg  cmt1_valid_i;
  reg  cmt1_complete_i;
  reg [31:0] cmt1_pc_i;
  reg [31:0] cmt1_inst_i;
  reg  cmt1_rf_we_i;
  reg [4:0] cmt1_rd_i;
  reg [31:0] cmt1_result_i;
  reg [31:0] cmt1_result2_i;
  reg  cmt1_is_load_i;
  reg  cmt1_is_store_i;
  reg [31:0] cmt1_paddr_i;
  reg [31:0] cmt1_vaddr_i;
  reg [3:0] cmt1_wstrb_i;
  reg [2:0] cmt1_size_i;
  reg  cmt1_uncached_i;
  reg  cmt1_is_branch_i;
  reg [`BR_TYPE_W-1:0] cmt1_br_type_i;
  reg  cmt1_pred_taken_i;
  reg  cmt1_br_taken_i;
  reg [31:0] cmt1_br_target_i;
  reg  cmt1_is_last_i;
  reg [`FTQ_W-1:0] cmt1_ftq_id_i;
  reg [`PRIV_NUM-1:0] cmt1_priv_vec_i;
  reg [13:0] cmt1_csr_num_i;
  reg [`TLB_OP_NUM-1:0] cmt1_tlb_op_i;
  reg [4:0] cmt1_cacop_code_i;
  reg [`EXCP_NUM-1:0] cmt1_excp_i;
  wire  rob_pop_o;
  wire  rob_clear0_o;
  wire  rob_clear1_o;
  wire  cmt_wake0_valid_o;
  wire [`ROB_W-1:0] cmt_wake0_robid_o;
  wire [31:0] cmt_wake0_data_o;
  wire [4:0] cmt_wake0_rd_o;
  wire  cmt_wake1_valid_o;
  wire [`ROB_W-1:0] cmt_wake1_robid_o;
  wire [31:0] cmt_wake1_data_o;
  wire [4:0] cmt_wake1_rd_o;
  wire  arf_we0_o;
  wire [4:0] arf_waddr0_o;
  wire [31:0] arf_wdata0_o;
  wire  arf_we1_o;
  wire [4:0] arf_waddr1_o;
  wire [31:0] arf_wdata1_o;
  wire  rat_cmt_en0_o;
  wire [4:0] rat_cmt_addr0_o;
  wire [`ROB_W-1:0] rat_cmt_num0_o;
  wire  rat_cmt_en1_o;
  wire [4:0] rat_cmt_addr1_o;
  wire [`ROB_W-1:0] rat_cmt_num1_o;
  wire  sb_push_valid_o;
  wire [31:0] sb_push_paddr_o;
  wire [31:0] sb_push_data_o;
  wire [3:0] sb_push_wstrb_o;
  wire [2:0] sb_push_size_o;
  wire  sb_push_uncached_o;
  reg  sb_full_i;
  reg  sb_empty_i;
  wire  csr_cmt_valid_o;
  wire [31:0] csr_cmt_pc_o;
  wire  csr_cmt_ex_o;
  wire  csr_cmt_ertn_o;
  wire [31:0] csr_cmt_vaddr_o;
  wire  excp_int_o;
  wire  excp_adef_o;
  wire  excp_adem_o;
  wire  excp_ipe_o;
  wire  excp_ale_o;
  wire  excp_sys_o;
  wire  excp_brk_o;
  wire  excp_ine_o;
  wire [`TLB_EX_NUM-1:0] excp_tlb_vec_o;
  wire  csr_we_o;
  wire [13:0] csr_wnum_o;
  wire [31:0] csr_wmask_o;
  wire [31:0] csr_wvalue_o;
  wire  ll_set_o;
  wire  sc_set_o;
  wire [27:0] lladdr_o;
  reg  has_int_i;
  reg [31:0] csr_next_pc_i;
  reg [1:0] csr_redirect_i;
  wire [`TLB_OP_NUM-1:0] tlb_op_cmt_o;
  wire [9:0] invtlb_asid_o;
  wire [18:0] invtlb_vpn_o;
  wire  icacop_valid_o;
  wire [1:0] icacop_op_o;
  wire [31:0] icacop_addr_o;
  wire  dcacop_valid_o;
  wire [1:0] dcacop_op_o;
  wire [31:0] dcacop_addr_o;
  wire  ftq_cmt_valid_o;
  wire [`FTQ_W-1:0] ftq_cmt_id_o;
  wire  ftq_cmt_is_last_o;
  wire  ftq_cmt_is_branch_o;
  wire  ftq_cmt_taken_o;
  wire  ftq_cmt_mispred_o;
  wire [31:0] ftq_cmt_target_o;
  wire [`BR_TYPE_W-1:0] ftq_cmt_br_type_o;
  wire [31:0] ftq_cmt_pc_o;
  wire [`FTQ_W-1:0] ftq_query_id_o;
  reg [31:0] ftq_blk_target_i;
  wire  ras_cmt_call_o;
  wire  ras_cmt_ret_o;
  wire [31:0] ras_cmt_retaddr_o;
  wire  flush_req_o;
  wire [`FLUSH_TYPE_W-1:0] flush_type_o;
  wire [31:0] flush_pc_o;
  wire  idle_commit_o;
  reg  uncached_ld_inflight_i;
  wire  debug0_valid_o;
  wire [31:0] debug0_pc_o;
  wire [3:0] debug0_rf_wen_o;
  wire [4:0] debug0_rf_wnum_o;
  wire [31:0] debug0_rf_wdata_o;
  wire [31:0] debug0_inst_o;
  wire  debug1_valid_o;
  wire [31:0] debug1_pc_o;
  wire [3:0] debug1_rf_wen_o;
  wire [4:0] debug1_rf_wnum_o;
  wire [31:0] debug1_rf_wdata_o;
  wire [31:0] debug1_inst_o;
  commit uut(
    .clk(clk),
    .reset(reset),
    .head_robid0_i(head_robid0_i),
    .cmt0_valid_i(cmt0_valid_i),
    .cmt0_complete_i(cmt0_complete_i),
    .cmt0_pc_i(cmt0_pc_i),
    .cmt0_inst_i(cmt0_inst_i),
    .cmt0_rf_we_i(cmt0_rf_we_i),
    .cmt0_rd_i(cmt0_rd_i),
    .cmt0_result_i(cmt0_result_i),
    .cmt0_result2_i(cmt0_result2_i),
    .cmt0_is_load_i(cmt0_is_load_i),
    .cmt0_is_store_i(cmt0_is_store_i),
    .cmt0_paddr_i(cmt0_paddr_i),
    .cmt0_vaddr_i(cmt0_vaddr_i),
    .cmt0_wstrb_i(cmt0_wstrb_i),
    .cmt0_size_i(cmt0_size_i),
    .cmt0_uncached_i(cmt0_uncached_i),
    .cmt0_is_branch_i(cmt0_is_branch_i),
    .cmt0_br_type_i(cmt0_br_type_i),
    .cmt0_pred_taken_i(cmt0_pred_taken_i),
    .cmt0_br_taken_i(cmt0_br_taken_i),
    .cmt0_br_target_i(cmt0_br_target_i),
    .cmt0_is_last_i(cmt0_is_last_i),
    .cmt0_ftq_id_i(cmt0_ftq_id_i),
    .cmt0_priv_vec_i(cmt0_priv_vec_i),
    .cmt0_csr_num_i(cmt0_csr_num_i),
    .cmt0_tlb_op_i(cmt0_tlb_op_i),
    .cmt0_cacop_code_i(cmt0_cacop_code_i),
    .cmt0_excp_i(cmt0_excp_i),
    .cmt1_valid_i(cmt1_valid_i),
    .cmt1_complete_i(cmt1_complete_i),
    .cmt1_pc_i(cmt1_pc_i),
    .cmt1_inst_i(cmt1_inst_i),
    .cmt1_rf_we_i(cmt1_rf_we_i),
    .cmt1_rd_i(cmt1_rd_i),
    .cmt1_result_i(cmt1_result_i),
    .cmt1_result2_i(cmt1_result2_i),
    .cmt1_is_load_i(cmt1_is_load_i),
    .cmt1_is_store_i(cmt1_is_store_i),
    .cmt1_paddr_i(cmt1_paddr_i),
    .cmt1_vaddr_i(cmt1_vaddr_i),
    .cmt1_wstrb_i(cmt1_wstrb_i),
    .cmt1_size_i(cmt1_size_i),
    .cmt1_uncached_i(cmt1_uncached_i),
    .cmt1_is_branch_i(cmt1_is_branch_i),
    .cmt1_br_type_i(cmt1_br_type_i),
    .cmt1_pred_taken_i(cmt1_pred_taken_i),
    .cmt1_br_taken_i(cmt1_br_taken_i),
    .cmt1_br_target_i(cmt1_br_target_i),
    .cmt1_is_last_i(cmt1_is_last_i),
    .cmt1_ftq_id_i(cmt1_ftq_id_i),
    .cmt1_priv_vec_i(cmt1_priv_vec_i),
    .cmt1_csr_num_i(cmt1_csr_num_i),
    .cmt1_tlb_op_i(cmt1_tlb_op_i),
    .cmt1_cacop_code_i(cmt1_cacop_code_i),
    .cmt1_excp_i(cmt1_excp_i),
    .rob_pop_o(rob_pop_o),
    .rob_clear0_o(rob_clear0_o),
    .rob_clear1_o(rob_clear1_o),
    .cmt_wake0_valid_o(cmt_wake0_valid_o),
    .cmt_wake0_robid_o(cmt_wake0_robid_o),
    .cmt_wake0_data_o(cmt_wake0_data_o),
    .cmt_wake0_rd_o(cmt_wake0_rd_o),
    .cmt_wake1_valid_o(cmt_wake1_valid_o),
    .cmt_wake1_robid_o(cmt_wake1_robid_o),
    .cmt_wake1_data_o(cmt_wake1_data_o),
    .cmt_wake1_rd_o(cmt_wake1_rd_o),
    .arf_we0_o(arf_we0_o),
    .arf_waddr0_o(arf_waddr0_o),
    .arf_wdata0_o(arf_wdata0_o),
    .arf_we1_o(arf_we1_o),
    .arf_waddr1_o(arf_waddr1_o),
    .arf_wdata1_o(arf_wdata1_o),
    .rat_cmt_en0_o(rat_cmt_en0_o),
    .rat_cmt_addr0_o(rat_cmt_addr0_o),
    .rat_cmt_num0_o(rat_cmt_num0_o),
    .rat_cmt_en1_o(rat_cmt_en1_o),
    .rat_cmt_addr1_o(rat_cmt_addr1_o),
    .rat_cmt_num1_o(rat_cmt_num1_o),
    .sb_push_valid_o(sb_push_valid_o),
    .sb_push_paddr_o(sb_push_paddr_o),
    .sb_push_data_o(sb_push_data_o),
    .sb_push_wstrb_o(sb_push_wstrb_o),
    .sb_push_size_o(sb_push_size_o),
    .sb_push_uncached_o(sb_push_uncached_o),
    .sb_full_i(sb_full_i),
    .sb_empty_i(sb_empty_i),
    .csr_cmt_valid_o(csr_cmt_valid_o),
    .csr_cmt_pc_o(csr_cmt_pc_o),
    .csr_cmt_ex_o(csr_cmt_ex_o),
    .csr_cmt_ertn_o(csr_cmt_ertn_o),
    .csr_cmt_vaddr_o(csr_cmt_vaddr_o),
    .excp_int_o(excp_int_o),
    .excp_adef_o(excp_adef_o),
    .excp_adem_o(excp_adem_o),
    .excp_ipe_o(excp_ipe_o),
    .excp_ale_o(excp_ale_o),
    .excp_sys_o(excp_sys_o),
    .excp_brk_o(excp_brk_o),
    .excp_ine_o(excp_ine_o),
    .excp_tlb_vec_o(excp_tlb_vec_o),
    .csr_we_o(csr_we_o),
    .csr_wnum_o(csr_wnum_o),
    .csr_wmask_o(csr_wmask_o),
    .csr_wvalue_o(csr_wvalue_o),
    .ll_set_o(ll_set_o),
    .sc_set_o(sc_set_o),
    .lladdr_o(lladdr_o),
    .has_int_i(has_int_i),
    .csr_next_pc_i(csr_next_pc_i),
    .csr_redirect_i(csr_redirect_i),
    .tlb_op_cmt_o(tlb_op_cmt_o),
    .invtlb_asid_o(invtlb_asid_o),
    .invtlb_vpn_o(invtlb_vpn_o),
    .icacop_valid_o(icacop_valid_o),
    .icacop_op_o(icacop_op_o),
    .icacop_addr_o(icacop_addr_o),
    .dcacop_valid_o(dcacop_valid_o),
    .dcacop_op_o(dcacop_op_o),
    .dcacop_addr_o(dcacop_addr_o),
    .ftq_cmt_valid_o(ftq_cmt_valid_o),
    .ftq_cmt_id_o(ftq_cmt_id_o),
    .ftq_cmt_is_last_o(ftq_cmt_is_last_o),
    .ftq_cmt_is_branch_o(ftq_cmt_is_branch_o),
    .ftq_cmt_taken_o(ftq_cmt_taken_o),
    .ftq_cmt_mispred_o(ftq_cmt_mispred_o),
    .ftq_cmt_target_o(ftq_cmt_target_o),
    .ftq_cmt_br_type_o(ftq_cmt_br_type_o),
    .ftq_cmt_pc_o(ftq_cmt_pc_o),
    .ftq_query_id_o(ftq_query_id_o),
    .ftq_blk_target_i(ftq_blk_target_i),
    .ras_cmt_call_o(ras_cmt_call_o),
    .ras_cmt_ret_o(ras_cmt_ret_o),
    .ras_cmt_retaddr_o(ras_cmt_retaddr_o),
    .flush_req_o(flush_req_o),
    .flush_type_o(flush_type_o),
    .flush_pc_o(flush_pc_o),
    .idle_commit_o(idle_commit_o),
    .uncached_ld_inflight_i(uncached_ld_inflight_i),
    .debug0_valid_o(debug0_valid_o),
    .debug0_pc_o(debug0_pc_o),
    .debug0_rf_wen_o(debug0_rf_wen_o),
    .debug0_rf_wnum_o(debug0_rf_wnum_o),
    .debug0_rf_wdata_o(debug0_rf_wdata_o),
    .debug0_inst_o(debug0_inst_o),
    .debug1_valid_o(debug1_valid_o),
    .debug1_pc_o(debug1_pc_o),
    .debug1_rf_wen_o(debug1_rf_wen_o),
    .debug1_rf_wnum_o(debug1_rf_wnum_o),
    .debug1_rf_wdata_o(debug1_rf_wdata_o),
    .debug1_inst_o(debug1_inst_o)
  );
  initial clk=0; always #5 clk=~clk;
  initial begin
    reset=1; @(posedge clk); reset=0;

    `TB_PASS("commit tie-off run");
    $display("ALL TESTS DONE"); $finish;
  end
endmodule
