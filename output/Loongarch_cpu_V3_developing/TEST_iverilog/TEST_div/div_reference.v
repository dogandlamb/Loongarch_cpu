// ============================================================
// div 模块（CLZ 快速移位除法器，迭代式）
// ------------------------------------------------------------
// 参考实现说明：
// - 符号预处理：有符号转无符号迭代，结束修正符号
//   （商符号 = 两操作数符号异或，余数符号 = 被除数符号）；
// - CLZ 对齐：迭代次数 = clz(divisor)-clz(dividend)+1，跳过无效迭代
//   （小操作数常见 1~10 拍出结果）；
// - 特殊值（与 NEMU 对齐）：
//   除 0     ：商 = 全 1，余数 = 被除数；
//   有符号溢出（0x80000000 / -1）：商 = 0x80000000，余 = 0；
// - flush_i 立即打断迭代（busy 清 0，不产生 done）。
// ============================================================

module div(
    input  wire          clk,
    input  wire          reset,
    input  wire          flush_i,        // 冲刷打断（作废当前迭代）

    input  wire          valid_i,        // 启动
    input  wire [31:0]   dividend_i,     // 被除数
    input  wire [31:0]   divisor_i,      // 除数
    input  wire          is_signed_i,    // 1=有符号

    output wire [31:0]   quotient_o,     // 商
    output wire [31:0]   remainder_o,    // 余数
    output wire          done_o,         // 结果有效一拍
    output wire          busy_o          // 迭代中
);

// 5 级分段 CLZ（返回 0~32）
function [5:0] clz32;
    input [31:0] x;
    reg [31:0] v;
    begin
        clz32 = 6'd0;
        v = x;
        if (v == 32'b0) clz32 = 6'd32;
        else begin
            if (v[31:16] == 16'b0) begin clz32 = clz32 + 6'd16; v = v << 16; end
            if (v[31:24] == 8'b0)  begin clz32 = clz32 + 6'd8;  v = v << 8;  end
            if (v[31:28] == 4'b0)  begin clz32 = clz32 + 6'd4;  v = v << 4;  end
            if (v[31:30] == 2'b0)  begin clz32 = clz32 + 6'd2;  v = v << 2;  end
            if (v[31] == 1'b0)     begin clz32 = clz32 + 6'd1;             end
        end
    end
endfunction

localparam S_IDLE = 2'd0;
localparam S_RUN  = 2'd1;
localparam S_DONE = 2'd2;

reg [1:0]  state;
reg        sign_q, sign_r;          // 商/余数最终符号
reg [31:0] quot;
reg [31:0] rem;
reg [63:0] dvs_sh;                  // 对齐后的除数（随迭代右移）
reg [5:0]  iter_cnt;                // 剩余迭代次数
reg [31:0] quot_out, rem_out;

// 启动拍组合预处理
wire sgn_a = is_signed_i & dividend_i[31];
wire sgn_b = is_signed_i & divisor_i[31];
wire [31:0] abs_a = sgn_a ? (~dividend_i + 1'b1) : dividend_i;
wire [31:0] abs_b = sgn_b ? (~divisor_i + 1'b1) : divisor_i;

wire div_by_zero = (divisor_i == 32'b0);
wire signed_ovf  = is_signed_i && (dividend_i == 32'h8000_0000) && (divisor_i == 32'hffff_ffff);

wire [5:0] clz_a = clz32(abs_a);
wire [5:0] clz_b = clz32(abs_b);
wire       small_dividend = (clz_a > clz_b);    // |a| < |b| -> 商 0 余 a
wire [5:0] shift = clz_b - clz_a;

assign busy_o      = (state == S_RUN);
assign done_o      = (state == S_DONE);
assign quotient_o  = quot_out;
assign remainder_o = rem_out;

wire [63:0] dvs_aligned = {32'b0, abs_b} << shift;

// 迭代比较与减法
wire [63:0] rem_ext  = {32'b0, rem};
wire        ge       = (rem_ext >= dvs_sh);
wire [63:0] rem_next = ge ? (rem_ext - dvs_sh) : rem_ext;

always @(posedge clk) begin
    if (reset || flush_i) begin
        state <= S_IDLE;
    end else begin
        case (state)
            S_IDLE: begin
                if (valid_i) begin
                    sign_q <= sgn_a ^ sgn_b;
                    sign_r <= sgn_a;
                    if (div_by_zero) begin
                        quot_out <= 32'hffff_ffff;
                        rem_out  <= dividend_i;
                        state    <= S_DONE;
                    end else if (signed_ovf) begin
                        quot_out <= 32'h8000_0000;
                        rem_out  <= 32'b0;
                        state    <= S_DONE;
                    end else if (small_dividend) begin
                        quot_out <= 32'b0;
                        rem_out  <= dividend_i;
                        state    <= S_DONE;
                    end else begin
                        rem      <= abs_a;
                        dvs_sh   <= dvs_aligned;
                        quot     <= 32'b0;
                        iter_cnt <= shift + 6'd1;
                        state    <= S_RUN;
                    end
                end
            end
            S_RUN: begin
                rem    <= rem_next[31:0];
                quot   <= {quot[30:0], ge};
                dvs_sh <= dvs_sh >> 1;
                iter_cnt <= iter_cnt - 6'd1;
                if (iter_cnt == 6'd1) begin
                    // 最后一次迭代：符号修正后输出
                    quot_out <= sign_q ? (~{quot[30:0], ge} + 1'b1) : {quot[30:0], ge};
                    rem_out  <= sign_r ? (~rem_next[31:0] + 1'b1)   : rem_next[31:0];
                    state    <= S_DONE;
                end
            end
            S_DONE: begin
                state <= S_IDLE;
            end
            default: state <= S_IDLE;
        endcase
    end
end

endmodule
