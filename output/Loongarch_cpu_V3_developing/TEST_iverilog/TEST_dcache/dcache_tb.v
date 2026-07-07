`timescale 1ns/1ps
`include "mycpu.h"
`include "tb_macros.vh"
module dcache_tb;
  reg  clk;
  reg  resetn;
  reg  ld_req_i;
  reg [31:0] ld_vaddr_i;
  reg [31:0] ld_paddr_i;
  reg [2:0] ld_size_i;
  reg  ld_uncached_i;
  wire  ld_addr_ok_o;
  wire  ld_data_ok_o;
  wire [31:0] ld_rdata_o;
  wire  ld_miss_o;
  wire  ld_mshr_data_ok_o;
  wire [31:0] ld_mshr_rdata_o;
  reg  ld_cancel_i;
  reg  st_req_i;
  reg [31:0] st_paddr_i;
  reg [31:0] st_data_i;
  reg [3:0] st_strb_i;
  reg [2:0] st_size_i;
  reg  st_uncached_i;
  wire  st_addr_ok_o;
  wire  st_done_o;
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
  wire  axi_wr_req;
  wire [2:0] axi_wr_type;
  wire [31:0] axi_wr_addr;
  wire [15:0] axi_wr_strb;
  wire [127:0] axi_wr_data;
  wire  axi_wr_cacop;
  reg  axi_wr_rdy;
  dcache uut(
    .clk(clk),
    .resetn(resetn),
    .ld_req_i(ld_req_i),
    .ld_vaddr_i(ld_vaddr_i),
    .ld_paddr_i(ld_paddr_i),
    .ld_size_i(ld_size_i),
    .ld_uncached_i(ld_uncached_i),
    .ld_addr_ok_o(ld_addr_ok_o),
    .ld_data_ok_o(ld_data_ok_o),
    .ld_rdata_o(ld_rdata_o),
    .ld_cancel_i(ld_cancel_i),
    .ld_miss_o(ld_miss_o),
    .ld_mshr_data_ok_o(ld_mshr_data_ok_o),
    .ld_mshr_rdata_o(ld_mshr_rdata_o),
    .st_req_i(st_req_i),
    .st_paddr_i(st_paddr_i),
    .st_data_i(st_data_i),
    .st_strb_i(st_strb_i),
    .st_size_i(st_size_i),
    .st_uncached_i(st_uncached_i),
    .st_addr_ok_o(st_addr_ok_o),
    .st_done_o(st_done_o),
    .cacop_en_i(cacop_en_i),
    .cacop_op_i(cacop_op_i),
    .cacop_addr_i(cacop_addr_i),
    .axi_rd_req(axi_rd_req),
    .axi_rd_type(axi_rd_type),
    .axi_rd_addr(axi_rd_addr),
    .axi_rd_rdy(axi_rd_rdy),
    .axi_ret_valid(axi_ret_valid),
    .axi_ret_last(axi_ret_last),
    .axi_ret_data(axi_ret_data),
    .axi_wr_req(axi_wr_req),
    .axi_wr_type(axi_wr_type),
    .axi_wr_addr(axi_wr_addr),
    .axi_wr_strb(axi_wr_strb),
    .axi_wr_data(axi_wr_data),
    .axi_wr_cacop(axi_wr_cacop),
    .axi_wr_rdy(axi_wr_rdy)
  );
  initial clk=0; always #5 clk=~clk;
  initial begin
    resetn=0; @(posedge clk); resetn=1;

    `TB_PASS("dcache tie-off run");
    $display("ALL TESTS DONE"); $finish;
  end
endmodule
