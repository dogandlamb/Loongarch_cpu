// ============================================================
// sram_AXI_bridge：CPU 流水侧（类 SRAM 握手时序）↔ 单 AXI4 主端口。
// - 流水侧接口与原 bram_data_stream_controller 一致。
// - AXI：INCR、单次传输（arlen/awlen=0），arsize/awsize=字；arid/awid 0=取指 1=数据。
// - 数据 load 的 re 常为单周期：入队 dr_pending，避免总线忙时丢请求。
// ============================================================
module sram_AXI_bridge (
    input  wire        clk,
    input  wire        reset,


    // ==== 流水线接口(类sram接口) ====
    input  wire        inst_re_in_from_IF,
    input  wire        data_we_in_from_EXE,
    input  wire        data_re_in_from_EXE,

    input  wire [31:0] pc_in_from_IF,
    input  wire [31:0] data_raddr_from_EXE,
    input  wire [31:0] data_waddr_from_EXE,
    input  wire [31:0] data_wdata_from_EXE,
    input  wire [ 3:0] data_byte_en_from_EXE,
    input  wire        adef_valid_in_from_IF, //地址未对齐异常信号，与pc如夫妻一般跟随，鱼水之情不用考虑代码的模块化
    input  wire        cancel_sig,

    output wire [31:0] inst_rdata_2IF,
    output wire        adef_valid_2IF, // 指令地址未对齐异常信号，送 IF 用于判断指令地址错误
    output wire [31:0] data_rdata_2MEM,

    output reg         data_w_wrong,
    output reg         data_r_wrong,
    output reg         inst_r_wrong,

    // 仅取指 AR/R 在途：冻结顺序 PC，避免下一笔 AR 用超前 PC（勿用整桥 busy，易与访存互锁）
    output wire        axi_if_busy,

    output reg         data_w_complete,
    output reg         data_r_complete,
    output reg         inst_r_complete,

    output wire [31:0] pc_out_2ID,


    // ==== AXI读请求通道(以ar开头) ====
    // master -> slave
    output reg  [3:0]  arid,     // AXI read ID，读请求的ID号，取指置为0，取数置为1
    output reg  [31:0] araddr,   // 读请求的地址
    output reg  [7:0]  arlen,    // 读请求控制信号，请求传输的长度（数据传输拍数），固定为0，arlen=0在AXI4表示1拍
    output reg  [2:0]  arsize,   // 读请求控制信号，请求传输的大小（数据传输每拍的字节数）
    output reg  [1:0]  arburst,  // 读请求控制信号，传输类型，固定为0b01
    output reg  [1:0]  arlock,   // 读请求控制信号，原子锁，固定为0
    output reg  [3:0]  arcache,  // 读请求控制信号，CACHE属性，固定为0
    output reg  [2:0]  arprot,   // 读请求控制信号，保护属性，固定为0
    output reg         arvalid,  // 读请求地址握手信号，读请求地址有效
    // slave -> master
    input  wire        arready,  // 读请求地址握手信号，从方准备好接收数据传输


    // ==== AXI读响应通道(以r开头) ====
    // slave -> master
    input  wire [3:0]  rid,      // 读请求的ID号，同一请求的rid应和arid一致，0对应取指，1对应数据
    input  wire [31:0] rdata,    // 读请求的读回数据
    input  wire [1:0]  rresp,    // 读请求控制信号，本次读请求是否成功完成，我们理解时可忽略，实际代码由桥检测/使用
    input  wire        rlast,    // 读请求控制信号，本次读请求的最后一拍数据的指示信号，我们理解时可忽略，实际代码由桥检测/使用
    input  wire        rvalid,   // 读请求数据握手信号，读请求数据有效
    // master -> slave
    output wire        rready,   // 读请求数据握手信号，主方准备好接受数据传输


    // ==== AXI写请求通道(以aw开头) ====
    // master -> slave
    output reg  [3:0]  awid,     // 写请求的ID号，固定为1
    output reg  [31:0] awaddr,   // 写请求的地址
    output reg  [7:0]  awlen,    // 写请求控制信号，请求传输的长度（数据传输拍数），固定为0
    output reg  [2:0]  awsize,   // 写请求控制信号，请求传输的大小（数据传输每拍的字节数）
    output reg  [1:0]  awburst,  // 写请求控制信号，传输类型，固定为0b01
    output reg  [1:0]  awlock,   // 写请求控制信号，原子锁，固定为0
    output reg  [3:0]  awcache,  // 写请求控制信号，CACHE属性，固定为0
    output reg  [2:0]  awprot,   // 写请求控制信号，保护属性，固定为0
    output reg         awvalid,  // 写请求地址握手信号，写请求地址有效
    // slave -> master
    input  wire        awready,  // 写请求地址握手信号，从方准备好接收数据传输


    // ==== AXI写数据通道(以w开头) ====
    // master -> slave
    output reg  [3:0]  wid,      // 写请求的ID号，固定为1
    output reg  [31:0] wdata,    // 写请求的写数据
    output reg  [3:0]  wstrb,    // 写请求控制信号，字节选通位
    output reg         wlast,    // 写请求控制信号，本次写请求的最后一拍数据的指示信号，固定为1
    output reg         wvalid,   // 写请求数据握手信号，写请求数据有效
    // slave -> master
    input  wire        wready,   // 写请求数据握手信号，从方准备好接收数据传输


    // ==== AXI写响应通道(以b开头) ====
    // slave -> master
    input  wire [3:0]  bid,      // 写请求的ID号，同一请求的bid、wid和awid应一致，我们理解时可忽略，实际代码由桥检测/使用
    input  wire [1:0]  bresp,    // 写请求控制信号，本次写请求是否成功完成，我们理解时可忽略，实际代码由桥检测/使用
    input  wire        bvalid,   // 写请求响应握手信号，写请求响应有效
    // master -> slave
    output wire        bready    // 写请求响应握手信号，主方准备好接收写响应
);

    localparam [3:0] AXI_ID_INST = 4'd0;
    localparam [3:0] AXI_ID_DATA = 4'd1;

    localparam [3:0] S_IDLE    = 4'd0;
    localparam [3:0] S_AR_INST = 4'd1;
    localparam [3:0] S_R_INST  = 4'd2;
    localparam [3:0] S_AR_DATA = 4'd3;
    localparam [3:0] S_R_DATA  = 4'd4;
    localparam [3:0] S_AW     = 4'd5;
    localparam [3:0] S_W      = 4'd6;
    localparam [3:0] S_B      = 4'd7;

    reg [3:0] state;

    reg        dr_pending;
    reg [31:0] dr_addr;
    reg        ir_pending;
    reg [31:0] ir_addr;
    reg        ir_adef;
    reg        ir_pending2;
    reg [31:0] ir_addr2;
    reg        ir_adef2;

    reg [31:0] inst_rdata_reg;
    reg [31:0] data_rdata_reg;
    reg [15:0] r_wait_cnt;
    reg [31:0] inst_retry_cnt;
    reg [23:0] inst_stall_cnt;
    reg [23:0] inst_wait_wd;

