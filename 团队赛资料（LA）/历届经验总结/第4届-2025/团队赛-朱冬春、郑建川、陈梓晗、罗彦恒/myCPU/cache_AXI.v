`timescale 1ns / 1ps
`include "defines.vh"

module cache_AXI
(
    input  wire         clk,
    input  wire         rst,    // low active

    //icache read
    input wire inst_ren_i,
    input wire [31:0] inst_araddr_i,
    output reg inst_rvalid_o,
    output reg [255:0] inst_rdata_o,
    output wire icache_ren_received,
    output wire icache_flush_flag_valid,

    //dcache read
    input wire data_ren_i,
    input wire [31:0] data_araddr_i,
    output reg data_rvalid_o,
    output reg [255:0] data_rdata_o,
    output wire dcache_ren_received,

    //dcache write
    input wire [3:0] data_wen_i,
    input wire [255:0] data_wdata_i,
    input wire [31:0] data_awaddr_i,
    output reg data_bvalid_o,

    output wire cache_axi_write_pre_ready,

    //ready to dcache
    output wire dev_rrdy_o,
    output wire dev_wrdy_o,
    //iuncache read channel
    input wire iuncache_ren_i,
    input wire [31:0] iuncache_raddr_i,
    output reg iuncache_rvalid_o,
    output reg [63:0] iuncache_rdata_o, 

    //duncache read channel
    input wire duncache_ren_i,
    input wire [31:0] duncache_raddr_i,
    output reg duncache_rvalid_o,
    output reg [31:0] duncache_rdata_o,

    //duncache write channel
    input wire duncache_wen_i,
    input wire [3:0] duncache_wstrb,
    input wire [31:0] duncache_wdata_i,
    input wire [31:0] duncache_waddr_i,
    output reg duncache_write_resp,  //dcache闁跨喎褰ㄧ喊澶嬪duncache_write_finish

    //AXI communicate
    output wire axi_ce_o,
    output wire [3:0] axi_wsel_o,   // 闁跨喐鏋婚幏鐑芥晸閺傘倖瀚归柨鐔告灮閹风兘鏁撶粩顓狀暜閹风strb

    //AXI read
    input wire [31:0] rdata_i,
    input wire rdata_valid_i,
    output wire axi_ren_o,
    output wire axi_rready_o,
    output wire [31:0] axi_raddr_o,
    output wire [7:0] axi_rlen_o,

    //AXI write
    input wire wdata_resp_i,  // 閸愭瑩鏁撻弬銈嗗鎼存棃鏁撻懘姘卞皑閹凤拷
    output wire axi_wen_o,
    output wire [31:0] axi_waddr_o,
    output reg [31:0] axi_wdata_o,
    output wire axi_wvalid_o,
    output wire axi_wlast_o,
    output wire [7:0] axi_wlen_o
);  

    localparam  read_FREE = 3'b000;
    localparam  read_ICACHE = 3'b001;
    localparam  read_DCACHE = 3'b010;
    localparam  read_IUNCACHE = 3'b011; 
    localparam  read_DUNCACHE = 3'b100;

    localparam  write_FREE = 2'b00;
    localparam  write_BUSY = 2'b01;
    localparam  write_UNCACHE = 2'b10;

    reg [2:0] read_state;
    reg [2:0] next_read_state;
    reg [1:0] write_state;
    reg [1:0] next_write_state;

    reg [2:0] read_count;
    reg [2:0] write_count;

    assign axi_ce_o = rst ? 1'b0 : 1'b1;
    assign dev_rrdy_o = read_state == read_FREE;
    assign dev_wrdy_o = write_state == write_FREE;
    assign cache_axi_write_pre_ready = next_write_state == write_FREE;
    assign icache_ren_received = read_state == read_FREE & next_read_state == read_ICACHE;
    assign dcache_ren_received = read_state == read_FREE & next_read_state == read_DCACHE;
    assign icache_flush_flag_valid = read_state == read_ICACHE | next_read_state == read_ICACHE | read_state == read_IUNCACHE | next_read_state == read_IUNCACHE;

    always @(posedge clk)
    begin
        if(rst)
        begin
            read_state <= read_FREE;
            write_state <= write_FREE;
        end
        else
        begin
            read_state <= next_read_state;
            write_state <= next_write_state;
        end
    end

    //read state machine
    always @(*)
    begin
        case(read_state)
        read_FREE:begin
            if(duncache_ren_i) next_read_state = read_DUNCACHE;
            else if(iuncache_ren_i) next_read_state = read_IUNCACHE;
            else if(data_ren_i) next_read_state = read_DCACHE;
            else if(inst_ren_i) next_read_state = read_ICACHE;
            else next_read_state = read_FREE;
        end
        read_ICACHE:begin
            if(rdata_valid_i & read_count == 3'h7) next_read_state = read_FREE;
            else next_read_state = read_ICACHE;
        end
        read_DCACHE:begin
            if(rdata_valid_i & read_count == 3'h7) next_read_state = read_FREE;
            else next_read_state = read_DCACHE;
        end
        read_IUNCACHE:begin
            if(rdata_valid_i & read_count == 3'h1) next_read_state = read_FREE;
            else next_read_state = read_IUNCACHE;
        end
        read_DUNCACHE:begin
            if(rdata_valid_i) next_read_state = read_FREE;
            else next_read_state = read_DUNCACHE;
        end
        endcase
    end 

    //write state machine
    always @(*)
    begin
        case(write_state)
        write_FREE:begin
            if(duncache_wen_i) next_write_state = write_UNCACHE;
            else if(|data_wen_i) next_write_state = write_BUSY;
            else next_write_state = write_FREE;
        end
        write_BUSY:begin
            if(wdata_resp_i & write_count == 3'h7) next_write_state = write_FREE;
            else next_write_state = write_BUSY;
        end
        write_UNCACHE:begin
            if(wdata_resp_i) next_write_state = write_FREE;
            else next_write_state = write_UNCACHE;
        end
        endcase
    end

    //read and write counter
    always @(posedge clk)
    begin
        if(rst)
        begin
            read_count <= 3'b0;
            write_count <= 3'b0;
        end
        else
        begin
            if(read_state == read_FREE)
                read_count <= 3'b0;
            else if(rdata_valid_i)
                read_count <= read_count +1;
            if(write_state == write_FREE)
                write_count <= 3'b0;
            else if(wdata_resp_i)
                write_count <= write_count + 1;
        end
    end

    assign axi_ren_o = read_state != read_FREE;
    assign axi_rready_o = axi_ren_o;
    assign axi_raddr_o = (read_state == read_IUNCACHE) ? iuncache_raddr_i :
                         (read_state == read_DUNCACHE) ? duncache_raddr_i :
                         (read_state == read_DCACHE)   ? {data_araddr_i[31:5],5'b0} :
                         (read_state == read_ICACHE)   ? {inst_araddr_i[31:5],5'b0} : 32'b0;

    always @(posedge clk)
    begin
        if(rst)
        begin
            inst_rvalid_o <= 1'b0;
            data_rvalid_o <= 1'b0;
            iuncache_rvalid_o <= 1'b0;
            duncache_rvalid_o <= 1'b0;
        end
        else
        begin
            if(read_state == read_ICACHE & read_count == 3'h7 & rdata_valid_i)
                inst_rvalid_o <= 1'b1;
            else 
                inst_rvalid_o <= 1'b0;
            if(read_state == read_DCACHE & read_count == 3'h7 & rdata_valid_i)
                data_rvalid_o <= 1'b1;
            else
                data_rvalid_o <= 1'b0;
            if(read_state == read_IUNCACHE & read_count == 3'h1 & rdata_valid_i)
                iuncache_rvalid_o <= 1'b1;
            else
                iuncache_rvalid_o <= 1'b0;
            if(read_state == read_DUNCACHE & rdata_valid_i)
                duncache_rvalid_o <= 1'b1;
            else 
                duncache_rvalid_o <= 1'b0;
        end
    end
    //connected to the data block of icache or dcache
    always @(posedge clk)
    begin
        if(rst)
        begin
            inst_rdata_o <= 256'b0;
        end
        else if(rdata_valid_i)
        begin
            case(read_count)
            3'b000:inst_rdata_o[31:0]    <= rdata_i;
            3'b001:inst_rdata_o[63:32]   <= rdata_i;
            3'b010:inst_rdata_o[95:64]   <= rdata_i;
            3'b011:inst_rdata_o[127:96]  <= rdata_i;
            3'b100:inst_rdata_o[159:128] <= rdata_i;
            3'b101:inst_rdata_o[191:160] <= rdata_i;
            3'b110:inst_rdata_o[223:192] <= rdata_i;
            3'b111:inst_rdata_o[255:224] <= rdata_i;
            endcase
        end
    end

    always @(posedge clk)
    begin
        if(rst)
        begin
            data_rdata_o <= 256'b0;
        end
        else if(rdata_valid_i)
        begin
            case(read_count)
            3'b000:data_rdata_o[31:0] <= rdata_i;
            3'b001:data_rdata_o[63:32] <= rdata_i;
            3'b010:data_rdata_o[95:64] <= rdata_i;
            3'b011:data_rdata_o[127:96] <= rdata_i;
            3'b100:data_rdata_o[159:128] <= rdata_i;
            3'b101:data_rdata_o[191:160] <= rdata_i;
            3'b110:data_rdata_o[223:192] <= rdata_i;
            3'b111:data_rdata_o[255:224] <= rdata_i;
            endcase
        end
    end
    //duncache 
    always @(posedge clk)
    begin
        if(rst)
        begin
            duncache_rdata_o <= 32'b0;
            iuncache_rdata_o <= 64'b0;
        end
        else
        begin
            if(rdata_valid_i & read_state == read_DUNCACHE)
                duncache_rdata_o <= rdata_i;
            if(rdata_valid_i & read_state == read_IUNCACHE)
            begin
                case(read_count)
                3'b000:iuncache_rdata_o[31:0] <= rdata_i;
                3'b001:iuncache_rdata_o[63:32] <= rdata_i;
                default:;
                endcase
            end
        end
    end

    //AXI
    assign axi_wen_o = write_state != write_FREE; //娑撯偓閻╁娣柨鐔告灮閹烽娲块柨鐔告灮閹风兘鏁撻弬銈嗗闁跨喎鈧喎顦柨鐔告灮閹风兘鏁撻弬銈嗗闁跨喐鏋婚幏鐑芥晸閿燂拷
    assign axi_wvalid_o = write_state != write_FREE; //闁跨喐鏋婚幏鐑芥晸閺傘倖瀚归挊鏇℃闁跨喐鏋婚幏鐑芥晸閺傘倖瀚归柨鐔告灮閹风兘鏁撻懘姘卞皑閹风兘鏁撻幋顏嗗皑閹风兘鏁撻崜鍖＄秶閹风兘鏁撻弬銈嗗闁跨喐甯寸喊澶嬪闁跨喐鏋婚幏鐑芥晸閺傘倖瀚归柨鐔虹xi_interface,闁跨喐鏋婚幏绌墄i_interface闁跨喐鏋婚幏铚傜瘍濞岋繝鏁撻弬銈嗗闁跨喓鐓喊澶嬪闁跨喐鏋婚幏鐑芥晸閺傘倖瀚归挊鏇犲闁跨喐鏋婚幏鐑芥晸閺傘倖瀚圭€光偓娴兼瑦瀚归柨鐕傛嫹
    assign axi_wlen_o = (write_state == write_UNCACHE) ? 8'h0 : 8'h7;
    assign axi_rlen_o = read_state == read_IUNCACHE ? 8'h1 : ((read_state == read_DUNCACHE) ? 8'h0 : 8'h7);
    assign axi_wsel_o = (write_state == write_UNCACHE) ? duncache_wstrb : 4'b1111;    //////////////////////////
    assign axi_waddr_o = write_state == write_UNCACHE ? duncache_waddr_i : {data_awaddr_i[31:5],5'b0};
    assign axi_wlast_o = ((write_state == write_BUSY) & write_count == 3'h7) | write_state == write_UNCACHE;

    always @(posedge clk)
    begin
        if(rst)
        begin
            data_bvalid_o <= 1'b0;
            duncache_write_resp <= 1'b0;
        end
        else 
        begin
            data_bvalid_o <= wdata_resp_i & ((write_state == write_BUSY) & write_count == 3'h7 ) | (write_state == write_UNCACHE & wdata_resp_i);
            duncache_write_resp <= (write_state == write_UNCACHE) & wdata_resp_i;
        end
    end

    always @(*)
    begin
        if(write_state == write_UNCACHE)
        begin
            axi_wdata_o = duncache_wdata_i;
        end
        else
        begin
            case(write_count)
            3'b000:axi_wdata_o = data_wdata_i[31:0];
            3'b001:axi_wdata_o = data_wdata_i[63:32];
            3'b010:axi_wdata_o = data_wdata_i[95:64];
            3'b011:axi_wdata_o = data_wdata_i[127:96];
            3'b100:axi_wdata_o = data_wdata_i[159:128];
            3'b101:axi_wdata_o = data_wdata_i[191:160];
            3'b110:axi_wdata_o = data_wdata_i[223:192];
            3'b111:axi_wdata_o = data_wdata_i[255:224];
            default:axi_wdata_o = 32'b0;
        endcase
        end
    end
endmodule