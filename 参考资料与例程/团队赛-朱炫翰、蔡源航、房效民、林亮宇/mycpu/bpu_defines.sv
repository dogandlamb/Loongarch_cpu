`ifndef BPU_DEFINES_SV
`define BPU_DEFINES_SV

`include "core_defines.sv"
// 模块包括BPU内部的结构体、BPU和FTQ之间的端口

// 2025/6/28：代码阅读体会
/*
1、关于FTB：（Fast Target Buffer）用于缓存分支跳转目标地址
    从命中机制来说，FTB就像一个缓存，根据core_config规定条目的个数总共有1024个，于是FTBtag长度就是32-10-2=20
    实际上FTB的作用就是缓存最近的跳转指令的跳转目标（这里还带上了预测失败的回退目标）
2、关于前端组件交互机制：
    目前看下来，bpu_types主要定义了BPU和FTQ之间交互的信息端口，至于端口各个信号有什么用途，目前只是从AI给出的名称注释中略知一二
    还需要阅读实际组件代码来进一步了解端口含义
*/


package bpu_defines;

    import core_defines::*;
    //目前看来用到了core_config中的FTB_NSET和FTB_NWAY

    //FTB条目信息
    typedef struct packed {
        logic valid;                //条目有效位
        logic is_cross_cacheline;   //FTB条目是否跨越缓存行
        logic [1:0] branch_type;    //分支跳转的类型
        // Virtual tag, pc[1:0] is always 0, so not used in index or tag
        logic [ADDR_WIDTH-3-$clog2(FTB_NSET):0] tag;    //ftb标签    
        //这里的位数首先减去末尾的两位然后再减去根据（FTB_NSET=1024）计算出来的十位，也就是取高20位
        logic [ADDR_WIDTH-1:0] jump_target_address; //分支跳转的目标地址
        logic [ADDR_WIDTH-1:0] fall_through_address;//分支未跳转时候的回退地址
    } ftb_entry_t;


    //TAGE元数据
    typedef struct packed {
        logic [$clog2(BPU_TAG_COMPONENT_NUM+1)-1:0] provider_id;    //主预测件ID
        logic [$clog2(BPU_TAG_COMPONENT_NUM+1)-1:0] alt_provider_id;//备选预测件ID
        logic useful;                                               //当前预测是否有用
        logic [BPU_TAG_COMPONENT_NUM:0][2:0] provider_ctr_bits;             //组件计数器，表征预测的强度
        logic [BPU_TAG_COMPONENT_NUM-1:0][BPU_TAG_COMPONENT_TAG_WIDTH-1:0] tag_predictor_query_tag;     //查询标签
        logic [BPU_TAG_COMPONENT_NUM-1:0][BPU_TAG_COMPONENT_TAG_WIDTH-1:0] tag_predictor_origin_tag;    //原始标签
        logic [BPU_TAG_COMPONENT_NUM-1:0][9:0] tag_predictor_hit_index;     //标签命中索引
        logic [BPU_TAG_COMPONENT_NUM-1:0][2:0] tag_predictor_useful_bits;   //组件的有用位

    } tage_meta_t;


    //TAGE的更新信息
    typedef struct packed {
        logic valid;            //更新信息有效位
        logic predict_correct;  //预测是否正确
        logic branch_taken;     //分支实际是否跳转
        logic is_conditional;   //是否未条件分支
        tage_meta_t bpu_meta;   //关联的TAGE元数据
    } tage_predictor_update_info_t;


    //BPU给到FTQ的元数据，用来传输预测器的预测结果
    typedef struct packed {
        logic valid;                                //有效位
        logic ftb_hit;                              //FTB是否命中
        logic [$clog2(FTB_NWAY)-1:0] ftb_hit_index; //FTB命中条目组索引
        tage_meta_t bpu_meta;                       //TAGE元数据类型：TAGE预测的结果
    } bpu_ftq_meta_t;


    //FTQ给到BPU的元数据，用来更新预测器的相关信息
    typedef struct packed {
        logic valid;                                //有效位
        logic ftb_hit;                              //FTB是否命中
        logic [$clog2(FTB_NWAY)-1:0] ftb_hit_index; //FTB命中组索引
        logic ftb_dirty;                            //FTB条目是否需要更新
        logic is_cross_cacheline;                   //是否跨越缓存行

        tage_meta_t bpu_meta;   //TAGE元数据类型

        // Backend Decode Info：后端执行反馈
        logic is_branch;        //是否为分支
        logic [1:0] branch_type;//分支类型
        logic is_taken;         //分支实际跳转
        logic predicted_taken;  //预测跳转

        // FTB meta
        logic [ADDR_WIDTH-1:0] start_pc;            //分支指令PC
        logic [ADDR_WIDTH-1:0] jump_target_address; //实际跳转的目标
        logic [ADDR_WIDTH-1:0] fall_through_address;//实际回退的地址
    } ftq_bpu_meta_t;


    // FTQ条目中BPU元数据信息，其实和bpu_ftq_meta_t是一样的
    typedef struct packed {
        logic valid;    //有效
        logic ftb_hit;  //命中
        logic [$clog2(FTB_NWAY)-1:0] ftb_hit_index; //组索引

        tage_meta_t bpu_meta;//TAGE元数据类型

    } ftq_bpu_meta_entry_t;


    // 用来存储ftq条目的实际分支跳转目标
    typedef struct packed {
        logic ftb_dirty;    //ftb更新标志
        logic [ADDR_WIDTH-1:0] jump_target_address; //跳转地址
        logic [ADDR_WIDTH-1:0] fall_through_address;//回退地址
    } ftq_branch_meta_entry_t;

    typedef struct packed {
        logic ras_push;    // BPU提前训练RAS
        logic ras_pop;     // 取出返回地址
        logic [ADDR_WIDTH-1:0] call_ret_address;
    } bpu_ras_op_t;

    typedef struct packed {
        logic ras_push;    // BPU提前训练RAS
        logic ras_pop;     // 取出返回地址
        logic [$clog2(FRONTEND_FTQ_SIZE)-1:0] push_ftq_id;
        logic [$clog2(FETCH_WIDTH+1)-1:0] push_idx;
    } BU_ras_op_t;

endpackage

`endif
