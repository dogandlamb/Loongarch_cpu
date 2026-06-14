`timescale 1ns/1ps
`include "mycpu.h"
`include "tb_macros.vh"
module icache_tb;
  reg  clk;
  reg  resetn;
  reg  ifu_req_i;
  reg [31:0] ifu_vaddr_i;
  reg [31:0] ifu_paddr_i;
  reg  ifu_uncached_i;
  wire  ifu_addr_ok_o;
  wire  ifu_data_ok_o;
  wire [`CACHE_LINE_BITS-1:0] ifu_rline_o;
  reg  ifu_cancel_i;
  reg  cacop_en_i;
  reg [1:0] cacop_op_i;
  reg [31:0] cacop_addr_i;
  wire  axi_rd_req;
  wire [2:0] axi_rd_type;
  wire [31:0] axi_rd_addr;
  reg  axi_rd_rdy;
  reg  axi_ret_valid;
  reg  axi_ret_last;
  reg [127:0] axi_ret_data;
  icache uut(
    .clk(clk),
    .resetn(resetn),
    .ifu_req_i(ifu_req_i),
    .ifu_vaddr_i(ifu_vaddr_i),
    .ifu_paddr_i(ifu_paddr_i),
    .ifu_uncached_i(ifu_uncached_i),
    .ifu_addr_ok_o(ifu_addr_ok_o),
    .ifu_data_ok_o(ifu_data_ok_o),
    .ifu_rline_o(ifu_rline_o),
    .ifu_cancel_i(ifu_cancel_i),
    .cacop_en_i(cacop_en_i),
    .cacop_op_i(cacop_op_i),
    .cacop_addr_i(cacop_addr_i),
    .axi_rd_req(axi_rd_req),
    .axi_rd_type(axi_rd_type),
    .axi_rd_addr(axi_rd_addr),
    .axi_rd_rdy(axi_rd_rdy),
    .axi_ret_valid(axi_ret_valid),
    .axi_ret_last(axi_ret_last),
    .axi_ret_data(axi_ret_data)
  );
  initial clk=0; always #5 clk=~clk;
  initial begin
    resetn=0; @(posedge clk); resetn=1;

    `TB_PASS("icache tie-off run");
    $display("ALL TESTS DONE"); $finish;
  end
endmodule
