`timescale 1ns/1ps
`include "mycpu.h"
`include "tb_macros.vh"
// ============================================================
// l1_tlb 单元测试：
// 1. miss 透传主表结果（found/ppn/属性原样）
// 2. 回填后命中：主表结果改变但微表未 fence，仍返回缓存副本（缓存语义）
// 3. fence 整表失效：重新跟随主表
// 4. 大页（ps!=12）不回填：主表结果变化立即可见
// 5. dis_refill 拍不回填
// ============================================================
module l1_tlb_tb;
  reg clk, reset;
  reg fence_i, dis_refill_i;
  reg req_valid_i;
  reg [31:0] vaddr_i;
  wire found_o;
  wire [19:0] ppn_o;
  wire [5:0]  ps_o;
  wire [1:0]  mat_o;
  wire v_o, d_o;
  wire [1:0]  plv_o;
  wire [18:0] tlb_vppn_o;
  wire tlb_va_bit12_o;
  // 行为级"主表"：由 TB 直接驱动
  reg         tlb_found_i;
  reg [19:0]  tlb_ppn_i;
  reg [5:0]   tlb_ps_i;
  reg [1:0]   tlb_mat_i;
  reg         tlb_v_i, tlb_d_i;
  reg [1:0]   tlb_plv_i;

  l1_tlb #(.ENTRY_NUM(8)) uut(
    .clk(clk), .reset(reset),
    .fence_i(fence_i), .dis_refill_i(dis_refill_i),
    .req_valid_i(req_valid_i), .vaddr_i(vaddr_i),
    .found_o(found_o), .ppn_o(ppn_o), .ps_o(ps_o),
    .mat_o(mat_o), .v_o(v_o), .d_o(d_o), .plv_o(plv_o),
    .tlb_vppn_o(tlb_vppn_o), .tlb_va_bit12_o(tlb_va_bit12_o),
    .tlb_found_i(tlb_found_i), .tlb_ppn_i(tlb_ppn_i), .tlb_ps_i(tlb_ps_i),
    .tlb_mat_i(tlb_mat_i), .tlb_v_i(tlb_v_i), .tlb_d_i(tlb_d_i), .tlb_plv_i(tlb_plv_i));

  initial clk=0; always #5 clk=~clk;

  initial begin
    reset=1; fence_i=0; dis_refill_i=0; req_valid_i=0; vaddr_i=0;
    tlb_found_i=0; tlb_ppn_i=0; tlb_ps_i=6'd12; tlb_mat_i=0; tlb_v_i=0; tlb_d_i=0; tlb_plv_i=0;
    @(posedge clk); #1 reset=0;

    // ---- 1. miss 透传 ----
    req_valid_i=1; vaddr_i=32'h1234_5678;
    tlb_found_i=1; tlb_ppn_i=20'habcde; tlb_ps_i=6'd12; tlb_mat_i=2'b01; tlb_v_i=1; tlb_d_i=1; tlb_plv_i=2'b00;
    #1;
    `TB_CHECK(tlb_vppn_o == 32'h1234_5678 >> 13, "query forwarded to main tlb");
    `TB_CHECK(found_o && (ppn_o == 20'habcde) && (mat_o == 2'b01) && v_o && d_o, "miss passthrough result");
    @(posedge clk); #1;   // 回填落表

    // ---- 2. 命中用缓存副本（主表结果换掉也不受影响，直到 fence）----
    tlb_ppn_i=20'h11111; tlb_mat_i=2'b00; tlb_v_i=0; tlb_d_i=0;
    #1;
    `TB_CHECK(found_o && (ppn_o == 20'habcde) && (mat_o == 2'b01) && v_o && d_o && (ps_o == 6'd12),
              "hit returns cached copy");

    // ---- 3. fence 整表失效，重新跟随主表 ----
    fence_i=1; @(posedge clk); #1 fence_i=0;
    #1;
    `TB_CHECK(found_o && (ppn_o == 20'h11111) && (mat_o == 2'b00) && !v_o, "fence invalidates all entries");

    // ---- 4. 大页不回填 ----
    vaddr_i=32'h8040_0000;
    tlb_found_i=1; tlb_ppn_i=20'h22222; tlb_ps_i=6'd21; tlb_mat_i=2'b01; tlb_v_i=1;
    @(posedge clk); #1;   // 若误回填，此拍已入表
    tlb_ppn_i=20'h33333;
    #1;
    `TB_CHECK(found_o && (ppn_o == 20'h33333) && (ps_o == 6'd21), "huge page not cached (still passthrough)");

    // ---- 5. dis_refill 拍不回填 ----
    vaddr_i=32'h4000_2000;
    tlb_found_i=1; tlb_ppn_i=20'h44444; tlb_ps_i=6'd12; tlb_v_i=1;
    dis_refill_i=1;
    @(posedge clk); #1 dis_refill_i=0;
    tlb_ppn_i=20'h55555;
    #1;
    `TB_CHECK(found_o && (ppn_o == 20'h55555), "dis_refill blocks refill (still passthrough)");
    @(posedge clk); #1;   // 本拍正常回填 55555
    tlb_ppn_i=20'h66666;
    #1;
    `TB_CHECK(found_o && (ppn_o == 20'h55555), "refill resumes after dis_refill deasserts");

    // ---- 6. 主表 miss 透传 found=0 ----
    vaddr_i=32'h7777_0000; tlb_found_i=0;
    #1;
    `TB_CHECK(!found_o, "main tlb miss reported");

    $display("ALL TESTS DONE"); $finish;
  end
endmodule
