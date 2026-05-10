`include "mycpu.vh"
`include "pipeline_types.sv"
`include "core_defines.sv"
`include "bpu_defines.sv"
module BU
    import pipeline_types::*;
    import core_defines::*;
    import bpu_defines::*;
(
    //输入时钟和复位
    input  logic    clk ,
    input  logic    reset,
    //================================ 流水线握手信号 ================================
    input  logic    WB_allow_in,             //WB阶段可以输入
    output logic    BU_allow_in,             //EXE阶段可以输入
    //================================ 流水线间通信总线 ================================
    output ROB_t    FU_WB_bus,   //送至WB阶段信号
    input  BU_bus_t data_i,
    //================================ 执行阶段（结束时）的写ROB端口 ================================
    output logic                            complete_en,
    output logic [$clog2(ROB_DEPTH)-1:0]    complete_addr,
    //================================ 前递暂停信号 ================================
    output logic        FU_pause,    // 在四个功能单元中检测到异常、ertn_flush、refetch_flush，暂停发射，直到提交阶段进行处理然后清空整个流水线
    output logic        BU_pause,
    //================================ 分支预测接口 ================================
    output logic                          redirect, // 错误刷新标志
    output logic [31:0]                   redirect_target, // 错误目标地址
    output logic [$clog2(FRONTEND_FTQ_SIZE)-1:0] redirect_ftq_id,
    output backend_ftq_meta_updata_t      backend_ftq_meta_updata,
    output BU_ras_op_t                    BU_ras_data,
    input  logic [ADDR_WIDTH-1:0]         ftq_query_pc_i,
    //================================ 分支预测错误指令的ROB索引 ================================
    output logic [$clog2(ROB_DEPTH)-1:0]  ROB_error_index,
    //================================ 流水线刷新 ================================
    // 异常和ertn到达WB阶段时，前递回来的清除流水线缓存的信号
    input  logic        flush_sign,
    input  logic        redirect_flush
    );
//================================ 信号定义 ================================
/*(* mark_debug="true", keep="true" *)*/logic valid;
logic ready_go;
logic data_valid;
logic [31:0]final_result;
//================================ 分支处理逻辑 ================================
/*跳转指令信号*/
logic         br_taken;      // 分支跳转发生
logic [31:0]  br_target;     // 分支目标地址
logic         rj_eq_rd;      // 寄存器相等比较
logic         rj_lt_rd;      // 有符号小于比较
logic         rj_ltu_rd;     // 无符号小于比较
logic [31:0]  rj_rd_add_result;   // 加法结果
logic         rj_rd_add_cout;// 加法进位
logic [31: 0] br_addera;     //用于计算blu、blut
logic [31: 0] br_adderb;     //对rd_values按位取反
/*分支预测处理相关信号*/
logic is_branch;
logic jump_target_mispredict;
logic [ADDR_WIDTH-1:0] jump_target_addr;
logic [ADDR_WIDTH-1:0] fall_through_addr;
logic branch_direction_mispredict;
logic branch_target_mispredict;
logic branch_target_right; // 通过查询前端发现分支目标正确，此时抑制重定向信号的生成
/*(* mark_debug="true", keep="true" *)*/logic [31:0] seq_pc;

// 指令具体执行信息
/*(* mark_debug="true", keep="true" *)*/branch_info_t branch_info;
wire  is_last_in_block;

// 此时指令无效，或者指令下一周期就可以进入下一个流水级
assign BU_allow_in = !valid || ready_go && WB_allow_in;

assign ready_go    = 1'b1;

//================================ 主要逻辑实现 ================================
BU_bus_t BU_data;
//================================ 与前后流水级的通信 ================================
always @(posedge clk) begin
    if (reset | flush_sign) begin
        valid <= 1'b0;
    end
    else if (BU_allow_in) begin
        valid <= data_i.valid;
    end

    if (data_i.valid & BU_allow_in) begin
    	BU_data <= data_i;
    end
end

