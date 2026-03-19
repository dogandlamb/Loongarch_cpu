`include "bpu_defines.sv"
`include "frontend_defines.sv"
`include "core_defines.sv"

module ftb
    import core_defines::*;
    import frontend_defines::*;
    import bpu_defines::*;
(
    input logic clk,
    input logic rst,

    // Query 查询端口
    // 用PC查询，输出命中信息，命中条目数据，命中条目在哪一路
    input logic [ADDR_WIDTH-1:0] query_i,
    output ftb_entry_t query_o,
    output logic [$clog2(FTB_NWAY)-1:0] hit_index_o,
    output logic hit_singnal_o,

    // Update signals 更新端口
    input logic [ADDR_WIDTH-1:0] update_i,
    input logic [$clog2(FTB_NWAY)-1:0] update_way_i,
    input logic update_valid_i,
    input logic update_dirty_i,
    input ftb_entry_t update_info_i

);

    // Parameters
    localparam WAY_WIDTH = $clog2(FTB_NSET);   // 10位组索引
    localparam WAY_NUM = $clog2(FTB_NWAY);   // 2位路索引
    localparam NSET = FTB_NSET;
    localparam NWAY = FTB_NWAY;



    // Signals definition
    ftb_entry_t [NWAY-1:0] way_query_entry;
    logic [NWAY-1:0] ftb_way_hit;   // 4位信号，独热码，表示具体哪一路命中
    logic [WAY_NUM-1:0] way_hit_index;   // 最终命中路索引
    // Query
    logic [WAY_WIDTH-1:0] query_index;
    logic [ADDR_WIDTH-WAY_WIDTH-3:0] query_tag_r;
    // Update
    logic [WAY_WIDTH-1:0] update_index;
    ftb_entry_t entry_update;
    logic [NWAY-1:0] update_way_en;
    logic [15:0] random_val;

    // 解决冲突问题
    ftb_entry_t  conflict_entry_r;
    logic query_update_conflict;
    logic query_update_conflict_r;

    // Query logic 查询逻辑===========================================================================
    assign query_index = query_i[2+:WAY_WIDTH]; // 10位组索引
    always_ff @(posedge clk) begin
        query_tag_r <= query_i[ADDR_WIDTH-1:WAY_WIDTH+2];  //tag锁存
    end
    always_comb begin   // 并行查询组索引query_index对应的4个条目，如果有条目命中，那么way_hit对应位为1
        for (integer way_idx = 0; way_idx < NWAY; way_idx++) begin
            ftb_way_hit[way_idx] = (way_query_entry[way_idx].tag == query_tag_r) && way_query_entry[way_idx].valid;
        end
    end



    // Query output
    assign query_o = query_update_conflict_r ? conflict_entry_r : way_query_entry[way_hit_index];  // 输出命中条目信息
    assign hit_singnal_o = |ftb_way_hit;  // FTB是否命中
    assign hit_index_o = way_hit_index; // 优先译码器输出

    // Update logic 更新逻辑=========================================================================
    assign update_index = update_i[WAY_WIDTH+1:2];  // 组索引
    always_comb begin
        if (update_dirty_i) begin  // 确定要覆盖哪一路的情况， update_way_index_i作为路索引
            entry_update = update_info_i;
            update_way_en = 0;
            update_way_en[update_way_i] = update_valid_i;
            // update_entry同时接入到四路存储体的写入端口，而update_we的每一位都对应了一个存储体的写使能
        end else begin  // Update a new entry in 添加一个新的条目
            entry_update = update_info_i;
            update_way_en = 0;
            for (integer way_idx = 0; way_idx < NWAY; way_idx++) begin
                if (way_idx[WAY_NUM-1:0] == random_val[WAY_NUM-1:0])
                    update_way_en[way_idx] = update_valid_i;
            end
        end
    end


    // 宽度为4的优先译码器，把way_hit从独热码翻译成二进制way_hit_index
    normal_priority_encoder #(
        .WIDTH(NWAY)
    ) u_normal_priority_encoder (
        .priority_vector(ftb_way_hit),
        .encoded_result (way_hit_index)
    );

    //伪随机模块
    lfsr #(
        .WIDTH(16)
    ) u_lfsr (
        .clk  (clk),
        .rst  (rst),
        .en   (1'b1),
        .value(random_val)
    );

    generate
        for (genvar way_idx = 0; way_idx < NWAY; way_idx++) begin
        // 综合使用伪双端口RAM
        // Port B as read port, Port A as write port
        bram_ftb u_bram_ftb (
          .clka(clk),      
          .clkb(clk),
          // 端口A（写入）     
          .ena(1'b1),       
          .wea(update_way_en[way_idx]),     
          .addra(update_index),   
          .dina(entry_update),
    
          // 端口B（只读）
          .enb(1'b1),         
          .addrb(query_index),  
          .doutb(way_query_entry[way_idx])  
        );
        end
    endgenerate

// 用来debug，读写地址相同时的行为，发现此时fall_through并不能正常输出，只能采取寄存器旁路路径来解决
    assign query_update_conflict = (update_i == query_i) && update_valid_i;

    always_ff@(posedge clk) begin
        if(rst | (query_update_conflict_r && !query_update_conflict)) begin
            conflict_entry_r <= '0;
            query_update_conflict_r <= 1'b0;
        end else if(query_update_conflict) begin
            query_update_conflict_r <= 1'b1;
            conflict_entry_r <= update_info_i;
        end
    end

endmodule