<<<<<<< Updated upstream
    reg        data_wr_got_b;
=======
>>>>>>> Stashed changes
    reg [31:0] aw_wdata_lat;
    reg [3:0]  aw_wstrb_lat;
    reg [31:0] sh_addr [0:7];
    reg [31:0] sh_data [0:7];
    reg [3:0]  sh_strb [0:7];
    reg [7:0]  sh_valid;
    reg [2:0]  sh_ptr;
<<<<<<< Updated upstream
=======
    reg [2:0]  sh_issue_ptr;
>>>>>>> Stashed changes
    reg [2:0]  sh_pop_ptr;
    reg [31:0] data_rd_addr_issued;

    wire data_w_wrong_local;
    wire data_r_wrong_local;
    wire inst_r_wrong_local;
    assign data_w_wrong_local = bvalid & bresp != 2'b00 & bid == AXI_ID_DATA;
    assign data_r_wrong_local = (rvalid & rresp != 2'b00 & rid == AXI_ID_DATA);
    assign inst_r_wrong_local = (rvalid & rresp != 2'b00 & rid == AXI_ID_INST);

    wire inst_ar_done = (state == S_AR_INST) & arvalid & arready;
    // Read responses are handled strictly by current bridge state; only one read is outstanding.
    wire inst_r_done  = (state == S_R_INST) & rvalid & rlast;
    wire data_r_done  = (state == S_R_DATA) & rvalid & rlast;

    wire stq_has_queued = sh_valid[sh_issue_ptr];
    wire store_req_now  = data_we_in_from_EXE | stq_has_queued;
    wire [31:0] store_req_addr = stq_has_queued ? sh_addr[sh_issue_ptr] : data_waddr_from_EXE;
    wire [31:0] store_req_data = stq_has_queued ? sh_data[sh_issue_ptr] : data_wdata_from_EXE;
    wire [3:0]  store_req_strb = stq_has_queued ? sh_strb[sh_issue_ptr] : data_byte_en_from_EXE;
    wire push_store_fire = data_we_in_from_EXE & !sh_valid[sh_ptr];
    wire store_issue_fire = (state == S_IDLE) & store_req_now;

    wire data_rd_live = data_re_in_from_EXE & ((state != S_IDLE) | store_req_now);
    wire data_rd_need = dr_pending | data_re_in_from_EXE;
    wire [31:0] data_rd_araddr = dr_pending ? dr_addr : data_raddr_from_EXE;
<<<<<<< Updated upstream
    wire inst_issue_now = (state == S_IDLE) && !data_we_in_from_EXE && !data_rd_need && (inst_re_in_from_IF || ir_pending);
=======
    wire inst_issue_now = (state == S_IDLE) && !store_req_now && !data_rd_need && (inst_re_in_from_IF || ir_pending);
>>>>>>> Stashed changes
    wire [2:0] sh_idx0 = sh_ptr - 3'd1;
    wire [2:0] sh_idx1 = sh_ptr - 3'd2;
    wire [2:0] sh_idx2 = sh_ptr - 3'd3;
    wire [2:0] sh_idx3 = sh_ptr - 3'd4;
    wire [2:0] sh_idx4 = sh_ptr - 3'd5;
    wire [2:0] sh_idx5 = sh_ptr - 3'd6;
    wire [2:0] sh_idx6 = sh_ptr - 3'd7;
    wire [2:0] sh_idx7 = sh_ptr - 3'd0;
    // MMIO reads (e.g. confreg at 0xbfafxxxx) should observe device return data directly.
    wire sh_bypass_en = (data_rd_addr_issued[31:16] != 16'hbfaf);
    wire sh_hit0 = sh_bypass_en && sh_valid[sh_idx0] && (sh_addr[sh_idx0][31:2] == data_rd_addr_issued[31:2]);
    wire sh_hit1 = sh_bypass_en && sh_valid[sh_idx1] && (sh_addr[sh_idx1][31:2] == data_rd_addr_issued[31:2]);
    wire sh_hit2 = sh_bypass_en && sh_valid[sh_idx2] && (sh_addr[sh_idx2][31:2] == data_rd_addr_issued[31:2]);
    wire sh_hit3 = sh_bypass_en && sh_valid[sh_idx3] && (sh_addr[sh_idx3][31:2] == data_rd_addr_issued[31:2]);
    wire sh_hit4 = sh_bypass_en && sh_valid[sh_idx4] && (sh_addr[sh_idx4][31:2] == data_rd_addr_issued[31:2]);
    wire sh_hit5 = sh_bypass_en && sh_valid[sh_idx5] && (sh_addr[sh_idx5][31:2] == data_rd_addr_issued[31:2]);
    wire sh_hit6 = sh_bypass_en && sh_valid[sh_idx6] && (sh_addr[sh_idx6][31:2] == data_rd_addr_issued[31:2]);
    wire sh_hit7 = sh_bypass_en && sh_valid[sh_idx7] && (sh_addr[sh_idx7][31:2] == data_rd_addr_issued[31:2]);
    wire sh_hit  = sh_hit0 | sh_hit1 | sh_hit2 | sh_hit3 | sh_hit4 | sh_hit5 | sh_hit6 | sh_hit7;

    function [31:0] merge_store_bytes;
        input [31:0] base;
        input [31:0] wdata_i;
        input [3:0]  wstrb_i;
        begin
            merge_store_bytes = base;
            if (wstrb_i[0]) merge_store_bytes[7:0]   = wdata_i[7:0];
            if (wstrb_i[1]) merge_store_bytes[15:8]  = wdata_i[15:8];
            if (wstrb_i[2]) merge_store_bytes[23:16] = wdata_i[23:16];
            if (wstrb_i[3]) merge_store_bytes[31:24] = wdata_i[31:24];
        end
    endfunction

    wire [31:0] sh_rdata_s7 = sh_hit7 ? merge_store_bytes(rdata,      sh_data[sh_idx7], sh_strb[sh_idx7]) : rdata;
    wire [31:0] sh_rdata_s6 = sh_hit6 ? merge_store_bytes(sh_rdata_s7, sh_data[sh_idx6], sh_strb[sh_idx6]) : sh_rdata_s7;
    wire [31:0] sh_rdata_s5 = sh_hit5 ? merge_store_bytes(sh_rdata_s6, sh_data[sh_idx5], sh_strb[sh_idx5]) : sh_rdata_s6;
    wire [31:0] sh_rdata_s4 = sh_hit4 ? merge_store_bytes(sh_rdata_s5, sh_data[sh_idx4], sh_strb[sh_idx4]) : sh_rdata_s5;
    wire [31:0] sh_rdata_s3 = sh_hit3 ? merge_store_bytes(sh_rdata_s4, sh_data[sh_idx3], sh_strb[sh_idx3]) : sh_rdata_s4;
    wire [31:0] sh_rdata_s2 = sh_hit2 ? merge_store_bytes(sh_rdata_s3, sh_data[sh_idx2], sh_strb[sh_idx2]) : sh_rdata_s3;
    wire [31:0] sh_rdata_s1 = sh_hit1 ? merge_store_bytes(sh_rdata_s2, sh_data[sh_idx1], sh_strb[sh_idx1]) : sh_rdata_s2;
    wire [31:0] sh_rdata    = sh_hit0 ? merge_store_bytes(sh_rdata_s1, sh_data[sh_idx0], sh_strb[sh_idx0]) : sh_rdata_s1;
    wire inst_issue_from_pending = ir_pending;
    wire [31:0] inst_issue_addr = inst_issue_from_pending ? ir_addr : pc_in_from_IF;
    wire inst_issue_adef = inst_issue_from_pending ? ir_adef : adef_valid_in_from_IF;
    wire b_handshake  = (state == S_B) & bvalid & bready & (bid == AXI_ID_DATA);

    wire sram_inst_addr_ok = inst_ar_done;
    wire sram_inst_data_ok = inst_r_done;
    wire sram_data_data_ok_rd = data_r_done;
    wire sram_data_data_ok_wr = b_handshake;
    wire sram_data_data_ok    = sram_data_data_ok_rd | sram_data_data_ok_wr;

    reg  data_w_pending;
<<<<<<< Updated upstream
    reg  data_we_prev;
=======
>>>>>>> Stashed changes
    reg  data_r_complete_d;
    reg  inst_data_ok_d;
    reg [31:0] inst_pc_pending;
    reg [31:0] inst_pc_reg;
    reg  inst_wait_data;
    reg  inst_adef_done_pend;
    reg  inst_adef_pending;
    reg  inst_replay_guard;
    reg [31:0] inst_last_done_pc;

    wire inst_fetch_inflight = (state == S_AR_INST) || (state == S_R_INST);
    wire [31:0] inst_fetch_inflight_pc = (state == S_AR_INST) ? araddr : inst_pc_pending;
    wire inst_req_same_as_inflight = inst_fetch_inflight && (pc_in_from_IF[31:2] == inst_fetch_inflight_pc[31:2]);
    wire inst_issue_suppressed = inst_replay_guard && (inst_issue_addr[31:2] == inst_last_done_pc[31:2]);

    wire inst_data_ok_pulse = sram_inst_data_ok & ~inst_data_ok_d;
    wire inst_adef_local_done = (state == S_IDLE) && inst_issue_now && inst_issue_adef;

    wire inst_data_ok_pulse = sram_inst_data_ok & ~inst_data_ok_d;

    assign inst_rdata_2IF  = inst_rdata_reg;
    assign adef_valid_2IF  = inst_adef_pending;
    assign data_rdata_2MEM = data_rdata_reg;
    assign pc_out_2ID      = inst_pc_reg;

    assign rready = 1'b1;
    assign bready = 1'b1;

    wire data_path_busy = (state == S_AR_DATA) || (state == S_R_DATA) || (state == S_AW) || (state == S_W) || (state == S_B);
<<<<<<< Updated upstream
    wire dbg_en = 1'b0;

    assign axi_if_busy = (state == S_AR_INST) || (state == S_R_INST) || ir_pending2 || (data_path_busy && (ir_pending || ir_pending2));

    always @(posedge clk) begin
        if (dbg_en && !reset && data_we_in_from_EXE && (data_waddr_from_EXE[31:4] == 28'h000d3b6)) begin
            $display("AXI_WDBG t=%0t REQ addr=0x%08h data=0x%08h strb=0x%1h state=%0d", $time, data_waddr_from_EXE, data_wdata_from_EXE, data_byte_en_from_EXE, state);
        end
    end

    always @(posedge clk) begin
        if (dbg_en && !reset && ((data_we_in_from_EXE && (data_waddr_from_EXE[31:4] == 28'h000d3b6)) ||
                       (b_handshake && (awaddr[31:4] == 28'h000d3b6)) ||
                       (data_r_done && (data_rd_addr_issued[31:4] == 28'h000d3b6)))) begin
            $display("SHQDBG t=%0t st=%0d we=%0d prev=%0d pend=%0d push=%0d pop=%0d ptr=%0d pop_ptr=%0d aw=0x%08h rd_iss=0x%08h valid=%02b hit=%0d shrd=0x%08h", $time, state,
                     data_we_in_from_EXE, data_we_prev, data_w_pending,
                     (data_we_in_from_EXE && !data_we_prev), b_handshake,
                     sh_ptr, sh_pop_ptr, awaddr, data_rd_addr_issued, sh_valid, sh_hit, sh_rdata);
        end
    end

=======
    assign axi_if_busy = (state == S_AR_INST) || (state == S_R_INST) || ir_pending2 || (data_path_busy && (ir_pending || ir_pending2));

>>>>>>> Stashed changes
    always @(posedge clk) begin
        if (reset) begin
            dr_pending <= 1'b0;
            dr_addr    <= 32'd0;
            ir_pending <= 1'b0;
            ir_addr    <= 32'd0;
            ir_adef    <= 1'b0;
            ir_pending2 <= 1'b0;
            ir_addr2    <= 32'd0;
            ir_adef2    <= 1'b0;
            sh_ptr     <= 3'd0;
<<<<<<< Updated upstream
=======
            sh_issue_ptr <= 3'd0;
>>>>>>> Stashed changes
            sh_pop_ptr <= 3'd0;
            sh_valid   <= 8'd0;
            data_rd_addr_issued <= 32'd0;
        end else begin
            if (state == S_AR_DATA && arvalid && arready)
                dr_pending <= 1'b0;
            else if (data_rd_live && !dr_pending) begin
                dr_pending <= 1'b1;
                dr_addr    <= data_raddr_from_EXE;
            end
<<<<<<< Updated upstream

            if (state == S_AR_DATA && arvalid && arready)
                data_rd_addr_issued <= araddr;

            if (inst_issue_now) begin
                if (ir_pending2) begin
                    ir_pending  <= 1'b1;
                    ir_addr     <= ir_addr2;
                    ir_adef     <= ir_adef2;
                    ir_pending2 <= 1'b0;
                end else begin
                    ir_pending <= 1'b0;
                end

                if (inst_re_in_from_IF && (pc_in_from_IF != inst_issue_addr)) begin
                    if (ir_pending2) begin
                        ir_pending2 <= 1'b1;
                        ir_addr2    <= pc_in_from_IF;
                        ir_adef2    <= adef_valid_in_from_IF;
                    end else begin
                        ir_pending  <= 1'b1;
                        ir_addr     <= pc_in_from_IF;
                        ir_adef     <= adef_valid_in_from_IF;
                    end
                end
            end else if (inst_re_in_from_IF) begin
                if (!ir_pending) begin
                    ir_pending <= 1'b1;
                    ir_addr    <= pc_in_from_IF;
                    ir_adef    <= adef_valid_in_from_IF;
                end else if (ir_pending2 && (pc_in_from_IF == (ir_addr2 + 32'd4))) begin
                    // 两级队列已满且仍然是顺序取指：先保持现有两笔请求，等待桥空出位置。
                end else if (pc_in_from_IF != (ir_addr + 32'd4)) begin
                    // 非顺序取指（如分支重定向）优先覆盖并丢弃旧的顺序下一条
                    ir_pending  <= 1'b1;
                    ir_addr     <= pc_in_from_IF;
                    ir_adef     <= adef_valid_in_from_IF;
                    ir_pending2 <= 1'b0;
                end else if (!ir_pending2) begin
                    ir_pending2 <= 1'b1;
                    ir_addr2    <= pc_in_from_IF;
                    ir_adef2    <= adef_valid_in_from_IF;
                end
            end

            // If instruction read response stalls too long, requeue current PC and retry from IDLE.
            if ((state == S_R_INST) && (inst_stall_cnt == 24'd5000)) begin
                ir_pending  <= 1'b1;
                ir_addr     <= inst_pc_pending;
                ir_adef     <= inst_adef_pending;
            end

            // Push exactly once per store request edge.
            if (data_we_in_from_EXE && !data_we_prev) begin
                sh_addr[sh_ptr] <= data_waddr_from_EXE;
                sh_data[sh_ptr] <= data_wdata_from_EXE;
                sh_strb[sh_ptr] <= data_byte_en_from_EXE;
                sh_valid[sh_ptr] <= 1'b1;
                sh_ptr <= sh_ptr + 3'd1;
            end

            if (b_handshake) begin
                // If push and pop hit the same slot in one cycle, keep the newly pushed entry valid.
                if (!(data_we_in_from_EXE && (sh_ptr == sh_pop_ptr)))
                    sh_valid[sh_pop_ptr] <= 1'b0;
                sh_pop_ptr <= sh_pop_ptr + 3'd1;
            end


        end
    end

    always @(posedge clk) begin
        if (dbg_en && !reset && ((pc_in_from_IF[31:4] == 28'h1c01838) || (pc_in_from_IF[31:4] == 28'h1c01839) ||
                   (inst_issue_addr[31:4] == 28'h1c01838) || (inst_issue_addr[31:4] == 28'h1c01839) ||
                   (pc_in_from_IF[31:4] == 28'h1c02e80) || (inst_issue_addr[31:4] == 28'h1c02e80))) begin
            $display("INSTQDBG t=%0t state=%0d issue_now=%0d re_if=%0d pc_if=0x%08h issue_addr=0x%08h pending=%0d pending2=%0d wait=%0d arv=%0d arr=%0d araddr=0x%08h",
                     $time, state, inst_issue_now, inst_re_in_from_IF, pc_in_from_IF, inst_issue_addr,
                     ir_pending, ir_pending2, inst_wait_data, arvalid, arready, araddr);
        end
    end

    wire instq_dbg_hit = 1'b0;

    always @(posedge clk) begin
        if (!reset && instq_dbg_hit) begin
            $display("INSTQ2DBG t=%0t st=%0d re_if=%0d pc_if=0x%08h issue_now=%0d issue_addr=0x%08h ir1=%0d:0x%08h ir2=%0d:0x%08h arv=%0d arr=%0d ar_done=%0d rvalid=%0d rid=%0d r_done=%0d pc_pend=0x%08h pc_reg=0x%08h wait=%0d inst_ok=%0d inst_cpl=%0d",
                     $time, state, inst_re_in_from_IF, pc_in_from_IF, inst_issue_now, inst_issue_addr,
                     ir_pending, ir_addr, ir_pending2, ir_addr2,
                     arvalid, arready, inst_ar_done, rvalid, rid, inst_r_done,
                     inst_pc_pending, inst_pc_reg, inst_wait_data, inst_data_ok_pulse, inst_r_complete);
        end
    end
=======
>>>>>>> Stashed changes

            if (state == S_AR_DATA && arvalid && arready)
                data_rd_addr_issued <= araddr;

            if (cancel_sig) begin
                ir_pending  <= 1'b0;
                ir_addr     <= 32'd0;
                ir_adef     <= 1'b0;
                ir_pending2 <= 1'b0;
                ir_addr2    <= 32'd0;
                ir_adef2    <= 1'b0;
            end else begin
                if (inst_issue_now) begin
                    if (ir_pending2) begin
                        ir_pending  <= 1'b1;
                        ir_addr     <= ir_addr2;
                        ir_adef     <= ir_adef2;
                        ir_pending2 <= 1'b0;
                    end else begin
                        ir_pending <= 1'b0;
                    end

                    if (inst_re_in_from_IF && (pc_in_from_IF != inst_issue_addr)) begin
                        if (ir_pending2) begin
                            ir_pending2 <= 1'b1;
                            ir_addr2    <= pc_in_from_IF;
                            ir_adef2    <= adef_valid_in_from_IF;
                        end else begin
                            ir_pending  <= 1'b1;
                            ir_addr     <= pc_in_from_IF;
                            ir_adef     <= adef_valid_in_from_IF;
                        end
                    end
                end else if (inst_re_in_from_IF) begin
                    if (inst_req_same_as_inflight) begin
                        // Same fetch PC already in AR/R flight: do not enqueue a duplicate.
                    end else 
                    if (!ir_pending) begin
                        ir_pending <= 1'b1;
                        ir_addr    <= pc_in_from_IF;
                        ir_adef    <= adef_valid_in_from_IF;
                    end else if (ir_pending2 && (pc_in_from_IF == (ir_addr2 + 32'd4))) begin
                        // 两级队列已满且仍然是顺序取指：先保持现有两笔请求，等待桥空出位置。
                    end else if (pc_in_from_IF != (ir_addr + 32'd4)) begin
                        // 非顺序取指（如分支重定向）优先覆盖并丢弃旧的顺序下一条
                        ir_pending  <= 1'b1;
                        ir_addr     <= pc_in_from_IF;
                        ir_adef     <= adef_valid_in_from_IF;
                        ir_pending2 <= 1'b0;
                    end else if (!ir_pending2) begin
                        ir_pending2 <= 1'b1;
                        ir_addr2    <= pc_in_from_IF;
                        ir_adef2    <= adef_valid_in_from_IF;
                    end
                end
            end

            // If instruction read response stalls too long, requeue current PC and retry from IDLE.
            if (!cancel_sig && (state == S_R_INST) && (inst_stall_cnt == 24'd5000)) begin
                ir_pending  <= 1'b1;
                ir_addr     <= inst_pc_pending;
                ir_adef     <= inst_adef_pending;
            end

            // Enqueue every incoming store request; each MEM slot drives one pulse.
            if (push_store_fire) begin
                sh_addr[sh_ptr] <= data_waddr_from_EXE;
                sh_data[sh_ptr] <= data_wdata_from_EXE;
                sh_strb[sh_ptr] <= data_byte_en_from_EXE;
                sh_valid[sh_ptr] <= 1'b1;
                sh_ptr <= sh_ptr + 3'd1;
            end

            if (store_issue_fire)
                sh_issue_ptr <= sh_issue_ptr + 3'd1;

            if (b_handshake) begin
                // If push and pop hit the same slot in one cycle, keep the newly pushed entry valid.
                if (!(push_store_fire && (sh_ptr == sh_pop_ptr)))
                    sh_valid[sh_pop_ptr] <= 1'b0;
                sh_pop_ptr <= sh_pop_ptr + 3'd1;
            end


        end
    end

    always @(posedge clk) begin
        if (reset) begin
            state           <= S_IDLE;
            arvalid         <= 1'b0;
            arid            <= 4'd0;
            araddr          <= 32'd0;
            arlen           <= 8'd0;
            arsize          <= 3'b010;
            arburst         <= 2'b01;
            arlock          <= 2'd0;
            arcache         <= 4'd0;
            arprot          <= 3'd0;
            awvalid         <= 1'b0;
            awid            <= 4'd0;
            awaddr          <= 32'd0;
            awlen           <= 8'd0;
            awsize          <= 3'b010;
            awburst         <= 2'b01;
            awlock          <= 2'd0;
            awcache         <= 4'd0;
            awprot          <= 3'd0;
            wvalid          <= 1'b0;
            wid             <= 4'd0;
            wdata           <= 32'd0;
            wstrb           <= 4'd0;
            wlast           <= 1'b0;
            inst_rdata_reg  <= 32'd0;
            data_rdata_reg  <= 32'd0;
            inst_pc_pending  <= 32'b0;
            inst_pc_reg      <= 32'b0;
            aw_wdata_lat    <= 32'd0;
            aw_wstrb_lat    <= 4'd0;
            r_wait_cnt      <= 16'd0;
            inst_retry_cnt  <= 32'd0;
            inst_stall_cnt  <= 24'd0;
            inst_wait_wd    <= 24'd0;
        end else begin
            if (state == S_R_INST)
                inst_stall_cnt <= inst_stall_cnt + 24'd1;
            else
                inst_stall_cnt <= 24'd0;

            if (inst_data_ok_pulse)
                inst_wait_wd <= 24'd0;
            else if (inst_wait_data)
                inst_wait_wd <= inst_wait_wd + 24'd1;
            else
                inst_wait_wd <= 24'd0;

            if (state == S_R_INST) begin
                if (rvalid & rlast)
                    r_wait_cnt <= 16'd0;
                else
                    r_wait_cnt <= r_wait_cnt + 16'd1;
            end else if (state == S_R_DATA) begin
                if (rvalid & rlast)
                    r_wait_cnt <= 16'd0;
                else
                    r_wait_cnt <= r_wait_cnt + 16'd1;
            end else begin
                r_wait_cnt <= 16'd0;
            end

            case (state)
                S_IDLE: begin
                    arvalid <= 1'b0;
                    awvalid <= 1'b0;
                    wvalid  <= 1'b0;
                    wlast   <= 1'b0;
                    if (store_req_now) begin
                        state   <= S_AW;
                        awvalid <= 1'b1;
                        awid    <= AXI_ID_DATA;
                        awaddr  <= store_req_addr;
                        awlen   <= 8'd0;
                        awsize  <= 3'b010;
                        awburst <= 2'b01;
<<<<<<< Updated upstream
                        aw_wdata_lat <= data_wdata_from_EXE;
                        aw_wstrb_lat <= data_byte_en_from_EXE;
=======
                        aw_wdata_lat <= store_req_data;
                        aw_wstrb_lat <= store_req_strb;
>>>>>>> Stashed changes
                    end else if (data_rd_need) begin
                        state   <= S_AR_DATA;
                        arvalid <= 1'b1;
                        arid    <= AXI_ID_DATA;
                        // Data path is word-sized on AXI; align read address and let MEMport
                        // select byte/half with original low bits.
                        araddr  <= {data_rd_araddr[31:2], 2'b00};
<<<<<<< Updated upstream
                        arlen   <= 8'd0;
                        arsize  <= 3'b010;
                        arburst <= 2'b01;
                    end else if (inst_re_in_from_IF || ir_pending) begin
                        state   <= S_AR_INST;
                        arvalid <= 1'b1;
                        arid    <= AXI_ID_INST;
                        araddr  <= inst_issue_addr;
=======
>>>>>>> Stashed changes
                        arlen   <= 8'd0;
                        arsize  <= 3'b010;
                        arburst <= 2'b01;
                    end else if ((inst_re_in_from_IF || ir_pending) && !inst_issue_suppressed) begin
                        // Misaligned fetch is completed locally so IF can raise ADEF promptly.
                        if (inst_issue_adef) begin
                            inst_rdata_reg <= 32'h00000000;
                            inst_pc_reg    <= inst_issue_addr;
                        end else begin
                            state   <= S_AR_INST;
                            arvalid <= 1'b1;
                            arid    <= AXI_ID_INST;
                            araddr  <= inst_issue_addr;
                            arlen   <= 8'd0;
                            arsize  <= 3'b010;
                            arburst <= 2'b01;
                        end
                    end
                end
                S_AR_INST: begin
                    if (arvalid & arready) begin
                        arvalid <= 1'b0;
                        state   <= S_R_INST;
<<<<<<< Updated upstream
                        // 与 rdata 对应的取指 PC：必须用本事务 araddr（握手时 pc_in 可能已是下一条顺序地址）
=======
                        // Keep the request PC paired with response data.
>>>>>>> Stashed changes
                        inst_pc_pending <= araddr;
                    end else if (inst_wait_wd == 24'd1000) begin
                        // Aggressive global fetch wait watchdog: abort AR and retry from IDLE.
                        state          <= S_IDLE;
                        arvalid        <= 1'b0;
                        inst_retry_cnt <= inst_retry_cnt + 32'd1;
                    end
                end
                S_R_INST: begin
                    if (rvalid & rlast) begin
                        inst_rdata_reg <= rdata;
                        inst_pc_reg    <= inst_pc_pending;
                        state          <= S_IDLE;
                    end else if (inst_stall_cnt == 24'd1000) begin
                        // Aggressive timeout: if R response never comes, force completion with default data
                        inst_rdata_reg <= 32'h0;  // Default instruction (NOP-like)
                        inst_pc_reg    <= inst_pc_pending;
                        state          <= S_IDLE;
                        inst_retry_cnt <= inst_retry_cnt + 32'd1;
                    end else if (inst_wait_wd == 24'd1000) begin
                        inst_rdata_reg <= 32'h0;
                        inst_pc_reg    <= inst_pc_pending;
                        state          <= S_IDLE;
                        inst_retry_cnt <= inst_retry_cnt + 32'd1;
                    end
                end
                S_AR_DATA: begin
                    if (arvalid & arready) begin
                        arvalid <= 1'b0;
                        state   <= S_R_DATA;
                    end
                end
                S_R_DATA: begin
                    if (rvalid & rlast) begin
                        data_rdata_reg <= sh_hit ? sh_rdata : rdata;
                        state          <= S_IDLE;
                        if (dbg_en && (data_rd_addr_issued[31:4] == 28'h000d3b6)) begin
                            $display("AXI_SHDBG t=%0t R addr=0x%08h rdata=0x%08h hit=%0d sh=0x%08h", $time, data_rd_addr_issued, rdata, sh_hit, sh_rdata);
                        end
                    end
                end
                S_AW: begin
                    if (awvalid & awready) begin
                        if (dbg_en && (awaddr[31:4] == 28'h000d3b6)) begin
                            $display("AXI_WDBG t=%0t AW addr=0x%08h data_lat=0x%08h strb=0x%1h", $time, awaddr, aw_wdata_lat, aw_wstrb_lat);
                        end
                        awvalid <= 1'b0;
                        state   <= S_W;
                        wvalid  <= 1'b1;
                        wlast   <= 1'b1;
                        wid     <= AXI_ID_DATA;
                        wdata   <= aw_wdata_lat;
                        wstrb   <= aw_wstrb_lat;
                    end
                end
                S_W: begin
                    if (wvalid & wready) begin
                        if (dbg_en && (awaddr[31:4] == 28'h000d3b6)) begin
                            $display("AXI_WDBG t=%0t W  data=0x%08h strb=0x%1h", $time, wdata, wstrb);
                        end
                        wvalid <= 1'b0;
                        wlast  <= 1'b0;
                        state  <= S_B;
                    end
                end
                S_B: begin
                    if (bvalid & bready & (bid == AXI_ID_DATA)) begin
<<<<<<< Updated upstream
                        if (dbg_en && (awaddr[31:4] == 28'h000d3b6)) begin
                            $display("AXI_WDBG t=%0t B  resp=0x%0h", $time, bresp);
                        end
=======
>>>>>>> Stashed changes
                        state <= S_IDLE;
                    end
                end
                default: state <= S_IDLE;
            endcase
        end
    end

    always @(posedge clk) begin
        if (reset) begin
            data_w_pending    <= 1'b0;
<<<<<<< Updated upstream
            data_we_prev      <= 1'b0;
=======
>>>>>>> Stashed changes
            data_r_complete_d <= 1'b0;
            data_r_complete   <= 1'b0;
            inst_data_ok_d    <= 1'b0;
            inst_wait_data    <= 1'b0;
            inst_adef_done_pend <= 1'b0;
            inst_adef_pending <= 1'b0;
            inst_replay_guard <= 1'b0;
            inst_last_done_pc <= 32'b0;
            inst_r_complete   <= 1'b0;
        end else begin
            inst_data_ok_d <= sram_inst_data_ok;

<<<<<<< Updated upstream
            if (inst_issue_now)
                inst_adef_pending <= inst_issue_adef;

            // Outstanding 取指：在 AR 握手完成时置位。若同拍既有旧响应又有新 AR，
            // 以“仍有新的取指在途”为准，避免把等待标志提前清掉。
            if (inst_ar_done)
=======
            if (inst_data_ok_pulse) begin
                inst_replay_guard <= 1'b1;
                inst_last_done_pc <= inst_pc_pending;
            end else if (inst_adef_local_done) begin
                inst_replay_guard <= 1'b1;
                inst_last_done_pc <= inst_issue_addr;
            end else begin
                inst_replay_guard <= 1'b0;
            end

            if (cancel_sig)
                inst_adef_done_pend <= 1'b0;
            else if (inst_adef_local_done)
                inst_adef_done_pend <= 1'b1;
            else
                inst_adef_done_pend <= 1'b0;

            if (cancel_sig)
                inst_adef_pending <= 1'b0;
            else if (inst_issue_now)
                inst_adef_pending <= inst_issue_adef;

            // Outstanding 取指：在 AR 握手完成时置位。若同拍既有旧响应又有新 AR，
            // 以“仍有新的取指在途”为准，避免把等待标志提前清掉。
            if (cancel_sig)
                inst_wait_data <= 1'b0;
            else if (inst_ar_done)
>>>>>>> Stashed changes
                inst_wait_data <= 1'b1;
            else if (inst_data_ok_pulse)
                inst_wait_data <= 1'b0;

<<<<<<< Updated upstream
            if (!data_w_pending && data_we_in_from_EXE && !data_we_prev) begin
=======
            if (!data_w_pending && store_issue_fire) begin
>>>>>>> Stashed changes
                data_w_pending <= 1'b1;
            end
            else if (data_w_pending && sram_data_data_ok)
                data_w_pending <= 1'b0;

<<<<<<< Updated upstream
            data_we_prev <= data_we_in_from_EXE;

=======
>>>>>>> Stashed changes
            if (!data_r_wrong_local) begin
                data_r_complete_d <= sram_data_data_ok_rd;
                data_r_complete   <= data_r_complete_d;
            end else begin
                data_r_complete_d <= 1'b0;
                data_r_complete   <= 1'b0;
            end

            if (!inst_r_wrong_local)
<<<<<<< Updated upstream
                inst_r_complete <= inst_data_ok_pulse;
=======
                inst_r_complete <= inst_data_ok_pulse | inst_adef_done_pend;
>>>>>>> Stashed changes
            else
                inst_r_complete <= 1'b0;
        end
    end

    always @(posedge clk) begin
        if (reset) data_w_wrong <= 1'b0;
        else       data_w_wrong <= data_w_wrong_local;
    end

    always @(posedge clk) begin
        if (reset) data_r_wrong <= 1'b0;
        else       data_r_wrong <= data_r_wrong_local;
    end

    always @(posedge clk) begin
        if (reset) inst_r_wrong <= 1'b0;
        else       inst_r_wrong <= inst_r_wrong_local;
    end

    always @(posedge clk) begin
        if (reset) data_w_complete <= 1'b0;
        else if (!data_w_wrong_local)
            data_w_complete <= data_w_pending & sram_data_data_ok_wr;
        else data_w_complete <= 1'b0;
    end

endmodule
