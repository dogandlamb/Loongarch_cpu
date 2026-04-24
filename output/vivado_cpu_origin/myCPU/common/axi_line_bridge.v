/**
 * AXI Line Bridge
 * - Converts 128-bit cache line requests into 32-bit AXI bursts
 */

module axi_line_bridge (
    input  wire        clk,
    input  wire        resetn,

    input  wire        ic_rd_req,
    input  wire [2:0]  ic_rd_type,
    input  wire [31:0] ic_rd_addr,
    output wire        ic_rd_rdy,
    output wire        ic_ret_valid,
    output wire        ic_ret_last,
    output wire [127:0] ic_ret_data,

    input  wire        dc_rd_req,
    input  wire [2:0]  dc_rd_type,
    input  wire [31:0] dc_rd_addr,
    output wire        dc_rd_rdy,
    output wire        dc_ret_valid,
    output wire        dc_ret_last,
    output wire [127:0] dc_ret_data,

    input  wire        dc_wr_req,
    input  wire [2:0]  dc_wr_type,
    input  wire [31:0] dc_wr_addr,
    input  wire [15:0] dc_wr_strb,
    input  wire [127:0] dc_wr_data,
    output wire        dc_wr_rdy,

    output wire        axi_awvalid,
    output wire [31:0] axi_awaddr,
    output wire [2:0]  axi_awburst,
    output wire [3:0]  axi_awlen,
    output wire [2:0]  axi_awsize,
    input  wire        axi_awready,

    output wire        axi_wvalid,
    output wire [31:0] axi_wdata,
    output wire [3:0]  axi_wstrb,
    output wire        axi_wlast,
    input  wire        axi_wready,

    input  wire        axi_bvalid,
    input  wire [1:0]  axi_bresp,
    output wire        axi_bready,

    output wire        axi_arvalid,
    output wire [31:0] axi_araddr,
    output wire [2:0]  axi_arburst,
    output wire [3:0]  axi_arlen,
    output wire [2:0]  axi_arsize,
    input  wire        axi_arready,

    input  wire        axi_rvalid,
    input  wire [31:0] axi_rdata,
    input  wire [1:0]  axi_rresp,
    input  wire        axi_rlast,
    output wire        axi_rready
);

localparam RD_IDLE  = 2'd0;
localparam RD_AR    = 2'd1;
localparam RD_RDATA = 2'd2;

localparam WR_IDLE  = 2'd0;
localparam WR_AW    = 2'd1;
localparam WR_WDATA = 2'd2;
localparam WR_RESP  = 2'd3;

reg [1:0]  rd_state;
reg [1:0]  wr_state;
reg        rd_is_ic;
reg        rd_is_line;
reg [1:0]  rd_word_sel;
reg [31:0] rd_addr_buf;
reg [1:0]  rd_beat;
reg [127:0] rd_buf;
reg        rd_ret_valid_r;
reg        rd_ret_last_r;
reg [127:0] rd_ret_data_r;

reg [31:0] wr_addr_buf;
reg [127:0] wr_data_buf;
reg [15:0] wr_strb_buf;
reg        wr_is_line;
reg [1:0]  wr_beat;

wire ic_rd_fire = (rd_state == RD_IDLE) && ic_rd_req;
wire dc_rd_fire = (rd_state == RD_IDLE) && !ic_rd_req && dc_rd_req;
wire [127:0] rd_buf_next = rd_buf;

function [127:0] insert_rd_word;
    input [127:0] line;
    input [31:0] word;
    input [1:0] beat;
    reg [127:0] tmp;
    begin
        tmp = line;
        case (beat)
            2'd0: tmp[31:0] = word;
            2'd1: tmp[63:32] = word;
            2'd2: tmp[95:64] = word;
            default: tmp[127:96] = word;
        endcase
        insert_rd_word = tmp;
    end
endfunction

function [31:0] select_wr_word;
    input [127:0] line;
    input [1:0] beat;
    begin
        case (beat)
            2'd0: select_wr_word = line[31:0];
            2'd1: select_wr_word = line[63:32];
            2'd2: select_wr_word = line[95:64];
            default: select_wr_word = line[127:96];
        endcase
    end
endfunction

function [3:0] select_wr_strb;
    input [15:0] strb;
    input [1:0] beat;
    begin
        case (beat)
            2'd0: select_wr_strb = strb[3:0];
            2'd1: select_wr_strb = strb[7:4];
            2'd2: select_wr_strb = strb[11:8];
            default: select_wr_strb = strb[15:12];
        endcase
    end
endfunction

function [127:0] pack_single_rd_word;
    input [31:0] word;
    input [1:0] word_sel;
    reg [127:0] tmp;
    begin
        tmp = 128'b0;
        case (word_sel)
            2'd0: tmp[31:0] = word;
            2'd1: tmp[63:32] = word;
            2'd2: tmp[95:64] = word;
            default: tmp[127:96] = word;
        endcase
        pack_single_rd_word = tmp;
    end
endfunction

