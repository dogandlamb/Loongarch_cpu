`include "cpu_defs.vh"

// ============================================================
// exception_Decoder（纯组合）
// 将输入的异常标志信号译码为异常对应的Ecode、Esubcode
// 在 csr_exception_commit_handler 模块例化
// 有些异常我还没加入！！！但现在不影响
// ============================================================
module exception_Decoder (
    input wire INT_valid,           // 中断是否触发，高电平即为有中断异常
    input wire ADEF_valid,          // 取指地址错位异常，特指pc
    input wire ALE_valid,           // 地址非对齐异常，特指MEM的访存
    input wire SYS_valid,           // 系统调用异常，与指令syscall相关
    input wire BRK_valid,           // 断点异常，与指令break相关
    input wire INE_valid,           // 指令不存在异常，特指ID

    output wire [7:0] Ecode,        // 异常码
    output wire  Esubcode           // 异常子码
);

// 有优先级，INT中断最大>IF检测出的异常>ID>EXE>MEM>WB
assign Ecode = INT_valid ? `INT_ECODE :
               ADEF_valid ? `ADEF_ECODE :
               INE_valid ? `INE_ECODE :
               ALE_valid ? `ALE_ECODE :
               SYS_valid ? `SYS_ECODE :
               BRK_valid ? `BRK_ECODE :
               `Ecode_other_exception;

assign Esubcode = INT_valid ? `INT_ESUBCODE :
               ADEF_valid ? `ADEF_ESUBCODE :
               INE_valid ? `INE_ESUBCODE :
               ALE_valid ? `ALE_ESUBCODE :
               SYS_valid ? `SYS_ESUBCODE :
               BRK_valid ? `BRK_ESUBCODE :
               `Esubcode_other_exception;

endmodule