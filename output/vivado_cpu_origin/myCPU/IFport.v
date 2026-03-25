module IFport (
    input  wire        clk,
    input  wire        reset,
    input  wire        valid,
    input  wire [31:0] inst_in,//输入的指令
    input  wire [31:0] pc_in,//输入的pc地址

    output reg         readyGo,
    output reg         allowIn,

    output reg  [31:0] inst_out,
    output reg  [31:0] pc_out
);
// ============================================================
// 模块功能：
// IF 取指阶段。根据 PC 从指令存储器中取出指令，处理分支跳转，
// 完成 PC 更新，并输出指令给 ID 译码阶段。
//
// 端口定义：
// - 时序与握手：
//   - clk     : 时钟信号。
//   - reset   : 复位信号(同步)。
//   - valid   : 当前 IF 级输入有效标志。
// - 地址、指令输入
//   - inst_in : 输入的指令。
//   - pc_in   : 输入的 PC 地址。
//
// - 控制信号输出（送往 IF_ID_reg）：
//   - readyGo : 本级是否已就绪，可向下一级传递数据。
//   - allowIn : 本级是否允许上一级写入新数据。
// - 指令输出（送往 IF_ID_reg）：
//   - inst_out : 取出的 32 位指令。
//   - pc_out   : 当前指令对应的 PC 值（供后续级使用）。
//   
// IF 透传，就是不进行任何处理，直接将输入的 pc_in 和 inst_in 赋给 pc_out 和 inst_out
//
// 工作流程！！！！！！：
// 1. pc_in 直接赋给 pc_out
// 2. pc_out 接到外部指令存储器地址口
// 3.存储器返回指令作为 inst_in
// 4.inst_in 直接赋给 inst_out
// 5.readyGo 和 allowIn 都是常开
//
// TODO：
// 1) 前端： PC 是外部的独立模块，所以为要输入，也输出（所以有pc_in和pc_out）
// 2) 接口：明确 inst_in 来源（直接 SRAM ）。
// 3) 验证：覆盖 reset 后首拍输出与连续取指传递。
// ============================================================
always @(posedge clk) begin
    if (reset) begin
        inst_out <= 32'b0;
        pc_out   <= 32'b0;
        readyGo  <=  1'b1; 
        allowIn  <=  1'b1; 
    end 
    else if (valid) begin
        inst_out <= inst_in; // 直接透传指令
        pc_out   <=   pc_in; // 直接透传 PC
        readyGo  <= 1'b1;    
        allowIn  <= 1'b1;    
    end 
    else if (!valid) begin
        inst_out <=inst_out; // 保持原值
        pc_out   <=  pc_out; // 保持原值
        readyGo  <= 1'b0;    
        allowIn  <= 1'b0;    
    end
    else begin
        inst_out <= 32'b0;
        pc_out   <= 32'b0;
        readyGo  <=  1'b0;    
        allowIn  <=  1'b0;    
    end
end
endmodule