always @(posedge clk) begin
    if (!resetn) begin
        rd_state <= RD_IDLE;
        wr_state <= WR_IDLE;
        rd_is_ic <= 1'b0;
        rd_is_line <= 1'b0;
        rd_word_sel <= 2'b0;
        rd_addr_buf <= 32'b0;
        rd_beat <= 2'b0;
        rd_buf <= 128'b0;
        rd_ret_valid_r <= 1'b0;
        rd_ret_last_r <= 1'b0;
        rd_ret_data_r <= 128'b0;
        wr_addr_buf <= 32'b0;
        wr_data_buf <= 128'b0;
        wr_strb_buf <= 16'b0;
        wr_is_line <= 1'b0;
        wr_beat <= 2'b0;
    end else begin
        rd_ret_valid_r <= 1'b0;
        rd_ret_last_r <= 1'b0;

        case (rd_state)
            RD_IDLE: begin
                if (ic_rd_fire) begin
                    rd_is_ic <= 1'b1;
                    rd_addr_buf <= ic_rd_addr;
                    rd_is_line <= (ic_rd_type == 3'b100);
                    rd_word_sel <= ic_rd_addr[3:2];
                    rd_beat <= 2'b0;
                    rd_buf <= 128'b0;
                    rd_state <= RD_AR;
                end else if (dc_rd_fire) begin
                    rd_is_ic <= 1'b0;
                    rd_addr_buf <= dc_rd_addr;
                    rd_is_line <= (dc_rd_type == 3'b100);
                    rd_word_sel <= dc_rd_addr[3:2];
                    rd_beat <= 2'b0;
                    rd_buf <= 128'b0;
                    rd_state <= RD_AR;
                end
            end
            RD_AR: begin
                if (axi_arready) begin
                    rd_state <= RD_RDATA;
                end
            end
            RD_RDATA: begin
                if (axi_rvalid) begin
                    if (rd_is_line) begin
                        rd_buf <= insert_rd_word(rd_buf, axi_rdata, rd_beat);
                        if (rd_beat == 2'd3 || axi_rlast) begin
                            rd_ret_data_r <= insert_rd_word(rd_buf, axi_rdata, rd_beat);
                            rd_ret_valid_r <= 1'b1;
                            rd_ret_last_r <= 1'b1;
                            rd_state <= RD_IDLE;
                        end else begin
                            rd_beat <= rd_beat + 1'b1;
                        end
                    end else begin
                        rd_ret_data_r <= pack_single_rd_word(axi_rdata, rd_word_sel);
                        rd_ret_valid_r <= 1'b1;
                        rd_ret_last_r <= 1'b1;
                        rd_state <= RD_IDLE;
                    end
                end
            end
            default: rd_state <= RD_IDLE;
        endcase

        case (wr_state)
            WR_IDLE: begin
                if (dc_wr_req) begin
                    wr_addr_buf <= dc_wr_addr;
                    wr_data_buf <= dc_wr_data;
                    wr_strb_buf <= dc_wr_strb;
                    wr_is_line <= (dc_wr_type == 3'b100);
                    wr_beat <= 2'b0;
                    wr_state <= WR_AW;
                end
            end
            WR_AW: begin
                if (axi_awready) begin
                    wr_state <= WR_WDATA;
                end
            end
            WR_WDATA: begin
                if (axi_wready) begin
                    if ((!wr_is_line) || (wr_beat == 2'd3)) begin
                        wr_state <= WR_RESP;
                    end else begin
                        wr_beat <= wr_beat + 1'b1;
                    end
                end
            end
            WR_RESP: begin
                if (axi_bvalid) begin
                    wr_state <= WR_IDLE;
                end
            end
            default: wr_state <= WR_IDLE;
        endcase
    end
end

assign ic_rd_rdy = (rd_state == RD_IDLE) && !dc_rd_req;
assign dc_rd_rdy = (rd_state == RD_IDLE) && (!ic_rd_req || ic_rd_fire);
assign dc_wr_rdy = (wr_state == WR_RESP) && axi_bvalid;

assign ic_ret_valid = rd_is_ic && rd_ret_valid_r;
assign ic_ret_last = rd_is_ic && rd_ret_last_r;
assign ic_ret_data = rd_ret_data_r;

assign dc_ret_valid = !rd_is_ic && rd_ret_valid_r;
assign dc_ret_last = !rd_is_ic && rd_ret_last_r;
assign dc_ret_data = rd_ret_data_r;

assign axi_awvalid = (wr_state == WR_AW);
assign axi_awaddr = wr_is_line ? {wr_addr_buf[31:4], 4'b0000} : wr_addr_buf;
assign axi_awburst = 3'b001;
assign axi_awlen = wr_is_line ? 4'd3 : 4'd0;
assign axi_awsize = 3'b010;

assign axi_wvalid = (wr_state == WR_WDATA);
assign axi_wdata = wr_is_line ? select_wr_word(wr_data_buf, wr_beat) : wr_data_buf[31:0];
assign axi_wstrb = wr_is_line ? select_wr_strb(wr_strb_buf, wr_beat) : wr_strb_buf[3:0];
assign axi_wlast = wr_is_line ? (wr_beat == 2'd3) : 1'b1;

assign axi_bready = (wr_state == WR_RESP);

assign axi_arvalid = (rd_state == RD_AR);
assign axi_araddr = rd_is_line ? {rd_addr_buf[31:4], 4'b0000} : rd_addr_buf;
assign axi_arburst = 3'b001;
assign axi_arlen = rd_is_line ? 4'd3 : 4'd0;
assign axi_arsize = 3'b010;

assign axi_rready = (rd_state == RD_RDATA);

endmodule
