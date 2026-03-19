`timescale 1ns / 1ps

module icache_tag_ram
(
    input clk,
    input we1,
    input we2,
    input [6:0] index1,
    input [6:0] index2,
    input [6:0] cacop_index,
    input cacop_flush,
    input [20:0] data_in,
    input rst,
    output reg [20:0] data_out1,
    output reg [20:0] data_out2
);

(* RAM_STYLE="block"*)reg [20:0] data [127:0];

integer i;
always @(posedge clk)
begin
    if(rst)
    begin
        for (i = 0; i < 128; i = i + 1)
        begin
            data[i] <= 21'b0;  // 151位全0
        end
        data_out1 <= 21'b0;
        data_out2 <= 21'b0;
    end
    else
    begin
        data_out1 <= data[index1];
        data_out2 <= data[index2];
        if(we1) data[index1] <= data_in;
        else if(we2) data[index2] <= data_in;
        else if(cacop_flush) data[cacop_index] <= 21'b0;
    end
end

endmodule