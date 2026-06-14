`include "mycpu.h"

// ============================================================
// dcache 模块（L1 数据缓存，新架构端口：load/store 分离双口）
// ------------------------------------------------------------
// 功能（新架构）：
// - load 口：服务 LSU 的读访问（cached 命中快速返回；uncached 旁路 AXI，
//   由 LSU 保证只在 ROB 头发出）；
// - store 口：服务 store_buffer 的按序写出（cached 写命中直接写入；
//   miss 走 refill 后写；uncached 直写 AXI，按真实宽度 st_size_i）；
// - cacop 口：commit 提交级驱动（idx_inv/hit_inv/hit_wb）；
// - 写回法 + 脏位；目标几何参数 `L1_NWAY(4)×`L1_NSET(128)×32B 行。
//
// 端口：
// - ld_* ：LSU load 访问口
// - st_* ：store_buffer 写出口
// - cacop_*：cache 维护口
// - axi_* ：下层 L2 接口（原样保留）
// ============================================================
module dcache (
    input  wire        clk,
    input  wire        resetn,

    // ---------------- LSU load 口 ----------------
    input  wire        ld_req_i,         // load 请求（保持至 addr_ok）
    input  wire [31:0] ld_vaddr_i,       // 虚地址（VIPT 索引）
    input  wire [31:0] ld_paddr_i,       // 物理地址（tag 比对）
    input  wire [2:0]  ld_size_i,        // 0=B 1=H 2=W（uncached 精确宽度）
    input  wire        ld_uncached_i,
    output wire        ld_addr_ok_o,
    output wire        ld_data_ok_o,
    output wire [31:0] ld_rdata_o,
    input  wire        ld_cancel_i,      // 冲刷取消在途 load（uncached 例外，LSU 保证不取消）

    // ---------------- store_buffer 写出口 ----------------
    input  wire        st_req_i,         // store 写请求（保持至 addr_ok）
    input  wire [31:0] st_paddr_i,
    input  wire [31:0] st_data_i,
    input  wire [3:0]  st_strb_i,
    input  wire [2:0]  st_size_i,
    input  wire        st_uncached_i,
    output wire        st_addr_ok_o,
    output wire        st_done_o,        // 写完成（写命中可快速完成）

    // ---------------- cache 维护口（commit 提交级驱动）----------------
    input  wire        cacop_en_i,
    input  wire [1:0]  cacop_op_i,       // IDX_INV / HIT_INV / HIT_WB
    input  wire [31:0] cacop_addr_i,

    // ---------------- 下层 L2 接口（原样保留）----------------
    output wire        axi_rd_req,
    output wire [2:0]  axi_rd_type,
    output wire [31:0] axi_rd_addr,
    input  wire        axi_rd_rdy,
    input  wire        axi_ret_valid,
    input  wire        axi_ret_last,
    input  wire [127:0] axi_ret_data,
    output wire        axi_wr_req,
    output wire [2:0]  axi_wr_type,
    output wire [31:0] axi_wr_addr,
    output wire [15:0] axi_wr_strb,
    output wire [127:0] axi_wr_data,
    output wire        axi_wr_cacop,
    input  wire        axi_wr_rdy
);

// ============================================================
//TODO: 改造说明（下方保留旧"单口阻塞式"实现作为基底）：
//
//TODO: 第一步——load/store 双口仲裁：旧实现只有一个 mem_* 口；新端口
//      ld_*/st_* 通过下方桥接复用旧单口（store 优先或 load 优先自选，
//      注意公平性防饿死）。一期这样跑通没问题（SB 写出与 load 不会
//      高频争抢）；二期改"真双口"：tag/data RAM 双读口或分 bank。
//
//TODO: 第二步——几何参数改宏（同 icache）：4 路 × 128 组 × 32B 行；
//      旧 way0/way1 + 4 bank 扩为 4 way + 8 bank，LRU 改 4 路。
//
//TODO: 第三步——写回与重填并行（AXI 优化一期）：旧状态机 S_WB（写脏行）
//      串行于 S_RREQ/S_FILL；改造为：脏行先搬进 victim/writeback buffer，
//      AXI 读（refill）立即发起，写回在后台排空——dirty miss 延迟减半。
//
//TODO: 第四步——非阻塞 miss（二期，IPC 大头）：miss 移入 1 项 MSHR 后
//      本体继续服务后续命中请求（mariver 实证 +9% IPC）；需要 LSU 配合
//      （miss 的 load 挂起等 MSHR 回填，命中的后续 load 先行）。
//
//TODO: 第五步——uncached：旧实现已支持（mat=00 旁路），桥接处按
//      ld_uncached_i/st_uncached_i 映射；uncached store 必须按 st_size_i
//      发真实 AXI 宽度（团队赛 UART 字节写的坑，旧实现已处理，保留）。
//
//TODO: 第六步——cacop：HIT_WB（脏行写回）走旧 axi_wr_cacop 通路保留；
//      cacop_mat 旧端口已废弃（恒按物理地址处理）。
//
// 下方为旧端口名桥接（保证旧代码体可编译；改造时逐步替换删除）：
// ============================================================
//TODO: 占位仲裁！store 优先（SB 排空不可饿死）；同拍只服务一个请求，
//      另一方 addr_ok 压低。改造真双口后删除本段。
wire        st_sel    = st_req_i;                      // store 优先
wire        mem_valid = ld_req_i | st_req_i;
wire        mem_op    = st_sel;                        // 1=写 0=读
wire [2:0]  mem_axsize= st_sel ? st_size_i  : ld_size_i;
wire [31:0] mem_addr  = st_sel ? st_paddr_i : ld_paddr_i;
wire [1:0]  mem_mat   = (st_sel ? st_uncached_i : ld_uncached_i) ? 2'b00 : 2'b01;
wire [3:0]  mem_wstrb = st_strb_i;
wire [31:0] mem_wdata = st_data_i;
wire        cacop_en   = cacop_en_i;
wire [1:0]  cacop_op   = cacop_op_i;
wire [31:0] cacop_addr = cacop_addr_i;
wire [1:0]  cacop_mat  = 2'b01;
wire [4:0]  preld_hint = 5'b0;                         // preld 按 nop 处理，通路废弃
wire        preld_en   = 1'b0;
wire        tlb_excp_cancel_req = ld_cancel_i & ~st_sel; // 仅取消 load；store 已提交不可取消
wire        sc_cancel_req       = 1'b0;                // sc 成败已在译码期定性，通路废弃
wire        tlb_valid  = 1'b1;
wire [31:0] tlb_paddr  = mem_addr;
// 旧输出口转内部信号
wire        mem_addr_ok;
wire        mem_data_ok;
wire [31:0] mem_rdata;
wire        stall_mem;

assign ld_addr_ok_o = mem_addr_ok & ~st_sel & ld_req_i;
assign ld_data_ok_o = mem_data_ok & ~mem_op;           //TODO: 占位：用请求配对区分读/写完成更稳
assign ld_rdata_o   = mem_rdata;
assign st_addr_ok_o = mem_addr_ok & st_sel;
assign st_done_o    = mem_data_ok & mem_op;            //TODO: 占位：同上，写完成配对

localparam SETS   = 256;
localparam SET_W  = 8;
localparam TAG_W  = 20;
localparam S_IDLE = 2'd0;
localparam S_WB   = 2'd1;
localparam S_RREQ = 2'd2;
localparam S_FILL = 2'd3;

reg [1:0]       state;
reg             initing;
reg [SET_W-1:0] init_set;
reg [31:0]      req_addr;
reg [31:0]      req_wdata;
reg [3:0]       req_wstrb;
reg             req_op_r;
reg             uncached_r;
reg [SET_W-1:0] req_set;
reg [TAG_W-1:0] req_tag;
reg             req_way;
reg [127:0]     victim_line;
reg [TAG_W-1:0] victim_tag;
reg             mem_data_ok_pulse;
reg [31:0]      mem_rdata_hold;
reg [255:0]     lru_way1;
reg [1:0]       way_d_reg [255:0];
reg             req_need_refill_r;
reg             req_is_cacop_r;
reg             req_is_preld_r;
reg             sb_valid;
reg [31:0]      sb_addr;
reg [127:0]     sb_data;
reg [15:0]      sb_strb;
reg [2:0]       sb_type;
reg [2:0]       req_axsize;
integer         idx;

function automatic [2:0] wstrb_to_axsize;
    input [3:0] wstrb;
    begin
        if ((wstrb == 4'b0001) || (wstrb == 4'b0010) || (wstrb == 4'b0100) || (wstrb == 4'b1000))
            wstrb_to_axsize = 3'b000;
        else if ((wstrb == 4'b0011) || (wstrb == 4'b1100))
            wstrb_to_axsize = 3'b001;
        else
            wstrb_to_axsize = 3'b010;
    end
endfunction

wire [31:0] base_addr = tlb_valid ? tlb_paddr : mem_addr;
wire [SET_W-1:0] cur_set = base_addr[11:4];
wire [TAG_W-1:0] cur_tag = base_addr[31:12];
wire [1:0] cur_word_sel = base_addr[3:2];
wire [SET_W-1:0] cacop_set = cacop_addr[11:4];
wire [TAG_W-1:0] cacop_tag = cacop_addr[31:12];
wire [31:0] req_line_addr = {req_addr[31:4], 4'b0000};
// LoongArch MAT: 2'b00/2'b10 = uncached, 2'b01 = coherent cached (see CRMD.DATM/DATF).
wire mem_uncached = (mem_mat == 2'b00) || (mem_mat == 2'b10);
wire cancel_req = tlb_excp_cancel_req | sc_cancel_req;
wire sb_complete = sb_valid && axi_wr_rdy;

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
wire way0_valid_clean = (way0_valid === 1'b1);
wire way1_valid_clean = (way1_valid === 1'b1);

wire way0_hit = (state == S_IDLE) && mem_valid && !mem_uncached && !cacop_en
             && way0_valid_clean && (way0_tagv[19:0] === cur_tag);
wire way1_hit = (state == S_IDLE) && mem_valid && !mem_uncached && !cacop_en
             && way1_valid_clean && (way1_tagv[19:0] === cur_tag);
wire hit = (way0_hit === 1'b1) || (way1_hit === 1'b1);
wire [127:0] way0_line = {way0_bank3_dout, way0_bank2_dout, way0_bank1_dout, way0_bank0_dout};
wire [127:0] way1_line = {way1_bank3_dout, way1_bank2_dout, way1_bank1_dout, way1_bank0_dout};
wire [127:0] hit_line = way1_hit ? way1_line : way0_line;

wire cacop_way0_hit = (state == S_IDLE) && cacop_en && way0_valid_clean && (way0_tagv[19:0] === cacop_tag);
wire cacop_way1_hit = (state == S_IDLE) && cacop_en && way1_valid_clean && (way1_tagv[19:0] === cacop_tag);
wire cacop_hit = (cacop_way0_hit === 1'b1) || (cacop_way1_hit === 1'b1);
wire cacop_hit_way = cacop_way1_hit;
wire cacop_dirty_hit = cacop_hit_way ? way_d_reg[cacop_set][1] : way_d_reg[cacop_set][0];
wire is_cacop_idx_inv = (cacop_op == `CACOP_OP_IDX_INV);
wire is_cacop_hit_inv = (cacop_op == `CACOP_OP_HIT_INV);
wire is_cacop_hit_wb  = (cacop_op == `CACOP_OP_HIT_WB);
wire cacop_idx_way = cacop_addr[0];
wire cacop_idx_valid = cacop_idx_way ? way1_valid_clean : way0_valid_clean;
wire cacop_idx_dirty = cacop_idx_way ? way_d_reg[cacop_set][1] : way_d_reg[cacop_set][0];
wire [127:0] cacop_idx_line = cacop_idx_way ? way1_line : way0_line;
wire [TAG_W-1:0] cacop_idx_tag = cacop_idx_way ? way1_tagv[19:0] : way0_tagv[19:0];
// Hit-invalidate (op=01) selects way by index bit [0], same as index-invalidate; tag match is not required.
wire cacop_use_idx_way = is_cacop_idx_inv || is_cacop_hit_inv;
wire cacop_need_wb = (is_cacop_hit_wb  && cacop_hit && cacop_dirty_hit)
                  || (cacop_use_idx_way && cacop_idx_valid && cacop_idx_dirty);
