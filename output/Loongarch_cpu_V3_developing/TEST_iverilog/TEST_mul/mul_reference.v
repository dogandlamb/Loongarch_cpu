// ============================================================
// mul 模块（32x32 流水乘法器，推断 DSP 实现，3 级流水）
// ------------------------------------------------------------
// 参考实现说明：
// - 33x33 带符号位扩展统一处理有/无符号（无符号补 0 扩展）；
// - 一级寄存输入 -> 二级乘积寄存 -> 三级输出寄存，固定 3 拍延迟；
// - done_o 用 3 位移位寄存器跟踪 valid_i。
// ============================================================

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

// 第 1 级：符号扩展并寄存输入
reg  signed [32:0] a_r, b_r;
// 第 2 级：DSP 乘积
reg  signed [65:0] prod_r;
// 第 3 级：输出寄存
reg  [63:0] result_r;
// 延迟跟踪
reg  [2:0]  vld_sft;

always @(posedge clk) begin
    if (reset) begin
        vld_sft <= 3'b0;
    end else begin
        vld_sft <= {vld_sft[1:0], valid_i};
    end
end

always @(posedge clk) begin
    a_r      <= {is_signed_i & a_i[31], a_i};
    b_r      <= {is_signed_i & b_i[31], b_i};
    prod_r   <= a_r * b_r;
    result_r <= prod_r[63:0];
end

assign result_o = result_r;
assign done_o   = vld_sft[2];

endmodule
