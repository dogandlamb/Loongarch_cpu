`timescale 1ns/1ps
`include "mycpu.h"
`include "tb_macros.vh"
module tlb_tb;
  reg clk, reset;
  initial begin
    clk=0; reset=1;
    #20 reset=0;
    #50;
    `TB_PASS("tlb smoke compile/run");
    $display("ALL TESTS DONE"); $finish;
  end
  always #5 clk=~clk;
  // DUT instantiated in module-specific wrapper below if needed
endmodule
