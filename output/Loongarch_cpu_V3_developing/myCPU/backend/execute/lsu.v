// ============================================================
// lsu 模块（访存单元：AGU + DC 两级流水）
// ------------------------------------------------------------
// 功能：
// - 接收 rs_mem 发射的访存类指令，两级流水处理（mariver MU 同款）：
//   * AGU 级：算虚地址（base+imm）-> 查 DTLB/MMU 翻译 -> ALE/TLB 异常检测
//             -> load 同时查 store buffer（前递）
//   * DC  级：load 访问 DCache（命中 1~2 拍返回）/ 接受 SB 前递数据
//             -> 数据整形（字节/半字/符号扩展）-> 写回 ROB
// - store/sc.w：只走 AGU 级（算地址+翻译+异常检测），不访问 DCache！
//   把 {paddr, vaddr, 写数据, wstrb, size, uncached} 写回 ROB，
//   提交后由 commit 推入 store buffer 真正写出（提交后写语义）。
// - cacop：同 store，只算地址翻译，提交级驱动 cache 维护口。
// - uncached load：有副作用（外设读），必须等该指令到 ROB 头（确定提交）
//   才能向 DCache 发请求 —— 通过 robid 与 ROB head 比较的许可机制实现。
// - load 写回时广播唤醒（wb 总线）；AGU 级投机唤醒为二期优化。
//
// 端口：
// - issue_*        ：rs_mem 发射口直连
// - lsu_ready_o    ：AGU 级可接收
// - mmu_d_*        ：D 侧地址翻译口（组合）
// - dc_*           ：DCache load 访问口
// - sb_query_*     ：store buffer 前递查询口
// - rob_head_*     ：uncached load 许可（robid==head 才发）
// - wb_*           ：写回 ROB（load 数据 / store 信息 / 动态异常）
// - early_wakeup_* ：AGU 级投机唤醒（二期）
// ============================================================
`include "mycpu.h"

module lsu(
    input  wire                       clk,
    input  wire                       reset,
    input  wire                       flush_i,

    // ---------------- 发射入口（来自 rs_mem）----------------
    input  wire                       issue_valid_i,
    input  wire [`ROB_W-1:0]          issue_robid_i,
    input  wire [31:0]                issue_pc_i,
    input  wire [`MEM_OP_NUM-1:0]     issue_mem_op_i,
    input  wire                       issue_is_cacop_i,
    input  wire [31:0]                issue_base_i,        // rj 值
    input  wire [31:0]                issue_wdata_i,       // rd 值（store 数据）
    input  wire [31:0]                issue_imm_i,         // 偏移
    output wire                       lsu_ready_o,         // AGU 级空闲

    // ---------------- D 侧地址翻译（连 mmu D 通道，组合）----------------
    output wire                       mmu_d_req_o,
    output wire [31:0]                mmu_d_vaddr_o,
    output wire                       mmu_d_is_store_o,    // 区分 PIL/PIS 与 PME
    input  wire [31:0]                mmu_d_paddr_i,
    input  wire [1:0]                 mmu_d_mat_i,
    input  wire [`TLB_EX_NUM-1:0]     mmu_d_tlb_ex_i,      // TLBR/PIL/PIS/PPI/PME
    input  wire                       mmu_d_excp_adem_i,

    // ---------------- DCache load 访问口 ----------------
    output wire                       dc_req_o,            // load 请求（保持至 addr_ok）
    output wire [31:0]                dc_vaddr_o,          // 虚地址（VIPT 索引）
    output wire [31:0]                dc_paddr_o,          // 物理地址（tag 比对）
    output wire [2:0]                 dc_size_o,           // 0=B 1=H 2=W
    output wire                       dc_uncached_o,
    input  wire                       dc_addr_ok_i,
    input  wire                       dc_data_ok_i,
    input  wire [31:0]                dc_rdata_i,
    output wire                       dc_cancel_o,         // 冲刷取消在途请求

    // ---------------- store buffer 前递查询（AGU/DC 级组合）----------------
    output wire [31:0]                sb_query_paddr_o,
    input  wire                       sb_query_hit_i,      // 全字节命中可前递
    input  wire [31:0]                sb_query_data_i,
    input  wire                       sb_query_partial_i,  // 部分命中：load 必须等 SB 排空重试

    // ---------------- uncached load 许可（与 ROB head 比较）----------------
    input  wire [`ROB_W-1:0]          rob_head_robid_i,    // 当前 ROB 队头编号
    input  wire                       rob_head_valid_i,
    output wire                       uncached_ld_inflight_o, // 有 uncached load 在飞（commit 屏蔽中断用）

    // ---------------- 写回 ROB ----------------
    output wire                       wb_valid_o,
    output wire [`ROB_W-1:0]          wb_robid_o,
    output wire [31:0]                wb_data_o,           // load 整形后数据 / store 写数据
    output wire [31:0]                wb_paddr_o,          // 访存物理地址（store/cacop/difftest 用）
    output wire [31:0]                wb_vaddr_o,          // 访存虚地址（BADV/difftest 用）
    output wire [3:0]                 wb_wstrb_o,          // store 字节使能（已按地址对齐移位）
    output wire [2:0]                 wb_size_o,           // 访问宽度
    output wire                       wb_uncached_o,       // 非缓存访问
    output wire [`EXCP_NUM-1:0]       wb_excp_o,           // 动态异常（ALE/ADEM/TLBR_M/PIL/PIS/PPI_M/PME）

    // ---------------- AGU 级投机唤醒（二期）----------------
    output wire                       early_wakeup_valid_o,
    output wire [`ROB_W-1:0]          early_wakeup_robid_o
);

