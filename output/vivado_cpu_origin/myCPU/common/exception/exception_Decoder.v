`include "../../top/cpu_defs.vh"

// ============================================================
// exception_Decoder（纯组合）
// 将输入的异常标志信号译码为异常对应的Ecode、Esubcode
// 在 csr_exception_commit_handler 模块例化
// 有些异常我还没加入！！！但现在不影响
// ============================================================
module exception_Decoder (
    input wire INT_valid,           // 中断是否触发，高电平即为有中断异常
    input wire ADEF_valid,          // 取指地址错位异常，特指pc
    input wire [`TLB_EX_NUM-1:0] TLB_EX_valid,
    input wire ALE_valid,           // 地址非对齐异常，特指MEM的访存
    input wire SYS_valid,           // 系统调用异常，与指令syscall相关
    input wire BRK_valid,           // 断点异常，与指令break相关
    input wire INE_valid,           // 指令不存在异常，特指ID

    output wire [7:0] Ecode,        // 异常码
    output wire  Esubcode           // 异常子码
);

// 有优先级，INT中断最大>IF检测出的异常>ID>EXE>MEM>WB
// 各 valid 用 ===1'b1 判定，避免某位为 X 时三元运算把 Ecode/Esubcode 污染成 X。
assign Ecode = (INT_valid === 1'b1) ? `INT_ECODE :
               (ADEF_valid === 1'b1) ? `ADEF_ECODE :
               (TLB_EX_valid[`TLB_EX_TLBR] === 1'b1) ? `TLBR_ECODE :
               (TLB_EX_valid[`TLB_EX_PIF] === 1'b1) ? `PIF_ECODE :
               (TLB_EX_valid[`TLB_EX_PPI] === 1'b1) ? `PPI_ECODE :
               (TLB_EX_valid[`TLB_EX_PIL] === 1'b1) ? `PIL_ECODE :
               (TLB_EX_valid[`TLB_EX_PIS] === 1'b1) ? `PIS_ECODE :
               (TLB_EX_valid[`TLB_EX_PME] === 1'b1) ? `PME_ECODE :
               (INE_valid === 1'b1) ? `INE_ECODE :
               (ALE_valid === 1'b1) ? `ALE_ECODE :
               (SYS_valid === 1'b1) ? `SYS_ECODE :
               (BRK_valid === 1'b1) ? `BRK_ECODE :
               `Ecode_other_exception;

assign Esubcode = (INT_valid === 1'b1) ? `INT_ESUBCODE :
               (ADEF_valid === 1'b1) ? `ADEF_ESUBCODE :
               (TLB_EX_valid[`TLB_EX_TLBR] === 1'b1) ? `TLBR_ESUBCODE :
               (TLB_EX_valid[`TLB_EX_PIF] === 1'b1) ? `PIF_ESUBCODE :
               (TLB_EX_valid[`TLB_EX_PPI] === 1'b1) ? `PPI_ESUBCODE :
               (TLB_EX_valid[`TLB_EX_PIL] === 1'b1) ? `PIL_ESUBCODE :
               (TLB_EX_valid[`TLB_EX_PIS] === 1'b1) ? `PIS_ESUBCODE :
               (TLB_EX_valid[`TLB_EX_PME] === 1'b1) ? `PME_ESUBCODE :
               (INE_valid === 1'b1) ? `INE_ESUBCODE :
               (ALE_valid === 1'b1) ? `ALE_ESUBCODE :
               (SYS_valid === 1'b1) ? `SYS_ESUBCODE :
               (BRK_valid === 1'b1) ? `BRK_ESUBCODE :
               `Esubcode_other_exception;

endmodule