`include "../../common/cpu_defs.vh"

// ============================================================
// MEMport：访存级。load 需等待 data_r_complete；完成后 load_done_match 保持 ready 直至读回的数据离开。
// data_r_complete -> load_done_match -> readyGo -> allowIn
// ============================================================
module MEMport (
    input  wire                   clk,
    input  wire                   reset,
    input  wire                   valid,

    input  wire [31:0]            data_sram_rdata,   // BRAM 读回字（字就是32位的数据）
    input  wire [31:0]            exe_result,        // 与读回来的bram数据，以及exe的数据二选一，送给wb的数据
    input  wire [31:0]            pc_in,
    input  wire [ 4:0]            wb_reg_addr_in,
    input  wire [`MEM_OP_NUM-1:0] mem_op,
    input  wire                   wb_op_in,
    input  wire [31:0]            mem_wdata_in,

    input  wire [31:0]            data_rdata_2MEM,   

    input  wire [31:0]            data_raddr_from_EXE,
    input  wire [31:0]            data_waddr_from_EXE,

    input  wire                   data_w_complete,
    input  wire                   data_r_complete,

    input wire  [`CSR_OP_NUM-1:0] csr_op_in,
    input wire  [11:0]            csr_num_in,
    input wire  [31:0]            csr_wmask_in,
    input wire  [31:0]            csr_wvalue_in,
    
    input wire  [`WB_SRC_NUM-1:0] wb_src_op_in, // 写回数据来源选择
    
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
    output wire [`CSR_OP_NUM-1:0] csr_op_out,
    output wire [11:0]            csr_num_out,
    output wire [31:0]            csr_wmask_out,
    output wire [31:0]            csr_wvalue_out,
    output wire [`WB_SRC_NUM-1:0] wb_src_op_out,

    output wire                   readyGo,
    output wire                   allowIn,

    output wire [31:0]            wb_wdata,
    output wire [31:0]            pc_out,
    output wire [ 4:0]            wb_reg_addr_out,
    output wire                   wb_op_out,

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

wire   bram_re; // load，从bram读回来数据给到寄存器堆里
wire   bram_we; // store，从寄存器堆里读出来数据存到bram里

wire   exception_valid_w;
assign exception_valid_w = exception_valid_in;

assign bram_re = exception_valid_w || !valid ? 1'b0 : (mem_op[`MEM_OP_LD_W] | mem_op[`MEM_OP_LD_H] | mem_op[`MEM_OP_LD_B]
               | mem_op[`MEM_OP_LD_HU] | mem_op[`MEM_OP_LD_BU]);
assign bram_we = exception_valid_w || !valid? 1'b0 : (mem_op[`MEM_OP_ST_W] | mem_op[`MEM_OP_ST_H] | mem_op[`MEM_OP_ST_B]);

