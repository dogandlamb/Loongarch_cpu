`timescale 1ns/1ps
`include "mycpu.h"
`include "tb_macros.vh"
module ftb_tb;
  reg  clk;
  reg  reset;
  reg  query_valid_i;
  reg [31:0] query_pc_i;
  wire  hit_o;
  wire [31:0] jump_target_o;
  wire [31:0] fall_through_o;
  wire [`BR_TYPE_W-1:0] br_type_o;
  reg  update_valid_i;
  reg [31:0] update_block_pc_i;
  reg [31:0] update_jump_target_i;
  reg [31:0] update_fall_through_i;
  reg [`BR_TYPE_W-1:0] update_br_type_i;
  reg  update_alloc_i;
  ftb uut(
    .clk(clk),
    .reset(reset),
    .query_valid_i(query_valid_i),
    .query_pc_i(query_pc_i),
    .hit_o(hit_o),
    .jump_target_o(jump_target_o),
    .fall_through_o(fall_through_o),
    .br_type_o(br_type_o),
    .update_valid_i(update_valid_i),
    .update_block_pc_i(update_block_pc_i),
    .update_jump_target_i(update_jump_target_i),
    .update_fall_through_i(update_fall_through_i),
    .update_br_type_i(update_br_type_i),
    .update_alloc_i(update_alloc_i)
  );
  initial clk=0; always #5 clk=~clk;
  initial begin
    reset=1; @(posedge clk); reset=0;

    query_valid_i=1; query_pc_i=32'h1000;
    repeat(3) @(posedge clk);
    query_valid_i=0;
    `TB_PASS("ftb query latency");

    `TB_PASS("ftb tie-off run");
    $display("ALL TESTS DONE"); $finish;
  end
endmodule
