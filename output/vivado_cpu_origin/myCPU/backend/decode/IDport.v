`include "../../common/cpu_defs.vh"

// ============================================================
// IDport：译码级。纯组合输出寄存器读地址、ALU 源、分支与访存控制；内部例化
// 实例化了inst_dec / op_dec / imm_generator / ALU_srcGenerator / get_reg_read_addr五个模块。
// stall = RAW插泡 = 阻塞， 清 alu/mem/br 等，保留 src* 地址
// ============================================================
module IDport (
    input  wire        reset,
    input  wire        valid,              // ID 槽有效
    input  wire        stall,              // RAW 插泡：清 alu/mem/br 等，保留 src* 地址，就是阻塞

    input  wire [31:0] inst,               // IF/ID 传输过来的32位指令
    input  wire [31:0] src1_rdata,         // regfile 口1（在top里会有前递的src1_rdata）
    input  wire [31:0] src2_rdata,         // regfile 口2（同理，也有前递的src2_rdata）
    input  wire [31:0] pc_in,              // 本指令 PC

    output reg         allowIn,            // 对 IF/ID 寄存器级，目前是常 1
    output reg         readyGo,            // 也是常 1

    output reg  [4:0]  src1_addr,          // regfile 读口1 地址
    output reg  [4:0]  src2_addr,          // regfile 读口2 地址
    output reg  [4:0]  wb_reg_addr,        // 目的 rd 地址
    output reg  [31:0] alu_src1,
    output reg  [31:0] alu_src2,
    output reg  [31:0] br_imm,
    output reg  [`ALU_OP_NUM-1:0] alu_op,
    output reg  [`BR_OP_NUM-1:0]  br_op,
    output reg  [`MEM_OP_NUM-1:0] mem_op,
    output reg  [31:0] mem_wdata,          // store 数据
    output reg         wb_op,              // 是否需要写回寄存器
    output reg  [31:0] pc_out              // 透传 pc_in
);

// inst_dec 输出的one-hot指令
wire inst_add_w, inst_addi_w, inst_slti, inst_sltui, inst_andi, inst_ori, inst_xori;
wire inst_sub_w;
wire inst_ld_w, inst_ld_h, inst_ld_b, inst_ld_hu, inst_ld_bu;
wire inst_st_w, inst_st_b, inst_st_h;
wire inst_bne, inst_slt, inst_sltu, inst_and, inst_or, inst_nor, inst_xor;
wire inst_slli_w, inst_srli_w, inst_srai_w, inst_sll_w, inst_srl_w, inst_sra_w;
wire inst_b, inst_bl, inst_beq, inst_blt, inst_bge, inst_bltu, inst_bgeu, inst_jirl;
wire inst_lu12i_w, inst_pcaddu12i;
wire inst_mul_w, inst_mulh_w, inst_mulh_wu, inst_div_w, inst_div_wu, inst_mod_w, inst_mod_wu;

wire [`ALU_OP_NUM-1:0] alu_op_inner; //内部ALU操作码，后续看条件赋值给output alu_op
wire [`BR_OP_NUM-1:0]  br_op_inner;  //内部分支跳转操作码，后续看条件赋值给output br_op
wire [`MEM_OP_NUM-1:0] mem_op_inner; //内部访存操作码，后续看条件赋值给output mem_op
wire [31:0]            alu_imm_w;
wire [31:0]            br_imm_w;
wire [31:0]            alu_src1_w;
wire [31:0]            alu_src2_w;
wire [4:0]             rf_raddr1_w;
wire [4:0]             rf_raddr2_w;
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
    .inst_sll_w   (inst_sll_w),
    .inst_srl_w   (inst_srl_w),
    .inst_sra_w   (inst_sra_w),
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
    .alu_op       (alu_op_inner),
    .br_op        (br_op_inner),
    .mem_op       (mem_op_inner)
);

imm_generator u_imm_generator(
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

// 读寄存器地址由 get_reg_read_addr 生成
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

        // ori 专用路径：使用零扩展 ui12
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
