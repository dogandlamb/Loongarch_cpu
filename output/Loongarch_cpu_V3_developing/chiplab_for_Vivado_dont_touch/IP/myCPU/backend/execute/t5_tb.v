`timescale 1ns/1ps
module t5_tb;
  reg clk, rst, v;
  reg [31:0] a, b;
  wire [31:0] q, r;
  wire done, busy;
  div u(.clk(clk), .reset(rst), .flush_i(0), .valid_i(v),
        .dividend_i(a), .divisor_i(b), .is_signed_i(1),
        .quotient_o(q), .remainder_o(r), .done_o(done), .busy_o(busy));
  initial clk = 0;
  always #5 clk = ~clk;
  integer k;
  initial begin
    rst = 1; v = 0;
    repeat (2) @(negedge clk);
    rst = 0;
    a = 32'hc3e0f060;
    b = 32'he9c97944;
    v = 1;
    @(negedge clk);
    v = 0;
    for (k = 0; k < 50; k = k + 1) begin
      @(negedge clk);
      if (done) begin
        $display("q=%h r=%h", q, r);
        if (r === 32'hf04dfdd8) $display("PASS");
        else $display("FAIL");
        $finish;
      end
    end
    $display("TIMEOUT busy=%b", busy);
    $finish;
  end
endmodule
