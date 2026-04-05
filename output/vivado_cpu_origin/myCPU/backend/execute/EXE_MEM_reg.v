`include "../../common/cpu_defs.vh"

// ============================================================
// EXE_MEM_reg：EXE 与 MEM 之间的流水寄存器；slot_tag_out 每成功握手翻转一次供 MEM 区分 load 槽。
// ============================================================
module EXE_MEM_reg (
    input  wire                   clk,
    input  wire                   reset,
    input  wire                   valid,
    input  wire                   readyGo,
    input  wire                   allowIn,

    input  wire [31:0]            exe_alu_or_addr_in, // ALU/分支链结果，或 load/store 地址，之前是final_result_in
    input  wire [31:0]            pc_in,
    input  wire [ 4:0]            wb_reg_addr_in,
    input  wire [`MEM_OP_NUM-1:0] mem_op_in,
    input  wire                   wb_op_in,
    input  wire [31:0]            mem_wdata_in,      // store 数据
    input  wire [31:0]            data_raddr_from_EXE,
    input  wire [31:0]            data_waddr_from_EXE,
    input  wire [31:0]            data_wdata_from_EXE,
    input  wire [ 3:0]            data_wbyte_en_from_EXE,

    output reg  [31:0]            exe_alu_or_addr_out,
    output reg  [31:0]            pc_out,
    output reg  [ 4:0]            wb_reg_addr_out,
    output reg  [`MEM_OP_NUM-1:0] mem_op_out,
    output reg                    wb_op_out,
    output reg  [31:0]            mem_wdata_out,
    output reg  [31:0]            data_raddr_out_from_EXE,
    output reg  [31:0]            data_waddr_out_from_EXE,
    output reg  [31:0]            data_wdata_out_from_EXE,
    output reg  [ 3:0]            data_wbyte_en_out_from_EXE,
    output reg                    slot_tag_out
);

always @(posedge clk) begin
    // 复位：清空本级
    if(reset) begin
        exe_alu_or_addr_out <= 32'h0;
        pc_out <= 32'h0;
        wb_reg_addr_out <= 5'h0;
        mem_op_out <= {`MEM_OP_NUM{1'b0}};
        wb_op_out <= 1'h0;
        mem_wdata_out <= 32'h0;
        data_raddr_out_from_EXE <= 32'h0;
        data_waddr_out_from_EXE <= 32'h0;
        data_wdata_out_from_EXE <= 32'h0;
        data_wbyte_en_out_from_EXE <= 4'h0;
        slot_tag_out <= 1'b0;
    end 
    
    // 握手成功：推进 EXE 输出到 MEM
    else if (valid && readyGo && allowIn) begin
        exe_alu_or_addr_out <= exe_alu_or_addr_in;
        pc_out           <= pc_in;
        wb_reg_addr_out  <= wb_reg_addr_in;
        mem_op_out       <= mem_op_in;
        wb_op_out        <= wb_op_in;
        mem_wdata_out    <= mem_wdata_in;
        data_raddr_out_from_EXE <= data_raddr_from_EXE;
        data_waddr_out_from_EXE <= data_waddr_from_EXE;
        data_wdata_out_from_EXE <= data_wdata_from_EXE;
        data_wbyte_en_out_from_EXE <= data_wbyte_en_from_EXE;
        slot_tag_out <= ~slot_tag_out;
    end 
    
    // 上游无效：输出清空
    else if (!valid) begin
        exe_alu_or_addr_out <= 32'h0;
        pc_out <= 32'h0;
        wb_reg_addr_out <= 5'h0;
        mem_op_out <= {`MEM_OP_NUM{1'b0}};
        wb_op_out <= 1'h0;
        mem_wdata_out <= 32'h0;
        data_raddr_out_from_EXE <= 32'h0;
        data_waddr_out_from_EXE <= 32'h0;
        data_wdata_out_from_EXE <= 32'h0;
        data_wbyte_en_out_from_EXE <= 4'h0;
        slot_tag_out <= slot_tag_out;
    end 
    
    // 反压或本级未就绪：保持当前值
    else begin
        exe_alu_or_addr_out <= exe_alu_or_addr_out;
        pc_out           <= pc_out;
        wb_reg_addr_out  <= wb_reg_addr_out;
        mem_op_out       <= mem_op_out;
        wb_op_out        <= wb_op_out;
        mem_wdata_out    <= mem_wdata_out;
        data_raddr_out_from_EXE <= data_raddr_out_from_EXE;
        data_waddr_out_from_EXE <= data_waddr_out_from_EXE;
        data_wdata_out_from_EXE <= data_wdata_out_from_EXE;
        data_wbyte_en_out_from_EXE <= data_wbyte_en_out_from_EXE;
        slot_tag_out <= slot_tag_out;
    end
end

endmodule
