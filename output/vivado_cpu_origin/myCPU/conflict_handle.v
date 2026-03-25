module conflict_handle(
    input wire        clk,
    input wire        reset,

    input wire        br_conflict,
    input wire        data_conflict_between_ID_EXE,
    input wire        data_conflict_between_ID_MEM,
    input wire        data_conflict_between_ID_WB,

    output reg        block_sig,
    output reg [ 3:0] forward_delivery_sig,
    output reg        cancel_sig
);
//输出分别为阻塞信号，前递信号（其中置一的位为前递的前后寄存器），指令取消信号
always @(posedge clk or posedge reset) begin
    if(reset) block_sig<=0;
    else      block_sig<=( data_conflict_between_ID_EXE 
                         | data_conflict_between_ID_MEM
                         | data_conflict_between_ID_WB);
end

always @(posedge clk or posedge reset) begin
    if(reset) forward_delivery_sig<=0;
    else      forward_delivery_sig<={1'b1,data_conflict_between_ID_EXE,data_conflict_between_ID_MEM,data_conflict_between_ID_WB};
end

always @(posedge clk or posedge reset) begin
    if(reset) cancel_sig<=0;
    else      cancel_sig<=br_conflict;
end
endmodule