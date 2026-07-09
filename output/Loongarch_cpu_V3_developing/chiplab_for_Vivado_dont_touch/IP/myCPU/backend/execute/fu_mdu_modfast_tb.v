`timescale 1ns/1ps
`include "mycpu.h"
module fu_mdu_modfast_tb;
  reg clk, reset, flush, issue_valid;
  reg [`ROB_W-1:0] issue_robid;
  reg [`ALU_OP_NUM-1:0] issue_alu_op;
  reg [31:0] issue_src0, issue_src1;
  wire mdu_ready, wb_valid;
  wire [31:0] wb_data;
  fu_mdu uut(.clk(clk), .reset(reset), .flush_i(flush),
    .issue_valid_i(issue_valid), .issue_robid_i(issue_robid),
    .issue_alu_op_i(issue_alu_op), .issue_csr_op_i(0), .issue_csr_num_i(0),
    .issue_tlb_op_i(0), .issue_wb_src_op_i(0),
    .issue_src0_i(issue_src0), .issue_src1_i(issue_src1),
    .mdu_ready_o(mdu_ready), .csr_raddr_o(), .csr_rdata_i(0),
    .timer_64_i(0), .csr_tid_i(0),
    .wb_valid_o(wb_valid), .wb_robid_o(), .wb_data_o(wb_data), .wb_data2_o());
  initial clk=0; always #5 clk=~clk;
  integer k;
  initial begin
    reset=1; flush=0; issue_valid=0; issue_alu_op=0;
    @(negedge clk); @(negedge clk); reset=0;
    issue_robid=7; issue_src0=32'hfda5ea8a; issue_src1=32'hfac1873c;
    issue_alu_op[`ALU_OP_MOD_W]=1;
    issue_valid=1;
    @(negedge clk); issue_valid=0;
    for (k=0;k<20;k=k+1) begin
      @(negedge clk);
      $display("k=%0d ready=%b valid=%b data=%h", k, mdu_ready, wb_valid, wb_data);
      if (wb_valid && wb_data===32'hfda5ea8a) begin
        $display("PASS fast mod");
        $finish;
      end
    end
    $display("FAIL fast mod data=%h", wb_data);
    $finish;
  end
endmodule
