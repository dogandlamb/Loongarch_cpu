`ifndef MYCPU_VH
`define MYCPU_VH

`define DECODER_WIDTH 2



`define BR_BUS_WD           33
`define IF_TO_ID_BUS_WD     108
`define ISS_TO_EXE_BUS_WD    357
`define EXE_TO_MEM_BUS_WD   472
`define MEM_TO_WB_BUS_WD    450

// CRMD
`define CRMD           14'h0
`define CRMD_PLV       1:0
`define CRMD_IE        2
`define CRMD_DA        3
`define CRMD_PG        4
`define CRMD_DATF      6:5
`define CRMD_DATM      8:7

// PRMD
`define PRMD           14'h1
`define PRMD_PPLV      1:0
`define PRMD_PIE       2

// ECFG
`define ECFG           14'h4
`define ECFG_LIE       12:0

// ESTAT
`define ESTAT          14'h5
`define ESTAT_IS10     1:0

// ERA
`define ERA            14'h6
`define ERA_PC         31:0

// BADV
`define BADV           14'h7

// EENTRY
`define EENTRY         14'hc
`define EENTRY_VA      31:6

// TLBIDX
`define TLBIDX         14'h10
`define TLBIDX_INDEX   2:0
`define TLBIDX_PS      29:24
`define TLBIDX_NE      31

// TLBEHI
`define TLBEHI         14'h11
`define TLBEHI_VPPN    31:13

// TLBELO0��TLBELO1
`define TLBELO0        14'h12
`define TLBELO1        14'h13
`define TLBELO_V       0
`define TLBELO_D       1
`define TLBELO_PLV     3:2
`define TLBELO_MAT     5:4
`define TLBELO_G       6
`define TLBELO_PPN     27:8 // PALEN = 32 ������ַ����Чλ��

// ASID
`define ASID           14'h18
`define ASID_ASID       9:0

// PGDL��PGDH��PGD
`define PGDL           14'h19
`define PGDH           14'h1a
`define PGD            14'h1b
`define BASE           31:12

// CPUID
`define CPUID          14'h20

// SAVE 0~3
`define SAVE0          14'h30
`define SAVE1          14'h31
`define SAVE2          14'h32
`define SAVE3          14'h33
`define SAVE_DATA      31:0

// LLBCTL LLBit����
`define LLBCTL         14'h60
`define LLBCTL_ROLLB   0
`define LLBCTL_WCLLB   1
`define LLBCTL_KLO     2

// TID
`define TID            14'h40
`define TID_TID        31:0

// TCFG
`define TCFG           14'h41
`define TCFG_EN        0
`define TCFG_PERIODIC  1
`define TCFG_INITVAL   31:2

// TVAL
`define TVAL           14'h42

// CNTC
`define CNTC           14'h43

// TICLR
`define TICLR          14'h44
`define TICLR_CLR      0

// TLBRENTRY
`define TLBRENTRY      14'h88
`define TLBRENTRY_PA   31:6

// DISABLE_CACHE
`define DISABLE_CACHE  14'h101

// DMW0��DMW1
`define DMW0           14'h180
`define DMW1           14'h181
`define DMW_PLV0       0
`define DMW_PLV3       3
`define DMW_MAT        5:4
`define DMW_PSEG       27:25
`define DMW_VSEG       31:29

// CPUCFG
`define CPUCFG        14'hb0
`define CPUCFG1       14'hb1
`define CPUCFG2       14'hb2
`define CPUCFG10      14'hc0
`define CPUCFG11      14'hc1
`define CPUCFG12      14'hc2
`define CPUCFG13      14'hc3

// ECODE
`define ECODE_INT  6'h0
`define ECODE_PIL  6'h1 // load ����ҳ��Ч����
`define ECODE_PIS  6'h2 // store ����ҳ��Ч����
`define ECODE_PIF  6'h3 // ȡָ����ҳ��Ч����
`define ECODE_PME  6'h4 // ҳ�޸�����
`define ECODE_PPI  6'h7 // ҳ��Ȩ�ȼ����Ϲ�����
`define ECODE_ADE  6'h8
`define ECODE_ALE  6'h9
`define ECODE_SYS  6'hb
`define ECODE_BRK  6'hc
`define ECODE_INE  6'hd
`define ECODE_IPE  6'he
`define ECODE_FPD  6'hf
`define ECODE_TLBR 6'h3f // TLB ��������

// ESUBCODE
`define ESUBCODE_ADEF      9'h0

`endif
