`timescale 1ns / 1ps

`include "defines.vh"

module ID_stage (
    input  wire         cpu_rstn     ,
    input  wire         cpu_clk      ,
    // pipeline control
    input  wire         pl_suspend   ,      // 流水线暂停
    input  wire         pred_error   ,      // 分支预测错误的标志位
    input  wire         fd_rD1_sel   ,      // 源操作数1选择信号（选择前递数据或源寄存器1的值）
    input  wire [31:0]  fd_rD1       ,      // 前递到ID阶段的源操作数1
    input  wire         fd_rD2_sel   ,      // 源操作数2选择信号（选择前递数据或源寄存器1的值）
    input  wire [31:0]  fd_rD2       ,      // 前递到ID阶段的源操作数2
    // From IF and WB
    input  wire         if_valid     ,      // IF阶段有效信号
    input  wire [31:0]  if_pc        ,      // IF阶段PC值
    input  wire [31:0]  if_npc       ,      // IF阶段的下一条指令PC值
    input  wire         wb_rf_we     ,      // WB阶段的寄存器写使能
    input  wire [ 4:0]  wb_wR        ,      // WB阶段的目的寄存器
    input  wire [31:0]  wb_wd        ,      // WB阶段的写回数据
    // To IF
    output wire         id_is_ld_st  ,      // ID阶段是否是Load/Store指令
    // To EX
    output wire         id_valid     ,      // ID阶段有效信号
    output wire [31:0]  id_pc        ,      // ID阶段PC值
    output wire [ 1:0]  id_npc_op    ,      // ID阶段的npc_op，用于控制下一条指令PC值的生成
    output wire [31:0]  id_ext       ,      // ID阶段的扩展后的立即数
    output wire [31:0]  id_real_rD1  ,      // ID阶段的源操作数1的实际值
    output wire [31:0]  id_real_rD2  ,      // ID阶段的源操作数2的实际值
    output wire [ 4:0]  id_alu_op    ,      // ID阶段的alu_op，用于控制ALU进行何种运算
    output wire         id_alua_sel  ,      // ID阶段的ALU操作数A选择信号（选择源寄存器1的值或扩展后的立即数或其他）
    output wire         id_alub_sel  ,      // ID阶段的ALU操作数B选择信号（选择源寄存器2的值或扩展后的立即数或其他）
    output wire         id_rf_we     ,      // ID阶段的寄存器写使能（指令需要写回时rf_we为1）
    output wire [ 4:0]  id_wR        ,      // ID阶段的目标寄存器
    output wire [ 1:0]  id_wd_sel    ,      // ID阶段的写回数据选择（选择ALU执行结果写回，或选择访存数据写回，etc.）
    output wire [ 3:0]  id_ram_we    ,      // ID阶段的主存写使能信号（针对store指令）
    output wire [ 2:0]  id_ram_ext_op,      // ID阶段的读主存数据扩展op，用于控制主存读回数据的扩展方式（针对load指令）
    output wire         id_is_br_jmp ,      // ID阶段是否是条件分支或直接跳转指令
    // Data Forward
    output wire [ 4:0]  id_rR1       ,      // 从指令码中解析出源寄存器1的编号/地址
    output wire         id_rR1_re    ,      // ID阶段的源寄存器1读标志信号（有效时表示指令需要从源寄存器1读取操作数）
    output wire [ 4:0]  id_rR2       ,      // 从指令码中解析出源寄存器2的编号/地址
    output wire         id_rR2_re    ,      // ID阶段的源寄存器2读标志信号（有效时表示指令需要从源寄存器2读取操作数）
    // Instruction Fetch Interface
    input  wire         ifetch_valid ,      // 指令机器码有效信号
    input  wire [31:0]  ifetch_inst         // 指令机器码
);

    assign      id_valid = ifetch_valid & !pred_error;
    wire [31:0] id_inst  = ifetch_inst;
    wire [ 2:0] id_ext_op;
    wire        id_r2_sel, id_wr_sel;
    assign      id_rR1 = id_inst[9:5];
    assign      id_rR2 = id_r2_sel ? id_inst[14:10] : id_inst[4:0];
    assign      id_wR  = id_wr_sel ? id_inst[4:0] : 5'h1;
    wire [31:0] id_rD1, id_rD2;
    assign      id_real_rD1 = fd_rD1_sel ? fd_rD1 : id_rD1;
    assign      id_real_rD2 = fd_rD2_sel ? fd_rD2 : id_rD2;
    assign      id_is_ld_st = id_valid & (id_wd_sel == `WD_RAM);

    IF_ID u_IF_ID (
        .cpu_clk    (cpu_clk   ),
        .cpu_rstn   (cpu_rstn  ),
        .suspend    (pl_suspend),

        .valid_in   (if_valid  ),
        .pc_in      (if_pc     ),
        .pc_out     (id_pc     )
    );

    CU u_CU (
        .inst_31_15 (id_inst[31:15]),
        .npc_op     (id_npc_op     ),
        .is_br_jmp  (id_is_br_jmp  ),
        .ext_op     (id_ext_op     ),
        .r2_sel     (id_r2_sel     ),
        .rR1_re     (id_rR1_re     ),
        .rR2_re     (id_rR2_re     ),
        .alua_sel   (id_alua_sel   ),
        .alub_sel   (id_alub_sel   ),
        .alu_op     (id_alu_op     ),
        .ram_ext_op (id_ram_ext_op ),
        .ram_we     (id_ram_we     ),
        .rf_we      (id_rf_we      ),
        .wr_sel     (id_wr_sel     ),
        .wd_sel     (id_wd_sel     )
    );

    RF u_RF(
        .cpu_clk    (cpu_clk ),
        .rR1        (id_rR1  ),
        .rR2        (id_rR2  ),
        .we         (wb_rf_we),
        .wR         (wb_wR   ),
        .wD         (wb_wd   ),
        .rD1        (id_rD1  ),
        .rD2        (id_rD2  )
    );
    
    EXT u_EXT(
        .ext_op     (id_ext_op    ),
        .din        (id_inst[25:0]),
        .ext        (id_ext       )
    );

endmodule
