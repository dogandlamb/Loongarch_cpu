module bram_data_stream_controller(
    input wire clk,
    input wire reset,

    input wire inst_r_we_in_from_IF,
    input wire data_w_we_in_from_EXE,
    input wire data_r_we_in_from_EXE,

    input wire [31:0] pc_in_from_IF,
    input wire [31:0] data_raddr_from_EXE,
    input wire [31:0] data_waddr_from_EXE,
    input wire [31:0] data_wdata_from_EXE,

    input wire [31:0] inst_rdata_from_bram,
    input wire [31:0] data_rdata_from_bram,
    
    input wire inst_r_we_in_from_bram,
    input wire data_w_we_in_from_bram,
    input wire data_r_we_in_from_bram,
    
    output wire inst_r_we_out_2bram,
    output wire data_w_we_out_2bram,
    output wire data_r_we_out_2bram,

    output wire [31:0] inst_raddr_2bram,
    output wire [31:0] data_raddr_2bram,
    output wire [31:0] data_waddr_2bram,
    output wire [31:0] data_wdata_2bram,

    output wire [31:0] inst_rdata_2IF,
    output wire [31:0] data_rdata_2MEM,
    
    output reg data_w_wrong,
    output reg data_r_wrong,
    output reg inst_r_wrong,

    output reg data_w_complete,
    output reg data_r_complete,
    output reg inst_r_complete,

    output reg [31:0] pc_out_2ID

);
/*
    inst_r_we_in_from_IF： 从IF阶段收到的指令读取使能
    data_w_we_in_from_EXE：从EXE阶段收到的数据读取使能
    data_r_we_in_from_EXE：从EXE阶段收到的数据写入使能

   pc_in_from_IF      ：从IF阶段收到的指令地址
   data_raddr_from_EXE：从EXE阶段收到的数据读取地址
   data_waddr_from_EXE：从EXE阶段收到的数据写入地址
   data_wdata_from_EXE：从EXE阶段收到的数据写入数据

   inst_rdata_from_bram：内存返回的指令数据
   data_rdata_from_bram：内存返回的数值数据
    
   inst_r_we_in_from_bram：从内存返回的指令有效标志
   data_w_we_in_from_bram：从内存返回的数据写入有效标志
   data_r_we_in_from_bram：从内存返回的数据读取有效标志
    
    inst_r_we_out_2bram：向内存发送的指令读取使能
    data_w_we_out_2bram：向内存发送的数据写入使能
    data_r_we_out_2bram：向内存发送的数据读取使能

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

assign data_w_wrong_local=1'b0;//需要异常处理可以修改这部分逻辑，同时保留对外的接口
assign data_r_wrong_local=1'b0;
assign inst_r_wrong_local=1'b0;


assign inst_r_we_out_2bram = inst_r_we_in_from_IF;
assign data_r_we_out_2bram = data_r_we_in_from_EXE;
assign data_w_we_out_2bram = data_w_we_in_from_EXE;

assign inst_raddr_2bram = pc_in_from_IF;
assign data_raddr_2bram = data_raddr_from_EXE;
assign data_waddr_2bram = data_waddr_from_EXE;
assign data_wdata_2bram = data_wdata_from_EXE;

assign inst_rdata_2IF  = inst_rdata_from_bram;
assign data_rdata_2MEM = data_rdata_from_bram;

always @ (posedge clk) begin
    if(reset) data_w_wrong <= 1'b0;
    else data_w_wrong <= data_w_wrong_local;
end

always @ (posedge clk) begin
    if(reset) data_r_wrong <= 1'b0;
    else data_r_wrong <= data_r_wrong_local;
end

always @ (posedge clk) begin
    if(reset) inst_r_wrong <= 1'b0;
    else inst_r_wrong <= inst_r_wrong_local;
end

always @ (posedge clk) begin
    if(reset) data_w_complete <= 1'b0;
    else if(!data_w_wrong_local) data_w_complete <= data_w_we_in_from_EXE;
    else data_w_complete <= 1'b0;
end

always @ (posedge clk) begin
    if(reset) data_r_complete <= 1'b0;
    else if(!data_r_wrong_local) data_r_complete <= data_r_we_in_from_EXE;
    else data_r_complete <= 1'b0;
end

always @ (posedge clk) begin
    if(reset) inst_r_complete <= 1'b0;
    else if(!inst_r_wrong_local) inst_r_complete <= inst_r_we_in_from_IF;
    else inst_r_complete <= 1'b0;
end

always @ (posedge clk) begin
    if(reset) pc_out_2ID <= 32'b0;
    else pc_out_2ID <= pc_in_from_IF;
end

endmodule