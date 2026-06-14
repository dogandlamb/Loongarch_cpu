`timescale 1ns/1ps
`include "mycpu.h"
`include "tb_macros.vh"
module ras_tb;
  reg clk, reset, flush, spush, spop, cpush, cpop;
  reg [31:0] spush_a, cpush_a;
  wire [31:0] top; wire empty;
  ras uut(.clk(clk), .reset(reset), .flush_i(flush),
    .spec_push_i(spush), .spec_push_addr_i(spush_a), .spec_pop_i(spop),
    .top_addr_o(top), .empty_o(empty),
    .cmt_push_i(cpush), .cmt_push_addr_i(cpush_a), .cmt_pop_i(cpop));
  initial clk=0; always #5 clk=~clk;
  initial begin
    reset=1; flush=0; spush=0; spop=0; cpush=0; cpop=0;
    @(posedge clk); reset=0;
    `TB_CHECK(empty, "ras empty");
    cpush=1; cpush_a=32'h1000; @(posedge clk); cpush=0;
    flush=1; @(posedge clk); flush=0; #1;
    `TB_CHECK(!empty && (top==32'h1000), "flush restore cmt stack");
    spop=1; @(posedge clk); spop=0; #1;
    `TB_CHECK(empty, "spec pop");
    $display("ALL TESTS DONE"); $finish;
  end
endmodule
