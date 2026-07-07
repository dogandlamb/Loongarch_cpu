`timescale 1ns/1ps
`include "mycpu.h"
`include "tb_macros.vh"
module store_buffer_tb;
  reg clk, reset;
  reg push_valid_i, dc_wr_addr_ok_i, dc_wr_done_i;
  reg [31:0] push_paddr_i, push_data_i, query_paddr_i;
  reg [3:0] push_wstrb_i;
  reg [2:0] push_size_i;
  reg push_uncached_i;
  reg query_uncached_i;
  wire sb_full_o, sb_empty_o, dc_wr_req_o, query_hit_o, query_partial_o;
  wire [31:0] dc_wr_paddr_o, dc_wr_data_o, query_data_o;
  wire [3:0] dc_wr_strb_o;
  wire [2:0] dc_wr_size_o;
  wire dc_wr_uncached_o;
  store_buffer uut(
    .clk(clk), .reset(reset),
    .push_valid_i(push_valid_i), .push_paddr_i(push_paddr_i), .push_data_i(push_data_i),
    .push_wstrb_i(push_wstrb_i), .push_size_i(push_size_i), .push_uncached_i(push_uncached_i),
    .sb_full_o(sb_full_o), .sb_empty_o(sb_empty_o),
    .dc_wr_req_o(dc_wr_req_o), .dc_wr_paddr_o(dc_wr_paddr_o), .dc_wr_data_o(dc_wr_data_o),
    .dc_wr_strb_o(dc_wr_strb_o), .dc_wr_size_o(dc_wr_size_o), .dc_wr_uncached_o(dc_wr_uncached_o),
    .dc_wr_addr_ok_i(dc_wr_addr_ok_i), .dc_wr_done_i(dc_wr_done_i),
    .query_paddr_i(query_paddr_i), .query_uncached_i(query_uncached_i),
    .query_hit_o(query_hit_o),
    .query_data_o(query_data_o), .query_partial_o(query_partial_o));
  initial clk=0; always #5 clk=~clk;
  initial begin
    reset=1; push_valid_i=0; dc_wr_addr_ok_i=0; dc_wr_done_i=0;
    push_wstrb_i=4'hf; push_size_i=3'd2; push_uncached_i=0; query_uncached_i=0;
    push_paddr_i=0; push_data_i=0; query_paddr_i=0;
    @(posedge clk); reset=0;
    `TB_CHECK(sb_empty_o, "sb empty after reset");
    push_valid_i=1; push_paddr_i=32'h1000; push_data_i=32'hdeadbeef;
    @(posedge clk); push_valid_i=0;
    `TB_CHECK(!sb_empty_o, "push accepted");
    `TB_CHECK(dc_wr_req_o, "drain req asserted");
    $display("ALL TESTS DONE"); $finish;
  end
endmodule
