// ============================================================
// mul 模块（32x32 流水乘法器，推断 DSP 实现，3 级流水）
// ------------------------------------------------------------
// 参考实现说明：
// - 33x33 带符号位扩展统一处理有/无符号（无符号补 0 扩展）；
// - 一级寄存输入 -> 二级乘积寄存 -> 三级输出寄存，固定 3 拍延迟；
// - done_o 用 3 位移位寄存器跟踪 valid_i；
// - 加 use_dsp 属性引导 Vivado 映射 DSP48 级联。
// ============================================================

(* use_dsp = "yes" *)
module mul(
    input  wire          clk,
    input  wire          reset,

    input  wire          valid_i,       // 启动（fu_mdu 保证 busy 期间不重复启动）
    input  wire [31:0]   a_i,
    input  wire [31:0]   b_i,
    input  wire          is_signed_i,   // 1=有符号（mul.w/mulh.w），0=无符号（mulh.wu）

    output wire [63:0]   result_o,      // 64 位全乘积
    output wire          done_o         // 结果有效（启动后固定拍数）
);

localparam MUL_LATENCY = 3;

reg signed [32:0] a33_r;
reg signed [32:0] b33_r;
(* use_dsp = "yes" *) reg signed [65:0] prod_r;
reg        [63:0] result_r;
reg        [MUL_LATENCY-1:0] valid_pipe;

wire signed [32:0] a33 = {is_signed_i & a_i[31], a_i};
wire signed [32:0] b33 = {is_signed_i & b_i[31], b_i};

always @(posedge clk) begin
    if (reset) begin
        a33_r      <= 33'b0;
        b33_r      <= 33'b0;
        prod_r     <= 66'b0;
        result_r   <= 64'b0;
        valid_pipe <= {MUL_LATENCY{1'b0}};
    end else begin
        valid_pipe <= {valid_pipe[MUL_LATENCY-2:0], valid_i};
        if (valid_i) begin
            a33_r <= a33;
            b33_r <= b33;
        end
        prod_r   <= a33_r * b33_r;
        result_r <= prod_r[63:0];
    end
end

assign result_o = result_r;
assign done_o   = valid_pipe[MUL_LATENCY-1];

endmodule
