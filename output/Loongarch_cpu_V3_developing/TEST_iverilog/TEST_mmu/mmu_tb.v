`timescale 1ns/1ps
`include "mycpu.h"
`include "tb_macros.vh"
module mmu_tb;
  reg clk;
  reg reset;
  reg  i_req_i;
  reg [31:0] i_vaddr_i;
  wire [31:0] i_paddr_o;
  wire [1:0] i_mat_o;
  wire  i_excp_adef_o;
  wire [`TLB_EX_NUM-1:0] i_tlb_ex_o;
  reg  d_req_i;
  reg  d_is_store_i;
  reg [31:0] d_vaddr_i;
  wire [31:0] d_paddr_o;
  wire [1:0] d_mat_o;
  wire  d_excp_adem_o;
  wire [`TLB_EX_NUM-1:0] d_tlb_ex_o;
  wire  tlbm_inst_req_o;
  wire [31:0] tlbm_inst_vaddr_o;
  wire  tlbm_data_req_o;
  wire  tlbm_data_is_store_o;
  wire [31:0] tlbm_data_vaddr_o;
  reg [31:0] tlbm_inst_paddr_i;
  reg [1:0] tlbm_inst_mat_i;
  reg  tlbm_inst_ex_adef_i;
  reg  tlbm_inst_ex_tlbr_i;
  reg  tlbm_inst_ex_pif_i;
  reg  tlbm_inst_ex_ppi_i;
  reg [31:0] tlbm_data_paddr_i;
  reg [1:0] tlbm_data_mat_i;
  reg  tlbm_data_ex_tlbr_i;
  reg  tlbm_data_ex_pil_i;
  reg  tlbm_data_ex_pis_i;
  reg  tlbm_data_ex_ppi_i;
  reg  tlbm_data_ex_pme_i;
  reg  tlbm_data_ex_adem_i;
  mmu uut(
    .i_req_i(i_req_i),
    .i_vaddr_i(i_vaddr_i),
    .i_paddr_o(i_paddr_o),
    .i_mat_o(i_mat_o),
    .i_excp_adef_o(i_excp_adef_o),
    .i_tlb_ex_o(i_tlb_ex_o),
    .d_req_i(d_req_i),
    .d_is_store_i(d_is_store_i),
    .d_vaddr_i(d_vaddr_i),
    .d_paddr_o(d_paddr_o),
    .d_mat_o(d_mat_o),
    .d_excp_adem_o(d_excp_adem_o),
    .d_tlb_ex_o(d_tlb_ex_o),
    .tlbm_inst_req_o(tlbm_inst_req_o),
    .tlbm_inst_vaddr_o(tlbm_inst_vaddr_o),
    .tlbm_data_req_o(tlbm_data_req_o),
    .tlbm_data_is_store_o(tlbm_data_is_store_o),
    .tlbm_data_vaddr_o(tlbm_data_vaddr_o),
    .tlbm_inst_paddr_i(tlbm_inst_paddr_i),
    .tlbm_inst_mat_i(tlbm_inst_mat_i),
    .tlbm_inst_ex_adef_i(tlbm_inst_ex_adef_i),
    .tlbm_inst_ex_tlbr_i(tlbm_inst_ex_tlbr_i),
    .tlbm_inst_ex_pif_i(tlbm_inst_ex_pif_i),
    .tlbm_inst_ex_ppi_i(tlbm_inst_ex_ppi_i),
    .tlbm_data_paddr_i(tlbm_data_paddr_i),
    .tlbm_data_mat_i(tlbm_data_mat_i),
    .tlbm_data_ex_tlbr_i(tlbm_data_ex_tlbr_i),
    .tlbm_data_ex_pil_i(tlbm_data_ex_pil_i),
    .tlbm_data_ex_pis_i(tlbm_data_ex_pis_i),
    .tlbm_data_ex_ppi_i(tlbm_data_ex_ppi_i),
    .tlbm_data_ex_pme_i(tlbm_data_ex_pme_i),
    .tlbm_data_ex_adem_i(tlbm_data_ex_adem_i)
  );
  initial clk=0; always #5 clk=~clk;
  initial begin
    reset=1; @(posedge clk); reset=0;

    `TB_PASS("mmu tie-off run");
    $display("ALL TESTS DONE"); $finish;
  end
endmodule
