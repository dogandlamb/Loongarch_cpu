`include "mycpu.h"

// ============================================================
// exception_Decoder 模块（异常优先级编码器，纯组合）
// ------------------------------------------------------------
// 功能（新架构下角色不变，作为 csr_exception_commit_handler 的内部工具）：
// - 把 commit 提交级送来的各异常 valid 信号按优先级编码成 8 位 Ecode 与
//   Esubcode，供 CSR 写 ESTAT/选择异常入口使用。
// - 优先级（高 -> 低）：INT > 取指类（ADEF/TLBR/PIF/PPI）> INE > IPE
//   > SYS/BRK > ALE/ADEM > 访存 TLB 类（TLBR/PIL/PIS/PPI/PME）。
//   注意：commit 每次只会送一条指令的异常（双提交时异常指令必单提交），
//   同一条指令多个异常位同时有效时按上述优先级取最高者。
// ============================================================
module exception_Decoder (
    input  wire                   INT_valid,
    input  wire                   ADEF_valid,
    input  wire                   ADEM_valid,
    input  wire                   IPE_valid,
    input  wire [`TLB_EX_NUM-1:0] TLB_EX_valid,   // 位序见 mycpu.h（TLBR/PIF/PPI/PIL/PIS/PME）
    input  wire                   ALE_valid,
    input  wire                   SYS_valid,
    input  wire                   BRK_valid,
    input  wire                   INE_valid,
    output wire [7:0]             Ecode,
    output wire                   Esubcode
);

    // 按优先级从高到低的链式选择（INT 最高）
    assign Ecode =
        INT_valid                      ? `INT_ECODE  :
        ADEF_valid                     ? `ADEF_ECODE :
        TLB_EX_valid[`TLB_EX_TLBR]     ? `TLBR_ECODE :
        TLB_EX_valid[`TLB_EX_PIF]      ? `PIF_ECODE  :
        TLB_EX_valid[`TLB_EX_PPI]      ? `PPI_ECODE  :
        INE_valid                      ? `INE_ECODE  :
        IPE_valid                      ? `IPE_ECODE  :
        SYS_valid                      ? `SYS_ECODE  :
        BRK_valid                      ? `BRK_ECODE  :
        ALE_valid                      ? `ALE_ECODE  :
        ADEM_valid                     ? `ADEM_ECODE :
        TLB_EX_valid[`TLB_EX_PIL]      ? `PIL_ECODE  :
        TLB_EX_valid[`TLB_EX_PIS]      ? `PIS_ECODE  :
        TLB_EX_valid[`TLB_EX_PME]      ? `PME_ECODE  :
                                         `Ecode_other_exception;

    // 仅 ADEM 需要 ESUBCODE=1（与 ADEF 同 ECODE=0x8 靠子码区分）
    assign Esubcode =
        ADEM_valid && !INT_valid && !ADEF_valid
                   && !TLB_EX_valid[`TLB_EX_TLBR]
                   && !TLB_EX_valid[`TLB_EX_PIF]
                   && !TLB_EX_valid[`TLB_EX_PPI]
                   && !INE_valid && !IPE_valid
                   && !SYS_valid && !BRK_valid && !ALE_valid
                   ? `ADEM_ESUBCODE : 1'b0;

//TODO: 本模块为重建版本（原版随旧架构清理误删，逻辑按原优先级语义重写）。
//      若提交级遇到"取指 TLB 异常"与"访存 TLB 异常"共用 TLB_EX_valid 向量
//      产生歧义（同位序 PPI 两用），commit 侧已按指令类型分别打包，
//      这里不需要区分；如对优先级有疑问以《龙芯架构32位精简版参考手册》
//      异常优先级表为准核对一遍。

endmodule
