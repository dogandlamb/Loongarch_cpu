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
`define ALU_OP_NUM      17  // 表征ALU有几种操作
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


`endif
