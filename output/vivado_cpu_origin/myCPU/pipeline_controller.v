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
);
//逻辑为如果有出现数据冲突就阻塞IF和ID，直到冲突接除；如果出现跳转就取消正在ID和IF阶段的两条指令

always @ (posedge clk or posedge reset)begin
    if(reset) IF_ID_reg_allowIn <= 0;
    else      IF_ID_reg_allowIn <= (!block_sig & ID_allowIn);
end

always @ (posedge clk or posedge reset)begin
    if(reset) ID_EXE_reg_allowIn <= 0;
    else      ID_EXE_reg_allowIn <= (!block_sig & EXE_allowIn);
end

always @ (posedge clk or posedge reset)begin
    if(reset) EXE_MEM_reg_allowIn <= 0;
    else      EXE_MEM_reg_allowIn <= 1'b1;
end

always @ (posedge clk or posedge reset)begin
    if(reset) MEM_WB_reg_allowIn <= 0;
    else      MEM_WB_reg_allowIn <= 1'b1;
end
///////////////////////////////////////////////////////////////////////////
always @ (posedge clk or posedge reset)begin
    if(reset) IF_ID_reg_valid <= 0;
    else      IF_ID_reg_valid <= !cancel_sig;
end

always @ (posedge clk or posedge reset)begin
    if(reset) ID_EXE_reg_valid <= 0;
    else      ID_EXE_reg_valid <= !cancel_sig;
end

always @ (posedge clk or posedge reset)begin
    if(reset) EXE_MEM_reg_valid <= 0;
    else      EXE_MEM_reg_valid <= 1'b1;
end

always @ (posedge clk or posedge reset)begin
    if(reset) MEM_WB_reg_valid <= 0;
    else      MEM_WB_reg_valid <= 1'b1;
end
endmodule