// 因为只有jirl和bl指令需要写回，它们写回的数据都是pc+4
assign final_result = BU_data.pc + 32'h4;
//================================ 数据前递 ================================
assign BU_pause = valid; // BU中有指令，就阻塞指令进入FU2和FU3
assign FU_pause = (BU_data.ex | BU_data.ertn_flush | BU_data.refetch_flush) & valid;
assign data_valid = valid & ~BU_data.ex & ~BU_data.refetch_flush &~redirect_flush;
//================================ 分支处理逻辑 ================================
/*计算是否进行分支跳转还有跳转目标地址*/
assign rj_eq_rd = (BU_data.rj_value == BU_data.rkd_value);
assign rj_lt_rd  = (BU_data.rj_value[31] & ~BU_data.rkd_value[31])
                   | ((BU_data.rj_value[31] ~^ BU_data.rkd_value[31]) & rj_rd_add_result[31]);
assign rj_ltu_rd = ~rj_rd_add_cout;
//lt和ltu结果生成逻辑
assign br_addera = BU_data.rj_value;
assign br_adderb = ~BU_data.rkd_value;
assign {rj_rd_add_cout ,rj_rd_add_result} = br_addera + br_adderb +1'b1;
assign br_taken = (  BU_data.br_inst_sel[8] &  rj_eq_rd // br_inst_sel = {inst_beq, inst_bne, inst_blt, inst_bltu, inst_bge, inst_bgeu, inst_jirl, inst_bl, inst_b}
                   | BU_data.br_inst_sel[7] & ~rj_eq_rd
                   | BU_data.br_inst_sel[6] &  rj_lt_rd
                   | BU_data.br_inst_sel[5] &  rj_ltu_rd
                   | BU_data.br_inst_sel[4] & ~rj_lt_rd
                   | BU_data.br_inst_sel[3] & ~rj_ltu_rd
                   | BU_data.br_inst_sel[2]
                   | BU_data.br_inst_sel[1]
                   | BU_data.br_inst_sel[0]
                  ) & valid & ready_go;                // 使用指令的ready_go而不是整个流水线的ready_go
                  //分支跳转成立条件判断，有些是无条件跳转
                  //注意这里&& valid的结构非常重要
                  //其意义在于如果要进行分支跳转，是的IF阶段已经取指的指令取消，那么下个周期这个已经取消的指令无法进入ISS阶段
                  //于是ISS阶段数据有效信号为0，此时&& valid可以取消这个多余的跳转信号，防止对IF正确取出的指令进入到ISS阶段产生影响

// 分支目标计算
assign br_target = BU_data.br_inst_sel[2] ? (BU_data.rj_value + BU_data.br_offs) : (BU_data.pc + BU_data.br_offs);
                    //区分以BU_data.pc中的值为基址还是寄存器中的值

//================================ 分支预测信息 ================================
assign BU_ras_data.ras_push = (BU_data.branch_info.branch_type == BRANCH_TYPE_CALL) & data_valid;
assign BU_ras_data.ras_pop  = (BU_data.branch_info.branch_type == BRANCH_TYPE_RET ) & data_valid;

assign BU_ras_data.push_ftq_id = BU_data.ftq_id;
assign BU_ras_data.push_idx    = BU_data.ftq_block_idx;

assign ftq_query_addr_o = $clog2(FRONTEND_FTQ_SIZE)'(BU_data.ftq_id + 1);
// 对backend_ftq_meta_updata的赋值
assign seq_pc = BU_data.pc + 32'h4;
assign branch_direction_mispredict =  br_taken ^ BU_data.branch_info.predicted_taken;
assign branch_target_mispredict    = (br_taken & BU_data.branch_info.predicted_taken & (br_target != ftq_query_pc_i)) |
                                    (~br_taken &~BU_data.branch_info.predicted_taken & (seq_pc    != ftq_query_pc_i) & BU_data.is_last_in_block);
assign branch_target_right         = BU_data.branch_info.predecoder_redirect; 
// 虽然可能没有进行预测，但是跳转指令在将要跳转时的指令流是正确的（尤其是对于预译码重定向的情况），此时用来抑制redirect信号的生成
// 注意，这不会影响主预测器的训练，因为相当于避免后端重定向覆盖预译码预译码重定向，此时还能检测到主预测器的信息错误，将跳转信息送入BPU训练