wire cacop_wb_way = cacop_use_idx_way ? cacop_idx_way : cacop_hit_way;
wire [127:0] cacop_wb_line = cacop_use_idx_way ? cacop_idx_line : (cacop_hit_way ? way1_line : way0_line);
wire [TAG_W-1:0] cacop_wb_tag = cacop_use_idx_way ? cacop_idx_tag : (cacop_hit_way ? way1_tagv[19:0] : way0_tagv[19:0]);

wire preld_way0_hit = (state == S_IDLE) && preld_en && !mem_valid && !cacop_en
                   && way0_valid_clean && (way0_tagv[19:0] === cur_tag);
wire preld_way1_hit = (state == S_IDLE) && preld_en && !mem_valid && !cacop_en
                   && way1_valid_clean && (way1_tagv[19:0] === cur_tag);
wire preld_hit = (preld_way0_hit === 1'b1) || (preld_way1_hit === 1'b1);
wire [31:0] hit_rdata = pick_word(hit_line, cur_word_sel);

wire replace_way = !way0_valid_clean ? 1'b0 : (!way1_valid_clean ? 1'b1 : lru_way1[cur_set]);
wire replace_dirty = replace_way ? way_d_reg[cur_set][1] : way_d_reg[cur_set][0];
wire [127:0] replace_line = replace_way ? way1_line : way0_line;
wire [TAG_W-1:0] replace_tag = replace_way ? way1_tagv[19:0] : way0_tagv[19:0];
wire fill_accept = (state == S_FILL) && axi_ret_valid && !uncached_r;
wire [127:0] fill_line = req_op_r ? merge_store(axi_ret_data, req_wdata, req_wstrb, req_addr[3:2]) : axi_ret_data;
wire store_buffer_enqueue = (state == S_IDLE) && !sb_valid
                         && ((mem_valid && !mem_uncached && !hit && !cacop_en && replace_dirty)
                          || (preld_en && !mem_valid && !cacop_en && !preld_hit && replace_dirty));

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

