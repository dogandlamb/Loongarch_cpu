`timescale 1ns/1ps
`include "mycpu.h"
`include "tb_macros.vh"
module ftq_tb;
  reg  clk;
  reg  reset;
  reg  flush_i;
  reg  p0_valid_i;
  reg [31:0] p0_pc_i;
  reg [`BLK_LEN_W-1:0] p0_length_i;
  reg  p0_taken_i;
  reg [31:0] p0_target_i;
  reg [`BR_TYPE_W-1:0] p0_br_type_i;
  reg  p1_valid_i;
  reg [31:0] p1_pc_i;
  reg [`BLK_LEN_W-1:0] p1_length_i;
  reg  p1_taken_i;
  reg [31:0] p1_target_i;
  reg [`BR_TYPE_W-1:0] p1_br_type_i;
  reg [`BPU_META_W-1:0] p1_meta_i;
  wire  ftq_full_o;
  wire  ifu_valid_o;
  wire [31:0] ifu_pc_o;
  wire [`BLK_LEN_W-1:0] ifu_length_o;
  wire  ifu_taken_o;
  wire [31:0] ifu_target_o;
  wire [`FTQ_W-1:0] ifu_ftq_id_o;
  reg  ifu_accept_i;
  reg  predec_redirect_i;
  reg [`FTQ_W-1:0] predec_redirect_id_i;
  reg [`BLK_LEN_W-1:0] predec_length_i;
  reg  predec_taken_i;
  reg [31:0] predec_target_i;
  reg [`BR_TYPE_W-1:0] predec_br_type_i;
  reg  cmt_valid_i;
  reg [`FTQ_W-1:0] cmt_ftq_id_i;
  reg  cmt_is_last_i;
  reg  cmt_is_branch_i;
  reg  cmt_taken_i;
  reg  cmt_mispred_i;
  reg [31:0] cmt_target_i;
  reg [`BR_TYPE_W-1:0] cmt_br_type_i;
  reg [31:0] cmt_pc_i;
  reg [`FTQ_W-1:0] cmt_query_id_i;
  wire [31:0] cmt_blk_target_o;
  wire  train_valid_o;
  wire [31:0] train_pc_o;
  wire  train_is_branch_o;
  wire  train_taken_o;
  wire  train_mispred_o;
  wire [31:0] train_target_o;
  wire [`BR_TYPE_W-1:0] train_br_type_o;
  wire [31:0] train_fall_through_o;
  wire [`BPU_META_W-1:0] train_meta_o;
  ftq uut(
    .clk(clk),
    .reset(reset),
    .flush_i(flush_i),
    .p0_valid_i(p0_valid_i),
    .p0_pc_i(p0_pc_i),
    .p0_length_i(p0_length_i),
    .p0_taken_i(p0_taken_i),
    .p0_target_i(p0_target_i),
    .p0_br_type_i(p0_br_type_i),
    .p1_valid_i(p1_valid_i),
    .p1_pc_i(p1_pc_i),
    .p1_length_i(p1_length_i),
    .p1_taken_i(p1_taken_i),
    .p1_target_i(p1_target_i),
    .p1_br_type_i(p1_br_type_i),
    .p1_meta_i(p1_meta_i),
    .ftq_full_o(ftq_full_o),
    .ifu_valid_o(ifu_valid_o),
    .ifu_pc_o(ifu_pc_o),
    .ifu_length_o(ifu_length_o),
    .ifu_taken_o(ifu_taken_o),
    .ifu_target_o(ifu_target_o),
    .ifu_ftq_id_o(ifu_ftq_id_o),
    .ifu_accept_i(ifu_accept_i),
    .predec_redirect_i(predec_redirect_i),
    .predec_redirect_id_i(predec_redirect_id_i),
    .predec_length_i(predec_length_i),
    .predec_taken_i(predec_taken_i),
    .predec_target_i(predec_target_i),
    .predec_br_type_i(predec_br_type_i),
    .cmt_valid_i(cmt_valid_i),
    .cmt_ftq_id_i(cmt_ftq_id_i),
    .cmt_is_last_i(cmt_is_last_i),
    .cmt_is_branch_i(cmt_is_branch_i),
    .cmt_taken_i(cmt_taken_i),
    .cmt_mispred_i(cmt_mispred_i),
    .cmt_target_i(cmt_target_i),
    .cmt_br_type_i(cmt_br_type_i),
    .cmt_pc_i(cmt_pc_i),
    .cmt_query_id_i(cmt_query_id_i),
    .cmt_blk_target_o(cmt_blk_target_o),
    .train_valid_o(train_valid_o),
    .train_pc_o(train_pc_o),
    .train_is_branch_o(train_is_branch_o),
    .train_taken_o(train_taken_o),
    .train_mispred_o(train_mispred_o),
    .train_target_o(train_target_o),
    .train_br_type_o(train_br_type_o),
    .train_fall_through_o(train_fall_through_o),
    .train_meta_o(train_meta_o)
  );
  initial clk=0; always #5 clk=~clk;
  initial begin
    reset=1; @(posedge clk); reset=0;

    p0_valid_i=1; p0_pc_i=32'h1c000000; p0_length_i=3'd4;
    @(posedge clk); p0_valid_i=0;
    #1;
    `TB_CHECK(ifu_valid_o, "ftq has block after p0");

    `TB_PASS("ftq tie-off run");
    $display("ALL TESTS DONE"); $finish;
  end
endmodule
