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

reg agu_valid;
reg [`ROB_W-1:0] agu_robid;
reg [31:0] agu_pc;
reg [`MEM_OP_NUM-1:0] agu_mem_op;
reg  agu_is_cacop;
reg  [31:0] agu_base;
reg [31:0] agu_wdata;
reg [31:0] agu_imm;

wire agu_is_load;
wire agu_is_store;
wire [31:0] agu_vaddr;
wire [31:0] agu_paddr;
wire [1:0]  agu_mat;
wire [`TLB_EX_NUM-1:0] agu_tlb_ex;
wire agu_excp_adem;
wire agu_detect_ale;
wire [31:0] agu_store_data;
wire [3:0] agu_store_wstrb;
wire agu_sb_hit;
wire [31:0] agu_sb_query_data;
wire agu_sb_partial;
wire agu_uncached;
reg  [`EXCP_NUM-1:0] agu_excp;

reg dc_valid;
reg [`ROB_W-1:0] dc_robid;
reg [`MEM_OP_NUM-1:0] dc_mem_op;
reg dc_is_cacop;
reg [31:0] dc_vaddr;
reg [31:0] dc_paddr;
reg dc_is_load;
reg dc_is_store;
reg [31:0] dc_wdata;
reg [3:0] dc_wstrb;
reg dc_sb_query_hit;
reg [31:0] dc_sb_query_data;
reg dc_sb_query_partial;
reg [`EXCP_NUM-1:0] dc_excp;
reg dc_uncached;

wire dc_has_excp;
wire dc_uncached_permit;
wire dc_req;
wire dc_data_ok;
wire dc_done;
wire dc_can_accept;
wire [31:0] dc_rdata;
wire [2:0] mem_size;

// agu级
always @(posedge clk) begin
    if (reset || flush_i) begin
        agu_valid <= 1'b0;
    end else if (lsu_ready_o) begin
        agu_valid <= issue_valid_i;
        agu_robid <= issue_robid_i;
        agu_pc <= issue_pc_i;
        agu_mem_op <= issue_mem_op_i;
        agu_is_cacop <= issue_is_cacop_i;
        agu_base <= issue_base_i;
        agu_wdata <= issue_wdata_i;
        agu_imm <= issue_imm_i;
    end
end

assign agu_vaddr = agu_base + agu_imm;
assign mmu_d_req_o = agu_valid;
assign mmu_d_vaddr_o = agu_vaddr;

assign agu_is_load  = agu_mem_op[`MEM_OP_LD_W]  | agu_mem_op[`MEM_OP_LD_B]  |
                      agu_mem_op[`MEM_OP_LD_H]  | agu_mem_op[`MEM_OP_LD_BU] |
                      agu_mem_op[`MEM_OP_LD_HU] | agu_mem_op[`MEM_OP_LL_W];
assign agu_is_store = agu_mem_op[`MEM_OP_ST_W] | agu_mem_op[`MEM_OP_ST_B] |
                      agu_mem_op[`MEM_OP_ST_H] | agu_mem_op[`MEM_OP_SC_W];
assign mmu_d_is_store_o = agu_is_store | agu_is_cacop;

assign agu_paddr = mmu_d_paddr_i;
assign agu_mat = mmu_d_mat_i;
assign agu_tlb_ex = mmu_d_tlb_ex_i;
assign agu_excp_adem = mmu_d_excp_adem_i;

assign sb_query_paddr_o = (dc_valid && dc_sb_query_partial) ? dc_paddr : agu_paddr;
assign agu_sb_hit = agu_is_load && sb_query_hit_i;
assign agu_sb_query_data = sb_query_data_i;
assign agu_sb_partial = agu_is_load && sb_query_partial_i;

assign agu_uncached = (agu_mat == 2'b00) || (agu_mat == 2'b10);

assign agu_detect_ale = (agu_vaddr[0] != 1'b0 &&
                        (agu_mem_op[`MEM_OP_ST_H] | agu_mem_op[`MEM_OP_LD_H] |
                         agu_mem_op[`MEM_OP_LD_HU])) ||
                        (agu_vaddr[1:0] != 2'b00 &&
                        (agu_mem_op[`MEM_OP_ST_W] | agu_mem_op[`MEM_OP_LD_W] |
                         agu_mem_op[`MEM_OP_LL_W] | agu_mem_op[`MEM_OP_SC_W]));

