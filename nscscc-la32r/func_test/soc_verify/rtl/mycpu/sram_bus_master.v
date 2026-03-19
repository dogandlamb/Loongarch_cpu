`timescale 1ns / 1ps

`include "defines.vh"

module sram_bus_master(
    input  wire         cpu_rstn     ,      // low active
    input  wire         cpu_clk      ,
    input  wire         sram_uclk    ,
    // ICache Interface
    output wire         ic_dev_rrdy  ,      // 给ICache读主存的就绪信号（就绪时ICache才能发出读主存请求）
    input  wire         ic_cpu_ren   ,      // ICache的读主存使能信号
    input  wire [31:0]  ic_cpu_raddr ,      // ICache的读主存地址
    output wire         ic_dev_rvalid,      // 返回给ICache的指令有效信号（有效n个周期则返回n条指令）
    output wire [31:0]  ic_dev_rdata ,      // 返回给ICache的指令
    // DCache Interface
    output wire         dc_dev_wrdy  ,      // 给DCache写主存的就绪信号（就绪时DCache才能发出写主存请求）
    input  wire [ 3:0]  dc_cpu_wen   ,      // DCache的写主存使能信号，支持字节使能
    input  wire [31:0]  dc_cpu_waddr ,      // DCache的写主存地址
    input  wire [31:0]  dc_cpu_wdata ,      // DCache的写主存数据
    output wire         dc_dev_rrdy  ,      // 给DCache读主存的就绪信号（就绪时DCache才能发出读主存请求）
    input  wire         dc_cpu_ren   ,      // DCache的读主存使能信号
    input  wire [31:0]  dc_cpu_raddr ,      // DCache的读主存地址
    output wire         dc_dev_rvalid,      // 返回给DCache的数据有效信号（有效n个周期则返回n个有效数据）
    output wire [31:0]  dc_dev_rdata ,      // 返回给DCache的读主存数据
    // SRAM-BUS Interface 0 (SRAM)
    output wire         bus_en0      ,      // 访问SRAM的使能信号
    output reg  [31:0]  bus_addr0    ,      // 访问SRAM的地址，读/写共用
    output wire [ 3:0]  bus_we0      ,      // 写SRAM写使能，支持字节使能
    output wire [31:0]  bus_wdata0   ,      // 写SRAM数据
    input  wire [31:0]  bus_rdata0   ,      // 读SRAM数据
    // SRAM-BUS Interface 1 (Peripheral)
    output wire         bus_en1      ,      // 访问外设的使能信号
    output reg  [31:0]  bus_addr1    ,      // 访问外设的地址，读/写共用
    output wire [ 3:0]  bus_we1      ,      // 写外设写使能，支持字节使能
    output wire [31:0]  bus_wdata1   ,      // 写外设数据
    input  wire [31:0]  bus_rdata1          // 读外设数据
);

`ifdef ENABLE_ICACHE    localparam IC_BLK_LEN = `CACHE_BLK_LEN;
`else                   localparam IC_BLK_LEN = 1;
`endif

