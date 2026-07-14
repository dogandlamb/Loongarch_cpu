module axi3_to_axi4_bridge #(
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 32,
    parameter ID_WIDTH = 4,
    parameter W_Burst_Length_MAX = 4
)(
    input wire clk,
    input wire rst_n,
    
    // AXI3 Slave Interface
    // AW Channel
    input wire [ID_WIDTH-1:0]     s_axi3_awid,
    input wire [ADDR_WIDTH-1:0]   s_axi3_awaddr,
    input wire [3:0]              s_axi3_awlen,
    input wire [2:0]              s_axi3_awsize,
    input wire [1:0]              s_axi3_awburst,
    input wire [1:0]              s_axi3_awlock,
    input wire [3:0]              s_axi3_awcache,
    input wire [2:0]              s_axi3_awprot,
    input wire                    s_axi3_awvalid,
    output wire                   s_axi3_awready,
    
    // W Channel
    input wire [ID_WIDTH-1:0]     s_axi3_wid,
    input wire [DATA_WIDTH-1:0]   s_axi3_wdata,
    input wire [(DATA_WIDTH/8)-1:0] s_axi3_wstrb,
    input wire                    s_axi3_wlast,
    input wire                    s_axi3_wvalid,
    output wire                   s_axi3_wready,
    
    // B Channel
    output wire [ID_WIDTH-1:0]    s_axi3_bid,
    output wire [1:0]             s_axi3_bresp,
    output wire                   s_axi3_bvalid,
    input wire                    s_axi3_bready,
    
    // AR Channel
    input wire [ID_WIDTH-1:0]     s_axi3_arid,
    input wire [ADDR_WIDTH-1:0]   s_axi3_araddr,
    input wire [3:0]              s_axi3_arlen,
    input wire [2:0]              s_axi3_arsize,
    input wire [1:0]              s_axi3_arburst,
    input wire [1:0]              s_axi3_arlock,
    input wire [3:0]              s_axi3_arcache,
    input wire [2:0]              s_axi3_arprot,
    input wire                    s_axi3_arvalid,
    output wire                   s_axi3_arready,
    
    // R Channel
    output wire [ID_WIDTH-1:0]    s_axi3_rid,
    output wire [DATA_WIDTH-1:0]  s_axi3_rdata,
    output wire [1:0]             s_axi3_rresp,
    output wire                   s_axi3_rlast,
    output wire                   s_axi3_rvalid,
    input wire                    s_axi3_rready,
    
    // AXI4 Master Interface
    // AW Channel
    output wire [ID_WIDTH-1:0]    m_axi4_awid,
    output wire [ADDR_WIDTH-1:0]  m_axi4_awaddr,
    output wire [7:0]             m_axi4_awlen,
    output wire [2:0]             m_axi4_awsize,
    output wire [1:0]             m_axi4_awburst,
    output wire                   m_axi4_awlock,
    output wire [3:0]             m_axi4_awcache,
    output wire [2:0]             m_axi4_awprot,
    output wire                   m_axi4_awvalid,
    input wire                    m_axi4_awready,
    
    // W Channel
    output wire [DATA_WIDTH-1:0]  m_axi4_wdata,
    output wire [(DATA_WIDTH/8)-1:0] m_axi4_wstrb,
    output wire                   m_axi4_wlast,
    output wire                   m_axi4_wvalid,
    input wire                    m_axi4_wready,
    
    // B Channel
    input wire [ID_WIDTH-1:0]     m_axi4_bid,
    input wire [1:0]              m_axi4_bresp,
    input wire                    m_axi4_bvalid,
    output wire                   m_axi4_bready,
    
    // AR Channel
    output wire [ID_WIDTH-1:0]    m_axi4_arid,
    output wire [ADDR_WIDTH-1:0]  m_axi4_araddr,
    output wire [7:0]             m_axi4_arlen,
    output wire [2:0]             m_axi4_arsize,
    output wire [1:0]             m_axi4_arburst,
    output wire                   m_axi4_arlock,
    output wire [3:0]             m_axi4_arcache,
    output wire [2:0]             m_axi4_arprot,
    output wire                   m_axi4_arvalid,
    input wire                    m_axi4_arready,
    
    // R Channel
    input wire [ID_WIDTH-1:0]     m_axi4_rid,
    input wire [DATA_WIDTH-1:0]   m_axi4_rdata,
    input wire [1:0]              m_axi4_rresp,
    input wire                    m_axi4_rlast,
    input wire                    m_axi4_rvalid,
    output wire                   m_axi4_rready
);
    // 处理AW和W之间的乱序与交织
    // 状态
    localparam S_IDLE       = 3'h0; //等待主机的AW
    localparam S_AW_ENTER   = 3'h1; //收到主机的AW,等待主机的W
    localparam S_W_ENTER    = 3'h2; //收到主机的W,等待向从机发送
    localparam S_AW_SENDING = 3'h3; //向从机发送AW
    localparam S_W_SENDING  = 3'h4; //向从机发送W

    reg [2:0] state [3:0];
    reg [2:0] next_state [3:0];

    reg [ID_WIDTH-1:0]          buffer_awid[3:0];
    reg [ADDR_WIDTH-1:0]        buffer_awaddr[3:0];
    reg [3:0]                   buffer_awlen[3:0];
    reg [2:0]                   buffer_awsize[3:0];
    reg [1:0]                   buffer_awburst[3:0];
    reg [1:0]                   buffer_awlock[3:0];
    reg [3:0]                   buffer_awcache[3:0];
    reg [2:0]                   buffer_awprot[3:0];

    reg [$clog2(W_Burst_Length_MAX)-1:0] write_cnt[3:0];
    reg [DATA_WIDTH-1:0]        buffer_wdata[0:3][0:W_Burst_Length_MAX-1];
    reg [(DATA_WIDTH/8)-1:0]    buffer_wstrb[0:3][0:W_Burst_Length_MAX-1];
    reg                         buffer_wlast[0:3][0:W_Burst_Length_MAX-1];

    wire [3:0] state_idle;
    wire [3:0] state_aw_enter;
    wire [3:0] state_w_enter;
    wire [3:0] state_aw_sending;
    wire [3:0] state_w_sending;

    //find state first one
    wire [3:0] state_idle_one;
    wire [3:0] state_w_enter_one;

    first_one_4_4 u_sel_idle (.in(state_idle), .out(state_idle_one));
    first_one_4_4 u_sel_w_enter (.in(state_w_enter), .out(state_w_enter_one));

    wire [1:0] aw_ptr;
    wire [1:0] w_ptr;

    encode_4_2 u_aw_ptr(.in(state_aw_sending), .out(aw_ptr));
    encode_4_2 u_w_ptr (.in(state_w_sending), .out(w_ptr));

    wire can_send_aw = !((|state_aw_sending) || (|state_w_sending));

    wire [3:0] awid_one;
    first_one_id u_awid_one (.id0(buffer_awid[0]), .id1(buffer_awid[1]),
                             .id2(buffer_awid[2]), .id3(buffer_awid[3]), .id_valid(state_aw_enter), .out(awid_one));

