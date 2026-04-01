//用以延迟一个时钟周期的控制器，主要用于协调指令和数据的读写时序

module bram_data_stream_controller(
    input  wire        clk,
    input  wire        reset,

    input  wire        inst_re_in_from_IF,
    input  wire        data_we_in_from_EXE,
    input  wire        data_re_in_from_EXE,

    input wire [31:0] pc_in_from_IF,
    input wire [31:0] data_raddr_from_EXE,
    input wire [31:0] data_waddr_from_EXE,
    input wire [31:0] data_wdata_from_EXE,
    input wire [ 3:0] data_byte_en_from_EXE, // added by sssafridi, byte enable for store instructions

    input wire [31:0] inst_rdata_from_bram,
    input wire [31:0] data_rdata_from_bram,
    
    input wire inst_re_in_from_bram,
    input wire data_we_in_from_bram,
    input wire data_re_in_from_bram,
    
    output wire inst_re_out_2bram,
    output wire data_we_out_2bram,
    output wire data_re_out_2bram,

    output wire [31:0] inst_raddr_2bram,
    output wire [31:0] data_raddr_2bram,
    output wire [31:0] data_waddr_2bram,
    output wire [31:0] data_wdata_2bram,
    output wire [ 3:0] data_wbyte_en_2bram,

    output wire [31:0] inst_rdata_2IF,
    output wire [31:0] data_rdata_2MEM,

    output reg         data_w_wrong,
    output reg         data_r_wrong,
    output reg         inst_r_wrong,

    output reg         data_w_complete,
    output reg         data_r_complete,
    output reg         inst_r_complete,

    output reg  [31:0] pc_out_2ID
);
/*
    inst_re_in_from_IF： 从IF阶段收到的指令读取使能
    data_we_in_from_EXE：从EXE阶段收到的数据读取使能
    data_re_in_from_EXE：从EXE阶段收到的数据写入使能

   pc_in_from_IF      ：从IF阶段收到的指令地址
   data_raddr_from_EXE：从EXE阶段收到的数据读取地址
   data_waddr_from_EXE：从EXE阶段收到的数据写入地址
   data_wdata_from_EXE：从EXE阶段收到的数据写入数据

   inst_rdata_from_bram：内存返回的指令数据
   data_rdata_from_bram：内存返回的数值数据
    
   inst_re_in_from_bram：从内存返回的指令有效标志
   data_we_in_from_bram：从内存返回的数据写入有效标志
   data_re_in_from_bram：从内存返回的数据读取有效标志
    
    inst_re_out_2bram：向内存发送的指令读取使能
    data_we_out_2bram：向内存发送的数据写入使能
    data_re_out_2bram：向内存发送的数据读取使能

    inst_raddr_2bram：向内存发送的指令读取地址
    data_raddr_2bram：向内存发送的数据读取地址
    data_waddr_2bram：向内存发送的数据写入地址
    data_wdata_2bram：向内存发送的数据写入数据

    inst_rdata_2IF：向IF返回的指令读取数据
    data_rdata_2MEM：向MEM返回的数据读取数据
    
    data_w_wrong：数据写入异常标志
    data_r_wrong：数据读取异常标志
    inst_r_wrong：指令读取异常标志

    data_w_complete：数据读取成功标志
    data_r_complete：数据写入成功标志
    inst_r_complete：指令读取成功标志

*/

wire data_w_wrong_local;
wire data_r_wrong_local;
wire inst_r_wrong_local;
reg  data_we_req_d1;
reg  data_re_req_d1;
reg  data_w_pending;
reg  data_r_pending;
reg  data_r_complete_d; // expr 打一拍再输出 complete，与 pending 同块且对齐读数据

assign data_w_wrong_local=1'b0;//需要异常处理可以修改这部分逻辑，同时保留对外的接口
assign data_r_wrong_local=1'b0;
assign inst_r_wrong_local=1'b0;


assign inst_re_out_2bram = inst_re_in_from_IF;
assign data_re_out_2bram = data_re_in_from_EXE;
assign data_we_out_2bram = data_we_in_from_EXE;

assign inst_raddr_2bram = pc_in_from_IF;
assign data_raddr_2bram = data_raddr_from_EXE;
assign data_waddr_2bram = data_waddr_from_EXE;
assign data_wdata_2bram = data_wdata_from_EXE;

assign inst_rdata_2IF  = inst_rdata_from_bram;
assign data_rdata_2MEM = data_rdata_from_bram;

always @ (posedge clk) begin
    if (reset) begin
        data_we_req_d1 <= 1'b0;
        data_re_req_d1 <= 1'b0;
        data_w_pending <= 1'b0;
        data_r_pending <= 1'b0;
        data_r_complete_d <= 1'b0;
        data_r_complete   <= 1'b0;
    end
    else begin
        data_we_req_d1 <= data_we_in_from_EXE;
        data_re_req_d1 <= data_re_in_from_EXE;

        // 每个请求仅登记一次 pending，等待对应返回后清除
        if (!data_w_pending && data_we_in_from_EXE) begin
            data_w_pending <= 1'b1;
        end
        else if (data_w_pending && !data_we_in_from_EXE && data_we_in_from_bram) begin
            data_w_pending <= 1'b0;
        end
        else begin
            data_w_pending <= data_w_pending;
        end

        // 读 pending：re 为高登记；清除须在 re 已拉低后进行（与常 1 的 bram 应答配合）
        if (!data_r_pending && data_re_in_from_EXE) begin
            data_r_pending <= 1'b1;
        end
        else if (data_r_pending && !data_re_in_from_EXE && data_re_in_from_bram) begin
            data_r_pending <= 1'b0;
        end
        else begin
            data_r_pending <= data_r_pending;
        end

        // 读完成：expr 与 pending 同块；complete 为 expr 延迟一拍（单拍脉冲）
        if (!data_r_wrong_local) begin
            data_r_complete_d <= data_r_pending & !data_re_in_from_EXE & data_re_in_from_bram;
            data_r_complete   <= data_r_complete_d;
        end
        else begin
            data_r_complete_d <= 1'b0;
            data_r_complete   <= 1'b0;
        end
    end
end


always @ (posedge clk) begin
    if (reset) data_w_wrong <= 1'b0;
    else       data_w_wrong <= data_w_wrong_local;
end

always @ (posedge clk) begin
    if (reset) data_r_wrong <= 1'b0;
    else       data_r_wrong <= data_r_wrong_local;
end

always @ (posedge clk) begin
    if (reset) inst_r_wrong <= 1'b0;
    else       inst_r_wrong <= inst_r_wrong_local;
end

always @ (posedge clk) begin
    if(reset) data_w_complete <= 1'b0;
    else if(!data_w_wrong_local) data_w_complete <= data_w_pending & !data_we_in_from_EXE & data_we_in_from_bram;
    else data_w_complete <= 1'b0;
end

always @ (posedge clk) begin
    if(reset) inst_r_complete <= 1'b0;
    else if(!inst_r_wrong_local) inst_r_complete <= inst_re_in_from_IF & inst_re_in_from_bram;
    else inst_r_complete <= 1'b0;
end

always @ (posedge clk) begin
    if(reset) pc_out_2ID <= 32'b0;
    else pc_out_2ID <= pc_in_from_IF;
end

endmodule