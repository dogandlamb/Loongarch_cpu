`timescale 1ns / 1ps

`include "defines.vh"

module RF (
    input  wire         cpu_clk,
    input  wire [ 4:0]  rR1    ,
    input  wire [ 4:0]  rR2    ,
    input  wire         we     ,
    input  wire [ 4:0]  wR     ,
    input  wire [31:0]  wD     ,
    output wire [31:0]  rD1    ,
    output wire [31:0]  rD2    
);

    reg [31:0] r [1:31];

    always @(posedge cpu_clk) begin
        if (we & (wR != 5'h0)) r[wR] <= wD;
    end

    assign rD1 = (rR1 == 5'h0) ? 32'h0 : r[rR1];
    assign rD2 = (rR2 == 5'h0) ? 32'h0 : r[rR2];

endmodule
