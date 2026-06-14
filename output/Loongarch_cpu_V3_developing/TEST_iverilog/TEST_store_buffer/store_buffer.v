// ============================================================
// store_buffer 模块（提交后写缓冲，`SB_SIZE=8 项 FIFO）
// ------------------------------------------------------------
// 功能：
// - 乱序核 store 正确性的关键部件："store 在提交前绝不写内存"。
//   store 指令提交时（已确定非投机），commit 把 {paddr,data,wstrb,size,uncached}
//   推入本缓冲；本缓冲按程序序逐条写出到 DCache/外设，写出与流水线解耦
//   （提交不必等写完成，后续指令继续提交 —— 隐藏 store 延迟）。
// - load 前递：在飞的 store 尚未写进 DCache 时，更年轻的 load 读同地址必须
//   看到它的数据 —— LSU 在 AGU/DC 级查询本缓冲按字节前递。
// - 重要语义（与其他队列的本质区别！）：
//   * 全局冲刷 flush 时本缓冲【不清空】—— 缓冲里全部是"已提交"的 store，
//     体系结构上已经发生，必须继续写出；只有复位才清。
//   * ibar/dbar/ll 等屏障语义：commit 等 sb_empty 后才放行（端口已给）。
//
// 端口：
// - push_*      ：commit 提交 store 入队（一拍最多 1 条，见 commit 单提交约定）
// - dc_wr_*     ：排空写 DCache 口（含 uncached 直写外设通道）
// - query_*     ：LSU load 前递查询口（组合，物理地址）
// - sb_full/empty
// ============================================================
`include "mycpu.h"

module store_buffer(
    input  wire                clk,
    input  wire                reset,

    // ---------------- 提交入队（来自 commit）----------------
    input  wire                push_valid_i,
    input  wire [31:0]         push_paddr_i,
    input  wire [31:0]         push_data_i,       // 已按地址对齐到字节通道
    input  wire [3:0]          push_wstrb_i,
    input  wire [2:0]          push_size_i,       // AXI size（uncached 精确宽度用）
    input  wire                push_uncached_i,
    output wire                sb_full_o,         // 满（commit 暂停提交 store）
    output wire                sb_empty_o,        // 空（屏障/uncached load 等待用）

    // ---------------- 排空写出口（连 dcache 的 store 写口）----------------
    output wire                dc_wr_req_o,       // 写请求（保持至 addr_ok）
    output wire [31:0]         dc_wr_paddr_o,
    output wire [31:0]         dc_wr_data_o,
    output wire [3:0]          dc_wr_strb_o,
    output wire [2:0]          dc_wr_size_o,
    output wire                dc_wr_uncached_o,
    input  wire                dc_wr_addr_ok_i,   // DCache 收下
    input  wire                dc_wr_done_i,      // 写完成（cached 写命中可当拍/次拍完成）

    // ---------------- load 前递查询口（LSU，组合）----------------
    input  wire [31:0]         query_paddr_i,
    output wire                query_hit_o,       // 整字（4 字节）全部可由 SB 提供
    output wire [31:0]         query_data_o,      // 前递数据（多项命中取最年轻）
    output wire                query_partial_o    // 部分字节命中（load 须等排空）
);

//TODO: 实现 8 项 FIFO 写缓冲（参考语义：本计划"提交后写"方案；
//      mariver 用的是"投机写+回滚队列"另一套方案，二期想对比可看其 mem_ctrl.v）
//
//TODO: 存储结构：
//      reg [`SB_SIZE-1:0] valid;
//      reg [31:0] paddr[0:`SB_SIZE-1], data[0:`SB_SIZE-1];
//      reg [3:0]  strb [0:`SB_SIZE-1];
//      reg [2:0]  size [0:`SB_SIZE-1];
//      reg        uncached[0:`SB_SIZE-1];
//      reg [`SB_W-1:0] head, tail;   // head=最老（先写出），tail=入队位置
//
//TODO: 入队/出队：
//      push -> 写 tail 项，tail++；sb_full = 满判断（count 或指针法）。
//      排空：head 项 valid 时持续发 dc_wr_req（保持到 addr_ok），
//            dc_wr_done 后清该项、head++。按序写出，绝不乱序！
//      cached 与 uncached 都从同一出口走（dcache 内部按 uncached 旁路 AXI），
//      uncached 写要用 push_size_i 给出真实 AXI 宽度（外设按字节写的坑！）。
//
//TODO: 前递查询（纯组合）：
//      对每一项比较 paddr[31:2] == query_paddr_i[31:2]（按字对齐比较）：
//      - 命中项中选"最年轻"（离 tail 最近的）做前递源；
//      - query_hit_o：命中项 strb==4'hf 且非 uncached（整字可前递）；
//      - query_partial_o：命中但 strb!=4'hf，或多项部分覆盖，或命中 uncached 项
//        —— 一律让 load 等待排空后重试（按字节合并前递是二期优化，
//        需要逐字节多路选择，先别做）。
//
//TODO: 坑点提示（必读！）：
//      1. flush 不清本缓冲！这里的 store 已提交，是体系结构状态的一部分。
//      2. difftest 的 StoreEvent 在 commit 提交点报告（不等 SB 排空），
//         与 NEMU 的提交序一致；SB 只是写出延迟，软件不可见。
//      3. 同拍 push + 排空 + 查询并存：注意 count/指针的合并更新；
//         查询命中"本拍正在写出的 head 项"也算命中（数据仍有效）。
//      4. sb_empty 是 ibar/ll/uncached-load 等待的依据，必须严格：
//         "队列空 且 无在途未完成写"才算 empty。

endmodule
