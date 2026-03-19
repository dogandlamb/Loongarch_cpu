`timescale 1ns / 1ps

module cache_wreq_bridge(
    input  wire         rstn     ,
    input  wire         cpu_clk  ,
    // Cache Write Interface
    output wire         dev_wrdy ,      // 给Cache写主存的就绪信号（就绪时Cache才能发出写主存请求）
    input  wire [ 3:0]  cpu_wen  ,      // Cache的写主存使能信号，支持字节使能
    input  wire [31:0]  cpu_waddr,      // Cache的写主存地址
    input  wire [31:0]  cpu_wdata,      // Cache的写主存数据
    // SRAM-User Interface
    input  wire         bus_uclk ,
    output wire         bus_en   ,      // SRAM使能信号
    output wire [31:0]  bus_waddr,      // 写SRAM地址
    output wire [ 3:0]  bus_we   ,      // 写SRAM写使能，支持字节使能
    output wire [31:0]  bus_wdata       // 写SRAM数据
);

    wire [ 3:0] fifo_we;
    wire [31:0] fifo_waddr;
    wire [31:0] fifo_wdata;
    wire        fifo_empty;
    wire        fifo_rd_en = !fifo_empty;

    async_fifo #(
        .DATA_WIDTH(68)
    ) dc_wreq_fifo (
        .rstn       (rstn),
        // Write Port
        .wr_clk     (cpu_clk),
        .wr_en      ((cpu_wen != 4'h0)),
        .din        ({cpu_wen, cpu_waddr, cpu_wdata}),
        .full       (),
        // Read Port
        .rd_clk     (bus_uclk),
        .rd_en      (fifo_rd_en),
        .dout       ({fifo_we, fifo_waddr, fifo_wdata}),
        .empty      (fifo_empty)
    );

    assign dev_wrdy = fifo_empty;

    reg  fifo_rd_en_r;
    wire new_wreq = !fifo_rd_en_r & fifo_rd_en;  // posedge of fifo_rd_en
    always @(posedge bus_uclk) fifo_rd_en_r <= fifo_rd_en;

    wire        wr_peripheral = (fifo_waddr[31:16] == 16'hBFAF);
    wire [31:0] wr_word_addr  = {2'h0, fifo_waddr[31:2]};

    assign bus_en    = new_wreq;
    assign bus_waddr = wr_peripheral ? fifo_waddr : wr_word_addr;
    assign bus_we    = new_wreq ? fifo_we : 4'h0;
    assign bus_wdata = fifo_wdata;

endmodule
