`timescale 1ns/1ps
`include "mycpu.h"
`include "tb_macros.vh"
module bpu_tb;
  reg  clk;
  reg  reset;
  reg  flush_i;
  reg [31:0] flush_pc_i;
  reg  predec_redirect_i;
  reg [31:0] predec_redirect_pc_i;
  reg  ftq_full_i;
  wire  p0_valid_o;
  wire [31:0] p0_pc_o;
  wire [`BLK_LEN_W-1:0] p0_length_o;
  wire  p0_taken_o;
  wire [31:0] p0_target_o;
  wire [`BR_TYPE_W-1:0] p0_br_type_o;
  wire  p1_valid_o;
  wire [31:0] p1_pc_o;
  wire [`BLK_LEN_W-1:0] p1_length_o;
  wire  p1_taken_o;
  wire [31:0] p1_target_o;
  wire [`BR_TYPE_W-1:0] p1_br_type_o;
  wire [`BPU_META_W-1:0] p1_meta_o;
  reg  train_valid_i;
  reg [31:0] train_pc_i;
  reg  train_is_branch_i;
  reg  train_taken_i;
  reg  train_mispred_i;
  reg [31:0] train_target_i;
  reg [`BR_TYPE_W-1:0] train_br_type_i;
  reg [31:0] train_fall_through_i;
  reg [`BPU_META_W-1:0] train_meta_i;
  reg  cmt_is_call_i;
  reg  cmt_is_ret_i;
  reg [31:0] cmt_call_retaddr_i;
  bpu uut(
    .clk(clk),
    .reset(reset),
    .flush_i(flush_i),
    .flush_pc_i(flush_pc_i),
    .predec_redirect_i(predec_redirect_i),
    .predec_redirect_pc_i(predec_redirect_pc_i),
    .ftq_full_i(ftq_full_i),
    .p0_valid_o(p0_valid_o),
    .p0_pc_o(p0_pc_o),
    .p0_length_o(p0_length_o),
    .p0_taken_o(p0_taken_o),
    .p0_target_o(p0_target_o),
    .p0_br_type_o(p0_br_type_o),
    .p1_valid_o(p1_valid_o),
    .p1_pc_o(p1_pc_o),
    .p1_length_o(p1_length_o),
    .p1_taken_o(p1_taken_o),
    .p1_target_o(p1_target_o),
    .p1_br_type_o(p1_br_type_o),
    .p1_meta_o(p1_meta_o),
    .train_valid_i(train_valid_i),
    .train_pc_i(train_pc_i),
    .train_is_branch_i(train_is_branch_i),
    .train_taken_i(train_taken_i),
    .train_mispred_i(train_mispred_i),
    .train_target_i(train_target_i),
    .train_br_type_i(train_br_type_i),
    .train_fall_through_i(train_fall_through_i),
    .train_meta_i(train_meta_i),
    .cmt_is_call_i(cmt_is_call_i),
    .cmt_is_ret_i(cmt_is_ret_i),
    .cmt_call_retaddr_i(cmt_call_retaddr_i)
  );
  initial clk=0; always #5 clk=~clk;
  initial begin
    reset=1; @(posedge clk); reset=0;

    `TB_PASS("bpu tie-off run");
    $display("ALL TESTS DONE"); $finish;
  end
endmodule
