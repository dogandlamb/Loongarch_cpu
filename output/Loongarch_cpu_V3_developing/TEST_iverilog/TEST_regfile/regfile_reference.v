`include "mycpu.h"

// ============================================================
// regfile 模块（ARF：体系结构寄存器堆，32x32）
// ------------------------------------------------------------
// 参考实现说明：
// - 4 读口（rename）+ 2 写口（commit 双提交，槽 1 更年轻优先）；
// - 读口带双写口写穿透（槽 1 优先），与 RAT 释放时序对齐；
// - 调试读口与 DIFFTEST 快照保留。
// ============================================================
module regfile(
    input  wire        clk,

    // ---------------- rename 读口 ×4（组合）----------------
    input  wire [ 4:0] raddr0,
    output wire [31:0] rdata0,
    input  wire [ 4:0] raddr1,
    output wire [31:0] rdata1,
    input  wire [ 4:0] raddr2,
    output wire [31:0] rdata2,
    input  wire [ 4:0] raddr3,
    output wire [31:0] rdata3,

    // dispatch 操作数 ARF 回读（RAT 已释放时）
    input  wire [ 4:0] raddr4,
    output wire [31:0] rdata4,
    input  wire [ 4:0] raddr5,
    output wire [31:0] rdata5,
    input  wire [ 4:0] raddr6,
    output wire [31:0] rdata6,
    input  wire [ 4:0] raddr7,
    output wire [31:0] rdata7,

    // ---------------- commit 写口 ×2 ----------------
    input  wire        we0,              // 槽 0 写使能
    input  wire [ 4:0] waddr0,
    input  wire [31:0] wdata0,
    input  wire        we1,              // 槽 1 写使能（同地址时优先于槽 0）
    input  wire [ 4:0] waddr1,
    input  wire [31:0] wdata1,

    // ---------------- 调试只读端口：core_top.rf_rdata 由本端口驱动 ----------------
    input  wire [ 4:0] dbg_raddr,
    output wire [31:0] dbg_rdata

`ifdef DIFFTEST_EN
    ,
    output wire [31:0] diff_gpr_0,
    output wire [31:0] diff_gpr_1,
    output wire [31:0] diff_gpr_2,
    output wire [31:0] diff_gpr_3,
    output wire [31:0] diff_gpr_4,
    output wire [31:0] diff_gpr_5,
    output wire [31:0] diff_gpr_6,
    output wire [31:0] diff_gpr_7,
    output wire [31:0] diff_gpr_8,
    output wire [31:0] diff_gpr_9,
    output wire [31:0] diff_gpr_10,
    output wire [31:0] diff_gpr_11,
    output wire [31:0] diff_gpr_12,
    output wire [31:0] diff_gpr_13,
    output wire [31:0] diff_gpr_14,
    output wire [31:0] diff_gpr_15,
    output wire [31:0] diff_gpr_16,
    output wire [31:0] diff_gpr_17,
    output wire [31:0] diff_gpr_18,
    output wire [31:0] diff_gpr_19,
    output wire [31:0] diff_gpr_20,
    output wire [31:0] diff_gpr_21,
    output wire [31:0] diff_gpr_22,
    output wire [31:0] diff_gpr_23,
    output wire [31:0] diff_gpr_24,
    output wire [31:0] diff_gpr_25,
    output wire [31:0] diff_gpr_26,
    output wire [31:0] diff_gpr_27,
    output wire [31:0] diff_gpr_28,
    output wire [31:0] diff_gpr_29,
    output wire [31:0] diff_gpr_30,
    output wire [31:0] diff_gpr_31
