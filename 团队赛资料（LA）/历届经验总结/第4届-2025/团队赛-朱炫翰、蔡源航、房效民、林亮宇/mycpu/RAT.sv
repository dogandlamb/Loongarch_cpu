`include "mycpu.vh"
`include "pipeline_types.sv"
`include "core_defines.sv"
module RAT /*一个映射表，就是用来告诉指令它的源操作数应该去ROB中的哪个位置找，用来解决写后读冒险*/
    import pipeline_types::*;
    import core_defines::*;
(
    input  logic        clk,
    input  logic        reset,
    input  logic        flush_sign,
    //================================ RA阶段的读写端口 ================================
    // 读
    input  logic [DECODER_WIDTH-1:0][ 4:0] src1_addr,
    input  logic [DECODER_WIDTH-1:0][ 4:0] src2_addr,

    output logic [DECODER_WIDTH-1:0]                        src1_valid,
    output logic [DECODER_WIDTH-1:0]                        src2_valid,
    output logic [DECODER_WIDTH-1:0][$clog2(ROB_DEPTH)-1:0] src1_prf,
    output logic [DECODER_WIDTH-1:0][$clog2(ROB_DEPTH)-1:0] src2_prf,

    // 写
    input  logic [DECODER_WIDTH-1:0]                         we,       //write enable, HIGH valid
    input  logic [DECODER_WIDTH-1:0][ 4:0]                   waddr,
    input  logic [DECODER_WIDTH-1:0][$clog2(ROB_DEPTH)-1:0]  wprf,
    //================================ 分支预测错误时的纠正 ================================
    // from ISS
    input  logic        redirect, // ISS阶段传来的分支预测错误信号
    //================================ retire时的无效化 ================================
    input  logic [COMMIT_WIDTH-1:0]                         invalid, // 就是ROB的dequeue_en
    input  logic [COMMIT_WIDTH-1:0][$clog2(ROB_DEPTH)-1:0]  invalid_ROB_idx,
    input  logic [COMMIT_WIDTH-1:0][ 4:0]                   invalid_addr
);
reg [31:0]                          valid; // 表示表项是否有效，无效说明结果在逻辑寄存器中，无需在RTA中映射
reg [31:0][$clog2(ROB_DEPTH)-1:0]   prf;   // 逻辑寄存器对应的物理寄存器，即ROB索引

// 写
always @(posedge clk) begin
    if (reset || flush_sign || redirect) begin // 重定向的时候直接把整个RAT清空，因为分支预测错误后的指令都是错的，此时的RAT是没有用的
        valid <= 32'b0;
    end
    else begin // retire的无效化和RA阶段的重命名没有互斥关系，重命名优先级高于无效化
        for (int i = 0; i < COMMIT_WIDTH; i++) begin
            if (invalid[i] && prf[invalid_addr[i]] == invalid_ROB_idx[i]) begin // 当指令在commit阶段retire时，如果RAT中的映射关系仍然有效，则要把对应的映射关系置为无效
                valid[invalid_addr[i]] <= 1'b0;
            end
        end
        for (int i = 0; i < DECODER_WIDTH; i++) begin // 在RA阶段写，指令进入发射队列的时候写；如果两条指令的目的寄存器相同，则只写后一个
            if (we[i]) begin
                valid[waddr[i]] <= 1'b1;
                prf[waddr[i]] <= wprf[i];
            end
        end
    end
end
// 读
always_comb begin : read_select
    src1_valid[0] = valid[src1_addr[0]];
    src2_valid[0] = valid[src2_addr[0]];

    src1_prf[0] = prf[src1_addr[0]];
    src2_prf[0] = prf[src2_addr[0]];
    // 后一条的RAT映射有特殊的判断逻辑，如果前一条指令的目的寄存器是后一条指令的源寄存器，那就映射到前一条指令的ROB索引
    if (we[0] && (src1_addr[1] == waddr[0])) begin
        src1_valid[1] = 1'b1;
        src1_prf[1]   = wprf[0];
    end
    else begin
        src1_valid[1] = valid[src1_addr[1]];
        src1_prf[1]   = prf[src1_addr[1]];
    end
    if (we[0] && (src2_addr[1] == waddr[0])) begin
        src2_valid[1] = 1'b1;
        src2_prf[1]   = wprf[0];
    end
    else begin
        src2_valid[1] = valid[src2_addr[1]];
        src2_prf[1]   = prf[src2_addr[1]];
    end
end
endmodule
