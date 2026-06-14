// ============================================================
// rob 模块（重排序缓冲：奇偶双体环形队列，队列式重命名的核心）
// ------------------------------------------------------------
// 功能（mariver 同款设计，本架构的灵魂部件）：
// - `ROB_SIZE=32 项 = 16 个"槽位对" × 2 路（奇偶分体）：
//   每拍恒分配一对（槽 0 -> {1'b0,tail}，槽 1 -> {1'b1,tail}），
//   ROB 编号同时承担三重角色：重命名标签 + 程序序 + 结果存储索引。
// - head/tail 环形指针；满判据 head == tail + `ROB_GUARD（保留 5 对安全
//   间距：保证"已提交但结果仍可能被 dispatch 读取"的表项不被新分配覆盖）。
// - 4 个 FU 写回口各写各的（无端口冲突）；提交口读队头一对；
//   dispatch 4 个读口取未就绪源操作数的值（带同拍写回旁路）。
// - NOP 消除：分配时 is_nop 直接标 complete，不经执行。
//
// 端口分组：
// - alloc_*  ：rename 成对分配（静态信息）
// - raddr/rrdy/rdata ×4 ：dispatch 操作数读口
// - alu0/alu1/mem/mdu wb ：4 路 FU 写回口
// - cmt0/cmt1_* ：队头一对的全部信息（送 commit 仲裁）
// - cmt_pop/clear ：提交推进控制
// ============================================================
`include "mycpu.h"

module rob(
    input  wire                       clk,
    input  wire                       reset,
    input  wire                       flush_i,            // 全局冲刷：head/tail/valid 全清

    // =============== 分配口（rename，恒成对） ===============
    input  wire                       alloc_en_i,         // 本拍分配一对
    output wire [`ROB_PAIR_W-1:0]     rob_tail_o,         // 当前队尾对指针
    output wire                       rob_full_o,         // 满（含安全间距）
    output wire                       rob_empty_o,

    // ---- 槽 0 静态信息 ----
    input  wire                       a0_valid_i,
    input  wire [31:0]                a0_pc_i,
    input  wire [31:0]                a0_inst_i,
    input  wire                       a0_rf_we_i,
    input  wire [4:0]                 a0_rd_i,
    input  wire [`FU_NUM-1:0]         a0_futype_i,
    input  wire                       a0_is_load_i,
    input  wire                       a0_is_store_i,
    input  wire                       a0_is_branch_i,
    input  wire [`BR_TYPE_W-1:0]      a0_br_type_i,
    input  wire                       a0_pred_taken_i,
    input  wire                       a0_is_last_i,
    input  wire [`FTQ_W-1:0]          a0_ftq_id_i,
    input  wire [`PRIV_NUM-1:0]       a0_priv_vec_i,
    input  wire [13:0]                a0_csr_num_i,
    input  wire [`TLB_OP_NUM-1:0]     a0_tlb_op_i,        // TLB 维护类型（提交级落地）
    input  wire [4:0]                 a0_cacop_code_i,
    input  wire [`EXCP_NUM-1:0]       a0_excp_i,          // 静态异常（取指/译码）
    input  wire                       a0_is_nop_i,

    // ---- 槽 1 静态信息 ----
    input  wire                       a1_valid_i,
    input  wire [31:0]                a1_pc_i,
    input  wire [31:0]                a1_inst_i,
    input  wire                       a1_rf_we_i,
    input  wire [4:0]                 a1_rd_i,
    input  wire [`FU_NUM-1:0]         a1_futype_i,
    input  wire                       a1_is_load_i,
    input  wire                       a1_is_store_i,
    input  wire                       a1_is_branch_i,
    input  wire [`BR_TYPE_W-1:0]      a1_br_type_i,
    input  wire                       a1_pred_taken_i,
    input  wire                       a1_is_last_i,
    input  wire [`FTQ_W-1:0]          a1_ftq_id_i,
    input  wire [`PRIV_NUM-1:0]       a1_priv_vec_i,
    input  wire [13:0]                a1_csr_num_i,
    input  wire [`TLB_OP_NUM-1:0]     a1_tlb_op_i,
    input  wire [4:0]                 a1_cacop_code_i,
    input  wire [`EXCP_NUM-1:0]       a1_excp_i,
    input  wire                       a1_is_nop_i,

    // =============== dispatch 操作数读口 ×4（组合，带同拍写回旁路） ===============
    input  wire [`ROB_W-1:0]          raddr0_i,
    output wire                       rrdy0_o,            // 该编号已写回（含本拍正在写回）
    output wire [31:0]                rdata0_o,
    input  wire [`ROB_W-1:0]          raddr1_i,
    output wire                       rrdy1_o,
    output wire [31:0]                rdata1_o,
    input  wire [`ROB_W-1:0]          raddr2_i,
    output wire                       rrdy2_o,
    output wire [31:0]                rdata2_o,
    input  wire [`ROB_W-1:0]          raddr3_i,
    output wire                       rrdy3_o,
    output wire [31:0]                rdata3_o,

    // =============== FU 写回口 ×4 ===============
    // ---- fu_alu0 ----
    input  wire                       alu0_wb_valid_i,
    input  wire [`ROB_W-1:0]          alu0_wb_robid_i,
    input  wire [31:0]                alu0_wb_data_i,
    input  wire                       alu0_wb_br_taken_i,
    input  wire [31:0]                alu0_wb_br_target_i,
    // ---- fu_alu1 ----
    input  wire                       alu1_wb_valid_i,
    input  wire [`ROB_W-1:0]          alu1_wb_robid_i,
    input  wire [31:0]                alu1_wb_data_i,
    input  wire                       alu1_wb_br_taken_i,
    input  wire [31:0]                alu1_wb_br_target_i,
    // ---- lsu ----
    input  wire                       mem_wb_valid_i,
    input  wire [`ROB_W-1:0]          mem_wb_robid_i,
    input  wire [31:0]                mem_wb_data_i,
    input  wire [31:0]                mem_wb_paddr_i,
    input  wire [31:0]                mem_wb_vaddr_i,
    input  wire [3:0]                 mem_wb_wstrb_i,
    input  wire [2:0]                 mem_wb_size_i,
    input  wire                       mem_wb_uncached_i,
    input  wire [`EXCP_NUM-1:0]       mem_wb_excp_i,      // 动态异常（与静态按位或）
    // ---- fu_mdu ----
    input  wire                       mdu_wb_valid_i,
    input  wire [`ROB_W-1:0]          mdu_wb_robid_i,
    input  wire [31:0]                mdu_wb_data_i,
    input  wire [31:0]                mdu_wb_data2_i,     // CSR 新值 / invtlb {vppn,asid} 打包

    // =============== 提交口：队头一对的全部信息 ===============
    output wire [`ROB_W-1:0]          head_robid0_o,      // 队头槽 0 编号（uncached load 许可比较用）
    // ---- 槽 0 ----
    output wire                       cmt0_valid_o,
    output wire                       cmt0_complete_o,
    output wire [31:0]                cmt0_pc_o,
    output wire [31:0]                cmt0_inst_o,
    output wire                       cmt0_rf_we_o,
    output wire [4:0]                 cmt0_rd_o,
    output wire [31:0]                cmt0_result_o,      // 写回 ARF 的值
    output wire [31:0]                cmt0_result2_o,     // CSR 新值/invtlb 打包/…
    output wire                       cmt0_is_load_o,
    output wire                       cmt0_is_store_o,
    output wire [31:0]                cmt0_paddr_o,
    output wire [31:0]                cmt0_vaddr_o,
    output wire [3:0]                 cmt0_wstrb_o,
    output wire [2:0]                 cmt0_size_o,
    output wire                       cmt0_uncached_o,
    output wire                       cmt0_is_branch_o,
    output wire [`BR_TYPE_W-1:0]      cmt0_br_type_o,
    output wire                       cmt0_pred_taken_o,
    output wire                       cmt0_br_taken_o,    // 实际方向（FU 写回）
    output wire [31:0]                cmt0_br_target_o,   // 实际目标
    output wire                       cmt0_is_last_o,
    output wire [`FTQ_W-1:0]          cmt0_ftq_id_o,
    output wire [`PRIV_NUM-1:0]       cmt0_priv_vec_o,
    output wire [13:0]                cmt0_csr_num_o,
    output wire [`TLB_OP_NUM-1:0]     cmt0_tlb_op_o,
    output wire [4:0]                 cmt0_cacop_code_o,
    output wire [`EXCP_NUM-1:0]       cmt0_excp_o,        // 静态|动态 合并后
    // ---- 槽 1 ----
    output wire                       cmt1_valid_o,
    output wire                       cmt1_complete_o,
    output wire [31:0]                cmt1_pc_o,
    output wire [31:0]                cmt1_inst_o,
    output wire                       cmt1_rf_we_o,
    output wire [4:0]                 cmt1_rd_o,
    output wire [31:0]                cmt1_result_o,
    output wire [31:0]                cmt1_result2_o,
    output wire                       cmt1_is_load_o,
    output wire                       cmt1_is_store_o,
    output wire [31:0]                cmt1_paddr_o,
    output wire [31:0]                cmt1_vaddr_o,
    output wire [3:0]                 cmt1_wstrb_o,
    output wire [2:0]                 cmt1_size_o,
    output wire                       cmt1_uncached_o,
    output wire                       cmt1_is_branch_o,
    output wire [`BR_TYPE_W-1:0]      cmt1_br_type_o,
    output wire                       cmt1_pred_taken_o,
    output wire                       cmt1_br_taken_o,
    output wire [31:0]                cmt1_br_target_o,
    output wire                       cmt1_is_last_o,
    output wire [`FTQ_W-1:0]          cmt1_ftq_id_o,
    output wire [`PRIV_NUM-1:0]       cmt1_priv_vec_o,
    output wire [13:0]                cmt1_csr_num_o,
    output wire [`TLB_OP_NUM-1:0]     cmt1_tlb_op_o,
    output wire [4:0]                 cmt1_cacop_code_o,
    output wire [`EXCP_NUM-1:0]       cmt1_excp_o,

    // ---- 提交推进控制（commit 仲裁结果）----
    input  wire                       cmt_pop_i,          // head++（队头对处理完毕）
    input  wire                       cmt_clear0_i,       // 槽 0 已提交（清 valid，可早于 pop）
    input  wire                       cmt_clear1_i        // 槽 1 已提交
);