`endif

);
reg [31:0] rf[31:0];
integer i;

initial begin
    for (i = 0; i < 32; i = i + 1) begin
        rf[i] = 32'b0;
    end
end

// 双写口：同拍同地址时槽 1（更年轻）优先生效
always @(posedge clk) begin
    if (we1 && (waddr1 != 5'b0)) rf[waddr1] <= wdata1;
    if (we0 && (waddr0 != 5'b0) && !(we1 && (waddr1 == waddr0))) rf[waddr0] <= wdata0;
end

// 读口写穿透（双口都透，槽 1 优先）
// 用 === 与 we===1'b1：地址或写使能含 X 时勿用 `==`/`&&` 产生 X 污染读口
function [31:0] rf_read;
    input [4:0] raddr;
    begin
        if (raddr === 5'b0)
            rf_read = 32'b0;
        else if ((we1 === 1'b1) && (waddr1 === raddr))
            rf_read = wdata1;
        else if ((we0 === 1'b1) && (waddr0 === raddr))
            rf_read = wdata0;
        else
            rf_read = rf[raddr];
    end
endfunction

assign rdata0 = rf_read(raddr0);
assign rdata1 = rf_read(raddr1);
assign rdata2 = rf_read(raddr2);
assign rdata3 = rf_read(raddr3);
assign rdata4 = rf_read(raddr4);
assign rdata5 = rf_read(raddr5);
assign rdata6 = rf_read(raddr6);
assign rdata7 = rf_read(raddr7);

// 调试端口：直接读寄存器内容（不含写穿透），r0 恒 0
assign dbg_rdata = (dbg_raddr === 5'b0) ? 32'b0 : rf[dbg_raddr];

`ifdef DIFFTEST_EN
// posedge 快照 + 双口写穿透（槽 1 优先），与提交拍对齐
reg [31:0] diff_gpr_r [1:31];
integer dg;
always @(posedge clk) begin
    for (dg = 1; dg < 32; dg = dg + 1) begin
        if ((we1 === 1'b1) && (waddr1 === dg[4:0]))
            diff_gpr_r[dg] <= wdata1;
        else if ((we0 === 1'b1) && (waddr0 === dg[4:0]))
            diff_gpr_r[dg] <= wdata0;
        else
            diff_gpr_r[dg] <= rf[dg];
    end
end
assign diff_gpr_0  = 32'b0;
assign diff_gpr_1  = diff_gpr_r[1];
assign diff_gpr_2  = diff_gpr_r[2];
assign diff_gpr_3  = diff_gpr_r[3];
assign diff_gpr_4  = diff_gpr_r[4];
assign diff_gpr_5  = diff_gpr_r[5];
assign diff_gpr_6  = diff_gpr_r[6];
assign diff_gpr_7  = diff_gpr_r[7];
assign diff_gpr_8  = diff_gpr_r[8];
assign diff_gpr_9  = diff_gpr_r[9];
assign diff_gpr_10 = diff_gpr_r[10];
assign diff_gpr_11 = diff_gpr_r[11];
assign diff_gpr_12 = diff_gpr_r[12];
assign diff_gpr_13 = diff_gpr_r[13];
assign diff_gpr_14 = diff_gpr_r[14];
assign diff_gpr_15 = diff_gpr_r[15];
assign diff_gpr_16 = diff_gpr_r[16];
assign diff_gpr_17 = diff_gpr_r[17];
assign diff_gpr_18 = diff_gpr_r[18];
assign diff_gpr_19 = diff_gpr_r[19];
assign diff_gpr_20 = diff_gpr_r[20];
assign diff_gpr_21 = diff_gpr_r[21];
assign diff_gpr_22 = diff_gpr_r[22];
assign diff_gpr_23 = diff_gpr_r[23];
assign diff_gpr_24 = diff_gpr_r[24];
assign diff_gpr_25 = diff_gpr_r[25];
assign diff_gpr_26 = diff_gpr_r[26];
assign diff_gpr_27 = diff_gpr_r[27];
assign diff_gpr_28 = diff_gpr_r[28];
assign diff_gpr_29 = diff_gpr_r[29];
assign diff_gpr_30 = diff_gpr_r[30];
assign diff_gpr_31 = diff_gpr_r[31];
`endif

endmodule
