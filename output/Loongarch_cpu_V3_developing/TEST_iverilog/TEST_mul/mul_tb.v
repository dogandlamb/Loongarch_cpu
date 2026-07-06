`timescale 1ns/1ps
`include "mycpu.h"
`include "tb_macros.vh"
module mul_tb;
  reg clk, reset, valid, is_signed;
  reg [31:0] a, b;
  wire [63:0] result;
  wire done;
  mul uut(.clk(clk), .reset(reset), .valid_i(valid), .a_i(a), .b_i(b),
          .is_signed_i(is_signed), .result_o(result), .done_o(done));
  initial clk=0; always #5 clk=~clk;

  task run_case;
    input [31:0] ta;
    input [31:0] tb;
    input        signed_mode;
    input [63:0] expected;
    input [255:0] msg;
    begin
      @(negedge clk);
      a = ta;
      b = tb;
      is_signed = signed_mode;
      valid = 1'b1;

      @(negedge clk);
      valid = 1'b0;
      a = 32'b0;
      b = 32'b0;
      is_signed = 1'b0;

      @(posedge clk); #1;
      `TB_CHECK(!done, "mul done not early");

      @(posedge clk); #1;
      `TB_CHECK(done && result == expected, msg);

      @(posedge clk); #1;
      `TB_CHECK(!done, "mul done one-cycle pulse");
    end
  endtask

  initial begin
    reset=1; valid=0; a=0; b=0; is_signed=0;
    @(posedge clk);
    @(posedge clk);
    reset=0;

    run_case(32'd6,        32'd7,        1'b1, 64'd42,                "mul signed 6*7");
    run_case(32'hffffffff, 32'd2,        1'b1, 64'hfffffffffffffffe,  "mul signed -1*2");
    run_case(32'h80000000, 32'd2,        1'b1, 64'hffffffff00000000,  "mul signed min*2");
    run_case(32'hffffffff, 32'hffffffff, 1'b0, 64'hfffffffe00000001,  "mul unsigned max*max");
    run_case(32'hffffffff, 32'd2,        1'b0, 64'h00000001fffffffe,  "mul unsigned max*2");

    $display("ALL TESTS DONE"); $finish;
  end
endmodule
