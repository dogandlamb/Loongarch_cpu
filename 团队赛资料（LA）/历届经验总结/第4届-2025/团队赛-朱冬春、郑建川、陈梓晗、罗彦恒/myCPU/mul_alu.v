`timescale 1ns/1ps
`include "defines.vh"

module mul_alu (
    input wire clk,
    input wire rst,

    input wire start,           //乘法运算开始信号
    input wire signed_op,       // 操作数有无符号选择（1表示有符号数，0表示无符号数）
    input wire [31:0] reg1,     // 操作数1
    input wire [31:0] reg2,     // 操作数2

    output wire done,           //乘法运算完成信号
    output wire [63:0] result   // 乘法运算结果
);

    reg [63:0] mul_result;  
    reg valid;

    wire [63:0] reg1_ext;
    wire [63:0] reg2_ext;

    // 符号扩展操处理
    assign reg1_ext = signed_op ? {{32{reg1[31]}}, reg1} : {32'b0, reg1};
    assign reg2_ext = signed_op ? {{32{reg2[31]}}, reg2} : {32'b0, reg2};

    // ??不知道能不能直接乘
    always @(posedge clk) 
    begin
        if(rst)
        begin
            mul_result <= 64'b0;
        end
        else if (start) 
        begin
            mul_result <= $signed(reg1_ext) * $signed(reg2_ext); // 执行乘法运算
        end
    end

    always @(posedge clk) 
    begin
        if (rst)    valid <= 0;
        else        valid <= start ? 1 : 0;
    end

    assign done = valid;            // 当乘法运算完成时，设置done信号
    assign result = mul_result; 

endmodule

