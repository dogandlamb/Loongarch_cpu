`timescale 1ns/1ps
`include "mycpu.h"
`include "tb_macros.vh"
module fu_alu_tb;
  reg  clk;
  reg  reset;
  reg  flush_i;
  reg  issue_valid_i;
  reg [`ROB_W-1:0] issue_robid_i;
  reg [31:0] issue_pc_i;
  reg [`ALU_OP_NUM-1:0] issue_alu_op_i;
  reg [`BR_OP_NUM-1:0] issue_br_op_i;
  reg [31:0] issue_src0_i;
  reg [31:0] issue_src1_i;
  reg [31:0] issue_imm_i;
  reg  issue_use_imm_i;
  reg [31:0] issue_br_offs_i;
  wire  wb_valid_o;
  wire [`ROB_W-1:0] wb_robid_o;
  wire [31:0] wb_data_o;
  wire  wb_br_taken_o;
  wire [31:0] wb_br_target_o;
  wire  early_wakeup_valid_o;
  wire [`ROB_W-1:0] early_wakeup_robid_o;
  wire  ex_redirect_valid_o;
  wire [31:0] ex_redirect_pc_o;
  fu_alu uut(
    .clk(clk),
    .reset(reset),
    .flush_i(flush_i),
    .issue_valid_i(issue_valid_i),
    .issue_robid_i(issue_robid_i),
    .issue_pc_i(issue_pc_i),
    .issue_alu_op_i(issue_alu_op_i),
    .issue_br_op_i(issue_br_op_i),
    .issue_src0_i(issue_src0_i),
    .issue_src1_i(issue_src1_i),
    .issue_imm_i(issue_imm_i),
    .issue_use_imm_i(issue_use_imm_i),
    .issue_br_offs_i(issue_br_offs_i),
    .wb_valid_o(wb_valid_o),
    .wb_robid_o(wb_robid_o),
    .wb_data_o(wb_data_o),
    .wb_br_taken_o(wb_br_taken_o),
    .wb_br_target_o(wb_br_target_o),
    .early_wakeup_valid_o(early_wakeup_valid_o),
    .early_wakeup_robid_o(early_wakeup_robid_o),
    .ex_redirect_valid_o(ex_redirect_valid_o),
    .ex_redirect_pc_o(ex_redirect_pc_o)
  );
  initial clk=0; always #5 clk=~clk;
  initial begin
    reset=1; @(posedge clk); reset=0;

    `TB_PASS("fu_alu tie-off run");
    $display("ALL TESTS DONE"); $finish;
  end
endmodule
