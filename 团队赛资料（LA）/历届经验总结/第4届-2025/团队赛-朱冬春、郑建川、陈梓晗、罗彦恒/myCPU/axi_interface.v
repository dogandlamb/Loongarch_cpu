`include "defines.vh"

module axi_interface
(
    input wire clk,
    input wire rst,
    //connected to cache_axi
    input wire cache_ce,
    input wire cache_wen,          //来自cache_axi的写使能，生成逻辑为cache_axi中write状态不为write_FREE
    input wire [3:0] cache_wsel,   //连接cache axi的axi_wsel_o
    input wire cache_ren,          //来自cache_axi的读使能，生成逻辑为cache_axi中read状态不为read_FREE
    input wire [31:0] cache_raddr,
    input wire [31:0] cache_waddr,
    input wire [31:0] cache_wdata,
    input wire cache_rready,      //cache准备好读，生成逻辑是cache_axi的read状态不为read_RFEE
    input wire cache_wvalid,      //来自cache_axi，生成逻辑与上面的cache_wen一样，意义不明，但暂时保留，后续看可以删掉
    input wire cache_wlast,       //指示这是最后的32位数据
    output wire wdata_resp_o,     //写响应，连接cache_axi,在该信号为1时，cache_axi中的write计数器在clk上升沿自增
    
    input wire [1:0] cache_brust_type,  //由于icache和dcache数据块大小相同，固定为递增地址模式，即2'b01
    input wire [2:0] cache_brust_size,  //每次传输的数据包的大小，固定为32b，即该值固定为3'b010
    input wire [7:0] cacher_burst_length, //与cache块大小有关，若为128位，则该值为3，若为256位，则该值为7，连接cache_axi的axi_wlen_o
    input wire [7:0] cachew_burst_length, //同上一行的注释，连接cache_axi的axi_rlen_o

    //conneceed to AXI :AR,R,AW,W,B (详见实验4：AXI总线接口设计-实验原理)
    //AR读地址
    output wire [3:0] arid,        //cache的设备ID，assign赋固定值4'b0000
    output reg [31:0] araddr,      
    output reg [7:0] arlen,       //读时在clk上升沿被赋值为上面的cacher_burst_length
    output reg [2:0] arsize,
    output reg [1:0] arburst,
    output wire [1:0] arlock,    //值为2'b00，assign直接赋值，功能不明
    output reg [3:0] arcache,    //下文中仅可能被赋值为4'b0000，功能不明
    output wire [2:0] arprot,    //assign直接赋值为3'b000，功能不明
    output reg arvalid ,         //读地址有效信号
    input wire arready,          //从设备的AR通道就绪
    //R读数据
    input wire [3:0] rid,
    input wire [31:0] rdata,    //AXI返回的单个数据包
    input wire [1:0] rresp,     //读请求响应，下文中没有再次出现，暂时保留，后面可去除
    input wire rlast,           //来自总线，指示最后一个32位数据
    input wire rvalid,          //来自总线，表示读回的数据有效
    output reg rready,          //交给总线的信号，表示读地址已发送，cache这边准备好接受返回的读数据
    output reg [31:0] rdata_o,  //给cache_axi返回的读数据
    output reg rdata_valid_o,
    //AW写地址
    output wire [3:0] awid,     //assign awid=4'b0000
    output reg [31:0] awaddr,   //发送给总线的写地址
    output reg [7:0] awlen,     //数据包个数
    output reg [2:0] awsize,    //+1后为单个数据包大小
    output reg [1:0] awburst,
    output wire [1:0] awlock,   //assign awlock = 2'b00
    output reg [3:0] awcache,
    output wire [2:0] awprot,   //assign awport = 3'b000
    output reg awvalid,         //给总线的写地址有效
    input wire awready,         //从设备的AW通道就绪
    //W写数据
    output wire [3:0] wid,     //assign wid = 4'b0000
    output reg [31:0] wdata,   //给总线的写数据
    output reg [3:0] wstrb,    //给总线的按字节的写使能，意义不明的4位，应该只有4'b0000和4'b1111
    output reg wlast,          //向总线指示最后32位数据
    output reg wvalid,         //写数据有效
    input wire wready,         //从设备w通道就绪，信号来自总线
    //写响应
    input wire [3:0] bid,      //当前写响应对应的主设备ID
    input wire [1:0] bresp,    //写请求的响应，下面没有再次出现，可去掉
    input wire bvalid,         //写响应有效，指示写完成
    output wire bready         //assign bready = 1,主设备B通道就绪
);  

    localparam AXI_IDLE = 2'b00;
    localparam ARREADY = 2'b01;
    localparam RVALID = 2'b10;

    //共用一个AXI_IDLE宏定义
    localparam AWREADY = 2'b01;
    localparam WREADY = 2'b10;
    localparam BVALID = 2'b11;

    reg [1:0] r_state;
    reg [1:0] r_next_state;
    reg [1:0] w_state;
    reg [1:0] w_next_state;

    // AXI参数设置
    assign arid         = 4'b0001;
    assign arlock       = 2'b0;
    assign arprot       = 3'b000;
    assign awid         = 4'b0001;
    assign awlock       = 2'b0;
    assign awprot       = 3'b000;
    assign wid          = 4'b0001;
    assign bready       = 1'b1;

    assign wdata_resp_o = (w_state == WREADY) ? wready : 1'b0;

    //状态机
    always @(posedge clk)
    begin
        if(rst)
        begin
            r_state <= AXI_IDLE;
            w_state <= AXI_IDLE;
        end
        else
        begin
            r_state <= r_next_state;
            w_state <= w_next_state;
        end
    end

    //读状态机
    always @(*)
    begin
        case(r_state)
        AXI_IDLE:begin
            if(cache_ce & cache_ren & !(cache_raddr == awaddr && w_next_state != AXI_IDLE))
                r_next_state = ARREADY;
            else 
                r_next_state = AXI_IDLE;
        end
        ARREADY:begin
            if(arready) 
                r_next_state = RVALID;
            else 
                r_next_state = ARREADY;
        end
        RVALID:begin
            if(!rvalid & !rready & rdata_valid_o)
                r_next_state = AXI_IDLE;
            else
                r_next_state = RVALID;
        end
        default:r_next_state = AXI_IDLE;
        endcase
    end
    //写状态机
    always @(*)
    begin
        case(w_state)
        AXI_IDLE:begin
            if(cache_ce & cache_wen)
                w_next_state = AWREADY;
            else
                w_next_state = AXI_IDLE;
        end
        AWREADY:begin
            if(awready)
                w_next_state = WREADY;
            else 
                w_next_state = AWREADY;
        end
        WREADY:begin
            if(wready & wlast & wvalid)
                w_next_state = BVALID;
            else
                w_next_state = WREADY;
        end
        BVALID:begin
            if(bvalid)
                w_next_state = AXI_IDLE;
            else 
                w_next_state = BVALID;
        end
        default:w_next_state = AXI_IDLE;
        endcase
    end

    always @(posedge clk)
    begin
        if(rst)
        begin
            araddr <= 32'b0;
            arlen <= 8'b0;
            arsize <= 3'b100;
            arburst <= 2'b01;
            arcache <= 4'b0;
            arvalid <= 1'b0;
            rready <= 1'b0;
            rdata_o <= 32'b0;
            rdata_valid_o <= 1'b0;
            awaddr <= 32'b0;
            awlen <= 8'b0;
            awsize <= 3'b100;
            awburst <= 2'b01;
            awcache <= 4'b0;
            awvalid <= 1'b0;
            wvalid <= 1'b0;
            wdata <= 32'b0;
            wstrb <= 4'b1111;
            wlast <= 1'b0;
        end
        else
        begin
            case(r_state)
            AXI_IDLE:begin
                rready <= 1'b0;
                rdata_o <= 32'b0;
                rdata_valid_o <= 1'b0;
                if(cache_ce && cache_ren && !(cache_raddr == awaddr && w_next_state != AXI_IDLE))
                begin
                    arlen <= cacher_burst_length;
                    arsize <= cache_brust_size;
                    arburst <= cache_brust_type;
                    arcache <= 4'b0;
                    arvalid <= 1'b1;
                    araddr <= cache_raddr;
                end
                else
                begin
                    arvalid <= 1'b0;
                    araddr <= 32'b0;
                    arlen <= 8'b0;
                    arburst <= 2'b01;
                    arcache <= 4'b0;
                end
            end
            ARREADY:begin
                if(arready)
                begin
                    araddr <= 32'b0;
                    arlen <= 8'b0;
                    arburst <= 2'b01;
                    arcache <= 4'b0;
                    arvalid <= 1'b0;
                    rready <= 1'b1;
                end
            end
            RVALID:begin
                rdata_valid_o <= rvalid;
                if(rvalid & rlast)
                begin
                    rdata_o <= rdata;
                    rready <= 1'b0;
                end
                else if(rvalid)
                begin
                    rdata_o <= rdata;
                end
                else if(!rvalid & !rready & rdata_valid_o)
                    arsize <= 3'b010;
            end
            default:;
            endcase
            case(w_state)
            AXI_IDLE:begin
                if(cache_ce & cache_wen)
                begin
                    awlen <= cachew_burst_length;
                    if(cache_wsel == 4'b0001 || cache_wsel == 4'b0010 || cache_wsel == 4'b0100 || cache_wsel == 4'b1000)
                        awsize <= 3'b000;
                    else if(cache_wsel == 4'b0011 ||cache_wsel == 4'b1100)
                        awsize <= 3'b001;
                    //上面这两种看起来比较奇怪的情况应该是由于dcache的uncache模式引起的，具体的我暂时不太清楚
                    else
                        awsize <= cache_brust_size;
                    awburst <= cache_brust_type;
                    awcache <= 4'b0;
                    awvalid <= 1'b1;
                    awaddr <= cache_waddr;
                    wstrb <= cache_wsel;
                    wlast <= 1'b0;
                end
                else
                begin
                    wvalid <= 1'b0;
                    wdata <= 32'b0;
                    wlast <= 1'b0;
                    awaddr <= 32'b0;
                    awlen <= 8'b0;
                    awburst <= 2'b01;
                    awcache <= 4'b0;
                    awvalid <= 1'b0;
                end
            end
            AWREADY:begin
                if(awready)
                begin
                    awlen <= 8'b0;
                    awburst <= 2'b01;
                    awcache <= 4'b0;
                    awvalid <= 1'b0;
                    wvalid <= 1'b0;
                    wdata <= cache_wdata;
                    wlast <= 1'b0;
                end
            end
            WREADY:begin
                if(wready & wlast & wvalid)  //写入完成，wvalid信号置0
                begin
                    wvalid <= 1'b0;
                    wdata <= cache_wdata;
                    wlast <= 1'b0;
                end
                else if(wdata_resp_o)
                begin
                    wvalid <= 1'b1;
                    wdata <= cache_wdata;
                    wlast <= cache_wlast;
                end
                else
                begin
                    wvalid <= wvalid;
                    wdata <= wdata;
                    wlast <= wlast;
                end
            end
            BVALID:begin
                wvalid <= 1'b0;
                wlast <= 1'b0;
                wstrb <= 4'b1111;
                awsize <= 3'b010;
                if(bvalid)
                begin
                    awaddr <= 32'b0;
                end
            end
            default:;
            endcase
        end
    end
endmodule