/***********************BEGIN of 状态机********************************/

genvar i,j;
generate 
for(i=0; i<4;i=i+1) begin
    assign state_idle[i]        = (state[i] == S_IDLE       );
    assign state_aw_enter[i]    = (state[i] == S_AW_ENTER   );
    assign state_w_enter[i]     = (state[i] == S_W_ENTER    );
    assign state_aw_sending[i]  = (state[i] == S_AW_SENDING );
    assign state_w_sending[i]   = (state[i] == S_W_SENDING  );    

    always @(posedge clk or negedge rst_n) begin
        if(~rst_n)
            state[i] <= S_IDLE;
        else begin
            state[i] <= next_state[i];
        end
    end

    //状态跳转控制
    always @(*) begin
        case(state[i])
            S_IDLE : begin
                if(state_idle_one[i] & s_axi3_awvalid & s_axi3_awready)
                    next_state[i] = S_AW_ENTER;
                else
                    next_state[i] = S_IDLE;
            end
            S_AW_ENTER : begin
                if(s_axi3_wvalid & s_axi3_wready & s_axi3_wlast & s_axi3_wid == buffer_awid[i] & awid_one[i])
                    next_state[i] = S_W_ENTER;
                else
                    next_state[i] = S_AW_ENTER;
            end
            S_W_ENTER : begin
                if(state_w_enter_one[i] & can_send_aw)
                    next_state[i] = S_AW_SENDING;
                else
                    next_state[i] = S_W_ENTER;
            end
            S_AW_SENDING : begin
                if(m_axi4_awvalid & m_axi4_awready)
                    next_state[i] = S_W_SENDING;
                else
                    next_state[i] = S_AW_SENDING;
            end
            S_W_SENDING : begin
                if(m_axi4_wvalid & m_axi4_wready & m_axi4_wlast)
                    next_state[i] = S_IDLE;
                else
                    next_state[i] = S_W_SENDING;
            end
            default     :begin
                next_state[i] = S_IDLE;
            end
        endcase
    end


    always @ (posedge clk) begin
        if(s_axi3_awvalid & s_axi3_awready & state_idle_one[i]) begin
            buffer_awid[i]      <= s_axi3_awid;
            buffer_awaddr[i]    <= s_axi3_awaddr;
            buffer_awlen[i]     <= s_axi3_awlen;
            buffer_awsize[i]    <= s_axi3_awsize;
            buffer_awburst[i]   <= s_axi3_awburst;
            buffer_awlock[i]    <= s_axi3_awlock;
            buffer_awcache[i]   <= s_axi3_awcache;
            buffer_awprot[i]    <= s_axi3_awprot;
        end
    end
    always @ (posedge clk) begin
        if(state_idle[i]) begin
            write_cnt[i]        <= 'd0;
        end
        else if(s_axi3_wvalid & s_axi3_wready & (s_axi3_wid == buffer_awid[i]) & awid_one[i])begin
            if(s_axi3_wlast)
                write_cnt[i] <= 'd0;
            else
                write_cnt[i] <= write_cnt[i] + 1'b1;
        end
    end

    for(j=0; j<W_Burst_Length_MAX;j=j+1) begin
        always @ (posedge clk) begin
            if(s_axi3_wvalid & s_axi3_wready & (s_axi3_wid == buffer_awid[i]) & awid_one[i] & (write_cnt[i] == j))begin
                buffer_wdata[i] [j] <= s_axi3_wdata;
                buffer_wstrb[i] [j] <= s_axi3_wstrb;
                buffer_wlast[i] [j] <= s_axi3_wlast;
            end
        end
    end

    //下面这段有问题
