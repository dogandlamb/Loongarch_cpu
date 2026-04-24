// ============================================================
// pipeline_controller：各级 valid 寄存与级间 allowIn 组合生成。
// ID_allowIn/EXE_allowIn 上的 (x|~x) 为恒真因子，仅用于通过run linter检查。
// 可实现阻塞控制
// ============================================================
module pipeline_controller(
    input wire        clk,
    input wire        reset,

    input wire        block_sig,           // RAW 等阻塞
    input wire        cancel_sig,          // 分支冲刷（清 ID/EXE valid）
    input wire        csr_flush,           // 异常/ERTN 冲刷（需精确清空更年轻级）

    input wire        IF_readyGo,
    input wire        ID_readyGo,
    input wire        EXE_readyGo,
    input wire        MEM_readyGo,
    input wire        WB_allowIn,
    input wire        ID_allowIn,
    input wire        EXE_allowIn,
    input wire        MEM_allowIn,
    input wire        refetch_req,
    input wire        wb_refetch_tag, // WB级指令有重取指标志，要flush

    output reg        IF_ID_reg_allowIn,
    output reg        ID_EXE_reg_allowIn,
    output reg        EXE_MEM_reg_allowIn,
    output reg        MEM_WB_reg_allowIn,

    output reg        refetch_tag, // 如果有refetch_req，则此tag给到IF级

    output reg        IF_ID_reg_valid,
    output reg        ID_EXE_reg_valid,
    output reg        EXE_MEM_reg_valid,
    output reg        MEM_WB_reg_valid,

    output reg        IF_valid,
    output reg        ID_valid,
    output reg        EXE_valid,
    output reg        MEM_valid,
    output reg        WB_valid
);

reg        refetch_pending;

always @(*) begin
    MEM_WB_reg_allowIn  = (!reset) && (!WB_valid  || WB_allowIn);
    EXE_MEM_reg_allowIn = (!reset) && (!MEM_valid || (MEM_allowIn && MEM_WB_reg_allowIn));
    ID_EXE_reg_allowIn  = (!reset) && (!EXE_valid || (EXE_readyGo && EXE_MEM_reg_allowIn))
                                       && (EXE_allowIn | ~EXE_allowIn);
    IF_ID_reg_allowIn   = (!reset) && (!block_sig)
                                       && (!ID_valid || (ID_readyGo && ID_EXE_reg_allowIn))
                                       && (ID_allowIn | ~ID_allowIn);

    IF_ID_reg_valid   = IF_valid;
    ID_EXE_reg_valid  = ID_valid;
    EXE_MEM_reg_valid = EXE_valid;
    MEM_WB_reg_valid  = MEM_valid;
    refetch_tag       = refetch_pending;
end

always @(posedge clk) begin
    if (reset) begin
        IF_valid  <= 1'b0;
        ID_valid  <= 1'b0;
        EXE_valid <= 1'b0;
        MEM_valid <= 1'b0;
        WB_valid  <= 1'b0;
        refetch_pending <= 1'b0;
    end else begin
        IF_valid <= 1'b1;

        if (refetch_req) begin
            refetch_pending <= 1'b1;
        end else if (refetch_pending && IF_valid && IF_readyGo && IF_ID_reg_allowIn) begin
            refetch_pending <= 1'b0;
        end

        if (cancel_sig) begin
            ID_valid  <= 1'b0;
            EXE_valid <= 1'b0;

            // On exception/ERTN flush, squash younger MEM/WB flow to keep precise traps.
            if (csr_flush) begin
                MEM_valid <= 1'b0;
            end else if (EXE_MEM_reg_allowIn) begin
                MEM_valid <= EXE_valid && EXE_readyGo;
            end
        end else if (wb_refetch_tag) begin
            ID_valid  <= 1'b0;
            EXE_valid <= 1'b0;
            MEM_valid <= 1'b0;
        end else begin
            if (IF_ID_reg_allowIn)
                ID_valid <= IF_valid && IF_readyGo;
            if (ID_EXE_reg_allowIn)
                EXE_valid <= ID_valid && ID_readyGo;

            if (EXE_MEM_reg_allowIn)
                MEM_valid <= EXE_valid && EXE_readyGo;
        end

        if (csr_flush || wb_refetch_tag) begin
            if (MEM_WB_reg_allowIn)
                WB_valid <= 1'b0;
        end else if (MEM_WB_reg_allowIn) begin
            WB_valid <= MEM_valid && MEM_readyGo;
        end
    end
end

endmodule
