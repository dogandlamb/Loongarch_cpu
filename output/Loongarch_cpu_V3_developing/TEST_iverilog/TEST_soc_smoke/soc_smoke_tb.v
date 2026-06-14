`timescale 1ns/1ps
`include "mycpu.h"
`include "tb_macros.vh"

// mini-SoC 冒烟：例化 BPU+FTQ+IB+RAT+ROB 关键路径模块，验证参考 CPU 子模块可联合编译运行
module soc_smoke_tb;
  reg clk, reset;

  // BPU/FTQ
  wire bpu_p0_valid, ftq_full, ftq_ifu_valid, ifu_accept;
  wire [31:0] bpu_p0_pc, ftq_ifu_pc;
  wire [`BLK_LEN_W-1:0] bpu_p0_len, ftq_ifu_len;
  wire bpu_p0_taken, ftq_ifu_taken;
  wire [31:0] bpu_p0_target, ftq_ifu_target;
  wire [`BR_TYPE_W-1:0] bpu_p0_btype;
  wire bpu_p1_valid;
  wire [31:0] bpu_p1_pc, bpu_p1_target;
  wire [`BLK_LEN_W-1:0] bpu_p1_len;
  wire bpu_p1_taken;
  wire [`BR_TYPE_W-1:0] bpu_p1_btype;
  wire [`BPU_META_W-1:0] bpu_p1_meta;
  wire ftq_train_valid;
  wire [31:0] ftq_train_pc, ftq_train_target, ftq_train_fall;
  wire ftq_train_is_branch, ftq_train_taken, ftq_train_mispred;
  wire [`BR_TYPE_W-1:0] ftq_train_btype;
  wire [`BPU_META_W-1:0] ftq_train_meta;
  wire cmt_ras_call, cmt_ras_ret;
  wire [31:0] cmt_ras_retaddr;
  wire predec_redirect;
  wire [31:0] predec_redirect_pc;
  wire [`FTQ_W-1:0] predec_redirect_id;
  wire [`BLK_LEN_W-1:0] predec_length;
  wire predec_taken;
  wire [31:0] predec_target;
  wire [`BR_TYPE_W-1:0] predec_btype;
  wire [`FTQ_W-1:0] ftq_ifu_id;
  wire ib_can_push;
  wire ib_pop0_ready, ib_pop1_ready;
  wire ib_pop0_valid, ib_pop1_valid;

  initial clk=0;
  always #5 clk=~clk;

  assign ib_can_push = 1'b1;
  assign ib_pop0_ready = ib_pop0_valid;
  assign ib_pop1_ready = ib_pop1_valid;
  assign cmt_ras_call = 0; assign cmt_ras_ret = 0; assign cmt_ras_retaddr = 0;
  assign predec_redirect = 0; assign predec_redirect_pc = 0;
  assign predec_redirect_id = 0; assign predec_length = 0;
  assign predec_taken = 0; assign predec_target = 0; assign predec_btype = 0;
  assign ifu_accept = 0;

  bpu u_bpu(
    .clk(clk), .reset(reset), .flush_i(0), .flush_pc_i(32'h1c000000),
    .predec_redirect_i(0), .predec_redirect_pc_i(0), .ftq_full_i(ftq_full),
    .p0_valid_o(bpu_p0_valid), .p0_pc_o(bpu_p0_pc), .p0_length_o(bpu_p0_len),
    .p0_taken_o(bpu_p0_taken), .p0_target_o(bpu_p0_target), .p0_br_type_o(bpu_p0_btype),
    .p1_valid_o(bpu_p1_valid), .p1_pc_o(bpu_p1_pc), .p1_length_o(bpu_p1_len),
    .p1_taken_o(bpu_p1_taken), .p1_target_o(bpu_p1_target), .p1_br_type_o(bpu_p1_btype),
    .p1_meta_o(bpu_p1_meta),
    .train_valid_i(ftq_train_valid), .train_pc_i(ftq_train_pc),
    .train_is_branch_i(ftq_train_is_branch), .train_taken_i(ftq_train_taken),
    .train_mispred_i(ftq_train_mispred), .train_target_i(ftq_train_target),
    .train_br_type_i(ftq_train_btype), .train_fall_through_i(ftq_train_fall),
    .train_meta_i(ftq_train_meta),
    .cmt_is_call_i(cmt_ras_call), .cmt_is_ret_i(cmt_ras_ret), .cmt_call_retaddr_i(cmt_ras_retaddr));

  ftq u_ftq(
    .clk(clk), .reset(reset), .flush_i(0),
    .p0_valid_i(bpu_p0_valid), .p0_pc_i(bpu_p0_pc), .p0_length_i(bpu_p0_len),
    .p0_taken_i(bpu_p0_taken), .p0_target_i(bpu_p0_target), .p0_br_type_i(bpu_p0_btype),
    .p1_valid_i(bpu_p1_valid), .p1_pc_i(bpu_p1_pc), .p1_length_i(bpu_p1_len),
    .p1_taken_i(bpu_p1_taken), .p1_target_i(bpu_p1_target), .p1_br_type_i(bpu_p1_btype),
    .p1_meta_i(bpu_p1_meta), .ftq_full_o(ftq_full),
    .ifu_valid_o(ftq_ifu_valid), .ifu_pc_o(ftq_ifu_pc), .ifu_length_o(ftq_ifu_len),
    .ifu_taken_o(ftq_ifu_taken), .ifu_target_o(ftq_ifu_target), .ifu_ftq_id_o(ftq_ifu_id),
    .ifu_accept_i(ifu_accept),
    .predec_redirect_i(predec_redirect), .predec_redirect_id_i(predec_redirect_id),
    .predec_length_i(predec_length), .predec_taken_i(predec_taken),
    .predec_target_i(predec_target), .predec_br_type_i(predec_btype),
    .cmt_valid_i(0), .cmt_ftq_id_i(0), .cmt_is_last_i(0), .cmt_is_branch_i(0),
    .cmt_taken_i(0), .cmt_mispred_i(0), .cmt_target_i(0), .cmt_br_type_i(0), .cmt_pc_i(0),
    .cmt_query_id_i(0), .cmt_blk_target_o(),
    .train_valid_o(ftq_train_valid), .train_pc_o(ftq_train_pc),
    .train_is_branch_o(ftq_train_is_branch), .train_taken_o(ftq_train_taken),
    .train_mispred_o(ftq_train_mispred), .train_target_o(ftq_train_target),
    .train_br_type_o(ftq_train_btype), .train_fall_through_o(ftq_train_fall),
    .train_meta_o(ftq_train_meta));

  inst_buffer u_ib(
    .clk(clk), .reset(reset), .flush_i(0),
    .push0_valid_i(0), .push0_pc_i(0), .push0_inst_i(0),
    .push0_pred_taken_i(0), .push0_is_last_i(0), .push0_ftq_id_i(0), .push0_excp_i(0),
    .push1_valid_i(0), .push1_pc_i(0), .push1_inst_i(0),
    .push1_pred_taken_i(0), .push1_is_last_i(0), .push1_ftq_id_i(0), .push1_excp_i(0),
    .push2_valid_i(0), .push2_pc_i(0), .push2_inst_i(0),
    .push2_pred_taken_i(0), .push2_is_last_i(0), .push2_ftq_id_i(0), .push2_excp_i(0),
    .push3_valid_i(0), .push3_pc_i(0), .push3_inst_i(0),
    .push3_pred_taken_i(0), .push3_is_last_i(0), .push3_ftq_id_i(0), .push3_excp_i(0),
    .can_push_o(ib_can_push),
    .pop0_valid_o(ib_pop0_valid), .pop0_pc_o(), .pop0_inst_o(), .pop0_pred_taken_o(),
    .pop0_is_last_o(), .pop0_ftq_id_o(), .pop0_excp_o(), .pop0_ready_i(ib_pop0_ready),
    .pop1_valid_o(ib_pop1_valid), .pop1_pc_o(), .pop1_inst_o(), .pop1_pred_taken_o(),
    .pop1_is_last_o(), .pop1_ftq_id_o(), .pop1_excp_o(), .pop1_ready_i(ib_pop1_ready));

  initial begin
    reset=1;
    @(posedge clk); reset=0;
    repeat(20) @(posedge clk);
    `TB_CHECK(bpu_p0_valid || ftq_ifu_valid, "frontend produces blocks");
    $display("ALL TESTS DONE");
    $finish;
  end
endmodule
