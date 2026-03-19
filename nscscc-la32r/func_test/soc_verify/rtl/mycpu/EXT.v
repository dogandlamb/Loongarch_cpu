`timescale 1ns / 1ps

`include "defines.vh"

module EXT (
    input  wire [ 2:0]  ext_op,
    input  wire [25:0]  din   ,
    output reg  [31:0]  ext   
);

    always @(*) begin
        case (ext_op)
            `EXT_12 : ext = (din[21] ? {20'hfffff,din[21:10]} : {20'h00000,din[21:10]});
            `EXT_20 : ext = {din[24:5],12'h000};
            default : ext = {27'h0000000,din[14:10]};
        endcase
    end

endmodule
