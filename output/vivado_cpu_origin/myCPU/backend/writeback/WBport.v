`include "../../common/cpu_defs.vh"

// ============================================================
// WBport：写回级组合逻辑。valid 且非复位时透传 MEM_WB_reg 输出到 regfile；
// ============================================================
module WBport (
    input  wire                     reset,            // 同步高有效复位
    input  wire                     valid,            // WB 槽有效

    input  wire [31:0]              wb_wdata_in,      // 写回数据
    input  wire [31:0]              pc_in,            // 用以提交 PC（调试）
    input  wire [ 4:0]              wb_reg_addr_in,   // 写回的目的寄存器号
    input  wire                     wb_op_in,         // 写回指令使能，即wb_we = wb_op_in
    input  wire  [`CSR_OP_NUM-1:0] csr_op_in,
    input  wire  [11:0]            csr_num_in,
    input  wire  [31:0]            csr_wmask_in,
    input  wire  [31:0]            csr_wvalue_in,
     
    input  wire  [`WB_SRC_NUM-1:0] wb_src_op_in, // 写回数据来源选择

    input  wire  [`TLB_OP_NUM-1:0] tlb_op_in,
    input  wire  [9:0]             invtlb_asid_in,
    input  wire  [18:0]            invtlb_vpn_in,

    input wire  [`CACHE_OP_NUM-1:0] cache_op_valid_in,
    input wire  [1:0]             cache_cacop_op_in,
    input wire  [31:0]            cache_cacop_addr_in,
    input wire  [1:0]             cache_cacop_mat_in,
    input wire  [4:0]             cache_cacop_cd_in,
    input wire                    refetch_tag_in,

    input  wire                    ertn_op_in,
    input  wire                    sys_valid_in,
    input  wire                    brk_valid_in,
    input  wire                    ine_valid_in,
    input  wire                    adef_valid_in,
    input  wire                    int_valid_in,
    input  wire                    ale_valid_in,
    input  wire                    exception_valid_in,
    input  wire  [31:0]            if_vaddr_in,   
    input  wire  [31:0]            ale_vaddr_in,   // 地址错误异常的虚地址
    
    input  wire  [`TLB_EX_NUM-1:0] tlb_ex_valid_in,
    input  wire  [31:0]            tlb_vaddr_in,


    output wire        allowIn,          // 对上游允许写入（一直为1）

    output wire [31:0] wb_wdata_out,     // 送 regfile 的写数据
    output wire [31:0] pc_out,           // 送 debug 的 PC,也送给csr模块用于记录异常发生时的PC
    output wire [ 4:0] wb_reg_addr_out,  // 送 regfile 的写地址
    output wire        wb_op_out,        // 送 regfile 的写使能

    // to CSR
    output wire  [`CSR_OP_NUM-1:0] csr_op_out,
    output wire  [11:0]            csr_num_out,
    output wire  [31:0]            csr_wmask_out,
    output wire  [31:0]            csr_wvalue_out,

    output wire  [`TLB_OP_NUM-1:0] tlb_op_out,
    output wire  [9:0]             invtlb_asid_out,
    output wire  [18:0]            invtlb_vpn_out,
    output wire  [`TLB_EX_NUM-1:0] tlb_ex_valid_out_2csr,
    output wire  [31:0]            wb_vaddr_out,

    output wire                    wb_ex_2csr,           // 写回阶段指令是否发生异常（送 CSR 模块用于记录异常类型）
    output wire                    wb_valid_2csr,        // 写回阶段指令是否有效（送 CSR 模块用于记录异常发生时的 PC 和指令地址）
    output wire                    wb_is_ertn_2csr,      // 写回阶段指令是否是 ERTN（送 CSR 模块用于判断是否需要从 EPC 恢复 PC）
    output wire                    int_valid_out_2csr,     // 写回阶段指令是否是有效的中断（送 CSR 模块用于记录中断发生时的 PC 和指令地址）
    output wire                    adef_valid_out_2csr,    // 写回阶段指令是否是有效的地址异常（送 CSR 模块用于记录地址异常发生时的 PC 和指令地址）
    output wire                    ale_valid_out_2csr,     // 写回阶段指令是否是有效的地址错误异常（送 CSR 模块用于记录地址错误异常发生时的 PC 和指令地址）
    output wire                    sys_valid_out_2csr,     // 写回阶段指令是否是有效的系统调用（送 CSR 模块用于记录系统调用发生时的 PC 和指令地址）
    output wire                    brk_valid_out_2csr,     // 写回阶段指令是否是有效的断点（送 CSR 模块用于记录断点发生时的 PC 和指令地址）
    output wire                    ine_valid_out_2csr     // 写回阶段指令是否是有效的非法指令（送 CSR 模块用于记录非法指令发生时的 PC 和指令地址）
    
    output wire  [`CACHE_OP_NUM-1:0] cache_op_valid_out,
    output wire  [1:0]             cache_cacop_op_out,
    output wire  [31:0]            cache_cacop_addr_out,
    output wire  [1:0]             cache_cacop_mat_out,
    output wire  [4:0]             cache_cacop_cd_out,
    output wire                    refetch_tag_out
);

