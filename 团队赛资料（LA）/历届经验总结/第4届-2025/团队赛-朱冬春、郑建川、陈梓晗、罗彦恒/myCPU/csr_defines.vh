`ifndef CSR_DEFINES_V
`define CSR_DEFINES_V

// CSR 地址
`define CSR_CRMD        14'b00000000000000  //0
`define CSR_PRMD        14'b00000000000001  //1
`define CSR_EUEN        14'b00000000000010  //2
`define CSR_ECFG        14'b00000000000100  //4
`define CSR_ESTAT       14'b00000000000101  //5
`define CSR_ERA         14'b00000000000110  //6
`define CSR_BADV        14'b00000000000111  //7
`define CSR_EENTRY      14'b00000000001100  //c
`define CSR_TLBIDX      14'b00000000010000  //10
`define CSR_TLBEHI      14'b00000000010001  //11
`define CSR_TLBELO0     14'b00000000010010  //12
`define CSR_TLBELO1     14'b00000000010011  //13
`define CSR_ASID        14'b00000000011000  //18
`define CSR_PGDL        14'b00000000011001  //19
`define CSR_PGDH        14'b00000000011010  //1a
`define CSR_PGD         14'b00000000011011  //1b
`define CSR_CPUID       14'b00000000100000  //20
`define CSR_SAVE0       14'b00000000110000  //30
`define CSR_SAVE1       14'b00000000110001  //31
`define CSR_SAVE2       14'b00000000110010  //32
`define CSR_SAVE3       14'b00000000110011  //33
`define CSR_TID         14'b00000001000000  //40
`define CSR_TCFG        14'b00000001000001  //41
`define CSR_TVAL        14'b00000001000010  //42
`define CSR_TICLR       14'b00000001000100  //44
`define CSR_LLBCTL      14'b00000001100000  //60
`define CSR_TLBRENTRY   14'b00000010001000  //80
`define CSR_CTAG        14'b00000010011000  //98
`define CSR_DMW0        14'b00000110000000  //180
`define CSR_DMW1        14'b00000110000001  //181
`define CSR_CPUCFG1     14'b00000010110001  
`define CSR_CPUCFG2     14'b00000010110010
`define CSR_CPUCFG10    14'b00000011000000
`define CSR_CPUCFG11    14'b00000011000001
`define CSR_CPUCFG12    14'b00000011000010
`define CSR_CPUCFG13    14'b00000011000011

// Exceptions
`define EXCEPTION_INT 7'b0000000   //0
`define EXCEPTION_PIL 7'b0000010   //2
`define EXCEPTION_PIS 7'b0000100   //4
`define EXCEPTION_PIF 7'b0000110   //6
`define EXCEPTION_PME 7'b0001000   //8
`define EXCEPTION_PPI 7'b0001110   //e
`define EXCEPTION_ADEF 7'b0010000   //10
`define EXCEPTION_ADEM 7'b0010001   //11
`define EXCEPTION_ALE 7'b0010010   //12
`define EXCEPTION_SYS 7'b0010110   //16
`define EXCEPTION_BRK 7'b0011000   //18
`define EXCEPTION_INE 7'b0011010   //1a
`define EXCEPTION_IPE 7'b0011100   //1c
`define EXCEPTION_FPD 7'b0011110   //1e
`define EXCEPTION_FPE 7'b0100100   //24
`define EXCEPTION_TLBR 7'b1111110   //7e
`define EXCEPTION_NOP 7'b1111111   //7f

//CRMD
`define PLV       1:0
`define IE        2
`define DA        3
`define PG        4
`define DATF      6:5
`define DATM      8:7
//PRMD
`define PPLV      1:0
`define PIE       2
//ECTL
`define LIE       12:0
`define LIE_1     9:0
`define LIE_2     12:11
//ESTAT
`define IS        12:0
`define ECODE     21:16
`define ESUBCODE  30:22
//TLBIDX
`define INDEX     4:0
`define PS        29:24
`define NE        31
//TLBEHI
`define VPPN      31:13
//TLBELO
`define TLB_V      0
`define TLB_D      1
`define TLB_PLV    3:2
`define TLB_MAT    5:4
`define TLB_G      6
`define TLB_PPN    31:8
`define TLB_PPN_EN 27:8   //todo
//ASID
`define TLB_ASID  9:0
//CPUID
`define COREID    8:0
//LLBCTL
`define ROLLB     0
`define WCLLB     1
`define KLO       2
//TCFG
`define EN        0
`define PERIODIC  1
`define INITVAL   31:2
//TICLR
`define CLR       0
//TLBRENTRY
`define TLBRENTRY_PA 31:6
//DMW
`define PLV0      0
`define PLV3      3 
`define DMW_MAT   5:4
`define PSEG      27:25
`define VSEG      31:29
//PGDL PGDH PGD
`define BASE      31:12

`endif
