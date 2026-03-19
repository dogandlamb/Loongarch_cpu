`timescale 1ns / 1ps

module async_fifo #(
    parameter DATA_WIDTH = 32,
    parameter FIFO_DEPTH = 4    // 2^n
) (
    input  wire         rstn,
    // Write Port
    input  wire         wr_clk,
    input  wire         wr_en,
    input  wire [DATA_WIDTH-1:0] din,
    output wire         full,
    // Read Port
    input  wire         rd_clk,
    input  wire         rd_en,
    output wire [DATA_WIDTH-1:0] dout,
    output wire         empty
);

    localparam ADDR_WIDTH = $clog2(FIFO_DEPTH);

    reg [DATA_WIDTH-1:0] mem [0:FIFO_DEPTH-1];
    reg [DATA_WIDTH-1:0] dout_fwft, dout_hold;

    // 写指针和读指针（二进制和Gray码）
    reg [ADDR_WIDTH:0] wr_ptr_bin, wr_ptr_gray;
    reg [ADDR_WIDTH:0] rd_ptr_bin, rd_ptr_gray;

    // 同步到对方时钟域的Gray指针
    reg [ADDR_WIDTH:0] wr_ptr_gray_rdclk1, wr_ptr_gray_rdclk2;
    reg [ADDR_WIDTH:0] rd_ptr_gray_wrclk1, rd_ptr_gray_wrclk2;

    wire [ADDR_WIDTH:0] wr_ptr_bin_next  = wr_ptr_bin + (wr_en && !full);;
    wire [ADDR_WIDTH:0] wr_ptr_gray_next = (wr_ptr_bin_next >> 1) ^ wr_ptr_bin_next;

    // ==================== 写时钟域逻辑 ====================
    integer i;
    always @(posedge wr_clk or negedge rstn) begin
        if (!rstn) begin
            wr_ptr_bin  <= 0;
            wr_ptr_gray <= 0;
            for (i = 0; i < FIFO_DEPTH; i = i + 1)
                mem[i] <= {DATA_WIDTH{1'b0}};
        end else begin
            wr_ptr_bin  <= wr_ptr_bin_next;
            wr_ptr_gray <= wr_ptr_gray_next;
            if (wr_en && !full) begin
                mem[wr_ptr_bin[ADDR_WIDTH-1:0]] <= din;
            end
        end
    end

    // 当 wr_en 有效且即将变满时，full 立即变高，阻止 wr_ptr_bin_next 继续增长
    assign full = (wr_ptr_gray_next == {~rd_ptr_gray_wrclk2[ADDR_WIDTH:ADDR_WIDTH-1], rd_ptr_gray_wrclk2[ADDR_WIDTH-2:0]});

    // ==================== 读时钟域逻辑 ====================
    always @(posedge rd_clk or negedge rstn)
        dout_fwft <= !rstn ? {DATA_WIDTH{1'b0}} : mem[rd_ptr_bin[ADDR_WIDTH-1:0]];   // 始终加载当前头部数据
    always @(posedge rd_clk)
        if (rd_en & !empty) dout_hold <= dout_fwft;     // 下一次读操作之前，保持输出不变
        
    assign dout = (rd_en & !empty) ? dout_fwft : dout_hold;

    always @(posedge rd_clk or negedge rstn) begin
        if (!rstn) begin
            rd_ptr_bin  <= 0;
            rd_ptr_gray <= 0;
        end else if (rd_en && !empty) begin
            rd_ptr_bin  <= rd_ptr_bin + 1'b1;
            rd_ptr_gray <= (rd_ptr_bin + 1'b1) ^ ((rd_ptr_bin + 1'b1) >> 1);
        end
    end

    // empty标志：当读指针等于同步后的写指针时为空
    assign empty = (rd_ptr_gray == wr_ptr_gray_rdclk2);

    // ==================== 跨时钟域同步（两级同步器）===================
    // 写指针Gray码同步到读时钟域
    always @(posedge rd_clk or negedge rstn) begin
        if (!rstn) begin
            wr_ptr_gray_rdclk1 <= 0;
            wr_ptr_gray_rdclk2 <= 0;
        end else begin
            wr_ptr_gray_rdclk1 <= wr_ptr_gray;
            wr_ptr_gray_rdclk2 <= wr_ptr_gray_rdclk1;
        end
    end

    // 读指针Gray码同步到写时钟域
    always @(posedge wr_clk or negedge rstn) begin
        if (!rstn) begin
            rd_ptr_gray_wrclk1 <= 0;
            rd_ptr_gray_wrclk2 <= 0;
        end else begin
            rd_ptr_gray_wrclk1 <= rd_ptr_gray;
            rd_ptr_gray_wrclk2 <= rd_ptr_gray_wrclk1;
        end
    end

endmodule
