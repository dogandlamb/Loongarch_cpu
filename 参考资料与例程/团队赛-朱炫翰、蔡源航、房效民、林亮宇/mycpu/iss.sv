`include "mycpu.vh"
`include "pipeline_types.sv"
`include "core_defines.sv"
module iss
    import pipeline_types::*;
    import core_defines::*;
(
    //输入复位
    input  logic         reset,
    //================================ 模块准备信号 ================================
    input  logic         ISS_valid,
    output logic         iss_ready_go,     // 该指令完成处理标志
    input  logic         ISS_ready_go, // ISS流水级完成标志，标志着该流水级的所有指令都处理完成了
    //================================ 流水线握手信号 ================================
    input  logic                     dequeue_en,                     //当前指令准备出队
    //================================ 内外数据传输 ================================
    input  IQ_t          data_i,
    output ISS_EXE_bus_t data_o,
    output BU_bus_t      BU_data_o,
    output logic         is_privilege, // 表示指令是特权指令
    //================================ 寄存器文件接口 ================================
    output logic [4:0]  rf_raddr1,   // 寄存器读地址1
    input  logic [31:0] rf_rdata1,   // 寄存器读数据1
    output logic [4:0]  rf_raddr2,   // 寄存器读地址2
    input  logic [31:0] rf_rdata2,   // 寄存器读数据2
    //================================ ROB的读端口 ================================
    output logic [$clog2(ROB_DEPTH)-1:0] ROB_raddr1,
    input  logic                         ROB_rvalid1, // 指令的complete信号
    input  logic [31:0]                  ROB_rdata1,
    output logic [$clog2(ROB_DEPTH)-1:0] ROB_raddr2,
    input  logic                         ROB_rvalid2,
    input  logic [31:0]                  ROB_rdata2,
    //================================ pc查询 ================================
    output logic [$clog2(FRONTEND_FTQ_SIZE)-1:0] ftq_id,
    input  logic [31:0]                          ftq_query_pc,
    //================================ 中断接口 ================================
    input  logic        has_int,    // 是否有中断

    input  logic        EXE_next_need_refetch
    );

logic HAZARD_pause; // 该信号表示后面流水级指令与目前指令发生冒险所导致的阻塞，而不包括EXE_pause这种与当前指令无关的一定会进行的阻塞

//================================ 功能单元控制信号 ================================
// 操作数值
logic [31:0] rj_value;
logic [31:0] rkd_value;
logic [31:0] src1;
logic [31:0] src2;
//================================ 异常处理信号 ================================
logic        ISS_ex;      // 该指令有异常
logic [ 8:0] ISS_excp_num;// 异常号，每一位代表一种异常
logic        no_excp;     // idle


logic        next_need_refetch;  // 这个信号表示该指令的下一条指令需要进行重取
logic        refetch_flush;  // 重取标记
//================================ 冒险处理信号，由于流水线中指令有两份，这些信号也得两份 ================================
/*修改后的写后读逻辑：包含很多情况
普通的寄存器写后读、load-use冒险、乘除阻塞都包含在内
*/
logic RAW_HAZARD;

// CSR冒险检测
/*csr冒险判断：前一条指令写csr，后一条指令读csr，且csr_num相同（只需要看EXE和MEM阶段）*/
logic ISS_EXE_csr_HAZARD;
logic ISS_MEM_csr_HAZARD;

// 中断冒险检测
/*中断冒险判断：前三条指令写csr，并且csr_num为与中断相关的寄存器时，把指令阻塞在ISS阶段*/
logic csr_write_int;
logic ISS_EXE_int_HAZARD;
logic ISS_MEM_int_HAZARD;
logic ISS_WB_int_HAZARD;

// TLB冒险检测
/*tlbsrch冒险判断：前两条指令写ASID、TLBEHI，且当前指令为tlbsrch时，把指令阻塞在ISS阶段*/
logic ISS_EXE_tlbsrch_HAZARD;
logic ISS_MEM_tlbsrch_HAZARD;

// difftest

//=================================================== 主要逻辑实现 ===================================================

//================================ 数据接收逻辑 ================================
wire [31:0] ISS_pc;
wire [$clog2(ROB_DEPTH)-1:0] ROB_idx = data_i.ROB_idx;

wire        rf_raddr1_valid = data_i.rf_raddr1_valid; // 表示指令需要用源寄存器1
wire        rf_raddr2_valid = data_i.rf_raddr2_valid; // 表示指令需要用源寄存器2
PRF_t       rprf1;
PRF_t       rprf2;
assign      rprf1 = data_i.rprf1;
assign      rprf2 = data_i.rprf2;

wire [ 3:0] alu_op = data_i.alu_op;
wire [ 2:0] mul_op = data_i.mul_op;
wire [ 2:0] div_op = data_i.div_op;

wire [ 2:0] inst_ld_en = data_i.inst_ld_en;
wire [ 1:0] inst_st_en = data_i.inst_st_en;

wire src1_is_pc = data_i.src1_is_pc;
wire src2_is_imm = data_i.src2_is_imm;

wire gr_we = data_i.gr_we;
wire [ 4:0] dest = data_i.dest;
wire [31:0] imm = data_i.imm;

wire csr_re = data_i.csr_re;
wire [13:0] csr_num;
wire csr_we = data_i.csr_we;

wire ertn_flush = data_i.ertn_flush;
wire ex = data_i.ex;
wire [7:0] excp_num = data_i.excp_num;

wire [ 1:0] op_timer_64 = data_i.op_timer_64;

wire tlbsrch_en = data_i.tlbsrch_en;
wire tlbwr_en = data_i.tlbwr_en;
wire tlbfill_en = data_i.tlbfill_en;
wire tlbrd_en = data_i.tlbrd_en;
wire invtlb_en = data_i.invtlb_en;
wire [ 4:0] invtlb_op = data_i.invtlb_op;

wire inst_ll_w = data_i.inst_ll_w;
wire inst_sc_w = data_i.inst_sc_w;

wire inst_valid_cacop = data_i.inst_valid_cacop;

wire inst_idle = data_i.inst_idle;

`ifdef DIFFTEST_EN
wire [31:0] ISS_inst = data_i.inst;
wire cnt_inst = data_i.cnt_inst;
wire csr_rstat_en = data_i.csr_rstat_en;
`endif

wire [31:0] br_offs = data_i.br_offs;
wire [ 8:0] br_inst_sel = data_i.br_inst_sel;

wire inst_csrxchg = data_i.inst_csrxchg;

// 指令位于前端的信息
logic [$clog2(FETCH_WIDTH)-1:0] ftq_block_idx;  // 在FTQ块中的索引
logic is_last_in_block;  // 是否是块中的最后一条指令（决定后端在FTQ中提交）

assign ftq_id = data_i.ftq_id;
assign ftq_block_idx = data_i.ftq_block_idx;
assign is_last_in_block = data_i.is_last_in_block;

// 指令具体执行信息
branch_info_t branch_info;
//================================ 数据输出逻辑 ================================

assign ISS_pc = ftq_query_pc + (ftq_block_idx << 2);

assign is_privilege = csr_re | csr_we |
                      inst_valid_cacop|
                      tlbsrch_en | tlbrd_en | tlbwr_en | tlbfill_en | invtlb_en |
                      ertn_flush | inst_idle;


assign data_o = {   // 相当于ISS_to_EXE_valid
                    ISS_valid & ISS_ready_go, // ISS_valid是存起来的valid,但输出的valid是要与上ready_go的

                    ROB_idx,

                    alu_op,
                    mul_op,
                    div_op,

                    src1,
                    src2,
                    rkd_value,

                    gr_we,//1位
                    dest,//5位
                    inst_ld_en, //8位
                    inst_st_en, //8位
                    inst_ll_w,//1位
                    inst_sc_w,//1位

                    csr_re, //1位
                    csr_we, //1位
                    csr_num, //14位
                    inst_csrxchg, //1位

                    inst_valid_cacop,//1位   表示cacop指令的操作码让该cacop指令进行一定的操作，而不是无操作
                    ertn_flush, //1位

                    ISS_ex, //1位
                    ISS_excp_num, //9位

                    op_timer_64, //2位 定时器指令的信号，读计时器的高32位或低32位
                    /*TLB指令相关控制信号*/
                    tlbsrch_en, //1位
                    tlbwr_en, //1位
                    tlbfill_en, //1位
                    tlbrd_en, //1位
                    invtlb_en, //1位
                    invtlb_op, //5位

                    next_need_refetch,//1位
                    refetch_flush, // 空信号，实际赋值在外面进行赋值

                    ftq_id,
                    ftq_block_idx,
                    is_last_in_block
                    `ifdef DIFFTEST_EN
                    ,
                    ISS_inst,//32
                    cnt_inst,//1
                    csr_rstat_en//1
                    `endif
};

assign BU_data_o   = {
                    ISS_valid & ISS_ready_go, // ISS_valid是存起来的valid,但输出的valid是要与上ready_go的
                    ISS_pc,
                    ROB_idx,

                    gr_we,//1位
                    dest,//5位

                    rj_value,
                    rkd_value,

                    br_offs,
                    br_inst_sel,

                    ertn_flush, //1位

                    ISS_ex, //1位
                    ISS_excp_num, //9位

                    refetch_flush, // 空信号，实际赋值在外面进行赋值

                    ftq_id,
                    ftq_block_idx,
                    is_last_in_block,

                    branch_info
                    `ifdef DIFFTEST_EN
                    ,
                    ISS_inst,//32
                    cnt_inst,//1
                    csr_rstat_en//1
                    `endif
};

//================================ 流水线控制 ================================
/*需要阻塞ISS阶段的情况：
一、发生冒险且1.上一条指令访存时，或：2.上一条指令为乘法指令时（乘法运算需要两个周期），需要阻塞一周期
二、前两条指令标记为异常，或是ertn指令，或标记了重取标签，需要阻塞住ISS阶段
三、发生csr冒险时，需要阻塞住ISS阶段
四、发生int冒险时，需要阻塞住ISS阶段
五、发生tlbsrch冒险时，需要阻塞住ISS阶段
六、当ISS阶段与MEM阶段的指令发生寄存器写后读冒险时，要等MEM阶段取到数据后前递的数据才是正确的，所以要等访存的data_ok
七、ISS阶段的指令为idle指令时，把流水线阻塞在ISS阶段起暂停流水线的效果。在两种情况下CPU重新启动：
    1.被中断唤醒，此时ISS_ex置1，ISS_ready_go为1，恢复流动（但是要在WB阶段特判，这种情况不触发例外处理程序，因此将信号inst_idle往下传）
    2.复位，ISS_valid会被置0，ISS_ready_go为1，恢复流动
在双发射的情况下有特殊：
在MEM阶段有访存指令时（目前只可能同时有一条访存指令），等data_ok
*/
// 这里逻辑不够简洁，有待优化
assign HAZARD_pause = RAW_HAZARD                                                                ;
                    //   (ISS_EXE_int_HAZARD || ISS_MEM_int_HAZARD || ISS_WB_int_HAZARD)           |
                    //   (ISS_EXE_tlbsrch_HAZARD || ISS_MEM_tlbsrch_HAZARD)                        ; // 如果在MEM并不是个访存指令，那就会白等一个周期


assign iss_ready_go   = ~(HAZARD_pause | (inst_idle && ~has_int)) | ISS_ex ; // 当发生异常时，允许继续

/*寄存器读地址*/
assign rf_raddr1 = data_i.rf_raddr1;
assign rf_raddr2 = data_i.rf_raddr2;

/*对csr的读写控制信号*/
assign csr_num    = (data_i.csr_num == `CPUCFG) ? (rj_value[13:0] + 14'h00b0) : data_i.csr_num;

/*TLB指令相关控制信号*/
// 当invtlb_op不为4、5、6时，不需要用ASID，应该让rj为0；当invtlb_op不为5、6时，不需要用VA，应该让rk为0
// rj_is_r0和rk_is_r0在rj和rk的生成逻辑中使用了
assign invtlb_asid= rj_value[ 9:0];
assign invtlb_vpn = rkd_value[31:13];

// //================================ 分支处理逻辑 ================================
// /*计算是否进行分支跳转还有跳转目标地址*/
// assign rj_eq_rd = (rj_value == rkd_value);
// assign rj_lt_rd  = (rj_value[31] & ~rkd_value[31])
//                    | ((rj_value[31] ~^ rkd_value[31]) & rj_rd_add_result[31]);
// assign rj_ltu_rd = ~rj_rd_add_cout;
// //lt和ltu结果生成逻辑(照抄alu)
// assign br_addera = rj_value;
// assign br_adderb = ~rkd_value;
// assign {rj_rd_add_cout ,rj_rd_add_result} = br_addera + br_adderb +1'b1;
// assign br_taken = (  br_inst_sel[8] &  rj_eq_rd // br_inst_sel = {inst_beq, inst_bne, inst_blt, inst_bltu, inst_bge, inst_bgeu, inst_jirl, inst_bl, inst_b}
//                    | br_inst_sel[7] & ~rj_eq_rd
//                    | br_inst_sel[6] &  rj_lt_rd
//                    | br_inst_sel[5] &  rj_ltu_rd
//                    | br_inst_sel[4] & ~rj_lt_rd
//                    | br_inst_sel[3] & ~rj_ltu_rd
//                    | br_inst_sel[2]
//                    | br_inst_sel[1]
//                    | br_inst_sel[0]
//                   ) & ISS_valid & iss_ready_go;                // 使用指令的ready_go而不是整个流水线的ready_go
//                   //分支跳转成立条件判断，有些是无条件跳转
//                   //注意这里&& ISS_valid的结构非常重要
//                   //其意义在于如果要进行分支跳转，是的IF阶段已经取指的指令取消，那么下个周期这个已经取消的指令无法进入ISS阶段
//                   //于是ISS阶段数据有效信号为0，此时&& ISS_valid可以取消这个多余的跳转信号，防止对IF正确取出的指令进入到ISS阶段产生影响

// // 分支目标计算
// assign br_target = br_inst_sel[2] ? (rj_value + br_offs) : (ISS_pc + br_offs);
//                     //区分以pc中的值为基址还是寄存器中的值


/*操作数相关逻辑*/
assign src1 = src1_is_pc ? ISS_pc : rj_value;
assign src2 = src2_is_imm ? imm : rkd_value;

//================================ 冒险检测逻辑 ================================
// 寄存器写后读冒险用RAT解决，RAT在重命名阶段写入，在发射阶段读取
assign ROB_raddr1 = rprf1.prf;
assign ROB_raddr2 = rprf2.prf;

// 当映射关系有效且ROB中的数据被成功执行写回时，取ROB中的数据
assign rj_value  = (~rprf1.valid || ~ROB_rvalid1) ? rf_rdata1 : ROB_rdata1;
assign rkd_value = (~rprf2.valid || ~ROB_rvalid2) ? rf_rdata2 : ROB_rdata2; 

// rprf1.valid表示映射关系是否有效，当有映射且ROB返回的complete为0时，说明数据还未就绪
assign RAW_HAZARD = (rf_raddr1_valid & rprf1.valid & ~ROB_rvalid1) | (rf_raddr2_valid & rprf2.valid & ~ROB_rvalid2);


/*中断冒险判断：前三条指令写csr，并且csr_num为与中断相关的寄存器时，把指令阻塞在ISS阶段*/

// assign ISS_EXE_int_HAZARD = EXE_csr_we && EXE_csr_write_int;
// assign ISS_MEM_int_HAZARD = MEM_csr_we && MEM_csr_write_int;
// assign ISS_WB_int_HAZARD  = WB_csr_we  && WB_csr_write_int ;

// /*tlbsrch冒险判断：前两条指令写ASID、TLBEHI，且当前指令为tlbsrch时，把指令阻塞在ISS阶段*/
// assign ISS_EXE_tlbsrch_HAZARD = EXE_csr_we && (EXE_csr_num == `ASID || EXE_csr_num == `TLBEHI) && tlbsrch_en;
// assign ISS_MEM_tlbsrch_HAZARD = MEM_csr_we && (MEM_csr_num == `ASID || MEM_csr_num == `TLBEHI) && tlbsrch_en;

/*重取情况
next_need_refetch：这个信号会让该指令的下一条指令打上重取标记，打上重取标记的指令不会产生任何的写效果，同时会将这条标记重取的指令的下一条指令阻塞在ISS阶段。等该指令到达WB阶段时，
                    该标记使flush_sign置1，清空流水级缓存；同时令nextpc等于WB_pc，也就是等于该指令的pc值，从该指令开始重新执行
什么情况下需要将next_need_refetch置1：
1.写的地方为CRMD.DA\PG、DMW0、DMW1、ASID，这些与pre-IF级的取指有关
2.写的地方为CRMD.PLV，这与pre-IF级的PPI异常有关
3.写的地方为CRMD.DATF，这与pre-IF级的取指存储访问类型的判定有关
4.指令为TLBWR、TLBFILL、TLBRD、INVTLB，这些指令都会影响pre-IF级的取指
5.要么试试当csr_we为1时全都让下一条指令重取？
*/
// 还可以简化
assign next_need_refetch =  csr_we |
                            //(csr_we & (csr_num == `CRMD)) |
                            // (csr_we & (csr_num == `CRMD) & (csr_wmask[`CRMD_DA]   & csr_wmask[`CRMD_DA]  )) |
                            // (csr_we & (csr_num == `CRMD) & (csr_wmask[`CRMD_PG]   & csr_wmask[`CRMD_PG]  )) |
                            // (csr_we & (csr_num == `CRMD) & (csr_wmask[`CRMD_PLV]  & csr_wmask[`CRMD_PLV] )) |
                            // (csr_we & (csr_num == `CRMD) & (csr_wmask[`CRMD_DATF] & csr_wmask[`CRMD_DATF])) |
                            //(csr_we & ((csr_num == `DMW0) | (csr_num == `DMW1) | (csr_num == `ASID)))       |
                            tlbsrch_en | tlbwr_en | tlbfill_en | tlbrd_en | invtlb_en |
                            inst_valid_cacop; // cacop指令的下一条指令要重取

assign refetch_flush = EXE_next_need_refetch;
//================================ BTB控制 ================================

// // 对backend_ftq_meta_updata的赋值
// assign seq_pc = ISS_pc + 32'h4;
// assign branch_direction_mispredict =  br_taken ^ data_i.branch_info.predicted_taken;
// assign branch_target_mispredict    = (br_taken & data_i.branch_info.predicted_taken & (br_target != ftq_query_pc_i)) |
//                                     (~br_taken &~data_i.branch_info.predicted_taken & (seq_pc    != ftq_query_pc_i) & data_i.is_last_in_block);
// assign branch_target_right         = br_taken && (br_target == ftq_query_pc_i); 
// // 虽然可能没有进行预测，但是跳转指令在将要跳转时的指令流是正确的（尤其是对于预译码重定向的情况），此时用来抑制redirect信号的生成
// // 注意，这不会影响主预测器的训练，因为相当于避免后端重定向覆盖预译码预译码重定向

// assign branch_bus.redirect         = !branch_target_right && (branch_direction_mispredict | branch_target_mispredict) && ISS_valid;
// assign branch_bus.redirect_target  = br_taken ? br_target : seq_pc;

// assign branch_bus.ROB_error_index  = ROB_idx;

// assign is_branch = |br_inst_sel;
// assign jump_target_mispredict = branch_target_mispredict | (br_taken & ~data_i.is_last_in_block);
// assign branch_bus.redirect_ftq_id = data_i.ftq_id;
// assign jump_target_addr = br_target;
// assign fall_through_addr = seq_pc;
// assign branch_bus.backend_ftq_meta_updata = {
//     is_branch,
//     jump_target_mispredict,
//     jump_target_addr,
//     fall_through_addr,
//     branch_bus.redirect_ftq_id
// };

// 对branch_info的赋值
assign branch_info.redirect = data_i.branch_info.redirect;
assign branch_info.is_branch = data_i.branch_info.is_branch;

always_comb begin : branch_type_select
    if (br_inst_sel[2]) begin // inst_jirl
        branch_info.branch_type = (dest == 0 & rf_raddr1 == 1) ? BRANCH_TYPE_RET   :
                                  (dest == 1)                  ? BRANCH_TYPE_CALL  :
                                                                 BRANCH_TYPE_UNCOND;
    end
    else if (br_inst_sel[0]) begin // inst_b
        branch_info.branch_type = BRANCH_TYPE_UNCOND;
    end
    else if (br_inst_sel[1]) begin // inst_bl
        branch_info.branch_type = BRANCH_TYPE_CALL;
    end
    else begin
        branch_info.branch_type = BRANCH_TYPE_COND;
    end
end

assign branch_info.is_taken = data_i.branch_info.is_taken;
assign branch_info.predecoder_redirect = data_i.branch_info.predecoder_redirect;
assign branch_info.predicted_taken = data_i.branch_info.predicted_taken;
assign branch_info.predict_valid = data_i.branch_info.predict_valid;
//================================ 异常处理 ================================
assign no_excp      = inst_idle & has_int; // 表示idle状态被中断唤醒，这种情况不触发例外，用于使WB_ex置0
assign ISS_ex       = (has_int & ~no_excp) | ex ;
assign ISS_excp_num = {excp_num, has_int};




endmodule