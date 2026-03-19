`timescale 1ns / 1ps

`include "defines.vh"

module ALU (
    input  wire [ 4:0]  alu_op,
    input  wire [31:0]  A     ,
    input  wire [31:0]  B     ,
    output reg  [31:0]  C     ,
    output reg          f     
);

    always @(*) begin
        case (alu_op)
            `ALU_ADD : C = A + B;
            default  : C = 32'h87654321;
        endcase
    end

    always @(*) begin
        case (alu_op)
            default  : f = 1'b0;
        endcase
    end

endmodule
