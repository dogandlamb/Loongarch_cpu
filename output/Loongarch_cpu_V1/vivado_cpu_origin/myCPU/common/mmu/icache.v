`include "../../top/cpu_defs.vh"

module icache (
    input  wire        clk,
    input  wire        resetn,
    input  wire        if_valid,
    input  wire [31:0] if_pc,
    input  wire [1:0]  if_mat,
    output wire        if_addr_ok,
    output wire        if_data_ok,
    output wire [31:0] if_data,
    input  wire        cacop_en,
    input  wire [1:0]  cacop_op,
    input  wire [31:0] cacop_addr,
    input  wire [1:0]  cacop_mat,
    input  wire        tlb_excp_cancel_req,
    input  wire        tlb_valid,
    input  wire [31:0] tlb_paddr,
    output wire        axi_rd_req,
    output wire [2:0]  axi_rd_type,
    output wire [31:0] axi_rd_addr,
    input  wire        axi_rd_rdy,
    input  wire        axi_ret_valid,
    input  wire        axi_ret_last,
    input  wire [127:0] axi_ret_data,
    output wire [31:0] if_pc_out,
    output wire        stall_if
);

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
reg             uncached_r;
reg             req_way;
reg             refill_echo_block;
reg             resp_echo_block;
reg [31:0]      resp_echo_pc;
reg             cancel_lookup_holdoff;
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
reg             lk_valid;
reg             lk_uncached;
reg [SET_W-1:0] ram_set_q;

// Instruction fetches are word-aligned; forcing [1:0]=00 avoids X on PC low bits in sim.
wire [31:0] cur_addr_i = tlb_valid ? tlb_paddr : if_pc;
wire [31:0] cur_addr    = { cur_addr_i[31:2], 2'b00 };
wire [SET_W-1:0] cur_set = cur_addr[11:4];
wire [TAG_W-1:0] cur_tag = cur_addr[31:12];
wire [1:0] cur_word_sel = cur_addr[3:2];
// 仅 MAT=2'b10 走非缓存取指；普通取指进入 ICache。
wire if_uncached = (if_mat === 2'b10);

// 4-state safe: treat cacop_en as asserted only when strictly 1.
wire cacop_en_safe = (cacop_en === 1'b1);

wire [31:0] lk_tag = lk_addr[31:12];
wire [SET_W-1:0] lk_set = lk_addr[11:4];
wire [1:0] lk_word_sel = lk_addr[3:2];

wire [17:0] cur_ram_addr = {10'b0, cur_set};
wire [17:0] lk_ram_addr  = {10'b0, lk_set};
wire [17:0] req_ram_addr = {10'b0, req_set};
wire [17:0] cacop_ram_addr = {10'b0, cacop_addr[11:4]};
wire [17:0] init_ram_addr = {10'b0, init_set};
wire [17:0] cache_ram_addr = (state === S_INIT) ? init_ram_addr
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
// Plain "|" can yield X if an operand is X; drive outputs only from 0/1-qualified hits.
wire hit_clean = (way0_hit === 1'b1) || (way1_hit === 1'b1);

wire [127:0] way0_line = {way0_bank3_dout, way0_bank2_dout, way0_bank1_dout, way0_bank0_dout};
wire [127:0] way1_line = {way1_bank3_dout, way1_bank2_dout, way1_bank1_dout, way1_bank0_dout};
wire [127:0] hit_line = way1_hit ? way1_line : way0_line;

// CACOP/refetch 到来时要取消在途读返回，避免自修改代码场景下旧指令回放。
wire cancel_req = tlb_excp_cancel_req || cacop_en_safe;
// 替换路选择必须对应已经锁存的一拍查找请求，因为同步 BRAM 的 dout 对齐 lk_addr。
wire replace_way = (way0_valid !== 1'b1) ? 1'b0 : ((way1_valid !== 1'b1) ? 1'b1 : lru_way1[lk_set]);
// CACOP 与 refill 返回同拍时，优先执行目标 set 失效；旧 refill 直接丢弃。
wire fill_accept = (state === S_FILL) && axi_ret_valid && (uncached_r !== 1'b1) && (cancel_req !== 1'b1);
wire [127:0] fill_line = axi_ret_data;
wire [31:0] fill_word = fill_line[31:0];

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

wire [31:0] hit_pc = {lk_addr[31:2], 2'b00};
wire [31:0] hit_data = pick_word(hit_line, lk_word_sel);
// refill 返回对应发起读请求时锁存的 req_pc；顺序取指时当前 PC 可能已经跨到下一行。
// 旧请求在 cancel 时会退出 S_FILL，AXI 桥也只允许单 outstanding 读，这里不能再用当前 PC 过滤。
wire refill_cur_match = 1'b1;
wire [31:0] ret_pc = req_pc;
wire [31:0] ret_data = pick_word(axi_ret_data, ret_pc[3:2]);
wire fill_data_ok = (state === S_FILL) && axi_ret_valid
                 && (refill_cur_match === 1'b1) && (cancel_req !== 1'b1);
wire raw_data_ok = hit_clean || fill_data_ok;
wire [31:0] raw_pc_out = hit_clean ? hit_pc : ret_pc;
wire duplicate_resp = (resp_echo_block === 1'b1) && (raw_data_ok === 1'b1)
                   && (raw_pc_out === resp_echo_pc);

// ICache 的 CACOP op0/op1/op2 在功能测试中都用于让目标指令行失效；
// op2 在 DCache 侧可表示写回类操作，但 ICache 没有 dirty，需要按 hit invalidate 处理。
wire invalidate_set = cacop_en_safe && ((cacop_op == `CACOP_OP_IDX_INV)
                                     || (cacop_op == `CACOP_OP_HIT_INV)
                                     || (cacop_op == `CACOP_OP_HIT_WB));
