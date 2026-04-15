// xsim_ip_stubs.v — Behavioral stub for axi_ram (blk_mem_gen with AXI4 interface)
// Used in xsim simulation to replace the Xilinx IP block-RAM generator.
`timescale 1ns / 1ps

module axi_ram (
    input  wire        s_aclk,
    input  wire        s_aresetn,

    // AXI4 Write Address
    input  wire [3 :0] s_axi_awid,
    input  wire [31:0] s_axi_awaddr,
    input  wire [7 :0] s_axi_awlen,
    input  wire [2 :0] s_axi_awsize,
    input  wire [1 :0] s_axi_awburst,
    input  wire        s_axi_awvalid,
    output reg         s_axi_awready,

    // AXI4 Write Data
    input  wire [31:0] s_axi_wdata,
    input  wire [3 :0] s_axi_wstrb,
    input  wire        s_axi_wlast,
    input  wire        s_axi_wvalid,
    output reg         s_axi_wready,

    // AXI4 Write Response
    output reg  [3 :0] s_axi_bid,
    output reg  [1 :0] s_axi_bresp,
    output reg         s_axi_bvalid,
    input  wire        s_axi_bready,

    // AXI4 Read Address
    input  wire [3 :0] s_axi_arid,
    input  wire [31:0] s_axi_araddr,
    input  wire [7 :0] s_axi_arlen,
    input  wire [2 :0] s_axi_arsize,
    input  wire [1 :0] s_axi_arburst,
    input  wire        s_axi_arvalid,
    output reg         s_axi_arready,

    // AXI4 Read Data
    output reg  [3 :0] s_axi_rid,
    output reg  [31:0] s_axi_rdata,
    output reg  [1 :0] s_axi_rresp,
    output reg         s_axi_rlast,
    output reg         s_axi_rvalid,
    input  wire        s_axi_rready
);

    // 256 KB memory (64K words x 32-bit), byte-addressable via word index
    localparam MEM_DEPTH = 65536;
    reg [31:0] mem [0:MEM_DEPTH-1];

    // Load initial memory content (inst_ram.mem placed by Vivado into xsim cwd)
    initial begin
        $readmemh("inst_ram.mem", mem);
    end

    // ----------------------------------------------------------------
    // Write channel state machine
    // ----------------------------------------------------------------
    reg [3 :0] aw_id_r;
    reg [31:0] aw_addr_r;
    reg [7 :0] aw_len_r;
    reg [2 :0] aw_size_r;
    reg [1 :0] aw_burst_r;
    reg [7 :0] aw_beat_cnt;
    reg        aw_active;
    reg [31:0] waddr;

    always @(posedge s_aclk) begin
        if (!s_aresetn) begin
            s_axi_awready <= 1'b1;
            s_axi_wready  <= 1'b0;
            s_axi_bvalid  <= 1'b0;
            s_axi_bid     <= 4'd0;
            s_axi_bresp   <= 2'b00;
            aw_active     <= 1'b0;
            aw_beat_cnt   <= 8'd0;
        end else begin
            // B channel handshake
            if (s_axi_bvalid && s_axi_bready) begin
                s_axi_bvalid <= 1'b0;
                s_axi_awready <= 1'b1;
            end

            // AW handshake
            if (s_axi_awvalid && s_axi_awready && !aw_active) begin
                aw_id_r      <= s_axi_awid;
                aw_addr_r    <= s_axi_awaddr;
                aw_len_r     <= s_axi_awlen;
                aw_size_r    <= s_axi_awsize;
                aw_burst_r   <= s_axi_awburst;
                aw_beat_cnt  <= 8'd0;
                aw_active    <= 1'b1;
                s_axi_awready <= 1'b0;
                s_axi_wready  <= 1'b1;
            end

            // W channel data beats
            if (aw_active && s_axi_wvalid && s_axi_wready) begin
                // Compute current word address
                waddr = aw_addr_r + (aw_beat_cnt << aw_size_r);
                // Byte-lane write
                if (s_axi_wstrb[0]) mem[waddr[17:2]][7 : 0] <= s_axi_wdata[7 : 0];
                if (s_axi_wstrb[1]) mem[waddr[17:2]][15: 8] <= s_axi_wdata[15: 8];
                if (s_axi_wstrb[2]) mem[waddr[17:2]][23:16] <= s_axi_wdata[23:16];
                if (s_axi_wstrb[3]) mem[waddr[17:2]][31:24] <= s_axi_wdata[31:24];

                if (s_axi_wlast) begin
                    aw_active    <= 1'b0;
                    s_axi_wready <= 1'b0;
                    s_axi_bvalid <= 1'b1;
                    s_axi_bid    <= aw_id_r;
                    s_axi_bresp  <= 2'b00;
                end else begin
                    aw_beat_cnt <= aw_beat_cnt + 1'b1;
                end
            end
        end
    end

    // ----------------------------------------------------------------
    // Read channel state machine
    // ----------------------------------------------------------------
    reg [3 :0] ar_id_r;
    reg [31:0] ar_addr_r;
    reg [7 :0] ar_len_r;
    reg [2 :0] ar_size_r;
    reg [1 :0] ar_burst_r;
    reg [7 :0] ar_beat_cnt;
    reg        ar_active;
    reg [31:0] raddr;

    always @(posedge s_aclk) begin
        if (!s_aresetn) begin
            s_axi_arready <= 1'b1;
            s_axi_rvalid  <= 1'b0;
            s_axi_rid     <= 4'd0;
            s_axi_rdata   <= 32'd0;
            s_axi_rresp   <= 2'b00;
            s_axi_rlast   <= 1'b0;
            ar_active     <= 1'b0;
            ar_beat_cnt   <= 8'd0;
        end else begin
            if (ar_active) begin
                if (!s_axi_rvalid || s_axi_rready) begin
                    raddr = ar_addr_r + (ar_beat_cnt << ar_size_r);
                    s_axi_rdata  <= mem[raddr[17:2]];
                    s_axi_rid    <= ar_id_r;
                    s_axi_rresp  <= 2'b00;
                    s_axi_rvalid <= 1'b1;
                    if (ar_beat_cnt == ar_len_r) begin
                        s_axi_rlast   <= 1'b1;
                        ar_active     <= 1'b0;
                        s_axi_arready <= 1'b1;
                    end else begin
                        s_axi_rlast <= 1'b0;
                        ar_beat_cnt <= ar_beat_cnt + 1'b1;
                    end
                end
            end else begin
                // Deassert rvalid after handshake
                if (s_axi_rvalid && s_axi_rready) begin
                    s_axi_rvalid <= 1'b0;
                    s_axi_rlast  <= 1'b0;
                end

                // AR handshake
                if (s_axi_arvalid && s_axi_arready) begin
                    ar_id_r       <= s_axi_arid;
                    ar_addr_r     <= s_axi_araddr;
                    ar_len_r      <= s_axi_arlen;
                    ar_size_r     <= s_axi_arsize;
                    ar_burst_r    <= s_axi_arburst;
                    ar_beat_cnt   <= 8'd0;
                    ar_active     <= 1'b1;
                    s_axi_arready <= 1'b0;
                end
            end
        end
    end

endmodule

// ================================================================
// Stub for mult_gen_0: 33x33 signed multiplier, 1-cycle latency
// ================================================================
module mult_gen_0 (
    input  wire        CLK,
    input  wire [32:0] A,
    input  wire [32:0] B,
    output reg  [65:0] P
);
    // 1-cycle pipeline (matches Xilinx mult_gen latency=1)
    wire signed [32:0] a_s = A;
    wire signed [32:0] b_s = B;
    wire signed [65:0] prod = a_s * b_s;
    always @(posedge CLK) begin
        P <= prod;
    end
endmodule

// ================================================================
// Stub for div_gen_0: 32-bit signed divider with AXI-Stream I/F
// Uses non-restoring or simple Verilog division for behavioral sim.
// Latency: configurable — here we use a simple shift-subtract
// approach with ~36-cycle latency to match typical IP settings.
// ================================================================
module div_gen_0 (
    input  wire        aclk,
    input  wire [31:0] s_axis_divisor_tdata,
    input  wire        s_axis_divisor_tvalid,
    input  wire [31:0] s_axis_dividend_tdata,
    input  wire        s_axis_dividend_tvalid,
    output reg  [63:0] m_axis_dout_tdata,
    output reg         m_axis_dout_tvalid
);
    // Internal state
    reg busy;
    reg [5:0] count;
    reg [31:0] dividend_abs;
    reg [31:0] divisor_abs;
    reg        quot_neg;
    reg        rem_neg;

    // Pipeline delay counter (match ~36 cycle latency of IP)
    localparam LATENCY = 36;
    reg [5:0] lat_cnt;
    reg [31:0] saved_dividend;
    reg [31:0] saved_divisor;
    reg        saved_quot_neg;
    reg        saved_rem_neg;
    reg signed [31:0] a_s_div;
    reg signed [31:0] b_s_div;

    always @(posedge aclk) begin
        if (!busy) begin
            m_axis_dout_tvalid <= 1'b0;
            if (s_axis_divisor_tvalid && s_axis_dividend_tvalid) begin
                saved_dividend <= s_axis_dividend_tdata;
                saved_divisor  <= s_axis_divisor_tdata;
                busy    <= 1'b1;
                lat_cnt <= 6'd0;
            end
        end else begin
            if (lat_cnt == LATENCY - 1) begin
                // Compute result using Verilog operators
                // The IP treats inputs as signed (fractional config)
                a_s_div = saved_dividend;
                b_s_div = saved_divisor;
                // Output format: [63:32] = quotient, [31:0] = remainder
                if (b_s_div == 0) begin
                    m_axis_dout_tdata <= 64'd0;
                end else begin
                    m_axis_dout_tdata[63:32] <= a_s_div / b_s_div;
                    m_axis_dout_tdata[31:0]  <= a_s_div % b_s_div;
                end
                m_axis_dout_tvalid <= 1'b1;
                busy <= 1'b0;
            end else begin
                lat_cnt <= lat_cnt + 1'b1;
            end
        end
    end

    initial begin
        busy = 1'b0;
        m_axis_dout_tvalid = 1'b0;
        m_axis_dout_tdata  = 64'd0;
        lat_cnt = 6'd0;
    end
endmodule
