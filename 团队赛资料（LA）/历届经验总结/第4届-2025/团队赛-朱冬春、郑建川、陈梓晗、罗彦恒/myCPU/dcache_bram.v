`timescale 1ns / 1ps

module dcache_bram
(
    input wire clka,
    input wire [6:0] addra,
    input wire [20:0] dina,
    input wire wea,

    input wire clkb,
    input wire [6:0] addrb,
    output reg [20:0] doutb
);

reg [20:0] data [127:0];

always @(posedge clka)
begin
    doutb <= data[addrb];
    if(wea) data[addra] <= dina;
end

endmodule