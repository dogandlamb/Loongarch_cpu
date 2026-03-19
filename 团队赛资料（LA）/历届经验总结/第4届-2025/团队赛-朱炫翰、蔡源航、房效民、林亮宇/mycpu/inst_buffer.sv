module inst_buffer #(
    parameter DATA_WIDTH = 32, // 数据宽度
    parameter DEPTH = 16, // 队列长度
    parameter FETCH_WIDTH = 4,
    parameter INST_BUF_PTR = 4
) (
    input logic clk,
    input logic reset,

    input logic flush, // 队列清空
    input logic redirect, // 分支预测错误清空队列

    input logic [FETCH_WIDTH-1:0] enqueue_en, // 入队使能
    input logic [FETCH_WIDTH-1:0][DATA_WIDTH - 1:0] enqueue_data, // 入队数据

    input logic [$clog2(FETCH_WIDTH+1)-1:0] enqueue_length,
    input logic [$clog2(FETCH_WIDTH+1)-1:0] instr_buffer_length,

    input logic [1:0] dequeue_en, // 出队使能
    output logic [1:0][DATA_WIDTH - 1:0] dequeue_data, // 出队数据

    output logic full, // 队列满
    output logic one_left,
    output logic empty // 队列空
);

    (* ram_style = "distributed" *) logic [DATA_WIDTH - 1:0] IB[DEPTH-1: 0]; // 存储队列数据

    logic [$clog2(DEPTH) - 1:0] head; // 队列头
    logic [$clog2(DEPTH) - 1:0] tail; // 队列尾

    logic [$clog2(DEPTH) - 1:0] head_plus; // 队列头+1
    logic [$clog2(DEPTH) - 1:0] tail_plus; // 队列尾+1

    always_ff @(posedge clk) begin : tail_update
        if (reset || flush || redirect) begin
            tail <= 0;
            tail_plus <= 1;
        end
        else begin
            tail <= INST_BUF_PTR'(tail + enqueue_length);
            tail_plus <= INST_BUF_PTR'(tail_plus + enqueue_length);
        end
    end

    // always_ff @(posedge clk) begin : tail_update
    //     if (reset || flush || redirect) begin
    //         tail <= 0;
    //         tail_plus <= 1;
    //     end else if (&enqueue_en) begin // 两条指令入队
    //         tail <= tail + 2;
    //         tail_plus <= tail_plus + 2;
    //     end else if (|enqueue_en) begin // 一条指令入队，但什么情况下是只有一条指令入队呢？1.队列只有一个空位？
    //         tail <= tail + 1;
    //         tail_plus <= tail_plus + 1;
    //     end
    // end

    always_ff @(posedge clk) begin : enqueue
        if (enqueue_en[0]) begin
            IB[tail] <= enqueue_data[0];
        end
        if (enqueue_en[1]) begin
            IB[INST_BUF_PTR'(tail + 1)] <= enqueue_data[1];
        end
        if (enqueue_en[2]) begin
            IB[INST_BUF_PTR'(tail + 2)] <= enqueue_data[2];
        end
        if (enqueue_en[3]) begin
            IB[INST_BUF_PTR'(tail + 3)] <= enqueue_data[3];
        end
    end

    // always_ff @(posedge clk) begin : enqueue
    //     if (&enqueue_en) begin
    //         IB[tail] <= enqueue_data[0];
    //         IB[tail_plus] <= enqueue_data[1];
    //     end else if (enqueue_en[0]) begin
    //         IB[tail] <= enqueue_data[0];
    //     end else if (enqueue_en[1]) begin
    //         IB[tail] <= enqueue_data[1];
    //     end
    // end

    always_ff @(posedge clk) begin : head_update
        if (reset || flush || redirect) begin
            head <= 0;
            head_plus <= 1;
        end else if (&dequeue_en && !empty) begin
            head <= INST_BUF_PTR'(head + 2);
            head_plus <= INST_BUF_PTR'(head_plus + 2);
        end else if (|dequeue_en && !empty) begin
            head <= INST_BUF_PTR'(head + 1);
            head_plus <= INST_BUF_PTR'(head_plus + 1);
        end
    end

    // dequeue，读是组合逻辑
    assign dequeue_data[0] = IB[head];
    assign dequeue_data[1] = IB[head_plus];
    // // 至少保证有4个位置空余
    // assign full = (head == INST_BUF_PTR'(tail_plus + 3)) || (head == INST_BUF_PTR'(tail_plus + 2)) || (head == INST_BUF_PTR'(tail_plus + 1)) || (head == tail_plus);

    always_comb begin
        unique case (instr_buffer_length)
            1 :         full = (head == tail_plus);
            2 :         full = (head == INST_BUF_PTR'(tail_plus + 1)) || (head == tail_plus);
            3 :         full = (head == INST_BUF_PTR'(tail_plus + 2)) || (head == INST_BUF_PTR'(tail_plus + 1)) || (head == tail_plus);
            default :   full = (head == INST_BUF_PTR'(tail_plus + 3)) || (head == INST_BUF_PTR'(tail_plus + 2)) || (head == INST_BUF_PTR'(tail_plus + 1)) || (head == tail_plus);
        endcase
    end

    assign empty = (head == tail); // 保证至少有两个指令
    assign one_left = (head_plus == tail);

endmodule
