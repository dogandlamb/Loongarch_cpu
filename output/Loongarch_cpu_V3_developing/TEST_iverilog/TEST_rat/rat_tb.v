`timescale 1ns/1ps
`include "mycpu.h"
`include "tb_macros.vh"

module rat_tb;
    reg clk, reset, flush;
    reg wen0, wen1, cmt0, cmt1;
    reg [4:0] waddr0, waddr1, caddr0, caddr1;
    reg [`ROB_W-1:0] wnum0, wnum1, cnum0, cnum1;
    reg [4:0] raddr0, raddr1, raddr2, raddr3;
    wire busy0, busy1, busy2, busy3;
    wire [`ROB_W-1:0] rnum0, rnum1, rnum2, rnum3;

    rat uut(
        .clk(clk), .reset(reset), .flush_i(flush),
        .raddr0_i(raddr0), .rbusy0_o(busy0), .rnum0_o(rnum0),
        .raddr1_i(raddr1), .rbusy1_o(busy1), .rnum1_o(rnum1),
        .raddr2_i(raddr2), .rbusy2_o(busy2), .rnum2_o(rnum2),
        .raddr3_i(raddr3), .rbusy3_o(busy3), .rnum3_o(rnum3),
        .wen0_i(wen0), .waddr0_i(waddr0), .wnum0_i(wnum0),
        .wen1_i(wen1), .waddr1_i(waddr1), .wnum1_i(wnum1),
        .cmt_en0_i(cmt0), .cmt_addr0_i(caddr0), .cmt_num0_i(cnum0),
        .cmt_en1_i(cmt1), .cmt_addr1_i(caddr1), .cmt_num1_i(cnum1)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        reset = 1; flush = 0; wen0 = 0; wen1 = 0; cmt0 = 0; cmt1 = 0;
        @(posedge clk); reset = 0;
        raddr0 = 5'd1; raddr1 = 5'd2; raddr2 = 5'd0; raddr3 = 5'd3;
        #1;
        `TB_CHECK(!busy2, "r0 never busy");

        wen0 = 1; waddr0 = 5'd1; wnum0 = 5'd7;
        @(posedge clk); wen0 = 0;
        raddr0 = 5'd1; #1;
        `TB_CHECK(busy0 && (rnum0 == 5'd7), "write port0 rename r1->rob7");

        cmt0 = 1; caddr0 = 5'd1; cnum0 = 5'd7;
        @(posedge clk); cmt0 = 0;
        raddr0 = 5'd1; #1;
        `TB_CHECK(!busy0, "commit release r1");

        wen0 = 1; waddr0 = 5'd1; wnum0 = 5'd9;
        wen1 = 1; waddr1 = 5'd1; wnum1 = 5'd10;
        @(posedge clk); wen0 = 0; wen1 = 0;
        raddr0 = 5'd1; #1;
        `TB_CHECK(busy0 && (rnum0 == 5'd10), "we1 younger wins same addr");

        $display("ALL TESTS DONE");
        $finish;
    end
endmodule
