`include "cpu_defs.vh"

module IDport (
    input  wire        clk,
    input  wire        reset,
    input  wire        valid,
    input  wire        stall,

    input  wire [31:0] inst,
    input  wire [31:0] src1_rdata,
    input  wire [31:0] src2_rdata,

    input  wire [31:0] pc_in,

    output reg         allowIn,
    output reg         readyGo,

    output reg  [4:0]  src1_addr,
    output reg  [4:0]  src2_addr,

    output reg  [4:0]  wb_reg_addr,
    output reg  [31:0] alu_src1,
    output reg  [31:0] alu_src2,
    output reg  [31:0] br_imm,
    output reg  [`ALU_OP_NUM-1:0] alu_op,
    output reg  [`BR_OP_NUM-1:0]  br_op,
    output reg  [`MEM_OP_NUM-1:0] mem_op,
    output reg  [31:0] mem_wdata,
    output reg         wb_op,
    output reg  [31:0] pc_out
);
// ============================================================
// 模块功能：
// ID 译码阶段。输入指令后完成寄存器地址解析、立即数/分支信息生成、
// ALU 控制信号生成，并输出给 EXE 前级寄存器。
//
// 端口定义：
// - 时序与握手：
//   - clk     : 时钟信号。
//   - reset   : 复位信号。
//   - valid   : 当前 ID 级输入有效标志。
//   - stall   : RAW 阻塞插泡信号（仅清空送 EXE 的控制/数据，不清读地址）。
//   - allowIn : 本级是否允许上一级写入新数据。
//   - readyGo : 本级是否已就绪，可向下一级传递数据。
// - 输入：
//   - inst : 待译码的 32 位指令。
//   - src1_rdata : 源寄存器 1 读数据（来自 regfile）。
//   - src2_rdata : 源寄存器 2 读数据（来自 regfile）。
// - 输出（寄存器读地址）：
//   - src1_addr : 源寄存器 1 地址（读寄存器堆端口 A）。
//   - src2_addr : 源寄存器 2 地址（读寄存器堆端口 B）。
// - 输出（送往 EXE）：
//   - wb_reg_addr : 目的寄存器地址。
//   - alu_src1    : ALU 源操作数 1。
//   - alu_src2    : ALU 源操作数 2。
//   - br_imm      : 分支立即数/偏移量。
//   - alu_op      : ALU 操作控制码。
//   - br_op       : 分支控制码。
//   - mem_op      : 访存控制。
//   - wb_op       : 写回使能控制。
//
// TODO：
// 1) 译码：补全指令覆盖并维护 inst_dec/op_dec 对齐关系（就是位宽对齐）。
// 2) 数据：完善 mem_op/wb_op 编码规范文档。
// 3) 流水：在需要时接入真实反压（当前可先常开）。
// 4) 验证：指令到控制信号的一致性。
// ============================================================
// 时序规则：
// 1. 同步复位时，本级输出全部清零。
// 2. valid=0 时，内部数据保持，readyGo/allowIn 拉低。
// 3. valid=1 时，正常译码并锁存输出。
// ============================================================
////////////////////////////////////////////////
//以下为指令标志
wire inst_add_w;     //rj+rk写入rd
wire inst_addi_w;    //rj+12位立即数扩展为32位，写入rd
wire inst_slti;      //有符号立即数比较
wire inst_sltui;     //无符号立即数比较
wire inst_andi;      //按位与立即数
wire inst_xori;      //按位异或立即数
wire inst_sub_w;     //rj-rk写入rd
wire inst_ld_w;      //从内存中取出32位，存入rd
wire inst_ld_h;      //从内存中取出16位，存入rd
wire inst_ld_b;      //从内存中取出8位，存入rd
wire inst_ld_hu;     //从内存中取出16位，无符号扩展后存入rd
wire inst_ld_bu;     //从内存中取出8位，无符号扩展后存入rd
wire inst_st_w;      //word访问内存，32位数据，目标地址为rj寄存器数据加上12位立即数扩展到32位的结果之和，储存数据为rd寄存器的数据
wire inst_st_b;      //byte访问内存，8位数据，目标地址同上，储存数据同inst_st_w, 但只存入内存地址对应的8位
wire inst_st_h;      //half访问内存，16位数据，目标地址同上，储存数据同inst_st_w，但只存入内存地址对应的16位
wire inst_bne;       //rj!=rk跳转目标地址
wire inst_slt;       //有符号数比较，src1<src2为1，否则为0
wire inst_sltu;      //无符号数比较，同上

