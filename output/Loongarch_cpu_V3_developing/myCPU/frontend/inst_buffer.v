`include "mycpu.h"

module inst_buffer(
    input  wire                       clk,
    input  wire                       reset,
    input  wire                       flush_i,

    input  wire                       push0_valid_i,
    input  wire [31:0]                push0_pc_i,
    input  wire [31:0]                push0_inst_i,
    input  wire                       push0_pred_taken_i,
    input  wire                       push0_is_last_i,
    input  wire [`FTQ_W-1:0]          push0_ftq_id_i,
    input  wire [`EXCP_NUM-1:0]       push0_excp_i,

    input  wire                       push1_valid_i,
    input  wire [31:0]                push1_pc_i,
    input  wire [31:0]                push1_inst_i,
    input  wire                       push1_pred_taken_i,
    input  wire                       push1_is_last_i,
    input  wire [`FTQ_W-1:0]          push1_ftq_id_i,
    input  wire [`EXCP_NUM-1:0]       push1_excp_i,

    input  wire                       push2_valid_i,
    input  wire [31:0]                push2_pc_i,
    input  wire [31:0]                push2_inst_i,
    input  wire                       push2_pred_taken_i,
    input  wire                       push2_is_last_i,
    input  wire [`FTQ_W-1:0]          push2_ftq_id_i,
    input  wire [`EXCP_NUM-1:0]       push2_excp_i,

    input  wire                       push3_valid_i,
    input  wire [31:0]                push3_pc_i,
    input  wire [31:0]                push3_inst_i,
    input  wire                       push3_pred_taken_i,
    input  wire                       push3_is_last_i,
    input  wire [`FTQ_W-1:0]          push3_ftq_id_i,
    input  wire [`EXCP_NUM-1:0]       push3_excp_i,

    output wire                       can_push_o,

    output wire                       pop0_valid_o,
    output wire [31:0]                pop0_pc_o,
    output wire [31:0]                pop0_inst_o,
    output wire                       pop0_pred_taken_o,
    output wire                       pop0_is_last_o,
    output wire [`FTQ_W-1:0]          pop0_ftq_id_o,
    output wire [`EXCP_NUM-1:0]       pop0_excp_o,
    input  wire                       pop0_ready_i,

    output wire                       pop1_valid_o,
    output wire [31:0]                pop1_pc_o,
    output wire [31:0]                pop1_inst_o,
    output wire                       pop1_pred_taken_o,
    output wire                       pop1_is_last_o,
    output wire [`FTQ_W-1:0]          pop1_ftq_id_o,
    output wire [`EXCP_NUM-1:0]       pop1_excp_o,
    input  wire                       pop1_ready_i
);

localparam ENTRY_W = `EXCP_NUM + `FTQ_W + 1 + 1 + 32 + 32;

reg [ENTRY_W-1:0] mem [0:`IB_SIZE-1];
reg [`IB_W-1:0]   head;
reg [`IB_W-1:0]   tail;
reg [`IB_W:0]     count;

reg [ENTRY_W-1:0] pop0_entry_r;
reg [ENTRY_W-1:0] pop1_entry_r;
reg               pop0_valid_r;
reg               pop1_valid_r;

wire [ENTRY_W-1:0] push0_entry = {push0_excp_i, push0_ftq_id_i, push0_is_last_i,
                                  push0_pred_taken_i, push0_inst_i, push0_pc_i};
wire [ENTRY_W-1:0] push1_entry = {push1_excp_i, push1_ftq_id_i, push1_is_last_i,
                                  push1_pred_taken_i, push1_inst_i, push1_pc_i};
wire [ENTRY_W-1:0] push2_entry = {push2_excp_i, push2_ftq_id_i, push2_is_last_i,
                                  push2_pred_taken_i, push2_inst_i, push2_pc_i};
wire [ENTRY_W-1:0] push3_entry = {push3_excp_i, push3_ftq_id_i, push3_is_last_i,
                                  push3_pred_taken_i, push3_inst_i, push3_pc_i};

wire [2:0] push_n = {2'b0, push0_valid_i} + {2'b0, push1_valid_i}
                  + {2'b0, push2_valid_i} + {2'b0, push3_valid_i};
wire pop0_fire = pop0_ready_i && pop0_valid_r;
wire pop1_fire = pop0_fire && pop1_ready_i && pop1_valid_r;
wire [1:0] pop_n = {1'b0, pop0_fire} + {1'b0, pop1_fire};

assign can_push_o = (count + {2'b0, push_n}) <= `IB_SIZE;

wire [`IB_W-1:0] head_plus1 = head + {{(`IB_W-1){1'b0}}, 1'b1};
wire [`IB_W-1:0] tail_plus1 = tail + {{(`IB_W-1){1'b0}}, 1'b1};
wire [`IB_W-1:0] tail_plus2 = tail + {{(`IB_W-2){1'b0}}, 2'd2};
wire [`IB_W-1:0] tail_plus3 = tail + {{(`IB_W-2){1'b0}}, 2'd3};

assign {pop0_excp_o, pop0_ftq_id_o, pop0_is_last_o, pop0_pred_taken_o,
        pop0_inst_o, pop0_pc_o} = pop0_entry_r;
assign {pop1_excp_o, pop1_ftq_id_o, pop1_is_last_o, pop1_pred_taken_o,
        pop1_inst_o, pop1_pc_o} = pop1_entry_r;
assign pop0_valid_o = pop0_valid_r;
assign pop1_valid_o = pop1_valid_r;

integer i;
initial begin
    head = {`IB_W{1'b0}};
    tail = {`IB_W{1'b0}};
    count = {(`IB_W+1){1'b0}};
    pop0_entry_r = {ENTRY_W{1'b0}};
    pop1_entry_r = {ENTRY_W{1'b0}};
    pop0_valid_r = 1'b0;
    pop1_valid_r = 1'b0;
    for (i = 0; i < `IB_SIZE; i = i + 1)
        mem[i] = {ENTRY_W{1'b0}};
end

always @(posedge clk or posedge reset or posedge flush_i) begin
    if (reset || flush_i) begin
        head <= {`IB_W{1'b0}};
        tail <= {`IB_W{1'b0}};
        count <= {(`IB_W+1){1'b0}};
        pop0_entry_r <= {ENTRY_W{1'b0}};
        pop1_entry_r <= {ENTRY_W{1'b0}};
        pop0_valid_r <= 1'b0;
        pop1_valid_r <= 1'b0;
    end else begin
        pop0_entry_r <= mem[head];
        pop1_entry_r <= mem[head_plus1];
        pop0_valid_r <= (count != {(`IB_W+1){1'b0}});
        pop1_valid_r <= (count >= {{(`IB_W-1){1'b0}}, 2'd2});

        if (can_push_o) begin
            if (push0_valid_i) mem[tail]      <= push0_entry;
            if (push1_valid_i) mem[tail_plus1] <= push1_entry;
            if (push2_valid_i) mem[tail_plus2] <= push2_entry;
            if (push3_valid_i) mem[tail_plus3] <= push3_entry;
            tail <= tail + push_n[`IB_W-1:0];
        end

        head <= head + {{(`IB_W-2){1'b0}}, pop_n};
        count <= count + (can_push_o ? {2'b0, push_n} : {(`IB_W+1){1'b0}})
                       - {{(`IB_W-1){1'b0}}, pop_n};
    end
end

endmodule
