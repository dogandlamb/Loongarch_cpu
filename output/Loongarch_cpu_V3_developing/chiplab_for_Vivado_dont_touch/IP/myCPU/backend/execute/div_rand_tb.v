`timescale 1ns/1ps
module div_rand_tb;
  reg clk, reset, flush, valid, is_signed;
  reg [31:0] dividend, divisor;
  wire [31:0] quot, rem;
  wire done, busy;
  integer errors, n;

  div uut(.clk(clk), .reset(reset), .flush_i(flush), .valid_i(valid),
          .dividend_i(dividend), .divisor_i(divisor), .is_signed_i(is_signed),
          .quotient_o(quot), .remainder_o(rem), .done_o(done), .busy_o(busy));

  initial clk = 0;
  always #5 clk = ~clk;

  task check;
    input [31:0] a, b;
    input        sgn;
    reg [31:0] eq, er, gq, gr;
    integer k;
    begin
      // reference
      if (b == 32'b0) begin
        eq = 32'hffffffff; er = a;
      end else if (sgn && a == 32'h80000000 && b == 32'hffffffff) begin
        eq = 32'h80000000; er = 32'h0;
      end else if (sgn) begin
        eq = $signed(a) / $signed(b);
        er = $signed(a) % $signed(b);
      end else begin
        eq = a / b;
        er = a % b;
      end
      @(negedge clk);
      dividend = a; divisor = b; is_signed = sgn; valid = 1;
      @(negedge clk);
      valid = 0;
      gq = 32'hx; gr = 32'hx;
      if (done) begin gq = quot; gr = rem; end
      for (k = 0; k < 80; k = k + 1) begin
        @(negedge clk);
        if (done) begin gq = quot; gr = rem; end
      end
      if (gq !== eq || gr !== er) begin
        errors = errors + 1;
        if (errors < 30)
          $display("FAIL sgn=%0d a=%h b=%h  q=%h(exp %h) r=%h(exp %h)", sgn, a, b, gq, eq, gr, er);
      end
    end
  endtask

  initial begin
    reset = 1; flush = 0; valid = 0; errors = 0;
    @(negedge clk); @(negedge clk); reset = 0;
    for (n = 0; n < 4000; n = n + 1) begin
      check($random, $random, n[0]);
    end
    // edge cases
    check(32'h80000000, 32'hffffffff, 1);
    check(32'd7, 32'd0, 1);
    check(32'd7, 32'd0, 0);
    check(32'd0, 32'd5, 1);
    check(32'd5, 32'd5, 0);
    check(32'hffffffff, 32'h1, 1);
    if (errors == 0) $display("ALL PASS: div random (%0d cases)", n);
    else $display("TOTAL FAIL: %0d", errors);
    $finish;
  end
endmodule
