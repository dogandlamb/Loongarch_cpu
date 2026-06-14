`timescale 1ns/1ps
`include "mycpu.h"
`include "tb_macros.vh"
module tage_tb;
  reg  clk;
  reg  reset;
  reg  query_valid_i;
  reg [31:0] query_pc_i;
  wire  taken_o;
  wire [`BPU_META_W-1:0] meta_o;
  reg  train_valid_i;
  reg [31:0] train_pc_i;
  reg  train_taken_i;
  reg  train_mispred_i;
  reg [`BPU_META_W-1:0] train_meta_i;
  tage uut(
    .clk(clk),
    .reset(reset),
    .query_valid_i(query_valid_i),
    .query_pc_i(query_pc_i),
    .taken_o(taken_o),
    .meta_o(meta_o),
    .train_valid_i(train_valid_i),
    .train_pc_i(train_pc_i),
    .train_taken_i(train_taken_i),
    .train_mispred_i(train_mispred_i),
    .train_meta_i(train_meta_i)
  );
  initial clk=0; always #5 clk=~clk;
  initial begin
    reset=1; @(posedge clk); reset=0;

    query_valid_i=1; query_pc_i=32'h1000;
    repeat(3) @(posedge clk);
    `TB_PASS("tage query run");

    `TB_PASS("tage tie-off run");
    $display("ALL TESTS DONE"); $finish;
  end
endmodule
