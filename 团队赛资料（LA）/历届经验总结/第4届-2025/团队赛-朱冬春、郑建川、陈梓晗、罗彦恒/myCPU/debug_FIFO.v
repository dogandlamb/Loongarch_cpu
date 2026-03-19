`include "defines.vh"

module debug_FIFO
(
    input wire clk,
    input wire rst,
    input wire [101:0] data1,
    input wire valid1,
    input wire [101:0] data2, 
    input wire valid2,
    output wire [101:0] data_out,
    output wire valid_out
);

reg [101:0] data [65535:0];
reg [15:0] read;
reg [15:0] write;
reg [15:0] write_add;

wire empty = read == write;
assign data_out = data[read];
assign valid_out = !empty;

integer i;
always @(posedge clk)
begin
    if(rst)
    begin
        for(i=0;i<65535;i=i+1)
        begin
            data[i] <= 0;
        end
        read <= 0;
        write <= 0;
        write_add <= 1;
    end
    else if(valid1 & valid2)
    begin
        data[write] <= data1;
        data[write_add] <= data2;
        write <= write +2;
        write_add <= write_add + 2;
    end
    else if(valid1)
    begin
        data[write] <= data1;
        write <= write + 1;
        write_add <= write_add + 1;
    end
    else if(valid2)
    begin
        data[write] <= data2;
        write <= write + 1;
        write_add <= write_add + 1;
    end
end

always @(posedge clk)
begin
    if(!rst & !empty)
    begin
        read <= read + 1;
        data[read] <= 0;
    end
end


endmodule




