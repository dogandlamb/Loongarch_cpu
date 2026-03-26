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
    output wire [31:0] nextpc
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
// 分支重定向优先于 block；否则 block 时保持当前 pc，避免组合自反馈导致 nextpc 变成 X
assign nextpc = br_taken ? br_target : (block_sig ? pc : seq_pc);//每个指令占32位，四个字节
assign br_target = (br_op[4]) ? (rj_value + br_offs) : (pc + br_offs);//jirl跳转指定地址，其它转到偏移量

endmodule