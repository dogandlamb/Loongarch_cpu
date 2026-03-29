module EXEport (
    input wire        valid,

    input wire  [ 4:0] wb_reg_addr,
    input wire  [31:0] alu_src1,
    input wire  [31:0] alu_src2,
    input wire  [31:0] pc_in,
    input wire  [31:0] br_imm,
    input wire  [ALU_OP_NUM-1 :0] alu_op,
    input wire  [BR_OP_NUM-1  :0] br_op,
    input wire  [31:0] mem_wdata_in,
    input wire  [ 1:0] mem_op_in,
    input wire         wb_op_in,


    output wire        readyGo,
    output wire        allowIn,

    output wire        br_taken,

    output wire [31:0]  final_result,
    output wire [31:0]  pc_out,
    output wire [ 4:0]  wb_reg_addr_out,
    output wire [ 1:0]  mem_op,
    output wire [31:0]  mem_wdata_out,
    output wire         wb_op,

    output wire data_we_from_EXE,
    output wire data_re_from_EXE,

    output wire [31:0] pc_from_IF,
    output wire [31:0] data_raddr_from_EXE,
    output wire [31:0] data_waddr_from_EXE,
    output wire [31:0] data_wdata_from_EXE
);
// ============================================================
// 模块功能：
// EXE 执行阶段。根据译码阶段给出的 ALU/分支控制信息完成运算，
// 生成执行结果、分支是否跳转信号，以及后续 MEM/WB 所需控制信息。
//
// 端口定义：
// - 时序与握手：
//   - valid   : 当前 EXE 级输入有效。
//   - readyGo : 本级是否已就绪，可向下一级传递数据。
//   - allowIn : 本级是否允许上一级写入新数据（通常受下一级反压影响）。
// - 分支输出：
//   - br_taken : 分支是否成立（供前端重定向 PC 参考）。
// - 输入（来自 ID/ID_EXE_reg）：
//   - wb_reg_addr : 目的寄存器地址。
//   - alu_src1    : ALU 源操作数 1。
//   - alu_src2    : ALU 源操作数 2。
//   - br_imm      : 分支立即数/偏移量。
//   - alu_op      : ALU 操作控制码。
//   - br_op       : 分支类型控制码。
// - 输出（送往 EXE_MEM_reg）：
//   - final_result   : 执行阶段输出结果。
//   - wb_reg_addr_out: 目的寄存器地址透传/修正值。
//   - mem_op         : 访存操作类型（供 MEM 阶段使用）。
//   - wb_op          : 写回使能标志。
//
// TODO：
// 1) ALU ：按 alu_op 实现运算组合逻辑并输出 final_result。
// 2) 分支：按 br_op 实现分支判定并驱动 br_taken。
// 3) 控制：完善 mem_op/wb_op 透传或重编码策略。
// 4) 流水：确定 readyGo/allowIn 策略（本阶段可先固定常开）。
// 5) 验证：补齐 EXE 基本算术/逻辑/分支用例。
// ============================================================
// output declaration of module alu
wire [31:0] alu_result_w;
wire        br_taken_w;
wire [31:0] link_pc4_w;

alu u_alu(
    .alu_op     	(alu_op      ),
    .alu_src1   	(alu_src1    ),
    .alu_src2   	(alu_src2    ),
    .alu_result 	(alu_result_w)  
);

//inst_b 无条件跳转到目标地址，地址偏移值为i26offs26逻辑左移两位再符号拓展
//inst_bl 无条件跳转到目标地址，偏移值同上，同时将该指令的pc＋4存到rl
//inst_beq rjrd相等跳转目标地址
//inst_jirl 无条件跳转到目标地址，将pc值加＋存到rd，目标地址为i16offs16逻辑左移两位后再符号拓展加rj的值
//inst_bne 将通用寄存器 rj 和通用寄存器 rd 的值进行比较，如果两者不等则跳转到目标地址，否则不跳转。
//assign br_op  = {inst_jirl , inst_b , inst_bl , inst_beq , inst_bne};
assign br_taken_w =(br_op[BR_OP_JIRL] && (alu_src1 == alu_src2))   // beq
                | (br_op[BR_OP_BEQ] && (alu_src1 != alu_src2))   // bne
                |  br_op[BR_OP_B]                              // jirl
                |  br_op[BR_OP_BNE]                              // bl
                |  br_op[BR_OP_BL];                             // b

assign readyGo       = 1'b1;
assign allowIn       = 1'b1;

assign br_taken        = valid && br_taken_w;
assign link_pc4_w      = pc_in + 32'd4;

assign  final_result    = valid ? ((br_op[4] | br_op[2]) ? link_pc4_w : alu_result_w) : 1'b0;
assign  pc_out          = valid ? pc_in : 32'b0;
assign  wb_reg_addr_out = valid ? wb_reg_addr : 5'b0;
assign  mem_op          = valid ? mem_op_in : 2'b0;
assign  mem_wdata_out   = valid ? mem_wdata_in : 32'b0;
assign  wb_op           = valid ? wb_op_in : 1'b0;

assign data_w_we_from_EXE = valid ? mem_op[MEM_OP_LD_W] : 1'b0;
assign data_r_we_from_EXE = valid ? mem_op[MEM_OP_ST_W] : 1'b0;
     
assign data_raddr_from_EXE = valid ? final_result : 32'b0; 
assign data_waddr_from_EXE = valid ? final_result : 32'b0;
assign data_wdata_from_EXE = valid ? mem_wdata_in : 32'b0;

endmodule