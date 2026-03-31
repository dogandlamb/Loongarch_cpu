// ============================================================
// 模块功能：
// 立即数/分支偏移生成器。根据指令类型选择并扩展不同位宽的立即数字段，
// 输出：
// - alu_imm：ALU 第二操作数相关立即数（含 ui5/si12/si20/si16/si26 及 link 的 +4）。
// - br_imm ：分支目标偏移（仅 si16/si26 左移 2 位后的符号扩展值）。
//
// 端口定义：
// - 输入：
//   - inst：当前指令字。
//   - inst_*：指令类型标志（决定立即数格式与扩展方式）。
// - 输出：
//   - alu_imm：供 `ALU_srcGenerator/IDport` 使用。
//   - br_imm ：供分支跳转目标计算使用。
//
// 与 top 的关系：
// - 由 `IDport` 实例化，输出进入 EXE 级（经 ID_EXE_reg 传递）。
// ============================================================
module imm_generator (
    input wire reset,        // 保留接口（当前为组合逻辑，不直接使用）
    input wire [31:0] inst,
    input wire inst_add_w,
    input wire inst_addi_w,
    input wire inst_sub_w,
    input wire inst_ld_w,
    input wire inst_ld_h,
    input wire inst_ld_b,
    input wire inst_ld_hu,
    input wire inst_ld_bu,
    input wire inst_st_w,
    input wire inst_st_b,
    input wire inst_st_h,
    input wire inst_bne,
    input wire inst_slt,
    input wire inst_sltu,
    input wire inst_and,
    input wire inst_or,
    input wire inst_nor,
    input wire inst_xor,
    input wire inst_slli_w,
    input wire inst_srli_w,
    input wire inst_srai_w,
    input wire inst_b,
    input wire inst_bl,
    input wire inst_beq,
    input wire inst_blt,
    input wire inst_bge,
    input wire inst_bltu,
    input wire inst_bgeu,
    input wire inst_jirl,
    input wire inst_lu12i_w,

    output wire [31:0] alu_imm,
    output wire [31:0] br_imm
);
    
    wire [4:0] ui5;
    wire [11:0] i12;
    wire [15:0] i16;
    wire [19:0] i20;
    wire [25:0] i26;
    
    wire need_ui5;
    wire need_si12;
    wire need_si16;
    wire need_si20;
    wire need_si26;
    wire src2_is_4;
    
    
    assign need_ui5  = inst_slli_w | inst_srli_w | inst_srai_w;
    assign need_si12 = inst_addi_w | inst_ld_w | inst_st_w | inst_st_b 
                     | inst_st_h | inst_ld_h | inst_ld_b | inst_ld_hu | inst_ld_bu;
    assign need_si16 = inst_jirl | inst_beq | inst_bne 
                     | inst_blt | inst_bge | inst_bltu | inst_bgeu;
    assign need_si20 = inst_lu12i_w;
    assign need_si26 = inst_b | inst_bl;
    assign src2_is_4 = inst_jirl | inst_bl;
    
    assign ui5 = inst[14:10];
    assign i12 = inst[21:10];
    assign i16 = inst[25:10];
    assign i20 = inst[24: 5];
    assign i26 = {inst[9: 0] , inst[25:10]};
    
    assign alu_imm = src2_is_4 ? 32'h4               :
    need_si20 ? {i20[19:0] , 12'b0} :
    need_si12 ? {{20{i12[11]}} , i12[11:0]} :
    need_ui5  ? {27'b0 , ui5[4:0]} :
    need_si26 ? {{ 4{i26[25]}} , i26[25:0] , 2'b00}:
    need_si16 ? {{14{i16[15]}} , i16[15:0] , 2'b00}:
    32'b0;

    assign br_imm = need_si26 ? {{ 4{i26[25]}} , i26[25:0] , 2'b00}:
                    need_si16 ? {{14{i16[15]}} , i16[15:0] , 2'b00}:
                    32'b0;
    
endmodule
