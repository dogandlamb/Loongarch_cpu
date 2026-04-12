`ifndef CPU_DEFS_VH
`define CPU_DEFS_VH


/* 分支/跳转操作码宏定义 */
`define BR_OP_NUM       9     // 分支/跳转有多少种操作，与br_op有关 
`define BR_OP_BEQ       0     // beq
`define BR_OP_BNE       1     // bne
`define BR_OP_JIRL      2     // jirl
`define BR_OP_BL        3     // bl
`define BR_OP_B         4     // b
`define BR_OP_BLT       5     // blt
`define BR_OP_BGE       6     // bge
`define BR_OP_BLTU      7     // bltu
`define BR_OP_BGEU      8     // bgeu


/* ALU操作码宏定义 */
`define ALU_OP_NUM      19  // 表征ALU有几种操作
`define ALU_OP_ADD      0   // 加法
`define ALU_OP_SUB      1   // 减法
`define ALU_OP_SLT      2   // 有符号小于比较
`define ALU_OP_SLTU     3   // 无符号小于比较
`define ALU_OP_AND      4   // 按位与
`define ALU_OP_NOR      5   // 按位或非
`define ALU_OP_OR       6   // 按位或
`define ALU_OP_XOR      7   // 按位异或
`define ALU_OP_SLL      8   // 逻辑左移
`define ALU_OP_SRL      9   // 逻辑右移
`define ALU_OP_SRA      10  // 算术右移
`define ALU_OP_LUI      11  // lu12i_w，立即数填到目标寄存器的高若干位，低位补 0
`define ALU_OP_MUL_W    12  // 32 位乘法低位结果
`define ALU_OP_MULH_W   13  // 有符号乘法高位结果
`define ALU_OP_MULH_WU  14  // 有符号/无符号混合乘法高位结果
`define ALU_OP_DIV_W    15  // 有符号除法
`define ALU_OP_DIV_WU   16  // 无符号除法
`define ALU_OP_MOD_W    17  // 有符号取余
`define ALU_OP_MOD_WU   18  // 无符号取余


/* mem_op操作码宏定义 */
`define MEM_OP_NUM      8   // 表征MEM访存有迹几种操作
`define MEM_OP_LD_W     1   // load，从内存取数据写入寄存器堆（与 {inst_ld_w, inst_st_w} 对齐）
`define MEM_OP_ST_W     0   // store，从寄存器堆数据存入内存（与 {inst_ld_w, inst_st_w} 对齐）
`define MEM_OP_ST_B     2   // store byte，从寄存器堆数据存入内存（与 {inst_ld_b, inst_st_b} 对齐）
`define MEM_OP_ST_H     3   // store half，从寄存器堆数据存入内存（与 {inst_ld_h, inst_st_h} 对齐）
`define MEM_OP_LD_B     4   // load byte，从内存取数据写入寄存器堆（与 {inst_ld_b, inst_st_b} 对齐）
`define MEM_OP_LD_H     5   // load half，从内存取数据写入寄存器堆（与 {inst_ld_h, inst_st_h} 对齐）    
`define MEM_OP_LD_BU    6   // load byte unsigned，从内存取数据写入寄存器堆（与 {inst_ld_b, inst_st_b} 对齐）
`define MEM_OP_LD_HU    7   // load half unsigned，从内存取数据写入寄存器堆（与 {inst_ld_h, inst_st_h} 对齐）

//csrrd、csrwr.csrxchg,ertn、syscall、break.rdcntvl.w.rdcntvh.w、rdcntid
/*csr_op操作码宏定义*/
`define CSR_OP_NUM      3   // 表征CSR指令有几种操作
`define CSR_OP_CSRRD    0   // CSRRD 指令将指定 CSR 的值写入到通用寄存器 rd 中
`define CSR_OP_CSRWR    1   // CSRWR 指令将通用寄存器 rd 中的旧值写入到指定 CSR 中，同时将指定 CSR 的旧值更新到通用寄存器 rd 中
`define CSR_OP_CSRXCHG  2   // CSRXCHG 指令根据通用寄存器 rj 中存放的写掩码信息，将通用寄存器 rd 中的旧值写入到指定 CSR 中对应写掩码为 1 的那些比特，该 CSR 中的其余比特保持不变，同时将该 CSR 的旧值更新到通用寄存器 rd 中

// /*计数器指令操作码宏定义*/
// `define RDCNT_OP_NUM      3  // 表征计数器指令有几种操作
// `define RDCNT_OP_RDCNTVL  0  // 读虚拟计数器值低32位指令，rdcntvl.w
// `define RDCNT_OP_RDCNTVH  1  // 读虚拟计数器高32位值指令，rdcntvh.w
// `define RDCNT_OP_RDCNTID  2  // 读计数器ID指令，rdcntid

