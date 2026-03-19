`include "core_defines.sv"
`include "bpu_defines.sv"


module ras_pre_train
    import core_defines::*;
    import bpu_defines::*;
(
    input logic clk,
    input logic rst,

    input logic backend_redirect_i, // 恢复的标志
    input logic backend_flush_i,    // 栈清空标志

    // BPU
    input bpu_ras_op_t bpu_pre_train_info_i,
    output logic [ADDR_WIDTH-1:0] pre_train_top_addr_o,
    output logic to_bpu_ras_empty,

    // Backend BU
    input BU_ras_op_t BU_train_info_i,
    input [ADDR_WIDTH-1:0] BU_call_addr_i

);

    // Parameters
    localparam PTR_WIDTH = $clog2(RAS_ENTRY_NUM);
    // Data structure
    logic [ADDR_WIDTH-1:0] pre_train_lutram[RAS_ENTRY_NUM];
    logic [ADDR_WIDTH-1:0] BU_lutram[RAS_ENTRY_NUM];
    // BPU预训练
    logic [PTR_WIDTH-1:0] pre_train_new_index;
    logic [PTR_WIDTH-1:0] pre_train_read_index;
    logic [ADDR_WIDTH-1:0] pre_train_call_ret_addr;
    logic pre_train_push,pre_train_pop;
    assign pre_train_push = bpu_pre_train_info_i.ras_push;
    assign pre_train_pop  = bpu_pre_train_info_i.ras_pop;
    assign pre_train_call_ret_addr = bpu_pre_train_info_i.call_ret_address;

    // BU维护信号
    logic [PTR_WIDTH-1:0] BU_new_index;
    logic [PTR_WIDTH-1:0] BU_read_index;
    logic BU_push,BU_pop;
    assign BU_push = BU_train_info_i.ras_push;
    assign BU_pop  = BU_train_info_i.ras_pop;

// 预测器预训练=============================================================
    // Index
    assign pre_train_new_index = pre_train_read_index + PTR_WIDTH'(pre_train_push) - PTR_WIDTH'(pre_train_pop);
    always_ff @(posedge clk) begin
        if (rst) pre_train_read_index <= '0;
        else if(backend_redirect_i) begin
            pre_train_read_index <= BU_read_index;
        end else begin
        pre_train_read_index <= pre_train_new_index;
        end
    end
    // Data
    always_ff @(posedge clk) begin
        // 因为有判空逻辑，所以不必复位初始化，可以使用lutram来实现
        // if (rst) begin
        //     for (int i = 0; i < RAS_ENTRY_NUM; i++) begin
        //         pre_train_lutram[i] <= '0;
        //     end
        // end else 
        if(backend_redirect_i) begin
            pre_train_lutram <= BU_lutram;
        end else if (pre_train_push) begin 
            pre_train_lutram[pre_train_new_index] <= pre_train_call_ret_addr;
        end
    end
    // Output
    assign pre_train_top_addr_o = pre_train_lutram[pre_train_read_index];
    assign to_bpu_ras_empty = pre_train_read_index == 0;

// BU维护正确的栈============================================================

    // Index
    assign BU_new_index = BU_read_index + PTR_WIDTH'(BU_push) - PTR_WIDTH'(BU_pop);
    always_ff @(posedge clk) begin
        if (rst) BU_read_index <= '0;
        else BU_read_index <= BU_new_index;
    end
    // Data
    always_ff @(posedge clk) begin
        // BU维护的返回栈甚至不需要判空
        // if (rst) begin
        //     for (int i = 0; i < RAS_ENTRY_NUM; i++) begin
        //         BU_lutram[i] <= '0;
        //     end
        // end
        if (BU_push) BU_lutram[BU_new_index] <= BU_call_addr_i + 4;
    end
endmodule