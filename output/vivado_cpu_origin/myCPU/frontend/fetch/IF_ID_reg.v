// ============================================================
// IF_ID_reg：IF 与 ID 之间的流水寄存器。
// ============================================================
module IF_ID_reg(
    input  wire        clk,
    input  wire        reset,
    input  wire        cancel_sig,         // 分支冲刷（就是置0）
    input  wire        valid,              // 上游 IF级 有效
    input  wire        readyGo,            // IF级可交付
    input  wire        allowIn,            // 下游可接收
    input  wire [31:0] pc_in,              // IF 输出 PC
    input  wire [31:0] inst_in,            // IF 输出指令

    output reg  [31:0] inst_out,           // 送 ID 指令
    output reg  [31:0] pc_out              // 送 ID PC
);

always @(posedge clk) begin
    // 分支冲刷或复位
    if (reset || cancel_sig) begin
        inst_out <= 32'h0;
        pc_out   <= 32'h0;
    end 
    
    // 握手成功：锁存来自 IF 的新指令与 PC
    else if (valid && readyGo && allowIn) begin
        inst_out <= inst_in;
        pc_out   <= pc_in;
    end 
    
    // 上游（IF级）无效：输出清空，避免错误的值向下传递
    else if (!valid) begin
        inst_out <= 32'b0;
        pc_out   <= 32'b0;
    end 
    
    // 下游反压（allowIn为0）或本级未就绪（IF的readyGo为0）：保持
    else if (!readyGo | !allowIn) begin
        inst_out <= inst_out;
        pc_out   <= pc_out;
    end
end

endmodule