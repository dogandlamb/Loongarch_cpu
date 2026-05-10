`include "../top/cpu_defs.vh"

// ============================================================
// ID_EXE_reg：ID 与 EXE 间流水寄存器。
// ============================================================
module ID_EXE_reg (
    input  wire                     clk,
    input  wire                     reset,
    input  wire                     cancel_sig,
    input  wire                     valid,
    input  wire                     readyGo,
    input  wire                     allowIn,

    input wire  [4:0]               wb_reg_addr_in,   // 目的寄存器地址
    input wire  [31:0]              alu_src1_in,
    input wire  [31:0]              alu_src2_in,
    input wire  [31:0]              br_imm_in,
    input wire  [31:0]              pc_in,
    input wire  [`ALU_OP_NUM-1:0]   alu_op_in,
    input wire  [`BR_OP_NUM-1:0]    br_op_in,
    input wire  [31:0]              mem_wdata_in,
    input wire  [`MEM_OP_NUM-1:0]   mem_op_in,
    input wire                      wb_op_in,
    input wire  [`CSR_OP_NUM-1:0]   csr_op_in,
    input wire  [11:0]              csr_num_in,
    input wire  [31:0]              csr_wmask_in,
    input wire  [31:0]              csr_wvalue_in,
    input wire  [`WB_SRC_NUM-1:0]   wb_src_op_in,

    input wire  [`TLB_OP_NUM-1:0]   tlb_op_in,
    input wire  [9:0]               invtlb_asid_in,
    input wire  [18:0]              invtlb_vpn_in,

    input wire                      ertn_op_in,
    input wire                      sys_valid_in,
    input wire                      brk_valid_in,
    input wire                      ine_valid_in,
    input wire                      adef_valid_in,      // 送 ID_EXE_reg 的指令地址未对齐异常信号
    input wire                      int_valid_in,       // 送 ID_EXE_reg 的中断有效信号
    input wire                      exception_valid_in, // 送 ID_EXE_reg 的指令异常有效信号（非法指令、系统调用、断点等）
    input wire  [`TLB_EX_NUM-1:0]   tlb_ex_valid_in,
    input wire  [31:0]              if_vaddr_in,
    input wire  [31:0]              tlb_vaddr_in,
    
    input wire  [`CACHE_OP_NUM-1:0] cache_op_valid_in,
    input wire  [1:0]               cache_cacop_op_in,
    input wire  [31:0]              cache_cacop_addr_in,
    input wire  [1:0]               cache_cacop_mat_in,
    input wire  [4:0]               cache_cacop_cd_in,
    input wire                      refetch_tag_in,

    output reg  [`CACHE_OP_NUM-1:0] cache_op_valid_out,
    output reg  [1:0]               cache_cacop_op_out,
    output reg  [31:0]              cache_cacop_addr_out,
    output reg  [1:0]               cache_cacop_mat_out,
    output reg  [4:0]               cache_cacop_cd_out,
    output reg                      refetch_tag_out,

    output reg  [4:0]               wb_reg_addr_out,
    output reg  [31:0]              alu_src1_out,
    output reg  [31:0]              alu_src2_out,
    output reg  [31:0]              br_imm_out,
    output reg  [31:0]              pc_out,
    output reg  [`ALU_OP_NUM-1:0]   alu_op_out,
    output reg  [31:0]              mem_wdata_out,
    output reg  [`BR_OP_NUM-1:0]    br_op_out,
    output reg  [`MEM_OP_NUM-1:0]   mem_op_out,
    output reg                      wb_op_out,
    output reg  [`CSR_OP_NUM-1:0]   csr_op_out,
    output reg  [11:0]              csr_num_out,
    output reg  [31:0]              csr_wmask_out,
    output reg  [31:0]              csr_wvalue_out,
    output reg  [`WB_SRC_NUM-1:0]   wb_src_op_out,

    output reg  [`TLB_OP_NUM-1:0]   tlb_op_out,
    output reg  [9:0]               invtlb_asid_out,
    output reg  [18:0]              invtlb_vpn_out,

    output reg                      ertn_op_out,
    output reg                      sys_valid_out,
    output reg                      brk_valid_out,
    output reg                      ine_valid_out,
    output reg                      adef_valid_out,      // 送 EXE 的指令地址未对齐异常信号
    output reg  [31:0]              if_vaddr_out,        // 送 EXE 的访存虚地址（目前仅 adef_valid 时有效，用于数据异常处理模块）
    output reg                      int_valid_out,       // 送 EXE 的中断有效信号
    output reg                      exception_valid_out, // 送 EXE 的指令异常有效信号（非法指令、系统调用、断点等）

    output reg  [`TLB_EX_NUM-1:0]   tlb_ex_valid_out,
    output reg  [31:0]              tlb_vaddr_out
);  

    always @(posedge clk) begin
        // 复位或cancel信号：清空
        if(reset || cancel_sig) begin
            wb_reg_addr_out   <= 5'h0;
            alu_src1_out      <= 32'h0;
            alu_src2_out      <= 32'h0;
            br_imm_out        <= 32'h0;
            pc_out            <= 32'h0;
            alu_op_out        <= {`ALU_OP_NUM{1'b0}};
            mem_wdata_out     <= 32'b0;
            br_op_out         <= {`BR_OP_NUM{1'b0}};
            mem_op_out        <= {`MEM_OP_NUM{1'b0}};
            wb_op_out         <= 1'h0;
            csr_op_out     <= {`CSR_OP_NUM{1'b0}};
            csr_num_out    <= 12'b0;
            csr_wmask_out  <= 32'b0;
            csr_wvalue_out <= 32'b0;
            wb_src_op_out  <= {`WB_SRC_NUM{1'b0}};
            ertn_op_out    <= 1'b0;
            sys_valid_out     <= 1'b0;
            brk_valid_out     <= 1'b0;
            ine_valid_out     <= 1'b0;
            adef_valid_out   <= 1'b0;
            int_valid_out    <= 1'b0;
            exception_valid_out <= 1'b0;
            if_vaddr_out     <= 32'b0;
            tlb_op_out       <= {`TLB_OP_NUM{1'b0}};
            invtlb_asid_out  <= 10'b0;
            invtlb_vpn_out   <= 19'b0;
            tlb_ex_valid_out <= {`TLB_EX_NUM{1'b0}};
            tlb_vaddr_out    <= 32'b0;
            cache_op_valid_out    <= {`CACHE_OP_NUM{1'b0}};
            cache_cacop_op_out    <= 2'b0;
            cache_cacop_addr_out  <= 32'b0;
            cache_cacop_mat_out   <= 2'b0;
            cache_cacop_cd_out    <= 5'b0;
            refetch_tag_out       <= 1'b0;
        end
    
        // 握手成功：在流水级寄存器锁存 ID 输出，推进到 EXE
        else if(valid && readyGo && allowIn) begin
            wb_reg_addr_out   <= wb_reg_addr_in;
            alu_src1_out      <= alu_src1_in;
            alu_src2_out      <= alu_src2_in;
            br_imm_out        <= br_imm_in;
            pc_out            <= pc_in;
            alu_op_out        <= alu_op_in;
            mem_wdata_out     <= mem_wdata_in;
            br_op_out         <= br_op_in;
            mem_op_out        <= mem_op_in;
            wb_op_out         <= wb_op_in;
            csr_op_out     <= csr_op_in;
            csr_num_out    <= csr_num_in;
            csr_wmask_out  <= csr_wmask_in;
            csr_wvalue_out <= csr_wvalue_in;
            wb_src_op_out  <= wb_src_op_in;
            ertn_op_out    <= ertn_op_in;
            sys_valid_out     <= sys_valid_in;
            brk_valid_out     <= brk_valid_in;
            ine_valid_out     <= ine_valid_in;
            adef_valid_out   <= adef_valid_in;
            int_valid_out    <= int_valid_in;
            exception_valid_out <= exception_valid_in;
            if_vaddr_out     <= if_vaddr_in;
            tlb_op_out       <= tlb_op_in;
            invtlb_asid_out  <= invtlb_asid_in;
            invtlb_vpn_out   <= invtlb_vpn_in;
            tlb_ex_valid_out <= tlb_ex_valid_in;
            tlb_vaddr_out    <= tlb_vaddr_in;
            cache_op_valid_out    <= cache_op_valid_in;
            cache_cacop_op_out    <= cache_cacop_op_in;
            cache_cacop_addr_out  <= cache_cacop_addr_in;
            cache_cacop_mat_out   <= cache_cacop_mat_in;
            cache_cacop_cd_out    <= cache_cacop_cd_in;
            refetch_tag_out       <= refetch_tag_in;
        end
    
        // 上游无效且本级可接收新槽：清空。
        // 若下游反压(allowIn=0)，必须保持当前槽，避免丢失在途指令。
        else if(!valid && allowIn) begin
            wb_reg_addr_out  <= 5'h0;
            alu_src1_out     <= 32'h0;
            alu_src2_out     <= 32'h0;
            br_imm_out       <= 32'h0;
            pc_out           <= 32'h0;
            alu_op_out       <= {`ALU_OP_NUM{1'b0}};
            mem_wdata_out    <= 32'b0;
            br_op_out        <= {`BR_OP_NUM{1'b0}};
            mem_op_out       <= {`MEM_OP_NUM{1'b0}};
            wb_op_out        <= 1'h0;
            csr_op_out     <= {`CSR_OP_NUM{1'b0}};
            csr_num_out    <= 12'b0;
            csr_wmask_out  <= 32'b0;
            csr_wvalue_out <= 32'b0;
            wb_src_op_out  <= {`WB_SRC_NUM{1'b0}};
            ertn_op_out    <= 1'b0;
            sys_valid_out     <= 1'b0;
            brk_valid_out     <= 1'b0;
            ine_valid_out     <= 1'b0;
            adef_valid_out   <= 1'b0;
            int_valid_out    <= 1'b0;
            exception_valid_out <= 1'b0;
            if_vaddr_out     <= 32'b0;
            tlb_op_out       <= {`TLB_OP_NUM{1'b0}};
            invtlb_asid_out  <= 10'b0;
            invtlb_vpn_out   <= 19'b0;
            tlb_ex_valid_out <= {`TLB_EX_NUM{1'b0}};
            tlb_vaddr_out    <= 32'b0;
            cache_op_valid_out    <= {`CACHE_OP_NUM{1'b0}};
            cache_cacop_op_out    <= 2'b0;
            cache_cacop_addr_out  <= 32'b0;
            cache_cacop_mat_out   <= 2'b0;
            cache_cacop_cd_out    <= 5'b0;
            refetch_tag_out       <= 1'b0;
        end
    
        // 下游反压（即readyGo为0）或ID未就绪（即allowIn为0）：保持当前值
        else if(!readyGo | !allowIn) begin
            wb_reg_addr_out  <= wb_reg_addr_out;
            alu_src1_out     <= alu_src1_out;
            alu_src2_out     <= alu_src2_out;
            br_imm_out       <= br_imm_out;
            pc_out           <= pc_out;
            alu_op_out       <= alu_op_out;
            mem_wdata_out    <= mem_wdata_out;
            br_op_out        <= br_op_out;
            mem_op_out       <= mem_op_out;
            wb_op_out        <= wb_op_out;
            csr_op_out       <= csr_op_out;
            csr_num_out      <= csr_num_out;
            csr_wmask_out    <= csr_wmask_out;
            csr_wvalue_out   <= csr_wvalue_out;
            wb_src_op_out    <= wb_src_op_out;
            ertn_op_out      <= ertn_op_out;
            sys_valid_out    <= sys_valid_out;
            brk_valid_out    <= brk_valid_out;
            ine_valid_out    <= ine_valid_out;
            adef_valid_out   <= adef_valid_out;
            int_valid_out    <= int_valid_out;
            exception_valid_out <= exception_valid_out;
            if_vaddr_out     <= if_vaddr_out;
            tlb_op_out       <= tlb_op_out;
            invtlb_asid_out  <= invtlb_asid_out;
            invtlb_vpn_out   <= invtlb_vpn_out;
            tlb_ex_valid_out <= tlb_ex_valid_out;
            tlb_vaddr_out    <= tlb_vaddr_out;
            cache_op_valid_out    <= cache_op_valid_out;
            cache_cacop_op_out    <= cache_cacop_op_out;
            cache_cacop_addr_out  <= cache_cacop_addr_out;
            cache_cacop_mat_out   <= cache_cacop_mat_out;
            cache_cacop_cd_out    <= cache_cacop_cd_out;
            refetch_tag_out       <= refetch_tag_out;
        end
    
        // 兜底分支：就是else，没啥
        else begin
            wb_reg_addr_out  <= 5'h0;
            alu_src1_out     <= 32'h0;
            alu_src2_out     <= 32'h0;
            br_imm_out       <= 32'h0;
            pc_out           <= 32'h0;
            alu_op_out       <= {`ALU_OP_NUM{1'b0}};
            mem_wdata_out    <= 32'h0;
            br_op_out        <= {`BR_OP_NUM{1'b0}};
            mem_op_out       <= {`MEM_OP_NUM{1'b0}};
            wb_op_out        <= 1'h0;
            csr_op_out       <= {`CSR_OP_NUM{1'b0}};
            csr_num_out      <= 12'b0;
            csr_wmask_out    <= 32'b0;
            csr_wvalue_out   <= 32'b0;
            wb_src_op_out    <= {`WB_SRC_NUM{1'b0}};
            ertn_op_out      <= 1'b0;
            sys_valid_out    <= 1'b0;
            brk_valid_out    <= 1'b0;
            ine_valid_out    <= 1'b0;
            adef_valid_out   <= 1'b0;
            int_valid_out    <= 1'b0;
            exception_valid_out <= 1'b0;
            if_vaddr_out     <= 32'b0;
            tlb_op_out       <= {`TLB_OP_NUM{1'b0}};
            invtlb_asid_out  <= 10'b0;
            invtlb_vpn_out   <= 19'b0;
            tlb_ex_valid_out <= {`TLB_EX_NUM{1'b0}};
            tlb_vaddr_out    <= 32'b0;
            cache_op_valid_out    <= {`CACHE_OP_NUM{1'b0}};
            cache_cacop_op_out    <= 2'b0;
            cache_cacop_addr_out  <= 32'b0;
            cache_cacop_mat_out   <= 2'b0;
            cache_cacop_cd_out    <= 5'b0;
            refetch_tag_out       <= 1'b0;
        end
    end


endmodule