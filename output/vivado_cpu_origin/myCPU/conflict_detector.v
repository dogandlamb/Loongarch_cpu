module conflict_detector(
    input  wire clk,
    input  wire reset,
    input  wire [ 4:0] alu_src1_addr,
    input  wire [ 4:0] alu_src2_addr,
    input  wire        br_taken,
    input  wire [ 4:0] exe_reg_dest,
    input  wire [ 4:0] mem_reg_dest,
    input  wire [ 4:0] wb_reg_dest,

    output wire        br_conflict,
    output wire        data_conflict_between_ID_EXE,
    output wire        data_conflict_between_ID_MEM,
    output wire        data_conflict_between_ID_WB,
);
//检测是否存在冲突和冲突的类型，只负责检测部分，完全组合逻辑
assign br_conflict = br_taken;
assign data_conflict_between_ID_EXE = (alu_src1_addr == exe_reg_dest) | (alu_src2_addr == exe_reg_dest);
assign data_conflict_between_ID_MEM = (alu_src1_addr == mem_reg_dest) | (alu_src2_addr == mem_reg_dest);
assign data_conflict_between_ID_WB  = (alu_src1_addr == wb_reg_dest ) | (alu_src2_addr == wb_reg_dest );
endmodule