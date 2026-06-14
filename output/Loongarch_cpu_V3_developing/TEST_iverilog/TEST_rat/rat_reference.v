// ============================================================
// rat 模块（寄存器别名表 / GPR 状态表 —— mariver gpr_table 同款）
// ------------------------------------------------------------
// 参考实现说明：
// - 32 项 {busy, robid} 映射表；
// - 读口纯组合（上一拍视图，槽间 RAW 旁路由 rename 在表外处理）；
// - 占用写优先于提交释放；释放必须 robid 完全匹配才清 busy；
// - flush 时 busy 全清（ARF 即为权威状态）。
// ============================================================
`include "mycpu.h"

module rat(
    input  wire                clk,
    input  wire                reset,
    input  wire                flush_i,

    // ---------------- 重命名查询口 ×4（组合读）----------------
    input  wire [4:0]          raddr0_i,        // 槽 0 的 src0（rj）
    output wire                rbusy0_o,
    output wire [`ROB_W-1:0]   rnum0_o,

    input  wire [4:0]          raddr1_i,        // 槽 0 的 src1（rk/rd）
    output wire                rbusy1_o,
    output wire [`ROB_W-1:0]   rnum1_o,

    input  wire [4:0]          raddr2_i,        // 槽 1 的 src0
    output wire                rbusy2_o,
    output wire [`ROB_W-1:0]   rnum2_o,

    input  wire [4:0]          raddr3_i,        // 槽 1 的 src1
    output wire                rbusy3_o,
    output wire [`ROB_W-1:0]   rnum3_o,

    // dispatch 侧查询（busy/robid，用于 RAT 已释放或 younger writer 后的 ARF 回读）
    input  wire [4:0]          raddr4_i,
    output wire                rbusy4_o,
    output wire [`ROB_W-1:0]   rnum4_o,
    input  wire [4:0]          raddr5_i,
    output wire                rbusy5_o,
    output wire [`ROB_W-1:0]   rnum5_o,
    input  wire [4:0]          raddr6_i,
    output wire                rbusy6_o,
    output wire [`ROB_W-1:0]   rnum6_o,
    input  wire [4:0]          raddr7_i,
    output wire                rbusy7_o,
    output wire [`ROB_W-1:0]   rnum7_o,

    // ---------------- 重命名占用写口 ×2 ----------------
    input  wire                wen0_i,          // 槽 0 写占用（该指令写寄存器且非 r0）
    input  wire [4:0]          waddr0_i,
    input  wire [`ROB_W-1:0]   wnum0_i,         // 槽 0 的 ROB 编号 {1'b0, rob_tail}

    input  wire                wen1_i,          // 槽 1 写占用
    input  wire [4:0]          waddr1_i,
    input  wire [`ROB_W-1:0]   wnum1_i,         // 槽 1 的 ROB 编号 {1'b1, rob_tail}

    // ---------------- 提交释放口 ×2 ----------------
    input  wire                cmt_en0_i,       // 提交槽 0 写寄存器的指令
    input  wire [4:0]          cmt_addr0_i,
    input  wire [`ROB_W-1:0]   cmt_num0_i,

    input  wire                cmt_en1_i,
    input  wire [4:0]          cmt_addr1_i,
    input  wire [`ROB_W-1:0]   cmt_num1_i
);

reg [31:0]        busy;
reg [`ROB_W-1:0]  num [0:31];

// 仿真期防 X：num 阵列上电清零（综合可忽略 initial）
integer init_i;
initial begin
    for (init_i = 0; init_i < 32; init_i = init_i + 1) num[init_i] = {`ROB_W{1'b0}};
end

// ---------------- 读口（纯组合，r0 恒不忙）----------------
assign rbusy0_o = busy[raddr0_i];
assign rnum0_o  = num[raddr0_i];
assign rbusy1_o = busy[raddr1_i];
assign rnum1_o  = num[raddr1_i];
assign rbusy2_o = busy[raddr2_i];
assign rnum2_o  = num[raddr2_i];
assign rbusy3_o = busy[raddr3_i];
assign rnum3_o  = num[raddr3_i];
assign rbusy4_o = busy[raddr4_i];
assign rnum4_o  = num[raddr4_i];
assign rbusy5_o = busy[raddr5_i];
assign rnum5_o  = num[raddr5_i];
assign rbusy6_o = busy[raddr6_i];
assign rnum6_o  = num[raddr6_i];
assign rbusy7_o = busy[raddr7_i];
assign rnum7_o  = num[raddr7_i];

// ---------------- 写口/释放（占用 > 释放；释放须编号匹配）----------------
genvar i;
generate
for (i = 0; i < 32; i = i + 1) begin : gen_rat_entry
    wire wr1   = wen1_i && (waddr1_i == i[4:0]);          // 槽 1 更年轻，优先
    wire wr0   = wen0_i && (waddr0_i == i[4:0]);
    wire rel0  = cmt_en0_i && (cmt_addr0_i == i[4:0]) && (cmt_num0_i == num[i]);
    wire rel1  = cmt_en1_i && (cmt_addr1_i == i[4:0]) && (cmt_num1_i == num[i]);

    always @(posedge clk) begin
        if (reset || flush_i) begin
            busy[i] <= 1'b0;
        end else if (i != 0) begin                        // r0 恒零：永不置 busy
            if (wr0 || wr1) begin
                busy[i] <= 1'b1;
                num[i]  <= wr1 ? wnum1_i : wnum0_i;
            end else if (rel0 || rel1) begin
                busy[i] <= 1'b0;
            end
        end
    end
end
endgenerate

endmodule