//TODO: 实现两级访存流水（参考：mariver fu_mu.v 的 preMEM(AGU)+MEM(LSU) 组织）
//
//TODO: AGU 级（第 1 级）：
//      1) vaddr = issue_base_i + issue_imm_i；mmu_d_req_o 组合发翻译；
//      2) ALE 检测：H 类要求 vaddr[0]==0，W 类要求 vaddr[1:0]==0，违者置 EXCP_ALE；
//      3) 异常合并：ALE/ADEM/TLB 异常（mmu_d_tlb_ex_i 翻译到 EXCP_* 向量：
//         load 用 PIL、store 用 PIS、写页用 PME，区分靠 mmu_d_is_store_o）；
//      4) store 数据预处理：按 vaddr[1:0] 把 issue_wdata_i 对齐到字节通道、
//         算 wstrb（st.b: 1<<va[1:0]；st.h: 3<<va[1:0]；st.w: 4'hf）；
//      5) 有异常的访存：不发 DCache/不写 SB 信息，直接带异常向量流向写回。
//      AGU 级结果锁存进 AGU/DC 流水寄存器。
//
//TODO: DC 级（第 2 级）：
//      - store/sc.w(真store)/cacop：无需访存，直接写回 ROB：
//          wb_data=对齐后写数据, wb_paddr/vaddr/wstrb/size/uncached 一并写回；
//      - load/ll.w：
//          a) 先看 AGU 级查 SB 的结果：sb_query_hit -> 直接用 SB 前递数据（不访 DCache）；
//             sb_query_partial -> 本条 load 阻塞（DC 级保持，等 SB 排空后重发查询）；
//          b) cached load -> dc_req 发 DCache（保持至 addr_ok），等 data_ok 收数；
//          c) uncached load -> 必须等 issue_robid==rob_head_robid（到 ROB 头）才发
//             dc_req（uncached 通道），期间 uncached_ld_inflight_o 置位
//             （commit 据此屏蔽中断附着，防止外设读已发生却被中断丢弃）；
//          d) 数据整形：按 vaddr[1:0] 与 mem_op 做字节/半字选择 + 符号/零扩展；
//      - 写回拍输出 wb_*。DC 级被占用时 AGU 级反压（lsu_ready_o=0）。
//
//TODO: lsu_ready_o：
//      AGU 级空（或本拍 AGU->DC 正常推进）即可接收新发射。
//
//TODO: 冲刷（flush_i）：
//      清 AGU/DC 两级 valid；dc_cancel_o 通知 DCache 作废在途请求/返回
//      （或本模块记"丢弃下一个 data_ok"标志）。注意：提交级冲刷时，
//      在飞的 cached load 即使返回了数据也只是被丢弃，无副作用，安全；
//      uncached load 因为只在 ROB 头发出，冲刷时要么还没发（直接作废）、
//      要么它就是队头本身（commit 会等它完成），不存在"半截"状态。
//
//TODO: 二期优化（接口已预留）：
//      1) AGU 级投机唤醒：load 在 AGU 级若能预测 DCache 命中（mariver 用
//         "最近两次命中的行地址"匹配），提前 2 拍广播 early_wakeup，
//         依赖者背靠背发射；预测错需要取消机制，谨慎实现。
//      2) 非阻塞 miss：DC 级 miss 后把请求移交 DCache 的 MSHR，本级继续
//         服务后续命中 load（DCache 侧配合，见 dcache.v 的 TODO）。
//
//TODO: 坑点提示：
//      1. SB 前递必须用物理地址比较（翻译后），且 SB 中 uncached store
//         不可前递（外设寄存器读必须真访问）。
//      2. ll.w 按普通 cached load 处理 + 提交级置 LLBIT（commit 负责）。
//      3. load 的 wb_data 必须是整形后的最终值——它会直接被 RS 唤醒
//         总线广播给等待的指令，不能让消费者再整形。

endmodule
