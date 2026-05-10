// Gshared predictor as base predictor
`ifndef TAGGED_PREDICTOR_SV
`define TAGGED_PREDICTOR_SV
`include "bpu_defines.sv"
`include "frontend_defines.sv"
`include "core_defines.sv"


module tagged_predictor
    import core_defines::*;
    import frontend_defines::*;
    import bpu_defines::*;
#(
    parameter INPUT_GHR_LENGTH = 4,
    parameter PHT_DEPTH = 2048, // PHT表项个数
    parameter PHT_TAG_WIDTH = BPU_TAG_COMPONENT_TAG_WIDTH,
    // BPU_TAG_COMPONENT_TAG_WIDTH=12
    parameter PHT_CTR_WIDTH = 3,    // 饱和计数器位宽
    parameter PHT_USEFUL_WIDTH = 2  //
) (
    input logic clk,
    input logic rst,

    // Query signal
    input logic global_history_update_i,
    input logic [INPUT_GHR_LENGTH:0] global_history_i,
    input logic [ADDR_WIDTH-1:0] pc_i,

    // Meta
    output logic [PHT_USEFUL_WIDTH-1:0] useful_bits_o,
    output logic [PHT_CTR_WIDTH-1:0] ctr_bits_o,
    output logic [PHT_TAG_WIDTH-1:0] query_tag_o,
    output logic [PHT_TAG_WIDTH-1:0] origin_tag_o,
    output logic [$clog2(PHT_DEPTH)-1:0] hit_index_o,
    // Query result
    output logic taken_o,
    output logic tag_hit_o,

    // Update signals
    input logic [ADDR_WIDTH-1:0] update_pc_i,
    input logic update_valid,
    input logic update_useful,
    input logic inc_useful,
    input logic [PHT_USEFUL_WIDTH-1:0] update_useful_bits_i,
    input logic update_ctr,
    input logic inc_ctr,
    input logic [PHT_CTR_WIDTH-1:0] update_ctr_bits_i,
    input logic realloc_entry,
    input logic [PHT_TAG_WIDTH-1:0] update_tag_i,
    input logic [$clog2(PHT_DEPTH)-1:0] update_index_i
);

    // Parameters
    localparam PHT_ADDR_WIDTH = $clog2(PHT_DEPTH);  // PHT_DEPTH=2048 PHT_ADDR_WIDTH=11

    // PHT 模式历史表
    typedef struct packed {
        bit [PHT_CTR_WIDTH-1:0] ctr;        // 3bit饱和计数器   3bit
        bit [PHT_TAG_WIDTH-1:0] tag;        // 标签位           12bit
        bit [PHT_USEFUL_WIDTH-1:0] useful;  // 有用标志         2bit
    } pht_entry;    // 17bit

    // pht_entry [PHT_DEPTH-1:0] PHT;


    // Query Index 查询索引
    // Fold GHT input to a fix length, the same as index range
    // Using a CSR, described in PPM-Liked essay
    logic [PHT_ADDR_WIDTH-1:0] hashed_ght_input;
    logic [PHT_ADDR_WIDTH-1:0] query_index, query_index_delay;
    // Tag
    // Generate another hash different from above, as described in PPM-Liked essay
    logic [PHT_TAG_WIDTH-1:0] tag_hash_csr1;
    logic [PHT_TAG_WIDTH-2:0] tag_hash_csr2;
    logic [PHT_TAG_WIDTH-1:0] query_tag, query_tag_delay;
    // Result
    pht_entry query_result;
    pht_entry bram_query_result;

    // Update entry
    pht_entry update_entry;
    logic [PHT_ADDR_WIDTH-1:0] update_index;

    // 解决冲突问题
    pht_entry  conflict_entry_r;
    logic query_update_conflict;
    logic query_update_conflict_r;


    //  查询逻辑，同时也是关键路径====================================================================

    // query_index is Fold(GHR) ^ PC[low] ^ PC[high]
    assign query_index = pc_i[0+:PHT_ADDR_WIDTH] ^ pc_i[0+PHT_ADDR_WIDTH+:PHT_ADDR_WIDTH] ^ hashed_ght_input;
    // query_tag is XORed from pc_i
    // assign query_tag = pc_i[31:31-PHT_TAG_WIDTH+1];
    assign query_tag = pc_i[2+:PHT_TAG_WIDTH] ^ tag_hash_csr1 ^ {tag_hash_csr2, 1'b0};

    always_ff @(posedge clk) begin
        query_index_delay <= query_index;
        query_tag_delay   <= query_tag;
    end

    // Output
    assign query_result = query_update_conflict_r ? conflict_entry_r : bram_query_result;
    assign ctr_bits_o = query_result.ctr;
    assign useful_bits_o = query_result.useful;
    assign hit_index_o = query_index_delay;
    assign query_tag_o = query_tag_delay;
    assign origin_tag_o = query_result.tag;
    assign taken_o = (query_result.ctr[PHT_CTR_WIDTH-1] == 1'b1);
    assign tag_hit_o = (query_tag_delay == query_result.tag);


    // 更新逻辑==================================================================================
    assign update_index = update_index_i;
    // Main update comb
    always_comb begin
        update_entry.tag = update_tag_i;
        // Update CTR bits
        if (update_ctr) begin
            case (update_ctr_bits_i)
                {PHT_CTR_WIDTH{1'b0}} : begin
                    update_entry.ctr =  inc_ctr ? {{PHT_CTR_WIDTH-1{1'b0}},1'b1} : {PHT_CTR_WIDTH{1'b0}};
                end
                {PHT_CTR_WIDTH{1'b1}} : begin
                    update_entry.ctr =  inc_ctr ? {PHT_CTR_WIDTH{1'b1}} : {{PHT_CTR_WIDTH-1{1'b1}},1'b0};
                end
                default: begin
                    update_entry.ctr = inc_ctr ? update_ctr_bits_i + 1 : update_ctr_bits_i - 1;
                end
            endcase
        end else update_entry.ctr = update_ctr_bits_i;

        // Update useful bits
        if (update_useful) begin
            case (update_useful_bits_i)
                {PHT_USEFUL_WIDTH{1'b1}} : begin
                    update_entry.useful = inc_useful ? {PHT_USEFUL_WIDTH{1'b1}} : update_useful_bits_i - 1;
                end
                {PHT_USEFUL_WIDTH{1'b0}} : begin
                    update_entry.useful =  inc_useful ? update_useful_bits_i + 1 : {PHT_USEFUL_WIDTH{1'b0}};
                end
                default: begin
                    update_entry.useful = inc_useful ? update_useful_bits_i + 1 : update_useful_bits_i - 1;
                end
            endcase
        end else update_entry.useful = update_useful_bits_i;
        // Alocate new entry 
        if (realloc_entry) begin
            update_entry.ctr = {1'b1, {(PHT_CTR_WIDTH - 1) {1'b0}}};  // Reset CTR
            update_entry.useful = 0;  // Clear useful
        end
    end


    // CSR hash
    csr_hash #(
        .INPUT_LENGTH (INPUT_GHR_LENGTH + 1),
        .OUTPUT_LENGTH(PHT_ADDR_WIDTH)
    ) ght_hash_csr_hash (
        .clk   (clk),
        .rst   (rst),
        .data_update_i(global_history_update_i),
        .data_i(global_history_i),
        .hash_o(hashed_ght_input)
    );
    csr_hash #(
        .INPUT_LENGTH (INPUT_GHR_LENGTH + 1),
        .OUTPUT_LENGTH(PHT_TAG_WIDTH)
    ) pc_hash_csr_hash1 (
        .clk   (clk),
        .rst   (rst),
        .data_update_i(global_history_update_i),
        .data_i(global_history_i),
        .hash_o(tag_hash_csr1)
    );
    csr_hash #(
        .INPUT_LENGTH (INPUT_GHR_LENGTH + 1),
        .OUTPUT_LENGTH(PHT_TAG_WIDTH - 1)
    ) pc_hash_csr_hash2 (
        .clk   (clk),
        .rst   (rst),
        .data_update_i(global_history_update_i),
        .data_i(global_history_i),
        .hash_o(tag_hash_csr2)
    );


    // 综合使用伪双端口RAM
    // Port B as read port, Port A as write port
    bram_tagged pht_table (
        .clka (clk),
        .clkb (clk),
        .enb  (1'b1),
        .ena  (1'b1),
        .wea  (update_valid),
        .addrb(query_index),
        .doutb(bram_query_result),
        .dina (update_entry),
        .addra(update_index)
    );
    
// 旁路路径=====================================================
// 用来debug，读写地址相同时的行为，发现此时读取条目并不能正常输出，只能采取寄存器旁路路径来解决
    assign query_update_conflict = (query_index == update_index) && update_valid;

    always_ff@(posedge clk) begin
        if(rst | (query_update_conflict_r && !query_update_conflict)) begin
            conflict_entry_r <= '0;
            query_update_conflict_r <= 1'b0;
        end else if(query_update_conflict) begin
            query_update_conflict_r <= 1'b1;
            conflict_entry_r <= update_entry;
        end
    end



endmodule

`endif