/*
    always @ (posedge clk) begin
        if(s_axi3_wvalid & s_axi3_wready & (s_axi3_wid == buffer_awid[i]) & awid_one[i])begin
            buffer_wdata[i] [write_cnt[i]] <= s_axi3_wdata;
            buffer_wstrb[i] [write_cnt[i]] <= s_axi3_wstrb;
            buffer_wlast[i] [write_cnt[i]] <= s_axi3_wlast;
        end
    end
*/
/*
    always @ (posedge clk) begin
        if(state_idle[i]) begin
            write_cnt[i]        <= 'd0;
        end
        else if(s_axi3_wvalid & s_axi3_wready & (s_axi3_wid == buffer_awid[i]) & awid_one[i])begin
            buffer_wdata[i] [write_cnt[i]] <= s_axi3_wdata;
            buffer_wstrb[i] [write_cnt[i]] <= s_axi3_wstrb;
            buffer_wlast[i] [write_cnt[i]] <= s_axi3_wlast;
            write_cnt[i] <= s_axi3_wlast ? 'd0 : write_cnt[i] + 1'b1;
        end
    end
    */
end
endgenerate


    // always @ (posedge clk) begin
    //     if(s_axi3_wvalid & s_axi3_wready & (s_axi3_wid == buffer_awid[0]) & awid_one[0] & write_cnt[0] == 2'd0)begin
    //         buffer_wdata[0][0] <= s_axi3_wdata;
    //         buffer_wstrb[0][0] <= s_axi3_wstrb;
    //         buffer_wlast[0][0] <= s_axi3_wlast;
    //     end
    // end

// AW Channel
assign s_axi3_awready   = |state_idle;

