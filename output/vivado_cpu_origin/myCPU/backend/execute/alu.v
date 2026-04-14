`include "../../common/cpu_defs.vh"

// ============================================================
// alu：组合/时序混合的运算单元。
// ============================================================
module alu(
    input  wire                    clk,              // 乘除 IP 时钟
    input  wire                    reset,            // 高有效：清除除法状态机
    input  wire [`ALU_OP_NUM-1:0]  alu_op,
    input  wire [31:0]             alu_src1,
    input  wire [31:0]             alu_src2,
    output wire [31:0]             alu_result,
    output wire                    alu_result_valid  // 多周期指令完成
);

wire op_add;
wire op_sub;
wire op_slt;
wire op_sltu;
wire op_and;
wire op_nor;
wire op_or;
wire op_xor;
wire op_sll;
wire op_srl;
wire op_sra;
wire op_lui;
wire op_mul_w;
wire op_mulh_w;
wire op_mulh_wu;
wire op_div_w;
wire op_div_wu;
wire op_mod_w;
wire op_mod_wu;

assign op_add     = alu_op[`ALU_OP_ADD];
assign op_sub     = alu_op[`ALU_OP_SUB];
assign op_slt     = alu_op[`ALU_OP_SLT];
assign op_sltu    = alu_op[`ALU_OP_SLTU];
assign op_and     = alu_op[`ALU_OP_AND];
assign op_nor     = alu_op[`ALU_OP_NOR];
assign op_or      = alu_op[`ALU_OP_OR];
assign op_xor     = alu_op[`ALU_OP_XOR];
assign op_sll     = alu_op[`ALU_OP_SLL];
assign op_srl     = alu_op[`ALU_OP_SRL];
assign op_sra     = alu_op[`ALU_OP_SRA];
assign op_lui     = alu_op[`ALU_OP_LUI];
assign op_mul_w   = alu_op[`ALU_OP_MUL_W];
assign op_mulh_w  = alu_op[`ALU_OP_MULH_W];
assign op_mulh_wu = alu_op[`ALU_OP_MULH_WU];
assign op_div_w   = alu_op[`ALU_OP_DIV_W];
assign op_div_wu  = alu_op[`ALU_OP_DIV_WU];
assign op_mod_w   = alu_op[`ALU_OP_MOD_W];
assign op_mod_wu  = alu_op[`ALU_OP_MOD_WU];

wire op_mul_any          = op_mul_w | op_mulh_w | op_mulh_wu; // any指任意一个，w、wu...
wire op_div_signed_any   = op_div_w | op_mod_w;
wire op_div_unsigned_any = op_div_wu | op_mod_wu;
wire op_div_any          = op_div_signed_any | op_div_unsigned_any;

wire [31:0] adder_b;
wire        adder_cin;
wire [31:0] adder_result;
wire        adder_cout;

assign adder_b   = (op_sub | op_slt | op_sltu) ? ~alu_src2 : alu_src2;
assign adder_cin = (op_sub | op_slt | op_sltu) ? 1'b1      : 1'b0;
assign {adder_cout, adder_result} = alu_src1 + adder_b + adder_cin;

wire [31:0] add_sub_result = adder_result;
wire [31:0] slt_result     = {31'b0, (alu_src1[31] & ~alu_src2[31])
                               | ((alu_src1[31] ~^ alu_src2[31]) & adder_result[31])}; // ((alu_src1[31] ~^ alu_src2[31]) & adder_result[31]) 是判断符号位是否相同
wire [31:0] sltu_result    = {31'b0, ~adder_cout};
wire [31:0] and_result     = alu_src1 & alu_src2;
wire [31:0] or_result      = alu_src1 | alu_src2;
wire [31:0] nor_result     = ~or_result;
wire [31:0] xor_result     = alu_src1 ^ alu_src2;
wire [31:0] lui_result     = alu_src2;
wire [31:0] sll_result     = alu_src1 << alu_src2[4:0];
wire [63:0] sr64_result    = {{32{op_sra & alu_src1[31]}}, alu_src1} >> alu_src2[4:0];
wire [31:0] sr_result      = sr64_result[31:0];



// ================================乘法部分begin=============================== //
wire [32:0] mul_a = op_mulh_wu ? {1'b0, alu_src1} : {alu_src1[31], alu_src1};
wire [32:0] mul_b = op_mulh_wu ? {1'b0, alu_src2} : {alu_src2[31], alu_src2};
wire [65:0] mul_result_raw;
mult_gen_0 u_mult_gen_0(
    .CLK(clk),
    .A  (mul_a),
    .B  (mul_b),
    .P  (mul_result_raw) // mul_result_raw 是乘法结果，raw指未进行符号扩展的乘法结果
);
wire [31:0] mul_w_result   = mul_result_raw[31:0];
wire [31:0] mulh_w_result  = mul_result_raw[63:32];
wire [31:0] mulh_wu_result = mul_result_raw[63:32];
reg op_mul_any_d; // 用于延迟一个时钟周期的乘法操作标志
always @(posedge clk) begin
    op_mul_any_d <= op_mul_any;
end
// ================================乘法部分end=============================== //



// ================================除法部分begin=============================== //
// 这部分除法部分可以不用仔细看，因为有点复杂-_-
// 因为dogandlamb改过一轮了
wire div_special_zero = op_div_any && (alu_src2 == 32'b0); // 除数为0
wire div_special_signed_overflow = op_div_signed_any
                                && (alu_src1 == 32'h8000_0000)
                                && (alu_src2 == 32'hffff_ffff); // 有符号除法溢出
wire div_special_unsigned_large_divisor = op_div_unsigned_any
                                       && !div_special_zero
                                       && alu_src2[31]; // 无符号除数过大
// 除法特殊情况，将上面三个条件或起来（除数为0、有符号除法溢出、无符号除数过大）
wire div_special_case = div_special_zero
                     || div_special_signed_overflow
                     || div_special_unsigned_large_divisor; 

// 无符号除法使用半宽减法修正（半宽减法就是将除数右移1位，然后与被除数进行减法，如果结果为负数，则商加1，余数为被除数）
wire div_use_half_reduction = op_div_unsigned_any
                           && !div_special_case
                           && alu_src1[31];

reg        div_busy; // 除法是否忙
reg        div_use_half_reduction_reg; // 用于延迟一个时钟周期的半宽减法修正标志
reg [31:0] div_divisor_reg; // 用于延迟一个时钟周期的除数
reg        div_dividend_lsb_reg; // 用于延迟一个时钟周期的被除数最低位

wire        div_in_valid; // 除法输入有效
wire [31:0] div_divisor_data; // 除数数据
wire [31:0] div_dividend_data; // 被除数数据
wire        div_out_valid; // 除法输出有效
wire [63:0] div_out_data; // 除法输出数据

assign div_in_valid      = !div_busy && op_div_any && !div_special_case;
assign div_divisor_data  = alu_src2;
assign div_dividend_data = div_use_half_reduction ? {1'b0, alu_src1[31:1]} : alu_src1;

div_gen_0 u_div_gen_0(
    .aclk                   (clk),
    .s_axis_divisor_tdata   (div_divisor_data),
    .s_axis_divisor_tvalid  (div_in_valid),
    .s_axis_dividend_tdata  (div_dividend_data),
    .s_axis_dividend_tvalid (div_in_valid),
    .m_axis_dout_tdata      (div_out_data),
    .m_axis_dout_tvalid     (div_out_valid)
);

always @(posedge clk) begin
    if (reset) begin
        div_busy                   <= 1'b0;
        div_use_half_reduction_reg <= 1'b0;
        div_divisor_reg            <= 32'b0;
        div_dividend_lsb_reg       <= 1'b0;
    end else if (!div_busy) begin
        if (div_in_valid) begin
            div_busy                   <= 1'b1;
            div_use_half_reduction_reg <= div_use_half_reduction;
            div_divisor_reg            <= alu_src2;
            div_dividend_lsb_reg       <= alu_src1[0];
        end
    end else if (div_out_valid) begin
        div_busy <= 1'b0;
    end
end

wire [31:0] div_ip_quot = div_out_data[63:32];
wire [31:0] div_ip_rem  = div_out_data[31:0];

wire [32:0] div_half_rem_wide = {div_ip_rem, 1'b0} | {{32{1'b0}}, div_dividend_lsb_reg};
wire        div_half_ge       = div_half_rem_wide >= {1'b0, div_divisor_reg};
// 此处 {q,0}+ge 与 {q,0}|{0,ge} 等价（无进位到 bit1），避免 QOR-1「+ 不可合并」
wire [32:0] div_half_quot_wide = {div_ip_quot, 1'b0} | {{32{1'b0}}, div_half_ge};
// 单级减法；33 位结果的高位在 div_half_rem_fix_wide / alu_wide_hi_lint 中显式参与
wire [32:0] div_half_sub_wide = div_half_rem_wide - {1'b0, div_divisor_reg};
wire [32:0] div_half_rem_fix_wide = div_half_ge ? div_half_sub_wide : div_half_rem_wide;

wire [31:0] div_ip_quot_fix = div_use_half_reduction_reg ? div_half_quot_wide[31:0] : div_ip_quot;
wire [31:0] div_ip_rem_fix  = div_use_half_reduction_reg ? div_half_rem_fix_wide[31:0] : div_ip_rem;

wire        div_unsigned_ge = alu_src1 >= alu_src2;
wire [31:0] div_special_quot = div_special_zero ? 32'b0 :
                               div_special_signed_overflow ? 32'h8000_0000 :
                               div_special_unsigned_large_divisor ? {31'b0, div_unsigned_ge} :
                               32'b0;
wire [31:0] div_special_rem  = div_special_zero ? 32'b0 :
                               div_special_signed_overflow ? 32'b0 :
                               div_special_unsigned_large_divisor ? (div_unsigned_ge ? (alu_src1 - alu_src2) : alu_src1) :
                               32'b0;

wire [31:0] div_quot_result = div_special_case ? div_special_quot : div_ip_quot_fix;
wire [31:0] div_rem_result  = div_special_case ? div_special_rem  : div_ip_rem_fix;
wire        div_result_ok   = op_div_any && (div_special_case || div_out_valid);
// ================================除法部分end=============================== //


wire op_alu_1cycle = op_add | op_sub | op_slt | op_sltu | op_and | op_nor
                   | op_or  | op_xor | op_sll | op_srl  | op_sra | op_lui; // 1cycle指单周期操作
wire mul_result_ok = op_mul_any && op_mul_any_d;

assign alu_result_valid = op_alu_1cycle | mul_result_ok | div_result_ok;

wire [31:0] alu_result_mux;
assign alu_result_mux = ({32{op_add | op_sub}} & add_sub_result)
                      | ({32{op_slt}} & slt_result)
                      | ({32{op_sltu}} & sltu_result)
                      | ({32{op_and}} & and_result)
                      | ({32{op_nor}} & nor_result)
                      | ({32{op_or}} & or_result)
                      | ({32{op_xor}} & xor_result)
                      | ({32{op_lui}} & lui_result)
                      | ({32{op_sll}} & sll_result)
                      | ({32{op_srl | op_sra}} & sr_result)
                      | ({32{op_mul_w}} & mul_w_result)
                      | ({32{op_mulh_w}} & mulh_w_result)
                      | ({32{op_mulh_wu}} & mulh_wu_result)
                      | ({32{op_div_w | op_div_wu}} & div_quot_result)
                      | ({32{op_mod_w | op_mod_wu}} & div_rem_result);

// mul_result_raw 在首几拍可为 X；若 alu_wide_hi_lint 参与异或自消去，会把 X 扩散到 alu_result，毒化 addi 等单周期运算
assign alu_result = alu_result_mux;

endmodule
