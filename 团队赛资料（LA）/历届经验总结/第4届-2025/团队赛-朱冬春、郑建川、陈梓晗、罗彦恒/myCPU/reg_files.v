`timescale 1ns / 1ps
`include "defines.vh"
`include "csr_defines.vh"

module reg_files(
    input  wire clk,
    input  wire rst,
    input  wire [1:0]  reg_read_en1, 
    input  wire [1:0]  reg_read_en2,    
    input  wire [4:0]  reg_read_addr1_1,        // 第一条指令的两个读地址
    input  wire [4:0]  reg_read_addr1_2, 
    input  wire [4:0]  reg_read_addr2_1,        // 第二条指令的两个读地址
    input  wire [4:0]  reg_read_addr2_2,
    input  wire [31:0] reg_write_data1, 
    input  wire [31:0] reg_write_data2,
    input  wire [4:0]  reg_write_addr1,
    input  wire [4:0]  reg_write_addr2,
    input  wire [1:0]  reg_write_en, //锟侥达拷锟斤拷写使锟斤拷锟脚猴拷

    output reg [31:0] reg_read_data1_1 ,    // 第一条指令的两个读数据
    output reg [31:0] reg_read_data1_2 ,
    output reg [31:0] reg_read_data2_1 ,    // 第二条指令的两个读数据
    output reg [31:0] reg_read_data2_2

    `ifdef DIFF
    ,

    output wire [31:0] regs_diff [31:0]
    `endif 
);

`ifdef DIFF
assign regs_diff = reg_file;
`endif 

reg [31:0] reg_file [31:0]; //锟侥达拷锟斤拷锟侥硷拷

integer i;
always @(posedge clk) 
begin
    if(rst)
    begin
        for(i=0;i<32;i=i+1)
        begin
            reg_file[i] <= 32'b0;
        end
    end
    // 写锟侥达拷锟斤拷
    else
    begin
        if (reg_write_en[0] & reg_write_addr1 != 5'b0) 
        begin
            reg_file[reg_write_addr1] <= reg_write_data1;
        end
        if (reg_write_en[1] & reg_write_addr2 != 5'b0) 
        begin
            reg_file[reg_write_addr2] <= reg_write_data2;
        end
    end
end

always @(*) begin
    // 锟斤拷锟侥达拷锟斤拷
    if (reg_read_en1[0]) begin
        reg_read_data1_1 = reg_file[reg_read_addr1_1];
    end else begin
        reg_read_data1_1 = 32'bz; // 锟斤拷锟矫伙拷锟绞癸拷埽锟斤拷锟斤拷锟斤拷锟斤拷态
    end

    if (reg_read_en1[1]) begin
        reg_read_data1_2 = reg_file[reg_read_addr1_2];
    end else begin
        reg_read_data1_2 = 32'bz; // 锟斤拷锟矫伙拷锟绞癸拷埽锟斤拷锟斤拷锟斤拷锟斤拷态
    end

    if (reg_read_en2[0]) begin
        reg_read_data2_1 = reg_file[reg_read_addr2_1];
    end else begin
        reg_read_data2_1 = 32'bz; // 锟斤拷锟矫伙拷锟绞癸拷埽锟斤拷锟斤拷锟斤拷锟斤拷态
    end

    if (reg_read_en2[1]) begin
        reg_read_data2_2 = reg_file[reg_read_addr2_2];
    end else begin
        reg_read_data2_2 = 32'bz; // 锟斤拷锟矫伙拷锟绞癸拷埽锟斤拷锟斤拷锟斤拷锟斤拷态
    end
end

endmodule