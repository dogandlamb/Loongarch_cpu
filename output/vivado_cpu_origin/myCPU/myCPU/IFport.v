module IFport (
    input  wire        clk,
    input  wire        reset,
    input  wire        valid,

    input  wire [31:0] pc_1in,
    input  wire [31:0] inst_in,
    input  wire [31:0] pc_2in,
    input  wire        inst_valid_in,//本拍 BRAM 返回是否有效
    input  wire        cancel_in,//本拍返回是否需要丢弃

    output wire        readyGo,
    output wire        allowIn,

    output wire [31:0] pc_1out,
    output wire [31:0] inst_out,
    output wire [31:0] pc_2out
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
//   - pc_1in   : 要发指令读请求对应的PC
//   - inst_in : bram_data_stream_controller返回的指令。
//   - pc_2in   : bram_data_stream_controller返回指令对应的PC
//
//   - inst_valid_in : 本拍指令存储器返回的指令是否有效（用于阻塞控制）。
//   - cancel_in     : 本拍指令是否需要丢弃（用于分支重定向控制）。
// - 控制信号输出（送往 IF_ID_reg）：
//   - readyGo : 本级是否已就绪，可向下一级传递数据。
//   - allowIn : 本级是否允许上一级写入新数据。
// - 指令输出（送往 IF_ID_reg）：
//   - pc_1out   : 送给bram_data_stream_controller的当前指令对应的 PC 值（供后续级使用）。
//   - inst_out  : 最终输出给 IF_ID_reg 的处理后 32 位指令。
//   - pc_2out   : 最终输出给 IF_ID_reg 的处理后当前指令对应的 PC 值。
// ============================================================
// IFport 作为组合透传口，避免与 IF_ID_reg 双重打一拍。

wire   resp_ok;  // 本拍指令是否有效且不需要丢弃

assign resp_ok   = valid && inst_valid_in && !cancel_in;

assign readyGo   = resp_ok;
assign allowIn   = 1'b1;

assign pc_1out   = pc_1in;

assign inst_out = resp_ok ? inst_in : 32'b0;//如果本拍指令无效或者需要丢弃，则输出全0指令（NOP）
assign pc_2out   = resp_ok ? pc_2in   : 32'b0;//如果本拍指令无效或者需要丢弃，则输出全0 PC（对应NOP指令）

endmodule
