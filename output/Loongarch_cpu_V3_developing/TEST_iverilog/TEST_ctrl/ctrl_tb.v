`timescale 1ns/1ps
`include "mycpu.h"
`include "tb_macros.vh"
module ctrl_tb;
  reg clk, reset, cmt_flush, idle_cmt, has_int, ex_redir;
  reg [31:0] cmt_pc, ex_pc;
  reg [`FLUSH_TYPE_W-1:0] cmt_type;
  wire flush; wire [31:0] flush_pc; wire fetch_stall;
  ctrl uut(.clk(clk), .reset(reset), .cmt_flush_req_i(cmt_flush),
    .cmt_flush_type_i(cmt_type), .cmt_flush_pc_i(cmt_pc),
    .ex_redirect_req_i(ex_redir), .ex_redirect_pc_i(ex_pc),
    .idle_commit_i(idle_cmt), .has_int_i(has_int),
    .flush_o(flush), .flush_pc_o(flush_pc), .fetch_stall_o(fetch_stall));
  initial clk=0; always #5 clk=~clk;
  initial begin
    reset=1; cmt_flush=0; idle_cmt=0; has_int=0; ex_redir=0;
    cmt_pc=32'h80001000; cmt_type=0; ex_pc=0;
    @(posedge clk); reset=0;
    cmt_flush=1; #1;
    `TB_CHECK(flush && (flush_pc==32'h80001000), "flush passthrough");
    @(posedge clk); cmt_flush=0;
    idle_cmt=1; @(posedge clk);
    `TB_CHECK(fetch_stall, "idle lock");
    idle_cmt=0; has_int=1; @(posedge clk);
    idle_cmt=0; has_int=1; @(posedge clk); #1;
    `TB_CHECK(!fetch_stall, "int unlock");
    $display("ALL TESTS DONE"); $finish;
  end
endmodule
