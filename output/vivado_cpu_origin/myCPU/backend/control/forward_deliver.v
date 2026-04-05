// ============================================================
// forward_deliver：ID 级读口数据前递二选一链。
// 优先级 EXE > MEM > WB > regfile；命中信号来自 conflict_handle。
// ============================================================
module forward_deliver (
    input  wire        FD_EXE_2rs1_sig,  // rs1 用 EXE 结果
    input  wire        FD_MEM_2rs1_sig,  // rs1 用 MEM 结果
    input  wire        FD_WB_2rs1_sig,   // rs1 用 WB 结果
    input  wire        FD_EXE_2rs2_sig,  // rs2 同上
    input  wire        FD_MEM_2rs2_sig,
    input  wire        FD_WB_2rs2_sig,
    input  wire [31:0] rf_rdata1,        // regfile 读口1
    input  wire [31:0] rf_rdata2,        // regfile 读口2
    input  wire [31:0] EXE_data,         // EXE 级旁路数据
    input  wire [31:0] MEM_data,         // MEM 级旁路数据
    input  wire [31:0] WB_data,          // WB 级旁路数据

    output wire [31:0] ID_src1_rdata,    // 送 ID 的 src1
    output wire [31:0] ID_src2_rdata     // 送 ID 的 src2
);

assign ID_src1_rdata = FD_EXE_2rs1_sig ? EXE_data :
                       FD_MEM_2rs1_sig ? MEM_data :
                       FD_WB_2rs1_sig  ? WB_data  : 
                       rf_rdata1;

assign ID_src2_rdata = FD_EXE_2rs2_sig ? EXE_data :
                       FD_MEM_2rs2_sig ? MEM_data :
                       FD_WB_2rs2_sig  ? WB_data  : 
                       rf_rdata2;

endmodule
