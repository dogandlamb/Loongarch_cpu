`include "cpu_defs.vh"

module alu(
    input  wire                    clk,              // 乘除法 IP 使用时钟
    input  wire [`ALU_OP_NUM-1:0]  alu_op,
    input  wire [31:0]             alu_src1,
    input  wire [31:0]             alu_src2,
    output wire [31:0]             alu_result,
    output wire                    alu_result_valid  // 结果有效，mul/div.w 会拉低直到完成
);

/////////////////////////////////////////////
// 计算操作标志位
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

////////////////////////////////////////////////
// 操作译码
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


wire op_mul_any = op_mul_w | op_mulh_w | op_mulh_wu;

//////////////////////////////////////////////////
// 组合运算部分
wire [31:0] add_sub_result;
wire [31:0] slt_result;
wire [31:0] sltu_result;
wire [31:0] and_result;
wire [31:0] nor_result;
wire [31:0] or_result;
wire [31:0] xor_result;
wire [31:0] lui_result;
wire [31:0] sll_result;
wire [63:0] sr64_result;
wire [31:0] sr_result;


wire [31:0] adder_a;
wire [31:0] adder_b;
wire        adder_cin;
wire [31:0] adder_result;
wire        adder_cout;

assign adder_a   = alu_src1;
assign adder_b   = (op_sub | op_slt | op_sltu) ? ~alu_src2 : alu_src2;
assign adder_cin = (op_sub | op_slt | op_sltu) ? 1'b1      : 1'b0;
assign {adder_cout, adder_result} = adder_a + adder_b + adder_cin;

assign add_sub_result = adder_result;
assign slt_result     = {31'b0, (alu_src1[31] & ~alu_src2[31])
                          | ((alu_src1[31] ~^ alu_src2[31]) & adder_result[31])};
assign sltu_result    = {31'b0, ~adder_cout};
assign and_result     = alu_src1 & alu_src2;
assign or_result      = alu_src1 | alu_src2;
assign nor_result     = ~or_result;
assign xor_result     = alu_src1 ^ alu_src2;
assign lui_result     = alu_src2;
assign sll_result     = alu_src1 << alu_src2[4:0];
assign sr64_result    = {{32{op_sra & alu_src1[31]}}, alu_src1[31:0]} >> alu_src2[4:0];
assign sr_result      = sr64_result[31:0];


//////////////////////////////////////////////////
// 乘法 IP：mult_gen_0（PipeStages=1，P 比输入晚 1 拍）
wire [32:0] mul_a = op_mulh_wu ? {1'b0, alu_src1} : {alu_src1[31], alu_src1};
wire [32:0] mul_b = op_mulh_wu ? {1'b0, alu_src2} : {alu_src2[31], alu_src2};
wire [65:0] mul_result_raw;

mult_gen_0 u_mult_gen_0(
    .CLK(clk),
    .A  (mul_a),
    .B  (mul_b),
    .P  (mul_result_raw)
);

// 与 33×33 有符号乘法一致：低 64 位为 32×32 有符号全宽积（mulh_wu 为零扩展 33 位，积的高 32 位）
wire [31:0] mul_w_result   = mul_result_raw[31:0];
wire [31:0] mulh_w_result  = mul_result_raw[63:32];
wire [31:0] mulh_wu_result = mul_result_raw[63:32];

reg op_mul_any_d;
always @(posedge clk) begin
    op_mul_any_d <= op_mul_any;
end

//////////////////////////////////////////////////
// 除法 IP：div_gen_0（仅 div.w；div.wu 为无符号，与 Signed IP 语义不同，仍用组合）
wire [31:0] div_divisor_data  = alu_src2;
wire [31:0] div_dividend_data = alu_src1;
reg         div_in_valid;
wire        div_out_valid;
wire [63:0] div_out_data;

div_gen_0 u_div_gen_0(
    .aclk                   (clk),
    .s_axis_divisor_tdata   (div_divisor_data),
    .s_axis_divisor_tvalid  (div_in_valid),
    .s_axis_dividend_tdata  (div_dividend_data),
    .s_axis_dividend_tvalid (div_in_valid),
    .m_axis_dout_tdata      (div_out_data),
    .m_axis_dout_tvalid     (div_out_valid)
);

localparam DIV_ST_IDLE = 1'b0;
localparam DIV_ST_WAIT = 1'b1;
reg div_st;
reg [31:0] div_w_quot_reg;
reg [31:0] div_w_rem_reg;

initial begin
    div_st = DIV_ST_IDLE;
    div_w_quot_reg = 32'b0;
    div_w_rem_reg  = 32'b0;
    div_in_valid   = 1'b0;
end

always @(posedge clk) begin
    div_in_valid <= 1'b0;
    case (div_st)
        DIV_ST_IDLE: begin
            if (op_div_w | op_mod_w) begin
                div_in_valid <= 1'b1;
                div_st       <= DIV_ST_WAIT;
            end
        end
        DIV_ST_WAIT: begin
            if (div_out_valid) begin
                div_w_quot_reg <= div_out_data[31:0];
                div_w_rem_reg  <= div_out_data[63:32];
                div_st         <= DIV_ST_IDLE;
            end
        end
        default: div_st <= DIV_ST_IDLE;
    endcase
end

wire [31:0] div_w_quot  = div_w_quot_reg;
wire [31:0] div_w_rem   = div_w_rem_reg;
wire [31:0] div_wu_quot = (alu_src2 == 32'b0) ? 32'b0
                         : ($unsigned(alu_src1) / $unsigned(alu_src2));
wire [31:0] div_wu_rem  = (alu_src2 == 32'b0) ? 32'b0
                         : ($unsigned(alu_src1) % $unsigned(alu_src2));

//////////////////////////////////////////////////
// 输出有效控制
wire op_alu_1cycle = op_add | op_sub | op_slt | op_sltu | op_and | op_nor | op_or | op_xor
                   | op_sll | op_srl | op_sra | op_lui | op_div_wu | op_mod_wu;

wire mul_result_ok = op_mul_any && op_mul_any_d;

wire div_w_result_ok = (div_st == DIV_ST_WAIT) && div_out_valid;

assign alu_result_valid = op_alu_1cycle
                        | mul_result_ok
                        | ((op_div_w | op_mod_w) ? div_w_result_ok : 1'b0);

//////////////////////////////////////////////////
// 结果选择，总输出
assign alu_result = ({32{op_add | op_sub}} & add_sub_result)
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
                  | ({32{op_div_w}} & div_w_quot)
                  | ({32{op_div_wu}} & div_wu_quot)
                  | ({32{op_mod_w}} & div_w_rem)
                  | ({32{op_mod_wu}} & div_wu_rem);

endmodule
