`include "../common/cpu_defs.vh"

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

reg [1:0]       state;
reg [31:0]      req_pc;
reg             uncached_r;
reg             req_way;
reg [SET_W-1:0] req_set;
reg [TAG_W-1:0] req_tag;
reg [255:0]     lru_way1;
integer         idx;

wire [31:0] cur_addr = tlb_valid ? tlb_paddr : if_pc;
wire [SET_W-1:0] cur_set = cur_addr[11:4];
wire [TAG_W-1:0] cur_tag = cur_addr[31:12];
wire [1:0] cur_word_sel = cur_addr[3:2];
wire if_uncached = (if_mat == 2'b10);

wire [17:0] cur_ram_addr = {10'b0, cur_set};
wire [17:0] req_ram_addr = {10'b0, req_set};
wire [17:0] cacop_ram_addr = {10'b0, cacop_addr[11:4]};
wire [17:0] cache_ram_addr = (state == S_FILL) ? req_ram_addr
                        : (cacop_en ? cacop_ram_addr : cur_ram_addr);

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
wire way0_hit = (state == S_IDLE) && if_valid && !if_uncached && !cacop_en && way0_valid && (way0_tagv[19:0] == cur_tag);
wire way1_hit = (state == S_IDLE) && if_valid && !if_uncached && !cacop_en && way1_valid && (way1_tagv[19:0] == cur_tag);
wire hit = way0_hit | way1_hit;

wire [127:0] way0_line = {way0_bank3_dout, way0_bank2_dout, way0_bank1_dout, way0_bank0_dout};
wire [127:0] way1_line = {way1_bank3_dout, way1_bank2_dout, way1_bank1_dout, way1_bank0_dout};
wire [127:0] hit_line = way1_hit ? way1_line : way0_line;

wire replace_way = !way0_valid ? 1'b0 : (!way1_valid ? 1'b1 : lru_way1[cur_set]);
wire fill_accept = (state == S_FILL) && axi_ret_valid && !uncached_r;
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

wire [31:0] hit_data = pick_word(hit_line, cur_word_sel);
wire [31:0] ret_data = uncached_r ? pick_word(axi_ret_data, req_pc[3:2]) : pick_word(axi_ret_data, req_pc[3:2]);
wire cancel_req = tlb_excp_cancel_req;

wire invalidate_set = cacop_en && (cacop_op == `CACOP_OP_IDX_INV || cacop_op == `CACOP_OP_HIT_INV);
wire [31:0] way0_tagv_inval_data = {11'b0, 1'b0, way0_tagv[19:0]};
wire [31:0] way1_tagv_inval_data = {11'b0, 1'b0, way1_tagv[19:0]};
wire [31:0] way0_tagv_fill_data = {11'b0, 1'b1, req_tag};
wire [31:0] way1_tagv_fill_data = {11'b0, 1'b1, req_tag};

wire way0_tagv_we = fill_accept && !req_way;
wire way1_tagv_we = fill_accept && req_way;
wire way0_inval_we = invalidate_set;
wire way1_inval_we = invalidate_set;

wire [31:0] way0_bank0_fill_data = fill_line[31:0];
wire [31:0] way0_bank1_fill_data = fill_line[63:32];
wire [31:0] way0_bank2_fill_data = fill_line[95:64];
wire [31:0] way0_bank3_fill_data = fill_line[127:96];
wire [31:0] way1_bank0_fill_data = fill_line[31:0];
wire [31:0] way1_bank1_fill_data = fill_line[63:32];
wire [31:0] way1_bank2_fill_data = fill_line[95:64];
wire [31:0] way1_bank3_fill_data = fill_line[127:96];

assign if_addr_ok = (state == S_IDLE) && !cacop_en;
assign if_data_ok = hit || (state == S_FILL && axi_ret_valid);
assign if_data = hit ? hit_data : ret_data;
assign if_pc_out = hit ? if_pc : req_pc;
assign stall_if = if_valid && !if_data_ok;

assign axi_rd_req = (state == S_WAIT) && !cancel_req;
assign axi_rd_type = uncached_r ? 3'b010 : 3'b100;
assign axi_rd_addr = uncached_r ? req_pc : {req_pc[31:4], 4'b0000};

icache_way0_TAGV_ram u_icache_way0_TAGV_ram(
    .addra(cache_ram_addr),
    .clka(clk),
    .dina(fill_accept ? way0_tagv_fill_data : way0_tagv_inval_data),
    .douta(way0_tagv_dout),
    .ena(1'b1),
    .wea(fill_accept ? 4'hF : (way0_inval_we ? 4'hF : 4'h0))
);

icache_way1_TAGV_ram u_icache_way1_TAGV_ram(
    .addra(cache_ram_addr),
    .clka(clk),
    .dina(fill_accept ? way1_tagv_fill_data : way1_tagv_inval_data),
    .douta(way1_tagv_dout),
    .ena(1'b1),
    .wea(fill_accept ? 4'hF : (way1_inval_we ? 4'hF : 4'h0))
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
        state <= S_IDLE;
        req_pc <= 32'b0;
        uncached_r <= 1'b0;
        req_way <= 1'b0;
        req_set <= {SET_W{1'b0}};
        req_tag <= {TAG_W{1'b0}};
        lru_way1 <= 256'b0;
        for (idx = 0; idx < SETS; idx = idx + 1) begin
            lru_way1[idx] <= 1'b0;
        end
    end else begin
        if (cancel_req) begin
            state <= S_IDLE;
        end else if (state == S_IDLE) begin
            if (if_valid && !cacop_en) begin
                req_pc <= cur_addr;
                uncached_r <= if_uncached;
                req_set <= cur_set;
                req_tag <= cur_tag;
                req_way <= replace_way;
                if (way0_hit) begin
                    lru_way1[cur_set] <= 1'b1;
                end else if (way1_hit) begin
                    lru_way1[cur_set] <= 1'b0;
                end else begin
                    state <= S_WAIT;
                end
            end
        end else if (state == S_WAIT) begin
            if (axi_rd_rdy) begin
                state <= S_FILL;
            end
        end else if (state == S_FILL) begin
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

        if (cacop_en && (cacop_op == `CACOP_OP_IDX_INV || cacop_op == `CACOP_OP_HIT_INV)) begin
            lru_way1[cacop_addr[11:4]] <= 1'b0;
        end
    end
end

endmodule
