`timescale 1ns / 1ps

`include "defines.vh"

module PC (
    input  wire         cpu_rstn,
    input  wire         cpu_clk ,
    input  wire         suspend ,

    input  wire         if_valid,
    input  wire [31:0]  din     ,
    output reg  [31:0]  pc      
);

	always @(posedge cpu_clk or negedge cpu_rstn) begin
		if (!cpu_rstn    ) pc <= `PC_INIT_VAL;
		else if (suspend ) pc <= pc;
		else if (if_valid) pc <= din;
	end

endmodule
