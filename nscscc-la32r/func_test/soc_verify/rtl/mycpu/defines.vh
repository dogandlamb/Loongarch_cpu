`ifndef DEFINES_VH
`define DEFINES_VH

// `define ENABLE_ICACHE
// `define ENABLE_DCACHE
// `define ENABLE_BPU

`define CACHE_BLK_LEN   8
`define CACHE_BLK_SIZE  (`CACHE_BLK_LEN*32)
`define CACHE_BLK_NUM   32

`define PC_INIT_VAL 32'h1C000000

`define NPC_PC4     2'b00

`define EXT_12      3'b011
`define EXT_20      3'b110

`define ALU_ADD     5'b00000

`define RAM_EXT_N   3'b000
`define RAM_EXT_H   3'b100

`define RAM_WE_N    4'b0000

`define R2_RK       1'b1
`define R2_RD       1'b0

`define ALUA_R1     1'b1
`define ALUA_PC     1'b0

`define ALUB_R2     1'b1
`define ALUB_EXT    1'b0

`define WR_RD       1'b1
`define WR_Rr1      1'b0

`define WD_ALU      2'b11
`define WD_RAM      2'b01

`endif