// 与上~redirect_flush来刷掉分支预测错指令后的分支跳转指令
assign redirect         = !branch_target_right && (branch_direction_mispredict | branch_target_mispredict) && valid && ~redirect_flush;
assign redirect_target  = br_taken ? br_target : seq_pc;

assign ROB_error_index  = BU_data.ROB_idx;

assign is_branch = valid && ~redirect_flush;
assign jump_target_mispredict = branch_target_mispredict | (br_taken & ~BU_data.is_last_in_block);
assign redirect_ftq_id = BU_data.ftq_id;
assign jump_target_addr = br_target;
assign fall_through_addr = seq_pc;
assign backend_ftq_meta_updata = {
    is_branch && valid,// BU有些指令停太久，指令还是在BU的有效期间再发出信号吧
    jump_target_mispredict && valid,
    jump_target_addr,
    fall_through_addr,
    redirect_ftq_id
};

// 对branch_info的赋值
assign branch_info.redirect = redirect;
assign branch_info.is_branch = is_branch;

assign branch_info.branch_type = BU_data.branch_info.branch_type;
assign branch_info.is_taken = br_taken;
assign branch_info.predecoder_redirect = BU_data.branch_info.predecoder_redirect;
assign branch_info.predicted_taken = BU_data.branch_info.predicted_taken;
assign branch_info.predict_valid = BU_data.branch_info.predict_valid;

// 分支预测信号
assign is_last_in_block = (br_taken & ~BU_data.is_last_in_block) | BU_data.is_last_in_block;

// 和FU0、FU1中的给下一个阶段的valid一样，要与上~redirect_flush来刷掉分支预测错指令后的分支跳转指令
assign complete_en = BU_allow_in && valid && ~redirect_flush; // 数据有效且指令允许流入下个流水级时，给ROB填入完成信号
assign complete_addr = ROB_error_index;

//================================ 数据输出 ================================
assign FU_WB_bus.complete = 1'b1;
assign FU_WB_bus.Areg     = BU_data.dest;
assign FU_WB_bus.ex = BU_data.ex;
assign FU_WB_bus.excp_num = {7'b0, BU_data.excp_num};
assign FU_WB_bus.data = final_result;

assign FU_WB_bus.gr_we = BU_data.gr_we;

assign FU_WB_bus.data_uncache_en = 1'b0;

assign FU_WB_bus.csr_tlb_type = 1'b0;

assign FU_WB_bus.inst_ll_w = 1'b0;
assign FU_WB_bus.inst_sc_w = 1'b0;

assign FU_WB_bus.different_data = 0;

assign FU_WB_bus.csr_we = 1'b0;
assign FU_WB_bus.ertn_flush = BU_data.ertn_flush;
assign FU_WB_bus.refetch_flush = BU_data.refetch_flush;

// 指令位于前端的信息
assign FU_WB_bus.ftq_id = BU_data.ftq_id;   // FTQ块的索引
assign FU_WB_bus.ftq_block_idx = BU_data.ftq_block_idx;  // 在FTQ块中的索引
assign FU_WB_bus.is_last_in_block = is_last_in_block;  // 是否是块中的最后一条指令（决定后端在FTQ中提交）

// 指令具体执行信息
assign FU_WB_bus.branch_info = branch_info;

// difftest
`ifdef DIFFTEST_EN
assign FU_WB_bus.diff_timer_64_rdata = 0;
assign FU_WB_bus.diff_inst = BU_data.diff_inst;
assign FU_WB_bus.diff_inst_ld_en = 0;
assign FU_WB_bus.diff_inst_st_en = 0;
assign FU_WB_bus.diff_cnt_inst = BU_data.diff_cnt_inst;
assign FU_WB_bus.diff_csr_rstat_en = BU_data.diff_csr_rstat_en;
assign FU_WB_bus.diff_csr_rdata = 0;
assign FU_WB_bus.diff_data_sram_wdata = 0;
`endif
endmodule