wire inst_and;       //与，rj&rk写入rd
wire inst_or;        //或，rj|rk写入rd
wire inst_nor;       //同或，~(rj|rk)写入rd
wire inst_xor;       //异或，rj^rk写入rd

wire inst_slli_w;    //rj数据逻辑左移ui5，存入rd
wire inst_srli_w;    //rj数据逻辑右移ui5，存入rd
wire inst_srai_w;    //rj数据算术右移ui5，存入rd
wire inst_sll_w;     //rj数据逻辑左移rk[4:0]
wire inst_srl_w;     //rj数据逻辑右移rk[4:0]
wire inst_sra_w;     //rj数据算术右移rk[4:0]
    
wire inst_b;         //无条件跳转到目标地址，地址偏移值为i26offs26逻辑左移两位再符号拓展
wire inst_bl;        //无条件跳转到目标地址，偏移值同上，同时将该指令的pc＋4存到rl
wire inst_beq;       //rjrd相等跳转目标地址
wire inst_blt;       //有符号数比较，src1<src2跳转目标地址
wire inst_bge;       //有符号数比较，src1>=src2跳转目标地址
wire inst_bltu;      //无符号数比较，src1<src2跳
wire inst_bgeu;      //无符号数比较，src1>=src2跳转目标地址
wire inst_jirl;      //无条件跳转到目标地址，将pc值加＋存到rd，目标地址为i16offs16逻辑左移两位后再符号拓展加rj的值
wire inst_lu12i_w;   //用于将20位bit立即数链接上12bit0后写入rd
wire inst_pcaddu12i; //rd <- pc + (si20<<12)
wire inst_ori;       //ori: rj | ui12 -> rd
wire inst_mul_w;     //乘法
wire inst_mulh_w;    //有符号乘法高位结果
wire inst_mulh_wu;   //有符号/无符号混合乘法高位结果
wire inst_div_w;     //有符号除法
wire inst_div_wu;    //无符号除法
wire inst_mod_w;     //有符号取余
wire inst_mod_wu;    //无符号取余

