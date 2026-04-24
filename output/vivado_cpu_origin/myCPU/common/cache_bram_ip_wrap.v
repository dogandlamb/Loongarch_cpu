module cache_bram_32x256 (
    input  wire [17:0] addra,
    input  wire        clka,
    input  wire [31:0] dina,
    output wire [31:0] douta,
    input  wire        ena,
    input  wire [3:0]  wea
);
reg [31:0] mem [0:255];
wire [7:0] a = addra[7:0];
assign douta = ena ? mem[a] : 32'b0;
always @(posedge clka) begin
    if (ena) begin
        if (wea[0]) mem[a][7:0]   <= dina[7:0];
        if (wea[1]) mem[a][15:8]  <= dina[15:8];
        if (wea[2]) mem[a][23:16] <= dina[23:16];
        if (wea[3]) mem[a][31:24] <= dina[31:24];
    end
end
endmodule

module icache_way0_TAGV_ram(input wire [17:0] addra,input wire clka,input wire [31:0] dina,output wire [31:0] douta,input wire ena,input wire [3:0] wea);
cache_bram_32x256 u(.addra(addra),.clka(clka),.dina(dina),.douta(douta),.ena(ena),.wea(wea)); endmodule
module icache_way1_TAGV_ram(input wire [17:0] addra,input wire clka,input wire [31:0] dina,output wire [31:0] douta,input wire ena,input wire [3:0] wea);
cache_bram_32x256 u(.addra(addra),.clka(clka),.dina(dina),.douta(douta),.ena(ena),.wea(wea)); endmodule
module dcache_way0_TAGV_ram(input wire [17:0] addra,input wire clka,input wire [31:0] dina,output wire [31:0] douta,input wire ena,input wire [3:0] wea);
cache_bram_32x256 u(.addra(addra),.clka(clka),.dina(dina),.douta(douta),.ena(ena),.wea(wea)); endmodule
module dcache_way1_TAGV_ram(input wire [17:0] addra,input wire clka,input wire [31:0] dina,output wire [31:0] douta,input wire ena,input wire [3:0] wea);
cache_bram_32x256 u(.addra(addra),.clka(clka),.dina(dina),.douta(douta),.ena(ena),.wea(wea)); endmodule

module icache_way0_Bank0_ram(input wire [17:0] addra,input wire clka,input wire [31:0] dina,output wire [31:0] douta,input wire ena,input wire [3:0] wea);
cache_bram_32x256 u(.addra(addra),.clka(clka),.dina(dina),.douta(douta),.ena(ena),.wea(wea)); endmodule
module icache_way0_Bank1_ram(input wire [17:0] addra,input wire clka,input wire [31:0] dina,output wire [31:0] douta,input wire ena,input wire [3:0] wea);
cache_bram_32x256 u(.addra(addra),.clka(clka),.dina(dina),.douta(douta),.ena(ena),.wea(wea)); endmodule
module icache_way0_Bank2_ram(input wire [17:0] addra,input wire clka,input wire [31:0] dina,output wire [31:0] douta,input wire ena,input wire [3:0] wea);
cache_bram_32x256 u(.addra(addra),.clka(clka),.dina(dina),.douta(douta),.ena(ena),.wea(wea)); endmodule
module icache_way0_Bank3_ram(input wire [17:0] addra,input wire clka,input wire [31:0] dina,output wire [31:0] douta,input wire ena,input wire [3:0] wea);
cache_bram_32x256 u(.addra(addra),.clka(clka),.dina(dina),.douta(douta),.ena(ena),.wea(wea)); endmodule
module icache_way1_Bank0_ram(input wire [17:0] addra,input wire clka,input wire [31:0] dina,output wire [31:0] douta,input wire ena,input wire [3:0] wea);
cache_bram_32x256 u(.addra(addra),.clka(clka),.dina(dina),.douta(douta),.ena(ena),.wea(wea)); endmodule
module icache_way1_Bank1_ram(input wire [17:0] addra,input wire clka,input wire [31:0] dina,output wire [31:0] douta,input wire ena,input wire [3:0] wea);
cache_bram_32x256 u(.addra(addra),.clka(clka),.dina(dina),.douta(douta),.ena(ena),.wea(wea)); endmodule
module icache_way1_Bank2_ram(input wire [17:0] addra,input wire clka,input wire [31:0] dina,output wire [31:0] douta,input wire ena,input wire [3:0] wea);
cache_bram_32x256 u(.addra(addra),.clka(clka),.dina(dina),.douta(douta),.ena(ena),.wea(wea)); endmodule
module icache_way1_Bank3_ram(input wire [17:0] addra,input wire clka,input wire [31:0] dina,output wire [31:0] douta,input wire ena,input wire [3:0] wea);
cache_bram_32x256 u(.addra(addra),.clka(clka),.dina(dina),.douta(douta),.ena(ena),.wea(wea)); endmodule

module dcache_way0_Bank0_ram(input wire [17:0] addra,input wire clka,input wire [31:0] dina,output wire [31:0] douta,input wire ena,input wire [3:0] wea);
cache_bram_32x256 u(.addra(addra),.clka(clka),.dina(dina),.douta(douta),.ena(ena),.wea(wea)); endmodule
module dcache_way0_Bank1_ram(input wire [17:0] addra,input wire clka,input wire [31:0] dina,output wire [31:0] douta,input wire ena,input wire [3:0] wea);
cache_bram_32x256 u(.addra(addra),.clka(clka),.dina(dina),.douta(douta),.ena(ena),.wea(wea)); endmodule
module dcache_way0_Bank2_ram(input wire [17:0] addra,input wire clka,input wire [31:0] dina,output wire [31:0] douta,input wire ena,input wire [3:0] wea);
cache_bram_32x256 u(.addra(addra),.clka(clka),.dina(dina),.douta(douta),.ena(ena),.wea(wea)); endmodule
module dcache_way0_Bank3_ram(input wire [17:0] addra,input wire clka,input wire [31:0] dina,output wire [31:0] douta,input wire ena,input wire [3:0] wea);
cache_bram_32x256 u(.addra(addra),.clka(clka),.dina(dina),.douta(douta),.ena(ena),.wea(wea)); endmodule
module dcache_way1_Bank0_ram(input wire [17:0] addra,input wire clka,input wire [31:0] dina,output wire [31:0] douta,input wire ena,input wire [3:0] wea);
cache_bram_32x256 u(.addra(addra),.clka(clka),.dina(dina),.douta(douta),.ena(ena),.wea(wea)); endmodule
module dcache_way1_Bank1_ram(input wire [17:0] addra,input wire clka,input wire [31:0] dina,output wire [31:0] douta,input wire ena,input wire [3:0] wea);
cache_bram_32x256 u(.addra(addra),.clka(clka),.dina(dina),.douta(douta),.ena(ena),.wea(wea)); endmodule
module dcache_way1_Bank2_ram(input wire [17:0] addra,input wire clka,input wire [31:0] dina,output wire [31:0] douta,input wire ena,input wire [3:0] wea);
cache_bram_32x256 u(.addra(addra),.clka(clka),.dina(dina),.douta(douta),.ena(ena),.wea(wea)); endmodule
module dcache_way1_Bank3_ram(input wire [17:0] addra,input wire clka,input wire [31:0] dina,output wire [31:0] douta,input wire ena,input wire [3:0] wea);
cache_bram_32x256 u(.addra(addra),.clka(clka),.dina(dina),.douta(douta),.ena(ena),.wea(wea)); endmodule
