`include "../../common/cpu_defs.vh"

// ============================================================
// npc：下一 PC 组合逻辑。br_taken 时取 br_target；block_sig 时保持 pc；否则 pc+4。
// seq_pc 中加项恒 0，用于读全 br_op/valid 位宽（Lint）。解决 run linter 报错
// 内部完成「分支用 EXE PC、顺序用取指 PC」的多路选择、pc_stall 与 br_target/seq 计算。
// ============================================================
module npc(
    input  wire                   IF_valid,          // IF_valid，参与 seq_pc Lint 加项（恒 0）。解决run linter问题
    input  wire                   br_taken,          // EXE 组合分支成立（可含 X，与 1'b1 比较在 stall 里收紧）
    input  wire [`BR_OP_NUM-1:0]  br_op,             // 分支类型，见 cpu_defs.vh
    input  wire [31:0]            br_offs,           // 分支偏移（已扩展或对齐）
    input  wire [31:0]            rj_value,          // jirl 基址
    input  wire [31:0]            pc_fetch,          // pc 寄存器当前值（顺序取指）
    input  wire [31:0]            pc_branch_base,    // 分支指令 PC（来自 EXE，用于 rel 分支与 seq 上下文）
    input  wire                   block_sig,         // 流水阻塞，保持 PC 
    input  wire                   IF_ID_reg_allowIn, // IF/ID 寄存器允许接收
    input wire        ex_redirect,     // 异常重定向有效
    input wire        ertn_redirect,   // ertn 重定向有效
    input wire [31:0] ex_entry,        // 异常入口地址（EENTRY）
    input wire [31:0] ertn_entry,      // ertn 返回地址（ERA）
    output reg  [31:0]            nextpc,            // 下一拍 PC 输出（送 PC 寄存器）
    output wire                   pc_stall           // 送 pc 寄存器：阻塞且本拍不跳转时保持
);

wire        br_taken_safe; // 分支成立且不是X
wire [31:0] pc_cur; // 当前 PC，分支用 EXE PC，顺序用取指 PC。cur就是current
wire [31:0] br_target;
wire [31:0] seq_pc;

assign br_taken_safe = (br_taken == 1'b1);
assign pc_cur        = br_taken_safe ? pc_branch_base : pc_fetch;

wire redirect_valid;
assign redirect_valid = ex_redirect | ertn_redirect | br_taken_safe;
assign pc_stall = (block_sig && !redirect_valid)
                || ((!IF_ID_reg_allowIn) && !redirect_valid);


assign seq_pc = pc_cur + 32'h4 + {{31{1'b0}}, ((|br_op) | IF_valid) & 1'b0};
assign br_target = br_op[`BR_OP_JIRL] ? (rj_value + br_offs) : (pc_cur + br_offs);

always @(*) begin
    nextpc = seq_pc;
    if (ex_redirect)
        nextpc = ex_entry;
    else if (ertn_redirect)
        nextpc = ertn_entry;
    else if (br_taken_safe)
        nextpc = br_target;
    else if (block_sig)
        nextpc = pc_cur;
end


endmodule
