`timescale 1ns / 1ps
`include "defines.vh"

module FIFO
(
    input wire clk,
    input wire rst,
    input wire flush,

    input wire push_en,
    input wire [105:0] push_data,
    input wire pop_en,
    output wire [105:0] pop_data,
    output wire empty,
    output wire full,
    output wire stall
);
    reg [3:0] write_index;  
    reg [3:0] write_index_add1;
    reg [3:0] write_index_add2; 
    reg [3:0] read_index;
    reg [105:0] data [15:0];  //1+32+32+32+1+7
    
    assign empty = write_index == read_index;
    assign full  = read_index == write_index_add1;
    assign stall = read_index == write_index_add2;
    assign pop_data = data[read_index];
    integer i;
    always @(posedge clk)
    begin
        if(rst | flush)
        begin
            write_index <= 4'b0;
            read_index <= 4'b0;
            write_index_add1 <= 4'h1;
            write_index_add2 <= 4'h2;
            for(i=0; i<16; i=i+1)
                data[i] <= 106'b0;
        end
        else 
        begin
            if(push_en)
            begin
                data[write_index] <= push_data;
                write_index <= write_index +1;
                write_index_add1 <= write_index_add1 + 1;
                write_index_add2 <= write_index_add2 + 1;
            end
            if(pop_en & !empty)
            begin
                read_index <= read_index + 1;
            end
        end
    end
endmodule