`ifndef BPU_SV
`define BPU_SV
`include "bpu_defines.sv"
`include "frontend_defines.sv"
`include "core_defines.sv"
module bpu
    import core_defines::*;
    import frontend_defines::*;
    import bpu_defines::*;
(
    input logic clk,
    input logic rst,

    // 冲刷&重定向
    input logic backend_flush_i,

    // FTQ接口
    input  [ADDR_WIDTH-1:0] pc_i,               // 预测PC
    input  logic ftq_queue_full_i,                    // FTQ满
    // 预测块输出
    output ftq_block_t ftq_base_pre_block_o,    // P0预测块
    output ftq_block_t ftq_main_pre_block_o,    // P1预测块（TAGE修正）
    output bpu_ftq_meta_t to_ftq_bpu_info_o,           // 预测元数据
    // 训练数据
    input  ftq_bpu_meta_t ftq_train_info_i,

    // 主预测器重定向修改PC
    output logic main_redirect_o,
    output logic [ADDR_WIDTH-1:0] main_redirect_pc_o,

    // 提前训练RAS
    output bpu_ras_op_t bpu_ras_train_info_o,
    input logic [ADDR_WIDTH-1:0] pre_train_ras_top_i,
    input logic ras_empty_i
);

// 信号和参数 ========================================================

    // 基础预测器计数器的宽度为2
    localparam BASE_PRE_CTR_WIDTH = BPU_COMPONENT_CTR_WIDTH[0];

    logic [ADDR_WIDTH-1:0] pc_delay;       // pc_delay用于TAGE的预测，可以理解为延迟之后的PC
    logic main_redirect;                // 主预测器重定向信号

    logic ftb_hit;                      // FTB命中标志
    logic [$clog2(FTB_NWAY)-1:0] ftb_hit_index; // FTB命中索引
    ftb_entry_t ftb_query_info;              // FTB查询结果

    logic main_bpu_pre_taken, main_bpu_pre_valid; // 预测跳转、预测有效，来自主预测器


    logic flush_delay, ftq_full_delay;
    always_ff @(posedge clk) begin
        flush_delay <= backend_flush_i | (main_redirect & ~ftq_full_delay);
        ftq_full_delay <= ftq_queue_full_i;
    end

// FTQ块的生成逻辑 ========================================================
    bpu_ftq_meta_t tage_meta; // bpu给ftq的预测元数据
    logic if_cross_a_cacheline;
    assign if_cross_a_cacheline = pc_i[3:0] > 4'h0;
    //  基础预测or无空泡预测-------------------------------
    always_comb begin
        if (ftq_queue_full_i) begin   // 如果FTQ满，那么拉低所有给FTQ的信号
            ftq_base_pre_block_o = 0;
        end else begin  // P0 generate a next-line prediction
            if (if_cross_a_cacheline) begin
                ftq_base_pre_block_o.length = 3'b100 - pc_i[3:2];  //通过比较巧妙的方法防止基本块跨页，否则地址翻译对一个基本块中的pc就有可能出现区别
            end else begin
                ftq_base_pre_block_o.length = 4;
            end
            ftq_base_pre_block_o.start_pc = pc_i;       // 块起始pc
            ftq_base_pre_block_o.valid = 1;             // 块有效
            // If cross page, length will be cut, so ensures no cacheline cross
            ftq_base_pre_block_o.is_cross_cacheline = 1'b0;
            ftq_base_pre_block_o.predicted_taken = 0;   // 基础预测就是不跳转
            ftq_base_pre_block_o.predict_valid = 0;     // 基础预测不提供有效预测
        end
    end
    // 备注：对于是否跨cacheline还要确认一下fang写的Cahce是怎么缓存Cache行的，是从发生缺失的地址开始缓存还是说从规定的cacheline开头缓存

    // TAGE重定向预测-------------------------------
    assign main_redirect = ftb_hit & ~flush_delay & ~ftq_full_delay;
        // 如果ftb命中，说明是之前缓存过的基本块，此时启用TAGE主预测器进行预测
        // ftq_full_delay：表示上个时钟周期bpu指针和com指针只相差1，所以当前时钟在没有提交的情况下两个指针重合，FTQ不支持写入
        // flush_delay：如果上个时钟预测器收到flush，那么这个时钟TAGE肯定没有给出正确的预测结果
    always_ff @(posedge clk) begin
        pc_delay <= pc_i;  // 延迟PC用于P1预测
    end
    // 主预测器给FTQ的输出
    always_comb begin
        if (main_redirect) begin  // 如果当前周期主预测器给出预测结果，那么生成块
            ftq_main_pre_block_o.valid = 1;
            ftq_main_pre_block_o.is_cross_cacheline = ftb_query_info.is_cross_cacheline;
            ftq_main_pre_block_o.start_pc = pc_delay;
            ftq_main_pre_block_o.length = ftb_query_info.fall_through_address[2+$clog2(FETCH_WIDTH):2] -pc_delay[2+$clog2(FETCH_WIDTH):2];  // 用分支跳转失败的回退地址来计算基本块的长度
            ftq_main_pre_block_o.predict_valid = 1;
            case (ftb_query_info.branch_type)
                BRANCH_TYPE_COND: begin
                    ftq_main_pre_block_o.predicted_taken = main_bpu_pre_taken;
                end
                BRANCH_TYPE_CALL, BRANCH_TYPE_RET, BRANCH_TYPE_UNCOND: begin
                    ftq_main_pre_block_o.predicted_taken = 1;   // 这三类是一定跳转的，此时应该直接根据ftb条目
                end
            endcase
        end else ftq_main_pre_block_o = 0;
    end
    
    // PC output 预测器重定向更新PC，更新的PC会作为下一次预测的起始地址
    always_comb begin
        main_redirect_o = main_redirect;
        case (ftb_query_info.branch_type)
            BRANCH_TYPE_COND:   // 一般的分支指令，根据预测的方向选择更新PC
            main_redirect_pc_o = main_bpu_pre_taken ? ftb_query_info.jump_target_address : ftb_query_info.fall_through_address;
            BRANCH_TYPE_CALL, BRANCH_TYPE_UNCOND:   // 调用指令必定跳转，用目标地址更新PC
            main_redirect_pc_o = ftb_query_info.jump_target_address;
            BRANCH_TYPE_RET:    // 返回指令从RAS栈顶弹出指令更新PC
            if (ras_empty_i) main_redirect_pc_o = ftb_query_info.fall_through_address;
            else main_redirect_pc_o = pre_train_ras_top_i;
        endcase
    end

    // 给FTQ暂存的训练信息
    assign to_ftq_bpu_info_o.bpu_meta = tage_meta.bpu_meta;       // 组合FTB数据和TAGE数据
    assign to_ftq_bpu_info_o.ftb_hit  = ftb_hit;
    assign to_ftq_bpu_info_o.ftb_hit_index  = ftb_hit_index;
    assign to_ftq_bpu_info_o.valid  = ftb_hit;


// FTB ==================================================
    logic bpu_miss_pre;                               // 预测错误标志
    logic ftb_update_valid;                         // FTB更新有效标志
    tage_predictor_update_info_t tage_update_info;  // TAGE更新信息
    ftb_entry_t ftb_update_entry;                   // FTB更新条目
    // FTB更新条件（满足任一）：
    // 1. 条件分支预测错误且FTB未命中
    // 2. FTB条目脏（需要更新）
    // 3. 第一次遇见一个条目
    always_comb begin
        ftb_update_entry.valid = ~(ftq_train_info_i.ftb_dirty & ftq_train_info_i.ftb_hit);
        ftb_update_entry.tag = ftq_train_info_i.start_pc[ADDR_WIDTH-1:$clog2(FTB_NSET)+2];
        ftb_update_entry.branch_type = ftq_train_info_i.branch_type;
        ftb_update_entry.is_cross_cacheline = ftq_train_info_i.is_cross_cacheline;
        ftb_update_entry.jump_target_address = ftq_train_info_i.jump_target_address;
        ftb_update_entry.fall_through_address = ftq_train_info_i.fall_through_address;
        bpu_miss_pre = ftq_train_info_i.predicted_taken ^ ftq_train_info_i.is_taken;
        ftb_update_valid = ftq_train_info_i.valid & ((bpu_miss_pre & ~ftq_train_info_i.ftb_hit)| (ftq_train_info_i.ftb_dirty & ftq_train_info_i.ftb_hit));
    end
    ftb u_ftb (
        .clk(clk),
        .rst(rst),

        // Query
        .query_i(pc_i),
        .query_o(ftb_query_info),
        .hit_singnal_o(ftb_hit),
        .hit_index_o(ftb_hit_index),

        // Update
        .update_i(ftq_train_info_i.start_pc),
        .update_way_i(ftq_train_info_i.ftb_hit_index),
        .update_valid_i(ftb_update_valid),
        .update_dirty_i(ftq_train_info_i.ftb_dirty & ftq_train_info_i.ftb_hit),
        .update_info_i(ftb_update_entry)
    );

    // TAGE====================================================
    always_comb begin
        tage_update_info.valid = ftq_train_info_i.valid;
        tage_update_info.predict_correct = ftq_train_info_i.valid & ~bpu_miss_pre;
        tage_update_info.is_conditional = ftq_train_info_i.branch_type == BRANCH_TYPE_COND;
        tage_update_info.branch_taken = ftq_train_info_i.is_taken;
        tage_update_info.bpu_meta = ftq_train_info_i.bpu_meta;
    end

    tage_predictor u_tage_predictor (
        .clk                   (clk),
        .rst                   (rst),
        .pc_i                  (pc_i),
        .bpu_meta_o            (tage_meta),
        .predict_branch_taken_o(main_bpu_pre_taken),
        .predict_valid_o       (main_bpu_pre_valid),
        .update_pc_i           (ftq_train_info_i.start_pc),
        .update_info_i         (tage_update_info)
    );

    // RAS===========================================================

    assign bpu_ras_train_info_o.ras_push = main_redirect && (ftb_query_info.branch_type == BRANCH_TYPE_CALL);
    assign bpu_ras_train_info_o.ras_pop  = main_redirect && (ftb_query_info.branch_type == BRANCH_TYPE_RET) && !ras_empty_i;
    assign bpu_ras_train_info_o.call_ret_address = ftb_query_info.fall_through_address;


endmodule

`endif