always @(*) begin
    agu_excp = {`EXCP_NUM{1'b0}};
    agu_excp[`EXCP_ALE]    = agu_detect_ale;
    agu_excp[`EXCP_ADEM]   = agu_excp_adem;
    agu_excp[`EXCP_TLBR_M] = agu_tlb_ex[`TLB_EX_TLBR];
    agu_excp[`EXCP_PPI_M]  = agu_tlb_ex[`TLB_EX_PPI];
    agu_excp[`EXCP_PIL]    = agu_tlb_ex[`TLB_EX_PIL];
    agu_excp[`EXCP_PIS]    = agu_tlb_ex[`TLB_EX_PIS];
    agu_excp[`EXCP_PME]    = agu_tlb_ex[`TLB_EX_PME];
end

assign agu_store_data = agu_wdata << {agu_vaddr[1:0], 3'b000};
assign agu_store_wstrb = agu_mem_op[`MEM_OP_ST_B] ? (4'b0001 << agu_vaddr[1:0]) :
                         agu_mem_op[`MEM_OP_ST_H] ? (4'b0011 << agu_vaddr[1:0]) :
                         (agu_mem_op[`MEM_OP_ST_W] | agu_mem_op[`MEM_OP_SC_W]) ? 4'b1111 :
                         4'b0000;

// dc级
always @(posedge clk) begin
    if (reset || flush_i) begin
        dc_valid <= 1'b0;
    end else if (dc_can_accept) begin
            dc_valid <= agu_valid;
            dc_robid <= agu_robid;
            dc_mem_op <= agu_mem_op;
            dc_is_cacop <= agu_is_cacop;
            dc_vaddr <= agu_vaddr;
            dc_paddr <= agu_paddr;
            dc_is_load <= agu_is_load;
            dc_is_store <= agu_is_store;
            dc_wdata <= agu_store_data;
            dc_wstrb <= agu_store_wstrb;
            dc_sb_query_hit <= agu_sb_hit;
            dc_sb_query_data <= agu_sb_query_data;
            dc_sb_query_partial <= agu_sb_partial;
            dc_excp <= agu_excp;
            dc_uncached <= agu_uncached;
    end else if (dc_sb_query_partial) begin
            dc_sb_query_hit <= sb_query_hit_i;
            dc_sb_query_partial <= sb_query_partial_i;
            if (sb_query_hit_i) begin
                dc_sb_query_data <= sb_query_data_i;
            end
    end
end

assign dc_has_excp = |dc_excp;
assign dc_uncached_permit = !dc_uncached || (rob_head_valid_i && (dc_robid == rob_head_robid_i));
assign dc_req = dc_valid && dc_is_load && !dc_has_excp && !dc_sb_query_hit &&
                !dc_sb_query_partial && dc_uncached_permit;
assign dc_req_o = dc_req;

assign dc_data_ok = dc_data_ok_i;
assign dc_rdata = dc_rdata_i;

assign dc_done = dc_valid && (dc_has_excp || dc_is_store || dc_is_cacop ||
                              dc_sb_query_hit || dc_data_ok);
assign dc_can_accept = !dc_valid || dc_done;
assign lsu_ready_o = !agu_valid || dc_can_accept;
assign dc_cancel_o = flush_i;

wire [31:0] load_raw_data;
wire [7:0]  load_byte;
wire [15:0] load_half;
wire [31:0] load_wb_data;

assign load_raw_data = dc_sb_query_hit ? dc_sb_query_data : dc_rdata;  //sb hit则从sb取，否则向DCache发送请求

assign load_byte = (dc_vaddr[1:0] == 2'b00) ? load_raw_data[7:0]   :
                   (dc_vaddr[1:0] == 2'b01) ? load_raw_data[15:8]  :
                   (dc_vaddr[1:0] == 2'b10) ? load_raw_data[23:16] :
                                               load_raw_data[31:24];

assign load_half = dc_vaddr[1] ? load_raw_data[31:16]
                               : load_raw_data[15:0];

assign load_wb_data =
    dc_mem_op[`MEM_OP_LD_B ] ? {{24{load_byte[7]}}, load_byte} :
    dc_mem_op[`MEM_OP_LD_BU] ? {24'b0, load_byte} :
    dc_mem_op[`MEM_OP_LD_H ] ? {{16{load_half[15]}}, load_half} :
    dc_mem_op[`MEM_OP_LD_HU] ? {16'b0, load_half} :
                               load_raw_data;

assign mem_size = (dc_mem_op[`MEM_OP_ST_B] || dc_mem_op[`MEM_OP_LD_B] || dc_mem_op[`MEM_OP_LD_BU]) ? 3'b000 :
                  (dc_mem_op[`MEM_OP_ST_H] || dc_mem_op[`MEM_OP_LD_H] || dc_mem_op[`MEM_OP_LD_HU]) ? 3'b001 :
                  3'b010;     //存储位宽

assign dc_vaddr_o = dc_vaddr;
assign dc_paddr_o = dc_paddr;
assign dc_size_o = mem_size;
assign dc_uncached_o = dc_uncached;
assign uncached_ld_inflight_o = dc_valid && dc_is_load && dc_uncached && !dc_done;

assign wb_valid_o = dc_done;
assign wb_robid_o = dc_robid;
assign wb_data_o = (dc_is_store || dc_is_cacop) ? dc_wdata :
                    (dc_sb_query_hit || dc_data_ok) ? load_wb_data :
                    32'b0;

assign wb_paddr_o = dc_paddr;
assign wb_vaddr_o = dc_vaddr;
assign wb_wstrb_o = dc_wstrb;
assign wb_size_o = mem_size;
assign wb_uncached_o = dc_uncached;
assign wb_excp_o  = dc_excp;

assign early_wakeup_valid_o = 1'b0;
assign early_wakeup_robid_o = {`ROB_W{1'b0}};

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