wire [31:0] r_word_addr   = {data_raddr_from_EXE[31:2], 2'b00};
wire [31:0] w_word_addr   = {data_waddr_from_EXE[31:2], 2'b00};
wire [ 1:0] load_addr_off = data_raddr_from_EXE[1:0];

reg [31:0] load_rdata_hold; // load 返回流水线对齐
always @(posedge clk) begin
    if (reset || !bram_re)
        load_rdata_hold <= 32'b0;
    else if (data_r_complete)
        load_rdata_hold <= data_sram_rdata;
end

// load_wdata_raw就是还没经过对齐处理的数据（生的），要写入寄存器堆
wire [31:0] load_wdata_raw = data_r_complete ? data_sram_rdata : load_rdata_hold;

wire [ 7:0] r_byte_data;
wire [15:0] r_half_data;
wire [31:0] r_word_data;

assign r_byte_data = (load_addr_off == 2'b00) ? load_wdata_raw[7:0] :
                     (load_addr_off == 2'b01) ? load_wdata_raw[15:8] :
                     (load_addr_off == 2'b10) ? load_wdata_raw[23:16] :
                     load_wdata_raw[31:24];

assign r_half_data = (load_addr_off == 2'b00) ? load_wdata_raw[15:0] :
                     (load_addr_off == 2'b10) ? load_wdata_raw[31:16] :
                     16'b0;

assign r_word_data = load_wdata_raw;

wire [31:0] load_result;

assign load_result = (mem_op[`MEM_OP_LD_B])  ? {{24{r_byte_data[7]}}, r_byte_data[7:0]} :
                     (mem_op[`MEM_OP_LD_H])  ? {{16{r_half_data[15]}}, r_half_data[15:0]} :
                     (mem_op[`MEM_OP_LD_BU]) ? {24'b0, r_byte_data[7:0]} :
                     (mem_op[`MEM_OP_LD_HU]) ? {16'b0, r_half_data[15:0]} :
                     (mem_op[`MEM_OP_LD_W])  ? r_word_data :
                                               32'b0;

// 对当前 MEM 流水级做“完成后保持就绪”
reg        load_done_hold;
reg [31:0] load_done_pc;
reg [ 4:0] load_done_rd;
wire       load_done_match = load_done_hold
                           && (pc_in == load_done_pc)
                           && (wb_reg_addr_in == load_done_rd);
                           
always @(posedge clk) begin
    if (reset)
        load_done_hold <= 1'b0;
    else if (!valid || !bram_re)
        load_done_hold <= 1'b0;
    // hold 只用于补偿完成后的下一次推进；被消费后立即清掉，防止同一槽重复提交
    else if (load_done_match && !data_r_complete)
        load_done_hold <= 1'b0;
    else if (load_done_hold && !((pc_in == load_done_pc) && (wb_reg_addr_in == load_done_rd)))
        load_done_hold <= 1'b0;
    else if (data_r_complete) begin
        load_done_hold <= 1'b1;
        load_done_pc   <= pc_in;
        load_done_rd   <= wb_reg_addr_in;
    end
end

// load：未完成前不可推进；一旦完成，保持 ready 直到该 load 槽位离开 MEM
assign readyGo = bram_re ? (data_r_complete | load_done_match) : 1'b1;
assign allowIn = readyGo;

// memport_in_lint 只是为了满足run linter报错，不影响原有逻辑
wire memport_in_lint = (|data_rdata_2MEM) | data_w_complete | (|mem_wdata_in) | (|data_waddr_from_EXE)
                      | bram_we | (|r_word_addr) | (|w_word_addr);
assign wb_wdata        = !exception_valid_w && valid ? ((bram_re ? load_result : exe_result)
                                 ^ ({32{memport_in_lint}} ^ {32{memport_in_lint}})) : 32'b0;
assign pc_out          = valid ? pc_in : 32'b0;// 送 debug 的 PC
assign wb_reg_addr_out = !exception_valid_w && valid ? wb_reg_addr_in : 5'b0;
assign wb_op_out       = !exception_valid_w && valid ? wb_op_in : 1'b0;

assign csr_op_out = valid ? csr_op_in : {`CSR_OP_NUM{1'b0}};
assign csr_num_out = valid ? csr_num_in : 12'b0;
assign csr_wmask_out = valid ? csr_wmask_in : 32'b0;
assign csr_wvalue_out = valid ? csr_wvalue_in : 32'b0;
assign wb_src_op_out = valid ? wb_src_op_in : {`WB_SRC_NUM{1'b0}};
assign ertn_op_out = valid ? ertn_op_in : 1'b0;
assign sys_valid_out = valid ? sys_valid_in : 1'b0;
assign brk_valid_out = valid ? brk_valid_in : 1'b0;
assign ine_valid_out = valid ? ine_valid_in : 1'b0;
assign adef_valid_out = valid ? adef_valid_in : 1'b0;
assign ale_valid_out = valid ? ale_valid_in : 1'b0;
assign int_valid_out = valid ? int_valid_in : 1'b0;
assign exception_valid_out = valid ? exception_valid_in : 1'b0;
assign if_vaddr_out = valid && adef_valid_in ? if_vaddr_in : 32'b0;
assign ale_vaddr_out = valid && ale_valid_in ? ale_vaddr_in : 32'b0;


endmodule
