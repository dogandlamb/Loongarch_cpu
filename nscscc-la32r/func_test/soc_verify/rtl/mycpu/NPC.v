`timescale 1ns / 1ps

`include "defines.vh"

module NPC (
    input  wire         cpu_clk ,
    input  wire         cpu_rstn,
    input  wire         id_valid,
    input  wire         ex_valid,
    input  wire [ 1:0]  npc_op  ,
    input  wire [31:0]  ex_pc   ,
    input  wire [31:0]  rj      ,
    input  wire [31:0]  offset  ,
    input  wire         br      ,
    output reg  [31:0]  npc     
);

    wire [31:0] pc4 = ex_pc + 32'h4;

    always @(*) begin
        case (npc_op)
            `NPC_PC4 : npc = pc4;
            default  : npc = pc4;
        endcase
    end

endmodule
