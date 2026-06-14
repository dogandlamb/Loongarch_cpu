`timescale 1ns/1ps
`include "mycpu.h"
`include "tb_macros.vh"
module ifu_tb;
  reg  clk;
  reg  reset;
  reg  flush_i;
  reg  ftq_valid_i;
  reg [31:0] ftq_pc_i;
  reg [`BLK_LEN_W-1:0] ftq_length_i;
  reg  ftq_taken_i;
  reg [31:0] ftq_target_i;
  reg [`FTQ_W-1:0] ftq_ftq_id_i;
  wire  ftq_accept_o;
  wire  mmu_i_req_o;
  wire [31:0] mmu_i_vaddr_o;
  reg [31:0] mmu_i_paddr_i;
  reg [1:0] mmu_i_mat_i;
  reg  mmu_i_excp_adef_i;
  reg [`TLB_EX_NUM-1:0] mmu_i_tlb_ex_i;
  wire  ic_req_o;
  wire [31:0] ic_vaddr_o;
  wire [31:0] ic_paddr_o;
  wire  ic_uncached_o;
  reg  ic_addr_ok_i;
  reg  ic_data_ok_i;
  reg [`CACHE_LINE_BITS-1:0] ic_rline_i;
  wire  ic_cancel_o;
  wire  predec_redirect_o;
  wire [31:0] predec_redirect_pc_o;
  wire [`FTQ_W-1:0] predec_redirect_id_o;
  wire [`BLK_LEN_W-1:0] predec_length_o;
  wire  predec_taken_o;
  wire [31:0] predec_target_o;
  wire [`BR_TYPE_W-1:0] predec_br_type_o;
  wire  ib_push0_valid_o;
  wire [31:0] ib_push0_pc_o;
  wire [31:0] ib_push0_inst_o;
  wire  ib_push0_pred_taken_o;
  wire  ib_push0_is_last_o;
  wire [`FTQ_W-1:0] ib_push0_ftq_id_o;
  wire [`EXCP_NUM-1:0] ib_push0_excp_o;
  wire  ib_push1_valid_o;
  wire [31:0] ib_push1_pc_o;
  wire [31:0] ib_push1_inst_o;
  wire  ib_push1_pred_taken_o;
  wire  ib_push1_is_last_o;
  wire [`FTQ_W-1:0] ib_push1_ftq_id_o;
  wire [`EXCP_NUM-1:0] ib_push1_excp_o;
  wire  ib_push2_valid_o;
  wire [31:0] ib_push2_pc_o;
  wire [31:0] ib_push2_inst_o;
  wire  ib_push2_pred_taken_o;
  wire  ib_push2_is_last_o;
  wire [`FTQ_W-1:0] ib_push2_ftq_id_o;
  wire [`EXCP_NUM-1:0] ib_push2_excp_o;
  wire  ib_push3_valid_o;
  wire [31:0] ib_push3_pc_o;
  wire [31:0] ib_push3_inst_o;
  wire  ib_push3_pred_taken_o;
  wire  ib_push3_is_last_o;
  wire [`FTQ_W-1:0] ib_push3_ftq_id_o;
  wire [`EXCP_NUM-1:0] ib_push3_excp_o;
  reg  ib_can_push_i;
  ifu uut(
    .clk(clk),
    .reset(reset),
    .flush_i(flush_i),
    .ftq_valid_i(ftq_valid_i),
    .ftq_pc_i(ftq_pc_i),
    .ftq_length_i(ftq_length_i),
    .ftq_taken_i(ftq_taken_i),
    .ftq_target_i(ftq_target_i),
    .ftq_ftq_id_i(ftq_ftq_id_i),
    .ftq_accept_o(ftq_accept_o),
    .mmu_i_req_o(mmu_i_req_o),
    .mmu_i_vaddr_o(mmu_i_vaddr_o),
    .mmu_i_paddr_i(mmu_i_paddr_i),
    .mmu_i_mat_i(mmu_i_mat_i),
    .mmu_i_excp_adef_i(mmu_i_excp_adef_i),
    .mmu_i_tlb_ex_i(mmu_i_tlb_ex_i),
    .ic_req_o(ic_req_o),
    .ic_vaddr_o(ic_vaddr_o),
    .ic_paddr_o(ic_paddr_o),
    .ic_uncached_o(ic_uncached_o),
    .ic_addr_ok_i(ic_addr_ok_i),
    .ic_data_ok_i(ic_data_ok_i),
    .ic_rline_i(ic_rline_i),
    .ic_cancel_o(ic_cancel_o),
    .predec_redirect_o(predec_redirect_o),
    .predec_redirect_pc_o(predec_redirect_pc_o),
    .predec_redirect_id_o(predec_redirect_id_o),
    .predec_length_o(predec_length_o),
    .predec_taken_o(predec_taken_o),
    .predec_target_o(predec_target_o),
    .predec_br_type_o(predec_br_type_o),
    .ib_push0_valid_o(ib_push0_valid_o),
    .ib_push0_pc_o(ib_push0_pc_o),
    .ib_push0_inst_o(ib_push0_inst_o),
    .ib_push0_pred_taken_o(ib_push0_pred_taken_o),
    .ib_push0_is_last_o(ib_push0_is_last_o),
    .ib_push0_ftq_id_o(ib_push0_ftq_id_o),
    .ib_push0_excp_o(ib_push0_excp_o),
    .ib_push1_valid_o(ib_push1_valid_o),
    .ib_push1_pc_o(ib_push1_pc_o),
    .ib_push1_inst_o(ib_push1_inst_o),
    .ib_push1_pred_taken_o(ib_push1_pred_taken_o),
    .ib_push1_is_last_o(ib_push1_is_last_o),
    .ib_push1_ftq_id_o(ib_push1_ftq_id_o),
    .ib_push1_excp_o(ib_push1_excp_o),
    .ib_push2_valid_o(ib_push2_valid_o),
    .ib_push2_pc_o(ib_push2_pc_o),
    .ib_push2_inst_o(ib_push2_inst_o),
    .ib_push2_pred_taken_o(ib_push2_pred_taken_o),
    .ib_push2_is_last_o(ib_push2_is_last_o),
    .ib_push2_ftq_id_o(ib_push2_ftq_id_o),
    .ib_push2_excp_o(ib_push2_excp_o),
    .ib_push3_valid_o(ib_push3_valid_o),
    .ib_push3_pc_o(ib_push3_pc_o),
    .ib_push3_inst_o(ib_push3_inst_o),
    .ib_push3_pred_taken_o(ib_push3_pred_taken_o),
    .ib_push3_is_last_o(ib_push3_is_last_o),
    .ib_push3_ftq_id_o(ib_push3_ftq_id_o),
    .ib_push3_excp_o(ib_push3_excp_o),
    .ib_can_push_i(ib_can_push_i)
  );
  initial clk=0; always #5 clk=~clk;
  initial begin
    reset=1; @(posedge clk); reset=0;

    `TB_PASS("ifu tie-off run");
    $display("ALL TESTS DONE"); $finish;
  end
endmodule
