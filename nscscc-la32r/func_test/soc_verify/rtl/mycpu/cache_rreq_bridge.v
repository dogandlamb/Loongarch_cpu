`timescale 1ns / 1ps

module cache_rreq_bridge #(
    parameter BLK_LEN = 4
)(
    input  wire         rstn      ,
    input  wire         cpu_clk   ,
    input  wire         w_hold    ,     
    input  wire         r_hold    ,
    // Cache Read Interface
    output wire         dev_rrdy  ,     // 给Cache读主存的就绪信号（就绪时Cache才能发出读主存请求）
    input  wire         cpu_ren   ,     // Cache的读主存使能信号
    input  wire [31:0]  cpu_raddr ,     // Cache的读主存地址
    output reg          dev_rvalid,     // 返回给Cache的数据有效信号（有效n个周期则返回n个有效数据）
    output reg  [31:0]  dev_rdata ,     // 返回给Cache的读主存数据
    // SRAM-BUS Interface
    input  wire         bus_uclk  ,
    output wire         bus_en    ,     // SRAM使能信号
    output wire [31:0]  bus_raddr ,     // 读SRAM地址
    input  wire [31:0]  bus_rdata       // 读SRAM数据
);

    wire [31:0] fifo_raddr;
    wire        fifo_empty;
    wire        fifo_rd_en = !(w_hold | r_hold) & !fifo_empty;

    async_fifo u_rreq_fifo (
        .rstn       (rstn),
        // Write Port
        .wr_clk     (cpu_clk),
        .wr_en      (cpu_ren),
        .din        (cpu_raddr),
        .full       (),
        // Read Port
        .rd_clk     (bus_uclk),
        .rd_en      (fifo_rd_en),
        .dout       (fifo_raddr),   // word-address
        .empty      (fifo_empty)
    );

    assign dev_rrdy = fifo_empty;

    // Cache Read
    reg  fifo_rd_en_r;
    wire new_rreq = !fifo_rd_en_r & fifo_rd_en;  // posedge of fifo_rd_en
    always @(posedge bus_uclk) fifo_rd_en_r <= fifo_rd_en;

    wire        rd_peripheral = (fifo_raddr[31:16] == 16'hBFAF);
    wire [31:0] rd_word_addr  = {2'h0, fifo_raddr[31:2]};
    reg         ren_r;
    reg  [ 7:0] rd_cnt;
    reg  [31:0] rd_addr;
    // Peripheral: read a 32bit-word ; Memory: read a cache-block
    wire        read_end  = rd_peripheral ? (rd_cnt == 8'h1) : (rd_cnt == BLK_LEN);
    wire        rd_bus_en = new_rreq | ren_r;
    
    always @(posedge bus_uclk or negedge rstn) begin
        if (!rstn) begin
            ren_r  <= 1'b0;
            rd_cnt <= 8'h0;
        end else begin
            if (rd_cnt == BLK_LEN - 1)          ren_r <= 1'b0;
            else if (new_rreq & !rd_peripheral) ren_r <= 1'b1;

            if (read_end)       rd_cnt <= 8'h0;
            else if (rd_bus_en) rd_cnt <= rd_cnt + 8'h1;
            
            if (new_rreq)       rd_addr <= rd_word_addr + 32'h1;
            else if (ren_r)     rd_addr <= rd_addr + 32'h1;
        end
    end

    // Generate Output
    wire       rd_sram = (0 < rd_cnt) & (rd_cnt <= BLK_LEN);
    reg [ 7:0] cwf_cnt;
    always @(posedge cpu_clk or negedge rstn) begin
        if (!rstn) begin
            dev_rvalid <= 1'b0;
        end else begin
            if ((cwf_cnt < rd_cnt) & (rd_peripheral | rd_sram)) begin
                dev_rvalid <= 1'b1;
                dev_rdata  <= bus_rdata;
            end else begin
                dev_rvalid <= 1'b0;
            end
        end
    end

    always @(posedge cpu_clk or negedge rstn) begin
        if (!rstn) begin
            cwf_cnt <= 8'h0;
        end else begin
            if (fifo_rd_en) begin
                cwf_cnt <= 8'h0;
            end else if ((cwf_cnt < rd_cnt) & (rd_peripheral | rd_sram)) begin
                cwf_cnt <= cwf_cnt + 8'h1;
            end
        end
    end

    assign bus_en    = rd_bus_en;
    assign bus_raddr = ren_r ? rd_addr : (rd_peripheral ? fifo_raddr : rd_word_addr);

endmodule
