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
  integer i;
  initial begin
    reset=1; valid=0; @(posedge clk); reset=0;
    a=32'd6; b=32'd7; is_signed=1; valid=1; @(posedge clk); valid=0;
    begin : wait_done
      integer k; reg got;
      got=0;
      for (k=0;k<10;k=k+1) begin
        @(posedge clk);
        if (done) got=1;
      end
      `TB_CHECK(got && (result[31:0]==32'd42), "mul 6*7");
    end
    $display("ALL TESTS DONE"); $finish;
  end
endmodule
