// ============================================================
// 模块功能：
// 下一 PC 组合逻辑。根据分支命中与阻塞信号选择 nextpc：
// - 分支命中：nextpc = br_target；
// - 非分支且阻塞：nextpc = pc（保持）；
// - 非分支且不阻塞：nextpc = pc + 4。
//
// 端口定义：
// - valid    ：前端有效标志（当前版本仅保留接口）。
// - br_taken ：分支是否命中（来自 EXE）。
// - br_op    ：分支类型编码（jirl/b/bl/beq/bne）。
// - br_offs  ：分支偏移量。
// - rj_value ：jirl 基址寄存器值。
// - pc       ：当前基准 PC。
// - block_sig：阻塞信号。
// - nextpc   ：组合计算得到的下一 PC。
//
// 与 top 的联系：
// - 在 `mycpu_top` 中由 EXE 分支信息驱动，输出喂给 `pc` 模块。
// ============================================================
module npc(
    input  wire        valid,
    input  wire        br_taken,
    input  wire [ 4:0] br_op,
    input  wire [31:0] br_offs,
    input  wire [31:0] rj_value,
    input  wire [31:0] pc,
    input  wire        block_sig,
    output reg  [31:0] nextpc
);

//分支跳转
wire [31:0] br_target;//跳转的目标地址
wire [31:0] seq_pc;//pc+4的值，顺序执行时的下一条指令地址



/////////////////////////////////////////////////////////////////////
//EX:分支跳转地址的计算
//寄存器读地址和写地址的生成
//br_op = {inst_jirl , inst_b , inst_bl , inst_beq , inst_bne};

//下一指令地址赋值
assign seq_pc = pc + 32'h4;
assign br_target = br_op[`BR_OP_JIRL] ? (rj_value + br_offs) : (pc + br_offs);//jirl使用寄存器基址，其它分支使用pc相对偏移

// 对控制信号中的 X 做容错，避免 nextpc 在复位释放阶段被污染成 X
always @(*) begin
    nextpc = seq_pc;
    if (br_taken === 1'b1) begin
        nextpc = br_target;
    end
    else if (block_sig === 1'b1) begin
        nextpc = pc;
    end
end

endmodule