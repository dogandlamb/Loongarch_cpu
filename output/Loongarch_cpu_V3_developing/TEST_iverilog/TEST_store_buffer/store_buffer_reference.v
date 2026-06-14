// ============================================================
// store_buffer 模块（提交后写缓冲，`SB_SIZE=8 项 FIFO）
// ------------------------------------------------------------
// 参考实现说明：
// - 8 项环形 FIFO：commit 提交 store 入队（≤1 条/拍），head 项按序写出
//   DCache（req 保持至 addr_ok，done 后出队）—— 绝不乱序；
// - load 前递（组合）：按字地址比较全部有效项，选最年轻命中项：
//   整字（strb==4'hf）且 cached -> hit 前递；其余命中 -> partial（等排空）；
// - 全局冲刷【不清空】本缓冲（全部是已提交 store）；只有复位才清；
// - sb_empty 严格：无有效项即空（项在 done 前保持 valid，覆盖在途写）。
// ============================================================
`include "mycpu.h"

module store_buffer(
    input  wire                clk,
    input  wire                reset,

    // ---------------- 提交入队（来自 commit）----------------
    input  wire                push_valid_i,
    input  wire [31:0]         push_paddr_i,
    input  wire [31:0]         push_data_i,       // 已按地址对齐到字节通道
    input  wire [3:0]          push_wstrb_i,
    input  wire [2:0]          push_size_i,       // AXI size（uncached 精确宽度用）
    input  wire                push_uncached_i,
    output wire                sb_full_o,         // 满（commit 暂停提交 store）
    output wire                sb_empty_o,        // 空（屏障/uncached load 等待用）

    // ---------------- 排空写出口（连 dcache 的 store 写口）----------------
    output wire                dc_wr_req_o,       // 写请求（保持至 addr_ok）
    output wire [31:0]         dc_wr_paddr_o,
    output wire [31:0]         dc_wr_data_o,
    output wire [3:0]          dc_wr_strb_o,
    output wire [2:0]          dc_wr_size_o,
    output wire                dc_wr_uncached_o,
    input  wire                dc_wr_addr_ok_i,   // DCache 收下
    input  wire                dc_wr_done_i,      // 写完成（cached 写命中可当拍/次拍完成）

    // ---------------- load 前递查询口（LSU，组合）----------------
    input  wire [31:0]         query_paddr_i,
    output wire                query_hit_o,       // 整字（4 字节）全部可由 SB 提供
    output wire [31:0]         query_data_o,      // 前递数据（多项命中取最年轻）
    output wire                query_partial_o    // 部分字节命中（load 须等排空）
);

reg [`SB_SIZE-1:0] valid;
reg [31:0]         e_paddr [0:`SB_SIZE-1];
reg [31:0]         e_data  [0:`SB_SIZE-1];
reg [3:0]          e_strb  [0:`SB_SIZE-1];
reg [2:0]          e_size  [0:`SB_SIZE-1];
reg                e_unc   [0:`SB_SIZE-1];
reg [`SB_W-1:0]    head, tail;
reg [`SB_W:0]      count;
reg                inflight;     // head 项已被 DCache 收下、等待 done

assign sb_full_o  = (count == `SB_SIZE);
assign sb_empty_o = (count == 0);

// ---------------- 排空写出 ----------------
assign dc_wr_req_o      = valid[head] && !inflight;
assign dc_wr_paddr_o    = e_paddr[head];
assign dc_wr_data_o     = e_data[head];
assign dc_wr_strb_o     = e_strb[head];
assign dc_wr_size_o     = e_size[head];
assign dc_wr_uncached_o = e_unc[head];

wire do_push = push_valid_i && !sb_full_o;
wire do_pop  = dc_wr_done_i && valid[head];

always @(posedge clk) begin
    if (reset) begin
        valid    <= {`SB_SIZE{1'b0}};
        head     <= {`SB_W{1'b0}};
        tail     <= {`SB_W{1'b0}};
        count    <= {(`SB_W+1){1'b0}};
        inflight <= 1'b0;
    end else begin
        if (dc_wr_req_o && dc_wr_addr_ok_i) inflight <= 1'b1;
        if (do_pop) begin
            valid[head] <= 1'b0;
            head        <= head + 1'b1;
            inflight    <= 1'b0;
        end
        if (do_push) begin
            valid[tail]   <= 1'b1;
            e_paddr[tail] <= push_paddr_i;
            e_data[tail]  <= push_data_i;
            e_strb[tail]  <= push_wstrb_i;
            e_size[tail]  <= push_size_i;
            e_unc[tail]   <= push_uncached_i;
            tail          <= tail + 1'b1;
        end
        count <= count + {{`SB_W{1'b0}}, do_push} - {{`SB_W{1'b0}}, do_pop};
    end
end

// ---------------- 前递查询（组合：从最年轻往最老找第一个命中）----------------
// 距 tail-1 偏移 k（k=0 最年轻），实际索引 idx = tail-1-k
reg        q_found;
reg        q_full_word;
reg [31:0] q_data;
integer qi;
reg [`SB_W-1:0] q_idx;
always @(*) begin
    q_found     = 1'b0;
    q_full_word = 1'b0;
    q_data      = 32'b0;
    for (qi = 0; qi < `SB_SIZE; qi = qi + 1) begin
        q_idx = tail - 1'b1 - qi[`SB_W-1:0];
        if (!q_found && valid[q_idx]
            && (e_paddr[q_idx][31:2] == query_paddr_i[31:2])) begin
            q_found     = 1'b1;
            q_full_word = (e_strb[q_idx] == 4'hf) && !e_unc[q_idx];
            q_data      = e_data[q_idx];
        end
    end
end

// 设备写序约定：只要缓冲内还有未写出的 uncached store，任何 load 查询都报
// partial（强制等排空）——保证"写设备寄存器 -> 读设备状态"的全局顺序。
reg any_unc;
integer ui;
always @(*) begin
    any_unc = 1'b0;
    for (ui = 0; ui < `SB_SIZE; ui = ui + 1) begin
        if (valid[ui] && e_unc[ui]) any_unc = 1'b1;
    end
end

assign query_hit_o     = q_found && q_full_word && !any_unc;
assign query_data_o    = q_data;
assign query_partial_o = (q_found && !q_full_word) || any_unc;

endmodule
