`include "mycpu.vh"
`include "pipeline_types.sv"
`include "core_defines.sv"
module ra
    import pipeline_types::*;
    import core_defines::*;
(
    //输入时钟和复位
    input  wire         clk ,
    input  wire         reset,
    //================================ 模块准备信号 ================================
    output reg          RA_valid,
    output wire         ra_ready_go,
    input  wire         RA_ready_go,
    //================================ 流水线握手信号 ================================
    input  wire         RA_allow_in,
    //================================ 流水线间通信总线 ================================
    input  ID_RA_bus_t  ID_RA_bus,    //ID送至RA阶段信号
    output IQ_t         IQ_enqueue_data,
    output ROB_t        ROB_enqueue_data,
    //================================ 与RAT的接口 ================================
    // 读
    output logic [ 4:0] src1_addr,
    output logic [ 4:0] src2_addr,
    input  logic                         src1_valid,
    input  logic                         src2_valid,
    input  logic [$clog2(ROB_DEPTH)-1:0] src1_prf,
    input  logic [$clog2(ROB_DEPTH)-1:0] src2_prf,
    // 写
    output logic                          we,       //write enable, HIGH valid
    output logic [ 4:0]                   waddr,
    output logic [$clog2(ROB_DEPTH)-1:0]  wprf,
    //================================ 与ROB的接口 ================================
    input  logic [$clog2(ROB_DEPTH) - 1:0] ROB_idx, // 这条指令对应的ROB索引
    //================================ 流水线刷新 ================================
    // 异常和ertn到达WB阶段时，前递回来的清除流水线缓存的信号
    input  wire         flush_sign,
    input  wire         redirect
    );

//================================ 前一流水级传过来的信号 ================================
reg nop; // 花费一个寄存器来空接信号，这样不是最好的做法但暂时想不到更好的方法了

logic [ 4:0] rj;
logic [ 4:0] rk;
logic [ 4:0] rd;

logic [ 4:0] rf_raddr1;
logic [ 4:0] rf_raddr2;
logic        rf_raddr1_valid;
logic        rf_raddr2_valid;
PRF_t        rprf1;
PRF_t        rprf2;

logic [ 3:0] alu_op;
logic [ 2:0] mul_op;
logic [ 2:0] div_op;

logic [ 2:0] inst_ld_en;
logic [ 1:0] inst_st_en;

logic src_reg_is_rd;
logic src1_is_pc;
logic src2_is_imm;

logic gr_we;
logic [ 4:0] dest;
logic [31:0] imm;

logic csr_re;
logic [13:0] csr_num;
logic csr_we;

logic ertn_flush;
logic ex;
logic [7:0] excp_num;

logic [ 1:0] op_timer_64;

logic tlbsrch_en;
logic tlbwr_en;
logic tlbfill_en;
logic tlbrd_en;
logic invtlb_en;
logic [ 4:0] invtlb_op;

logic inst_ll_w;
logic inst_sc_w;

logic inst_valid_cacop;

logic inst_idle;

logic inst_jirl;
logic inst_bl;
logic [31:0] br_offs;
logic [ 8:0] br_inst_sel; // br_inst_sel = {inst_beq, inst_bne, inst_blt, inst_bltu, inst_bge, inst_bgeu, inst_jirl, inst_bl, inst_b}

logic src_no_rj;
logic src_no_rk;

logic inst_csrxchg;

// 指令位于前端的信息
logic [$clog2(FRONTEND_FTQ_SIZE)-1:0] ftq_id;   // FTQ块的索引
logic [$clog2(FETCH_WIDTH)-1:0] ftq_block_idx;  // 在FTQ块中的索引
logic is_last_in_block;  // 是否是块中的最后一条指令（决定后端在FTQ中提交）

// 指令具体执行信息
branch_info_t branch_info;
// difftest
`ifdef DIFFTEST_EN
logic [31:0] inst;
logic cnt_inst;
logic csr_rstat_en;
`endif
//================================ 主要逻辑实现 ================================
// 重命名阶段应该没有需要阻塞的情况
assign ra_ready_go = 1'b1;

//================================ 与前后流水级的通信 ================================
always @(posedge clk) begin
    if (reset | flush_sign | redirect) begin
        RA_valid <= 1'b0;
    end
    else if (RA_allow_in) begin
        RA_valid <= ID_RA_bus.valid;
    end

    if (ID_RA_bus.valid & RA_allow_in) begin
    	{nop, // RA_valid不能在两个条件下同时赋值

        rj,
        rk,
        rd,

        rf_raddr1,
        rf_raddr2,
        rf_raddr1_valid,
        rf_raddr2_valid,

        alu_op,
        mul_op,
        div_op,

        inst_ld_en,
        inst_st_en,

        src_reg_is_rd,
        src1_is_pc,
        src2_is_imm,

        gr_we,
        dest,
        imm,

        csr_re,
        csr_num,
        csr_we,

        ertn_flush,
        ex,
        excp_num,

        op_timer_64,

        tlbsrch_en,
        tlbwr_en,
        tlbfill_en,
        tlbrd_en,
        invtlb_en,
        invtlb_op,

        inst_ll_w,
        inst_sc_w,

        inst_valid_cacop,

        inst_idle,

        inst_jirl,
        inst_bl,
        br_offs,
        br_inst_sel, // br_inst_sel = {inst_beq, inst_bne, inst_blt, inst_bltu, inst_bge, inst_bgeu, inst_jirl, inst_bl, inst_b}

        src_no_rj,
        src_no_rk,

        inst_csrxchg,

        // 指令位于前端的信息
        ftq_id,   // FTQ块的索引
        ftq_block_idx,  // 在FTQ块中的索引
        is_last_in_block,  // 是否是块中的最后一条指令（决定后端在FTQ中提交）

        // 指令具体执行信息
        branch_info
        `ifdef DIFFTEST_EN
        ,
        inst,
        cnt_inst,
        csr_rstat_en
        `endif
         } <= ID_RA_bus;
    end
end
// 与RAT的读写逻辑
// 读
assign src1_addr = rf_raddr1;
assign src2_addr = rf_raddr2;

assign rprf1 = {src1_valid, src1_prf};
assign rprf2 = {src2_valid, src2_prf};

/* 
1.写，当指令写回且目的寄存器不为全0时写RAT；
2.与上allow_in，当指令走的时候才写！不然如果指令还阻塞在RA阶段，写了RAT后自己又读了RAT，那不就错了吗
*/
assign we    = gr_we & (dest != 5'b0) & RA_valid & RA_allow_in; // 写使能都应该与上valid信号
assign waddr = dest;
assign wprf  = ROB_idx;

// 数据输出逻辑
assign IQ_enqueue_data = {
    RA_valid & RA_ready_go, // 1

    ROB_idx, // 5

    rf_raddr1, // 5
    rf_raddr2, // 5
    rf_raddr1_valid, // 1
    rf_raddr2_valid, // 1
    rprf1, // 6
    rprf2, // 6

    alu_op, // 12
    mul_op, // 3
    div_op, // 3

    inst_ld_en, // 8
    inst_st_en, // 8

    src1_is_pc, // 1
    src2_is_imm, // 1

    gr_we, // 1
    dest,  // 5
    imm, // 32

    csr_re, // 1
    csr_num, // 14
    csr_we, // 1

    ertn_flush, // 1
    ex, // 1
    excp_num, // 8

    op_timer_64, // 2

    tlbsrch_en, // 1
    tlbwr_en, // 1
    tlbfill_en, // 1
    tlbrd_en, // 1
    invtlb_en, // 1
    invtlb_op, // 5

    inst_ll_w, // 1
    inst_sc_w, // 1

    inst_valid_cacop, // 1

    inst_idle, // 1

    inst_jirl, // 1
    inst_bl, // 1
    br_offs, // 32
    br_inst_sel, // br_inst_sel = {inst_beq, inst_bne, inst_blt, inst_bltu, inst_bge, inst_bgeu, inst_jirl, inst_bl, inst_b}   9

    inst_csrxchg, // 1

    // 指令位于前端的信息
    ftq_id,   // FTQ块的索引  3
    ftq_block_idx,  // 在FTQ块中的索引  2
    is_last_in_block,  // 是否是块中的最后一条指令（决定后端在FTQ中提交）  1

    // 指令具体执行信息
    branch_info // 7
    `ifdef DIFFTEST_EN
    ,
    inst, // 32
    cnt_inst, // 1
    csr_rstat_en // 1
    `endif
};

// 因为指令没执行，填入ROB的数据只是用来占个位，complete为0表示指令还没执行完
assign ROB_enqueue_data.complete = 1'b0;


endmodule