`timescale 1ns / 1ps
`include "defines.vh"

module pc
(
    input wire clk,
    input wire rst,
    input wire not_same_page,
    input wire stall,     //停顿信号

    //后端给的分支真实情况
    input wire flush,     //强制更新信号
    input wire [31:0] new_pc, //跳转后更新的pc
    input wire pause,     //暂停信号
    input wire [31:0] pre_addr, //预测的分支地址
    input wire pred_taken, // 确定跳转的信号

    output wire [31:0] pc_out1,
    output wire [31:0] pc_out2,
    output wire inst_rreq_to_icache,
    output reg pc_is_exception,
    output reg [6:0] pc_exception_cause

);
    //pc异常的情况
    wire pc_excp;
    assign pc_excp = (pc_out1[1: 0] != 2'b00);
    assign inst_rreq_to_icache = !rst & !stall & !pause; 

    always @(*) begin
        pc_is_exception = pc_excp;
        pc_exception_cause = (pc_excp ?  `EXCEPTION_ADEF: `EXCEPTION_NOP);
    end

    reg    [31:0] pc1,pc2;

    always @(posedge clk) begin
        if(rst) begin
            pc1 <= 32'h1c000000;
            pc2 <= 32'h1c000004;
        end
        else if(flush) begin
            pc1 <= new_pc;
            pc2 <= new_pc + 4;
        end
        else if(pause) begin
            pc1 <= pc1;
            pc2 <= pc2;
        end
        else if (stall) begin
            pc1 <= pc1;
            pc2 <= pc2;
        end
        else if(pred_taken) begin
            pc1 <= pre_addr;
            pc2 <= pre_addr + 4;
        end
        else if(not_same_page)begin
            pc1 <= pc_out1 + 32'h4;
            pc2 <= pc_out2 + 32'h4;
        end
        else begin
            pc1 <= pc_out1 + 32'h8;
            pc2 <= pc_out2 + 32'h8;
        end
        
    end
    
    assign pc_out1 = pc1;
    assign pc_out2 = pc2;

endmodule
