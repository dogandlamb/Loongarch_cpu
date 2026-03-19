`timescale 1ns / 1ps

`include "defines.vh"

module RAM_EXT (
    input  wire [ 2:0]  ram_ext_op ,
    input  wire [ 1:0]  byte_offset,
    input  wire [31:0]  din        ,
    output reg  [31:0]  ext_out    
);

    reg [31:0] real_din;
    always @(*) begin
        case (byte_offset)
            2'b01  : real_din = { 8'h0, din[31: 8]};
            2'b10  : real_din = {16'h0, din[31:16]};
            2'b11  : real_din = {24'h0, din[31:24]};
            default: real_din = din;
        endcase
    end

    always @(*) begin
        case (ram_ext_op)
            `RAM_EXT_H : ext_out = {{16{real_din[15]}}, real_din[15:0]};
            default    : ext_out = real_din;
        endcase
    end

endmodule
