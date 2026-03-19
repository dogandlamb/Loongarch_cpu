`timescale 1ns / 1ps

module sram_ctrl #(
    parameter ADDR_WID = 20
)(
    input  wire         rstn,
    input  wire         usr_clk,        // 0  degree phase, 50% duty cycle
    input  wire         wen_clk,        // 45 degree phase, 75% duty cycle (or 90-50%)
    
    input  wire         usr_en,
    input  wire [31:0]  usr_addr,
    input  wire [ 3:0]  usr_we,
    input  wire [31:0]  usr_wdata,
    output wire [31:0]  usr_rdata,

    output wire [ADDR_WID-1:0]  sram_addr,      // read/write address
    inout  wire [31:0]  sram_data,      // read/write data
    output wire         sram_oen,       // output enable
    output wire         sram_cen,       // chip select
    output wire         sram_wen,       // write enable
    output wire [ 3:0]  sram_ben        // byte enable
);

    reg  [31:0] sram_rdata;
    wire [31:0] sram_wdata = usr_wdata;

    wire we = |usr_we;

    assign sram_addr = usr_addr;
    assign sram_data = sram_oen ? sram_wdata : 32'hZ;
    assign sram_oen  = we;
    assign sram_cen  = !usr_en;
    assign sram_wen  = !(usr_en & we) | !wen_clk;
    assign sram_ben  = we ? ~usr_we : 4'h0;

    always @(posedge usr_clk) begin
        sram_rdata <= !rstn ? 32'h0 : sram_data;
    end

    assign usr_rdata = we ? usr_wdata : sram_rdata;

endmodule
