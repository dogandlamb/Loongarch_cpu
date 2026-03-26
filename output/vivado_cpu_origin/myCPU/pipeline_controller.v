// ============================================================
// 模块功能：
// 流水控制器。统一输出各级/级间寄存器的 `allowIn` 与 `valid` 信号，
// 与顶层 `block_sig`、`cancel_sig` 协同完成阻塞与冲刷控制。
//
// 端口定义：
// - 输入：
//   - block_sig/cancel_sig：顶层冲突与分支控制信号。
//   - WB/ID/EXE/MEM_allowIn：各级本地允许接收信号。
// - 输出：
//   - IF_ID/ID_EXE/EXE_MEM/MEM_WB_reg_allowIn：级间寄存器写入许可。
//   - IF_ID/ID_EXE/EXE_MEM/MEM_WB_reg_valid   ：级间寄存器输入 valid。
//   - IF/ID/EXE/MEM/WB_valid                  ：各流水级 valid。
//
// 与 top 的联系：
// - 在 `mycpu_top` 中集中驱动所有阶段 valid/allowIn，属于全局控制核心。
// ============================================================
module pipeline_controller(
    input wire        clk,
    input wire        reset,

    input wire        block_sig,
    input wire        cancel_sig,

    input wire        WB_allowIn,
    input wire        ID_allowIn,
    input wire        EXE_allowIn,
    input wire        MEM_allowIn,

    output reg        IF_ID_reg_allowIn,
    output reg        ID_EXE_reg_allowIn,
    output reg        EXE_MEM_reg_allowIn,
    output reg        MEM_WB_reg_allowIn,

    output reg        IF_ID_reg_valid,
    output reg        ID_EXE_reg_valid,
    output reg        EXE_MEM_reg_valid,
    output reg        MEM_WB_reg_valid,

    output reg        IF_valid,
    output reg        ID_valid,
    output reg        EXE_valid,
    output reg        MEM_valid,
    output reg        WB_valid
);
//逻辑为如果有出现数据冲突就阻塞IF和ID，直到冲突接除；如果出现跳转就取消正在ID和IF阶段的两条指令

always @(*) begin
    IF_ID_reg_allowIn = (!reset) && (!block_sig) && ID_allowIn;
end

// 阻塞时在 ID/EXE 边界插入气泡：流水寄存器仍接收写使能，数据由顶层 mux 置 nop
always @ (posedge clk)begin
    if(reset) ID_EXE_reg_allowIn <= 0;
    else      ID_EXE_reg_allowIn <= EXE_allowIn;
end

always @ (posedge clk)begin
    if(reset) EXE_MEM_reg_allowIn <= 0;
    else      EXE_MEM_reg_allowIn <= 1'b1;
end

always @ (posedge clk)begin
    if(reset) MEM_WB_reg_allowIn <= 0;
    else      MEM_WB_reg_allowIn <= 1'b1;
end
///////////////////////////////////////////////////////////////////////////
always @ (posedge clk)begin
    if(reset) IF_ID_reg_valid <= 0;
    else      IF_ID_reg_valid <= 1'b1;
end

// ID/EXE 流水寄存器 valid 常 1；分支冲刷仅清 IF/ID，气泡由顶层 stall mux 插入
always @ (posedge clk)begin
    if(reset) ID_EXE_reg_valid <= 0;
    else      ID_EXE_reg_valid <= 1'b1;
end

always @ (posedge clk)begin
    if(reset) EXE_MEM_reg_valid <= 0;
    else      EXE_MEM_reg_valid <= 1'b1;
end

always @ (posedge clk)begin
    if(reset) MEM_WB_reg_valid <= 0;
    else      MEM_WB_reg_valid <= 1'b1;
end

////////////////////////////////////////////////////////////////////
// valid信号的输出控制逻辑
// 如果出现数据冲突就阻塞IF和ID，直到冲突接除；如果出现跳转就取消正在ID和IF阶段的两条指令

always @ (posedge clk)begin
    if(reset) IF_valid <= 0;
    else      IF_valid <= 1'b1;
end

always @ (posedge clk)begin
    if(reset) ID_valid <= 0;
    else      ID_valid <= 1'b1;
end

always @ (posedge clk)begin
    if(reset) EXE_valid <= 0;
    else      EXE_valid <= 1'b1;
end

always @ (posedge clk)begin
    if(reset) MEM_valid <= 0;
    else      MEM_valid <= 1'b1;
end

always @ (posedge clk)begin
    if(reset) WB_valid <= 0;
    else      WB_valid <= 1'b1;
end

endmodule