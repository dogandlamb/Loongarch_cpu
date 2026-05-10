module issue_queue #(
    parameter DATA_WIDTH = 32, // 数据宽度
    parameter DEPTH = 8 // 队列长度
) (
    input logic clk,
    input logic reset,

    input logic flush, // 队列清空
    input logic redirect, // 分支预测错误清空队列

    input logic [1:0] enqueue_en, // 入队使能
    input logic [1:0][DATA_WIDTH - 1:0] enqueue_data, // 入队数据

    input logic [1:0] dequeue_en, // 出队使能
    output logic [1:0][DATA_WIDTH - 1:0] dequeue_data, // 出队数据

    output logic full, // 队列满
    output logic one_left, // 队列中只有一个元素
    output logic empty // 队列空
);

    (* ram_style = "distributed" *)logic [DATA_WIDTH - 1:0] IQ[DEPTH-1: 0]; // 存储队列数据

    logic [$clog2(DEPTH) - 1:0] head; // 队列头
    logic [$clog2(DEPTH) - 1:0] tail; // 队列尾

    logic [$clog2(DEPTH) - 1:0] head_plus; // 队列头+1
    logic [$clog2(DEPTH) - 1:0] tail_plus; // 队列尾+1

    always_ff @(posedge clk) begin : tail_update
        if (reset || flush || redirect) begin
            tail <= 0;
            tail_plus <= 1;
        end else if (&enqueue_en) begin // 两条指令入队
            tail <= tail + 2;
            tail_plus <= tail_plus + 2;
        end else if (|enqueue_en) begin // 一条指令入队，但什么情况下是只有一条指令入队呢？1.队列只有一个空位？
            tail <= tail + 1;
            tail_plus <= tail_plus + 1;
        end
    end

    always_ff @(posedge clk) begin : enqueue
        if (&enqueue_en) begin
            IQ[tail] <= enqueue_data[0];
            IQ[tail_plus] <= enqueue_data[1];
        end else if (enqueue_en[0]) begin
            IQ[tail] <= enqueue_data[0];
        end else if (enqueue_en[1]) begin
            IQ[tail] <= enqueue_data[1];
        end
    end

    always_ff @(posedge clk) begin : head_update
        if (reset || flush || redirect) begin
            head <= 0;
            head_plus <= 1;
        end else if (&dequeue_en && !empty) begin
            head <= head + 2;
            head_plus <= head_plus + 2;
        end else if (|dequeue_en && !empty) begin
            head <= head + 1;
            head_plus <= head_plus + 1;
        end
    end

    // dequeue，读是组合逻辑
    assign dequeue_data[0] = IQ[head];
    assign dequeue_data[1] = IQ[head_plus];

    assign full = (head == 3'(tail_plus + 1)) || (head == tail_plus);
    assign empty = (head == tail);
    assign one_left = (head_plus == tail);

endmodule
