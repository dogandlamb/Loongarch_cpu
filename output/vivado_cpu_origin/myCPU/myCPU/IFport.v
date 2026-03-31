module IFport (
    input  wire        clk,
    input  wire        reset,
    input  wire        valid,

    input  wire [31:0] pc_1in,
    input  wire [31:0] inst_in,
    input  wire [31:0] pc_2in,
    input  wire        inst_valid_in,//本拍 BRAM 返回是否有效
    input  wire        cancel_in,//本拍返回是否需要丢弃
    input  wire        downstream_allowIn,// IF/ID 是否可接收

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
// IFport：旁路优先，阻塞时单槽缓存返回，避免 IF/ID 反压期间丢指令返回。

wire   resp_ok;  // 本拍指令是否有效且不需要丢弃
reg    hold_valid;
reg [31:0] hold_inst;
reg [31:0] hold_pc;
wire   out_valid;
wire [31:0] out_inst;
wire [31:0] out_pc;

assign resp_ok   = valid && inst_valid_in && !cancel_in;
assign out_valid = hold_valid | resp_ok;
assign out_inst  = hold_valid ? hold_inst : inst_in;
assign out_pc    = hold_valid ? hold_pc   : pc_2in;

always @(posedge clk) begin
    if (reset || cancel_in) begin
        hold_valid <= 1'b0;
        hold_inst  <= 32'b0;
        hold_pc    <= 32'b0;
    end else begin
        // 下游恢复后消费已缓存返回
        if (hold_valid && downstream_allowIn) begin
            hold_valid <= 1'b0;
        end
        // 仅在下游阻塞且当前有新返回时入缓存（旁路不加额外延迟）
        else if (!hold_valid && !downstream_allowIn && resp_ok) begin
            hold_valid <= 1'b1;
            hold_inst  <= inst_in;
            hold_pc    <= pc_2in;
        end
    end
end

assign readyGo   = out_valid;
assign allowIn   = 1'b1;

assign pc_1out   = pc_1in;

assign inst_out = out_valid ? out_inst : 32'b0;
assign pc_2out  = out_valid ? out_pc   : 32'b0;

endmodule
