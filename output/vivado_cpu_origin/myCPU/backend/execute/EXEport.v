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
    input wire                    stall,

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
    
    input wire  [`CSR_OP_NUM-1:0] csr_op_in,
    input wire  [11:0]            csr_num_in,
    input wire  [31:0]            csr_wmask_in,
    input wire  [31:0]            csr_wvalue_in,
    input wire  [31:0]            csr_rvalue_from_csr,
    input wire  [31:0]            csr_tid_from_csr, // 从CSR模块读出的tid值
    input wire  [`WB_SRC_NUM-1:0] wb_src_op_in, // 写回数据来源选择
    
    input wire                    ertn_op_in,
    input wire                    sys_valid_in,
    input wire                    brk_valid_in,
    input wire                    ine_valid_in,
    input wire                    adef_valid_in, // 送 ID_EXE_reg 的指令地址未对齐异常信号
    input wire                    int_valid_in,  // 送 ID_EXE_reg 的中断有效信号
    input wire                    exception_valid_in, // 送 ID_EXE_reg 的指令异常
    input wire  [31:0]            if_vaddr_in,   // 送 ID_EXE_reg 的访存虚地址（目前仅 adef_valid 时有效，用于数据异常处理模块）

    output wire                   readyGo,
    output wire                   allowIn,

    output wire                   br_taken,

    output wire [31:0]            exe_alu_or_addr_or_cnt, //cnt读出的数据共享这个数据通路
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
    output wire [ 3:0]            data_wbyte_en_from_EXE,
    output wire [`CSR_OP_NUM-1:0] csr_op_out,
    output wire [11:0]            csr_num_out,
    output wire [31:0]            csr_wmask_out,
    output wire [31:0]            csr_wvalue_out,
    output wire [`WB_SRC_NUM-1:0] wb_src_op_out,
    output wire                   ertn_op_out,
    output wire                   sys_valid_out,
    output wire                   brk_valid_out,
    output wire                   ine_valid_out,
    output wire                   adef_valid_out,    // 送 MEM 的指令地址未对齐异常信号
    output wire                   ale_valid_out,     //地址非对齐，送往MEM与WB
    output wire                   int_valid_out,     // 送 MEM 的中断有效信号
    output wire                   exception_valid_out, // 送 MEM 的指令异常有效信号（非法指令、系统调用、断点等）
    output wire [31:0]            if_vaddr_out, // 送往MEM的访存虚地址（目前仅 adef_valid_out 时有效，用于数据异常处理模块）
    output wire [31:0]            ale_vaddr_out // ALE的虚地址，区分于ADEF
);

wire [31:0] alu_result_w;           // ALU 组合结果
wire        alu_result_valid_w;     // 多周期指令完成
wire        br_taken_w;             // 组合分支条件满足
wire [31:0] br_target_w;            // EXE 级分支目标
wire [31:0] seq_target_w;           // EXE 级顺序目标（pc+4）
wire        br_to_seq_w;            // 分支目标与顺序目标相同（无需重定向）
wire [31:0] link_pc4_w;             // jirl/bl 链路：pc+4

wire [ 7:0] w_byte_data;            // 写一个字节的数据
wire [15:0] w_half_data;
wire [31:0] w_word_data;
wire [31:0] wdata_2bram;            // 对齐到字宽后的写数据

wire addr_error;
wire int_valid_w;
wire exception_valid_w;

wire [63:0] cnt_full;

clk_count64bit u_clk_count64bit(
    .clk             (clk),
    .reset           (reset),
    .clk_count_64    (cnt_full)
);

wire [31:0] cnt_low = cnt_full[31:0];
wire [31:0] cnt_high = cnt_full[63:32];


