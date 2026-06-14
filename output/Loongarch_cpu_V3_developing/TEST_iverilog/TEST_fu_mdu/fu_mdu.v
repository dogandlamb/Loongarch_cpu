// ============================================================
// fu_mdu 模块（乘除/CSR读/rdcnt/TLB维护打包 杂项执行单元，多周期非流水）
// ------------------------------------------------------------
// 功能：
// - 处理低频/多周期/需要特殊端口的指令（mariver 哲学："脏活累活都给 MDU 干"）：
//   * 乘法 mul/mulh/mulh_u    ：例化 mul.v（DSP 流水，2~3 拍）
//   * 除法 div/div_u/mod/mod_u：例化 div.v（CLZ 快速除法，常见 5~10 拍）
//   * CSR 类 csrrd/csrwr/csrxchg：读 CSR 旧值作为写回结果（rd <- old CSR）；
//     csrwr/csrxchg 同时把"要写入 CSR 的新值"算好放 result2（提交时真正写入）
//   * rdcntvl/rdcntvh/rdcntid ：读 64 位稳定计数器/TID
//   * invtlb：把 asid（src0[9:0]）与 va 的 vppn（src1[31:13]）打包进 result2，
//     提交级取出执行 TLB 无效化（TLB 真正落地永远在提交级）
//   * tlbsrch/tlbrd/tlbwr/tlbfill：执行级无事可做，直接标完成（提交级落地）
// - 非流水：同时只处理一条（busy 反压 rs_mdu）。
//
// 端口：
// - issue_*       ：rs_mdu 发射口直连
// - mdu_ready_o   ：空闲可接收
// - csr_raddr/rdata：CSR 读口（连 csr_exception_commit_handler 的读端口，组合）
// - timer_64_i / csr_tid_i ：稳定计数器与 TID（rdcnt 用）
// - wb_*          ：写回 ROB（data=写回值，data2=CSR新值/invtlb打包）
// ============================================================
`include "mycpu.h"

module fu_mdu(
    input  wire                       clk,
    input  wire                       reset,
    input  wire                       flush_i,

    // ---------------- 发射入口（来自 rs_mdu）----------------
    input  wire                       issue_valid_i,
    input  wire [`ROB_W-1:0]          issue_robid_i,
    input  wire [`ALU_OP_NUM-1:0]     issue_alu_op_i,     // 乘除位有效
    input  wire [`CSR_OP_NUM-1:0]     issue_csr_op_i,
    input  wire [13:0]                issue_csr_num_i,
    input  wire [`TLB_OP_NUM-1:0]     issue_tlb_op_i,
    input  wire [`WB_SRC_NUM-1:0]     issue_wb_src_op_i,  // rdcnt 类选择
    input  wire [31:0]                issue_src0_i,       // rj 值
    input  wire [31:0]                issue_src1_i,       // rk/rd 值
    output wire                       mdu_ready_o,        // 空闲（rs_mdu 发射条件）

    // ---------------- CSR 读口（组合读 csr handler）----------------
    output wire [13:0]                csr_raddr_o,
    input  wire [31:0]                csr_rdata_i,

    // ---------------- 计时器 ----------------
    input  wire [63:0]                timer_64_i,
    input  wire [31:0]                csr_tid_i,

    // ---------------- 写回 ROB ----------------
    output wire                       wb_valid_o,
    output wire [`ROB_W-1:0]          wb_robid_o,
    output wire [31:0]                wb_data_o,          // 写回 rd 的值
    output wire [31:0]                wb_data2_o          // CSR 新值 / invtlb {asid,vppn} 打包
);

//TODO: 实现多周期杂项单元（参考：mariver fu_mdu.v 的"指令分类处理"组织方式）
//
//TODO: 状态机骨架：
//      IDLE：issue_valid_i 且 IDLE -> 锁存全部发射信息，按类型分派：
//        - 乘法 -> 启动 mul.v，进入 BUSY 等 done（2~3 拍）
//        - 除法 -> 启动 div.v，进入 BUSY 等 done（CLZ 优化后小操作数约 5 拍）
//        - CSR/rdcnt/TLB 类 -> 单拍完成（下一拍即可写回）
//      BUSY：等 done -> 写回拍输出 wb_*，回 IDLE。
//      mdu_ready_o = (state==IDLE)；flush_i 时强制回 IDLE 并丢弃结果
//      （除法器内部也要能被 flush 打断，见 div.v 的 flush 口）。
//
//TODO: 各类指令的写回值（wb_data_o）与第二数据（wb_data2_o）：
//      mul_w    ：乘积低 32 位        mulh_w/wu：乘积高 32 位
//      div_w/wu ：商                  mod_w/wu ：余数
//      csrrd    ：CSR 旧值（csr_raddr_o=issue_csr_num_i 组合读）；data2 无用
//      csrwr    ：CSR 旧值；data2 = src1（rd 的值 = 新值）
//      csrxchg  ：CSR 旧值；data2 = (old & ~src0) | (src1 & src0)
//                 （mask=rj=src0，写值=rd=src1，新值在执行级算好，
//                   提交级直接把 data2 写进 CSR，csr handler 的 wmask 给全 1）
//      rdcntvl/vh：timer_64_i 低/高 32 位     rdcntid：csr_tid_i
//      invtlb   ：data 无用；data2 = {13'b0, src0[9:0], 19'b0} 不对——
//                 打包格式建议 data2 = {src1[31:13], 3'b0, src0[9:0]}
//                 即 {vppn(19bit), pad(3bit), asid(10bit)}，提交级按此解包。
//      tlbsrch/tlbrd/tlbwr/tlbfill：执行级直接完成（data/data2 无用），
//                 提交级用 tlb_op（存于 ROB 静态字段 priv/csr_num 路径）落地。
//
//TODO: CSR 读的"旧值"语义说明（为什么这样做是对的）：
//      csrwr/csrxchg 提交时会 FLUSH_REFETCH，且所有 CSR 写都发生在提交级——
//      因此本指令执行时读到的 CSR 值一定是"程序序上正确的旧值"
//      （前面的 CSR 写指令要么已提交生效、要么会先冲刷掉本指令重新执行）。
//
//TODO: 坑点提示：
//      1. 乘法建议 DSP 流水（mul.v），除法建议 CLZ 快速除法（div.v），
//         两者并行例化、按 op 启动其一。
//      2. flush 时若除法器还在迭代必须打断（div.v 有 flush_i），否则下一条
//         除法进来时状态机错乱。
//      3. 一期可把乘除先用旧 alu.v 里的 IP 方案顶上（mult_gen/div_gen），
//         先全流程跑通，再换自研 mul/div 提性能。

endmodule