/* 其他宏定义 */
// `define OT_OP_ERTN
// `define OT_OP_SYSCALL
// `define OT_OP_BREAK
/*这条指令最后写回寄存器的数据，应该从哪一路来（wb_op：要不要写回 wb_src：如果写回，从哪来*/
`define WB_SRC_NUM        6
`define WB_SRC_ALU        0// ALU运算结果
`define WB_SRC_MEM        1//load 返回值
`define WB_SRC_CSR        2//CSR 旧值
`define WB_SRC_CNTVL      3//计数器低 32 位
`define WB_SRC_CNTVH      4//计数器高 32 位
`define WB_SRC_TID        5//rdcntid 返回值


/* 异常Ecode、Esubcode宏定义 */
// 有些异常我还没加上
`define INT_ECODE  8'h00 //中断
`define ADEF_ECODE 8'h08 //取指地址错异常
`define ADEM_ECODE 8'h04 //访存指令地址错异常
`define INE_ECODE  8'h0d //指令不存在异常
`define ALE_ECODE  8'h09 //地址非对齐异常
`define SYS_ECODE  8'h0b //系统调用异常
`define BRK_ECODE  8'h0c //断点异常

`define INT_ESUBCODE   1'b0
`define ADEF_ESUBCODE  1'b0
`define INE_ESUBCODE   1'b0
`define ALE_ESUBCODE   1'b0
`define SYS_ESUBCODE   1'b0
`define BRK_ESUBCODE   1'b0

`define Ecode_other_exception 8'hFF
`define Esubcode_other_exception 1'b0


/* 控制状态寄存器号宏定义 */
// 用于 csr_num
`define CSR_CRMD        12'h000
`define CSR_PRMD        12'h001
`define CSR_EUEN        12'h002
`define CSR_ECFG        12'h004
`define CSR_ESTAT       12'h005
`define CSR_ERA         12'h006
`define CSR_BADV        12'h007
`define CSR_EENTRY      12'h00c
`define CSR_TLBIDX      12'h010
`define CSR_TLBEHI      12'h011
`define CSR_TLBELO0     12'h012
`define CSR_TLBELO1     12'h013
`define CSR_ASID        12'h018
`define CSR_PGDL        12'h019
`define CSR_PGDH        12'h01a
`define CSR_PGD         12'h01b
`define CSR_CPUID       12'h020
`define CSR_SAVE0       12'h030
`define CSR_SAVE1       12'h031
`define CSR_SAVE2       12'h032
`define CSR_SAVE3       12'h033
`define CSR_TID         12'h040
`define CSR_TCFG        12'h041
`define CSR_TVAL        12'h042
`define CSR_TICLR       12'h044
`define CSR_LLBCTL      12'h060
`define CSR_TLBRENTRY   12'h088
`define CSR_CTAG        12'h098
`define CSR_DMW0        12'h180
`define CSR_DMW1        12'h181


/* 控制状态寄存器域宏定义 */
// 用于 csr_wmask
`define CSR_CRMD_PLV       1:0
`define CSR_CRMD_IE        2
`define CSR_CRMD_DA        3
`define CSR_CRMD_PG        4
`define CSR_CRMD_DATF      6:5
`define CSR_CRMD_DATM      8:7
`define CSR_PRMD_PPLV      1:0
`define CSR_PRMD_PIE       2
`define CSR_ECFG_LIE       12:0
`define CSR_ESTAT_IS10     1:0
`define CSR_TICLR_CLR      0
`define CSR_ERA_PC         31:0
`define CSR_EENTRY_VA      31:6
`define CSR_SAVE_DATA      31:0
`define CSR_TID_TID        31:0
`define CSR_TCFG_EN        0
`define CSR_TCFG_PERIODIC  1
`define CSR_TCFG_INITVAL   31:2


`endif
