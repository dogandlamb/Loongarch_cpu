`include "../top/cpu_defs.vh"

// ============================================================
// WBport：写回级组合逻辑。负责将 MEM/WB 结果映射为：
// - regfile/debug 写回端口；
// - CSR 异常提交端口（异常类型、vaddr、TLB/维护信息等）。
// 该模块保持组合透传与筛选，不引入新的时序状态。
// ============================================================
module WBport (
    // input
    // 基本控制
    input  wire                     reset,                // 同步高有效复位
    input  wire                     valid,                // WB 槽有效

    // 写回主通路输入
    input  wire [31:0]              wb_wdata_in,          // 写回数据
    input  wire [31:0]              pc_in,                // 提交 PC（debug/CSR）
    input  wire [ 4:0]              wb_reg_addr_in,       // 写回目的寄存器号
    input  wire                     wb_op_in,             // 写回使能
    input  wire [`WB_SRC_NUM-1:0]   wb_src_op_in,         // 写回数据来源选择

    // CSR/TLB 控制输入
    input  wire [`CSR_OP_NUM-1:0]   csr_op_in,
    input  wire [11:0]              csr_num_in,
    input  wire [31:0]              csr_wmask_in,
    input  wire [31:0]              csr_wvalue_in,
    input  wire [`TLB_OP_NUM-1:0]   tlb_op_in,
    input  wire [9:0]               invtlb_asid_in,
    input  wire [18:0]              invtlb_vpn_in,
    input  wire [`TLB_EX_NUM-1:0]   tlb_ex_valid_in,
    input  wire [31:0]              tlb_vaddr_in,

    // cache 维护与 refetch 输入
    input  wire [`CACHE_OP_NUM-1:0] cache_op_valid_in,
    input  wire [1:0]               cache_cacop_op_in,
    input  wire [31:0]              cache_cacop_addr_in,
    input  wire [1:0]               cache_cacop_mat_in,
    input  wire [4:0]               cache_cacop_cd_in,
    input  wire                     refetch_tag_in,

    // 异常元信息输入
    input  wire                     ertn_op_in,
    input  wire                     sys_valid_in,
    input  wire                     brk_valid_in,
    input  wire                     ine_valid_in,
    input  wire                     adef_valid_in,
    input  wire                     int_valid_in,
    input  wire                     ale_valid_in,
    input  wire                     exception_valid_in,
    input  wire [31:0]              if_vaddr_in,
    input  wire [31:0]              ale_vaddr_in,         // ALE 对应虚地址


    // output
    // 与上游握手
    output wire                     allowIn,              // 对上游允许（当前常 1）

    // regfile/debug 写回输出
    output wire [31:0]              wb_wdata_out,         // 送 regfile 写数据
    output wire [31:0]              pc_out,               // 送 debug/CSR 的提交 PC
    output wire [ 4:0]              wb_reg_addr_out,      // 送 regfile 写地址
    output wire                     wb_op_out,            // 送 regfile 写使能

    // CSR 提交输出
    output wire [`CSR_OP_NUM-1:0]   csr_op_out,
    output wire [11:0]              csr_num_out,
    output wire [31:0]              csr_wmask_out,
    output wire [31:0]              csr_wvalue_out,
    output wire [`TLB_OP_NUM-1:0]   tlb_op_out,
    output wire [9:0]               invtlb_asid_out,
    output wire [18:0]              invtlb_vpn_out,
    output wire [`TLB_EX_NUM-1:0]   tlb_ex_valid_out_2csr,
    output wire [31:0]              wb_vaddr_out,
    output wire                     wb_ex_2csr,           // 本 WB 槽是否异常提交
    output wire                     wb_valid_2csr,        // 本 WB 槽是否有效提交
    output wire                     wb_is_ertn_2csr,      // 本 WB 槽是否 ERTN
    output wire                     int_valid_out_2csr,
    output wire                     adef_valid_out_2csr,
    output wire                     ale_valid_out_2csr,
    output wire                     sys_valid_out_2csr,
    output wire                     brk_valid_out_2csr,
    output wire                     ine_valid_out_2csr,

    // cache 维护与 refetch 透传
    output wire [`CACHE_OP_NUM-1:0] cache_op_valid_out,
    output wire [1:0]               cache_cacop_op_out,
    output wire [31:0]              cache_cacop_addr_out,
    output wire [1:0]               cache_cacop_mat_out,
    output wire [4:0]               cache_cacop_cd_out,
    output wire                     refetch_tag_out
);

    // 仅 refetch + 非零 tlb_op + GPR 写：误复用 TLBRD 等维护槽的「假写回」；普通 load/ALU（tlb_op=0）不因 refetch 被抹掉。
    wire any_tlb_op_wbref = (tlb_op_in[0] === 1'b1) | (tlb_op_in[1] === 1'b1) | (tlb_op_in[2] === 1'b1)
                          | (tlb_op_in[3] === 1'b1) | (tlb_op_in[4] === 1'b1) | (tlb_op_in[5] === 1'b1)
                          | (tlb_op_in[6] === 1'b1) | (tlb_op_in[7] === 1'b1) | (tlb_op_in[8] === 1'b1)
                          | (tlb_op_in[9] === 1'b1) | (tlb_op_in[10] === 1'b1);
    wire wb_refetch_squash = (refetch_tag_in === 1'b1)
        && any_tlb_op_wbref
        && (wb_op_in === 1'b1);
    wire wb_valid = (valid === 1'b1) && !wb_refetch_squash;
    wire exception_valid_w;
    assign exception_valid_w = (exception_valid_in === 1'b1);
    wire wb_we;
    assign wb_we = (wb_op_in === 1'b1) && (exception_valid_w !== 1'b1) && (valid === 1'b1);

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
    wire tlb_ex_any_wb = (tlb_ex_valid_in[0] === 1'b1) | (tlb_ex_valid_in[1] === 1'b1) | (tlb_ex_valid_in[2] === 1'b1)
                       | (tlb_ex_valid_in[3] === 1'b1) | (tlb_ex_valid_in[4] === 1'b1) | (tlb_ex_valid_in[5] === 1'b1);
    assign wb_vaddr_out = (reset || !wb_valid) ? 32'b0
                        : (tlb_ex_any_wb ? tlb_vaddr_in
                        :  (adef_valid_in ? if_vaddr_in : (ale_valid_in ? ale_vaddr_in : 32'b0)));

    assign tlb_op_out = (reset || !wb_valid) ? {`TLB_OP_NUM{1'b0}} : tlb_op_in;
    assign invtlb_asid_out = (reset || !wb_valid) ? 10'b0 : invtlb_asid_in;
    assign invtlb_vpn_out = (reset || !wb_valid) ? 19'b0 : invtlb_vpn_in;
    assign tlb_ex_valid_out_2csr = (reset || !wb_valid) ? {`TLB_EX_NUM{1'b0}} : tlb_ex_valid_in;

    assign cache_op_valid_out = (reset || !valid) ? {`CACHE_OP_NUM{1'b0}} : cache_op_valid_in;
    assign cache_cacop_op_out = (reset || !valid) ? 2'b0 : cache_cacop_op_in;
    assign cache_cacop_addr_out = (reset || !valid) ? 32'b0 : cache_cacop_addr_in;
    assign cache_cacop_mat_out = (reset || !valid) ? 2'b0 : cache_cacop_mat_in;
    assign cache_cacop_cd_out = (reset || !valid) ? 5'b0 : cache_cacop_cd_in;
    assign refetch_tag_out = (reset || !valid) ? 1'b0 : refetch_tag_in;

endmodule