function [31:0] merge_word;
    input [31:0] word;
    input [31:0] data;
    input [3:0] strb;
    reg [31:0] tmp;
    begin
        tmp = word;
        if (strb[0]) tmp[7:0]   = data[7:0];
        if (strb[1]) tmp[15:8]  = data[15:8];
        if (strb[2]) tmp[23:16] = data[23:16];
        if (strb[3]) tmp[31:24] = data[31:24];
        merge_word = tmp;
    end
endfunction

function [127:0] merge_store;
    input [127:0] line;
    input [31:0] data;
    input [3:0] strb;
    input [1:0] word_sel;
    reg [127:0] tmp;
    begin
        tmp = line;
        case (word_sel)
            2'd0: begin
                if (strb[0]) tmp[7:0]   = data[7:0];
                if (strb[1]) tmp[15:8]  = data[15:8];
                if (strb[2]) tmp[23:16] = data[23:16];
                if (strb[3]) tmp[31:24] = data[31:24];
            end
            2'd1: begin
                if (strb[0]) tmp[39:32] = data[7:0];
                if (strb[1]) tmp[47:40] = data[15:8];
                if (strb[2]) tmp[55:48] = data[23:16];
                if (strb[3]) tmp[63:56] = data[31:24];
            end
            2'd2: begin
                if (strb[0]) tmp[71:64] = data[7:0];
                if (strb[1]) tmp[79:72] = data[15:8];
                if (strb[2]) tmp[87:80] = data[23:16];
                if (strb[3]) tmp[95:88] = data[31:24];
            end
            default: begin
                if (strb[0]) tmp[103:96]  = data[7:0];
                if (strb[1]) tmp[111:104] = data[15:8];
                if (strb[2]) tmp[119:112] = data[23:16];
                if (strb[3]) tmp[127:120] = data[31:24];
            end
        endcase
        merge_store = tmp;
    end
