`timescale 1ns / 1ps

`include "defines.vh"

module EX_stage (
    input  wire         cpu_rstn     ,
    input  wire         cpu_clk      ,
    // pipeline control
    input  wire         pl_suspend   ,      // 流水线暂停信号
    output reg          ldst_unalign ,      // 访存地址是否不满足对齐条件
    // From ID
    input  wire         id_valid     ,      // ID阶段有效信号
    input  wire [31:0]  id_pc        ,      // ID阶段PC值
    input  wire [ 1:0]  id_npc_op    ,      // ID阶段的npc_op，用于控制下一条指令PC值的生成
    input  wire [31:0]  id_ext       ,      // ID阶段的扩展后的立即数
    input  wire [31:0]  id_real_rD1  ,      // ID阶段的源操作数1的实际值
    input  wire [31:0]  id_real_rD2  ,      // ID阶段的源操作数2的实际值
    input  wire [ 4:0]  id_alu_op    ,      // ID阶段的alu_op，用于控制ALU进行何种运算
    input  wire         id_alua_sel  ,      // ID阶段的ALU操作数A选择信号（选择源寄存器1的值或扩展后的立即数或其他）
    input  wire         id_alub_sel  ,      // ID阶段的ALU操作数B选择信号（选择源寄存器2的值或扩展后的立即数或其他）
    input  wire         id_rf_we     ,      // ID阶段的寄存器写使能（指令需要写回时rf_we为1）
    input  wire [ 4:0]  id_wR        ,      // ID阶段的目标寄存器
    input  wire [ 1:0]  id_wd_sel    ,      // ID阶段的写回数据选择（选择ALU执行结果写回，或选择访存数据写回，etc.）
    input  wire [ 3:0]  id_ram_we    ,      // ID阶段的主存写使能信号（针对store指令）
    input  wire [ 2:0]  id_ram_ext_op,      // ID阶段的读主存数据扩展op，用于控制主存读回数据的扩展方式（针对load指令）
    input  wire         id_is_br_jmp ,      // ID阶段是否是条件分支或直接跳转指令
    // To IF
    output wire [ 1:0]  ex_npc_op    ,      // EX阶段的npc_op，用于控制下一条指令PC值的生成
    output wire         ex_alu_f     ,      // EX阶段的标志位
    output wire         ex_is_ld_st  ,      // EX阶段是否是Load/Store指令
    output wire         ex_is_br_jmp ,      // EX阶段是否是条件分支或直接跳转指令
    output wire         ex_br_jmp_f  ,      // EX阶段分支跳转指令实际是否会发生跳转
    // To MEM
    output wire         ex_valid     ,      // EX阶段有效信号
    output wire [31:0]  ex_pc        ,      // EX阶段PC值
    output wire [31:0]  ex_rD1       ,      // EX阶段的源寄存器1的值
    output wire [31:0]  ex_rD2       ,      // EX阶段的源寄存器2的值
    output wire [31:0]  ex_ext       ,      // EX阶段的扩展后的立即数
    output wire [31:0]  ex_alu_C     ,      // EX阶段的ALU运算结果
    output wire         ex_rf_we     ,      // EX阶段的寄存器写使能（指令需要写回时rf_we为1）
    output wire [ 4:0]  ex_wR        ,      // EX阶段的目的寄存器
    output wire [ 1:0]  ex_wd_sel    ,      // EX阶段的写回数据选择（选择ALU执行结果写回，或选择访存数据写回，etc.）
    output wire [ 3:0]  ex_ram_we    ,      // EX阶段的主存写使能信号（针对store指令）
    output wire [ 2:0]  ex_ram_ext_op,      // EX阶段的读主存数据扩展op，用于控制主存读回数据的扩展方式（针对load指令）
    // Data Forward
    output reg  [31:0]  ex_wd        ,      // EX阶段的待写回数据
    output wire         ex_sel_ram          // EX阶段是否是访存指令 (特指Load指令, 用于Load-Use处理)
);

    wire [ 4:0] ex_alu_op;
    assign      ex_is_ld_st = ex_valid & 1'b0;
    wire        ex_alua_sel, ex_alub_sel;
    wire [31:0] ex_alu_A = ex_alua_sel ? ex_rD1 : ex_pc;
    wire [31:0] ex_alu_B = ex_alub_sel ? ex_rD2 : ex_ext;
    assign      ex_br_jmp_f = 1'b0;
    assign      ex_sel_ram  = 1'b0;

    ID_EX u_ID_EX (
        .cpu_clk        (cpu_clk),
        .cpu_rstn       (cpu_rstn),
        .suspend        (pl_suspend),
        .valid_in       (id_valid),

        .wR_in          (id_wR),
        .pc_in          (id_pc),
        .rD1_in         (id_real_rD1),
        .rD2_in         (id_real_rD2),
        .ext_in         (id_ext),

        .npc_op_in      (id_npc_op),
        .rf_we_in       (id_rf_we & id_valid),
        .wd_sel_in      (id_wd_sel),
        .alu_op_in      (id_alu_op & {5{id_valid}}),
        .alua_sel_in    (id_alua_sel),
        .alub_sel_in    (id_alub_sel),
        .ram_we_in      (id_ram_we & {4{id_valid}}),
        .ram_ext_op_in  (id_ram_ext_op),
        .is_br_jmp_in   (id_is_br_jmp & id_valid),

        .valid_out      (ex_valid),
        .wR_out         (ex_wR),
        .pc_out         (ex_pc),
        .rD1_out        (ex_rD1),
        .rD2_out        (ex_rD2),
        .ext_out        (ex_ext),

        .npc_op_out     (ex_npc_op),
        .rf_we_out      (ex_rf_we),
        .wd_sel_out     (ex_wd_sel),
        .alu_op_out     (ex_alu_op),
        .alua_sel_out   (ex_alua_sel),
        .alub_sel_out   (ex_alub_sel),
        .ram_we_out     (ex_ram_we),
        .ram_ext_op_out (ex_ram_ext_op),
        .is_br_jmp_out  (ex_is_br_jmp)
    );

    ALU u_ALU (
        .alu_op     (ex_alu_op),
        .A          (ex_alu_A ),
        .B          (ex_alu_B ),
        .C          (ex_alu_C ),
        .f          (ex_alu_f )
    );

    always @(*) begin
        case (ex_wd_sel)
            `WD_ALU: ex_wd = ex_alu_C;
            default: ex_wd = 32'h12345678;
        endcase
    end

    // 检查访存地址是否关于 待访问数据大小 对齐, 不对齐则不访存
    always @(*) begin
        case (ex_ram_we)
            default:
                case (ex_ram_ext_op)
                    `RAM_EXT_H : ldst_unalign = (ex_alu_C[1:0] != 2'h0) & (ex_alu_C[1:0] != 2'h2);
                    default    : ldst_unalign = 1'b0;
                endcase
        endcase
    end

endmodule
