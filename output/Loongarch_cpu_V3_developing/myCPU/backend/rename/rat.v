// ============================================================
// rat 模块（寄存器别名表 / GPR 状态表 —— mariver gpr_table 同款）
// ------------------------------------------------------------
// 功能：
// - 队列式重命名的核心映射表：记录每个逻辑寄存器（32 个 GPR）当前是否
//   被一条"未提交的写它的指令"占用（busy），以及那条指令的 ROB 编号。
// - 重命名时查表：busy=1 -> 源操作数标签 = 表中 ROB 编号（去 ROB 取数/等唤醒）；
//   busy=0 -> 直接读 ARF 拿提交值。
// - 重命名写表：目的寄存器 -> 记录本指令的 ROB 编号并置 busy。
// - 提交释放：提交指令的 (rd, robid) 与表中记录完全一致才清 busy
//   （若不一致说明 rd 已被更年轻的指令重新占用，不能清）。
// - 冲刷：busy 全清（ROB 已清空，所有映射失效；ARF 即为权威状态）。
//
// 端口：
// - raddr0~3 / rbusy / rnum ：重命名查询（2 条指令 × rj/rk 共 4 读口，组合）
// - wen0/1 / waddr / wnum   ：重命名占用写口（2 写口）
// - cmt_en0/1 / addr / num  ：提交释放口（2 口）
// - flush_i                 ：全局冲刷 busy 全清
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

//TODO: 实现 32 项 {busy, robid} 映射表（参考：mariver gpr_table.v，几乎可逐行对照移植）
//
//TODO: 存储结构：
//      reg [31:0]         busy;                    // 每个 GPR 一位
//      reg [`ROB_W-1:0]   num [0:31];              // 对应的 ROB 编号
//
//TODO: 读口（纯组合）：
//      rbusy0_o = busy[raddr0_i]; rnum0_o = num[raddr0_i];（×4，r0 的 busy 恒 0）
//      注意：同拍"写口与读口同地址"的旁路【不在本模块做】——同拍双发射中
//      槽 1 读槽 0 目的寄存器的 RAW 由 rename.v 在表外旁路（比较地址直接换标签），
//      本模块只提供"上一拍为止"的视图，这样写法最简单且与 mariver 一致。
//
//TODO: 写口与释放（时序，generate-for 对 32 项逐位写）：
//      对每个寄存器 i：
//        占用：if (wen0_i && waddr0_i==i) || (wen1_i && waddr1_i==i)
//                 num[i] <= (wen1_i && waddr1_i==i) ? wnum1_i : wnum0_i;   // 槽 1 更年轻，优先
//                 busy[i] <= 1;
//        释放：else if (cmt_en0_i && cmt_addr0_i==i && cmt_num0_i==num[i])
//                 || (cmt_en1_i && cmt_addr1_i==i && cmt_num1_i==num[i])
//                 busy[i] <= 0;     // 编号必须完全匹配才能清（防误清更年轻的占用）
//        冲刷：flush_i 时 busy 全 0（优先级最高；num 不用清）。
//      同拍"占用与释放同地址"：占用优先（新指令重新占用该寄存器）。
//
//TODO: 坑点提示：
//      1. r0 恒零：decoder 已保证写 r0 的指令 rf_we=0（wen 不会来），但读口上
//         r0 的 busy 也要恒 0（防御性写法：busy[0] 永远不置 1）。
//      2. 释放比较必须带 ROB 编号（cmt_num==num[i]），只比地址会把
//         "老指令提交"误清"新指令的占用"——这是队列式重命名最经典的 bug。

endmodule
