`include "core_defines.sv"
`include "bpu_defines.sv"
`include "frontend_defines.sv"

module tage_predictor
    import core_defines::*;
    import frontend_defines::*;
    import bpu_defines::*;
(
    input logic clk,
    input logic rst,

    // Query signal
    // 查询接口
    input logic [ADDR_WIDTH-1:0] pc_i,
    output bpu_ftq_meta_t bpu_meta_o  /*verilator public*/,
    output logic predict_branch_taken_o,
    output logic predict_valid_o,

    // Update signals
    // 更新接口
    input logic [ADDR_WIDTH-1:0] update_pc_i,
    input tage_predictor_update_info_t update_info_i
);


`ifdef DUMP_WAVEFORM
    initial begin
        $dumpfile("logs/wave.fst");
        $dumpvars(0, tage_predictor);
    end
`endif

    // Parameters
    localparam GHR_DEPTH = BPU_GHR_LENGTH; //1400
    localparam TAG_COMPONENT_AMOUNT = BPU_TAG_COMPONENT_NUM; //15 组件的数量
    localparam integer HISTORY_LENGTH[TAG_COMPONENT_AMOUNT+1] 
    = BPU_COMPONENT_HISTORY_LENGTH; //各个组件参考的历史长度
    localparam integer PHT_DEPTH[TAG_COMPONENT_AMOUNT+1] 
    = BPU_COMPONENT_TABLE_DEPTH; //各个组件的PHT深度


    // Reset
    logic rst_n;
    assign rst_n = ~rst;

    // Input
    tage_meta_t update_meta;
    assign update_meta = update_info_i.bpu_meta;

    // Signals
    // Query
    logic [TAG_COMPONENT_AMOUNT:0] taken;  // All components taken {tag_taken, base_taken}
    // Base predictor
    logic base_taken;
    logic [BPU_COMPONENT_CTR_WIDTH[0]-1:0] base_ctr;
    // Tagged predictor
    // The provider id of the accepted prediction, selected using priority encoder
    logic [$clog2(TAG_COMPONENT_AMOUNT+1)-1:0] pred_prediction_id;
    // The provider id of the last hit provider
    logic [$clog2(TAG_COMPONENT_AMOUNT+1)-1:0] altpred_prediction_id;
    // For example, provider 2,4 hit, and provider 1,3 missed
    // then pred is 4, and altpred is 2
    logic [TAG_COMPONENT_AMOUNT-1:0] tag_taken;
    logic [TAG_COMPONENT_AMOUNT-1:0] tag_hit;
    logic query_is_useful;  // Indicates whether the pred component is useful
    logic query_new_entry_flag;  // Indicates the provider is new

    // Meta
    logic [TAG_COMPONENT_AMOUNT-1:0][2:0] tag_ctr;
    logic [TAG_COMPONENT_AMOUNT-1:0][2:0] tag_useful;
    logic [TAG_COMPONENT_AMOUNT-1:0][BPU_TAG_COMPONENT_TAG_WIDTH-1:0] tag_query_tag;
    logic [TAG_COMPONENT_AMOUNT-1:0][BPU_TAG_COMPONENT_TAG_WIDTH-1:0] tag_origin_tag;
    logic [TAG_COMPONENT_AMOUNT-1:0][9:0] tag_hit_index;

    // Update
    logic [ADDR_WIDTH-1:0] update_pc;
    logic base_update_ctr;
    logic update_valid, global_history_update; // GHR更新标志
    logic update_predict_correct;
    logic update_branch_taken;
    logic update_is_conditional;
    logic update_new_entry_flag;  // Indicates the provider is new
    logic [$clog2(TAG_COMPONENT_AMOUNT+1)-1:0] update_provider_id;
    logic [$clog2(TAG_COMPONENT_AMOUNT+1)-1:0] update_alt_provider_id;
    logic [TAG_COMPONENT_AMOUNT:0] update_ctr;  // Whether a component should updated its ctr
    logic [TAG_COMPONENT_AMOUNT-1:0] tag_update_ctr;
    logic [TAG_COMPONENT_AMOUNT-1:0] tag_update_useful;
    logic [TAG_COMPONENT_AMOUNT-1:0] tag_update_inc_useful;
    logic [TAG_COMPONENT_AMOUNT-1:0] tag_update_realloc_entry;
    logic [TAG_COMPONENT_AMOUNT-1:0][2:0] tag_update_query_useful;
    logic [TAG_COMPONENT_AMOUNT-1:0][BPU_TAG_COMPONENT_TAG_WIDTH-1:0] tag_update_new_tag;
    // Indicates the longest history component which useful is 0
    logic [$clog2(TAG_COMPONENT_AMOUNT+1)-1:0] tag_update_useful_zero_id;

    // pingpong counter & lfsr
    // is a random number array
    logic [15:0] random_r;
    logic [TAG_COMPONENT_AMOUNT-1:0] tag_update_useful_pingpong_counter;

    // USE_ALT_ON_NA counter
    logic [3:0] use_alt_on_na_counter_table[8];
    logic [3:0] use_alt_on_na_counter;
    logic use_alt;
    integer use_alt_cnt;

    
    // END of Defines

    // Global History Register
    logic [GHR_DEPTH-1:0] GHR; // 全局历史寄存器
    always_ff @(posedge clk) begin
        if (update_valid) begin
            // Shift left for every valid branch
            GHR <= {GHR[GHR_DEPTH-2:0], update_branch_taken};
        end
    end
    always_ff @(posedge clk) begin
        global_history_update <= update_valid;
    end

    // Query Logic
    

    // Base Predictor //基础预测器实例化，提供基础的预测结果
    base_predictor u_base_predictor (
        .clk         (clk),
        .rst         (rst),
        .pc_i        (pc_i),            //用来预测的PC
        .update_valid(base_update_ctr), //基础预测器更新控制信号？
        .taken       (base_taken),      //基础预测的taken结果
        .ctr         (base_ctr),        //基础预测器的计数器值？
        .update_pc_i (update_pc),       //更新条目的pc值
        .inc_ctr     (update_branch_taken),//用于更新的是否跳转信息
        .update_ctr_i(update_meta.provider_ctr_bits[0])
    );
    // Tagged Predictor
    generate
        for (
            genvar provider_id = 0; provider_id < TAG_COMPONENT_AMOUNT; provider_id++
        ) begin : tagged_gen
            tagged_predictor #(
                .INPUT_GHR_LENGTH(HISTORY_LENGTH[provider_id+1]),
                .PHT_DEPTH(PHT_DEPTH[provider_id+1]),
                .PHT_USEFUL_WIDTH(BPU_COMPONENT_USEFUL_WIDTH[provider_id+1]),
                .PHT_CTR_WIDTH(BPU_COMPONENT_CTR_WIDTH[provider_id+1])
            ) u_tagged_predictor (
                .clk                    (clk),
                .rst                    (rst),
                // Query
                .global_history_update_i(update_valid),
                .global_history_i       (GHR[HISTORY_LENGTH[provider_id+1]:0]),
                .pc_i                   (pc_i),
                .useful_bits_o          (tag_useful[provider_id]),
                .ctr_bits_o             (tag_ctr[provider_id]),
                .query_tag_o            (tag_query_tag[provider_id]),
                .origin_tag_o           (tag_origin_tag[provider_id]),
                .hit_index_o            (tag_hit_index[provider_id]),
                .taken_o                (tag_taken[provider_id]),
                .tag_hit_o              (tag_hit[provider_id]),

                // Update
                .update_pc_i         (update_pc_i),
                .update_valid        (update_valid & update_is_conditional),
                .update_useful       (tag_update_useful[provider_id]),
                .inc_useful          (tag_update_inc_useful[provider_id]),
                .update_useful_bits_i(update_meta.tag_predictor_useful_bits[provider_id]),
                .update_ctr          (tag_update_ctr[provider_id]),
                .inc_ctr             (update_branch_taken),
                .update_ctr_bits_i   (update_meta.provider_ctr_bits[provider_id+1]),
                .realloc_entry       (tag_update_realloc_entry[provider_id]),
                .update_tag_i        (tag_update_new_tag[provider_id]),
                .update_index_i      (update_meta.tag_predictor_hit_index[provider_id])
            );
        end
    endgenerate

    assign query_is_useful = (taken[pred_prediction_id] != taken[altpred_prediction_id]);

    // Select the longest match provider
    always_comb begin
        pred_prediction_id = 0;
        for (integer i = 0; i < TAG_COMPONENT_AMOUNT; i++) begin
            if (tag_hit[i]) pred_prediction_id = i + 1;
        end
    end


    logic [TAG_COMPONENT_AMOUNT:0] altpred_pool;
    always_comb begin
        altpred_pool = {tag_hit, 1'b1};
        if (pred_prediction_id != 0) begin
            altpred_pool[pred_prediction_id] = 1'b0;
        end
    end
    always_comb begin
        altpred_prediction_id = 0;
        for (integer i = 0; i < TAG_COMPONENT_AMOUNT + 1; i++) begin
            if (altpred_pool[i]) altpred_prediction_id = i;
        end
    end

    // Output logic
    assign predict_valid_o = 1;
    assign taken = {tag_taken, base_taken};
    assign query_new_entry_flag = (tag_ctr[pred_prediction_id-1] == 3'b011 || tag_ctr[pred_prediction_id-1] == 3'b100) && 
                                    pred_prediction_id != 0;
    assign use_alt_on_na_counter = use_alt_on_na_counter_table[pc_i[2+:3]];
    assign use_alt = (use_alt_on_na_counter[3] == 1) && query_new_entry_flag;
    // assign use_alt = 0;
    assign predict_branch_taken_o = taken[pred_prediction_id];
    // Meta
    tage_meta_t query_meta;
    assign query_meta.tag_predictor_useful_bits = tag_useful;
    assign query_meta.tag_predictor_hit_index = tag_hit_index;
    assign query_meta.tag_predictor_query_tag = tag_query_tag;
    assign query_meta.tag_predictor_origin_tag = tag_origin_tag;
    assign query_meta.useful = query_is_useful;
    assign query_meta.provider_id = pred_prediction_id;
    assign query_meta.alt_provider_id = altpred_prediction_id;
    assign query_meta.provider_ctr_bits[0] = base_ctr;
    always_comb begin
        for (integer i = 1; i < TAG_COMPONENT_AMOUNT + 1; i++) begin
            query_meta.provider_ctr_bits[i] = tag_ctr[i-1];
        end
    end

    assign bpu_meta_o.bpu_meta = query_meta;

    // Update policy

    // USE_ALT_ON_NA
    assign update_new_entry_flag = (update_meta.provider_ctr_bits[update_provider_id-1] == 3'b011 || update_meta.provider_ctr_bits[update_provider_id-1] == 3'b100) && update_provider_id != 0;
    // assign update_new_entry_flag = update_meta.tag_predictor_useful_bits[update_provider_id-1] == 0 && (update_meta.provider_ctr_bits[update_provider_id-1] == 3'b010 || update_meta.provider_ctr_bits[update_provider_id-1] == 3'b001) && update_provider_id != 0;
    always_ff @(posedge clk) begin
        if (update_valid & update_new_entry_flag & update_meta.useful & ~update_info_i.predict_correct)
            use_alt_on_na_counter_table[update_pc[2+:3]] <= use_alt_on_na_counter == 4'b1111 ? 4'b1111 : use_alt_on_na_counter +1;
        else if (update_valid & update_new_entry_flag & update_meta.useful & update_info_i.predict_correct)
            use_alt_on_na_counter_table[update_pc[2+:3]] <= use_alt_on_na_counter == 0 ? 0 : use_alt_on_na_counter - 1;
    end
    always_ff @(posedge clk) begin
        if (use_alt) use_alt_cnt <= use_alt_cnt + 1;
    end

    // Update structs
    assign tag_update_ctr = update_ctr[TAG_COMPONENT_AMOUNT:1];
    assign base_update_ctr = update_ctr[0];
    // update-prefixed signals are updated related 
    assign update_valid = update_info_i.valid;
    assign update_predict_correct = update_info_i.predict_correct;
    assign update_branch_taken = update_info_i.branch_taken;
    assign update_is_conditional = update_info_i.is_conditional;
    assign update_provider_id = update_meta.provider_id;
    assign update_alt_provider_id = update_meta.alt_provider_id;
    assign update_pc = update_pc_i;

    assign tag_update_query_useful = update_meta.tag_predictor_useful_bits;



    // Get the ID of desired allocate component
    // This block finds the ID of useful == 0 component
    logic [TAG_COMPONENT_AMOUNT-1:0] tag_update_query_useful_match;
    always_comb begin
        for (integer i = 0; i < TAG_COMPONENT_AMOUNT; i++) begin
            tag_update_query_useful_match[i] = (tag_update_query_useful[i] == 0);
        end
    end
    // Allocation policy, according to TAGE essay
    // Shorter history component has a higher chance of chosen
    always_comb begin
        tag_update_useful_zero_id = 0;  // default 0
        for (integer i = TAG_COMPONENT_AMOUNT - 1; i >= 0; i--) begin
            if (tag_update_query_useful_match[i] && i + 1 > update_provider_id) begin
                // 1/2 probability when longer history tag want to be selected
                if (tag_update_useful_pingpong_counter[i]) begin
                    tag_update_useful_zero_id = i + 1;
                end
            end
        end
    end

    // LFSR & Ping-pong counter
    lfsr #(
        .WIDTH(16)
    ) u_pingpong_lfsr (
        .clk  (clk),
        .rst  (rst),
        .en   (1'b1),
        .value(random_r)
    );
    assign tag_update_useful_pingpong_counter = random_r[TAG_COMPONENT_AMOUNT-1:0];




    // Fill update structs
    // update_ctr
    always_comb begin : update_ctr_policy
        // update_ctr, default 0
        for (integer i = 0; i < TAG_COMPONENT_AMOUNT + 1; i++) begin
            update_ctr[i] = 1'b0;
        end
        // Update provider
        if (update_is_conditional & update_valid) begin
            update_ctr[update_provider_id] = 1;
        end
        // Update alt_provider if new entry
        if (update_new_entry_flag & update_is_conditional & ~update_info_i.predict_correct & update_valid) begin
            update_ctr[update_alt_provider_id] = 1;
        end
    end

    // tag_update_useful & tag_update_inc_useful & tag_update_realloc_entry
    always_comb begin : tag_update_policy
        // Default 0
        for (integer i = 0; i < TAG_COMPONENT_AMOUNT; i++) begin
            tag_update_useful[i] = 1'b0;
            tag_update_inc_useful[i] = 1'b0;
            tag_update_realloc_entry[i] = 1'b0;
        end
        if (update_is_conditional & update_valid) begin  // Only update on conditional branches
            if (update_predict_correct) begin
                // If useful, update useful bits
                tag_update_useful[update_provider_id-1] = update_meta.useful;
                // Increase if correct, else decrease
                tag_update_inc_useful[update_provider_id-1] = update_info_i.predict_correct;
            end else begin
                // Allocate new entry if mispredict
                // Allocate entry in longer history component
                if (tag_update_useful_zero_id > update_provider_id) begin  // Have found a slot to allocate
                    tag_update_realloc_entry[tag_update_useful_zero_id-1] = 1'b1;
                    if (update_new_entry_flag) tag_update_useful[update_provider_id-1] = 1;
                end else begin  // No slot to allocate, decrease all useful bits of longer history components
                    for (integer i = 0; i < TAG_COMPONENT_AMOUNT; i++) begin
                        if (i >= update_provider_id - 1) begin
                            tag_update_useful[i] = 1'b1;
                            tag_update_inc_useful[i] = 1'b0;
                        end
                    end
                end
            end
        end
    end
    // generate new tag
    always_comb begin
        for (integer i = 0; i < TAG_COMPONENT_AMOUNT; i++) begin
            tag_update_new_tag[i] = tag_update_realloc_entry[i] ? update_meta.tag_predictor_query_tag[i] : update_meta.tag_predictor_origin_tag[i];
        end
    end


endmodule
