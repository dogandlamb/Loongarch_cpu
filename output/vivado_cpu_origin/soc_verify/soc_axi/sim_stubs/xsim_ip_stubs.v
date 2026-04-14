// ============================================================
// XSim 行为桩：mult_gen_0 / div_gen_0 / axi_ram
// ============================================================

module mult_gen_0 (
    input  wire               CLK,
    input  wire        [32:0] A,
    input  wire        [32:0] B,
    output reg         [65:0] P
);
    always @(posedge CLK) begin
        P <= $signed(A) * $signed(B);
    end
endmodule

module div_gen_0 (
    input  wire               aclk,
    input  wire        [31:0] s_axis_divisor_tdata,
    input  wire               s_axis_divisor_tvalid,
    output wire               s_axis_divisor_tready,
    input  wire        [31:0] s_axis_dividend_tdata,
    input  wire               s_axis_dividend_tvalid,
    output wire               s_axis_dividend_tready,
    output reg         [63:0] m_axis_dout_tdata,
    output reg                m_axis_dout_tvalid
);
    wire fire = s_axis_divisor_tvalid & s_axis_dividend_tvalid
              & (s_axis_divisor_tdata != 32'd0);
    assign s_axis_divisor_tready  = 1'b1;
    assign s_axis_dividend_tready = 1'b1;

    always @(posedge aclk) begin
        m_axis_dout_tvalid <= 1'b0;
        if (fire) begin
            m_axis_dout_tdata <= {
                $signed(s_axis_dividend_tdata) / $signed(s_axis_divisor_tdata),
                $signed(s_axis_dividend_tdata) % $signed(s_axis_divisor_tdata)
            };
            m_axis_dout_tvalid <= 1'b1;
        end
    end
endmodule

module axi_ram (
    input  wire        s_aclk,
    input  wire        s_aresetn,
    input  wire [ 3:0] s_axi_arid,
    input  wire [31:0] s_axi_araddr,
    input  wire [ 7:0] s_axi_arlen,
    input  wire [ 2:0] s_axi_arsize,
    input  wire [ 1:0] s_axi_arburst,
    input  wire        s_axi_arvalid,
    output reg         s_axi_arready,
    output reg [ 3:0] s_axi_rid,
    output reg [31:0] s_axi_rdata,
    output reg [ 1:0] s_axi_rresp,
    output reg         s_axi_rlast,
    output reg         s_axi_rvalid,
    input  wire        s_axi_rready,
    input  wire [ 3:0] s_axi_awid,
    input  wire [31:0] s_axi_awaddr,
    input  wire [ 7:0] s_axi_awlen,
    input  wire [ 2:0] s_axi_awsize,
    input  wire [ 1:0] s_axi_awburst,
    input  wire        s_axi_awvalid,
    output reg         s_axi_awready,
    input  wire [31:0] s_axi_wdata,
    input  wire [ 3:0] s_axi_wstrb,
    input  wire        s_axi_wlast,
    input  wire        s_axi_wvalid,
    output reg         s_axi_wready,
    output reg [ 3:0] s_axi_bid,
    output reg [ 1:0] s_axi_bresp,
    output reg         s_axi_bvalid,
    input  wire        s_axi_bready
);
    // 与 axi_wrap_ram 一致：高区经 {12'h0,4'hf,nibble,off[11:0]} 折叠；指令映像基址 0x1c000000
    localparam MEM_WORDS = 524288;
    reg [31:0] mem [0:MEM_WORDS-1];

    function [31:0] map_axi_byte_addr;
        input [31:0] a;
        begin
            if (a[31:28] == 4'h0 || a[31:28] == 4'h1 || a[31:28] == 4'h7)
                map_axi_byte_addr = a;
            else
                map_axi_byte_addr = {12'b0, 4'hf, a[31:28], a[11:0]};
        end
    endfunction

    function integer word_index;
        input [31:0] byte_addr;
        reg [31:0] mapped;
        integer sw;
        integer wi;
        begin
            mapped = map_axi_byte_addr(byte_addr);
            // 无符号差再解释为 signed，得到 0x1bfffffc-0x1c000000 = -4 等负字偏移
            sw = $signed(mapped - 32'h1c000000) >>> 2;
            if (sw < 0)
                wi = 0;
            else if (sw >= MEM_WORDS)
                wi = MEM_WORDS - 1;
            else
                wi = sw;
            word_index = wi;
        end
    endfunction

    integer z;
    initial begin
        for (z = 0; z < MEM_WORDS; z = z + 1)
            mem[z] = 32'h0;
        $readmemh("inst_ram.mem", mem);
    end

    // 读：锁存 AR 后保持 rvalid 直至 rready；burst 时在握手同一拍预取下一字
    reg        rd_busy;
    reg [ 3:0] rd_id;
    reg [31:0] rd_addr;
    reg [ 7:0] rd_left;

    always @(posedge s_aclk) begin
        if (!s_aresetn) begin
            s_axi_arready <= 1'b1;
            s_axi_rvalid  <= 1'b0;
            s_axi_rlast   <= 1'b0;
            rd_busy       <= 1'b0;
        end else begin
            if (!rd_busy && s_axi_arvalid && s_axi_arready) begin
                rd_busy       <= 1'b1;
                s_axi_arready <= 1'b0;
                rd_id         <= s_axi_arid;
                rd_addr       <= s_axi_araddr;
                rd_left       <= s_axi_arlen;
                s_axi_rid     <= s_axi_arid;
                s_axi_rdata   <= mem[word_index(s_axi_araddr)];
                s_axi_rresp   <= 2'b00;
                s_axi_rlast   <= (s_axi_arlen == 8'd0);
                s_axi_rvalid  <= 1'b1;
            end else if (rd_busy && s_axi_rvalid && s_axi_rready) begin
                if (rd_left == 8'd0) begin
                    s_axi_rvalid  <= 1'b0;
                    rd_busy       <= 1'b0;
                    s_axi_arready <= 1'b1;
                end else begin
                    rd_addr      <= rd_addr + 32'd4;
                    rd_left      <= rd_left - 8'd1;
                    s_axi_rdata  <= mem[word_index(rd_addr + 32'd4)];
                    s_axi_rlast  <= (rd_left == 8'd1);
                    s_axi_rvalid <= 1'b1;
                end
            end
        end
    end

    // 写：锁存 AW 后收 W；最后一拍 wlast 后发 BRESP
    reg        wr_have_aw;
    reg [ 3:0] wr_id;
    reg [31:0] wr_addr;
    reg [ 7:0] wr_left;
    integer    bi;

    always @(posedge s_aclk) begin
        if (!s_aresetn) begin
            s_axi_awready <= 1'b1;
            s_axi_wready  <= 1'b0;
            s_axi_bvalid  <= 1'b0;
            wr_have_aw    <= 1'b0;
        end else begin
            if (s_axi_bvalid && s_axi_bready)
                s_axi_bvalid <= 1'b0;

            if (!wr_have_aw && s_axi_awvalid && s_axi_awready) begin
                wr_have_aw    <= 1'b1;
                wr_id         <= s_axi_awid;
                wr_addr       <= s_axi_awaddr;
                wr_left       <= s_axi_awlen;
                s_axi_awready <= 1'b0;
                s_axi_wready  <= 1'b1;
            end

            if (wr_have_aw && s_axi_wvalid && s_axi_wready) begin
                for (bi = 0; bi < 4; bi = bi + 1) begin
                    if (s_axi_wstrb[bi])
                        mem[word_index(wr_addr)][bi*8 +: 8] <= s_axi_wdata[bi*8 +: 8];
                end
                if (s_axi_wlast) begin
                    wr_have_aw    <= 1'b0;
                    s_axi_awready <= 1'b1;
                    s_axi_wready  <= 1'b0;
                    s_axi_bid     <= wr_id;
                    s_axi_bresp   <= 2'b00;
                    s_axi_bvalid  <= 1'b1;
                end else begin
                    wr_addr <= wr_addr + 32'd4;
                end
            end
        end
    end
endmodule
