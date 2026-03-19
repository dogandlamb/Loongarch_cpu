`timescale 1ns / 1ps

module IF_stage (
    input  wire         cpu_rstn     ,
    input  wire         cpu_clk      ,
    // pipeline control
    input  wire         pause_ifetch ,      // 暂停取指信号
    input  wire         resume_ifetch,      // 恢复取指信号
    input  wire         pl_suspend   ,      // 流水线暂停
    // From BPU
    input  wire         pred_error   ,      // 分支预测错误的标志位
    input  wire [31:0]  pred_target  ,      // 预测的下一条指令的地址
    // From other stages
    input  wire         id_valid     ,      // ID阶段的有效信号
    input  wire         ex_valid     ,      // EX阶段的有效信号
    input  wire [ 1:0]  ex_npc_op    ,      // EX阶段的npc_op，用于控制下一条指令PC值的生成
    input  wire [31:0]  ex_pc        ,      // EX阶段的PC值
    input  wire [31:0]  ex_rD1       ,      // EX阶段的源寄存器1的值
    input  wire [31:0]  ex_ext       ,      // EX阶段的扩展后的立即数
    input  wire         ex_alu_f     ,      // EX阶段的标志位
    // To ID
    output wire         if_valid     ,      // IF阶段有效信号
    output wire [31:0]  if_pc        ,      // IF阶段PC值
    output wire [31:0]  if_npc       ,      // 实际的下一条指令的地址
    // Instruction Fetch Interface
    output wire         ifetch_rreq  ,      // 取指请求信号
    output wire [31:0]  ifetch_addr  ,      // 取指地址
    input  wire         ifetch_valid        // 指令有效信号
);

    reg  rstn_r;
    wire first_req = !rstn_r & cpu_rstn;    // posedge of cpu_rstn
    always @(posedge cpu_clk) rstn_r <= cpu_rstn;

    wire [31:0] pc_reg;     // PC寄存器的值
    assign      if_pc = pred_error ? if_npc : pc_reg;
    
    assign ifetch_rreq = !pause_ifetch & (first_req    |    // 复位后首次取指
                                          ifetch_valid |    // 上一条已取回, 同时立即取下一条
                                          pred_error   |    // 分支预测错误, 立即用正确的地址取指
                                          resume_ifetch);   // 数据访存或乘除运算结束, 继续取指
    assign ifetch_addr = if_pc;
    assign if_valid    = ifetch_rreq;

    PC u_PC (
        .cpu_clk    (cpu_clk    ),
        .cpu_rstn   (cpu_rstn   ),
        .suspend    (pl_suspend ),

        .if_valid   (if_valid   ),
        .din        (pred_target),
        .pc         (pc_reg     )
    );

    NPC u_NPC (
        .cpu_clk    (cpu_clk    ),
        .cpu_rstn   (cpu_rstn   ),
        .id_valid   (id_valid   ),
        .ex_valid   (ex_valid   ),
        .npc_op     (ex_npc_op  ),
        .ex_pc      (ex_pc      ),
        .rj         (ex_rD1     ),
        .offset     (ex_ext     ),
        .br         (ex_alu_f   ), 
        .npc        (if_npc     )
    );

endmodule