endfunction

wire invalidate_set = cacop_en && (cacop_op == `CACOP_OP_IDX_INV || cacop_op == `CACOP_OP_HIT_INV);
wire invalidate_way0 = cacop_en && cacop_use_idx_way && (cacop_idx_way == 1'b0);
wire invalidate_way1 = cacop_en && cacop_use_idx_way && (cacop_idx_way == 1'b1);
wire [31:0] way0_tagv_fill_data = {11'b0, 1'b1, req_tag};
wire [31:0] way1_tagv_fill_data = {11'b0, 1'b1, req_tag};
wire [31:0] way0_tagv_inval_data = {11'b0, 1'b0, way0_tagv[19:0]};
wire [31:0] way1_tagv_inval_data = {11'b0, 1'b0, way1_tagv[19:0]};

// During bring-up in simulation, clear TAGV valid bits to avoid X-driven false hits.
wire init_inval_we = initing;
wire [17:0] init_ram_addr = {10'b0, init_set};
wire [17:0] cache_ram_addr = initing ? init_ram_addr
                         : (state == S_FILL) ? {10'b0, req_set}
                         : (cacop_en ? {10'b0, cacop_addr[11:4]} : {10'b0, cur_set});
wire [31:0] fill_word0 = fill_line[31:0];
wire [31:0] fill_word1 = fill_line[63:32];
wire [31:0] fill_word2 = fill_line[95:64];
wire [31:0] fill_word3 = fill_line[127:96];

// store buffer 未清空时先阻塞后续 DCache 请求，保证写后读、CACOP、MMIO 等顺序不被打乱。
assign mem_addr_ok = !initing && (state == S_IDLE) && !cacop_en && !sb_valid;
assign mem_data_ok = hit || mem_data_ok_pulse;
assign mem_rdata = hit ? hit_rdata : mem_rdata_hold;
assign stall_mem = mem_valid && !mem_data_ok;

assign axi_rd_req = (state == S_RREQ) && !cancel_req;
assign axi_rd_type = uncached_r ? req_axsize : 3'b100;
assign axi_rd_addr = uncached_r ? req_addr : req_line_addr;
assign axi_wr_req = sb_valid ? 1'b1 : ((state == S_WB) && !cancel_req);
assign axi_wr_type = sb_valid ? sb_type : (uncached_r ? req_axsize : 3'b100);
assign axi_wr_addr = sb_valid ? sb_addr : (uncached_r ? req_addr : {victim_tag, req_set, 4'b0000});
assign axi_wr_strb = sb_valid ? sb_strb : (uncached_r ? {12'b0, req_wstrb} : 16'hffff);
assign axi_wr_data = sb_valid ? sb_data : (uncached_r ? {96'b0, req_wdata} : victim_line);
assign axi_wr_cacop = sb_valid ? 1'b0 : req_is_cacop_r;

// For store-hit updates on synchronous BRAM IP, rely on byte write-enable directly.
// Using old dout for read-modify-write can pick a previous-cycle address and inject Xs.
wire [31:0] way0_bank0_in = fill_accept ? fill_word0 : mem_wdata;
wire [31:0] way0_bank1_in = fill_accept ? fill_word1 : mem_wdata;
wire [31:0] way0_bank2_in = fill_accept ? fill_word2 : mem_wdata;
wire [31:0] way0_bank3_in = fill_accept ? fill_word3 : mem_wdata;
wire [31:0] way1_bank0_in = fill_accept ? fill_word0 : mem_wdata;
wire [31:0] way1_bank1_in = fill_accept ? fill_word1 : mem_wdata;
wire [31:0] way1_bank2_in = fill_accept ? fill_word2 : mem_wdata;
wire [31:0] way1_bank3_in = fill_accept ? fill_word3 : mem_wdata;

wire way0_bank0_we = (state == S_IDLE) && way0_hit && mem_op && (cur_word_sel == 2'd0);
wire way0_bank1_we = (state == S_IDLE) && way0_hit && mem_op && (cur_word_sel == 2'd1);
wire way0_bank2_we = (state == S_IDLE) && way0_hit && mem_op && (cur_word_sel == 2'd2);
wire way0_bank3_we = (state == S_IDLE) && way0_hit && mem_op && (cur_word_sel == 2'd3);
wire way1_bank0_we = (state == S_IDLE) && way1_hit && mem_op && (cur_word_sel == 2'd0);
wire way1_bank1_we = (state == S_IDLE) && way1_hit && mem_op && (cur_word_sel == 2'd1);
wire way1_bank2_we = (state == S_IDLE) && way1_hit && mem_op && (cur_word_sel == 2'd2);
wire way1_bank3_we = (state == S_IDLE) && way1_hit && mem_op && (cur_word_sel == 2'd3);

dcache_way0_TAGV_ram u_dcache_way0_TAGV_ram(
    .addra(cache_ram_addr),
    .clka(clk),
    .dina(init_inval_we ? 32'b0 : (fill_accept ? way0_tagv_fill_data : way0_tagv_inval_data)),
    .douta(way0_tagv_dout),
    .ena(1'b1),
    .wea(init_inval_we ? 4'hF : ((fill_accept && !req_way) ? 4'hF : (invalidate_way0 ? 4'hF : 4'h0)))
);

dcache_way1_TAGV_ram u_dcache_way1_TAGV_ram(
    .addra(cache_ram_addr),
    .clka(clk),
    .dina(init_inval_we ? 32'b0 : (fill_accept ? way1_tagv_fill_data : way1_tagv_inval_data)),
    .douta(way1_tagv_dout),
    .ena(1'b1),
    .wea(init_inval_we ? 4'hF : ((fill_accept && req_way) ? 4'hF : (invalidate_way1 ? 4'hF : 4'h0)))
);

dcache_way0_Bank0_ram u_dcache_way0_Bank0_ram(.addra(cache_ram_addr), .clka(clk), .dina(way0_bank0_in), .douta(way0_bank0_dout), .ena(1'b1), .wea((fill_accept && !req_way) ? 4'hF : (way0_bank0_we ? mem_wstrb : 4'h0)));
dcache_way0_Bank1_ram u_dcache_way0_Bank1_ram(.addra(cache_ram_addr), .clka(clk), .dina(way0_bank1_in), .douta(way0_bank1_dout), .ena(1'b1), .wea((fill_accept && !req_way) ? 4'hF : (way0_bank1_we ? mem_wstrb : 4'h0)));
dcache_way0_Bank2_ram u_dcache_way0_Bank2_ram(.addra(cache_ram_addr), .clka(clk), .dina(way0_bank2_in), .douta(way0_bank2_dout), .ena(1'b1), .wea((fill_accept && !req_way) ? 4'hF : (way0_bank2_we ? mem_wstrb : 4'h0)));
dcache_way0_Bank3_ram u_dcache_way0_Bank3_ram(.addra(cache_ram_addr), .clka(clk), .dina(way0_bank3_in), .douta(way0_bank3_dout), .ena(1'b1), .wea((fill_accept && !req_way) ? 4'hF : (way0_bank3_we ? mem_wstrb : 4'h0)));
dcache_way1_Bank0_ram u_dcache_way1_Bank0_ram(.addra(cache_ram_addr), .clka(clk), .dina(way1_bank0_in), .douta(way1_bank0_dout), .ena(1'b1), .wea((fill_accept && req_way) ? 4'hF : (way1_bank0_we ? mem_wstrb : 4'h0)));
dcache_way1_Bank1_ram u_dcache_way1_Bank1_ram(.addra(cache_ram_addr), .clka(clk), .dina(way1_bank1_in), .douta(way1_bank1_dout), .ena(1'b1), .wea((fill_accept && req_way) ? 4'hF : (way1_bank1_we ? mem_wstrb : 4'h0)));
dcache_way1_Bank2_ram u_dcache_way1_Bank2_ram(.addra(cache_ram_addr), .clka(clk), .dina(way1_bank2_in), .douta(way1_bank2_dout), .ena(1'b1), .wea((fill_accept && req_way) ? 4'hF : (way1_bank2_we ? mem_wstrb : 4'h0)));
dcache_way1_Bank3_ram u_dcache_way1_Bank3_ram(.addra(cache_ram_addr), .clka(clk), .dina(way1_bank3_in), .douta(way1_bank3_dout), .ena(1'b1), .wea((fill_accept && req_way) ? 4'hF : (way1_bank3_we ? mem_wstrb : 4'h0)));

always @(posedge clk) begin
    if (!resetn) begin
        state <= S_IDLE;
        initing <= 1'b1;
        init_set <= {SET_W{1'b0}};
        req_addr <= 32'b0;
        req_wdata <= 32'b0;
        req_wstrb <= 4'b0;
        req_op_r <= 1'b0;
        uncached_r <= 1'b0;
        req_set <= {SET_W{1'b0}};
        req_tag <= {TAG_W{1'b0}};
        req_way <= 1'b0;
        victim_line <= 128'b0;
        victim_tag <= {TAG_W{1'b0}};
        mem_data_ok_pulse <= 1'b0;
        mem_rdata_hold <= 32'b0;
        lru_way1 <= 256'b0;
        req_need_refill_r <= 1'b0;
        req_is_cacop_r <= 1'b0;
        req_is_preld_r <= 1'b0;
        sb_valid <= 1'b0;
        sb_addr <= 32'b0;
        sb_data <= 128'b0;
        sb_strb <= 16'b0;
        sb_type <= 3'b010;
        for (idx = 0; idx < SETS; idx = idx + 1) begin
            way_d_reg[idx] = 2'b00;
        end
    end else begin
        mem_data_ok_pulse <= 1'b0;
        if (sb_complete) begin
            sb_valid <= 1'b0;
            sb_addr <= 32'b0;
            sb_data <= 128'b0;
            sb_strb <= 16'b0;
            sb_type <= 3'b010;
        end

        if (initing) begin
            if (init_set == {SET_W{1'b1}}) begin
                initing <= 1'b0;
            end
            init_set <= init_set + 1'b1;
            state <= S_IDLE;
            req_need_refill_r <= 1'b0;
            req_is_cacop_r <= 1'b0;
            req_is_preld_r <= 1'b0;
        end
        else
        if (cancel_req) begin
            state <= S_IDLE;
            req_need_refill_r <= 1'b0;
            req_is_cacop_r <= 1'b0;
            req_is_preld_r <= 1'b0;
        end else begin
            case (state)
                S_IDLE: begin
                    if (sb_valid) begin
                        if (sb_complete) begin
                            state <= req_need_refill_r ? S_RREQ : S_IDLE;
                        end
                    end else if (cacop_en && cacop_need_wb) begin
                        req_addr <= cacop_addr;
                        req_set <= cacop_set;
                        req_tag <= cacop_tag;
                        req_way <= cacop_wb_way;
                        req_op_r <= 1'b0;
                        req_wdata <= 32'b0;
                        req_wstrb <= 4'b0;
                        uncached_r <= 1'b0;
                        victim_line <= cacop_wb_line;
                        victim_tag <= cacop_wb_tag;
                        req_need_refill_r <= 1'b0;
                        req_is_cacop_r <= 1'b1;
                        req_is_preld_r <= 1'b0;
                        state <= S_WB;
                    end else if (mem_valid && !cacop_en) begin
                        req_addr <= base_addr;
                        req_wdata <= mem_wdata;
                        req_wstrb <= mem_wstrb;
                        req_op_r <= mem_op;
                        req_axsize <= mem_op ? wstrb_to_axsize(mem_wstrb) : mem_axsize;
                        uncached_r <= mem_uncached;
                        req_set <= cur_set;
                        req_tag <= cur_tag;
                        req_way <= replace_way;
                        req_is_cacop_r <= 1'b0;
                        req_is_preld_r <= 1'b0;
                        if (way0_hit) begin
                            if (mem_op) begin
                                way_d_reg[cur_set][0] <= 1'b1;
                            end
                            lru_way1[cur_set] <= 1'b1;
                            req_need_refill_r <= 1'b0;
                        end else if (way1_hit) begin
                            if (mem_op) begin
                                way_d_reg[cur_set][1] <= 1'b1;
                            end
                            lru_way1[cur_set] <= 1'b0;
                            req_need_refill_r <= 1'b0;
                        end else begin
                            victim_line <= replace_line;
                            victim_tag <= replace_tag;
                            if (mem_uncached) begin
                                req_need_refill_r <= 1'b0;
                                // Uncached stores use the write channel (S_WB). Uncached loads must use read (S_RREQ).
                                state <= mem_op ? S_WB : S_RREQ;
                            end else if (replace_dirty) begin
                                // 脏 victim 先写回再 refill，避免与 L2/AXI 并行时互相饿死。
                                sb_valid <= 1'b1;
                                sb_addr <= {replace_tag, cur_set, 4'b0000};
                                sb_data <= replace_line;
                                sb_strb <= 16'hffff;
                                sb_type <= 3'b100;
                                req_need_refill_r <= 1'b1;
                                state <= S_IDLE;
                            end else begin
                                req_need_refill_r <= 1'b1;
                                state <= S_RREQ;
                            end
                        end
                        if (hit && !mem_op) begin
                            mem_rdata_hold <= hit_rdata;
                        end
                    end else if (preld_en && !cacop_en) begin
                        req_addr <= base_addr;
                        req_wdata <= 32'b0;
                        req_wstrb <= 4'b0;
                        req_op_r <= 1'b0;
                        uncached_r <= 1'b0;
                        req_set <= cur_set;
                        req_tag <= cur_tag;
                        req_way <= replace_way;
                        req_need_refill_r <= 1'b1;
                        req_is_cacop_r <= 1'b0;
                        req_is_preld_r <= 1'b1;
                        if (preld_way0_hit) begin
                            lru_way1[cur_set] <= 1'b1;
                            req_need_refill_r <= 1'b0;
                        end else if (preld_way1_hit) begin
                            lru_way1[cur_set] <= 1'b0;
                            req_need_refill_r <= 1'b0;
                        end else begin
                            victim_line <= replace_line;
                            victim_tag <= replace_tag;
                            if (replace_dirty) begin
                                sb_valid <= 1'b1;
                                sb_addr <= {replace_tag, cur_set, 4'b0000};
                                sb_data <= replace_line;
                                sb_strb <= 16'hffff;
                                sb_type <= 3'b100;
                                state <= S_RREQ;
                            end else begin
                                state <= S_RREQ;
                            end
                        end
                    end
                end

                S_WB: begin
                    if (axi_wr_rdy) begin
                        if (uncached_r) begin
                            mem_data_ok_pulse <= req_is_preld_r ? 1'b0 : 1'b1;
                            state <= S_IDLE;
                        end else begin
                            if (req_way) begin
                                way_d_reg[req_set][1] <= 1'b0;
                            end else begin
                                way_d_reg[req_set][0] <= 1'b0;
                            end
                            state <= req_need_refill_r ? S_RREQ : S_IDLE;
                        end
                    end
                end

                S_RREQ: begin
                    if (axi_rd_rdy) begin
                        state <= S_FILL;
                    end
                end

                S_FILL: begin
                    if (axi_ret_valid) begin
                        if (!req_is_preld_r) begin
                            // Uncached byte/half/word AXI beats return one 32-bit word in axi_ret_data[31:0].
                            mem_rdata_hold <= uncached_r ? axi_ret_data[31:0]
                                                         : pick_word(axi_ret_data, req_addr[3:2]);
                            mem_data_ok_pulse <= 1'b1;
                        end
                        if (!uncached_r) begin
                            if (req_way) begin
                                way_d_reg[req_set][1] <= req_op_r;
                                lru_way1[req_set] <= 1'b0;
                            end else begin
                                way_d_reg[req_set][0] <= req_op_r;
                                lru_way1[req_set] <= 1'b1;
                            end
                        end
                        if (uncached_r || axi_ret_last) begin
                            state <= S_IDLE;
                        end
                    end
                end

                default: begin
                    state <= S_IDLE;
                end
            endcase

            if (cacop_en && (cacop_op == `CACOP_OP_IDX_INV || cacop_op == `CACOP_OP_HIT_INV)) begin
                if (invalidate_way0) begin
                    way_d_reg[cacop_addr[11:4]][0] <= 1'b0;
                end
                if (invalidate_way1) begin
                    way_d_reg[cacop_addr[11:4]][1] <= 1'b0;
                end
                lru_way1[cacop_addr[11:4]] <= 1'b0;
            end
        end
    end
end

wire dcache_lint_sink;
assign dcache_lint_sink = (|preld_hint) & preld_en;

endmodule
