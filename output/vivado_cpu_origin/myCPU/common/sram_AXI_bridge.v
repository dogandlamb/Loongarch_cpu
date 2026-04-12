// ============================================================
// sram_AXI_bridge：CPU 流水侧（类 SRAM 握手时序）↔ 单 AXI4 主端口。
// - 流水侧接口与原 bram_data_stream_controller 一致。
// - AXI：INCR、单次传输（arlen/awlen=0），arsize/awsize=字；arid/awid 0=取指 1=数据。
// - 数据 load 的 re 常为单周期：入队 dr_pending，避免总线忙时丢请求。
// ============================================================
module sram_AXI_bridge (
    input  wire        clk,
    input  wire        reset,


    // ==== 流水线接口(类sram接口) ====
    input  wire        inst_re_in_from_IF,
    input  wire        data_we_in_from_EXE,
    input  wire        data_re_in_from_EXE,

    input  wire [31:0] pc_in_from_IF,
    input  wire [31:0] data_raddr_from_EXE,
    input  wire [31:0] data_waddr_from_EXE,
    input  wire [31:0] data_wdata_from_EXE,
    input  wire [ 3:0] data_byte_en_from_EXE,

    output wire [31:0] inst_rdata_2IF,
    output wire [31:0] data_rdata_2MEM,

    output reg         data_w_wrong,
    output reg         data_r_wrong,
    output reg         inst_r_wrong,

    output reg         data_w_complete,
    output reg         data_r_complete,
    output reg         inst_r_complete,

    output wire [31:0] pc_out_2ID,


    // ==== AXI读请求通道(以ar开头) ====
    // master -> slave
    output reg  [3:0]  arid,     // AXI read ID，读请求的ID号，取指置为0，取数置为1
    output reg  [31:0] araddr,   // 读请求的地址
    output reg  [7:0]  arlen,    // 读请求控制信号，请求传输的长度（数据传输拍数），固定为0，arlen=0在AXI4表示1拍
    output reg  [2:0]  arsize,   // 读请求控制信号，请求传输的大小（数据传输每拍的字节数）
    output reg  [1:0]  arburst,  // 读请求控制信号，传输类型，固定为0b01
    output reg  [1:0]  arlock,   // 读请求控制信号，原子锁，固定为0
    output reg  [3:0]  arcache,  // 读请求控制信号，CACHE属性，固定为0
    output reg  [2:0]  arprot,   // 读请求控制信号，保护属性，固定为0
    output reg         arvalid,  // 读请求地址握手信号，读请求地址有效
    // slave -> master
    input  wire        arready,  // 读请求地址握手信号，从方准备好接收数据传输


    // ==== AXI读响应通道(以r开头) ====
    // slave -> master
    input  wire [3:0]  rid,      // 读请求的ID号，同一请求的rid应和arid一致，0对应取指，1对应数据
    input  wire [31:0] rdata,    // 读请求的读回数据
    input  wire [1:0]  rresp,    // 读请求控制信号，本次读请求是否成功完成，我们理解时可忽略，实际代码由桥检测/使用
    input  wire        rlast,    // 读请求控制信号，本次读请求的最后一拍数据的指示信号，我们理解时可忽略，实际代码由桥检测/使用
    input  wire        rvalid,   // 读请求数据握手信号，读请求数据有效
    // master -> slave
    output wire        rready,   // 读请求数据握手信号，主方准备好接受数据传输


    // ==== AXI写请求通道(以aw开头) ====
    // master -> slave
    output reg  [3:0]  awid,     // 写请求的ID号，固定为1
    output reg  [31:0] awaddr,   // 写请求的地址
    output reg  [7:0]  awlen,    // 写请求控制信号，请求传输的长度（数据传输拍数），固定为0
    output reg  [2:0]  awsize,   // 写请求控制信号，请求传输的大小（数据传输每拍的字节数）
    output reg  [1:0]  awburst,  // 写请求控制信号，传输类型，固定为0b01
    output reg  [1:0]  awlock,   // 写请求控制信号，原子锁，固定为0
    output reg  [3:0]  awcache,  // 写请求控制信号，CACHE属性，固定为0
    output reg  [2:0]  awprot,   // 写请求控制信号，保护属性，固定为0
    output reg         awvalid,  // 写请求地址握手信号，写请求地址有效
    // slave -> master
    input  wire        awready,  // 写请求地址握手信号，从方准备好接收数据传输


    // ==== AXI写数据通道(以w开头) ====
    // master -> slave
    output reg  [3:0]  wid,      // 写请求的ID号，固定为1
    output reg  [31:0] wdata,    // 写请求的写数据
    output reg  [3:0]  wstrb,    // 写请求控制信号，字节选通位
    output reg         wlast,    // 写请求控制信号，本次写请求的最后一拍数据的指示信号，固定为1
    output reg         wvalid,   // 写请求数据握手信号，写请求数据有效
    // slave -> master
    input  wire        wready,   // 写请求数据握手信号，从方准备好接收数据传输


    // ==== AXI写响应通道(以b开头) ====
    // slave -> master
    input  wire [3:0]  bid,      // 写请求的ID号，同一请求的bid、wid和awid应一致，我们理解时可忽略，实际代码由桥检测/使用
    input  wire [1:0]  bresp,    // 写请求控制信号，本次写请求是否成功完成，我们理解时可忽略，实际代码由桥检测/使用
    input  wire        bvalid,   // 写请求响应握手信号，写请求响应有效
    // master -> slave
    output wire        bready    // 写请求响应握手信号，主方准备好接收写响应
);

    localparam [3:0] AXI_ID_INST = 4'd0;
    localparam [3:0] AXI_ID_DATA = 4'd1;

    localparam [3:0] S_IDLE    = 4'd0;
    localparam [3:0] S_AR_INST = 4'd1;
    localparam [3:0] S_R_INST  = 4'd2;
    localparam [3:0] S_AR_DATA = 4'd3;
    localparam [3:0] S_R_DATA  = 4'd4;
    localparam [3:0] S_AW     = 4'd5;
    localparam [3:0] S_W      = 4'd6;
    localparam [3:0] S_B      = 4'd7;

    reg [3:0] state;

    reg        dr_pending;
    reg [31:0] dr_addr;

    reg [31:0] inst_rdata_reg;
    reg [31:0] data_rdata_reg;

    reg        data_wr_got_b;

    wire data_w_wrong_local;
    wire data_r_wrong_local;
    wire inst_r_wrong_local;
    assign data_w_wrong_local = bvalid & bresp != 2'b00 & bid == AXI_ID_DATA;
    assign data_r_wrong_local = (rvalid & rresp != 2'b00 & rid == AXI_ID_DATA);
    assign inst_r_wrong_local = (rvalid & rresp != 2'b00 & rid == AXI_ID_INST);

    wire inst_ar_done = (state == S_AR_INST) & arvalid & arready;
    wire inst_r_done  = (state == S_R_INST) & rvalid & rlast & (rid == AXI_ID_INST);
    wire data_r_done  = (state == S_R_DATA) & rvalid & rlast & (rid == AXI_ID_DATA);

    wire data_rd_live = data_re_in_from_EXE & ((state != S_IDLE) | data_we_in_from_EXE);
    wire data_rd_need = dr_pending | data_re_in_from_EXE;
    wire [31:0] data_rd_araddr = data_re_in_from_EXE ? data_raddr_from_EXE : dr_addr;
    wire b_handshake  = (state == S_B) & bvalid & bready & (bid == AXI_ID_DATA);

    wire sram_inst_addr_ok = inst_ar_done;
    wire sram_inst_data_ok = inst_r_done;
    wire sram_data_data_ok_rd = data_r_done;
    wire sram_data_data_ok_wr = data_wr_got_b & ~data_we_in_from_EXE;
    wire sram_data_data_ok    = sram_data_data_ok_rd | sram_data_data_ok_wr;

    reg  data_w_pending;
    reg  data_r_pending;
    reg  data_r_complete_d;
    reg [31:0] inst_pc_pending;
    reg  inst_wait_data;

    assign inst_rdata_2IF  = inst_rdata_reg;
    assign data_rdata_2MEM = data_rdata_reg;
    assign pc_out_2ID      = inst_pc_pending;

    assign rready = 1'b1;
    assign bready = 1'b1;

    always @(posedge clk) begin
        if (reset) begin
            dr_pending <= 1'b0;
            dr_addr    <= 32'd0;
        end else begin
            if (state == S_AR_DATA && arvalid && arready)
                dr_pending <= 1'b0;
            else if (data_rd_live) begin
                dr_pending <= 1'b1;
                dr_addr    <= data_raddr_from_EXE;
            end
        end
    end

    always @(posedge clk) begin
        if (reset)
            data_wr_got_b <= 1'b0;
        else begin
            if (b_handshake)
                data_wr_got_b <= 1'b1;
            else if (data_wr_got_b & ~data_we_in_from_EXE)
                data_wr_got_b <= 1'b0;
        end
    end

    always @(posedge clk) begin
        if (reset) begin
            state           <= S_IDLE;
            arvalid         <= 1'b0;
            arid            <= 4'd0;
            araddr          <= 32'd0;
            arlen           <= 8'd0;
            arsize          <= 3'b010;
            arburst         <= 2'b01;
            arlock          <= 2'd0;
            arcache         <= 4'd0;
            arprot          <= 3'd0;
            awvalid         <= 1'b0;
            awid            <= 4'd0;
            awaddr          <= 32'd0;
            awlen           <= 8'd0;
            awsize          <= 3'b010;
            awburst         <= 2'b01;
            awlock          <= 2'd0;
            awcache         <= 4'd0;
            awprot          <= 3'd0;
            wvalid          <= 1'b0;
            wid             <= 4'd0;
            wdata           <= 32'd0;
            wstrb           <= 4'd0;
            wlast           <= 1'b0;
            inst_rdata_reg  <= 32'd0;
            data_rdata_reg  <= 32'd0;
        end else begin
            case (state)
                S_IDLE: begin
                    arvalid <= 1'b0;
                    awvalid <= 1'b0;
                    wvalid  <= 1'b0;
                    wlast   <= 1'b0;
                    if (data_we_in_from_EXE) begin
                        state   <= S_AW;
                        awvalid <= 1'b1;
                        awid    <= AXI_ID_DATA;
                        awaddr  <= data_waddr_from_EXE;
                        awlen   <= 8'd0;
                        awsize  <= 3'b010;
                        awburst <= 2'b01;
                    end else if (data_rd_need) begin
                        state   <= S_AR_DATA;
                        arvalid <= 1'b1;
                        arid    <= AXI_ID_DATA;
                        araddr  <= data_rd_araddr;
                        arlen   <= 8'd0;
                        arsize  <= 3'b010;
                        arburst <= 2'b01;
                    end else if (inst_re_in_from_IF) begin
                        state   <= S_AR_INST;
                        arvalid <= 1'b1;
                        arid    <= AXI_ID_INST;
                        araddr  <= pc_in_from_IF;
                        arlen   <= 8'd0;
                        arsize  <= 3'b010;
                        arburst <= 2'b01;
                    end
                end
                S_AR_INST: begin
                    if (arvalid & arready) begin
                        arvalid <= 1'b0;
                        state   <= S_R_INST;
                    end
                end
                S_R_INST: begin
                    if (rvalid & rlast & (rid == AXI_ID_INST)) begin
                        inst_rdata_reg <= rdata;
                        state          <= S_IDLE;
                    end
                end
                S_AR_DATA: begin
                    if (arvalid & arready) begin
                        arvalid <= 1'b0;
                        state   <= S_R_DATA;
                    end
                end
                S_R_DATA: begin
                    if (rvalid & rlast & (rid == AXI_ID_DATA)) begin
                        data_rdata_reg <= rdata;
                        state          <= S_IDLE;
                    end
                end
                S_AW: begin
                    if (awvalid & awready) begin
                        awvalid <= 1'b0;
                        state   <= S_W;
                        wvalid  <= 1'b1;
                        wlast   <= 1'b1;
                        wid     <= AXI_ID_DATA;
                        wdata   <= data_wdata_from_EXE;
                        wstrb   <= data_byte_en_from_EXE;
                    end
                end
                S_W: begin
                    if (wvalid & wready) begin
                        wvalid <= 1'b0;
                        wlast  <= 1'b0;
                        state  <= S_B;
                    end
                end
                S_B: begin
                    if (bvalid & bready & (bid == AXI_ID_DATA))
                        state <= S_IDLE;
                end
                default: state <= S_IDLE;
            endcase
        end
    end

    always @(posedge clk) begin
        if (reset) begin
            data_w_pending    <= 1'b0;
            data_r_pending    <= 1'b0;
            data_r_complete_d <= 1'b0;
            data_r_complete   <= 1'b0;
            inst_pc_pending   <= 32'b0;
            inst_wait_data    <= 1'b0;
            inst_r_complete   <= 1'b0;
        end else begin
            if (inst_re_in_from_IF && sram_inst_addr_ok)
                inst_pc_pending <= pc_in_from_IF;

            if (sram_inst_data_ok)
                inst_wait_data <= 1'b0;
            else if (inst_re_in_from_IF && sram_inst_addr_ok)
                inst_wait_data <= 1'b1;

            if (!data_w_pending && data_we_in_from_EXE)
                data_w_pending <= 1'b1;
            else if (data_w_pending && !data_we_in_from_EXE && sram_data_data_ok)
                data_w_pending <= 1'b0;

            if (!data_r_pending && data_re_in_from_EXE)
                data_r_pending <= 1'b1;
            else if (data_r_pending && !data_re_in_from_EXE && sram_data_data_ok)
                data_r_pending <= 1'b0;

            if (!data_r_wrong_local) begin
                data_r_complete_d <= data_r_pending & !data_re_in_from_EXE & sram_data_data_ok;
                data_r_complete   <= data_r_complete_d;
            end else begin
                data_r_complete_d <= 1'b0;
                data_r_complete   <= 1'b0;
            end

            if (!inst_r_wrong_local)
                inst_r_complete <= sram_inst_data_ok
                    & (inst_wait_data | (inst_re_in_from_IF & sram_inst_addr_ok));
            else
                inst_r_complete <= 1'b0;
        end
    end

    always @(posedge clk) begin
        if (reset) data_w_wrong <= 1'b0;
        else       data_w_wrong <= data_w_wrong_local;
    end

    always @(posedge clk) begin
        if (reset) data_r_wrong <= 1'b0;
        else       data_r_wrong <= data_r_wrong_local;
    end

    always @(posedge clk) begin
        if (reset) inst_r_wrong <= 1'b0;
        else       inst_r_wrong <= inst_r_wrong_local;
    end

    always @(posedge clk) begin
        if (reset) data_w_complete <= 1'b0;
        else if (!data_w_wrong_local)
            data_w_complete <= data_w_pending & !data_we_in_from_EXE & sram_data_data_ok;
        else data_w_complete <= 1'b0;
    end

endmodule
