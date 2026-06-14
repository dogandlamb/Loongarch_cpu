`timescale 1ns/1ps
`include "mycpu.h"
`include "tb_macros.vh"
module rs_alu_tb;
  reg  clk;
  reg  reset;
  reg  flush_i;
  reg  push_valid_i;
  reg [`ROB_W-1:0] push_robid_i;
  reg [31:0] push_pc_i;
  reg [`ALU_OP_NUM-1:0] push_alu_op_i;
  reg [`BR_OP_NUM-1:0] push_br_op_i;
  reg  push_src0_ready_i;
  reg [31:0] push_src0_val_i;
  reg [`ROB_W-1:0] push_src0_robid_i;
  reg  push_src1_ready_i;
  reg [31:0] push_src1_val_i;
  reg [`ROB_W-1:0] push_src1_robid_i;
  reg [31:0] push_imm_i;
  reg  push_use_imm_i;
  reg [31:0] push_br_offs_i;
  wire  can_accept_o;
  wire [2:0] occupancy_o;
  reg  wb0_valid_i;
  reg [`ROB_W-1:0] wb0_robid_i;
  reg [31:0] wb0_data_i;
  reg  wb1_valid_i;
  reg [`ROB_W-1:0] wb1_robid_i;
  reg [31:0] wb1_data_i;
  reg  wb2_valid_i;
  reg [`ROB_W-1:0] wb2_robid_i;
  reg [31:0] wb2_data_i;
  reg  wb3_valid_i;
  reg [`ROB_W-1:0] wb3_robid_i;
  reg [31:0] wb3_data_i;
  reg  cmt_wake0_valid_i;
  reg [`ROB_W-1:0] cmt_wake0_robid_i;
  reg [31:0] cmt_wake0_data_i;
  reg  cmt_wake1_valid_i;
  reg [`ROB_W-1:0] cmt_wake1_robid_i;
  reg [31:0] cmt_wake1_data_i;
  reg [`ROB_SIZE-1:0] rob_done_i;
  reg [32*`ROB_SIZE-1:0] rob_result_flat_i;
  reg  early0_valid_i;
  reg [`ROB_W-1:0] early0_robid_i;
  reg  early1_valid_i;
  reg [`ROB_W-1:0] early1_robid_i;
  reg  early2_valid_i;
  reg [`ROB_W-1:0] early2_robid_i;
  wire  issue_valid_o;
  wire [`ROB_W-1:0] issue_robid_o;
  wire [31:0] issue_pc_o;
  wire [`ALU_OP_NUM-1:0] issue_alu_op_o;
  wire [`BR_OP_NUM-1:0] issue_br_op_o;
  wire [31:0] issue_src0_o;
  wire [31:0] issue_src1_o;
  wire [31:0] issue_imm_o;
  wire  issue_use_imm_o;
  wire [31:0] issue_br_offs_o;
  rs_alu uut(
    .clk(clk),
    .reset(reset),
    .flush_i(flush_i),
    .push_valid_i(push_valid_i),
    .push_robid_i(push_robid_i),
    .push_pc_i(push_pc_i),
    .push_alu_op_i(push_alu_op_i),
    .push_br_op_i(push_br_op_i),
    .push_src0_ready_i(push_src0_ready_i),
    .push_src0_val_i(push_src0_val_i),
    .push_src0_robid_i(push_src0_robid_i),
    .push_src1_ready_i(push_src1_ready_i),
    .push_src1_val_i(push_src1_val_i),
    .push_src1_robid_i(push_src1_robid_i),
    .push_imm_i(push_imm_i),
    .push_use_imm_i(push_use_imm_i),
    .push_br_offs_i(push_br_offs_i),
    .can_accept_o(can_accept_o),
    .occupancy_o(occupancy_o),
    .wb0_valid_i(wb0_valid_i),
    .wb0_robid_i(wb0_robid_i),
    .wb0_data_i(wb0_data_i),
    .wb1_valid_i(wb1_valid_i),
    .wb1_robid_i(wb1_robid_i),
    .wb1_data_i(wb1_data_i),
    .wb2_valid_i(wb2_valid_i),
    .wb2_robid_i(wb2_robid_i),
    .wb2_data_i(wb2_data_i),
    .wb3_valid_i(wb3_valid_i),
    .wb3_robid_i(wb3_robid_i),
    .wb3_data_i(wb3_data_i),
    .cmt_wake0_valid_i(cmt_wake0_valid_i),
    .cmt_wake0_robid_i(cmt_wake0_robid_i),
    .cmt_wake0_data_i(cmt_wake0_data_i),
    .cmt_wake1_valid_i(cmt_wake1_valid_i),
    .cmt_wake1_robid_i(cmt_wake1_robid_i),
    .cmt_wake1_data_i(cmt_wake1_data_i),
    .rob_done_i(rob_done_i),
    .rob_result_flat_i(rob_result_flat_i),
    .early0_valid_i(early0_valid_i),
    .early0_robid_i(early0_robid_i),
    .early1_valid_i(early1_valid_i),
    .early1_robid_i(early1_robid_i),
    .early2_valid_i(early2_valid_i),
    .early2_robid_i(early2_robid_i),
    .issue_valid_o(issue_valid_o),
    .issue_robid_o(issue_robid_o),
    .issue_pc_o(issue_pc_o),
    .issue_alu_op_o(issue_alu_op_o),
    .issue_br_op_o(issue_br_op_o),
    .issue_src0_o(issue_src0_o),
    .issue_src1_o(issue_src1_o),
    .issue_imm_o(issue_imm_o),
    .issue_use_imm_o(issue_use_imm_o),
    .issue_br_offs_o(issue_br_offs_o)
  );
  initial clk=0; always #5 clk=~clk;
  initial begin
    reset=1; @(posedge clk); reset=0;

    `TB_PASS("rs_alu tie-off run");
    $display("ALL TESTS DONE"); $finish;
  end
endmodule
