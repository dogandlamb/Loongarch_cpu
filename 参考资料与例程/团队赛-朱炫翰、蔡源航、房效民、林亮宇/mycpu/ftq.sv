`include "core_defines.sv"
`include "frontend_defines.sv"
`include "bpu_defines.sv"


module ftq
    import core_defines::*;
    import frontend_defines::*;
    import bpu_defines::*;
(
    input logic clk,
    input logic rst,

// 前端冲刷控制
    input logic backend_flush_i,                                        // 后端冲刷请求
    input logic [$clog2(FRONTEND_FTQ_SIZE)-1:0] backend_flush_ftq_id_i, // 后端冲刷FTQ条目ID
    input logic ifu_redirect_i,                                         // IFU冲刷信号：预解码发现错误,这里先禁用
    input logic [$clog2(FRONTEND_FTQ_SIZE)-1:0] ifu_redirect_ftq_id_i,  // 前端冲刷FTQ条目ID
    input logic ifu_redirect_dirty_i,                                   // IFU发现被错误预测的指令，要拉高脏标记

// 预测器
    input ftq_block_t bpu_base_ftq_block_i,// BPU预测P0块（常规预测）
    input ftq_block_t bpu_main_ftq_block_i,// BPU预测P1块（重定向预测）
    input bpu_ftq_meta_t bpu_to_ftq_info_i,    // BPU预测元数据
    input logic main_redirect_i,    // BPU主预测器重定向信息
    output logic to_bpu_full_o,      // ftq已满（暂停BPU预测）
    output ftq_bpu_meta_t to_bpu_train_info_o,   // ftq给bpu的训练数据

// 后端信息提交
    input ftq_updata_t ftq_updata_info_i,
    input logic [COMMIT_WIDTH-1:0] backend_commit_i,                    // 提交块掩码
    input logic [COMMIT_WIDTH-1:0] backend_branch_commit_i,             // 后端分支数据提交
    input logic [$clog2(FRONTEND_FTQ_SIZE)-1:0] backend_commit_ftq_id_i,// 提交ftq的ID
    input backend_commit_meta_t backend_commit_branch_info_i,           // 提交的分支元数据


// 后端查询PC
    input logic [$clog2(FRONTEND_FTQ_SIZE)-1:0] bu_query_id_i, // 后端pc通过ftq
    input  logic [ISSUE_WIDTH-1:0][$clog2(FRONTEND_FTQ_SIZE)-1:0] iss_query_id_i,
    input  logic [$clog2(FRONTEND_FTQ_SIZE)-1:0] ctrl_query_id_i,
    output logic [ADDR_WIDTH-1:0] bu_pc_query_o,
    output logic [ADDR_WIDTH-1:0] ras_pc_query_o,
    output logic [ADDR_WIDTH-1:0] iss0_pc_query_o,
    output logic [ADDR_WIDTH-1:0] iss1_pc_query_o,
    output logic [ADDR_WIDTH-1:0] ctrl_pc_query_o,

// 取指模块
    output ftq_block_t to_ifu_block_o,                           // 输出给IFU的预测块
    output logic to_ifu_redirect_o,               // 输出给IFU的重定向信号，同时IFU进行刷新 
    output [$clog2(FRONTEND_FTQ_SIZE)-1:0] to_ifu_id_o,// 输出给IFU的预测块ID
    input logic ifu_accept_block_i                            // IFU接受取指块的信号，如果接受则当周期返回accept
);

// 局部参数 ======================================================
    localparam QUEUE_LENGTH = FRONTEND_FTQ_SIZE;          // 队列长度=8
    localparam PTR_WIDTH = $clog2(QUEUE_LENGTH);          // 队列指针位宽=3

// 三指针 =======================================================
    logic [PTR_WIDTH-1:0] bpu_pre_ptr, ifu_read_ptr, commit_ptr;   // BPU写入指针，IFU读取指针，提交指针
    logic [$clog2(QUEUE_LENGTH)-1:0] bpu_pre_ptr_plus;             // BPU指针+1，用来判断队列是否满
    assign bpu_pre_ptr_plus = bpu_pre_ptr + 1;

// 队列数据结构 =================================================
    ftq_block_t [QUEUE_LENGTH-1:0] Fetch_Target_Queue;                   // FTQ主队列，采用寄存器文件作为存储体
    ftq_block_t [QUEUE_LENGTH-1:0] Fetch_Target_Queue_next;              // 下一周期队列值 
    logic                    bpu_info_store_enable;                         // BPU元数据写入有效
    logic [PTR_WIDTH-1:0]    bpu_info_store_ptr;                            // BPU元数据写入指针
    ftq_bpu_meta_entry_t     bpu_info_store;                                // BPU元数据写入条目
    logic [QUEUE_LENGTH-1:0] FTQ_branch_info_dirty;                       // FTB数据脏标记，在后端提交的时候检测到这个脏标记，FTB中对应的条目会无效化
    logic [QUEUE_LENGTH-1:0] FTQ_branch_info_dirty_next;                  //    
    ftq_bpu_meta_entry_t     FTQ_bpu_info    [QUEUE_LENGTH-1:0];          // FTQ_bpu_meta用来存储FTQ预测块预测器生成的元数据
    ftq_branch_meta_entry_t  FTQ_branch_info [QUEUE_LENGTH-1:0];          // FTQ_branch_meta用来保存FTQ条目分支跳转的实际数据，在后端提交时提供

// 后端提交计数 =================================================
    logic [1:0] count_of_commit;  // 统计后端提交的指令数量
    always_comb begin
        count_of_commit = 0;
        for (integer i = 0; i < COMMIT_WIDTH; i++) begin// 读取后端提交位掩码
            count_of_commit += backend_commit_i[i];
        end
    end

// 各种信号 ======================================================
    logic full_queue;                                   // 队列满
    logic full_queue_delay;                             // 队列满标记寄存器（同步更新），使得队列满信号产生延迟，阻断关键路径
    logic ifu_read_block;                               // IFU当周期接受了一个块（IFU accept并且预测块有效）
    logic ifu_read_block_delay;                           // IFU上周期接受了一个块
    logic main_bpu_redirect_delay;                      // BPU重定向信号延迟
    logic main_bpu_redirect_modify_ftq;                 // BPU重定向修改FTQ标志
    logic to_ifu_redirect;                              // IFU重定向信号
    logic ifu_frontend_redirect_delay;                  // IFU重定向延迟

// 前端控制信号 =================================================
    assign ifu_read_block = Fetch_Target_Queue[ifu_read_ptr].valid & ifu_accept_block_i;    // IFU请求有效 
    assign main_bpu_redirect_modify_ftq = bpu_main_ftq_block_i.valid;       // P1块是BPU重定向预测，会修改FTQ

    // ifu重定向判定
    // 当前bpu指针指向ifu指针的下一个块
    // 主预测器发出重定向要修改之前生成的块
    // 当前周期ifu准备取一个块
    // 满足上面三个条件，说明ifu当前周期要取的块是要被修改的无效块，于是FTQ发出ifu重定向抑制ifu取预测块
    assign to_ifu_redirect = (bpu_pre_ptr == PTR_WIDTH'(ifu_read_ptr + PTR_WIDTH'(1))) // BPU重定向的块正好修改了当前IFU取的块
                                 & main_bpu_redirect_modify_ftq                     // BPU P1重定向修改FTQ
                                 & ifu_read_block;                                    // ifu当前时钟正好要取被修改的预测块

    // 队列满判定
    assign full_queue = (bpu_pre_ptr_plus == commit_ptr);    // BPU下一位置等于提交位置，说明当前时钟周期BPU再进行写入两个指针就重合了，也就是FTQ还能支持BPU当前周期的写入

    // 寄存器延迟控制信号，将各个信号用寄存器延迟一个时钟周期，能切断关键路径
    always_ff @(posedge clk) begin
        full_queue_delay <= full_queue;                         // 队列满信号延迟
        ifu_read_block_delay <= ifu_read_block;                   // IFU请求信号延迟，即上个时钟取预测块
        ifu_frontend_redirect_delay <= to_ifu_redirect;         // 前端重定向延迟
        main_bpu_redirect_delay <= main_redirect_i;         // 主预测器重定向延迟
    end

    // Fetch_Target_Queue 主队列更新和复位
    always_ff @(posedge clk) begin
        if (rst) begin
            Fetch_Target_Queue <= 0;
        end else begin
            Fetch_Target_Queue <= Fetch_Target_Queue_next;
        end
    end

// FTQ暂存BPU数据======================================================
    always_ff @(posedge clk) begin
        // 更新分支跳转指令的信息
        if (ftq_updata_info_i.ftq_update_valid) begin  // 这个信号对应后端的is_branch，不受指令是否流走的控制
            FTQ_branch_info[ftq_updata_info_i.ftq_id].jump_target_address <= ftq_updata_info_i.jump_target;
            FTQ_branch_info[ftq_updata_info_i.ftq_id].fall_through_address <= ftq_updata_info_i.fall_through;
            FTQ_branch_info[ftq_updata_info_i.ftq_id].ftb_dirty <= ftq_updata_info_i.ftq_ftb_dirty;
        end
    end
    always_ff @(posedge clk) begin
        // P1有效
        // Maintain BPU meta info
        if (bpu_info_store_enable) FTQ_bpu_info[bpu_info_store_ptr] <= bpu_info_store;
    end

    always_ff @(posedge clk) begin
        if (rst) FTQ_branch_info_dirty <= '0;
        else FTQ_branch_info_dirty <= FTQ_branch_info_dirty_next;
    end

    always_comb begin : branch_info_dirty
        // 如果不做任何修改，那么保持当前值
        FTQ_branch_info_dirty_next = FTQ_branch_info_dirty;     

        // 将后端提交的块清零
        for (integer i = 0; i < COMMIT_WIDTH; i++) begin
            if (i < count_of_commit) FTQ_branch_info_dirty_next[PTR_WIDTH'(commit_ptr+i)] = 1'b0;
        end

        if (ifu_redirect_i && ifu_redirect_dirty_i) begin
            FTQ_branch_info_dirty_next[ifu_redirect_ftq_id_i] = 1'b1;
        end

        if (backend_flush_i) begin
            for (integer i = 0; i < QUEUE_LENGTH; i++) begin
                if (PTR_WIDTH'(i - commit_ptr) >= PTR_WIDTH'(i - backend_flush_ftq_id_i) && i != backend_flush_ftq_id_i)
                    FTQ_branch_info_dirty_next[i] = 0;
            end
        end
    end

// 指针管理逻辑 =================================================

    assign to_ifu_id_o = ifu_read_ptr;          //输出当前IFU的FTQ ID

    always_ff @(posedge clk) begin : ptr_ff
        if (rst) begin      // 复位
            bpu_pre_ptr  <= 0;
            ifu_read_ptr  <= 0;
            commit_ptr <= 0;
        end else begin
            // 后端提交，提交指针comm_ptr推进
            commit_ptr <= commit_ptr + count_of_commit;

            // 如果前端接受了块，取指指针ifu_ptr推进
            // 并且此时FTQ没有给ifu发送预测器重定向，如果发送预测器重定向说明ifu当前周期要取的任然是该指针所取的块
            // IB（指令缓冲）满的时候，IFU不应该再接受FTQ的输入
            if (ifu_accept_block_i & ~to_ifu_redirect_o) ifu_read_ptr <= ifu_read_ptr + 1;

            // 预测指针bpu_ptr在P0有效的时候推进
            if (bpu_base_ftq_block_i.valid) bpu_pre_ptr <= bpu_pre_ptr + 1;
            // P1有效表示预测重定向，不改变bpu_ptr直接重写（说明之前预测的结果错误）
            if (main_redirect_i) bpu_pre_ptr <= bpu_pre_ptr;

            // 前端重定向
            // 如果IFU的预译码器给出重定向，那么说明冲刷块的指令是正确的，只是基于这个指令进行预测以及后续取指的行为都是错误的
            // 所以把ifu_ptr和bpu_ptr都重置到发起冲刷的ftq块id的下一个位置
            if (ifu_redirect_i) begin
                ifu_read_ptr <= ifu_redirect_ftq_id_i + 1;
                bpu_pre_ptr <= ifu_redirect_ftq_id_i + 1;
            end
            // 后端重定向
            // 回到发出重定向的块的下一个块，和前端重定向一样
            // 后端冲刷到来的上跳沿，要结束发出冲刷指令所在的块，所以comm_ptr+1
            if (backend_flush_i) begin
                ifu_read_ptr <= backend_flush_ftq_id_i + 1;
                bpu_pre_ptr <= backend_flush_ftq_id_i + 1;
            end
        end
    end

// 队列更新逻辑 =================================================
    always_comb begin
        // 如果不做任何修改，那么保持当前FTQ的值
        Fetch_Target_Queue_next = Fetch_Target_Queue;     

        // 将后端提交的块清零
        for (integer i = 0; i < COMMIT_WIDTH; i++) begin
            if (i < count_of_commit) Fetch_Target_Queue_next[PTR_WIDTH'(commit_ptr+i)] = 0;
        end

        // 处理基础预测块
        if (bpu_base_ftq_block_i.valid) Fetch_Target_Queue_next[bpu_pre_ptr] = bpu_base_ftq_block_i;
        
        // 处理主预测器预测块
        if (bpu_main_ftq_block_i.valid) begin
                    // 若上一周期已接受P0（其实这里应该是上一周期没有接受BPU重定向），覆盖前一块
            if (~main_bpu_redirect_delay)  
                Fetch_Target_Queue_next[PTR_WIDTH'(bpu_pre_ptr-1)] = bpu_main_ftq_block_i;
            else    // 否则将这个块写入新的位置
                Fetch_Target_Queue_next[bpu_pre_ptr] = bpu_main_ftq_block_i;
        end

        // 重定向队列生成逻辑
        // 当出现重定向或者冲刷时，重定向指令所在块向后，一直到提交指针所在块都会被清空

        if (ifu_redirect_i) begin
            for (integer i = 0; i < QUEUE_LENGTH; i++) begin
                // 预解码器重定向，清除从comm_ptr到ifu_redirect_ftq_id_i之间的所有预测块（都是错误的块）
                // 当发生预解码器重定向时，发出重定向指令所在块ID是ifu_redirect_ftq_id_i
                // ifu_read_ptr/bpu_ptr下个时钟周期会定位到ifu_redirect_ftq_id_i+1，按照重定向后正确的执行方向继续取指和预测
                if (PTR_WIDTH'(i - commit_ptr) >= PTR_WIDTH'(i - ifu_redirect_ftq_id_i) && i != ifu_redirect_ftq_id_i)
                    Fetch_Target_Queue_next[i] = 0;
            end
        end

        if (backend_flush_i) begin
            for (integer i = 0; i < QUEUE_LENGTH; i++) begin
                // 后端重定向，清除从comm_ptr到backend_flush_ftq_id_i之间所有预测块（都是错误的块）
                // 当发生后端重定向时，发出重定向的指令所在块的ID是backend_flush_ftq_id_i
                // ifu_read_ptr/bpu_ptr下个时钟周期会定位到backend_flush_ftq_id_i+1，按照重定向后正确的执行方向继续取指和预测
                if (PTR_WIDTH'(i - commit_ptr) >= PTR_WIDTH'(i - backend_flush_ftq_id_i) && i != backend_flush_ftq_id_i)
                    Fetch_Target_Queue_next[i] = 0;
            end
        end
    end

// 输出信号逻辑 =================================================
    // -> IFU 输出当前的IFU块
    assign to_ifu_block_o = Fetch_Target_Queue[ifu_read_ptr];
    // 前端IFU冲刷的条件
    // 1、上个周期IFU取了一个基本块，也就是当前周期IFU正在用这个基本块取指
    // 2、主预测器重定向修改FTQ，主预测器重定向是就是修改上个时钟向FTQ写入的基础预测器的结果
    // 3、主预测器重定向修改的块上个周期正好被IFU用来取指令
    assign to_ifu_redirect_o = to_ifu_redirect;

    // -> backend 后端所有用到pc的地方都根据FTQ ID来查询
    assign bu_pc_query_o   = Fetch_Target_Queue[ $clog2(FRONTEND_FTQ_SIZE)'(bu_query_id_i+1)].start_pc;
    assign ras_pc_query_o  = Fetch_Target_Queue[bu_query_id_i       ].start_pc;
    assign iss0_pc_query_o = Fetch_Target_Queue[iss_query_id_i[0]   ].start_pc;
    assign iss1_pc_query_o = Fetch_Target_Queue[iss_query_id_i[1]   ].start_pc;
    assign ctrl_pc_query_o = Fetch_Target_Queue[ctrl_query_id_i     ].start_pc;
    // -> BPU 队列满信号，通知BPU停止预测
    assign to_bpu_full_o = full_queue;


// 训练数据生成 =================================================
    always_ff @(posedge clk) begin
        if (rst) to_bpu_train_info_o <= 0;
        else begin
            to_bpu_train_info_o <= 0;
            if(backend_branch_commit_i[0]) begin
                if (backend_commit_branch_info_i.is_branch) begin
                // 当分支指令提交的时候向预测器反馈训练信息
                to_bpu_train_info_o.valid <= 1;
                to_bpu_train_info_o.ftb_hit <= FTQ_bpu_info[backend_commit_ftq_id_i].ftb_hit;
                to_bpu_train_info_o.ftb_hit_index <= FTQ_bpu_info[backend_commit_ftq_id_i].ftb_hit_index;
                to_bpu_train_info_o.ftb_dirty <= FTQ_branch_info[backend_commit_ftq_id_i].ftb_dirty;
                // 必须使用后端解码出来的准确数据进行训练
                to_bpu_train_info_o.is_branch <= backend_commit_branch_info_i.is_branch;
                to_bpu_train_info_o.branch_type <= backend_commit_branch_info_i.branch_type;
                to_bpu_train_info_o.is_taken <= backend_commit_branch_info_i.is_taken;
                to_bpu_train_info_o.predicted_taken <= backend_commit_branch_info_i.predicted_taken;

                to_bpu_train_info_o.start_pc <= Fetch_Target_Queue[backend_commit_ftq_id_i].start_pc;
                to_bpu_train_info_o.is_cross_cacheline <= Fetch_Target_Queue[backend_commit_ftq_id_i].is_cross_cacheline;
                to_bpu_train_info_o.bpu_meta <= FTQ_bpu_info[backend_commit_ftq_id_i].bpu_meta;
                to_bpu_train_info_o.jump_target_address <= FTQ_branch_info[backend_commit_ftq_id_i].jump_target_address;
                to_bpu_train_info_o.fall_through_address <= FTQ_branch_info[backend_commit_ftq_id_i].fall_through_address;
                
                end else if(FTQ_branch_info_dirty[backend_commit_ftq_id_i]) begin
                to_bpu_train_info_o.valid <= 1;
                to_bpu_train_info_o.ftb_hit <= FTQ_bpu_info[backend_commit_ftq_id_i].ftb_hit;
                to_bpu_train_info_o.ftb_hit_index <= FTQ_bpu_info[backend_commit_ftq_id_i].ftb_hit_index;
                to_bpu_train_info_o.ftb_dirty <= 1'b1;  // 因为出现了误预测，所欲FTB数据有误

                to_bpu_train_info_o.start_pc <= Fetch_Target_Queue[backend_commit_ftq_id_i].start_pc;
                end
            end
        end
    end

// 训练信息生成 =================================================
    always_comb begin
        // P1块写入：覆盖前一块或新位置
        if (bpu_main_ftq_block_i.valid & ~main_bpu_redirect_delay) begin  
            // If last cycle accepted P0 input
            bpu_info_store_enable = 1;
            bpu_info_store_ptr = PTR_WIDTH'(bpu_pre_ptr - 1);
            bpu_info_store.ftb_hit = bpu_to_ftq_info_i.ftb_hit;
            bpu_info_store.ftb_hit_index = bpu_to_ftq_info_i.ftb_hit_index;
            bpu_info_store.bpu_meta = bpu_to_ftq_info_i.bpu_meta;
        end else if (bpu_main_ftq_block_i.valid) begin
            bpu_info_store_enable = 1;
            bpu_info_store_ptr = PTR_WIDTH'(bpu_pre_ptr);
            bpu_info_store.ftb_hit = bpu_to_ftq_info_i.ftb_hit;
            bpu_info_store.ftb_hit_index = bpu_to_ftq_info_i.ftb_hit_index;
            bpu_info_store.bpu_meta = bpu_to_ftq_info_i.bpu_meta;
        end else if (bpu_base_ftq_block_i.valid) begin  
            // If not provided by BPU, clear meta
            // P0块有效，不是来自BPU，那么就没有预测元数据
            bpu_info_store_enable = 1;
            bpu_info_store_ptr   = PTR_WIDTH'(bpu_pre_ptr);
            bpu_info_store = 0;
        end else begin
            bpu_info_store_enable = 0;
            bpu_info_store_ptr   = 0;
            bpu_info_store = 0;
        end
    end
endmodule