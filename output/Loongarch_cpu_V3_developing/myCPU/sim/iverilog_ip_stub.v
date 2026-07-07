// ============================================================
// iverilog 整核 elaboration 用行为级替身
// ------------------------------------------------------------
// alu.v 仍例化 Xilinx mult_gen_0 / div_gen_0（方案 B 过渡），
// 新架构乘除走 fu_mdu + mul.v/div.v。本文件仅供 iverilog 编译
// 检查，不参与 Vivado 综合（sim 目录不加入工程）。
// ============================================================

module mult_gen_0 (
    input  wire        CLK,
    input  wire [32:0] A,
    input  wire [32:0] B,
    output reg  [65:0] P
);
    always @(posedge CLK) begin
        P <= $signed(A) * $signed(B);
    end
endmodule

module div_gen_0 (
    input  wire        aclk,
    input  wire [31:0] s_axis_divisor_tdata,
    input  wire        s_axis_divisor_tvalid,
    input  wire [31:0] s_axis_dividend_tdata,
    input  wire        s_axis_dividend_tvalid,
    output reg  [63:0] m_axis_dout_tdata,
    output reg         m_axis_dout_tvalid
);
    reg        busy;
    reg [31:0] divisor_r;
    reg [31:0] dividend_r;

    always @(posedge aclk) begin
        m_axis_dout_tvalid <= 1'b0;
        if (!busy) begin
            if (s_axis_divisor_tvalid && s_axis_dividend_tvalid) begin
                busy       <= 1'b1;
                divisor_r  <= s_axis_divisor_tdata;
                dividend_r <= s_axis_dividend_tdata;
            end
        end else begin
            if (divisor_r == 32'b0) begin
                m_axis_dout_tdata <= {32'hffff_ffff, dividend_r};
            end else begin
                m_axis_dout_tdata <= {dividend_r / divisor_r, dividend_r % divisor_r};
            end
            m_axis_dout_tvalid <= 1'b1;
            busy <= 1'b0;
        end
    end
endmodule
