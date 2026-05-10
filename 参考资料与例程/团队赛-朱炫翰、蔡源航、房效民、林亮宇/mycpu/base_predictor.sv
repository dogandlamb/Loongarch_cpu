`ifndef BASE_PREDICTOR_SV
`define BASE_PREDICTOR_SV
`include "bpu_defines.sv"
`include "frontend_defines.sv"
`include "core_defines.sv"

module base_predictor
    import core_defines::*;
    import frontend_defines::*;
    import bpu_defines::*;
(
    input logic clk,
    input logic rst,
    // Query
    input logic [ADDR_WIDTH-1:0] pc_i,
    output logic taken,
    output logic [BPU_COMPONENT_CTR_WIDTH[0]-1:0] ctr,
    // Update
    input logic update_valid,
    input logic [ADDR_WIDTH-1:0] update_pc_i,
    input logic inc_ctr,
    input logic [BPU_COMPONENT_CTR_WIDTH[0]-1:0] update_ctr_i
);

    localparam TABLE_DEPTH = BPU_COMPONENT_TABLE_DEPTH[0];
    localparam TABLE_DEPTH_EXP2 = $clog2(TABLE_DEPTH);
    localparam CTR_WIDTH = BPU_COMPONENT_CTR_WIDTH[0];

    // 查询逻辑========================================================================
    logic [TABLE_DEPTH_EXP2-1:0] query_index;
    logic [CTR_WIDTH-1:0] query_entry;

    // 解决冲突问题
    logic [CTR_WIDTH-1:0]  conflict_entry_r;
    logic [CTR_WIDTH-1:0]  bram_query_entry;
    logic query_update_conflict;
    logic query_update_conflict_r;


    assign query_entry = query_update_conflict_r ? conflict_entry_r : bram_query_entry;


    assign query_index = pc_i[2+TABLE_DEPTH_EXP2-1:2];
    assign taken = (query_entry[CTR_WIDTH-1] == 1'b0);
    assign ctr = (query_entry);

    // BRAM清空复位逻辑，暂时禁用=======================================================
    
    typedef enum logic [1:0] {
        RESET_IDLE,
        RESET_CLEARING,
        RESET_COMPLETE
    } reset_state_t;

    reset_state_t reset_state, reset_state_next;
    logic [TABLE_DEPTH_EXP2-1:0] reset_index;        // Current reset index

    always_ff @(posedge clk) begin
        if (rst) begin
            reset_state <= RESET_CLEARING;
            reset_index <= '0;
        end 
        // else begin
        //     reset_state <= reset_state_next;
            
        //     // Increment reset counters
        //     if (reset_state == RESET_CLEARING) begin
        //         reset_index <= reset_index + 1;
        //     end
        // end
    end
    
    always_comb begin
        reset_state_next = reset_state;
        
        case (reset_state)
            RESET_CLEARING: 
                // Complete when last way of last set is cleared
                if (reset_index == (1 << TABLE_DEPTH_EXP2) - 1 ) 
                    reset_state_next = RESET_COMPLETE;
            
            RESET_COMPLETE: 
                // Stay in complete state until next reset
                reset_state_next = RESET_COMPLETE;
            
            default: 
                reset_state_next = RESET_IDLE;
        endcase
    end
    
    // Reset active signal
    logic reset_active;
    assign reset_active = (reset_state == RESET_CLEARING);
    
    // Reset complete signal
    logic reset_complete;
    assign reset_complete = (reset_state == RESET_COMPLETE);

    logic update_entry_mask,update_we_mask,update_index_mask,read_enable_mask;
    // 设置复位变量
    assign update_entry_mask = 1'b0;
    assign update_we_mask = 1'b0 ;
    assign update_index_mask =  1'b0;
    assign read_enable_mask =  1'b0;

    // 更新逻辑======================================================================
    logic [TABLE_DEPTH_EXP2-1:0] update_index;
    logic [CTR_WIDTH-1:0] update_content;
    assign update_index = update_pc_i[TABLE_DEPTH_EXP2+1:2];
    always_comb begin
        if (update_valid) begin
            if (update_ctr_i == {1'b0, {CTR_WIDTH - 1{1'b1}}}) begin
                update_content = inc_ctr ? update_ctr_i : update_ctr_i - 1;
            end else if (update_ctr_i == {1'b1, {CTR_WIDTH - 1{1'b0}}}) begin
                update_content = inc_ctr ? update_ctr_i + 1 : update_ctr_i;
            end else begin
                update_content = inc_ctr ? update_ctr_i + 1 : update_ctr_i - 1;
            end
        end else begin
            update_content = 0;
        end
    end


    // 综合使用伪双端口RAM
    // Port B as read port, Port A as write port
        bram_base_predictor pht_table (
        .clka (clk),
        .clkb (clk),
        .enb  (1'b1),
        .ena  (1'b1),
        .wea  (update_valid),

        .addrb(query_index),        // 14
        .doutb(bram_query_entry),        // 2
        .dina (update_content),
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
            conflict_entry_r <= update_content;
        end
    end


endmodule

`endif