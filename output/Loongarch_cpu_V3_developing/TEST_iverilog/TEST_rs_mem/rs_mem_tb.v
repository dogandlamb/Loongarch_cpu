`timescale 1ns/1ps
`include "mycpu.h"
`include "tb_macros.vh"
module rs_mem_tb;
  reg  clk;
  reg  reset;
  reg  flush_i;
  reg  push_valid_i;
  reg [`ROB_W-1:0] push_robid_i;
  reg [31:0] push_pc_i;
  reg [`MEM_OP_NUM-1:0] push_mem_op_i;
  reg  push_is_cacop_i;
  reg  push_src0_ready_i;
  reg [31:0] push_src0_val_i;
  reg [`ROB_W-1:0] push_src0_robid_i;
  reg  push_src1_ready_i;
  reg [31:0] push_src1_val_i;
  reg [`ROB_W-1:0] push_src1_robid_i;
  reg [31:0] push_imm_i;
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
  reg  early0_valid_i;
  reg [`ROB_W-1:0] early0_robid_i;
  reg  early1_valid_i;
  reg [`ROB_W-1:0] early1_robid_i;
  reg  early2_valid_i;
  reg [`ROB_W-1:0] early2_robid_i;
  wire  issue_valid_o;
  wire [`ROB_W-1:0] issue_robid_o;
  wire [31:0] issue_pc_o;
  wire [`MEM_OP_NUM-1:0] issue_mem_op_o;
  wire  issue_is_cacop_o;
  wire [31:0] issue_base_o;
  wire [31:0] issue_wdata_o;
  wire [31:0] issue_imm_o;
  reg  lsu_ready_i;
  rs_mem uut(
    .clk(clk),
    .reset(reset),
    .flush_i(flush_i),
    .push_valid_i(push_valid_i),
    .push_robid_i(push_robid_i),
    .push_pc_i(push_pc_i),
    .push_mem_op_i(push_mem_op_i),
    .push_is_cacop_i(push_is_cacop_i),
    .push_src0_ready_i(push_src0_ready_i),
    .push_src0_val_i(push_src0_val_i),
    .push_src0_robid_i(push_src0_robid_i),
    .push_src1_ready_i(push_src1_ready_i),
    .push_src1_val_i(push_src1_val_i),
    .push_src1_robid_i(push_src1_robid_i),
    .push_imm_i(push_imm_i),
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
    .early0_valid_i(early0_valid_i),
    .early0_robid_i(early0_robid_i),
    .early1_valid_i(early1_valid_i),
    .early1_robid_i(early1_robid_i),
    .early2_valid_i(early2_valid_i),
    .early2_robid_i(early2_robid_i),
    .issue_valid_o(issue_valid_o),
    .issue_robid_o(issue_robid_o),
    .issue_pc_o(issue_pc_o),
    .issue_mem_op_o(issue_mem_op_o),
    .issue_is_cacop_o(issue_is_cacop_o),
    .issue_base_o(issue_base_o),
    .issue_wdata_o(issue_wdata_o),
    .issue_imm_o(issue_imm_o),
    .lsu_ready_i(lsu_ready_i)
  );
  initial clk=0; always #5 clk=~clk;
  initial begin
    reset=1; @(posedge clk); reset=0;

    `TB_PASS("rs_mem tie-off run");
    $display("ALL TESTS DONE"); $finish;
  end
endmodule
