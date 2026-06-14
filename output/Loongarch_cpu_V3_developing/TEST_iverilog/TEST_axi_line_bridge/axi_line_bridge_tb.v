`timescale 1ns/1ps
`include "mycpu.h"
`include "tb_macros.vh"
module axi_line_bridge_tb;
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
  wire  dc_wr_rdy;
  wire  axi_awvalid;
  wire [31:0] axi_awaddr;
  wire [2:0] axi_awburst;
  wire [3:0] axi_awlen;
  wire [2:0] axi_awsize;
  reg  axi_awready;
  wire  axi_wvalid;
  wire [31:0] axi_wdata;
  wire [3:0] axi_wstrb;
  wire  axi_wlast;
  reg  axi_wready;
  reg  axi_bvalid;
  reg [1:0] axi_bresp;
  wire  axi_bready;
  wire  axi_arvalid;
  wire [31:0] axi_araddr;
  wire [2:0] axi_arburst;
  wire [3:0] axi_arlen;
  wire [2:0] axi_arsize;
  reg  axi_arready;
  reg  axi_rvalid;
  reg [31:0] axi_rdata;
  reg [1:0] axi_rresp;
  reg  axi_rlast;
  wire  axi_rready;
  axi_line_bridge uut(
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
    .dc_wr_rdy(dc_wr_rdy),
    .axi_awvalid(axi_awvalid),
    .axi_awaddr(axi_awaddr),
    .axi_awburst(axi_awburst),
    .axi_awlen(axi_awlen),
    .axi_awsize(axi_awsize),
    .axi_awready(axi_awready),
    .axi_wvalid(axi_wvalid),
    .axi_wdata(axi_wdata),
    .axi_wstrb(axi_wstrb),
    .axi_wlast(axi_wlast),
    .axi_wready(axi_wready),
    .axi_bvalid(axi_bvalid),
    .axi_bresp(axi_bresp),
    .axi_bready(axi_bready),
    .axi_arvalid(axi_arvalid),
    .axi_araddr(axi_araddr),
    .axi_arburst(axi_arburst),
    .axi_arlen(axi_arlen),
    .axi_arsize(axi_arsize),
    .axi_arready(axi_arready),
    .axi_rvalid(axi_rvalid),
    .axi_rdata(axi_rdata),
    .axi_rresp(axi_rresp),
    .axi_rlast(axi_rlast),
    .axi_rready(axi_rready)
  );
  initial clk=0; always #5 clk=~clk;
  initial begin
    resetn=0; @(posedge clk); resetn=1;

    `TB_PASS("axi_line_bridge tie-off run");
    $display("ALL TESTS DONE"); $finish;
  end
endmodule