assign addr_error = (mem_op_in[`MEM_OP_LD_H] || mem_op_in[`MEM_OP_ST_H] || mem_op_in[`MEM_OP_LD_HU]) && (alu_result_w[0] != 1'b0)
                   || (mem_op_in[`MEM_OP_LD_W] || mem_op_in[`MEM_OP_ST_W]) && (alu_result_w[1:0] != 2'b00);

assign int_valid_w = int_valid_in;
assign exception_valid_w = exception_valid_in || (addr_error && valid);

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


assign br_taken_w = (((br_op[`BR_OP_BEQ]  == 1'b1) && (alu_src1 == alu_src2))
                  || ((br_op[`BR_OP_BNE]  == 1'b1) && (alu_src1 != alu_src2))
                  || ((br_op[`BR_OP_BLT]  == 1'b1) && ($signed(alu_src1) < $signed(alu_src2)))
                  || ((br_op[`BR_OP_BGE]  == 1'b1) && ($signed(alu_src1) >= $signed(alu_src2)))
                  || ((br_op[`BR_OP_BLTU] == 1'b1) && (alu_src1 < alu_src2))
                  || ((br_op[`BR_OP_BGEU] == 1'b1) && (alu_src1 >= alu_src2))
                  ||  (br_op[`BR_OP_JIRL] == 1'b1)
                  ||  (br_op[`BR_OP_BL]   == 1'b1)
                  ||  (br_op[`BR_OP_B]    == 1'b1));

assign seq_target_w = pc_in + 32'd4;
assign br_target_w  = br_op[`BR_OP_JIRL] ? (alu_src1 + br_imm) : (pc_in + br_imm);
assign br_to_seq_w  = (br_target_w == seq_target_w);

assign readyGo       = !valid || alu_result_valid_w || ~(|alu_op);
/** 
* readyGo 赋值解释：
*(1) !valid：本级无有效槽 → 不必等 ALU，当作「可推进」。
*(2) alu_result_valid_w：多周期 ALU（乘除）完成。
*(3) ~(|alu_op)：alu_op 全 0 → 无 ALU 操作（例如纯分支/泡）→ 不需要等 ALU。
*/
assign allowIn       = 1'b1;

assign br_taken        = valid && !stall && br_taken_w && !br_to_seq_w;
assign link_pc4_w      = pc_in + 32'd4;

assign  exe_alu_or_addr_or_cnt = !valid ? 32'b0 :
                                stall ? 32'b0 :
                                (br_op[`BR_OP_JIRL] || br_op[`BR_OP_BL]) ? link_pc4_w :
                                (wb_src_op_in[`WB_SRC_CSR])   ? csr_rvalue_from_csr :
                                (wb_src_op_in[`WB_SRC_CNTVL]) ? cnt_low :
                                (wb_src_op_in[`WB_SRC_CNTVH]) ? cnt_high :
                                (wb_src_op_in[`WB_SRC_TID])   ? csr_tid_from_csr :
                                alu_result_valid_w            ? alu_result_w : 32'b0;
                                
assign  pc_out          = valid ? !stall ? pc_in : 32'b0 : 32'b0;
assign  wb_reg_addr_out = valid && !exception_valid_w ? !stall ? wb_reg_addr : 5'b0 : 5'b0;
assign  mem_op          = valid && !exception_valid_w ? !stall ? mem_op_in : {`MEM_OP_NUM{1'b0}} : {`MEM_OP_NUM{1'b0}};
assign  mem_wdata_out   = valid && !exception_valid_w ? !stall ? mem_wdata_in : 32'b0 : 32'b0;
assign  wb_op           = valid && !exception_valid_w ? !stall ? wb_op_in : 1'b0 : 1'b0;

assign data_we_from_EXE = (valid && !exception_valid_w) ? 
                        (!stall ? (mem_op[`MEM_OP_ST_W] | mem_op[`MEM_OP_ST_B] | mem_op[`MEM_OP_ST_H]) : 1'b0 )
                        : 1'b0;
assign data_re_from_EXE = (valid && !exception_valid_w) ? 
                        (!stall ? (mem_op[`MEM_OP_LD_W] | mem_op[`MEM_OP_LD_H] | mem_op[`MEM_OP_LD_B] | mem_op[`MEM_OP_LD_HU] | mem_op[`MEM_OP_LD_BU]) : 1'b0 )
                        : 1'b0;
     

assign data_raddr_from_EXE = (valid && !exception_valid_w) ?
                            (!stall ? alu_result_w : 32'b0)
                            : 32'b0;
assign data_waddr_from_EXE = (valid && !exception_valid_w) ?
                            (!stall ? alu_result_w : 32'b0)
                             : 32'b0;
assign data_wdata_from_EXE = (valid && !exception_valid_w) ? 
                            (!stall ? wdata_2bram : 32'b0) 
                            : 32'b0;

assign data_wbyte_en_from_EXE = (valid && !exception_valid_w) ? (!stall ? ((mem_op[`MEM_OP_ST_W]) ? 4'b1111 :
                                    (mem_op[`MEM_OP_ST_H]) ? ((alu_result_w[1] ? 4'b1100 : 4'b0011)) :
                                    (mem_op[`MEM_OP_ST_B]) ? (4'b0001 << alu_result_w[1:0]) : 4'b0000) : 4'b0000) : 4'b0000;

assign csr_op_out = valid ? (!stall ? csr_op_in : {`CSR_OP_NUM{1'b0}}) : {`CSR_OP_NUM{1'b0}};
assign csr_num_out = valid ? !stall ? csr_num_in : 12'b0 : 12'b0;
assign csr_wmask_out = valid ? !stall ? csr_wmask_in : 32'b0 : 32'b0;
assign csr_wvalue_out = valid ? !stall ? csr_wvalue_in : 32'b0 : 32'b0;
assign wb_src_op_out = valid ? !stall ? wb_src_op_in : {`WB_SRC_NUM{1'b0}} : {`WB_SRC_NUM{1'b0}};
assign ertn_op_out = valid ? !stall ? ertn_op_in : 1'b0 : 1'b0;
assign sys_valid_out = valid ? !stall ? sys_valid_in : 1'b0 : 1'b0;
assign brk_valid_out = valid ? !stall ? brk_valid_in : 1'b0 : 1'b0;
assign ine_valid_out = valid ? !stall ? ine_valid_in : 1'b0 : 1'b0;
assign adef_valid_out = valid ? !stall ? adef_valid_in : 1'b0 : 1'b0;
assign int_valid_out = valid ? !stall ? int_valid_in : 1'b0 : 1'b0;
assign ale_valid_out = valid ? !stall ? addr_error : 1'b0 : 1'b0;
assign exception_valid_out = valid ? !stall ? exception_valid_w : 1'b0 : 1'b0;
assign if_vaddr_out = valid && adef_valid_in ? !stall ? if_vaddr_in : 32'b0 : 32'b0;
assign ale_vaddr_out = valid && ale_valid_out ? (!stall ? alu_result_w : 32'b0) : 32'b0;





endmodule
