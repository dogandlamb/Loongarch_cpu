`timescale 1ns / 1ps

`include "defines.vh"

module MEM_WB (
    input  wire         cpu_clk,
    input  wire         cpu_rstn,
    input  wire         suspend,
    input  wire         valid_in,

    input  wire [ 4:0]  wR_in,
    input  wire [31:0]  pc_in,
    input  wire [31:0]  alu_C_in,
    input  wire [31:0]  ram_ext_in,
    input  wire [31:0]  ext_in,

    input  wire         rf_we_in,
    input  wire [ 1:0]  wd_sel_in,

    output reg          valid_out,
    output reg  [ 4:0]  wR_out,
    output reg  [31:0]  pc_out,
    output reg  [31:0]  alu_C_out,
    output reg  [31:0]  ram_ext_out,
    output reg  [31:0]  ext_out,

    output reg          rf_we_out,
    output reg  [ 1:0]  wd_sel_out
);

    always @(posedge cpu_clk) begin
        valid_out   <= !cpu_rstn ?  1'h0 : suspend ? 1'b0        : valid_in  ;
        wR_out      <= !cpu_rstn ?  5'h0 : suspend ? wR_out      : wR_in     ;
        pc_out      <= !cpu_rstn ? 32'h0 : suspend ? pc_out      : pc_in     ;
        alu_C_out   <= !cpu_rstn ? 32'h0 : suspend ? alu_C_out   : alu_C_in  ;
        ram_ext_out <= !cpu_rstn ? 32'h0 : suspend ? ram_ext_out : ram_ext_in;
        ext_out     <= !cpu_rstn ? 32'h0 : suspend ? ext_out     : ext_in    ;
        rf_we_out   <= !cpu_rstn ?  1'h0 : suspend ? 1'b0        : rf_we_in  ;
        wd_sel_out  <= !cpu_rstn ?  2'h0 : suspend ? wd_sel_out  : wd_sel_in ;
    end

endmodule
