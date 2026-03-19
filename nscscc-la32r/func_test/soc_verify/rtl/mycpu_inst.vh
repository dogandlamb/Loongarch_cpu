`ifndef MYCPU_INST_VH
`define MYCPU_INST_VH

`define ENABLE_INCDEV

`define IMPL_LU12I_W    0
`define IMPL_ADD_W      1
`define IMPL_ADDI_W     0
`define IMPL_SUB_W      0
`define IMPL_SLT        0
`define IMPL_SLTU       0
`define IMPL_AND        0
`define IMPL_OR         0
`define IMPL_XOR        0
`define IMPL_NOR        0
`define IMPL_SLLI_W     0
`define IMPL_SRLI_W     0
`define IMPL_SRAI_W     0
`define IMPL_LD_W       0 //Load
`define IMPL_ST_W       0 //Store
`define IMPL_BEQ        0 //B
`define IMPL_BNE        0 //B
`define IMPL_BL         0 //J
`define IMPL_JIRL       0 //J
`define IMPL_B          0 //J
`define IMPL_PCADDU12I  1
`define IMPL_SLTI       0
`define IMPL_SLTUI      0
`define IMPL_ANDI       0
`define IMPL_ORI        0
`define IMPL_XORI       0
`define IMPL_SLL_W      0
`define IMPL_SRA_W      0
`define IMPL_SRL_W      0
`define IMPL_DIV_W      0 //DIV
`define IMPL_DIV_WU     0 //DIV
`define IMPL_MUL_W      0 //MUL
`define IMPL_MULH_W     0 //MUL
`define IMPL_MULH_WU    0 //MUL
`define IMPL_MOD_W      0 //DIV
`define IMPL_MOD_WU     0 //DIV
`define IMPL_BLT        0 //B
`define IMPL_BGE        0 //B
`define IMPL_BLTU       0 //B
`define IMPL_BGEU       0 //B
`define IMPL_LD_B       0 //Load
`define IMPL_LD_H       1 //Load
`define IMPL_LD_BU      0 //Load
`define IMPL_LD_HU      0 //Load
`define IMPL_ST_B       0 //Store
`define IMPL_ST_H       0 //Store

`endif
