// ============================================================
// bram_data_stream_controller：IF或MEM 与 BRAM 之间的请求/应答整形。
// top里的 *_in_from_bram 常 1；数据读完成用 pending + 延迟一拍产生单周期脉冲。
// ============================================================
module bram_data_stream_controller(
    input wire         clk,
    input wire         reset,

    input wire         inst_re_in_from_IF,   // IF 发起取指
    input wire         data_we_in_from_EXE,  // MEM 发起写
    input wire         data_re_in_from_EXE,  // MEM 发起读

    input wire [31:0]  pc_in_from_IF,
    input wire [31:0]  data_raddr_from_EXE,
    input wire [31:0]  data_waddr_from_EXE,
    input wire [31:0]  data_wdata_from_EXE,
    input wire [ 3:0]  data_byte_en_from_EXE,

    input wire [31:0]  inst_rdata_from_bram,
    input wire [31:0]  data_rdata_from_bram,

    input wire         inst_re_in_from_bram, //top里常为1
    input wire         data_we_in_from_bram, //top里常为1
    input wire         data_re_in_from_bram, //top里常为1

    output wire        inst_re_out_2bram,
    output wire        data_we_out_2bram,
    output wire        data_re_out_2bram,

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

    output wire [31:0] pc_out_2ID           // 与返回给IF的指令对齐的 PC（延迟一拍）
);

wire data_w_wrong_local;
wire data_r_wrong_local;
wire inst_r_wrong_local;
assign data_w_wrong_local=1'b0;
assign data_r_wrong_local=1'b0;
assign inst_r_wrong_local=1'b0;


reg  data_we_req_d1;
reg  data_re_req_d1;
reg  data_w_pending;
reg  data_r_pending;
reg  data_r_complete_d;              // 读完成脉冲打一拍，就是读完成信号
reg  [31:0] inst_pc_pending;         // 与 inst_rdata 对齐的 PC，pending就是“待定的、等待的”意思

assign inst_re_out_2bram = inst_re_in_from_IF;
assign data_re_out_2bram = data_re_in_from_EXE | (data_re_req_d1 ^ data_re_req_d1);
assign data_we_out_2bram = data_we_in_from_EXE | (data_we_req_d1 ^ data_we_req_d1);
assign data_wbyte_en_2bram = data_byte_en_from_EXE;

assign inst_raddr_2bram = pc_in_from_IF;
assign data_raddr_2bram = data_raddr_from_EXE;
assign data_waddr_2bram = data_waddr_from_EXE;
assign data_wdata_2bram = data_wdata_from_EXE;

assign inst_rdata_2IF  = inst_rdata_from_bram;
assign data_rdata_2MEM = data_rdata_from_bram;
assign pc_out_2ID      = inst_pc_pending;

always @ (posedge clk) begin
    if (reset) begin
        data_we_req_d1 <= 1'b0;
        data_re_req_d1 <= 1'b0;
        data_w_pending <= 1'b0;
        data_r_pending <= 1'b0;
        data_r_complete_d <= 1'b0;
        data_r_complete   <= 1'b0;
        inst_pc_pending   <= 32'b0;
    end
    else begin
        data_we_req_d1 <= data_we_in_from_EXE;
        data_re_req_d1 <= data_re_in_from_EXE;
        if (inst_re_in_from_IF) begin
            // 对齐当前发起的取指请求，供下一拍返回的指令使用
            inst_pc_pending <= pc_in_from_IF;
        end

        // 每个请求仅登记一次 pending（等待中），等待对应返回后清除
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

        // 读完成：组合条件（pending 且 re 已拉低且 bram 应答）打入 data_r_complete_d；
        // 下一拍 data_r_complete <= data_r_complete_d，形成单周期脉冲。
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

endmodule
