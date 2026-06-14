// ============================================================
// commit 模块（提交级：双提交仲裁 + 异常/特权/误预测处理 + 训练/冲刷源头）
// ------------------------------------------------------------
// 参考实现说明（全核唯一让体系结构状态改变的地方）：
// - primary = 队头第一个有效槽（槽 0 已提交后为槽 1）；secondary = 同拍槽 1；
// - 优先级：中断附着 > 异常 > 特权类（单提交+落地+冲刷）> 误预测检查 > 常规提交；
// - 槽 1 同拍提交限制：无异常/特权/分支/pred_taken/is_last/双 store；
//   （is_last 限制保证 FTQ 提交口一拍最多一次 cmt_ptr 推进）
// - 冲刷类型：INT/异常->FLUSH_EXCP；ertn->FLUSH_ERTN；其余特权->FLUSH_REFETCH；
//   误预测->FLUSH_MISPRED；
// - sc.w 真 store 的写回值在本级旁路为 1（store 数据走 result 原值）。
// ============================================================
`include "mycpu.h"

module commit(
    input  wire                       clk,
    input  wire                       reset,

    // =============== ROB 队头一对（rob.v 提交口直连） ===============
    input  wire [`ROB_W-1:0]          head_robid0_i,
    // ---- 槽 0 ----
    input  wire                       cmt0_valid_i,
    input  wire                       cmt0_complete_i,
    input  wire [31:0]                cmt0_pc_i,
    input  wire [31:0]                cmt0_inst_i,
    input  wire                       cmt0_rf_we_i,
    input  wire [4:0]                 cmt0_rd_i,
    input  wire [31:0]                cmt0_result_i,
    input  wire [31:0]                cmt0_result2_i,
    input  wire                       cmt0_is_load_i,
    input  wire                       cmt0_is_store_i,
    input  wire [31:0]                cmt0_paddr_i,
    input  wire [31:0]                cmt0_vaddr_i,
    input  wire [3:0]                 cmt0_wstrb_i,
    input  wire [2:0]                 cmt0_size_i,
    input  wire                       cmt0_uncached_i,
    input  wire                       cmt0_is_branch_i,
    input  wire [`BR_TYPE_W-1:0]      cmt0_br_type_i,
    input  wire                       cmt0_pred_taken_i,
    input  wire                       cmt0_br_taken_i,
    input  wire [31:0]                cmt0_br_target_i,
    input  wire                       cmt0_is_last_i,
    input  wire [`FTQ_W-1:0]          cmt0_ftq_id_i,
    input  wire [`PRIV_NUM-1:0]       cmt0_priv_vec_i,
    input  wire [13:0]                cmt0_csr_num_i,
    input  wire [`TLB_OP_NUM-1:0]     cmt0_tlb_op_i,
    input  wire [4:0]                 cmt0_cacop_code_i,
    input  wire [`EXCP_NUM-1:0]       cmt0_excp_i,
    // ---- 槽 1 ----
    input  wire                       cmt1_valid_i,
    input  wire                       cmt1_complete_i,
    input  wire [31:0]                cmt1_pc_i,
    input  wire [31:0]                cmt1_inst_i,
    input  wire                       cmt1_rf_we_i,
    input  wire [4:0]                 cmt1_rd_i,
    input  wire [31:0]                cmt1_result_i,
    input  wire [31:0]                cmt1_result2_i,
    input  wire                       cmt1_is_load_i,
    input  wire                       cmt1_is_store_i,
    input  wire [31:0]                cmt1_paddr_i,
    input  wire [31:0]                cmt1_vaddr_i,
    input  wire [3:0]                 cmt1_wstrb_i,
    input  wire [2:0]                 cmt1_size_i,
    input  wire                       cmt1_uncached_i,
    input  wire                       cmt1_is_branch_i,
    input  wire [`BR_TYPE_W-1:0]      cmt1_br_type_i,
    input  wire                       cmt1_pred_taken_i,
    input  wire                       cmt1_br_taken_i,
    input  wire [31:0]                cmt1_br_target_i,
    input  wire                       cmt1_is_last_i,
    input  wire [`FTQ_W-1:0]          cmt1_ftq_id_i,
    input  wire [`PRIV_NUM-1:0]       cmt1_priv_vec_i,
    input  wire [13:0]                cmt1_csr_num_i,
    input  wire [`TLB_OP_NUM-1:0]     cmt1_tlb_op_i,
    input  wire [4:0]                 cmt1_cacop_code_i,
    input  wire [`EXCP_NUM-1:0]       cmt1_excp_i,

    // ---- 提交推进 ----
    output wire                       rob_pop_o,
    output wire                       rob_clear0_o,
    output wire                       rob_clear1_o,

    // 提交拍 RS 唤醒（commit 写 ARF 同步广播，避免 RS 仅等 wb 总线而饿死）
    output wire                       cmt_wake0_valid_o,
    output wire [`ROB_W-1:0]          cmt_wake0_robid_o,
    output wire [31:0]                cmt_wake0_data_o,
    output wire [4:0]                 cmt_wake0_rd_o,
    output wire                       cmt_wake1_valid_o,
    output wire [`ROB_W-1:0]          cmt_wake1_robid_o,
    output wire [31:0]                cmt_wake1_data_o,
    output wire [4:0]                 cmt_wake1_rd_o,

    // =============== ARF 写口 ×2 ===============
    output wire                       arf_we0_o,
    output wire [4:0]                 arf_waddr0_o,
    output wire [31:0]                arf_wdata0_o,
    output wire                       arf_we1_o,
    output wire [4:0]                 arf_waddr1_o,
    output wire [31:0]                arf_wdata1_o,

    // =============== RAT 释放口 ×2 ===============
    output wire                       rat_cmt_en0_o,
    output wire [4:0]                 rat_cmt_addr0_o,
    output wire [`ROB_W-1:0]          rat_cmt_num0_o,
    output wire                       rat_cmt_en1_o,
    output wire [4:0]                 rat_cmt_addr1_o,
    output wire [`ROB_W-1:0]          rat_cmt_num1_o,

    // =============== store buffer 入队 ===============
    output wire                       sb_push_valid_o,
    output wire [31:0]                sb_push_paddr_o,
    output wire [31:0]                sb_push_data_o,
    output wire [3:0]                 sb_push_wstrb_o,
    output wire [2:0]                 sb_push_size_o,
    output wire                       sb_push_uncached_o,
    input  wire                       sb_full_i,           // 满则 store 不能提交
    input  wire                       sb_empty_i,          // ibar/idle 等屏障等待

    // =============== CSR / 异常提交（对接 csr_exception_commit_handler） ===============
    output wire                       csr_cmt_valid_o,     // 本拍有指令提交（接 wb_valid）
    output wire [31:0]                csr_cmt_pc_o,        // 提交 PC（异常 ERA）
    output wire                       csr_cmt_ex_o,        // 异常提交（接 wb_ex）
    output wire                       csr_cmt_ertn_o,      // ertn 提交
    output wire [31:0]                csr_cmt_vaddr_o,     // BADV（取指异常=PC，访存异常=访存 vaddr）
    output wire                       excp_int_o,          // 各异常类型 valid（对接 handler 分立端口）
    output wire                       excp_adef_o,
    output wire                       excp_adem_o,
    output wire                       excp_ipe_o,
    output wire                       excp_ale_o,
    output wire                       excp_sys_o,
    output wire                       excp_brk_o,
    output wire                       excp_ine_o,
    output wire [`TLB_EX_NUM-1:0]     excp_tlb_vec_o,      // TLB 异常向量（取指/访存合并格式）
    output wire                       csr_we_o,            // CSR 写提交（csrwr/csrxchg）
    output wire [13:0]                csr_wnum_o,
    output wire [31:0]                csr_wmask_o,         // csrxchg 已在 MDU 合成新值 -> 全 1
    output wire [31:0]                csr_wvalue_o,        // = result2
    output wire                       ll_set_o,            // ll.w 提交置 LLBIT
    output wire                       sc_set_o,            // sc.w 提交清 LLBIT
    output wire [27:0]                lladdr_o,            // LL 地址高位
    input  wire                       has_int_i,           // CSR 有待处理中断
    input  wire [31:0]                csr_next_pc_i,       // 异常入口/ERA（handler 算好）
    input  wire [1:0]                 csr_redirect_i,      // `CSR_REDIRECT_EX / _ERTN

    // =============== TLB 维护落地（对接 tlb_manager / csr handler） ===============
    output wire [`TLB_OP_NUM-1:0]     tlb_op_cmt_o,        // 提交拍有效一拍
    output wire [9:0]                 invtlb_asid_o,       // 由 result2 解包
    output wire [18:0]                invtlb_vpn_o,

    // =============== cache 维护落地（直接驱动 I$/D$ cacop 口） ===============
    output wire                       icacop_valid_o,
    output wire [1:0]                 icacop_op_o,         // cacop_code[4:3]
    output wire [31:0]                icacop_addr_o,       // ROB paddr
    output wire                       dcacop_valid_o,
    output wire [1:0]                 dcacop_op_o,
    output wire [31:0]                dcacop_addr_o,

    // =============== FTQ 训练 / 查询 ===============
    output wire                       ftq_cmt_valid_o,     // 本拍有指令提交（推进 cmt_ptr/产生训练）
    output wire [`FTQ_W-1:0]          ftq_cmt_id_o,
    output wire                       ftq_cmt_is_last_o,
    output wire                       ftq_cmt_is_branch_o,
    output wire                       ftq_cmt_taken_o,
    output wire                       ftq_cmt_mispred_o,
    output wire [31:0]                ftq_cmt_target_o,    // 实际目标
    output wire [`BR_TYPE_W-1:0]      ftq_cmt_br_type_o,
    output wire [31:0]                ftq_cmt_pc_o,        // 分支指令 PC
    output wire [`FTQ_W-1:0]          ftq_query_id_o,      // 查该块的预测目标（误预测比对用）
    input  wire [31:0]                ftq_blk_target_i,    // FTQ 返回的预测目标

    // =============== RAS 提交栈维护（连 bpu） ===============
    output wire                       ras_cmt_call_o,
    output wire                       ras_cmt_ret_o,
    output wire [31:0]                ras_cmt_retaddr_o,   // call 的 PC+4

    // =============== 冲刷请求（送 ctrl） ===============
    output wire                       flush_req_o,
    output wire [`FLUSH_TYPE_W-1:0]   flush_type_o,
    output wire [31:0]                flush_pc_o,
    output wire                       idle_commit_o,       // idle 提交（ctrl 进入睡眠）

    // =============== LSU 状态 ===============
    input  wire                       uncached_ld_inflight_i, // 在飞 uncached load（屏蔽中断）

    // =============== 调试 / difftest 提交口 ===============
    output wire                       debug0_valid_o,
    output wire [31:0]                debug0_pc_o,
    output wire [3:0]                 debug0_rf_wen_o,
    output wire [4:0]                 debug0_rf_wnum_o,
    output wire [31:0]                debug0_rf_wdata_o,
    output wire [31:0]                debug0_inst_o,
    output wire                       debug1_valid_o,
    output wire [31:0]                debug1_pc_o,
    output wire [3:0]                 debug1_rf_wen_o,
    output wire [4:0]                 debug1_rf_wnum_o,
    output wire [31:0]                debug1_rf_wdata_o,
    output wire [31:0]                debug1_inst_o
);

wire [`ROB_PAIR_W-1:0] head_pair = head_robid0_i[`ROB_PAIR_W-1:0];

// ---------------- primary / secondary 选择 ----------------
wire p_sel1   = !cmt0_valid_i && cmt1_valid_i;    // 槽 0 已提交/无效，槽 1 为主
wire p_valid  = cmt0_valid_i || cmt1_valid_i;
wire s_exists = !p_sel1 && cmt0_valid_i && cmt1_valid_i;

wire                   p_complete = p_sel1 ? cmt1_complete_i : cmt0_complete_i;
wire [31:0]            p_pc       = p_sel1 ? cmt1_pc_i       : cmt0_pc_i;
wire [31:0]            p_inst     = p_sel1 ? cmt1_inst_i     : cmt0_inst_i;
wire                   p_rf_we    = p_sel1 ? cmt1_rf_we_i    : cmt0_rf_we_i;
wire [4:0]             p_rd       = p_sel1 ? cmt1_rd_i       : cmt0_rd_i;
wire [31:0]            p_result   = p_sel1 ? cmt1_result_i   : cmt0_result_i;
wire [31:0]            p_result2  = p_sel1 ? cmt1_result2_i  : cmt0_result2_i;
wire                   p_is_load  = p_sel1 ? cmt1_is_load_i  : cmt0_is_load_i;
wire                   p_is_store = p_sel1 ? cmt1_is_store_i : cmt0_is_store_i;
wire [31:0]            p_paddr    = p_sel1 ? cmt1_paddr_i    : cmt0_paddr_i;
wire [31:0]            p_vaddr    = p_sel1 ? cmt1_vaddr_i    : cmt0_vaddr_i;
wire [3:0]             p_wstrb    = p_sel1 ? cmt1_wstrb_i    : cmt0_wstrb_i;
wire [2:0]             p_size     = p_sel1 ? cmt1_size_i     : cmt0_size_i;
wire                   p_uncached = p_sel1 ? cmt1_uncached_i : cmt0_uncached_i;
wire                   p_is_branch= p_sel1 ? cmt1_is_branch_i: cmt0_is_branch_i;
wire [`BR_TYPE_W-1:0]  p_br_type  = p_sel1 ? cmt1_br_type_i  : cmt0_br_type_i;
wire                   p_pred_tk  = p_sel1 ? cmt1_pred_taken_i : cmt0_pred_taken_i;
wire                   p_br_taken = p_sel1 ? cmt1_br_taken_i : cmt0_br_taken_i;
wire [31:0]            p_br_target= p_sel1 ? cmt1_br_target_i: cmt0_br_target_i;
wire                   p_is_last  = p_sel1 ? cmt1_is_last_i  : cmt0_is_last_i;
wire [`FTQ_W-1:0]      p_ftq_id   = p_sel1 ? cmt1_ftq_id_i   : cmt0_ftq_id_i;
wire [`PRIV_NUM-1:0]   p_priv     = p_sel1 ? cmt1_priv_vec_i : cmt0_priv_vec_i;
wire [13:0]            p_csr_num  = p_sel1 ? cmt1_csr_num_i  : cmt0_csr_num_i;
wire [`TLB_OP_NUM-1:0] p_tlb_op   = p_sel1 ? cmt1_tlb_op_i   : cmt0_tlb_op_i;
wire [4:0]             p_cacop    = p_sel1 ? cmt1_cacop_code_i : cmt0_cacop_code_i;
wire [`EXCP_NUM-1:0]   p_excp     = p_sel1 ? cmt1_excp_i     : cmt0_excp_i;

// ---------------- 第一步：中断附着（最高优先级）----------------
wire int_take = has_int_i && p_valid && !uncached_ld_inflight_i;

// ---------------- 第二步：异常检查（需 complete，异常向量才完整）----------------
wire p_excp_any = |p_excp;
wire excp_take  = !int_take && p_valid && p_complete && p_excp_any;

// ---------------- 第三步：特权类与常规提交条件 ----------------
wire p_priv_any = |p_priv;
// 停顿条件：store 遇 SB 满；ibar/dbar 等 SB 排空
wire p_stall = (p_is_store && sb_full_i) || (p_priv[`PRIV_IBAR] && !sb_empty_i);

wire p_commit = p_valid && p_complete && !int_take && !excp_take && !p_stall;

wire priv_take = p_commit && p_priv_any;

// ---------------- 第四步：误预测检查（无异常/特权时）----------------
assign ftq_query_id_o = p_ftq_id;
wire p_mispred = p_commit && !p_priv_any &&
                 ( (p_is_branch && (p_br_taken != p_pred_tk))
                 | (p_is_branch && p_br_taken && p_pred_tk && (p_br_target != ftq_blk_target_i))
                 | (!p_is_branch && p_pred_tk) );

// ---------------- 冲刷仲裁 ----------------
wire priv_is_ertn = p_priv[`PRIV_ERTN];
wire p_flush = int_take || excp_take || priv_take || p_mispred;

assign flush_req_o  = p_flush;
assign flush_type_o = (int_take || excp_take) ? `FLUSH_EXCP
                    : (priv_take && priv_is_ertn) ? `FLUSH_ERTN
                    : priv_take ? `FLUSH_REFETCH
                    : p_mispred ? `FLUSH_MISPRED
                    : `FLUSH_NONE;
assign flush_pc_o   = (int_take || excp_take) ? csr_next_pc_i
                    : (priv_take && priv_is_ertn) ? csr_next_pc_i
                    : priv_take ? (p_pc + 32'd4)
                    : (p_br_taken ? p_br_target : (p_pc + 32'd4));

assign idle_commit_o = priv_take && p_priv[`PRIV_IDLE];

// ---------------- 第五步：槽 1 同拍提交限制 ----------------
wire s_commit = p_commit && !p_flush && s_exists
             && cmt1_complete_i
             && !(|cmt1_excp_i)
             && !(|cmt1_priv_vec_i)
             && !cmt1_is_branch_i
             && !cmt1_pred_taken_i
             && !cmt1_is_last_i
             && !(cmt1_is_store_i && (cmt0_is_store_i || sb_full_i));

// ---------------- 槽位提交映射 ----------------
wire slot0_commit = p_commit && !p_sel1;
wire slot1_commit = (p_commit && p_sel1) || s_commit;

// ---------------- ROB 推进 ----------------
assign rob_clear0_o = slot0_commit;
assign rob_clear1_o = slot1_commit;
// 两槽都"完结"（先前无效/已提交 或 本拍提交）则弹出（rob 内部带空队列保护）
assign rob_pop_o = ((!cmt0_valid_i) || slot0_commit) && ((!cmt1_valid_i) || slot1_commit);

// ---------------- ARF 写 / RAT 释放 ----------------
// sc.w 真 store 写回值旁路为 1（store 数据走 result 原值）
wire [31:0] cmt0_wdata = (cmt0_priv_vec_i[`PRIV_SC] && cmt0_is_store_i) ? 32'd1 : cmt0_result_i;
wire [31:0] cmt1_wdata = (cmt1_priv_vec_i[`PRIV_SC] && cmt1_is_store_i) ? 32'd1 : cmt1_result_i;

assign arf_we0_o    = slot0_commit && cmt0_rf_we_i;
assign arf_waddr0_o = cmt0_rd_i;
assign arf_wdata0_o = cmt0_wdata;
assign arf_we1_o    = slot1_commit && cmt1_rf_we_i;
assign arf_waddr1_o = cmt1_rd_i;
assign arf_wdata1_o = cmt1_wdata;

wire [`ROB_W-1:0] head_robid0 = {1'b0, head_pair};
wire [`ROB_W-1:0] head_robid1 = {1'b1, head_pair};
assign cmt_wake0_valid_o = slot0_commit && cmt0_rf_we_i;
assign cmt_wake0_robid_o = head_robid0;
assign cmt_wake0_data_o  = cmt0_wdata;
assign cmt_wake0_rd_o    = cmt0_rd_i;
assign cmt_wake1_valid_o = slot1_commit && cmt1_rf_we_i;
assign cmt_wake1_robid_o = head_robid1;
assign cmt_wake1_data_o  = cmt1_wdata;
assign cmt_wake1_rd_o    = cmt1_rd_i;

assign rat_cmt_en0_o   = arf_we0_o;
assign rat_cmt_addr0_o = cmt0_rd_i;
assign rat_cmt_num0_o  = {1'b0, head_pair};
assign rat_cmt_en1_o   = arf_we1_o;
assign rat_cmt_addr1_o = cmt1_rd_i;
assign rat_cmt_num1_o  = {1'b1, head_pair};

// ---------------- store 入 SB（一拍最多一条，限制已保证）----------------
wire st_from_slot0 = slot0_commit && cmt0_is_store_i;
wire st_from_slot1 = slot1_commit && cmt1_is_store_i;
assign sb_push_valid_o    = st_from_slot0 || st_from_slot1;
assign sb_push_paddr_o    = st_from_slot0 ? cmt0_paddr_i  : cmt1_paddr_i;
assign sb_push_data_o     = st_from_slot0 ? cmt0_result_i : cmt1_result_i;
assign sb_push_wstrb_o    = st_from_slot0 ? cmt0_wstrb_i  : cmt1_wstrb_i;
assign sb_push_size_o     = st_from_slot0 ? cmt0_size_i   : cmt1_size_i;
assign sb_push_uncached_o = st_from_slot0 ? cmt0_uncached_i : cmt1_uncached_i;

// ---------------- 异常向量翻译（优先级 = EXCP_* 位序，仅报最高位）----------------
// EXCP_*: ADEF > TLBR_F > PIF > PPI_F > INE > SYS > BRK > IPE > ALE > ADEM
//         > TLBR_M > PIL > PIS > PPI_M > PME
reg [`EXCP_NUM-1:0] p_excp_pri;
integer ei;
reg found_e;
always @(*) begin
    p_excp_pri = {`EXCP_NUM{1'b0}};
    found_e = 1'b0;
    for (ei = 0; ei < `EXCP_NUM; ei = ei + 1) begin
        if (!found_e && p_excp[ei]) begin
            p_excp_pri[ei] = 1'b1;
            found_e = 1'b1;
        end
    end
end

wire e_adef   = excp_take && p_excp_pri[`EXCP_ADEF];
wire e_tlbr_f = excp_take && p_excp_pri[`EXCP_TLBR_F];
wire e_pif    = excp_take && p_excp_pri[`EXCP_PIF];
wire e_ppi_f  = excp_take && p_excp_pri[`EXCP_PPI_F];
wire e_ine    = excp_take && p_excp_pri[`EXCP_INE];
wire e_sys    = excp_take && p_excp_pri[`EXCP_SYS];
wire e_brk    = excp_take && p_excp_pri[`EXCP_BRK];
wire e_ipe    = excp_take && p_excp_pri[`EXCP_IPE];
wire e_ale    = excp_take && p_excp_pri[`EXCP_ALE];
wire e_adem   = excp_take && p_excp_pri[`EXCP_ADEM];
wire e_tlbr_m = excp_take && p_excp_pri[`EXCP_TLBR_M];
wire e_pil    = excp_take && p_excp_pri[`EXCP_PIL];
wire e_pis    = excp_take && p_excp_pri[`EXCP_PIS];
wire e_ppi_m  = excp_take && p_excp_pri[`EXCP_PPI_M];
wire e_pme    = excp_take && p_excp_pri[`EXCP_PME];

wire e_fetch_side = e_adef | e_tlbr_f | e_pif | e_ppi_f;

assign excp_int_o  = int_take;
assign excp_adef_o = e_adef;
assign excp_adem_o = e_adem;
assign excp_ipe_o  = e_ipe;
assign excp_ale_o  = e_ale;
assign excp_sys_o  = e_sys;
assign excp_brk_o  = e_brk;
assign excp_ine_o  = e_ine;
assign excp_tlb_vec_o = {`TLB_EX_NUM{1'b0}}
                      | ({{(`TLB_EX_NUM-1){1'b0}}, e_tlbr_f | e_tlbr_m} << `TLB_EX_TLBR)
                      | ({{(`TLB_EX_NUM-1){1'b0}}, e_pif}              << `TLB_EX_PIF)
                      | ({{(`TLB_EX_NUM-1){1'b0}}, e_ppi_f | e_ppi_m}  << `TLB_EX_PPI)
                      | ({{(`TLB_EX_NUM-1){1'b0}}, e_pil}              << `TLB_EX_PIL)
                      | ({{(`TLB_EX_NUM-1){1'b0}}, e_pis}              << `TLB_EX_PIS)
                      | ({{(`TLB_EX_NUM-1){1'b0}}, e_pme}              << `TLB_EX_PME);

// ---------------- CSR 提交接口 ----------------
assign csr_cmt_valid_o = p_commit || excp_take || int_take;
assign csr_cmt_pc_o    = p_pc;
assign csr_cmt_ex_o    = excp_take || int_take;
assign csr_cmt_ertn_o  = priv_take && priv_is_ertn;
assign csr_cmt_vaddr_o = e_fetch_side ? p_pc : p_vaddr;

assign csr_we_o     = priv_take && p_priv[`PRIV_CSR_WR];
assign csr_wnum_o   = p_csr_num;
assign csr_wmask_o  = 32'hffff_ffff;     // MDU 已合成最终新值
assign csr_wvalue_o = p_result2;

assign ll_set_o = priv_take && p_priv[`PRIV_LL];
assign sc_set_o = priv_take && p_priv[`PRIV_SC];
assign lladdr_o = p_paddr[31:4];

// ---------------- TLB 维护落地 ----------------
assign tlb_op_cmt_o  = (priv_take && p_priv[`PRIV_TLB]) ? p_tlb_op : {`TLB_OP_NUM{1'b0}};
assign invtlb_asid_o = p_result2[9:0];
assign invtlb_vpn_o  = p_result2[31:13];

// ---------------- cache 维护落地 ----------------
wire cacop_commit = priv_take && p_priv[`PRIV_CACOP];
assign icacop_valid_o = cacop_commit && (p_cacop[2:0] == 3'd0);
assign icacop_op_o    = p_cacop[4:3];
assign icacop_addr_o  = p_paddr;
assign dcacop_valid_o = cacop_commit && (p_cacop[2:0] == 3'd1);
assign dcacop_op_o    = p_cacop[4:3];
assign dcacop_addr_o  = p_paddr;

// ---------------- FTQ 提交 / 训练 ----------------
// 仅 primary 上报（槽 1 同拍提交者必非 is_last/分支，FTQ 无需其信息）
assign ftq_cmt_valid_o    = p_commit;
assign ftq_cmt_id_o       = p_ftq_id;
assign ftq_cmt_is_last_o  = p_is_last;
assign ftq_cmt_is_branch_o= p_is_branch;
assign ftq_cmt_taken_o    = p_br_taken;
assign ftq_cmt_mispred_o  = p_mispred;
assign ftq_cmt_target_o   = p_br_target;
assign ftq_cmt_br_type_o  = p_br_type;
assign ftq_cmt_pc_o       = p_pc;

// ---------------- RAS 提交栈 ----------------
assign ras_cmt_call_o    = p_commit && p_is_branch && (p_br_type == `BR_TYPE_CALL);
assign ras_cmt_ret_o     = p_commit && p_is_branch && (p_br_type == `BR_TYPE_RET);
assign ras_cmt_retaddr_o = p_pc + 32'd4;

// ---------------- 调试口（debug0 = 本拍第一条提交）----------------
assign debug0_valid_o    = p_commit;
assign debug0_pc_o       = p_valid ? p_pc : 32'b0;
assign debug0_rf_wen_o   = {4{(p_sel1 ? arf_we1_o : arf_we0_o)}};
assign debug0_rf_wnum_o  = p_rd;
assign debug0_rf_wdata_o = p_sel1 ? cmt1_wdata : cmt0_wdata;
assign debug0_inst_o     = p_inst;

assign debug1_valid_o    = s_commit;
assign debug1_pc_o       = cmt1_pc_i;
assign debug1_rf_wen_o   = {4{(s_commit && cmt1_rf_we_i)}};
assign debug1_rf_wnum_o  = cmt1_rd_i;
assign debug1_rf_wdata_o = cmt1_wdata;
assign debug1_inst_o     = cmt1_inst_i;

// lint 吸收（未直接使用的输入）
wire commit_lint = (|csr_redirect_i) | p_is_load | p_rf_we | clk | reset
                 | (|p_result) | (|cmt1_vaddr_i) | (|cmt1_tlb_op_i)
                 | (|cmt1_csr_num_i) | (|cmt1_cacop_code_i) | (|cmt1_br_type_i)
                 | (|cmt1_ftq_id_i) | cmt1_br_taken_i | (|cmt1_br_target_i)
                 | cmt1_uncached_i | (|cmt1_size_i);

endmodule
