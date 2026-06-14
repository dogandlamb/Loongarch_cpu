// ============================================================
// ifu 模块（取指单元，含预译码）
// ------------------------------------------------------------
// 功能：
// - 从 FTQ 取出预测块，完成地址翻译 -> 访问 ICache（一次读一整行
//   `CACHE_LINE_BITS）-> 按块起始偏移切出最多 `FETCH_WIDTH 条指令
//   -> 预译码 -> 写入指令缓冲 IB。
// - 内部建议组织为 3 段小流水（参考团队赛 ifu.sv 的 4 级，可合并）：
//   F0：读 FTQ 块 + 查 ITLB/MMU 翻译（组合返回 paddr/mat/取指异常）
//   F1：向 ICache 发请求（物理地址），等待 addr_ok
//   F2：等待 data_ok 收整行数据，切割指令 + 预译码 + 写 IB
// - 预译码自重定向：发现块内有 BPU 漏预测的"直接无条件跳转 B/BL"
//   （不依赖寄存器、目标可当场算出），立即截断块、冲刷前端
//   （通知 BPU 重定向 + FTQ 修正块信息），不必等后端发现。
// - 取指异常（ADEF/TLBR/PIF/PPI）不阻塞：打在指令上随流水送到 ROB，
//   提交时统一处理（该块指令数据无效也照常送，占位即可）。
//
// 端口：
// - ftq_*      ：FTQ 取块口
// - mmu_i_*    ：I 侧地址翻译口（连 mmu 的 I 通道，组合）
// - ic_*       ：ICache 取指口（整行返回）
// - predec_*   ：预译码重定向（连 bpu + ftq）
// - ib_*       ：指令缓冲写入口（最多 4 条/拍）
// - flush_i    ：提交级全局冲刷（清空在途取指）
// ============================================================
`include "mycpu.h"

module ifu(
    input  wire                       clk,
    input  wire                       reset,
    input  wire                       flush_i,            // 全局冲刷：作废所有在途块/在途 icache 返回

    // ---------------- FTQ 取块 ----------------
    input  wire                       ftq_valid_i,
    input  wire [31:0]                ftq_pc_i,
    input  wire [`BLK_LEN_W-1:0]      ftq_length_i,
    input  wire                       ftq_taken_i,
    input  wire [31:0]                ftq_target_i,
    input  wire [`FTQ_W-1:0]          ftq_ftq_id_i,
    output wire                       ftq_accept_o,       // 收下该块（F0 接收成功）

    // ---------------- I 侧地址翻译（连 mmu I 通道，组合）----------------
    output wire                       mmu_i_req_o,        // 翻译请求（F0 级）
    output wire [31:0]                mmu_i_vaddr_o,      // 取指虚地址（块起始 PC）
    input  wire [31:0]                mmu_i_paddr_i,      // 翻译后物理地址
    input  wire [1:0]                 mmu_i_mat_i,        // 存储访问类型（0/2=非缓存,1=可缓存）
    input  wire                       mmu_i_excp_adef_i,  // 取指地址错（非对齐/越权地址段）
    input  wire [`TLB_EX_NUM-1:0]     mmu_i_tlb_ex_i,     // 取指 TLB 异常向量（TLBR/PIF/PPI）

    // ---------------- ICache 取指口（整行）----------------
    output wire                       ic_req_o,           // 取指请求（F1 级保持至 addr_ok）
    output wire [31:0]                ic_vaddr_o,         // 虚地址（VIPT 索引用）
    output wire [31:0]                ic_paddr_o,         // 物理地址（tag 比对用）
    output wire                       ic_uncached_o,      // 非缓存取指
    input  wire                       ic_addr_ok_i,       // ICache 收下请求
    input  wire                       ic_data_ok_i,       // 整行数据有效（一拍）
    input  wire [`CACHE_LINE_BITS-1:0] ic_rline_i,        // 整行数据（`CACHE_LINE_WORDS 条指令）
    output wire                       ic_cancel_o,        // 冲刷时取消在途请求/作废在途返回

    // ---------------- 预译码自重定向（连 bpu / ftq）----------------
    output wire                       predec_redirect_o,    // 发现漏预测的直接跳转
    output wire [31:0]                predec_redirect_pc_o, // 重定向目标（B/BL 的跳转地址）
    output wire [`FTQ_W-1:0]          predec_redirect_id_o, // 出错块 FTQ 编号
    output wire [`BLK_LEN_W-1:0]      predec_length_o,      // 截断后的块长
    output wire                       predec_taken_o,       // 恒 1
    output wire [31:0]                predec_target_o,      // 同 redirect_pc
    output wire [`BR_TYPE_W-1:0]      predec_br_type_o,     // UNCOND 或 CALL

    // ---------------- 指令缓冲写入口（最多 FETCH_WIDTH 条/拍）----------------
    output wire                       ib_push0_valid_o,
    output wire [31:0]                ib_push0_pc_o,
    output wire [31:0]                ib_push0_inst_o,
    output wire                       ib_push0_pred_taken_o,  // 该条预测跳转（仅块末分支可能为 1）
    output wire                       ib_push0_is_last_o,     // 块内最后一条（FTQ 释放/训练定位用）
    output wire [`FTQ_W-1:0]          ib_push0_ftq_id_o,
    output wire [`EXCP_NUM-1:0]       ib_push0_excp_o,        // 取指异常向量（ADEF/TLBR_F/PIF/PPI_F）

    output wire                       ib_push1_valid_o,
    output wire [31:0]                ib_push1_pc_o,
    output wire [31:0]                ib_push1_inst_o,
    output wire                       ib_push1_pred_taken_o,
    output wire                       ib_push1_is_last_o,
    output wire [`FTQ_W-1:0]          ib_push1_ftq_id_o,
    output wire [`EXCP_NUM-1:0]       ib_push1_excp_o,

    output wire                       ib_push2_valid_o,
    output wire [31:0]                ib_push2_pc_o,
    output wire [31:0]                ib_push2_inst_o,
    output wire                       ib_push2_pred_taken_o,
    output wire                       ib_push2_is_last_o,
    output wire [`FTQ_W-1:0]          ib_push2_ftq_id_o,
    output wire [`EXCP_NUM-1:0]       ib_push2_excp_o,

    output wire                       ib_push3_valid_o,
    output wire [31:0]                ib_push3_pc_o,
    output wire [31:0]                ib_push3_inst_o,
    output wire                       ib_push3_pred_taken_o,
    output wire                       ib_push3_is_last_o,
    output wire [`FTQ_W-1:0]          ib_push3_ftq_id_o,
    output wire [`EXCP_NUM-1:0]       ib_push3_excp_o,

    input  wire                       ib_can_push_i       // IB 本拍可接收最多 4 条
);

//TODO: 实现取指流水（参考：团队赛 ifu.sv 的 L0~L3 四级、满洋 frontend/ifu.sv）
//
//TODO: F0 级——取块 + 翻译：
//      - ftq_valid_i && F1 可接收 && ib 不堵 -> ftq_accept_o=1，块信息锁存进 F0/F1 流水寄存器。
//      - 组合发 mmu_i_req_o/mmu_i_vaddr_o（用块起始 PC；块不跨行，整块同页，一次翻译够用）。
//      - 把 paddr/mat/异常一起锁存。若有取指异常（adef/tlb_ex 非 0）：
//        不发 icache 请求，直接在 F2 给块内每条指令打上异常标记、指令字填 0 送 IB。
//
//TODO: F1 级——发 ICache 请求：
//      - ic_req_o 保持有效直到 ic_addr_ok_i（icache 忙时要持续请求，不能只发一拍脉冲）。
//      - ic_vaddr/ic_paddr/ic_uncached（mat!=1 即 uncached）同拍给出。
//      - uncached 取指：icache 旁路逐字取（icache 内部处理），返回接口不变。
//
//TODO: F2 级——收行 + 切割 + 预译码 + 入 IB：
//      - ic_data_ok_i 时收 ic_rline_i；按 块起始PC[`CACHE_LINE_W-1:2] 偏移取
//        length 条 32bit 指令：inst_k = rline[ (offset+k)*32 +: 32 ]。
//      - 每条指令拼装 ib_push 信号：pc = 块PC + 4k；is_last = (k == length-1)；
//        pred_taken = ftq_taken && is_last；ftq_id 透传；excp = F0 锁存的取指异常
//        （翻译异常属于整块，每条都打上同样的向量即可，提交时只有第一条会触发）。
//      - ib_can_push_i 为 0 时本级停顿（保持数据等待）。
//
//TODO: 预译码与自重定向（F2 级，组合扫描切出的指令）：
//      - 识别 B（opcode 010100）/ BL（010101）这类"目标 = PC + SignExt(imm26<<2)"
//        的直接无条件跳转（JIRL 依赖寄存器，预译码不管）。
//      - 若块内第 k 条是 B/BL，且 BPU 给的块预测没有在第 k 条跳转
//        （即 k < length-1，或 k==length-1 但 !ftq_taken）：
//          * 截断：本块只送 0..k 条入 IB，第 k 条 is_last=1、pred_taken=1
//          * 发 predec_redirect_o：目标 = pc_k + offs26，predec_length=k+1，
//            br_type = BL ? CALL : UNCOND
//          * BPU 收到后重定向取指 PC；FTQ 修正该块并丢弃其后的推测块
//      - 作废 F0/F1 中已在途的后续块（它们取的是错误路径）。
//
//TODO: 冲刷处理（flush_i）：
//      - 清空 F0/F1/F2 全部在途状态；ic_cancel_o 置 1 让 icache 作废在途返回
//        （或本模块记一个"丢弃下一次 data_ok"的标志，二选一，推荐后者简单）。
//
//TODO: 坑点提示：
//      1. icache 返回与冲刷竞争是经典坑：冲刷后必须丢弃"冲刷前发出的请求"
//         返回的数据，否则错误路径指令混入 IB。用"在途请求计数/标记"严格配对。
//      2. 取指异常的块不要真的访问 icache（地址可能非法），直接造 0 指令占位。
//      3. 预译码重定向后，FTQ 中该块之后的块全部无效，但本模块 F0/F1 可能已
//         取了下一块——务必一并作废（与坑 1 同机制处理）。

endmodule
