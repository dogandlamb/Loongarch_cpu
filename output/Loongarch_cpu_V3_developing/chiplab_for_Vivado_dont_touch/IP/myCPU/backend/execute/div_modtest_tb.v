`timescale 1ns/1ps
module div_modtest_tb;
  reg clk, reset, flush, valid, is_signed;
  reg [31:0] dividend, divisor;
  wire [31:0] quot, rem;
  wire done, busy;
  integer errors;

  div uut(.clk(clk), .reset(reset), .flush_i(flush), .valid_i(valid),
          .dividend_i(dividend), .divisor_i(divisor), .is_signed_i(is_signed),
          .quotient_o(quot), .remainder_o(rem), .done_o(done), .busy_o(busy));

  initial clk = 0;
  always #5 clk = ~clk;

  // reference model
  function [31:0] ref_mod;
    input [31:0] a, b;
    input        sgn;
    integer sa, sb, sr;
    reg [31:0] ua, ub, ur;
    begin
      if (b == 32'b0) begin
        ref_mod = a; // mod by zero -> dividend
      end else if (sgn) begin
        sa = $signed(a); sb = $signed(b);
        sr = sa % sb;   // Verilog % has sign of dividend, matches LoongArch
        ref_mod = sr;
      end else begin
        ua = a; ub = b;
        ur = ua % ub;
        ref_mod = ur;
      end
    end
  endfunction

  task run_mod;
    input [31:0] a, b, expect;
    input        sgn;
    reg [31:0] got;
    integer k;
    begin
      @(negedge clk);
      dividend = a; divisor = b; is_signed = sgn; valid = 1;
      @(negedge clk);
      valid = 0;
      got = 32'hx;
      if (done) got = rem;
      for (k = 0; k < 80; k = k + 1) begin
        @(negedge clk);
        if (done) got = rem;
      end
      if (got !== expect) begin
        errors = errors + 1;
        $display("FAIL: mod%s(%h, %h) = %h  expect %h", sgn?"w ":"wu", a, b, got, expect);
      end
    end
  endtask

  initial begin
    reset = 1; flush = 0; valid = 0; errors = 0;
    @(negedge clk); @(negedge clk); reset = 0;

    // ---- signed mod.w vectors (from n35_mod_w.S) ----
    run_mod(32'h56bedfa4, 32'h20831400, 32'h15b8b7a4, 1);
    run_mod(32'hfda5ea8a, 32'hfac1873c, 32'hfda5ea8a, 1);
    run_mod(32'h53eb4a70, 32'h07e13dd1, 32'h051ee046, 1);
    run_mod(32'h323676e0, 32'hdc3a3f10, 32'h0e70b5f0, 1);
    run_mod(32'hc3e0f060, 32'he9c97944, 32'hf04dfdd8, 1);
    run_mod(32'h7c7b85f2, 32'hdb7e6dc0, 32'h0ef6cf32, 1);
    run_mod(32'h8786a50c, 32'h412dc050, 32'hc8b4655c, 1);
    run_mod(32'h9471ab8a, 32'hc428d407, 32'hd048d783, 1);
    run_mod(32'ha0792145, 32'hd9316a68, 32'hee164c75, 1);
    run_mod(32'h00000000, 32'ha7bb1ef0, 32'h00000000, 1);

    // ---- unsigned mod.wu vectors (from n36_mod_wu.S) ----
    run_mod(32'h72013c68, 32'h48cb8680, 32'h2935b5e8, 0);
    run_mod(32'hd7042938, 32'h018a7078, 32'h00d91810, 0);
    run_mod(32'hbf81441b, 32'h704e3f24, 32'h4f3304f7, 0);
    run_mod(32'heb5994e6, 32'h622f1558, 32'h26fb6a36, 0);
    run_mod(32'hfcb1d1f0, 32'h2cc89437, 32'h1cc6ecdd, 0);
    run_mod(32'he3e9c400, 32'h5e37e5e0, 32'h2779f840, 0);
    run_mod(32'hb0e35480, 32'h8947ed80, 32'h279b6700, 0);
    run_mod(32'h9a86f9a7, 32'h62ff4728, 32'h3787b27f, 0);
    run_mod(32'h00000000, 32'hbea685ab, 32'h00000000, 0);
    run_mod(32'h9988ceac, 32'hf076e887, 32'h9988ceac, 0);

    if (errors == 0)
      $display("ALL PASS: div mod test");
    else
      $display("TOTAL FAIL: %0d", errors);
    $finish;
  end
endmodule
