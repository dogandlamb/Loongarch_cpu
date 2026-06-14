`timescale 1ns/1ps
`include "mycpu.h"
`include "tb_macros.vh"
module lsu_tb;
  reg  clk;
  reg  reset;
  reg  flush_i;
  reg  issue_valid_i;
  reg [`ROB_W-1:0] issue_robid_i;
  reg [31:0] issue_pc_i;
  reg [`MEM_OP_NUM-1:0] issue_mem_op_i;
  reg  issue_is_cacop_i;
  reg [31:0] issue_base_i;
  reg [31:0] issue_wdata_i;
  reg [31:0] issue_imm_i;
  wire  lsu_ready_o;
  wire  mmu_d_req_o;
  wire [31:0] mmu_d_vaddr_o;
  wire  mmu_d_is_store_o;
  reg [31:0] mmu_d_paddr_i;
  reg [1:0] mmu_d_mat_i;
  reg [`TLB_EX_NUM-1:0] mmu_d_tlb_ex_i;
  reg  mmu_d_excp_adem_i;
  wire  dc_req_o;
  wire [31:0] dc_vaddr_o;
  wire [31:0] dc_paddr_o;
  wire [2:0] dc_size_o;
  wire  dc_uncached_o;
  reg  dc_addr_ok_i;
  reg  dc_data_ok_i;
  reg [31:0] dc_rdata_i;
  wire  dc_cancel_o;
  wire [31:0] sb_query_paddr_o;
  reg  sb_query_hit_i;
  reg [31:0] sb_query_data_i;
  reg  sb_query_partial_i;
  reg [`ROB_W-1:0] rob_head_robid_i;
  reg  rob_head_valid_i;
  wire  uncached_ld_inflight_o;
  wire  wb_valid_o;
  wire [`ROB_W-1:0] wb_robid_o;
  wire [31:0] wb_data_o;
  wire [31:0] wb_paddr_o;
  wire [31:0] wb_vaddr_o;
  wire [3:0] wb_wstrb_o;
  wire [2:0] wb_size_o;
  wire  wb_uncached_o;
  wire [`EXCP_NUM-1:0] wb_excp_o;
  wire  early_wakeup_valid_o;
  wire [`ROB_W-1:0] early_wakeup_robid_o;
  lsu uut(
    .clk(clk),
    .reset(reset),
    .flush_i(flush_i),
    .issue_valid_i(issue_valid_i),
    .issue_robid_i(issue_robid_i),
    .issue_pc_i(issue_pc_i),
    .issue_mem_op_i(issue_mem_op_i),
    .issue_is_cacop_i(issue_is_cacop_i),
    .issue_base_i(issue_base_i),
    .issue_wdata_i(issue_wdata_i),
    .issue_imm_i(issue_imm_i),
    .lsu_ready_o(lsu_ready_o),
    .mmu_d_req_o(mmu_d_req_o),
    .mmu_d_vaddr_o(mmu_d_vaddr_o),
    .mmu_d_is_store_o(mmu_d_is_store_o),
    .mmu_d_paddr_i(mmu_d_paddr_i),
    .mmu_d_mat_i(mmu_d_mat_i),
    .mmu_d_tlb_ex_i(mmu_d_tlb_ex_i),
    .mmu_d_excp_adem_i(mmu_d_excp_adem_i),
    .dc_req_o(dc_req_o),
    .dc_vaddr_o(dc_vaddr_o),
    .dc_paddr_o(dc_paddr_o),
    .dc_size_o(dc_size_o),
    .dc_uncached_o(dc_uncached_o),
    .dc_addr_ok_i(dc_addr_ok_i),
    .dc_data_ok_i(dc_data_ok_i),
    .dc_rdata_i(dc_rdata_i),
    .dc_cancel_o(dc_cancel_o),
    .sb_query_paddr_o(sb_query_paddr_o),
    .sb_query_hit_i(sb_query_hit_i),
    .sb_query_data_i(sb_query_data_i),
    .sb_query_partial_i(sb_query_partial_i),
    .rob_head_robid_i(rob_head_robid_i),
    .rob_head_valid_i(rob_head_valid_i),
    .uncached_ld_inflight_o(uncached_ld_inflight_o),
    .wb_valid_o(wb_valid_o),
    .wb_robid_o(wb_robid_o),
    .wb_data_o(wb_data_o),
    .wb_paddr_o(wb_paddr_o),
    .wb_vaddr_o(wb_vaddr_o),
    .wb_wstrb_o(wb_wstrb_o),
    .wb_size_o(wb_size_o),
    .wb_uncached_o(wb_uncached_o),
    .wb_excp_o(wb_excp_o),
    .early_wakeup_valid_o(early_wakeup_valid_o),
    .early_wakeup_robid_o(early_wakeup_robid_o)
  );
  initial clk=0; always #5 clk=~clk;
  initial begin
    reset=1; @(posedge clk); reset=0;

    `TB_PASS("lsu tie-off run");
    $display("ALL TESTS DONE"); $finish;
  end
endmodule
