module forward_deliver (
    input wire FD_EXE_2rs1_sig,
    input wire FD_MEM_2rs1_sig,
    input wire FD_WB_2rs1_sig,
    input wire FD_EXE_2rs2_sig,
    input wire FD_MEM_2rs2_sig,
    input wire FD_WB_2rs2_sig,
    input wire [31:0] rf_rdata1,
    input wire [31:0] rf_rdata2,
    input wire [31:0] EXE_data,
    input wire [31:0] MEM_data,
    input wire [31:0] WB_data,

    output wire [31:0] ID_src1_rdata,
    output wire [31:0] ID_src2_rdata
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