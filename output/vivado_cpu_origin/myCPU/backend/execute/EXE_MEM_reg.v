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
    
    input wire  [`CSR_OP_NUM-1:0] csr_op_in,
    input wire  [11:0]            csr_num_in,
    input wire  [31:0]            csr_wmask_in,
    input wire  [31:0]            csr_wvalue_in,
    
    input wire  [`WB_SRC_NUM-1:0] wb_src_op_in, // 写回数据来源选择
    input wire  [`TLB_OP_NUM-1:0] tlb_op_in,
    input wire  [9:0]             invtlb_asid_in,
    input wire  [18:0]            invtlb_vpn_in,
    
    input wire                    ertn_op_in,
    input wire                    sys_valid_in,
    input wire                    brk_valid_in,
    input wire                    ine_valid_in,
    input wire                    adef_valid_in, 
    input wire                    ale_valid_in,  
    input wire                    int_valid_in,  
    input wire                    exception_valid_in, // 送 ID_EXE_reg 的指令异常
    input wire  [31:0]            if_vaddr_in,   // 送 ID_EXE_reg 的访存虚地址（目前仅 adef_valid 时有效，用于数据异常处理模块）
    input wire  [31:0]            ale_vaddr_in,  // 送 ID_EXE_reg 的地址错误异常虚地址（目前仅地址错误时有效，用于数据异常处理模块）
    input wire  [`TLB_EX_NUM-1:0] tlb_ex_valid_in,
    input wire  [31:0]            tlb_vaddr_in,

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
    output reg                    slot_tag_out,
    output reg  [`CSR_OP_NUM-1:0] csr_op_out,
    output reg  [11:0]            csr_num_out,  
    output reg  [31:0]            csr_wmask_out,
    output reg  [31:0]            csr_wvalue_out,
    output reg  [`WB_SRC_NUM-1:0] wb_src_op_out,
    output reg  [`TLB_OP_NUM-1:0] tlb_op_out,
    output reg  [9:0]             invtlb_asid_out,
    output reg  [18:0]            invtlb_vpn_out,
    output reg                    ertn_op_out,
    output reg                    sys_valid_out,
    output reg                    brk_valid_out,
    output reg                    ine_valid_out,
    output reg                    adef_valid_out,
    output reg                    ale_valid_out,
    output reg                    int_valid_out,
    output reg                    exception_valid_out,
    output reg  [31:0]            if_vaddr_out,
    output reg  [31:0]            ale_vaddr_out,
    output reg  [`TLB_EX_NUM-1:0] tlb_ex_valid_out,
    output reg  [31:0]            tlb_vaddr_out

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
        csr_op_out <= {`CSR_OP_NUM{1'b0}};
        csr_num_out <= 12'h0;
        csr_wmask_out <= 32'h0;
        csr_wvalue_out <= 32'h0;
        wb_src_op_out <= {`WB_SRC_NUM{1'b0}};
        ertn_op_out <= 1'b0;
        sys_valid_out <= 1'b0;
        brk_valid_out <= 1'b0;
        ine_valid_out <= 1'b0;
        adef_valid_out <= 1'b0;
        ale_valid_out <= 1'b0;
        int_valid_out <= 1'b0;
        exception_valid_out <= 1'b0;
        if_vaddr_out <= 32'h0;
        ale_vaddr_out <= 32'h0;

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
        csr_op_out <= csr_op_in;
        csr_num_out <= csr_num_in;  
        csr_wmask_out <= csr_wmask_in;
        csr_wvalue_out <= csr_wvalue_in;
        wb_src_op_out <= wb_src_op_in;
        ertn_op_out <= ertn_op_in;
        sys_valid_out <= sys_valid_in;
        brk_valid_out <= brk_valid_in;  
        ine_valid_out <= ine_valid_in;
        adef_valid_out <= adef_valid_in;
        ale_valid_out <= ale_valid_in;
        int_valid_out <= int_valid_in;
        exception_valid_out <= exception_valid_in;
        if_vaddr_out <= if_vaddr_in;
        ale_vaddr_out <= ale_vaddr_in;
    end 
    
    // 上游无效且本级可接收新槽：输出清空
    // 若下游反压(allowIn=0)，需保持当前槽，不能因上游valid=0而清空。
    else if (!valid && allowIn) begin
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
        csr_op_out <= {`CSR_OP_NUM{1'b0}};
        csr_num_out <= 12'h0;
        csr_wmask_out <= 32'h0;
        csr_wvalue_out <= 32'h0;
        wb_src_op_out <= {`WB_SRC_NUM{1'b0}};
        ertn_op_out <= 1'b0;
        sys_valid_out <= 1'b0;
        brk_valid_out <= 1'b0;
        ine_valid_out <= 1'b0;
        adef_valid_out <= 1'b0;
        ale_valid_out <= 1'b0;
        int_valid_out <= 1'b0;
        exception_valid_out <= 1'b0;
        if_vaddr_out <= 32'h0;
        ale_vaddr_out <= 32'h0;

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
        csr_op_out <= csr_op_out;
        csr_num_out <= csr_num_out;
        csr_wmask_out <= csr_wmask_out;
        csr_wvalue_out <= csr_wvalue_out;
        wb_src_op_out <= wb_src_op_out;
        ertn_op_out <= ertn_op_out;
        sys_valid_out <= sys_valid_out;
        brk_valid_out <= brk_valid_out;
        ine_valid_out <= ine_valid_out;
        adef_valid_out <= adef_valid_out;
        ale_valid_out <= ale_valid_out;
        int_valid_out <= int_valid_out;
        exception_valid_out <= exception_valid_out;
        if_vaddr_out <= if_vaddr_out;
        ale_vaddr_out <= ale_vaddr_out;
        
    end
end

endmodule