//TODO: 实现奇偶双体 ROB（参考：mariver rob.v 全文，结构一一对应，必读！）
//
//TODO: 指针与满判据（mariver 137~142 行的精髓）：
//      reg [`ROB_PAIR_W-1:0] head, tail;
//      assign rob_full_o  = (head == tail + `ROB_GUARD);   // 保留 5 对安全间距！
//      assign rob_empty_o = (head == tail);
//      为什么留间距：提交后（clear/pop）该表项的 result 仍可能在同拍/下拍被
//      dispatch 读口用旧编号读取（rename 在它提交前一拍刚查到这个标签）；
//      留 GUARD 对间距保证新分配不会立即覆盖刚提交项的结果。删掉间距会出现
//      "偶发读到新指令结果"的恶性随机错误，几乎无法调试——千万别省。
//
//TODO: 存储结构（全 reg/LUTRAM；32 项 = [`ROB_SIZE-1:0]，编号={奇偶,对指针}）：
//      静态区（分配写）：valid、pc、inst、rf_we、rd、futype、is_load/store/branch、
//                        br_type、pred_taken、is_last、ftq_id、priv_vec、csr_num、
//                        cacop_code、excp_static、is_nop
//      动态区（写回写）：complete、result[32]、result2[32]、paddr/vaddr[32]、
//                        wstrb[4]、size[3]、uncached、br_taken、br_target[32]、
//                        excp_dynamic[`EXCP_NUM]
//      （奇偶可以共用"对索引"的静态数组×2 份，或直接 32 项平铺，二选一；
//        平铺写法简单，推荐。）
//
//TODO: 分配（alloc_en_i）：
//      把 a0_* 写入 {1'b0,tail} 项、a1_* 写入 {1'b1,tail} 项；tail++；
//      complete 初值 = is_nop（NOP 消除：分配即完成）；
//      a*_valid=0 的槽也要写（valid=0 占位），保证队头判断简单。
//
//TODO: FU 写回（4 路并行，互不冲突）：
//      alu0/alu1：result<=data；br_taken/br_target 锁存；complete<=1
//      mem      ：result<=data；paddr/vaddr/wstrb/size/uncached/excp_dynamic 锁存；complete<=1
//      mdu      ：result<=data；result2<=data2；complete<=1
//
//TODO: dispatch 读口（组合 + 同拍写回旁路，mariver 223~259 行）：
//      rrdy = complete[raddr] | (任一 wb 口本拍 valid 且 robid==raddr)
//      rdata = 本拍写回旁路优先，否则读 result[raddr]
//      （旁路必不可少：写回与 dispatch 同拍时，不旁路会让指令在 RS 里
//        错过唤醒、又读不到 ROB 值，死等。）
//
//TODO: 提交口：
//      cmt0_* = 表项 {1'b0,head} 的全部字段；cmt1_* = {1'b1,head}；
//      cmt*_excp_o = excp_static | excp_dynamic；
//      head_robid0_o = {1'b0, head}（lsu 的 uncached 许可比较用——
//        注意 uncached load 在槽 1 时编号是 {1'b1,head}，lsu 侧比较
//        建议只比对指针部分 robid[`ROB_PAIR_W-1:0]==head 且槽 0 已提交/无效，
//        细节在 lsu/commit TODO 里再确认）。
//      cmt_clear0/1_i：清对应项 valid（提交完成）；cmt_pop_i：head++。
//
//TODO: 冲刷：flush_i 时 head/tail 清 0、valid/complete 全清（一拍完成）。
//
//TODO: 坑点提示：
//      1. 同拍"分配写静态区"与"写回写动态区"作用于不同表项（GUARD 保证），
//         不会冲突；但代码里要分开两个 always 块写清楚。
//      2. complete 位在分配时必须清 0（is_nop 除外）——上一轮用过的旧值
//         残留会导致指令"未执行就提交"，查死人。
//      3. 双发射槽 1 无效时照样占位（valid=0），提交仲裁会跳过它。

endmodule
