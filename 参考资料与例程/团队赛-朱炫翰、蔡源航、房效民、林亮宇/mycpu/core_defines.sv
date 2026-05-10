`ifndef CORE_DEFINES_SV
`define CORE_DEFINES_SV
// 这是我自己的core_defines，其实主要是前端的defines

package core_defines;

// 地址宽度，数据宽度
    parameter ADDR_WIDTH = 32;
    parameter DATA_WIDTH = 32;
    parameter INST_WIDTH = 32;

// 前端参数
    parameter FETCH_WIDTH = 4;          // 取指宽度4条
    parameter ICACHELINE_WIDTH = 128;   // ICACHE一行128位
    parameter FRONTEND_FTQ_SIZE = 8;    // FTQ条目个数8

// 后端参数
    parameter COMMIT_WIDTH  = 2;
    parameter DECODER_WIDTH = 2;
    parameter ISSUE_WIDTH   = 2;
    parameter FU_NUM        = 5;
    parameter BU_NUM        = 1;
    parameter ROB_DEPTH     = 32;

// FTB参数
    parameter integer FTB_NSET = 1024;  //FTB一组的条目个数1024
    parameter integer FTB_NWAY = 4;     //FTB4路组相联

// BPU参数
    // RAS
    parameter integer RAS_ENTRY_NUM = 32;
    // 分支类型
    parameter logic [1:0] BRANCH_TYPE_COND = 2'b00;
    parameter logic [1:0] BRANCH_TYPE_CALL = 2'b01;
    parameter logic [1:0] BRANCH_TYPE_RET = 2'b10;
    parameter logic [1:0] BRANCH_TYPE_UNCOND = 2'b11;
    // 预测器参数
    parameter BPU_TAG_COMPONENT_NUM = 4;
    parameter BPU_TAG_COMPONENT_TAG_WIDTH = 12;
    parameter integer BPU_COMPONENT_TABLE_DEPTH[BPU_TAG_COMPONENT_NUM+1] = '{8192,  1024,   1024,   1024,   1024};
    parameter integer BPU_COMPONENT_CTR_WIDTH[BPU_TAG_COMPONENT_NUM+1] = '{2,3,3,3,3};
    parameter integer BPU_COMPONENT_USEFUL_WIDTH[BPU_TAG_COMPONENT_NUM+1] = '{0,3,3,3,3};
    parameter integer BPU_COMPONENT_HISTORY_LENGTH[BPU_TAG_COMPONENT_NUM+1] = '{0,11,23,53,112};
    parameter BPU_GHR_LENGTH = 1024 + BPU_COMPONENT_HISTORY_LENGTH[BPU_TAG_COMPONENT_NUM];

endpackage

`endif  