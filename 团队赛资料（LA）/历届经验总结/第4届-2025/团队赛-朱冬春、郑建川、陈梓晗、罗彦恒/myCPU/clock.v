`timescale 1ns / 1ps
`include "defines.vh"
module clock
(
    input wire clk,
    input wire rst,
    output reg [63:0] count_64
);

    always @(posedge clk)
    begin
        if(rst)
        begin
            count_64 <= 0;
        end
        else 
        begin
            count_64 <= count_64 + 1;
        end
    end

endmodule