`ifdef ENABLE_DCACHE    localparam DC_BLK_LEN = `CACHE_BLK_LEN;
`else                   localparam DC_BLK_LEN = 1;
`endif

    // reg  [ 7:0] fifo_init_cnt;
    // wire        fifo_init_done = fifo_init_cnt >= 8'd10;
    // always @(posedge cpu_clk or negedge cpu_rstn) begin
    //     fifo_init_cnt <= !cpu_rstn ? 8'h0 : fifo_init_done ? fifo_init_cnt : fifo_init_cnt + 8'h1;
    // end
    wire        fifo_init_done = 1'b1;

    wire        ic_rfifo_rdy;
    wire        dc_rfifo_rdy;
    wire        dc_wfifo_rdy;
    assign      ic_dev_rrdy = fifo_init_done & ic_rfifo_rdy;
    assign      dc_dev_rrdy = fifo_init_done & dc_rfifo_rdy;
    assign      dc_dev_wrdy = fifo_init_done & dc_wfifo_rdy;

    wire [31:0] bus_rdata;
    wire [ 3:0] bus_we;
    wire [31:0] bus_wdata;

    wire        ic_rd_bus_en, dc_rd_bus_en, dc_wr_bus_en;
    wire [31:0] ic_bus_raddr, dc_bus_raddr, dc_bus_waddr;

    wire        rd_peripheral = (dc_bus_raddr[31:16] == 32'hBFAF);
    wire        wr_peripheral = (dc_bus_waddr[31:16] == 32'hBFAF);

    wire        wr_mem_en  = dc_wr_bus_en & !wr_peripheral;
    wire        rd_mem_en  = dc_rd_bus_en & !rd_peripheral;
    wire        wr_peri_en = dc_wr_bus_en &  wr_peripheral;
    wire        rd_peri_en = dc_rd_bus_en &  rd_peripheral;

    // ICache Read-request
    cache_rreq_bridge #(
        .BLK_LEN        (IC_BLK_LEN   )
    ) u_ic_rreq_bridge (
        .rstn           (cpu_rstn     ),
        .cpu_clk        (cpu_clk      ),
        .w_hold         (wr_mem_en    ),    // priority: data wr > data rd > inst rd
        .r_hold         (rd_mem_en    ),
        // Cache Read Interface
        .dev_rrdy       (ic_rfifo_rdy ),
        .cpu_ren        (ic_cpu_ren   ),
        .cpu_raddr      (ic_cpu_raddr ),
        .dev_rvalid     (ic_dev_rvalid),
        .dev_rdata      (ic_dev_rdata ),
        // SRAM-User Interface
        .bus_uclk       (sram_uclk    ),
        .bus_en         (ic_rd_bus_en ),
        .bus_raddr      (ic_bus_raddr ),
        .bus_rdata      (bus_rdata0   )
    );

    // DCache Read-request
    cache_rreq_bridge #(
        .BLK_LEN        (DC_BLK_LEN   )
    ) u_dc_rreq_bridge (
        .rstn           (cpu_rstn     ),
        .cpu_clk        (cpu_clk      ),
        .w_hold         (wr_mem_en    ),
        .r_hold         (1'b0         ),
        // Cache Read Interface
        .dev_rrdy       (dc_rfifo_rdy ),
        .cpu_ren        (dc_cpu_ren   ),
        .cpu_raddr      (dc_cpu_raddr ),
        .dev_rvalid     (dc_dev_rvalid),
        .dev_rdata      (dc_dev_rdata ),
        // SRAM-User Interface
        .bus_uclk       (sram_uclk    ),
        .bus_en         (dc_rd_bus_en ),
        .bus_raddr      (dc_bus_raddr ),
        .bus_rdata      (bus_rdata    )
    );

    // DCache Write-request
    cache_wreq_bridge u_dc_wreq_bridge (
        .rstn           (cpu_rstn     ),
        .cpu_clk        (cpu_clk      ),
        // Cache Write Interface
        .dev_wrdy       (dc_wfifo_rdy ),
        .cpu_wen        (dc_cpu_wen   ),
        .cpu_waddr      (dc_cpu_waddr ),
        .cpu_wdata      (dc_cpu_wdata ),
        // SRAM-User Interface
        .bus_uclk       (sram_uclk    ),
        .bus_en         (dc_wr_bus_en ),
        .bus_waddr      (dc_bus_waddr ),
        .bus_we         (bus_we       ),
        .bus_wdata      (bus_wdata    )
    );

    assign bus_en0 = wr_mem_en  | rd_mem_en | ic_rd_bus_en;
    assign bus_en1 = wr_peri_en | rd_peri_en;

    always @(*) begin
        if      (wr_mem_en   ) bus_addr0 = dc_bus_waddr;
        else if (rd_mem_en   ) bus_addr0 = dc_bus_raddr;
        else if (ic_rd_bus_en) bus_addr0 = ic_bus_raddr;
        else                   bus_addr0 = 32'hF0F0F0F0;
        
        if      (wr_peri_en  ) bus_addr1 = dc_bus_waddr;
        else if (rd_peri_en  ) bus_addr1 = dc_bus_raddr;
        else                   bus_addr1 = 32'hF1F1F1F1;
    end
    
    assign bus_we0    = bus_we & {4{wr_mem_en }};
    assign bus_we1    = bus_we & {4{wr_peri_en}};

    assign bus_wdata0 = bus_wdata;
    assign bus_wdata1 = bus_wdata;

    reg    rd_peri_en_r;
    always @(posedge sram_uclk) rd_peri_en_r <= !cpu_rstn ? 1'b0 : rd_peri_en;
    assign bus_rdata  = rd_peri_en_r ? bus_rdata1 : bus_rdata0;

endmodule
