// ============================================================
// mul 模块（32x32 流水乘法器，DSP 实现，2~3 级流水）
// ------------------------------------------------------------
// 功能：
// - 完成 32x32 -> 64 位有符号/无符号乘法，供 mul.w / mulh.w / mulh.wu 使用。
// - 用 FPGA 的 DSP48 硬核：要么直接写 `a*b` 让综合器推断 DSP 并手动
//   打 2~3 级流水寄存器，要么例化 Vivado mult_gen IP（两种都可以，
//   推断写法对 chiplab/verilator 仿真更友好，推荐）。
//
// 端口：
// - valid_i / a_i / b_i / is_signed_i ：启动一次乘法
// - result_o / done_o                 ：固定 N 拍后结果有效一拍
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

reg signed [32:0] a33_r;
reg signed [32:0] b33_r;
reg signed [65:0] prod_r;
reg        [63:0] result_r;
reg        [2:0]  valid_pipe;

wire signed [32:0] a33 = {is_signed_i & a_i[31], a_i};
wire signed [32:0] b33 = {is_signed_i & b_i[31], b_i};

always @(posedge clk) begin
    if (reset) begin
        a33_r      <= 33'b0;
        b33_r      <= 33'b0;
        prod_r     <= 66'b0;
        result_r   <= 64'b0;
        valid_pipe <= 3'b0;
    end else begin
        valid_pipe <= {valid_pipe[1:0], valid_i};
        if (valid_i) begin
            a33_r <= a33;
            b33_r <= b33;
        end
        prod_r   <= a33_r * b33_r;
        result_r <= prod_r[63:0];
    end
end

assign result_o = result_r;
assign done_o   = valid_pipe[2];

endmodule