wire [`ALU_OP_NUM-1:0] alu_op_inner; //内部ALU操作码，后续看条件赋值给output alu_op
wire [`BR_OP_NUM-1:0]  br_op_inner;  //内部分支跳转操作码，后续看条件赋值给output br_op
wire [`MEM_OP_NUM-1:0] mem_op_inner; //内部访存操作码，后续看条件赋值给output mem_op
wire [31:0]            alu_imm_w;
wire [31:0]            br_imm_w;
wire [31:0]            alu_src1_w;
wire [31:0]            alu_src2_w;
wire [4:0]             rf_raddr1_w;
wire [4:0]             rf_raddr2_w;

assign inst_ori = (inst[31:26] == 6'h00) && (inst[25:22] == 4'he);
wire wb_op_w;
assign wb_op_w = inst_add_w | inst_addi_w | inst_sub_w | inst_ld_w
               | inst_slt   | inst_sltu   | inst_and   | inst_or
               | inst_nor   | inst_xor    | inst_slli_w| inst_srli_w
               | inst_srai_w| inst_sll_w  | inst_srl_w | inst_sra_w
               | inst_lu12i_w| inst_pcaddu12i | inst_bl | inst_jirl
               | inst_slti  | inst_sltui  | inst_andi  | inst_xori
               | inst_ori    | inst_mul_w  | inst_mulh_w
               | inst_mulh_wu| inst_div_w  | inst_div_wu
               | inst_mod_w | inst_mod_wu
               | inst_ld_h   | inst_ld_b   | inst_ld_hu  | inst_ld_bu; 

inst_dec u_inst_dec(
    .reset        (reset),
    .inst         (inst),
    .inst_add_w   (inst_add_w),
    .inst_addi_w  (inst_addi_w),
    .inst_slti    (inst_slti),
    .inst_sltui   (inst_sltui),
    .inst_andi    (inst_andi),
    .inst_ori     (inst_ori),
    .inst_xori    (inst_xori),
    .inst_sub_w   (inst_sub_w),
    .inst_ld_w    (inst_ld_w),
    .inst_ld_h    (inst_ld_h),
    .inst_ld_b    (inst_ld_b),
    .inst_ld_hu   (inst_ld_hu),
    .inst_ld_bu   (inst_ld_bu),
    .inst_st_w    (inst_st_w),
    .inst_bne     (inst_bne),
    .inst_slt     (inst_slt),
    .inst_sltu    (inst_sltu),
    .inst_and     (inst_and),
    .inst_or      (inst_or),
    .inst_nor     (inst_nor),
    .inst_xor     (inst_xor),
    .inst_slli_w  (inst_slli_w),
    .inst_srli_w  (inst_srli_w),
    .inst_srai_w  (inst_srai_w),
    .inst_b       (inst_b),
    .inst_bl      (inst_bl),
    .inst_beq     (inst_beq),
    .inst_jirl    (inst_jirl),
    .inst_lu12i_w (inst_lu12i_w),
    .inst_pcaddu12i(inst_pcaddu12i),
    .inst_mul_w   (inst_mul_w),
    .inst_mulh_w  (inst_mulh_w),
    .inst_mulh_wu (inst_mulh_wu),
    .inst_div_w   (inst_div_w),
    .inst_div_wu  (inst_div_wu),
    .inst_mod_w   (inst_mod_w),
    .inst_mod_wu  (inst_mod_wu),
    .inst_blt     (inst_blt),
    .inst_bge     (inst_bge),
    .inst_bltu    (inst_bltu),
    .inst_bgeu    (inst_bgeu),
    .inst_st_b    (inst_st_b),
    .inst_st_h    (inst_st_h)
);

op_dec u_op_dec(
    .reset        (reset),
    .inst_add_w   (inst_add_w),
    .inst_addi_w  (inst_addi_w),
    .inst_slti    (inst_slti),
    .inst_sltui   (inst_sltui),
    .inst_andi    (inst_andi),
    .inst_ori     (inst_ori),
    .inst_xori    (inst_xori),
    .inst_sub_w   (inst_sub_w),
    .inst_ld_w    (inst_ld_w),
    .inst_ld_h    (inst_ld_h),
    .inst_ld_b    (inst_ld_b),
    .inst_ld_hu   (inst_ld_hu),
    .inst_ld_bu   (inst_ld_bu),
    .inst_st_w    (inst_st_w),
    .inst_st_b    (inst_st_b),
    .inst_st_h    (inst_st_h),
    .inst_bne     (inst_bne),
    .inst_slt     (inst_slt),
    .inst_sltu    (inst_sltu),
    .inst_and     (inst_and),
    .inst_or      (inst_or),
    .inst_nor     (inst_nor),
    .inst_xor     (inst_xor),
    .inst_slli_w  (inst_slli_w),
    .inst_srli_w  (inst_srli_w),
    .inst_srai_w  (inst_srai_w),
    .inst_b       (inst_b),
    .inst_bl      (inst_bl),
    .inst_beq     (inst_beq),
    .inst_blt     (inst_blt),
    .inst_bge     (inst_bge),
    .inst_bltu    (inst_bltu),
    .inst_bgeu    (inst_bgeu),
    .inst_jirl    (inst_jirl),
    .inst_lu12i_w (inst_lu12i_w),
    .inst_pcaddu12i(inst_pcaddu12i),
    .inst_mul_w   (inst_mul_w),
    .inst_mulh_w  (inst_mulh_w),
    .inst_mulh_wu (inst_mulh_wu),
    .inst_div_w   (inst_div_w),
    .inst_div_wu  (inst_div_wu),
    .inst_mod_w   (inst_mod_w),
    .inst_mod_wu  (inst_mod_wu),
    .alu_op       (alu_op_inner),
    .br_op        (br_op_inner),
    .mem_op       (mem_op_inner)
);

imm_generator u_imm_generator(
    .reset        (reset),
    .inst         (inst),
    .inst_add_w   (inst_add_w),
    .inst_addi_w  (inst_addi_w),
    .inst_slti    (inst_slti),
    .inst_sltui   (inst_sltui),
    .inst_andi    (inst_andi),
    .inst_ori     (inst_ori),
    .inst_xori    (inst_xori),
    .inst_sub_w   (inst_sub_w),
    .inst_ld_w    (inst_ld_w),
    .inst_ld_h    (inst_ld_h),
    .inst_ld_b    (inst_ld_b),
    .inst_ld_hu   (inst_ld_hu),
    .inst_ld_bu   (inst_ld_bu),
    .inst_st_w    (inst_st_w),
    .inst_st_b    (inst_st_b),
    .inst_st_h    (inst_st_h),
    .inst_bne     (inst_bne),
    .inst_slt     (inst_slt),
    .inst_sltu    (inst_sltu),
    .inst_and     (inst_and),
    .inst_or      (inst_or),
    .inst_nor     (inst_nor),
    .inst_xor     (inst_xor),
    .inst_slli_w  (inst_slli_w),
    .inst_srli_w  (inst_srli_w),
    .inst_srai_w  (inst_srai_w),
    .inst_b       (inst_b),
    .inst_bl      (inst_bl),
    .inst_beq     (inst_beq),
    .inst_blt     (inst_blt),
    .inst_bge     (inst_bge),
    .inst_bltu    (inst_bltu),
    .inst_bgeu    (inst_bgeu),
    .inst_jirl    (inst_jirl),
    .inst_lu12i_w (inst_lu12i_w),
    .inst_pcaddu12i(inst_pcaddu12i),
    .alu_imm      (alu_imm_w),
    .br_imm       (br_imm_w)
);

ALU_srcGenerator u_ALU_srcGenerator(
    .reset        (reset),
    .inst_add_w   (inst_add_w),
    .inst_addi_w  (inst_addi_w),
    .inst_slti    (inst_slti),
    .inst_sltui   (inst_sltui),
    .inst_andi    (inst_andi),
    .inst_ori     (inst_ori),
    .inst_xori    (inst_xori),
    .inst_sub_w   (inst_sub_w),
    .inst_ld_w    (inst_ld_w),
    .inst_ld_h    (inst_ld_h),
    .inst_ld_b    (inst_ld_b),
    .inst_ld_hu   (inst_ld_hu),
    .inst_ld_bu   (inst_ld_bu),
    .inst_st_w    (inst_st_w),
    .inst_st_b    (inst_st_b),
    .inst_st_h    (inst_st_h),
    .inst_bne     (inst_bne),
    .inst_slt     (inst_slt),
    .inst_sltu    (inst_sltu),
    .inst_and     (inst_and),
    .inst_or      (inst_or),
    .inst_nor     (inst_nor),
    .inst_xor     (inst_xor),
    .inst_slli_w  (inst_slli_w),
    .inst_srli_w  (inst_srli_w),
    .inst_srai_w  (inst_srai_w),
    .inst_sll_w   (inst_sll_w),
    .inst_srl_w   (inst_srl_w),
    .inst_sra_w   (inst_sra_w),
    .inst_b       (inst_b),
    .inst_bl      (inst_bl),
    .inst_beq     (inst_beq),
    .inst_blt     (inst_blt),
    .inst_bge     (inst_bge),
    .inst_bltu    (inst_bltu),
    .inst_bgeu    (inst_bgeu),
    .inst_jirl    (inst_jirl),
    .inst_lu12i_w (inst_lu12i_w),
    .inst_pcaddu12i(inst_pcaddu12i),
    .rj_value     (src1_rdata),
    .rkd_value    (src2_rdata),
    .imm          (alu_imm_w),
    .pc           (pc_in),
    .alu_src1     (alu_src1_w),
    .alu_src2     (alu_src2_w)
);

// 读寄存器地址统一由 get_reg_read_addr 生成，避免在 top/ID 重复维护规则
get_reg_read_addr u_get_reg_read_addr(
    .reset        (reset),
    .inst         (inst),
    .inst_add_w   (inst_add_w),
    .inst_addi_w  (inst_addi_w),
    .inst_slti    (inst_slti),
    .inst_sltui   (inst_sltui),
    .inst_andi    (inst_andi),
    .inst_ori     (inst_ori),
    .inst_xori    (inst_xori),
    .inst_sub_w   (inst_sub_w),
    .inst_ld_w    (inst_ld_w),
    .inst_ld_h    (inst_ld_h),
    .inst_ld_b    (inst_ld_b),
    .inst_ld_hu   (inst_ld_hu),
    .inst_ld_bu   (inst_ld_bu),
    .inst_st_w    (inst_st_w),
    .inst_st_b    (inst_st_b),
    .inst_st_h    (inst_st_h),
    .inst_bne     (inst_bne),
    .inst_slt     (inst_slt),
    .inst_sltu    (inst_sltu),
    .inst_and     (inst_and),
    .inst_or      (inst_or),
    .inst_nor     (inst_nor),
    .inst_xor     (inst_xor),
    .inst_slli_w  (inst_slli_w),
    .inst_srli_w  (inst_srli_w),
    .inst_srai_w  (inst_srai_w),
    .inst_sll_w   (inst_sll_w),
    .inst_srl_w   (inst_srl_w),
    .inst_sra_w   (inst_sra_w),
    .inst_b       (inst_b),
    .inst_bl      (inst_bl),
    .inst_beq     (inst_beq),
    .inst_blt     (inst_blt),
    .inst_bge     (inst_bge),
    .inst_bltu    (inst_bltu),
    .inst_bgeu    (inst_bgeu),
    .inst_jirl    (inst_jirl),
    .inst_lu12i_w (inst_lu12i_w),
    .inst_pcaddu12i(inst_pcaddu12i),
    .inst_mul_w   (inst_mul_w),
    .inst_mulh_w  (inst_mulh_w),
    .inst_mulh_wu (inst_mulh_wu),
    .inst_div_w   (inst_div_w),
    .inst_div_wu  (inst_div_wu),
    .inst_mod_w   (inst_mod_w),
    .inst_mod_wu  (inst_mod_wu),
    .rf_raddr1    (rf_raddr1_w),
    .rf_raddr2    (rf_raddr2_w)
);

always @(*) begin
    allowIn     = 1'b1;
    readyGo     = 1'b1;
    src1_addr   = 5'b0;
    src2_addr   = 5'b0;
    wb_reg_addr = 5'b0;
    alu_src1    = 32'b0;
    alu_src2    = 32'b0;
    br_imm      = 32'b0;
    alu_op      = {`ALU_OP_NUM{1'b0}};
    br_op       = {`BR_OP_NUM{1'b0}};
    mem_op      = {`MEM_OP_NUM{1'b0}};
    mem_wdata   = 32'b0;
    wb_op       = 1'b0;
    pc_out      = 32'b0;

    if (!reset && valid) begin
        src1_addr   = rf_raddr1_w;
        src2_addr   = rf_raddr2_w;
        // 注意：stall 只对送 EXE 的控制/数据插泡，不影响读寄存器地址。
        wb_reg_addr = stall ? 5'd0  : (inst_bl ? 5'd1 : inst[4:0]);
        alu_src1    = stall ? 32'd0 : alu_src1_w;
        alu_src2    = stall ? 32'd0 : alu_src2_w;
        br_imm      = stall ? 32'd0 : br_imm_w;
        alu_op      = stall ? {`ALU_OP_NUM{1'b0}} : alu_op_inner;
        br_op       = stall ? {`BR_OP_NUM{1'b0}}  : br_op_inner;
        mem_op      = stall ? {`MEM_OP_NUM{1'b0}} : mem_op_inner; // 注意 mem_op 的编码规范
        mem_wdata   = stall ? 32'd0 : src2_rdata;
        wb_op       = stall ? 1'b0  : wb_op_w;
        pc_out      = stall ? 32'd0 : pc_in;

        // ori 专用路径：使用零扩展 ui12，与通用译码输出保持一致的写回语义
        if (inst_ori) begin
            src1_addr   = rf_raddr1_w;
            src2_addr   = rf_raddr2_w;
            wb_reg_addr = stall ? 5'd0  : inst[4:0];
            alu_src1    = stall ? 32'd0 : src1_rdata;
            alu_src2    = stall ? 32'd0 : {20'b0, inst[21:10]};
            br_imm      = 32'b0;
            alu_op      = stall ? {`ALU_OP_NUM{1'b0}} : ({`ALU_OP_NUM{1'b0}} | ({{(`ALU_OP_NUM-1){1'b0}},1'b1} << `ALU_OP_OR)); // op_or
            br_op       = {`BR_OP_NUM{1'b0}};
            mem_op      = {`MEM_OP_NUM{1'b0}};
            mem_wdata   = 32'b0;
            wb_op       = stall ? 1'b0 : 1'b1;
            pc_out      = stall ? 32'd0 : pc_in;
        end
    end
end

endmodule
