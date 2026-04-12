// =====================================================
// MEM_WB_reg：MEM 与 WB 之间的流水寄存器。
// =====================================================
module MEM_WB_reg (
    input  wire        clk,
    input  wire        reset,
    input  wire        valid,
    input  wire        readyGo,
    input  wire        allowIn,

    input  wire [31:0] wb_wdata_in,
    input  wire [31:0] pc_in,
    input  wire [ 4:0] wb_reg_addr_in,
    input  wire        wb_op_in,

    input wire  [`CSR_OP_NUM-1:0] csr_op_in,
    input wire  [11:0]            csr_num_in,
    input wire  [31:0]            csr_wmask_in,
    input wire  [31:0]            csr_wvalue_in,
    input wire  [`WB_SRC_NUM-1:0] wb_src_op_in,     // 写回数据来源选择
    
    input wire                    ertn_op_in,
    input wire                    sys_valid_in,
    input wire                    brk_valid_in,
    input wire                    ine_valid_in,
    input wire                    adef_valid_in, 
    input wire                    int_valid_in,  
    input wire                    ale_valid_in,  
    input wire                    exception_valid_in, 
    input wire  [31:0]            if_vaddr_in,   
    input wire  [31:0]            ale_vaddr_in, 

    output reg  [31:0]            wb_wdata_out,
    output reg  [31:0]            pc_out,
    output reg  [ 4:0]            wb_reg_addr_out,
    output reg                    wb_op_out,

    output reg  [`CSR_OP_NUM-1:0] csr_op_out,
    output reg  [11:0]            csr_num_out,  
    output reg  [31:0]            csr_wmask_out,
    output reg  [31:0]            csr_wvalue_out,
    output reg  [`WB_SRC_NUM-1:0] wb_src_op_out,
    output reg                    ertn_op_out,
    output reg                    sys_valid_out,
    output reg                    brk_valid_out,
    output reg                    ine_valid_out,
    output reg                    adef_valid_out,
    output reg                    ale_valid_out,
    output reg                    int_valid_out,
    output reg                    exception_valid_out,
    output reg  [31:0]            if_vaddr_out,
    output reg  [31:0]            ale_vaddr_out
);

always @(posedge clk) begin
    if (reset) begin
        wb_wdata_out    <= 32'b0;
        pc_out          <= 32'b0;
        wb_reg_addr_out <= 5'b0;
        wb_op_out       <= 1'b0;
        csr_op_out      <= {`CSR_OP_NUM{1'b0}};
        csr_num_out     <= 12'b0;
        csr_wmask_out   <= 32'b0;
        csr_wvalue_out  <= 32'b0;
        wb_src_op_out   <= {`WB_SRC_NUM{1'b0}};
        ertn_op_out     <= 1'b0;
        sys_valid_out   <= 1'b0;
        brk_valid_out   <= 1'b0;
        ine_valid_out   <= 1'b0;
        adef_valid_out  <= 1'b0;
        ale_valid_out   <= 1'b0;
        int_valid_out   <= 1'b0;
        exception_valid_out <= 1'b0;
        if_vaddr_out    <= 32'b0;
        ale_vaddr_out   <= 32'b0;


    end else if (valid && readyGo && allowIn) begin
        wb_wdata_out    <= wb_wdata_in;
        pc_out          <= pc_in;
        wb_reg_addr_out <= wb_reg_addr_in;
        wb_op_out       <= wb_op_in;
        csr_op_out      <= csr_op_in;
        csr_num_out     <= csr_num_in;
        csr_wmask_out   <= csr_wmask_in;
        csr_wvalue_out  <= csr_wvalue_in;
        wb_src_op_out   <= wb_src_op_in;
        ertn_op_out     <= ertn_op_in;
        sys_valid_out   <= sys_valid_in;
        brk_valid_out   <= brk_valid_in;
        ine_valid_out   <= ine_valid_in;
        adef_valid_out  <= adef_valid_in;
        ale_valid_out   <= ale_valid_in;
        int_valid_out   <= int_valid_in;
        exception_valid_out <= exception_valid_in;
        if_vaddr_out    <= if_vaddr_in;
        ale_vaddr_out   <= ale_vaddr_in;

    end else if (!valid) begin
        wb_wdata_out    <= 32'b0;
        pc_out          <= 32'b0;
        wb_reg_addr_out <= 5'b0;
        wb_op_out       <= 1'b0;
        csr_op_out      <= {`CSR_OP_NUM{1'b0}};
        csr_num_out     <= 12'b0;
        csr_wmask_out   <= 32'b0;
        csr_wvalue_out  <= 32'b0;
        wb_src_op_out   <= {`WB_SRC_NUM{1'b0}};
        ertn_op_out     <= 1'b0;
        sys_valid_out   <= 1'b0;
        brk_valid_out   <= 1'b0;
        ine_valid_out   <= 1'b0;
        adef_valid_out  <= 1'b0;
        ale_valid_out   <= 1'b0;
        int_valid_out   <= 1'b0;
        exception_valid_out <= 1'b0;
        if_vaddr_out    <= 32'b0;
        ale_vaddr_out   <= 32'b0;

    end else begin
        wb_wdata_out    <= wb_wdata_out;
        pc_out          <= pc_out;
        wb_reg_addr_out <= wb_reg_addr_out;
        wb_op_out       <= wb_op_out;
        csr_op_out      <= csr_op_out;
        csr_num_out     <= csr_num_out;
        csr_wmask_out   <= csr_wmask_out;
        csr_wvalue_out  <= csr_wvalue_out;
        wb_src_op_out   <= wb_src_op_out;
        ertn_op_out     <= ertn_op_out;
        sys_valid_out   <= sys_valid_out;
        brk_valid_out   <= brk_valid_out;
        ine_valid_out   <= ine_valid_out;
        adef_valid_out  <= adef_valid_out;
        ale_valid_out   <= ale_valid_out;
        int_valid_out   <= int_valid_out;
        exception_valid_out <= exception_valid_out;
        if_vaddr_out    <= if_vaddr_out;
        ale_vaddr_out   <= ale_vaddr_out;

    end
end

endmodule
