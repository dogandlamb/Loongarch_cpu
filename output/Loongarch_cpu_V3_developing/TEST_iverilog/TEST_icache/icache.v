`include "mycpu.h"

// ============================================================
// icache 模块（L1 指令缓存，新架构端口：整行取指 + 简化冲刷语义）
// ------------------------------------------------------------
// 功能（新架构）：
// - IFU 一次取一整行（`CACHE_LINE_BITS），由 IFU 自行按块偏移切指令；
// - 取指地址翻译在 IFU/MMU 完成后送入（VIPT：vaddr 做索引、paddr 比 tag）；
// - 冲刷语义大幅简化：旧架构的 redirect_stale_*/branch_redirect 系列
//   补丁全部废弃——新前端冲刷时 IFU 用 cancel + 在途配对自行丢弃返回，
//   icache 只需要支持 cancel 在途请求；
// - cacop 由 commit 提交级驱动（idx_inv/hit_inv，物理地址）。
// - 目标几何参数：`L1_NWAY(4) 路 × `L1_NSET(128) 组 × `CACHE_LINE_BYTES(32B) 行
//   （旧实现为 2 路 256 组 16B 行，需按宏改造，见 TODO）。
//
// 端口：
// - ifu_*   ：取指口（请求/整行返回/取消）
// - cacop_* ：cache 维护口（commit）
// - axi_*   ：下层 L2 接口（128bit/拍 多拍传输，原样保留）
// ============================================================
module icache (
    input  wire        clk,
    input  wire        resetn,

    // ---------------- IFU 取指口 ----------------
    input  wire        ifu_req_i,        // 取指请求（保持至 addr_ok）
    input  wire [31:0] ifu_vaddr_i,      // 虚地址（VIPT 索引）
    input  wire [31:0] ifu_paddr_i,      // 物理地址（tag 比对）
    input  wire        ifu_uncached_i,   // 非缓存取指
    output wire        ifu_addr_ok_o,    // 请求被接收
    output wire        ifu_data_ok_o,    // 整行数据有效（一拍）
    output wire [`CACHE_LINE_BITS-1:0] ifu_rline_o, // 整行指令数据
    input  wire        ifu_cancel_i,     // 冲刷：作废在途请求/返回

    // ---------------- cache 维护口（commit 提交级驱动）----------------
    input  wire        cacop_en_i,
    input  wire [1:0]  cacop_op_i,       // `CACOP_OP_IDX_INV / HIT_INV
    input  wire [31:0] cacop_addr_i,     // 物理地址

    // ---------------- 下层 L2 接口（原样保留）----------------
    output wire        axi_rd_req,
    output wire [2:0]  axi_rd_type,
    output wire [31:0] axi_rd_addr,
    input  wire        axi_rd_rdy,
    input  wire        axi_ret_valid,
    input  wire        axi_ret_last,
    input  wire [127:0] axi_ret_data
);

// ============================================================
//TODO: 改造说明（下方保留旧实现作为基底，按以下步骤改造）：
//
//TODO: 第一步——几何参数改宏：SETS/SET_W/TAG_W 改用 `L1_NSET/`L1_INDEX_W/
//      `L1_TAG_W，行宽 16B->32B（bank 数 4->8 或行寄存器位宽翻倍），
//      路数 2->4（way0/way1 扩为 4 路 + LRU 改 4 路伪 LRU 或随机）。
//
//TODO: 第二步——输出整行：命中时把选中 way 的整行（8 个 bank 拼接）一拍
//      输出到 ifu_rline_o（旧实现按字选择输出 32bit 的逻辑废弃）；
//      refill 返回时整行边填边拼，填完输出（critical-word-first 二期做）。
//
//TODO: 第三步——删除旧补丁逻辑：redirect_stale_* / branch_line_snap /
//      resp_echo_* / cancel_resp_holdoff 等全部删除——这些是旧顺序流水
//      "分支冲刷与多拍取指纠缠"的产物；新架构 IFU 用"在途请求配对+丢弃"
//      统一处理，icache 只需在 ifu_cancel_i 时安全作废在途状态
//      （正在 AXI 交互的行允许填完，但不要发 data_ok）。
//
//TODO: 第四步——uncached 取指：按 ifu_uncached_i 旁路 cache（单字 AXI 读，
//      返回时拼到行的对应字位置，其余字无效——IFU 只会用块内有效部分）。
//
//TODO: 第五步——cacop：保留旧 cacop 通路（idx_inv/hit_inv），改为接受
//      cacop_*_i 新端口；ibar 的"I$ 全失效"可以用 idx_inv 循环或一拍
//      全清 valid 位（推荐后者，valid 用寄存器阵列时一拍清零很容易）。
//
//TODO: 二期性能优化（AXI 优化约定）：critical-word-first（目标字先回）、
//      取指预取口（FTQ 引导）、双 outstanding（与 dcache 各占一个 AXI id）。
//
// 下方为旧端口名到新端口的桥接（保证旧代码体可编译，改造时逐步替换删除）：
// ============================================================
wire        if_valid = ifu_req_i;
wire [31:0] if_pc    = ifu_paddr_i;          // 旧体内 if_pc 当物理地址用
wire [31:0] if_vpc   = ifu_vaddr_i;
wire [1:0]  if_mat   = ifu_uncached_i ? 2'b00 : 2'b01;
wire        cacop_en   = cacop_en_i;
wire [1:0]  cacop_op   = cacop_op_i;
wire [31:0] cacop_addr = cacop_addr_i;
wire [1:0]  cacop_mat  = 2'b01;
wire        tlb_excp_cancel_req     = ifu_cancel_i;
wire        branch_redirect_cancel  = 1'b0;   // 旧分支冲刷补丁通路废弃，恒 0
wire [31:0] redirect_target_pc      = 32'b0;
wire [31:0] redirect_branch_inst    = 32'b0;
wire [31:0] redirect_branch_pc      = 32'b0;
wire [31:0] redirect_fallthrough_inst = 32'b0;
wire        tlb_valid  = 1'b1;
wire [31:0] tlb_paddr  = ifu_paddr_i;
// 旧输出口转内部信号（旧代码体继续驱动它们；新输出在下方桥接）
wire        if_addr_ok;
wire        if_data_ok;
wire [31:0] if_data;
wire [31:0] if_pc_out;
wire [31:0] if_vpc_out;
wire        stall_if;
wire        redirect_stale_block;
wire        redirect_stale_refill_wait;
wire        redirect_stale_word_valid_o;
wire [31:0] redirect_stale_word_o;
wire        redirect_stale_ft_valid_o;
wire [31:0] redirect_stale_ft_word_o;
wire [31:0] redirect_stale_addr_o;
wire        redirect_source_line_valid_o;
wire [127:0] redirect_source_line_o;

assign ifu_addr_ok_o = if_addr_ok;
assign ifu_data_ok_o = if_data_ok;
//TODO: 占位桥接！旧实现一次只出 32bit 指令字，这里临时把它放在行低 32 位，
//      其余位填 0 —— 功能不正确，仅为框架可编译。完成"第二步整行输出"
//      改造后，把选中 way 的完整行接到 ifu_rline_o 并删除本占位。
assign ifu_rline_o = {{(`CACHE_LINE_BITS-32){1'b0}}, if_data};

localparam SETS   = 256;
localparam SET_W  = 8;
localparam TAG_W  = 20;
localparam S_IDLE = 2'd0;
localparam S_WAIT = 2'd1;
localparam S_FILL = 2'd2;
localparam S_INIT = 2'd3;

reg [1:0]       state;
reg [SET_W-1:0] init_set;
reg [31:0]      req_pc;
reg [31:0]      req_vpc;
reg             uncached_r;
reg             req_way;
reg             refill_echo_block;
reg             resp_echo_block;
reg [31:0]      resp_echo_pc;
reg [1:0]       cancel_resp_holdoff;
reg             redirect_inval_holdoff;
reg             redirect_adj_inval_pending;
reg [SET_W-1:0] redirect_adj_inval_set;
reg             redirect_ft_inval_pending;
reg [SET_W-1:0] redirect_ft_inval_set;
reg             redirect_prev_inval_pending;
reg [SET_W-1:0] redirect_prev_inval_set;
reg             redirect_miss_active;
reg [SET_W-1:0] redirect_miss_set;
reg             redirect_miss_seq;
reg             req_miss_seq;
reg [1:0]       cache_line_step_holdoff;
reg [1:0]       set_settling_holdoff;
reg             redirect_target_inval_pending;
reg             redirect_stale_word_valid;
reg [31:0]      redirect_stale_word;
reg             redirect_stale_ft_valid;
reg [31:0]      redirect_stale_ft_word;
reg [31:0]      redirect_stale_addr;
reg [SET_W-1:0] redirect_stale_set;
reg             redirect_stale_same_line;
reg             redirect_target_miss_pend;
reg [SET_W-1:0] redirect_target_miss_set;
reg [2:0]       redirect_stale_data_holdoff;
reg [127:0]     last_hit_line;
reg [31:0]      last_hit_line_addr;
reg [127:0]     redirect_source_line;
reg [31:0]      redirect_source_line_addr;
reg             redirect_source_line_valid;
reg [127:0]     branch_line_snap;
reg             branch_line_snap_valid;
reg [SET_W-1:0] ram_set_q_prev;
reg [31:0]      prev_fetch_addr;
reg [SET_W-1:0] req_set;
reg [TAG_W-1:0] req_tag;
reg [255:0]     lru_way1;
integer         idx;

// ------------------------------------------------------------
// BRAM is synchronous: dout reflects the *previous* cycle address.
// Align tag compare / word select with BRAM dout by registering the
// lookup request (address + attributes) for one cycle.
// ------------------------------------------------------------
reg [31:0]      lk_addr;
reg [31:0]      lk_vpc;
reg             lk_valid;
reg             lk_uncached;
reg [SET_W-1:0] ram_set_q;

// Instruction fetches are word-aligned; forcing [1:0]=00 avoids X on PC low bits in sim.
wire [31:0] cur_addr_i = tlb_valid ? tlb_paddr : if_pc;
wire [31:0] cur_addr    = { cur_addr_i[31:2], 2'b00 };
wire [SET_W-1:0] cur_set = cur_addr[11:4];
wire [TAG_W-1:0] cur_tag = cur_addr[31:12];
wire [1:0] cur_word_sel = cur_addr[3:2];
// LoongArch MAT: 2'b00/2'b10 = uncached, 2'b01 = coherent cached (see CRMD.DATF).
wire if_uncached = (if_mat === 2'b00) || (if_mat === 2'b10);

// 4-state safe: treat cacop_en as asserted only when strictly 1.
wire cacop_en_safe = (cacop_en === 1'b1);
wire cancel_req = tlb_excp_cancel_req || cacop_en_safe;
wire branch_cross_line_redirect = branch_redirect_cancel
                                && (redirect_target_pc[31:4] !== redirect_branch_pc[31:4]);
// 同 line 内 taken 分支（如 account_user_time bdc→bf0）：sync BRAM 可能把 fall-through 字
// （be0 move）当作目标 bf0 返回；须按 fall-through 字做 stale 屏蔽直到 refill。
wire branch_same_line_redirect = branch_redirect_cancel
                               && (redirect_target_pc[31:4] === redirect_branch_pc[31:4])
                               && ({redirect_target_pc[31:2], 2'b00}
                                !== {redirect_branch_pc[31:2], 2'b00});
wire [31:0] redirect_ft_pc  = redirect_branch_pc + 32'h4;
wire [1:0]  redirect_ft_sel = redirect_ft_pc[3:2];
wire [31:0] redirect_cur_addr = branch_cross_line_redirect ? {redirect_target_pc[31:2], 2'b00} : cur_addr;
wire [SET_W-1:0] redirect_cur_set = redirect_cur_addr[11:4];
// tag inval 仍用 cur_addr，避免 boot 期 branch 跨 line 时误 invalidate 目标/adj set。
// redirect 专用 cancel：不含 CACOP（boot cache init 每拍 cancel_req 会误触 inval 风暴）。
wire redirect_event_cancel = branch_redirect_cancel || tlb_excp_cancel_req;
wire redirect_target_line_fetch = branch_cross_line_redirect
                                && (prev_fetch_addr[31:4] === redirect_target_pc[31:4]);
wire redirect_set_change = redirect_event_cancel && ((prev_fetch_addr[31:4] !== cur_addr[31:4])
                        || redirect_target_line_fetch);
// cancel 同拍 IF cur_addr 可能尚未切到 nextpc；branch 跨 line 时用 nextpc 判定 force miss。
wire redirect_line_change = redirect_event_cancel
                          && (prev_fetch_addr[31:4] !== redirect_cur_addr[31:4]);

wire [31:0] lk_tag = lk_addr[31:12];
wire [SET_W-1:0] lk_set = lk_addr[11:4];
wire [1:0] lk_word_sel = lk_addr[3:2];

wire [17:0] cur_ram_addr = {10'b0, cur_set};
wire [17:0] lk_ram_addr  = {10'b0, lk_set};
wire [17:0] req_ram_addr = {10'b0, req_set};
wire [17:0] cacop_ram_addr = {10'b0, cacop_addr[11:4]};
wire [17:0] init_ram_addr = {10'b0, init_set};
wire redirect_adj_inval = redirect_adj_inval_pending && !redirect_prev_inval_pending
                      && !redirect_ft_inval_pending
                      && !cancel_req && (state === S_IDLE) && !cacop_en_safe;
wire redirect_ft_inval = redirect_ft_inval_pending && !redirect_prev_inval_pending
                       && !cancel_req && (state === S_IDLE) && !cacop_en_safe;
wire redirect_prev_inval = redirect_prev_inval_pending && !cancel_req
                         && (state === S_IDLE) && !cacop_en_safe;
wire redirect_target_inval = redirect_target_inval_pending && !cancel_req
                           && (state === S_IDLE) && !cacop_en_safe;
wire [17:0] prev_inval_ram_addr = {10'b0, redirect_prev_inval_set};
wire [17:0] adj_inval_ram_addr = {10'b0, redirect_adj_inval_set};
wire [17:0] ft_inval_ram_addr = {10'b0, redirect_ft_inval_set};
wire [17:0] cache_ram_addr = redirect_target_inval ? {10'b0, redirect_stale_set}
                        : redirect_adj_inval ? adj_inval_ram_addr
                        : redirect_ft_inval ? ft_inval_ram_addr
                        : redirect_prev_inval ? prev_inval_ram_addr
                        : (state === S_INIT) ? init_ram_addr
                        : (cacop_en_safe ? cacop_ram_addr
                        : ((state === S_FILL) ? req_ram_addr : cur_ram_addr));
wire ram_lk_match = (ram_set_q === lk_set);

wire [31:0] way0_tagv_dout;
wire [31:0] way1_tagv_dout;
wire [31:0] way0_bank0_dout;
wire [31:0] way0_bank1_dout;
wire [31:0] way0_bank2_dout;
wire [31:0] way0_bank3_dout;
wire [31:0] way1_bank0_dout;
wire [31:0] way1_bank1_dout;
wire [31:0] way1_bank2_dout;
wire [31:0] way1_bank3_dout;

wire [20:0] way0_tagv = way0_tagv_dout[20:0];
wire [20:0] way1_tagv = way1_tagv_dout[20:0];

wire way0_valid = way0_tagv[20];
wire way1_valid = way1_tagv[20];
wire refill_echo_hit = (refill_echo_block === 1'b1) && (lk_addr[31:2] === req_pc[31:2]);
wire way0_hit = (state === S_IDLE) && (ram_lk_match === 1'b1) && (lk_valid === 1'b1) && (lk_uncached === 1'b0)
                && (cacop_en_safe !== 1'b1) && (refill_echo_hit !== 1'b1)
                && (way0_valid === 1'b1) && (way0_tagv[19:0] === lk_tag);
wire way1_hit = (state === S_IDLE) && (ram_lk_match === 1'b1) && (lk_valid === 1'b1) && (lk_uncached === 1'b0)
                && (cacop_en_safe !== 1'b1) && (refill_echo_hit !== 1'b1)
                && (way1_valid === 1'b1) && (way1_tagv[19:0] === lk_tag);
// BRAM dout 对齐 lk_addr；当前拍 cur_addr 已变而 lk 仍为上拍请求时，不能对旧行报 hit。
// lk_valid=0（cancel 清空）时亦禁止 hit：否则 redirect 后首拍会用上一 set 的 stale dout
// 误匹配同 tag 行（例如 redirect 目标 d80 却返回 cd0 的 bltu）。
wire fetch_addr_aligned = (lk_valid === 1'b1) && (lk_addr === cur_addr);
wire post_cancel_block = (cancel_req === 1'b1)
                      || (cancel_resp_holdoff != 2'b00);
wire redirect_lookup_block = (redirect_inval_holdoff === 1'b1) || redirect_adj_inval
                          || redirect_ft_inval || redirect_prev_inval || redirect_target_inval;
// cancel 同拍 cross-line redirect 时 combinational force miss（redirect_miss_active 要下一拍才置位）。
wire redirect_cancel_force_miss = redirect_line_change;
// 同步 BRAM 口地址 ram_set_q 落后 cur_set 时，dout 仍是上一 set 数据（d80 ghost @189720000）。
wire bram_set_lag = (ram_set_q !== cur_set);
// ram_set_q 刚切到 cur_set 时，同步 BRAM data dout 仍可能是上一 set 的同 tag 行（d80 ghost）。
wire set_settling = (ram_set_q === cur_set) && (ram_set_q_prev !== cur_set);
wire icache_lookup_clean = fetch_addr_aligned
                        && !bram_set_lag
                        && (set_settling_holdoff === 2'b00)
                        && (cache_line_step_holdoff === 2'b00);
// 仅在 redirect 恢复完成后，顺序跨 line 时屏蔽 BRAM 误 hit（1810/a06dd120）。
wire cache_line_step = (prev_fetch_addr[31:4] !== cur_addr[31:4])
                    && (cancel_req !== 1'b1)
                    && (post_cancel_block !== 1'b1)
                    && (redirect_adj_inval_pending !== 1'b1)
                    && (redirect_prev_inval_pending !== 1'b1)
                    && !redirect_miss_active;
wire [127:0] way0_line = {way0_bank3_dout, way0_bank2_dout, way0_bank1_dout, way0_bank0_dout};
wire [127:0] way1_line = {way1_bank3_dout, way1_bank2_dout, way1_bank1_dout, way1_bank0_dout};
wire [127:0] hit_line = way1_hit ? way1_line : way0_line;

function [31:0] pick_word;
    input [127:0] line;
    input [1:0] word_sel;
    begin
        case (word_sel)
            2'd0: pick_word = line[31:0];
            2'd1: pick_word = line[63:32];
            2'd2: pick_word = line[95:64];
            default: pick_word = line[127:96];
        endcase
    end
endfunction

function line_contains_word;
    input [127:0] line;
    input [31:0]  word;
    begin
        line_contains_word = (line[31:0] === word) || (line[63:32] === word)
                          || (line[95:64] === word) || (line[127:96] === word);
    end
endfunction

wire [31:0] hit_pc = {lk_addr[31:2], 2'b00};
wire [31:0] hit_data = pick_word(hit_line, lk_word_sel);
wire redirect_stale_hit_block = redirect_stale_word_valid
                              && (cur_addr === redirect_stale_addr)
                              && (hit_data === redirect_stale_word);
// 跨 line redirect 后 sync BRAM 可能把 fall-through 字（bc3c→bdf0 的 lu12i）当作目标返回。
wire redirect_ft_stale_hit_block = redirect_stale_ft_valid
                                 && redirect_stale_word_valid
                                 && (cur_addr === redirect_stale_addr)
                                 && (hit_data === redirect_stale_ft_word);
// BRAM set 切换窗口内禁止目标行 sync hit，避免跨 line 分支后错行 ghost（228M b360 ld.w）。
wire redirect_stale_bram_block = redirect_stale_word_valid
                               && (cur_addr === redirect_stale_addr)
                               && (bram_set_lag || (ram_set_q !== redirect_stale_set));
wire redirect_stale_data_block = (redirect_stale_data_holdoff !== 3'b000)
                               && (cur_addr === redirect_stale_addr);
wire redirect_target_miss_pend_eff = redirect_target_miss_pend
                                   && !(fill_data_ok && (req_pc === redirect_stale_addr));
wire redirect_target_miss_block = redirect_target_miss_pend_eff
                                && (cur_addr === redirect_stale_addr);
wire redirect_branch_stale_comb = branch_cross_line_redirect
                                 && (cur_addr === {redirect_target_pc[31:2], 2'b00})
                                 && (hit_data === redirect_branch_inst);
// cancel 同拍 combinational fall-through ghost（寄存器 stale 下一拍才生效）。
wire redirect_ft_stale_comb = branch_cross_line_redirect
                           && (cur_addr === {redirect_target_pc[31:2], 2'b00})
                           && (redirect_fallthrough_inst !== 32'b0)
                           && (hit_data === redirect_fallthrough_inst);
// 跨 line redirect 后：目标 sync hit 的数据若仍属于源 cache line 任一字，一律 block+miss。
wire redirect_source_line_block = redirect_source_line_valid
                                && redirect_stale_word_valid
                                && (cur_addr === redirect_stale_addr)
                                && line_contains_word(redirect_source_line, hit_data);
// stale 窗口内目标 PC 禁止 sync hit（只允许 AXI refill 返回），避免 tag hit 返回旧行 ghost。
wire redirect_stale_target_sync_block = redirect_stale_word_valid
                                      && (cur_addr === redirect_stale_addr)
                                      && !fill_data_ok;
wire redirect_stale_sync_block = redirect_stale_hit_block || redirect_ft_stale_hit_block
                               || redirect_ft_stale_comb
                               || redirect_branch_stale_comb
                               || redirect_stale_bram_block
                               || redirect_stale_data_block
                               || redirect_source_line_block
                               || redirect_stale_target_sync_block;
assign redirect_stale_block = redirect_stale_sync_block
                           || redirect_target_miss_block;
wire redirect_target_force_miss = redirect_cancel_force_miss
                               || (redirect_miss_active && (cur_set === redirect_miss_set))
                               || redirect_stale_bram_block
                               || redirect_stale_data_block
                               || redirect_target_miss_block
                               || redirect_source_line_block
                               || redirect_stale_target_sync_block;
// refill 完成拍（S_FILL）须允许 IF 接收；hold 仅限 miss 等待（S_WAIT）。
assign redirect_stale_refill_wait = ((redirect_stale_word_valid || redirect_miss_active)
                                   && (state === S_WAIT));
// refill 同拍须放行 if_data_ok，否则 redirect_stale_block 永久屏蔽 fill 导致 livelock。
wire redirect_stale_if_suppress = (redirect_stale_sync_block || redirect_target_miss_block)
                                && !fill_data_ok;
wire tag_sync_hit = (ram_lk_match === 1'b1)
                 && ((way0_hit === 1'b1) || (way1_hit === 1'b1));
// stale/redirect 窗口内 tag 仍 hit 但 dout 不可信；须 miss 不能 LRU（func_lab19@17K）。
wire stale_tag_hit_needs_miss = tag_sync_hit
                             && (redirect_stale_block || redirect_target_force_miss);
wire hit_clean = fetch_addr_aligned
              && (post_cancel_block !== 1'b1)
              && (redirect_lookup_block !== 1'b1)
              && (cache_line_step_holdoff === 2'b00)
              && (set_settling_holdoff === 2'b00)
              && !redirect_target_force_miss
              && !redirect_stale_sync_block
              && !bram_set_lag
              && tag_sync_hit;

// CACOP/refetch 到来时要取消在途读返回，避免自修改代码场景下旧指令回放。
// 替换路选择必须对应已经锁存的一拍查找请求，因为同步 BRAM 的 dout 对齐 lk_addr。
wire replace_way = (way0_valid !== 1'b1) ? 1'b0 : ((way1_valid !== 1'b1) ? 1'b1 : lru_way1[lk_set]);
// CACOP 与 refill 返回同拍时，优先执行目标 set 失效；旧 refill 直接丢弃。
wire fill_accept = (state === S_FILL) && axi_ret_valid && (uncached_r !== 1'b1) && (cancel_req !== 1'b1);
wire [127:0] fill_line = axi_ret_data;
wire [31:0] fill_word = fill_line[31:0];

// 旧请求在 cancel 时会退出 S_FILL，AXI 桥也只允许单 outstanding 读，这里不能再用当前 PC 过滤。
wire refill_cur_match = 1'b1;
wire [31:0] ret_pc = req_pc;
// Uncached AXI beats return one 32-bit word in axi_ret_data[31:0] (see axi_line_bridge).
wire [31:0] ret_data = uncached_r ? axi_ret_data[31:0] : pick_word(axi_ret_data, ret_pc[3:2]);
wire fill_data_ok = (state === S_FILL) && axi_ret_valid
                 && (refill_cur_match === 1'b1) && (cancel_req !== 1'b1);
wire raw_data_ok = hit_clean || fill_data_ok;
wire [31:0] raw_pc_out = hit_clean ? hit_pc : ret_pc;
wire duplicate_resp = (resp_echo_block === 1'b1) && (raw_data_ok === 1'b1)
                   && (raw_pc_out === resp_echo_pc);
// stall_if 期间同址 hit 仍需每拍响应，不能靠 duplicate 永久屏蔽 ifok。
wire same_pc_fetch_hold = (lk_valid === 1'b1) && (if_valid === 1'b1)
                       && (lk_addr === cur_addr);

wire init_inval_we = (state === S_INIT);

// ICache 的 CACOP op0/op1/op2 在功能测试中都用于让目标指令行失效；
// op2 在 DCache 侧可表示写回类操作，但 ICache 没有 dirty，需要按 hit invalidate 处理。
wire invalidate_set = cacop_en_safe && ((cacop_op == `CACOP_OP_IDX_INV)
                                     || (cacop_op == `CACOP_OP_HIT_INV)
                                     || (cacop_op == `CACOP_OP_HIT_WB));
// 分支 redirect 跨 cache line 时 invalidate 目标行；下一拍 invalidate 源 set（cd0），再 invalidate 相邻行。
wire [31:0] way0_tagv_inval_data = init_inval_we ? 32'b0 : {11'b0, 1'b0, way0_tagv[19:0]};
wire [31:0] way1_tagv_inval_data = init_inval_we ? 32'b0 : {11'b0, 1'b0, way1_tagv[19:0]};
wire [31:0] way0_tagv_fill_data = {11'b0, 1'b1, req_tag};
wire [31:0] way1_tagv_fill_data = {11'b0, 1'b1, req_tag};

wire way0_tagv_we = fill_accept && !req_way;
wire way1_tagv_we = fill_accept && req_way;
wire way0_inval_we = invalidate_set || init_inval_we || redirect_set_change || redirect_adj_inval
                    || redirect_ft_inval || redirect_prev_inval || redirect_target_inval;
wire way1_inval_we = invalidate_set || init_inval_we || redirect_set_change || redirect_adj_inval
                    || redirect_ft_inval || redirect_prev_inval || redirect_target_inval;

wire [31:0] way0_bank0_fill_data = fill_line[31:0];
wire [31:0] way0_bank1_fill_data = fill_line[63:32];
wire [31:0] way0_bank2_fill_data = fill_line[95:64];
wire [31:0] way0_bank3_fill_data = fill_line[127:96];
wire [31:0] way1_bank0_fill_data = fill_line[31:0];
wire [31:0] way1_bank1_fill_data = fill_line[63:32];
wire [31:0] way1_bank2_fill_data = fill_line[95:64];
wire [31:0] way1_bank3_fill_data = fill_line[127:96];

assign if_addr_ok = (state === S_IDLE) && (cacop_en_safe !== 1'b1)
                  && !redirect_adj_inval && !redirect_ft_inval && !redirect_prev_inval && !redirect_target_inval;
assign if_data_ok = raw_data_ok
                 && (post_cancel_block !== 1'b1)
                 && (redirect_lookup_block !== 1'b1)
                 && !redirect_stale_if_suppress
                 && ((duplicate_resp !== 1'b1) || same_pc_fetch_hold);
assign if_data = hit_clean ? hit_data : ret_data;
assign if_pc_out = raw_pc_out;
assign if_vpc_out = hit_clean ? lk_vpc : req_vpc;
assign stall_if = (if_valid === 1'b1) && !if_data_ok;

assign axi_rd_req = (state === S_WAIT) && (cancel_req !== 1'b1);
assign axi_rd_type = uncached_r ? 3'b010 : 3'b100;
assign axi_rd_addr = uncached_r ? req_pc : {req_pc[31:4], 4'b0000};

assign redirect_stale_word_valid_o  = redirect_stale_word_valid;
assign redirect_stale_word_o        = redirect_stale_word;
assign redirect_stale_ft_valid_o    = redirect_stale_ft_valid;
assign redirect_stale_ft_word_o     = redirect_stale_ft_word;
assign redirect_stale_addr_o        = redirect_stale_addr;
assign redirect_source_line_valid_o = redirect_source_line_valid;
assign redirect_source_line_o       = redirect_source_line;

icache_way0_TAGV_ram u_icache_way0_TAGV_ram(
    .addra(cache_ram_addr),
    .clka(clk),
    .dina(fill_accept ? way0_tagv_fill_data : way0_tagv_inval_data),
    .douta(way0_tagv_dout),
    .ena(1'b1),
    .wea(way0_tagv_we ? 4'hF : (way0_inval_we ? 4'hF : 4'h0))
);

icache_way1_TAGV_ram u_icache_way1_TAGV_ram(
    .addra(cache_ram_addr),
    .clka(clk),
    .dina(fill_accept ? way1_tagv_fill_data : way1_tagv_inval_data),
    .douta(way1_tagv_dout),
    .ena(1'b1),
    .wea(way1_tagv_we ? 4'hF : (way1_inval_we ? 4'hF : 4'h0))
);

icache_way0_Bank0_ram u_icache_way0_Bank0_ram(.addra(cache_ram_addr), .clka(clk), .dina(way0_bank0_fill_data), .douta(way0_bank0_dout), .ena(1'b1), .wea(fill_accept && !req_way ? 4'hF : 4'h0));
icache_way0_Bank1_ram u_icache_way0_Bank1_ram(.addra(cache_ram_addr), .clka(clk), .dina(way0_bank1_fill_data), .douta(way0_bank1_dout), .ena(1'b1), .wea(fill_accept && !req_way ? 4'hF : 4'h0));
icache_way0_Bank2_ram u_icache_way0_Bank2_ram(.addra(cache_ram_addr), .clka(clk), .dina(way0_bank2_fill_data), .douta(way0_bank2_dout), .ena(1'b1), .wea(fill_accept && !req_way ? 4'hF : 4'h0));
icache_way0_Bank3_ram u_icache_way0_Bank3_ram(.addra(cache_ram_addr), .clka(clk), .dina(way0_bank3_fill_data), .douta(way0_bank3_dout), .ena(1'b1), .wea(fill_accept && !req_way ? 4'hF : 4'h0));
icache_way1_Bank0_ram u_icache_way1_Bank0_ram(.addra(cache_ram_addr), .clka(clk), .dina(way1_bank0_fill_data), .douta(way1_bank0_dout), .ena(1'b1), .wea(fill_accept && req_way ? 4'hF : 4'h0));
icache_way1_Bank1_ram u_icache_way1_Bank1_ram(.addra(cache_ram_addr), .clka(clk), .dina(way1_bank1_fill_data), .douta(way1_bank1_dout), .ena(1'b1), .wea(fill_accept && req_way ? 4'hF : 4'h0));
icache_way1_Bank2_ram u_icache_way1_Bank2_ram(.addra(cache_ram_addr), .clka(clk), .dina(way1_bank2_fill_data), .douta(way1_bank2_dout), .ena(1'b1), .wea(fill_accept && req_way ? 4'hF : 4'h0));
icache_way1_Bank3_ram u_icache_way1_Bank3_ram(.addra(cache_ram_addr), .clka(clk), .dina(way1_bank3_fill_data), .douta(way1_bank3_dout), .ena(1'b1), .wea(fill_accept && req_way ? 4'hF : 4'h0));

always @(posedge clk) begin
    if (!resetn) begin
        state <= S_INIT;
        init_set <= {SET_W{1'b0}};
        req_pc <= 32'b0;
        req_vpc <= 32'b0;
        uncached_r <= 1'b0;
        req_way <= 1'b0;
        refill_echo_block <= 1'b0;
        resp_echo_block <= 1'b0;
        resp_echo_pc <= 32'b0;
        cancel_resp_holdoff <= 2'b00;
        redirect_inval_holdoff <= 1'b0;
        redirect_adj_inval_pending <= 1'b0;
        redirect_adj_inval_set <= {SET_W{1'b0}};
        redirect_ft_inval_pending <= 1'b0;
        redirect_ft_inval_set <= {SET_W{1'b0}};
        redirect_prev_inval_pending <= 1'b0;
        redirect_prev_inval_set <= {SET_W{1'b0}};
        redirect_miss_active <= 1'b0;
        redirect_miss_set <= {SET_W{1'b0}};
        redirect_miss_seq <= 1'b0;
        req_miss_seq <= 1'b0;
        cache_line_step_holdoff <= 2'b00;
        set_settling_holdoff <= 2'b00;
        redirect_target_inval_pending <= 1'b0;
        redirect_stale_word_valid <= 1'b0;
        redirect_stale_word <= 32'b0;
        redirect_stale_ft_valid <= 1'b0;
        redirect_stale_ft_word <= 32'b0;
        redirect_stale_addr <= 32'b0;
        redirect_stale_set <= {SET_W{1'b0}};
        redirect_stale_same_line <= 1'b0;
        redirect_target_miss_pend <= 1'b0;
        redirect_target_miss_set <= {SET_W{1'b0}};
        redirect_stale_data_holdoff <= 3'b000;
        last_hit_line <= 128'b0;
        last_hit_line_addr <= 32'b0;
        redirect_source_line <= 128'b0;
        redirect_source_line_addr <= 32'b0;
        redirect_source_line_valid <= 1'b0;
        branch_line_snap <= 128'b0;
        branch_line_snap_valid <= 1'b0;
        ram_set_q_prev <= {SET_W{1'b0}};
        prev_fetch_addr <= 32'b0;
        req_set <= {SET_W{1'b0}};
        req_tag <= {TAG_W{1'b0}};
        lk_addr <= 32'b0;
        lk_vpc <= 32'b0;
        lk_valid <= 1'b0;
        lk_uncached <= 1'b0;
        ram_set_q <= {SET_W{1'b0}};
        lru_way1 <= 256'b0;
    end else begin
        // Capture lookup request for synchronous BRAM alignment.
        if (cancel_req || redirect_adj_inval || redirect_ft_inval || redirect_prev_inval || redirect_target_inval) begin
            lk_valid <= 1'b0;
        end else begin
            lk_valid <= (if_valid === 1'b1);
        end
        lk_addr     <= cur_addr;
        lk_vpc      <= if_vpc;
        lk_uncached <= if_uncached;
        ram_set_q   <= cache_ram_addr[SET_W-1:0];
        refill_echo_block <= (fill_data_ok === 1'b1);
        if (cancel_req) begin
            cancel_resp_holdoff <= redirect_line_change ? 2'b11 : 2'b10;
            redirect_inval_holdoff <= redirect_set_change;
            if (branch_cross_line_redirect) begin
                redirect_stale_same_line <= 1'b0;
                redirect_stale_word <= redirect_branch_inst;
                redirect_stale_ft_word <= redirect_fallthrough_inst;
                redirect_stale_ft_valid <= (redirect_fallthrough_inst !== 32'b0);
                redirect_stale_addr <= {redirect_target_pc[31:2], 2'b00};
                redirect_stale_set <= redirect_cur_set;
                redirect_stale_word_valid <= 1'b1;
                redirect_target_miss_pend <= 1'b1;
                redirect_target_miss_set <= redirect_cur_set;
                if (redirect_target_line_fetch) begin
                    redirect_target_inval_pending <= 1'b1;
                end
                if (redirect_ft_pc[31:4] !== redirect_branch_pc[31:4]) begin
                    redirect_ft_inval_pending <= 1'b1;
                    redirect_ft_inval_set <= redirect_ft_pc[11:4];
                end
                redirect_source_line_addr <= {redirect_branch_pc[31:4], 4'b0000};
                if (branch_line_snap_valid) begin
                    redirect_source_line <= branch_line_snap;
                    redirect_source_line_valid <= 1'b1;
                end else if (last_hit_line_addr === {redirect_branch_pc[31:4], 4'b0000}) begin
                    redirect_source_line <= last_hit_line;
                    redirect_source_line_valid <= 1'b1;
                end else if ((prev_fetch_addr[31:4] === redirect_branch_pc[31:4])
                          && (last_hit_line_addr === {prev_fetch_addr[31:4], 4'b0000})) begin
                    redirect_source_line <= last_hit_line;
                    redirect_source_line_valid <= 1'b1;
                end
            end else if (branch_same_line_redirect) begin
                redirect_stale_same_line <= 1'b1;
                redirect_stale_ft_valid <= 1'b0;
                redirect_stale_ft_word <= 32'b0;
                redirect_stale_addr <= {redirect_target_pc[31:2], 2'b00};
                redirect_stale_set <= redirect_branch_pc[11:4];
                redirect_source_line_addr <= {redirect_branch_pc[31:4], 4'b0000};
                redirect_target_miss_pend <= 1'b1;
                redirect_target_miss_set <= redirect_branch_pc[11:4];
                if (branch_line_snap_valid) begin
                    redirect_stale_word <= pick_word(branch_line_snap, redirect_ft_sel);
                    redirect_stale_word_valid <= 1'b1;
                    redirect_source_line <= branch_line_snap;
                    redirect_source_line_valid <= 1'b1;
                end else if (last_hit_line_addr === {redirect_branch_pc[31:4], 4'b0000}) begin
                    redirect_stale_word <= pick_word(last_hit_line, redirect_ft_sel);
                    redirect_stale_word_valid <= 1'b1;
                    redirect_source_line <= last_hit_line;
                    redirect_source_line_valid <= 1'b1;
                end else if (redirect_fallthrough_inst !== 32'b0) begin
                    redirect_stale_word <= redirect_fallthrough_inst;
                    redirect_stale_word_valid <= 1'b1;
                end
            end
            if (redirect_set_change) begin
                redirect_adj_inval_pending <= 1'b1;
                redirect_adj_inval_set <= cur_set + {{SET_W-1{1'b0}}, 1'b1};
                redirect_prev_inval_pending <= 1'b1;
                redirect_prev_inval_set <= prev_fetch_addr[11:4];
                redirect_miss_active <= 1'b1;
                redirect_miss_set <= cur_set;
                redirect_miss_seq <= redirect_miss_seq + 1'b1;
            end else begin
                redirect_adj_inval_pending <= 1'b0;
                redirect_prev_inval_pending <= 1'b0;
            end
        end else begin
            if (cancel_resp_holdoff != 2'b00) begin
                cancel_resp_holdoff <= cancel_resp_holdoff - 2'b01;
            end
            if (redirect_prev_inval) begin
                redirect_prev_inval_pending <= 1'b0;
            end
            if (redirect_ft_inval) begin
                redirect_ft_inval_pending <= 1'b0;
            end
            if (redirect_adj_inval) begin
                redirect_adj_inval_pending <= 1'b0;
                redirect_inval_holdoff <= 1'b0;
            end else if (!redirect_adj_inval_pending) begin
                redirect_inval_holdoff <= 1'b0;
            end
            if (redirect_miss_active && fill_data_ok && (req_set === redirect_miss_set)
                && (req_miss_seq === redirect_miss_seq)) begin
                redirect_miss_active <= 1'b0;
            end
            // 不在 sync hit 时清 stale_valid：ghost!=branch_inst 时会误清并放行错误指令。
            if (fill_data_ok && redirect_target_miss_pend
                && (req_pc === redirect_stale_addr)) begin
                redirect_target_miss_pend <= 1'b0;
            end
            if (fill_data_ok && axi_ret_last && redirect_stale_word_valid
                && (req_set === redirect_stale_set)
                && (req_pc[31:4] === redirect_stale_addr[31:4])
                && (pick_word(axi_ret_data, redirect_stale_addr[3:2]) !== redirect_stale_word)
                && (!redirect_stale_ft_valid
                 || (pick_word(axi_ret_data, redirect_stale_addr[3:2]) !== redirect_stale_ft_word))) begin
                redirect_stale_word_valid <= 1'b0;
                redirect_stale_ft_valid <= 1'b0;
                redirect_source_line_valid <= 1'b0;
                redirect_stale_same_line <= 1'b0;
                redirect_stale_data_holdoff <= 3'd5;
            end else if (fill_data_ok && axi_ret_last && redirect_stale_word_valid
                && (req_set === redirect_stale_set)
                && (req_pc === redirect_stale_addr)
                && ((pick_word(axi_ret_data, req_pc[3:2]) !== redirect_stale_word)
                 || redirect_stale_same_line)
                && (!redirect_stale_ft_valid
                 || (pick_word(axi_ret_data, req_pc[3:2]) !== redirect_stale_ft_word))) begin
                redirect_stale_word_valid <= 1'b0;
                redirect_stale_ft_valid <= 1'b0;
                redirect_source_line_valid <= 1'b0;
                redirect_stale_same_line <= 1'b0;
                redirect_stale_data_holdoff <= 3'd5;
            end else if (redirect_stale_data_holdoff !== 3'b000) begin
                redirect_stale_data_holdoff <= redirect_stale_data_holdoff - 3'b001;
            end
            if (redirect_target_inval) begin
                redirect_target_inval_pending <= 1'b0;
            end
        end
        if (cancel_req) begin
            resp_echo_block <= 1'b0;
            resp_echo_pc <= 32'b0;
        end else begin
            // 当前返回 PC 与正在请求的 PC 相同，下一拍同步 BRAM 可能回放同一条，屏蔽一拍即可。
            resp_echo_block <= (if_data_ok === 1'b1) && (raw_pc_out === cur_addr);
            if ((if_data_ok === 1'b1) && (raw_pc_out === cur_addr)) begin
                resp_echo_pc <= raw_pc_out;
            end
        end

        if (state === S_INIT) begin
            // Clear valid bits in TAGV RAMs to avoid X-driven false hits in simulation.
            if (init_set == {SET_W{1'b1}}) begin
                state <= S_IDLE;
            end
            init_set <= init_set + 1'b1;
        end else if (cancel_req) begin
            state <= S_IDLE;
        end else if (state === S_IDLE) begin
            // Hit 判定依赖同步 BRAM 对齐；miss 只依赖 lk_valid，避免 ram_lk_match 失配时永不发起 refill。
            if ((post_cancel_block !== 1'b1) && (lk_valid === 1'b1) && (cacop_en_safe !== 1'b1)
                && !redirect_adj_inval && !redirect_ft_inval && !redirect_prev_inval) begin
                if (stale_tag_hit_needs_miss || !tag_sync_hit) begin
                    req_pc <= cur_addr;
                    req_vpc <= if_vpc;
                    uncached_r <= if_uncached;
                    req_set <= cur_set;
                    req_tag <= cur_tag;
                    if (redirect_target_force_miss) begin
                        req_miss_seq <= redirect_miss_seq;
                    end
                    req_way <= (way0_valid !== 1'b1) ? 1'b0
                             : ((way1_valid !== 1'b1) ? 1'b1 : lru_way1[cur_set]);
                    state <= S_WAIT;
                end else if ((ram_lk_match === 1'b1) && (way0_hit === 1'b1)) begin
                    lru_way1[lk_set] <= 1'b1;
                end else if ((ram_lk_match === 1'b1) && (way1_hit === 1'b1)) begin
                    lru_way1[lk_set] <= 1'b0;
                end
            end
        end else if (state === S_WAIT) begin
            if (axi_rd_rdy) begin
                state <= S_FILL;
            end
        end else if (state === S_FILL) begin
            if (axi_ret_valid) begin
                if (uncached_r) begin
                    state <= S_IDLE;
                end else begin
                    lru_way1[req_set] <= ~req_way;
                    if (axi_ret_last) begin
                        state <= S_IDLE;
                    end
                end
            end
        end

        if (invalidate_set) begin
            lru_way1[cacop_addr[11:4]] <= 1'b0;
        end
        if (cache_line_step) begin
            cache_line_step_holdoff <= 2'b10;
        end else if (cache_line_step_holdoff != 2'b00) begin
            cache_line_step_holdoff <= cache_line_step_holdoff - 2'b01;
        end
        if (set_settling) begin
            set_settling_holdoff <= 2'b11;
        end else if (set_settling_holdoff != 2'b00) begin
            set_settling_holdoff <= set_settling_holdoff - 2'b01;
        end
        if (!cancel_req && hit_clean
         && ({lk_addr[31:4], 4'b0000} === {redirect_branch_pc[31:4], 4'b0000})) begin
            branch_line_snap <= hit_line;
            branch_line_snap_valid <= 1'b1;
        end
        if (!cancel_req && (hit_clean || fill_data_ok)) begin
            last_hit_line <= hit_clean ? hit_line : axi_ret_data;
            last_hit_line_addr <= hit_clean ? {lk_addr[31:4], 4'b0000} : {req_pc[31:4], 4'b0000};
        end
        ram_set_q_prev <= ram_set_q;
        prev_fetch_addr <= cur_addr;
    end
end

endmodule
