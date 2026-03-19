module decoder_2_4(
    input  wire [ 1:0] in,
    output wire [ 3:0] out
);
genvar i;
generate for (i=0; i<4; i=i+1) begin : gen_for_dec_2_4
    assign out[i] = (in == i);
end endgenerate

endmodule

module decoder_4_16(
    input  wire [ 3:0] in,
    output wire [15:0] out
);
genvar i;
generate for (i=0; i<16; i=i+1) begin : gen_for_dec_4_16
    assign out[i] = (in == i);
end endgenerate

endmodule

module decoder_5_32(
    input  wire [ 4:0] in,
    output wire [31:0] out
);
genvar i;
generate for (i=0; i<32; i=i+1) begin : gen_for_dec_5_32
    assign out[i] = (in == i);
end endgenerate

endmodule




module decoder_6_64(
    input  wire [ 5:0] in,
    output wire [63:0] out
);
genvar i;
generate 
	for (i=0; i<64; i=i+1) 
	begin : gen_for_dec_6_64  //bug7
    	assign out[i] = (in == i);
	end
endgenerate

endmodule


`ifdef DIFFTEST_EN

module data_bank_ram
#(
    parameter WIDTH = 32    ,
    parameter DEPTH = 256
)
(
    input  wire [ 7:0]          addra   ,
    input  wire                 clka    ,
    input  wire [31:0]          dina    ,
    output wire [31:0]          douta   ,
    input  wire                 ena     ,
    input  wire [ 3:0]          wea      
);

reg [31:0] mem_reg [255:0];
reg [31:0] output_buffer;

always @(posedge clka) begin
    if (ena) begin
        if (wea) begin
            if (wea[0]) begin
                mem_reg[addra][ 7: 0] <= dina[ 7: 0]; 
            end 

            if (wea[1]) begin
                mem_reg[addra][15: 8] <= dina[15: 8];
            end

            if (wea[2]) begin
                mem_reg[addra][23:16] <= dina[23:16];
            end

            if (wea[3]) begin
                mem_reg[addra][31:24] <= dina[31:24];
            end
        end
        else begin
            output_buffer <= mem_reg[addra];
        end
    end
end

assign douta = output_buffer;

endmodule 

module tagv_ram
#( 
    parameter WIDTH = 21    ,
    parameter DEPTH = 256
)
( 
    input  wire [ 7:0]          addra   ,
    input  wire                 clka    ,
    input  wire [20:0]          dina    ,
    output wire [20:0]          douta   ,
    input  wire                 ena     ,
    input  wire                 wea 
);

reg [20:0] mem_reg [255:0];
reg [20:0] output_buffer;

always @(posedge clka) begin
    if (ena) begin
        if (wea) begin
            mem_reg[addra] <= dina;
        end
        else begin
            output_buffer <= mem_reg[addra];
        end
    end
end

assign douta = output_buffer;

endmodule
`endif


