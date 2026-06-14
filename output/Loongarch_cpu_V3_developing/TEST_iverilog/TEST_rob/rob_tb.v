`timescale 1ns/1ps
`include "mycpu.h"
`include "tb_macros.vh"
module rob_tb;
  reg  clk;
  reg  reset;
  reg  flush_i;
  reg  alloc_en_i;
  wire [`ROB_PAIR_W-1:0] rob_tail_o;
  wire  rob_full_o;
  wire  rob_empty_o;
  reg  a0_valid_i;
  reg [31:0] a0_pc_i;
  reg [31:0] a0_inst_i;
  reg  a0_rf_we_i;
  reg [4:0] a0_rd_i;
  reg [`FU_NUM-1:0] a0_futype_i;
  reg  a0_is_load_i;
  reg  a0_is_store_i;
  reg  a0_is_branch_i;
  reg [`BR_TYPE_W-1:0] a0_br_type_i;
  reg  a0_pred_taken_i;
  reg  a0_is_last_i;
  reg [`FTQ_W-1:0] a0_ftq_id_i;
  reg [`PRIV_NUM-1:0] a0_priv_vec_i;
  reg [13:0] a0_csr_num_i;
  reg [`TLB_OP_NUM-1:0] a0_tlb_op_i;
  reg [4:0] a0_cacop_code_i;
  reg [`EXCP_NUM-1:0] a0_excp_i;
  reg  a0_is_nop_i;
  reg  a1_valid_i;
  reg [31:0] a1_pc_i;
  reg [31:0] a1_inst_i;
  reg  a1_rf_we_i;
  reg [4:0] a1_rd_i;
  reg [`FU_NUM-1:0] a1_futype_i;
  reg  a1_is_load_i;
  reg  a1_is_store_i;
  reg  a1_is_branch_i;
  reg [`BR_TYPE_W-1:0] a1_br_type_i;
  reg  a1_pred_taken_i;
  reg  a1_is_last_i;
  reg [`FTQ_W-1:0] a1_ftq_id_i;
  reg [`PRIV_NUM-1:0] a1_priv_vec_i;
  reg [13:0] a1_csr_num_i;
  reg [`TLB_OP_NUM-1:0] a1_tlb_op_i;
  reg [4:0] a1_cacop_code_i;
  reg [`EXCP_NUM-1:0] a1_excp_i;
  reg  a1_is_nop_i;
  reg [`ROB_W-1:0] raddr0_i;
  wire  rrdy0_o;
  wire [31:0] rdata0_o;
  reg [`ROB_W-1:0] raddr1_i;
  wire  rrdy1_o;
  wire [31:0] rdata1_o;
  reg [`ROB_W-1:0] raddr2_i;
  wire  rrdy2_o;
  wire [31:0] rdata2_o;
  reg [`ROB_W-1:0] raddr3_i;
  wire  rrdy3_o;
  wire [31:0] rdata3_o;
  reg  alu0_wb_valid_i;
  reg [`ROB_W-1:0] alu0_wb_robid_i;
  reg [31:0] alu0_wb_data_i;
  reg  alu0_wb_br_taken_i;
  reg [31:0] alu0_wb_br_target_i;
  reg  alu1_wb_valid_i;
  reg [`ROB_W-1:0] alu1_wb_robid_i;
  reg [31:0] alu1_wb_data_i;
  reg  alu1_wb_br_taken_i;
  reg [31:0] alu1_wb_br_target_i;
  reg  mem_wb_valid_i;
  reg [`ROB_W-1:0] mem_wb_robid_i;
  reg [31:0] mem_wb_data_i;
  reg [31:0] mem_wb_paddr_i;
  reg [31:0] mem_wb_vaddr_i;
  reg [3:0] mem_wb_wstrb_i;
  reg [2:0] mem_wb_size_i;
  reg  mem_wb_uncached_i;
  reg [`EXCP_NUM-1:0] mem_wb_excp_i;
  reg  mdu_wb_valid_i;
  reg [`ROB_W-1:0] mdu_wb_robid_i;
  reg [31:0] mdu_wb_data_i;
  reg [31:0] mdu_wb_data2_i;
  wire [`ROB_SIZE-1:0] done_vec_o;
  wire [32*`ROB_SIZE-1:0] result_flat_o;
  wire [`ROB_W-1:0] head_robid0_o;
  wire  cmt0_valid_o;
  wire  cmt0_complete_o;
  wire [31:0] cmt0_pc_o;
  wire [31:0] cmt0_inst_o;
  wire  cmt0_rf_we_o;
  wire [4:0] cmt0_rd_o;
  wire [31:0] cmt0_result_o;
  wire [31:0] cmt0_result2_o;
  wire  cmt0_is_load_o;
  wire  cmt0_is_store_o;
  wire [31:0] cmt0_paddr_o;
  wire [31:0] cmt0_vaddr_o;
  wire [3:0] cmt0_wstrb_o;
  wire [2:0] cmt0_size_o;
  wire  cmt0_uncached_o;
  wire  cmt0_is_branch_o;
  wire [`BR_TYPE_W-1:0] cmt0_br_type_o;
  wire  cmt0_pred_taken_o;
  wire  cmt0_br_taken_o;
  wire [31:0] cmt0_br_target_o;
  wire  cmt0_is_last_o;
  wire [`FTQ_W-1:0] cmt0_ftq_id_o;
  wire [`PRIV_NUM-1:0] cmt0_priv_vec_o;
  wire [13:0] cmt0_csr_num_o;
  wire [`TLB_OP_NUM-1:0] cmt0_tlb_op_o;
  wire [4:0] cmt0_cacop_code_o;
  wire [`EXCP_NUM-1:0] cmt0_excp_o;
  wire  cmt1_valid_o;
  wire  cmt1_complete_o;
  wire [31:0] cmt1_pc_o;
  wire [31:0] cmt1_inst_o;
  wire  cmt1_rf_we_o;
  wire [4:0] cmt1_rd_o;
  wire [31:0] cmt1_result_o;
  wire [31:0] cmt1_result2_o;
  wire  cmt1_is_load_o;
  wire  cmt1_is_store_o;
  wire [31:0] cmt1_paddr_o;
  wire [31:0] cmt1_vaddr_o;
  wire [3:0] cmt1_wstrb_o;
  wire [2:0] cmt1_size_o;
  wire  cmt1_uncached_o;
  wire  cmt1_is_branch_o;
  wire [`BR_TYPE_W-1:0] cmt1_br_type_o;
  wire  cmt1_pred_taken_o;
  wire  cmt1_br_taken_o;
  wire [31:0] cmt1_br_target_o;
  wire  cmt1_is_last_o;
  wire [`FTQ_W-1:0] cmt1_ftq_id_o;
  wire [`PRIV_NUM-1:0] cmt1_priv_vec_o;
  wire [13:0] cmt1_csr_num_o;
  wire [`TLB_OP_NUM-1:0] cmt1_tlb_op_o;
  wire [4:0] cmt1_cacop_code_o;
  wire [`EXCP_NUM-1:0] cmt1_excp_o;
  reg  cmt_pop_i;
  reg  cmt_clear0_i;
  reg  cmt_clear1_i;
  rob uut(
    .clk(clk),
    .reset(reset),
    .flush_i(flush_i),
    .alloc_en_i(alloc_en_i),
    .rob_tail_o(rob_tail_o),
    .rob_full_o(rob_full_o),
    .rob_empty_o(rob_empty_o),
    .a0_valid_i(a0_valid_i),
    .a0_pc_i(a0_pc_i),
    .a0_inst_i(a0_inst_i),
    .a0_rf_we_i(a0_rf_we_i),
    .a0_rd_i(a0_rd_i),
    .a0_futype_i(a0_futype_i),
    .a0_is_load_i(a0_is_load_i),
    .a0_is_store_i(a0_is_store_i),
    .a0_is_branch_i(a0_is_branch_i),
    .a0_br_type_i(a0_br_type_i),
    .a0_pred_taken_i(a0_pred_taken_i),
    .a0_is_last_i(a0_is_last_i),
    .a0_ftq_id_i(a0_ftq_id_i),
    .a0_priv_vec_i(a0_priv_vec_i),
    .a0_csr_num_i(a0_csr_num_i),
    .a0_tlb_op_i(a0_tlb_op_i),
    .a0_cacop_code_i(a0_cacop_code_i),
    .a0_excp_i(a0_excp_i),
    .a0_is_nop_i(a0_is_nop_i),
    .a1_valid_i(a1_valid_i),
    .a1_pc_i(a1_pc_i),
    .a1_inst_i(a1_inst_i),
    .a1_rf_we_i(a1_rf_we_i),
    .a1_rd_i(a1_rd_i),
    .a1_futype_i(a1_futype_i),
    .a1_is_load_i(a1_is_load_i),
    .a1_is_store_i(a1_is_store_i),
    .a1_is_branch_i(a1_is_branch_i),
    .a1_br_type_i(a1_br_type_i),
    .a1_pred_taken_i(a1_pred_taken_i),
    .a1_is_last_i(a1_is_last_i),
    .a1_ftq_id_i(a1_ftq_id_i),
    .a1_priv_vec_i(a1_priv_vec_i),
    .a1_csr_num_i(a1_csr_num_i),
    .a1_tlb_op_i(a1_tlb_op_i),
    .a1_cacop_code_i(a1_cacop_code_i),
    .a1_excp_i(a1_excp_i),
    .a1_is_nop_i(a1_is_nop_i),
    .raddr0_i(raddr0_i),
    .rrdy0_o(rrdy0_o),
    .rdata0_o(rdata0_o),
    .raddr1_i(raddr1_i),
    .rrdy1_o(rrdy1_o),
    .rdata1_o(rdata1_o),
    .raddr2_i(raddr2_i),
    .rrdy2_o(rrdy2_o),
    .rdata2_o(rdata2_o),
    .raddr3_i(raddr3_i),
    .rrdy3_o(rrdy3_o),
    .rdata3_o(rdata3_o),
    .alu0_wb_valid_i(alu0_wb_valid_i),
    .alu0_wb_robid_i(alu0_wb_robid_i),
    .alu0_wb_data_i(alu0_wb_data_i),
    .alu0_wb_br_taken_i(alu0_wb_br_taken_i),
    .alu0_wb_br_target_i(alu0_wb_br_target_i),
    .alu1_wb_valid_i(alu1_wb_valid_i),
    .alu1_wb_robid_i(alu1_wb_robid_i),
    .alu1_wb_data_i(alu1_wb_data_i),
    .alu1_wb_br_taken_i(alu1_wb_br_taken_i),
    .alu1_wb_br_target_i(alu1_wb_br_target_i),
    .mem_wb_valid_i(mem_wb_valid_i),
    .mem_wb_robid_i(mem_wb_robid_i),
    .mem_wb_data_i(mem_wb_data_i),
    .mem_wb_paddr_i(mem_wb_paddr_i),
    .mem_wb_vaddr_i(mem_wb_vaddr_i),
    .mem_wb_wstrb_i(mem_wb_wstrb_i),
    .mem_wb_size_i(mem_wb_size_i),
    .mem_wb_uncached_i(mem_wb_uncached_i),
    .mem_wb_excp_i(mem_wb_excp_i),
    .mdu_wb_valid_i(mdu_wb_valid_i),
    .mdu_wb_robid_i(mdu_wb_robid_i),
    .mdu_wb_data_i(mdu_wb_data_i),
    .mdu_wb_data2_i(mdu_wb_data2_i),
    .done_vec_o(done_vec_o),
    .result_flat_o(result_flat_o),
    .head_robid0_o(head_robid0_o),
    .cmt0_valid_o(cmt0_valid_o),
    .cmt0_complete_o(cmt0_complete_o),
    .cmt0_pc_o(cmt0_pc_o),
    .cmt0_inst_o(cmt0_inst_o),
    .cmt0_rf_we_o(cmt0_rf_we_o),
    .cmt0_rd_o(cmt0_rd_o),
    .cmt0_result_o(cmt0_result_o),
    .cmt0_result2_o(cmt0_result2_o),
    .cmt0_is_load_o(cmt0_is_load_o),
    .cmt0_is_store_o(cmt0_is_store_o),
    .cmt0_paddr_o(cmt0_paddr_o),
    .cmt0_vaddr_o(cmt0_vaddr_o),
    .cmt0_wstrb_o(cmt0_wstrb_o),
    .cmt0_size_o(cmt0_size_o),
    .cmt0_uncached_o(cmt0_uncached_o),
    .cmt0_is_branch_o(cmt0_is_branch_o),
    .cmt0_br_type_o(cmt0_br_type_o),
    .cmt0_pred_taken_o(cmt0_pred_taken_o),
    .cmt0_br_taken_o(cmt0_br_taken_o),
    .cmt0_br_target_o(cmt0_br_target_o),
    .cmt0_is_last_o(cmt0_is_last_o),
    .cmt0_ftq_id_o(cmt0_ftq_id_o),
    .cmt0_priv_vec_o(cmt0_priv_vec_o),
    .cmt0_csr_num_o(cmt0_csr_num_o),
    .cmt0_tlb_op_o(cmt0_tlb_op_o),
    .cmt0_cacop_code_o(cmt0_cacop_code_o),
    .cmt0_excp_o(cmt0_excp_o),
    .cmt1_valid_o(cmt1_valid_o),
    .cmt1_complete_o(cmt1_complete_o),
    .cmt1_pc_o(cmt1_pc_o),
    .cmt1_inst_o(cmt1_inst_o),
    .cmt1_rf_we_o(cmt1_rf_we_o),
    .cmt1_rd_o(cmt1_rd_o),
    .cmt1_result_o(cmt1_result_o),
    .cmt1_result2_o(cmt1_result2_o),
    .cmt1_is_load_o(cmt1_is_load_o),
    .cmt1_is_store_o(cmt1_is_store_o),
    .cmt1_paddr_o(cmt1_paddr_o),
    .cmt1_vaddr_o(cmt1_vaddr_o),
    .cmt1_wstrb_o(cmt1_wstrb_o),
    .cmt1_size_o(cmt1_size_o),
    .cmt1_uncached_o(cmt1_uncached_o),
    .cmt1_is_branch_o(cmt1_is_branch_o),
    .cmt1_br_type_o(cmt1_br_type_o),
    .cmt1_pred_taken_o(cmt1_pred_taken_o),
    .cmt1_br_taken_o(cmt1_br_taken_o),
    .cmt1_br_target_o(cmt1_br_target_o),
    .cmt1_is_last_o(cmt1_is_last_o),
    .cmt1_ftq_id_o(cmt1_ftq_id_o),
    .cmt1_priv_vec_o(cmt1_priv_vec_o),
    .cmt1_csr_num_o(cmt1_csr_num_o),
    .cmt1_tlb_op_o(cmt1_tlb_op_o),
    .cmt1_cacop_code_o(cmt1_cacop_code_o),
    .cmt1_excp_o(cmt1_excp_o),
    .cmt_pop_i(cmt_pop_i),
    .cmt_clear0_i(cmt_clear0_i),
    .cmt_clear1_i(cmt_clear1_i)
  );
  initial clk=0; always #5 clk=~clk;
  initial begin
    reset=1; @(posedge clk); reset=0;

    `TB_PASS("rob tie-off run");
    $display("ALL TESTS DONE"); $finish;
  end
endmodule
