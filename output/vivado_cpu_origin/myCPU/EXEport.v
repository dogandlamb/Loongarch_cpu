module EXEport (
    input wire        clk,
    input wire        reset,
    input wire        valid,

    input wire  [ 4:0] wb_reg_addr,
    input wire  [31:0] alu_src1,
    input wire  [31:0] alu_src2,
    input wire  [31:0] br_imm,
    input wire  [11:0] alu_op,
    input wire  [ 4:0] br_op,
    input wire  [31:0] mem_wdata_in,
    input wire  [ 1:0] mem_op_in,
    input wire         wb_op_in,


    output reg         readyGo,
    output reg         allowIn,

    output reg         br_taken,

    output reg [31:0] final_result,
    output reg [ 4:0] wb_reg_addr_out,
    output reg [ 1:0] mem_op,
    output reg [31:0] mem_wdata_out,
    output reg        wb_op
);
// ============================================================
// 模块功能：
// EXE 执行阶段。根据译码阶段给出的 ALU/分支控制信息完成运算，
// 生成执行结果、分支是否跳转信号，以及后续 MEM/WB 所需控制信息。
//
// 端口定义：
// - 时序与握手：
//   - clk     : 时钟信号。
//   - reset   : 复位信号。
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
assign br_taken_w =(br_op[1] && (alu_src1 == alu_src2))   // beq
                | (br_op[0] && (alu_src1 != alu_src2))   // bne
                |  br_op[4]                              // jirl
                |  br_op[2]                              // bl
                |  br_op[3];                             // b

always @(posedge clk) begin
    if (reset) begin
        readyGo         <= 1'b1;
        allowIn         <= 1'b1;
        br_taken        <= 1'b0;
        final_result    <= 32'b0;
        wb_reg_addr_out <= 5'b0;
        mem_op          <= 2'b0;
        mem_wdata_out   <= 32'b0;
        wb_op           <= 1'b0;
    end
    else if (valid) begin
        readyGo         <= 1'b1; 
        allowIn         <= 1'b1; 
        br_taken        <= br_taken_w;
        final_result    <= alu_result_w;
        wb_reg_addr_out <= wb_reg_addr;
        mem_op          <= mem_op_in;
        mem_wdata_out   <= mem_wdata_in;
        wb_op           <= wb_op_in;
    end
    else if (!valid) begin
        readyGo         <= 1'b0;
        allowIn         <= 1'b0;
        br_taken        <= 1'b0;
        final_result    <= final_result; 
        wb_reg_addr_out <= wb_reg_addr_out; 
        mem_op          <= mem_op; 
        mem_wdata_out   <= mem_wdata_out; 
        wb_op           <= wb_op; 
    end
    else begin
        readyGo         <= 1'b0;
        allowIn         <= 1'b0;
        br_taken        <= 1'b0;
        final_result    <= 32'b0;
        wb_reg_addr_out <= 5'b0;
        mem_op          <= 2'b0;
        mem_wdata_out   <= 32'b0;
        wb_op           <= 1'b0;
    end
end
endmodule