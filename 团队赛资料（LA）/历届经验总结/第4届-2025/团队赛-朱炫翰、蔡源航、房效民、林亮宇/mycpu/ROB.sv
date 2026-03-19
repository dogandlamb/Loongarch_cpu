`include "mycpu.vh"
`include "pipeline_types.sv"
`include "core_defines.sv"
module ROB
    import pipeline_types::*;
    import core_defines::*;
(
    input  logic clk,
    input  logic reset,
    input  logic flush_sign,
    // csr_cnt的增减
    input  logic csr_increase_en, // from ISS
    output logic csr_pause,
    //================================ 重命名阶段（结束时）的写端口 ================================
    input  logic [DECODER_WIDTH-1:0] enqueue_en, // 入队使能，发射队列什么时候添加指令，就什么时候入队
    input  ROB_t [DECODER_WIDTH-1:0] enqueue_data, // 入队数据
    //================================ 重命名阶段的读端口 ================================
    output logic [$clog2(ROB_DEPTH) - 1:0] tail, // 队列尾
    output logic [$clog2(ROB_DEPTH) - 1:0] tail_plus, // 队列尾+1
    //================================ 发射阶段的读端口 ================================
    input  logic [ISSUE_WIDTH-1:0][$clog2(ROB_DEPTH)-1:0] raddr1,
    output logic [ISSUE_WIDTH-1:0]                        rvalid1, // valid就是complete
    output logic [ISSUE_WIDTH-1:0][31:0]                  rdata1,
    input  logic [ISSUE_WIDTH-1:0][$clog2(ROB_DEPTH)-1:0] raddr2,
    output logic [ISSUE_WIDTH-1:0]                        rvalid2,
    output logic [ISSUE_WIDTH-1:0][31:0]                  rdata2,
    //================================ 执行阶段（结束时）的写端口 ================================
    input  logic [FU_NUM-1:0]                           complete_en,
    input  logic [FU_NUM-1:0][$clog2(ROB_DEPTH)-1:0]    complete_addr,
    input  ROB_t [FU_NUM-1:0]                           complete_entry,
    //================================ 提交阶段的退休端口 ================================   目前先一个一个退休，毕竟IPC也不高
    // from ctrl
    input  logic [COMMIT_WIDTH-1:0] dequeue_en, // 出队使能
    // to ctrl
    output ROB_t [COMMIT_WIDTH-1:0] dequeue_data, // 队头的数据，如果其状态为complete，则表示可以退休，dequeue_en为1；异常时有额外处理
    // to RAT
    output logic [COMMIT_WIDTH-1:0][$clog2(ROB_DEPTH)-1:0]invalid_ROB_idx, // 队头的ROB索引
    output logic [COMMIT_WIDTH-1:0][ 4:0]                 invalid_addr,    // 队头的目的寄存器
    //================================ 分支预测错误时的纠正 ================================
    // from ISS
    input  logic                        redirect, // ISS阶段传来的分支预测错误信号
    input  logic [$clog2(ROB_DEPTH)-1:0]ROB_error_index, // 分支预测错误的指令的ROB索引
    // to ID
    output logic                        ROB_redirect_state,
    //================================ ROB的状态 ================================
    // output logic one_spare, // 队列有一个空闲位置
    output logic full, // 队列满
    output logic one_left, // 队列只有一个元素
    output logic empty, // 队列空
    output logic ROB_pause // 表示ROB队列中发现了异常、ertn指令、refetch，在指令执行阶段结束的时候进行检测，这样可以确保pause的正确性
);

    ROB_t [ROB_DEPTH-1:0] rob; // 存储队列数据

    logic [$clog2(ROB_DEPTH) - 1:0] head; // 队列头

    logic [$clog2(ROB_DEPTH) - 1:0] head_plus; // 队列头+1

    always_ff @(posedge clk) begin : tail_update
        if (reset || flush_sign) begin
            tail <= 0;
            tail_plus <= 1;
        // 当分支预测错时，tail恢复到分支预测错误的指令的ROB索引+1，即让分支预测错误的指令成为ROB中的最后一条指令；分支预测错时，阻断指令进入ROB
        end else if (redirect) begin
            tail <= ROB_error_index + 1;
            tail_plus <= ROB_error_index + 2;
        end else if (&enqueue_en) begin // 两条指令入队
            tail <= tail + 2;
            tail_plus <= tail_plus + 2;
        end else if (|enqueue_en) begin // 一条指令入队，但什么情况下是只有一条指令入队呢？1.队列只有一个空位？
            tail <= tail + 1;
            tail_plus <= tail_plus + 1;
        end
    end

    always_ff @(posedge clk) begin : enqueue // 两个两个入队
        // if (reset || flush_sign) begin // 初始化
        //     rob <= 0;
        // end
        // else 
        begin
            // 重命名阶段结束时写入
            if (&enqueue_en) begin
                rob[tail] <= enqueue_data[0];
                rob[tail_plus] <= enqueue_data[1];
            end else if (enqueue_en[0]) begin // redirect时，这里不阻断，因为队列中指令的valid是靠head和tail来维护的，数据入队但是tail不变，等于没有入队
                rob[tail] <= enqueue_data[0];
            end else if (enqueue_en[1]) begin
                rob[tail] <= enqueue_data[1];
            end
            // 执行阶段结束时写入
            for (int i = 0; i < FU_NUM; i++) begin
                if(complete_en[i]) begin
                    rob[complete_addr[i]] <= complete_entry[i];
                end
            end
        end
    end

    always_comb begin : issue_read_src1
        for (int i = 0; i < ISSUE_WIDTH; i++) begin
            unique case (1'b1) 
                complete_en[0] && (complete_addr[0] == raddr1[i]) : begin
                    rvalid1[i] = 1'b1;
                    rdata1[i]  = complete_entry[0].data;
                end
                complete_en[1] && (complete_addr[1] == raddr1[i]) : begin
                    rvalid1[i] = 1'b1;
                    rdata1[i]  = complete_entry[1].data;
                end
                complete_en[2] && (complete_addr[2] == raddr1[i]) : begin
                    rvalid1[i] = 1'b1;
                    rdata1[i]  = complete_entry[2].data;
                end
                complete_en[3] && (complete_addr[3] == raddr1[i]) : begin
                    rvalid1[i] = 1'b1;
                    rdata1[i]  = complete_entry[3].data;
                end
                complete_en[4] && (complete_addr[4] == raddr1[i]) : begin
                    rvalid1[i] = 1'b1;
                    rdata1[i]  = complete_entry[4].data;
                end
                default : begin
                    rvalid1[i] = rob[raddr1[i]].complete;
                    rdata1[i]  = rob[raddr1[i]].data;
                end
            endcase
        end
    end

    always_comb begin : issue_read_src2
        for (int i = 0; i < ISSUE_WIDTH; i++) begin
            unique case (1'b1) 
                complete_en[0] && (complete_addr[0] == raddr2[i]) : begin
                    rvalid2[i] = 1'b1;
                    rdata2[i]  = complete_entry[0].data;
                end
                complete_en[1] && (complete_addr[1] == raddr2[i]) : begin
                    rvalid2[i] = 1'b1;
                    rdata2[i]  = complete_entry[1].data;
                end
                complete_en[2] && (complete_addr[2] == raddr2[i]) : begin
                    rvalid2[i] = 1'b1;
                    rdata2[i]  = complete_entry[2].data;
                end
                complete_en[3] && (complete_addr[3] == raddr2[i]) : begin
                    rvalid2[i] = 1'b1;
                    rdata2[i]  = complete_entry[3].data;
                end
                complete_en[4] && (complete_addr[4] == raddr2[i]) : begin
                    rvalid2[i] = 1'b1;
                    rdata2[i]  = complete_entry[4].data;
                end
                default : begin
                    rvalid2[i] = rob[raddr2[i]].complete;
                    rdata2[i]  = rob[raddr2[i]].data;
                end
            endcase
        end
    end


    always_ff @(posedge clk) begin : head_update // 单个提交
        if (reset || flush_sign) begin
            head <= 0;
            head_plus <= 1;
        end else if (&dequeue_en && !empty) begin
            head <= head + 2;
            head_plus <= head_plus + 2;
        end else if (|dequeue_en && !empty) begin // dequeue_en即retire使能
            head <= head + 1;
            head_plus <= head_plus + 1;
        end
    end

    // dequeue，读是组合逻辑
    assign dequeue_data[0] = rob[head];
    assign dequeue_data[1] = rob[head_plus];
    // to RAT
    assign invalid_ROB_idx[0] = head;
    assign invalid_ROB_idx[1] = head_plus;
    assign invalid_addr[0] = dequeue_data[0].Areg;
    assign invalid_addr[1] = dequeue_data[1].Areg;

    //assign one_spare= (head == $clog2(ROB_DEPTH)'(tail_plus + 1))
    assign full     = (head == $clog2(ROB_DEPTH)'(tail_plus + 1)) || (head == tail_plus);
    assign one_left = (head_plus == tail); // 队列只有一个元素
    assign empty    = (head == tail); // 队列为空

    // 表示FU执行完后的指令有没有异常、ertn、refetch这些需要让发射阶段暂停的情况
    logic [FU_NUM-1:0] need_pause;
    for (genvar i = 0; i < FU_NUM; i = i + 1) begin
        assign need_pause[i] = complete_en[i] && (complete_entry[i].ex || complete_entry[i].ertn_flush || complete_entry[i].refetch_flush);
    end

    always_ff @ (posedge clk) begin : ROB_pause_detect
        if (reset || flush_sign) begin
            ROB_pause <= 1'b0;
        end
        else begin
            if (|need_pause) begin
                ROB_pause <= 1'b1;
            end
        end
    end
    parameter REDIRECT = 1'b0;
    parameter COMPLETE = 1'b1;
    always_ff @ (posedge clk) begin : redirect_complete_detect
        if (reset || flush_sign) begin
            ROB_redirect_state <= COMPLETE;
        end
        else begin
            case (ROB_redirect_state)
                COMPLETE : begin
                    if (redirect) begin
                        ROB_redirect_state <= REDIRECT;
                    end
                end
                REDIRECT : begin
                    if (empty) begin
                        ROB_redirect_state <= COMPLETE;
                    end
                end
            endcase
        end
    end

    // logic csr_decrease_en;
    // logic csr_cnt;
    // assign csr_decrease_en = (dequeue_en[0] && dequeue_data[0].csr_we) || (dequeue_en[1] && dequeue_data[1].csr_we);
    // always_ff @ (posedge clk) begin : csr_cnt_update
    //     if (reset || flush_sign) begin
    //         csr_cnt <= 1'b0;
    //     end
    //     else begin
    //         if (csr_increase_en) begin
    //             csr_cnt <= csr_cnt + 1;
    //         end
    //         if (csr_decrease_en) begin
    //             csr_cnt <= csr_cnt - 1;
    //         end
    //     end
    // end
    // assign csr_pause = (csr_cnt != 0);



endmodule
