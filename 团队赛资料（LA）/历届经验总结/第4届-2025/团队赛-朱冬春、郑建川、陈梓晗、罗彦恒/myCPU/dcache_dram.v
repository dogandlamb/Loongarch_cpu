`timescale 1ns / 1ps

module dcache_dram
(
    input wire clka,
    input wire [6:0] addra,
    input wire [255:0] dina,
    input wire [31:0] wea,
    input wire clkb,
    input wire [6:0] addrb,
    output reg [255:0] doutb
);

reg [255:0] data [127:0];
wire [255:0] we = {
    {8{wea[31]}},
    {8{wea[30]}},
    {8{wea[29]}},
    {8{wea[28]}},
    {8{wea[27]}},
    {8{wea[26]}},
    {8{wea[25]}},
    {8{wea[24]}},
    {8{wea[23]}},
    {8{wea[22]}},
    {8{wea[21]}},
    {8{wea[20]}},
    {8{wea[19]}},
    {8{wea[18]}},
    {8{wea[17]}},
    {8{wea[16]}},
    {8{wea[15]}},
    {8{wea[14]}},
    {8{wea[13]}},
    {8{wea[12]}},
    {8{wea[11]}},
    {8{wea[10]}},
    {8{wea[9]}},
    {8{wea[8]}},
    {8{wea[7]}},
    {8{wea[6]}},
    {8{wea[5]}},
    {8{wea[4]}},
    {8{wea[3]}},
    {8{wea[2]}},
    {8{wea[1]}},
    {8{wea[0]}}
};
wire [255:0] write_data = (we & dina) | (~we & data[addra]); 
always @(posedge clka)
begin
    doutb <= data[addrb];
    if(|wea) data[addra] <= write_data;
end

endmodule