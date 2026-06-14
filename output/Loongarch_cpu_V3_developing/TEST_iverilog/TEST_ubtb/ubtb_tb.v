`timescale 1ns/1ps
`include "mycpu.h"
`include "tb_macros.vh"
module ubtb_tb;
  reg clk, reset, uvalid, utaken;
  reg [31:0] qpc, upc, utarget;
  reg [`BLK_LEN_W-1:0] ulen;
  reg [`BR_TYPE_W-1:0] ubtype;
  wire hit, taken; wire [31:0] target; wire [`BLK_LEN_W-1:0] len; wire [`BR_TYPE_W-1:0] btype;
  ubtb uut(.clk(clk), .reset(reset), .query_pc_i(qpc),
    .hit_o(hit), .taken_o(taken), .target_o(target), .length_o(len), .br_type_o(btype),
    .update_valid_i(uvalid), .update_block_pc_i(upc), .update_taken_i(utaken),
    .update_target_i(utarget), .update_length_i(ulen), .update_br_type_i(ubtype));
  initial clk=0; always #5 clk=~clk;
  initial begin
    reset=1; uvalid=0; qpc=32'h1000;
    @(posedge clk); reset=0;
    `TB_CHECK(!hit, "miss initially");
    uvalid=1; upc=32'h1000; utaken=1; utarget=32'h0ff0; ulen=3'd2; ubtype=`BR_TYPE_UNCOND;
    @(posedge clk); uvalid=0;
    qpc=32'h1000; #1;
    `TB_CHECK(hit && taken && (target==32'h0ff0), "backward branch fill");
    $display("ALL TESTS DONE"); $finish;
  end
endmodule