wire [31:0] way0_tagv_inval_data = init_inval_we ? 32'b0 : {11'b0, 1'b0, way0_tagv[19:0]};
wire [31:0] way1_tagv_inval_data = init_inval_we ? 32'b0 : {11'b0, 1'b0, way1_tagv[19:0]};
wire [31:0] way0_tagv_fill_data = {11'b0, 1'b1, req_tag};
wire [31:0] way1_tagv_fill_data = {11'b0, 1'b1, req_tag};

wire way0_tagv_we = fill_accept && !req_way;
wire way1_tagv_we = fill_accept && req_way;
wire init_inval_we = (state === S_INIT);
wire way0_inval_we = invalidate_set || init_inval_we;
wire way1_inval_we = invalidate_set || init_inval_we;

wire [31:0] way0_bank0_fill_data = fill_line[31:0];
wire [31:0] way0_bank1_fill_data = fill_line[63:32];
wire [31:0] way0_bank2_fill_data = fill_line[95:64];
wire [31:0] way0_bank3_fill_data = fill_line[127:96];
wire [31:0] way1_bank0_fill_data = fill_line[31:0];
wire [31:0] way1_bank1_fill_data = fill_line[63:32];
wire [31:0] way1_bank2_fill_data = fill_line[95:64];
wire [31:0] way1_bank3_fill_data = fill_line[127:96];

assign if_addr_ok = (state === S_IDLE) && (cacop_en_safe !== 1'b1);
assign if_data_ok = raw_data_ok && (duplicate_resp !== 1'b1);
assign if_data = hit_clean ? hit_data : ret_data;
assign if_pc_out = raw_pc_out;
assign stall_if = (if_valid === 1'b1) && !if_data_ok;

assign axi_rd_req = (state === S_WAIT) && (cancel_req !== 1'b1);
assign axi_rd_type = uncached_r ? 3'b010 : 3'b100;
assign axi_rd_addr = uncached_r ? req_pc : {req_pc[31:4], 4'b0000};

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
        uncached_r <= 1'b0;
        req_way <= 1'b0;
        refill_echo_block <= 1'b0;
        resp_echo_block <= 1'b0;
        resp_echo_pc <= 32'b0;
        cancel_lookup_holdoff <= 1'b0;
        req_set <= {SET_W{1'b0}};
        req_tag <= {TAG_W{1'b0}};
        lk_addr <= 32'b0;
        lk_valid <= 1'b0;
        lk_uncached <= 1'b0;
        ram_set_q <= {SET_W{1'b0}};
        lru_way1 <= 256'b0;
        for (idx = 0; idx < SETS; idx = idx + 1) begin
            lru_way1[idx] <= 1'b0;
        end
    end else begin
        // Capture lookup request for synchronous BRAM alignment.
        lk_addr     <= cur_addr;
        lk_valid    <= (if_valid === 1'b1);
        lk_uncached <= if_uncached;
        ram_set_q   <= cache_ram_addr[SET_W-1:0];
        refill_echo_block <= (fill_data_ok === 1'b1);
        cancel_lookup_holdoff <= (cancel_req === 1'b1);
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
            // Use lk_* for hit/miss and for miss request capture (BRAM synchronous alignment).
            if ((cancel_lookup_holdoff !== 1'b1) && (ram_lk_match === 1'b1)
                && (lk_valid === 1'b1) && (cacop_en_safe !== 1'b1)) begin
                if (way0_hit === 1'b1) begin
                    lru_way1[lk_set] <= 1'b1;
                end else if (way1_hit === 1'b1) begin
                    lru_way1[lk_set] <= 1'b0;
                end else begin
                    // Miss: launch refill for the lookup address (lk_addr), not current cur_addr.
                    req_pc <= lk_addr;
                    uncached_r <= lk_uncached;
                    req_set <= lk_set;
                    req_tag <= lk_tag;
                    req_way <= replace_way;
                    state <= S_WAIT;
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
    end
end

endmodule
