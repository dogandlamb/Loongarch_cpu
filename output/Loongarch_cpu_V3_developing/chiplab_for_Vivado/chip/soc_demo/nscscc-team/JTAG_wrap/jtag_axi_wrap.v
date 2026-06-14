module jtag_axi_wrap(
    
    input           aclk,
    input           aresetn,

    //AXI interface 
    //Read address channel
    output   [ 3:0] m_axi_arid,
    output   [31:0] m_axi_araddr,
    output   [ 7:0] m_axi_arlen,
    output   [ 2:0] m_axi_arsize,
    output   [ 1:0] m_axi_arburst,
    output          m_axi_arlock,
    output   [ 3:0] m_axi_arcache,
    output   [ 2:0] m_axi_arprot,
    output          m_axi_arvalid,
    input           m_axi_arready,
    //Read data channel
    input    [ 3:0] m_axi_rid,
    input    [31:0] m_axi_rdata,
    input    [ 1:0] m_axi_rresp,
    input           m_axi_rlast,
    input           m_axi_rvalid,
    output          m_axi_rready,
    //Write address channel
    output   [ 3:0] m_axi_awid,
    output   [31:0] m_axi_awaddr,
    output   [ 7:0] m_axi_awlen,
    output   [ 2:0] m_axi_awsize,
    output   [ 1:0] m_axi_awburst,
    output          m_axi_awlock,
    output   [ 3:0] m_axi_awcache,
    output   [ 2:0] m_axi_awprot,
    output          m_axi_awvalid,
    input           m_axi_awready,
    //Write data channel
    output   [31:0] m_axi_wdata,
    output   [ 3:0] m_axi_wstrb,
    output          m_axi_wlast,
    output          m_axi_wvalid,
    input           m_axi_wready,
    //Write response channel
    input    [ 3:0] m_axi_bid,
    input    [ 1:0] m_axi_bresp,
    input           m_axi_bvalid,
    output          m_axi_bready,

    //输出处理器核复位信号
    output          core_rst_n

);

jtag_axi u_jtag_axi (
  .aclk(aclk),                    // input wire aclk
  .aresetn(aresetn),              // input wire aresetn
  .m_axi_awid(m_axi_awid),        // output wire [3 : 0] m_axi_awid
  .m_axi_awaddr(m_axi_awaddr),    // output wire [31 : 0] m_axi_awaddr
  .m_axi_awlen(m_axi_awlen),      // output wire [7 : 0] m_axi_awlen
  .m_axi_awsize(m_axi_awsize),    // output wire [2 : 0] m_axi_awsize
  .m_axi_awburst(m_axi_awburst),  // output wire [1 : 0] m_axi_awburst
  .m_axi_awlock(m_axi_awlock),    // output wire m_axi_awlock
  .m_axi_awcache(m_axi_awcache),  // output wire [3 : 0] m_axi_awcache
  .m_axi_awprot(m_axi_awprot),    // output wire [2 : 0] m_axi_awprot
  .m_axi_awqos(m_axi_awqos),      // output wire [3 : 0] m_axi_awqos
  .m_axi_awvalid(m_axi_awvalid),  // output wire m_axi_awvalid
  .m_axi_awready(m_axi_awready),  // input wire m_axi_awready
  .m_axi_wdata(m_axi_wdata),      // output wire [31 : 0] m_axi_wdata
  .m_axi_wstrb(m_axi_wstrb),      // output wire [3 : 0] m_axi_wstrb
  .m_axi_wlast(m_axi_wlast),      // output wire m_axi_wlast
  .m_axi_wvalid(m_axi_wvalid),    // output wire m_axi_wvalid
  .m_axi_wready(m_axi_wready),    // input wire m_axi_wready
  .m_axi_bid(m_axi_bid),          // input wire [3 : 0] m_axi_bid
  .m_axi_bresp(m_axi_bresp),      // input wire [1 : 0] m_axi_bresp
  .m_axi_bvalid(m_axi_bvalid),    // input wire m_axi_bvalid
  .m_axi_bready(m_axi_bready),    // output wire m_axi_bready
  .m_axi_arid(m_axi_arid),        // output wire [3 : 0] m_axi_arid
  .m_axi_araddr(m_axi_araddr),    // output wire [31 : 0] m_axi_araddr
  .m_axi_arlen(m_axi_arlen),      // output wire [7 : 0] m_axi_arlen
  .m_axi_arsize(m_axi_arsize),    // output wire [2 : 0] m_axi_arsize
  .m_axi_arburst(m_axi_arburst),  // output wire [1 : 0] m_axi_arburst
  .m_axi_arlock(m_axi_arlock),    // output wire m_axi_arlock
  .m_axi_arcache(m_axi_arcache),  // output wire [3 : 0] m_axi_arcache
  .m_axi_arprot(m_axi_arprot),    // output wire [2 : 0] m_axi_arprot
  .m_axi_arqos(m_axi_arqos),      // output wire [3 : 0] m_axi_arqos
  .m_axi_arvalid(m_axi_arvalid),  // output wire m_axi_arvalid
  .m_axi_arready(m_axi_arready),  // input wire m_axi_arready
  .m_axi_rid(m_axi_rid),          // input wire [3 : 0] m_axi_rid
  .m_axi_rdata(m_axi_rdata),      // input wire [31 : 0] m_axi_rdata
  .m_axi_rresp(m_axi_rresp),      // input wire [1 : 0] m_axi_rresp
  .m_axi_rlast(m_axi_rlast),      // input wire m_axi_rlast
  .m_axi_rvalid(m_axi_rvalid),    // input wire m_axi_rvalid
  .m_axi_rready(m_axi_rready)    // output wire m_axi_rready
);

reg jtag_download_time;

always @(posedge aclk or negedge aresetn) begin
    if(~aresetn) begin
        jtag_download_time <= 1'b0;
    end
    else begin
        if(m_axi_awvalid && m_axi_awready && m_axi_awaddr == 32'h8000_0000)begin
            jtag_download_time <= 1'b1;
        end
        else if(m_axi_awvalid && m_axi_awready && m_axi_awaddr == 32'h4000_0000)begin
            jtag_download_time <= 1'b0;
        end
        else begin
            jtag_download_time <= jtag_download_time;
        end
    end
end

assign core_rst_n = aresetn & (~jtag_download_time);

endmodule