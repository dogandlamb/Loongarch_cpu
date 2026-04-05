`include "../../common/cpu_defs.vh"

// ============================================================
// EXEport：执行级。例化 alu；组合产生 br_taken、访存字节使能及 BRAM 请求信号。
// 唯一的时序在于alu的乘除法部分
// mul/div 时 readyGo 随 alu_result_valid。
// ============================================================
module EXEport (
    input wire                    clk,    //用于乘除法
    input wire                    reset,  //用于乘除法
    input wire                    valid,

    input wire  [ 4:0]            wb_reg_addr,
    input wire  [31:0]            alu_src1,
    input wire  [31:0]            alu_src2,
    input wire  [31:0]            pc_in,
    input wire  [31:0]            br_imm,
    input wire  [`ALU_OP_NUM-1:0] alu_op,
    input wire  [`BR_OP_NUM-1:0]  br_op,
    input wire  [31:0]            mem_wdata_in, //store 写数据
    input wire  [`MEM_OP_NUM-1:0] mem_op_in,
    input wire                    wb_op_in,

    output wire                   readyGo,
    output wire                   allowIn,

    output wire                   br_taken,

    output wire [31:0]            exe_alu_or_addr,
    output wire [31:0]            pc_out,
    output wire [ 4:0]            wb_reg_addr_out,
    output wire [`MEM_OP_NUM-1:0] mem_op,
    output wire [31:0]            mem_wdata_out,
    output wire                   wb_op,

    output wire                   data_we_from_EXE,
    output wire                   data_re_from_EXE,

    output wire [31:0]            data_raddr_from_EXE,
    output wire [31:0]            data_waddr_from_EXE,
    output wire [31:0]            data_wdata_from_EXE,
    output wire [ 3:0]            data_wbyte_en_from_EXE
);

wire [31:0] alu_result_w;           // ALU 组合结果
wire        alu_result_valid_w;     // 多周期指令完成
wire        br_taken_w;             // 组合分支条件满足
wire [31:0] link_pc4_w;             // jirl/bl 链路：pc+4

wire [ 7:0] w_byte_data;            // 写一个字节的数据
wire [15:0] w_half_data;
wire [31:0] w_word_data;
wire [31:0] wdata_2bram;            // 对齐到字宽后的写数据

assign w_byte_data = mem_wdata_in[7:0];
assign w_half_data = mem_wdata_in[15:0];
assign w_word_data = mem_wdata_in;

assign wdata_2bram = mem_op_in[`MEM_OP_ST_B] ? {4{w_byte_data}} :
                     mem_op_in[`MEM_OP_ST_H] ? {2{w_half_data}} :
                     mem_op_in[`MEM_OP_ST_W] ? w_word_data : 32'b0;



alu u_alu(
    .clk             (clk         ),
    .reset           (reset       ),
    .alu_op     	 (alu_op      ),
    .alu_src1   	 (alu_src1    ),
    .alu_src2   	 (alu_src2    ),
    .alu_result 	 (alu_result_w),
    .alu_result_valid(alu_result_valid_w)
);


assign br_taken_w = (br_op[`BR_OP_BEQ]  && (alu_src1 == alu_src2))
                  | (1'b0 & (|br_imm))
                  | (br_op[`BR_OP_BNE]  && (alu_src1 != alu_src2))
                  | (br_op[`BR_OP_BLT]  && ($signed(alu_src1) < $signed(alu_src2)))
                  | (br_op[`BR_OP_BGE]  && ($signed(alu_src1) >= $signed(alu_src2)))
                  | (br_op[`BR_OP_BLTU] && (alu_src1 < alu_src2))
                  | (br_op[`BR_OP_BGEU] && (alu_src1 >= alu_src2))
                  |  br_op[`BR_OP_JIRL]
                  |  br_op[`BR_OP_BL]
                  |  br_op[`BR_OP_B];

assign readyGo       = !valid || alu_result_valid_w || ~(|alu_op);
/** 
* readyGo 赋值解释：
*(1) !valid：本级无有效槽 → 不必等 ALU，当作「可推进」。
*(2) alu_result_valid_w：多周期 ALU（乘除）完成。
*(3) ~(|alu_op)：alu_op 全 0 → 无 ALU 操作（例如纯分支/泡）→ 不需要等 ALU。
*/
assign allowIn       = 1'b1;

assign br_taken        = valid && br_taken_w;
assign link_pc4_w      = pc_in + 32'd4;

assign  exe_alu_or_addr = valid ? ((br_op[`BR_OP_JIRL] | br_op[`BR_OP_BL]) ? link_pc4_w : alu_result_w) : 32'b0;
assign  pc_out          = valid ? pc_in : 32'b0;
assign  wb_reg_addr_out = valid ? wb_reg_addr : 5'b0;
assign  mem_op          = valid ? mem_op_in : {`MEM_OP_NUM{1'b0}};
assign  mem_wdata_out   = valid ? mem_wdata_in : 32'b0;
assign  wb_op           = valid ? wb_op_in : 1'b0;

assign data_we_from_EXE = valid ? (mem_op[`MEM_OP_ST_W] | mem_op[`MEM_OP_ST_B] | mem_op[`MEM_OP_ST_H]) : 1'b0;
assign data_re_from_EXE = valid ? (mem_op[`MEM_OP_LD_W] | mem_op[`MEM_OP_LD_H] | mem_op[`MEM_OP_LD_B] | mem_op[`MEM_OP_LD_HU] | mem_op[`MEM_OP_LD_BU]) : 1'b0;
     

assign data_raddr_from_EXE = valid ? exe_alu_or_addr : 32'b0;
assign data_waddr_from_EXE = valid ? exe_alu_or_addr : 32'b0;
assign data_wdata_from_EXE = valid ? wdata_2bram : 32'b0;

assign data_wbyte_en_from_EXE = valid ? ((mem_op[`MEM_OP_ST_W]) ? 4'b1111 :
                                    (mem_op[`MEM_OP_ST_H]) ? ((exe_alu_or_addr[1] ? 4'b1100 : 4'b0011)) :
                                    (mem_op[`MEM_OP_ST_B]) ? (4'b0001 << exe_alu_or_addr[1:0]) : 4'b0000) : 4'b0000;
endmodule
