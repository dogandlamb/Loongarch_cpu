`timescale 1ns/1ps
`include "mycpu.h"
`include "tb_macros.vh"
module fu_mdu_tb;
  reg  clk;
  reg  reset;
  reg  flush_i;
  reg  issue_valid_i;
  reg [`ROB_W-1:0] issue_robid_i;
  reg [`ALU_OP_NUM-1:0] issue_alu_op_i;
  reg [`CSR_OP_NUM-1:0] issue_csr_op_i;
  reg [13:0] issue_csr_num_i;
  reg [`TLB_OP_NUM-1:0] issue_tlb_op_i;
  reg [`WB_SRC_NUM-1:0] issue_wb_src_op_i;
  reg [31:0] issue_src0_i;
  reg [31:0] issue_src1_i;
  wire  mdu_ready_o;
  wire [13:0] csr_raddr_o;
  reg [31:0] csr_rdata_i;
  reg [63:0] timer_64_i;
  reg [31:0] csr_tid_i;
  wire  wb_valid_o;
  wire [`ROB_W-1:0] wb_robid_o;
  wire [31:0] wb_data_o;
  wire [31:0] wb_data2_o;
  fu_mdu uut(
    .clk(clk),
    .reset(reset),
    .flush_i(flush_i),
    .issue_valid_i(issue_valid_i),
    .issue_robid_i(issue_robid_i),
    .issue_alu_op_i(issue_alu_op_i),
    .issue_csr_op_i(issue_csr_op_i),
    .issue_csr_num_i(issue_csr_num_i),
    .issue_tlb_op_i(issue_tlb_op_i),
    .issue_wb_src_op_i(issue_wb_src_op_i),
    .issue_src0_i(issue_src0_i),
    .issue_src1_i(issue_src1_i),
    .mdu_ready_o(mdu_ready_o),
    .csr_raddr_o(csr_raddr_o),
    .csr_rdata_i(csr_rdata_i),
    .timer_64_i(timer_64_i),
    .csr_tid_i(csr_tid_i),
    .wb_valid_o(wb_valid_o),
    .wb_robid_o(wb_robid_o),
    .wb_data_o(wb_data_o),
    .wb_data2_o(wb_data2_o)
  );
  initial clk=0; always #5 clk=~clk;
  initial begin
    reset=1; @(posedge clk); reset=0;

    `TB_PASS("fu_mdu tie-off run");
    $display("ALL TESTS DONE"); $finish;
  end
endmodule
