`timescale 1ns/1ps
`include "mycpu.h"
`include "tb_macros.vh"
module l2cache_tb;
  reg  clk;
  reg  resetn;
  reg  ic_rd_req;
  reg [2:0] ic_rd_type;
  reg [31:0] ic_rd_addr;
  wire  ic_rd_rdy;
  wire  ic_ret_valid;
  wire  ic_ret_last;
  wire [127:0] ic_ret_data;
  reg  dc_rd_req;
  reg [2:0] dc_rd_type;
  reg [31:0] dc_rd_addr;
  wire  dc_rd_rdy;
  wire  dc_ret_valid;
  wire  dc_ret_last;
  wire [127:0] dc_ret_data;
  reg  dc_wr_req;
  reg [2:0] dc_wr_type;
  reg [31:0] dc_wr_addr;
  reg [15:0] dc_wr_strb;
  reg [127:0] dc_wr_data;
  reg  dc_wr_cacop;
  wire  dc_wr_rdy;
  wire  mem_rd_req;
  wire [2:0] mem_rd_type;
  wire [31:0] mem_rd_addr;
  reg  mem_rd_rdy;
  reg  mem_ret_valid;
  reg  mem_ret_last;
  reg [127:0] mem_ret_data;
  wire  mem_wr_req;
  wire [2:0] mem_wr_type;
  wire [31:0] mem_wr_addr;
  wire [15:0] mem_wr_strb;
  wire [127:0] mem_wr_data;
  reg  mem_wr_rdy;
  l2cache uut(
    .clk(clk),
    .resetn(resetn),
    .ic_rd_req(ic_rd_req),
    .ic_rd_type(ic_rd_type),
    .ic_rd_addr(ic_rd_addr),
    .ic_rd_rdy(ic_rd_rdy),
    .ic_ret_valid(ic_ret_valid),
    .ic_ret_last(ic_ret_last),
    .ic_ret_data(ic_ret_data),
    .dc_rd_req(dc_rd_req),
    .dc_rd_type(dc_rd_type),
    .dc_rd_addr(dc_rd_addr),
    .dc_rd_rdy(dc_rd_rdy),
    .dc_ret_valid(dc_ret_valid),
    .dc_ret_last(dc_ret_last),
    .dc_ret_data(dc_ret_data),
    .dc_wr_req(dc_wr_req),
    .dc_wr_type(dc_wr_type),
    .dc_wr_addr(dc_wr_addr),
    .dc_wr_strb(dc_wr_strb),
    .dc_wr_data(dc_wr_data),
    .dc_wr_cacop(dc_wr_cacop),
    .dc_wr_rdy(dc_wr_rdy),
    .mem_rd_req(mem_rd_req),
    .mem_rd_type(mem_rd_type),
    .mem_rd_addr(mem_rd_addr),
    .mem_rd_rdy(mem_rd_rdy),
    .mem_ret_valid(mem_ret_valid),
    .mem_ret_last(mem_ret_last),
    .mem_ret_data(mem_ret_data),
    .mem_wr_req(mem_wr_req),
    .mem_wr_type(mem_wr_type),
    .mem_wr_addr(mem_wr_addr),
    .mem_wr_strb(mem_wr_strb),
    .mem_wr_data(mem_wr_data),
    .mem_wr_rdy(mem_wr_rdy)
  );
  initial clk=0; always #5 clk=~clk;
  initial begin
    resetn=0; @(posedge clk); resetn=1;

    `TB_PASS("l2cache tie-off run");
    $display("ALL TESTS DONE"); $finish;
  end
endmodule
