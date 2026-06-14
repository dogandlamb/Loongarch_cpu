`timescale 1ns/1ps
`include "mycpu.h"
`include "tb_macros.vh"
module div_tb;
  reg clk, reset, flush, valid, is_signed;
  reg [31:0] dividend, divisor;
  wire [31:0] quot, rem;
  wire done, busy;
  div uut(.clk(clk), .reset(reset), .flush_i(flush), .valid_i(valid),
          .dividend_i(dividend), .divisor_i(divisor), .is_signed_i(is_signed),
          .quotient_o(quot), .remainder_o(rem), .done_o(done), .busy_o(busy));
  initial clk=0; always #5 clk=~clk;
  integer i;
  initial begin
    reset=1; flush=0; valid=0; @(posedge clk); reset=0;
    dividend=32'd20; divisor=32'd4; is_signed=0; valid=1;
    @(posedge clk); valid=0;
    begin : wait_div
      integer k; reg got;
      got=0;
      for (k=0;k<64;k=k+1) begin
        @(posedge clk);
        if (done) got=1;
      end
      `TB_CHECK(got && quot==32'd5 && rem==32'd0, "div 20/4");
    end
    $display("ALL TESTS DONE"); $finish;
  end
endmodule
