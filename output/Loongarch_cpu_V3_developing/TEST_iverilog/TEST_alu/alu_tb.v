`timescale 1ns/1ps
`include "mycpu.h"
`include "tb_macros.vh"

module alu_tb;
    reg clk, reset;
    reg [`ALU_OP_NUM-1:0] alu_op;
    reg [31:0] alu_src1, alu_src2;
    wire [31:0] alu_result;
    wire alu_result_valid;

    alu uut(
        .clk(clk), .reset(reset),
        .alu_op(alu_op), .alu_src1(alu_src1), .alu_src2(alu_src2),
        .exe_pc(32'b0),
        .alu_result(alu_result), .alu_result_valid(alu_result_valid)
    );

    initial begin
        clk = 0; reset = 0;
        alu_src1 = 32'd10; alu_src2 = 32'd32;
        alu_op = {(`ALU_OP_NUM){1'b0}}; alu_op[`ALU_OP_ADD] = 1'b1;
        #1;
        `TB_CHECK(alu_result_valid && (alu_result == 32'd42), "ADD 10+32");

        alu_op = {(`ALU_OP_NUM){1'b0}}; alu_op[`ALU_OP_OR] = 1'b1;
        alu_src1 = 32'hffff0000; alu_src2 = 32'h0000ffff;
        #1;
        `TB_CHECK(alu_result == 32'hffffffff, "OR");

        $display("ALL TESTS DONE");
        $finish;
    end
endmodule