assign m_axi4_awvalid   = |state_aw_sending;
assign m_axi4_awid      = buffer_awid[aw_ptr];
assign m_axi4_awaddr    = buffer_awaddr[aw_ptr];
assign m_axi4_awlen     = {4'h0, buffer_awlen[aw_ptr]};
assign m_axi4_awsize    = buffer_awsize[aw_ptr];
assign m_axi4_awburst   = buffer_awburst[aw_ptr];
assign m_axi4_awlock    = buffer_awlock[aw_ptr][0];
assign m_axi4_awcache   = buffer_awcache[aw_ptr];
assign m_axi4_awprot    = buffer_awprot[aw_ptr];

// W Channel
assign s_axi3_wready    = |state_aw_enter;

reg [$clog2(W_Burst_Length_MAX)-1:0] wdata_cnt;
always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        wdata_cnt <= 'd0;
    end
    else begin
        if(m_axi4_wvalid & m_axi4_wready & m_axi4_wlast) begin
            wdata_cnt <= 'd0;
        end
        else if (m_axi4_wvalid & m_axi4_wready) begin
            wdata_cnt <= wdata_cnt + 1'b1;
        end
    end
end

assign m_axi4_wvalid    = |state_w_sending;
assign m_axi4_wdata     = buffer_wdata[w_ptr] [wdata_cnt];
assign m_axi4_wstrb     = buffer_wstrb[w_ptr] [wdata_cnt];
assign m_axi4_wlast     = buffer_wlast[w_ptr] [wdata_cnt];

// B Channel
assign s_axi3_bid = m_axi4_bid;
assign s_axi3_bresp = m_axi4_bresp;
assign s_axi3_bvalid = m_axi4_bvalid;
assign m_axi4_bready = s_axi3_bready;

// AR Channel (直通转发，读通道无需处理交织)
assign m_axi4_arid = s_axi3_arid;
assign m_axi4_araddr = s_axi3_araddr;
assign m_axi4_arlen = {4'h0, s_axi3_arlen};
assign m_axi4_arsize = s_axi3_arsize;
assign m_axi4_arburst = s_axi3_arburst;
assign m_axi4_arlock = s_axi3_arlock[0];
assign m_axi4_arcache = s_axi3_arcache;
assign m_axi4_arprot = s_axi3_arprot;
assign m_axi4_arvalid = s_axi3_arvalid;
assign s_axi3_arready = m_axi4_arready;

// R Channel
assign s_axi3_rid = m_axi4_rid;
assign s_axi3_rdata = m_axi4_rdata;
assign s_axi3_rresp = m_axi4_rresp;
assign s_axi3_rlast = m_axi4_rlast;
assign s_axi3_rvalid = m_axi4_rvalid;
assign m_axi4_rready = s_axi3_rready;

endmodule

module first_one_4_4(
    input [3:0]  in,
    output [3:0] out
);

    assign out[0] = in[0];
    assign out[1] = in[1] & (~in[0]);
    assign out[2] = in[2] & (~|in[1:0]);
    assign out[3] = in[3] & (~|in[2:0]);

endmodule

module encode_4_2(
    input [3:0] in,
    output [1:0] out
);
    assign out =    ({4{in[0]}}&2'b00) | ({4{in[1]}}&2'b01) |
                    ({4{in[2]}}&2'b10) | ({4{in[3]}}&2'b11);
endmodule

module first_one_id #(
    parameter ID_WIDTH = 4
)(
    input [ID_WIDTH-1:0] id0,
    input [ID_WIDTH-1:0] id1,
    input [ID_WIDTH-1:0] id2,
    input [ID_WIDTH-1:0] id3,
    input [3:0]          id_valid,
    output [3:0]         out
);
    assign out[0] = id_valid[0] ? 1'b1 : 1'b0;
    assign out[1] = id_valid[1] ? ((~id_valid[0])||(|(id1^id0))) : 1'b0;
    assign out[2] = id_valid[2] ? ((~id_valid[0])||(|(id2^id0))) & ((~id_valid[1])||(|(id2^id1))) : 1'b0;
    assign out[3] = id_valid[3] ? ((~id_valid[0])||(|(id3^id0))) & ((~id_valid[1])||(|(id3^id1))) & ((~id_valid[2])||(|(id3^id2))) : 1'b0;
endmodule
