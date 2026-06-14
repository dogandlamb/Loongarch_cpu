`timescale 1ns/1ps
`include "mycpu.h"
`include "tb_macros.vh"

module regfile_tb;
    reg clk;
    reg we0, we1;
    reg [4:0] waddr0, waddr1, dbg_raddr;
    reg [31:0] wdata0, wdata1;
    reg [4:0] raddr0, raddr1, raddr2, raddr3;
    wire [31:0] rdata0, rdata1, rdata2, rdata3, dbg_rdata;

    regfile uut(
        .clk(clk),
        .we0(we0), .waddr0(waddr0), .wdata0(wdata0),
        .we1(we1), .waddr1(waddr1), .wdata1(wdata1),
        .raddr0(raddr0), .rdata0(rdata0),
        .raddr1(raddr1), .rdata1(rdata1),
        .raddr2(raddr2), .rdata2(rdata2),
        .raddr3(raddr3), .rdata3(rdata3),
        .dbg_raddr(dbg_raddr), .dbg_rdata(dbg_rdata)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        we0 = 0; we1 = 0;
        waddr0 = 0; waddr1 = 0;
        wdata0 = 0; wdata1 = 0;
        raddr0 = 0; raddr1 = 0; raddr2 = 0; raddr3 = 0;
        dbg_raddr = 0;
        raddr0 = 5'd0;
        #1;
        `TB_CHECK(rdata0 == 32'b0, "r0 read zero");

        we0 = 1; waddr0 = 5'd3; wdata0 = 32'hdeadbeef;
        repeat(2) @(posedge clk);
        we0 = 0;
        dbg_raddr = 5'd3; #1;
        `TB_CHECK(dbg_rdata == 32'hdeadbeef, "write then dbg read r3");

        we0 = 1; waddr0 = 5'd5; wdata0 = 32'h1;
        we1 = 1; waddr1 = 5'd5; wdata1 = 32'h2;
        repeat(2) @(posedge clk);
        we0 = 0; we1 = 0;
        raddr1 = 5'd5; #1;
        `TB_CHECK(rdata1 == 32'h2, "dual write younger wins");

        $display("ALL TESTS DONE");
        $finish;
    end
endmodule