wire wb_valid = valid && !refetch_tag_in; // 只有当指令有效且不是 refetch 指令时才真正写回
wire exception_valid_w;
assign exception_valid_w = exception_valid_in;
wire wb_we;
assign wb_we = wb_op_in && !exception_valid_w && valid;

assign allowIn         = 1'b1;
assign wb_wdata_out    = (reset || !wb_valid) ? 32'b0 : wb_wdata_in;
assign pc_out          = (reset || !wb_valid) ? 32'b0 : pc_in;
assign wb_reg_addr_out = (reset || !wb_valid) ? 5'b0  : wb_reg_addr_in;
assign wb_op_out       = (reset || !wb_valid) ? 1'b0  : wb_we;

assign csr_op_out = (reset || !wb_valid) ? {`CSR_OP_NUM{1'b0}} : csr_op_in;
assign csr_num_out = (reset || !wb_valid) ? 12'b0 : csr_num_in;
assign csr_wmask_out = (reset || !wb_valid) ? 32'b0 : csr_wmask_in;
assign csr_wvalue_out = (reset || !wb_valid) ? 32'b0 : csr_wvalue_in;
assign wb_ex_2csr = exception_valid_w && wb_valid;
assign wb_valid_2csr = wb_valid;
assign wb_is_ertn_2csr = ertn_op_in && wb_valid;
assign int_valid_out_2csr = int_valid_in && wb_valid;
assign adef_valid_out_2csr = adef_valid_in && wb_valid;
assign ale_valid_out_2csr = ale_valid_in && wb_valid;
assign sys_valid_out_2csr = sys_valid_in && wb_valid;
assign brk_valid_out_2csr = brk_valid_in && wb_valid;
assign ine_valid_out_2csr = ine_valid_in && wb_valid;
assign wb_vaddr_out = (reset || !wb_valid) ? 32'b0
                    : (adef_valid_in ? if_vaddr_in : (ale_valid_in ? ale_vaddr_in : 32'b0));

assign tlb_op_out = (reset || !wb_valid) ? {`TLB_OP_NUM{1'b0}} : tlb_op_in;
assign invtlb_asid_out = (reset || !wb_valid) ? 10'b0 : invtlb_asid_in;
assign invtlb_vpn_out = (reset || !wb_valid) ? 19'b0 : invtlb_vpn_in;
assign tlb_ex_valid_out_2csr = (reset || !wb_valid) ? {`TLB_EX_NUM{1'b0}} : tlb_ex_valid_in;
assign tlb_vaddr_out = (reset || !wb_valid) ? 32'b0 : tlb_vaddr_in;

assign cache_op_valid_out = (reset || !valid) ? {`CACHE_OP_NUM{1'b0}} : cache_op_valid_in;
assign cache_cacop_op_out = (reset || !valid) ? 2'b0 : cache_cacop_op_in;
assign cache_cacop_addr_out = (reset || !valid) ? 32'b0 : cache_cacop_addr_in;
assign cache_cacop_mat_out = (reset || !valid) ? 2'b0 : cache_cacop_mat_in;
assign cache_cacop_cd_out = (reset || !valid) ? 5'b0 : cache_cacop_cd_in;
assign refetch_tag_out = (reset || !valid) ? 1'b0 : refetch_tag_in;

endmodule
