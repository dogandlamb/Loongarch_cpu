`timescale 1ns / 1ps

module data_bram
(
    input clka,
    input clkb,
    input wea,
    input web,
    input [6:0] addra,
    input [6:0] addrb,
    input [255:0] dina,
    input [255:0] dinb,
    output reg [255:0] douta,
    output reg [255:0] doutb
);

reg [255:0] data [127:0];

integer i;
always @(posedge clka)
begin
    douta <= data[addra];
    doutb <= data[addrb];
    if(wea) data[addra] <= dina;
    else if(web) data[addrb] <= dinb;
end

endmodule


