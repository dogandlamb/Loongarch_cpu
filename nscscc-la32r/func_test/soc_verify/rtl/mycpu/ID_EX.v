`timescale 1ns / 1ps

`include "defines.vh"

module ID_EX (
    input  wire         cpu_clk,
    input  wire         cpu_rstn,
    input  wire         suspend,
    input  wire         valid_in,

    input  wire [ 4:0]  wR_in,
    input  wire [31:0]  pc_in,
    input  wire [31:0]  rD1_in,
    input  wire [31:0]  rD2_in,
    input  wire [31:0]  ext_in,

    input  wire [ 1:0]  npc_op_in,
    input  wire         rf_we_in,
    input  wire [ 1:0]  wd_sel_in,
    input  wire [ 4:0]  alu_op_in,
    input  wire         alua_sel_in,
    input  wire         alub_sel_in,
    input  wire [ 3:0]  ram_we_in,
    input  wire [ 2:0]  ram_ext_op_in,
    input  wire         is_br_jmp_in,

    output reg          valid_out,
    output reg  [ 4:0]  wR_out,
    output reg  [31:0]  pc_out,
    output reg  [31:0]  rD1_out,
    output reg  [31:0]  rD2_out,
    output reg  [31:0]  ext_out,

    output reg  [ 1:0]  npc_op_out,
    output reg          rf_we_out,
    output reg  [ 1:0]  wd_sel_out,
    output reg  [ 4:0]  alu_op_out,
    output reg          alua_sel_out,
    output reg          alub_sel_out,
    output reg  [ 3:0]  ram_we_out,
    output reg  [ 2:0]  ram_ext_op_out,
    output reg          is_br_jmp_out
);

    always @(posedge cpu_clk) begin
        valid_out      <= !cpu_rstn ?  1'h0 : suspend ? valid_out      : valid_in;
        wR_out         <= !cpu_rstn ?  5'h0 : suspend ? wR_out         : wR_in;
        pc_out         <= !cpu_rstn ? 32'h0 : suspend ? pc_out         : pc_in;
        rD1_out        <= !cpu_rstn ? 32'h0 : suspend ? rD1_out        : rD1_in;
        rD2_out        <= !cpu_rstn ? 32'h0 : suspend ? rD2_out        : rD2_in;
        ext_out        <= !cpu_rstn ? 32'h0 : suspend ? ext_out        : ext_in;
        npc_op_out     <= !cpu_rstn ?  2'h0 : suspend ? npc_op_out     : npc_op_in;
        rf_we_out      <= !cpu_rstn ?  1'h0 : suspend ? rf_we_out      : rf_we_in;
        wd_sel_out     <= !cpu_rstn ?  2'h0 : suspend ? wd_sel_out     : wd_sel_in;
        alu_op_out     <= !cpu_rstn ?  4'h0 : suspend ? alu_op_out     : alu_op_in;
        alua_sel_out   <= !cpu_rstn ?  1'h0 : suspend ? alua_sel_out   : alua_sel_in;
        alub_sel_out   <= !cpu_rstn ?  1'h0 : suspend ? alub_sel_out   : alub_sel_in;
        ram_we_out     <= !cpu_rstn ?  4'h0 : suspend ? ram_we_out     : ram_we_in;
        ram_ext_op_out <= !cpu_rstn ?  3'h0 : suspend ? ram_ext_op_out : ram_ext_op_in;
        is_br_jmp_out  <= !cpu_rstn ?  1'h0 : suspend ? is_br_jmp_out  : is_br_jmp_in;
    end

endmodule
