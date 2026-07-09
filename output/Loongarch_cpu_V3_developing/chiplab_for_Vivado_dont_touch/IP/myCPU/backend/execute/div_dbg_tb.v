`timescale 1ns/1ps
module div_dbg_tb;
  reg clk, reset, flush, valid, is_signed;
  reg [31:0] dividend, divisor;
  wire [31:0] quot, rem;
  wire done, busy;
  integer k;

  div uut(.clk(clk), .reset(reset), .flush_i(flush), .valid_i(valid),
          .dividend_i(dividend), .divisor_i(divisor), .is_signed_i(is_signed),
          .quotient_o(quot), .remainder_o(rem), .done_o(done), .busy_o(busy));

  initial clk = 0;
  always #5 clk = ~clk;

  initial begin
    reset = 1; flush = 0; valid = 0;
    @(negedge clk); @(negedge clk); reset = 0;
    // early-exit case: dividend_abs < divisor_abs (signed)
    @(negedge clk);
    dividend = 32'hfda5ea8a; divisor = 32'hfac1873c; is_signed = 1; valid = 1;
    @(negedge clk);
    valid = 0;
    for (k = 0; k < 20; k = k + 1) begin
      @(negedge clk);
      $display("k=%0d done=%b busy=%b rem=%h quot=%h", k, done, busy, rem, quot);
    end
    $finish;
  end
endmodule
