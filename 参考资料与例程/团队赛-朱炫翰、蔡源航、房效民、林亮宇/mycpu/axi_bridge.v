module axi_bridge(
    input   clk,
    input   reset,

    output   reg[ 3:0] arid,
    output   reg[31:0] araddr,
    output   reg[ 7:0] arlen,
    output   reg[ 2:0] arsize,
    output      [ 1:0] arburst,
    output      [ 1:0] arlock,
    output      [ 3:0] arcache,
    output      [ 2:0] arprot,
    output   reg       arvalid,
    input              arready,

    input    [ 3:0] rid,
    input    [31:0] rdata,
    input    [ 1:0] rresp,
    input           rlast,
    input           rvalid,
    output   reg    rready,

    output      [ 3:0] awid,
    output   reg[31:0] awaddr,
    output   reg[ 7:0] awlen,
    output   reg[ 2:0] awsize,
    output      [ 1:0] awburst,
    output      [ 1:0] awlock,
    output      [ 3:0] awcache,
    output      [ 2:0] awprot,
    output   reg       awvalid,
    input              awready,

    output      [ 3:0] wid,
    output   reg[31:0] wdata,
    output   reg[ 3:0] wstrb,
    output   reg       wlast,
    output   reg       wvalid,
    input              wready,

    input    [ 3:0] bid,
    input    [ 1:0] bresp,
    input           bvalid,
    output   reg    bready,
    //cache sign
    input            inst_rd_req     ,
    input  [ 2:0]    inst_rd_type    ,
    input  [31:0]    inst_rd_addr    ,
    output           inst_rd_rdy     ,
    output           inst_ret_valid  ,
    output           inst_ret_last   ,
    output [31:0]    inst_ret_data   ,
    input            inst_wr_req     ,
    input  [ 2:0]    inst_wr_type    ,
    input  [31:0]    inst_wr_addr    ,
    input  [ 3:0]    inst_wr_wstrb   ,
    input  [127:0]   inst_wr_data    ,
    output           inst_wr_rdy     ,

    input            data_rd_req     ,
    input  [ 2:0]    data_rd_type    ,
    input  [31:0]    data_rd_addr    ,
    output           data_rd_rdy     ,
    output           data_ret_valid  ,
    output           data_ret_last   ,
    output [31:0]    data_ret_data   ,
    input            data_wr_req     ,
    input  [ 2:0]    data_wr_type    ,
    input  [31:0]    data_wr_addr    ,
    input  [ 3:0]    data_wr_wstrb   ,
    input  [127:0]   data_wr_data    ,
    output           data_wr_rdy     ,
    output           write_buffer_empty
);



//fixed signal
assign  arburst = 2'b1;
assign  arlock  = 2'b0;
assign  arcache = 4'b0;
assign  arprot  = 3'b0;
assign  awid    = 4'b1;
assign  awburst = 2'b1;
assign  awlock  = 2'b0;
assign  awcache = 4'b0;
assign  awprot  = 3'b0;
assign  wid     = 4'b1;

assign  inst_wr_rdy = 1'b1;

localparam STATE_READ_IDLE = 1'b0;
localparam STATE_READ_REQUEST_SENT = 1'b1;
localparam STATE_READ_RESPONSE_IDLE = 1'b0;
localparam STATE_READ_RESPONSE_ACTIVE = 1'b1;
localparam STATE_WRITE_REQUEST_IDLE = 3'b000;
localparam STATE_WRITE_ADDR_ACTIVE = 3'b001;
localparam STATE_WRITE_DATA_ACTIVE = 3'b010;
localparam STATE_WRITE_ALL_ACTIVE = 3'b011;
localparam STATE_WRITE_DATA_TRANSFORM = 3'b100;
localparam STATE_WRITE_DATA_WAIT = 3'b101;
localparam STATE_WRITE_WAIT_RESPONSE = 3'b110;

reg       current_read_state;
reg       current_read_response_state;
reg [2:0] current_write_state;

wire      write_wait_enable;

wire         rd_requst_state_is_empty;
wire         rd_requst_can_receive;

assign rd_requst_state_is_empty = current_read_state == STATE_READ_IDLE;

wire        data_read_cache_line;
wire        inst_read_cache_line;
wire [ 2:0] data_real_read_size;
wire [ 7:0] data_real_read_len ;
wire [ 2:0] inst_real_read_size;
wire [ 7:0] inst_real_read_len ;
wire        data_write_cache_line;
wire [ 2:0] data_real_wr_size;
wire [ 7:0] data_real_wr_len ;

reg [127:0] write_buffer_data;
reg [ 2:0]  write_buffer_num;

wire        write_buffer_last;

//read type must be cache line
assign data_read_cache_line = data_rd_type == 3'b100                   ;
assign data_real_read_size  = data_read_cache_line ? 3'b10 : data_rd_type;
assign data_real_read_len   = data_read_cache_line ? 8'b11 : 8'b0        ;

assign write_buffer_empty = (write_buffer_num == 3'b0) && !write_wait_enable;

assign rd_requst_can_receive = rd_requst_state_is_empty && !(write_wait_enable && !(bvalid && bready));

assign data_rd_rdy = rd_requst_can_receive;
assign inst_rd_rdy = !data_rd_req && rd_requst_can_receive;

//write size can be special
assign data_write_cache_line = data_wr_type == 3'b100;
assign data_real_wr_size  = data_write_cache_line ? 3'b10 : data_wr_type;
assign data_real_wr_len   = data_write_cache_line ? 8'b11 : 8'b0             ;



assign inst_read_cache_line = inst_rd_type == 3'b100                   ;
assign inst_read_double_cache_line = inst_rd_type == 3'b101                   ;
assign inst_real_read_size  = inst_read_cache_line || inst_read_double_cache_line ? 3'b10 : inst_rd_type;
assign inst_real_read_len   = inst_read_double_cache_line ? 8'b111 : (inst_read_cache_line ? 8'b11 : 8'b0);



assign data_wr_rdy = (current_write_state == STATE_WRITE_REQUEST_IDLE);

assign write_buffer_last = write_buffer_num == 3'b1;


assign write_wait_enable = ~(current_write_state == STATE_WRITE_REQUEST_IDLE);

assign inst_ret_valid = !rid[0] && rvalid;
assign inst_ret_last  = !rid[0] && rlast;
assign inst_ret_data  = rdata;    //this signal needed buffer???
assign data_ret_valid =  rid[0] && rvalid;
assign data_ret_last  =  rid[0] && rlast;
assign data_ret_data  = rdata;


always @(posedge clk) begin
        if (reset) begin
        current_read_state <= STATE_READ_IDLE;
        arvalid <= 1'b0;
    end
    else case (current_read_state)
        STATE_READ_IDLE: begin
            if (data_rd_req) begin
                if (write_wait_enable) begin
                    if (bvalid && bready) begin   //when wait write back, stop send read request. easiest way.
                        current_read_state <= STATE_READ_REQUEST_SENT;
                        arid <= 4'b1;
                        araddr <= data_rd_addr;
                        arsize <= data_real_read_size;
                        arlen  <= data_real_read_len;
                        arvalid <= 1'b1;
                    end
                end
                else begin
                    current_read_state <= STATE_READ_REQUEST_SENT;
                    arid <= 4'b1;
                    araddr <= data_rd_addr;
                    arsize <= data_real_read_size;
                    arlen  <= data_real_read_len;
                    arvalid <= 1'b1;
                end
            end
            else if (inst_rd_req) begin
                if (write_wait_enable) begin
                    if (bvalid && bready) begin
                        current_read_state <= STATE_READ_REQUEST_SENT;
                        arid <= 4'b0;
                        araddr <= inst_rd_addr;
                        arsize <= inst_real_read_size;
                        arlen  <= inst_real_read_len;
                        arvalid <= 1'b1;
                    end
                end
                else begin
                    current_read_state <= STATE_READ_REQUEST_SENT;
                    arid <= 4'b0;
                    araddr <= inst_rd_addr;
                    arsize <= inst_real_read_size;
                    arlen  <= inst_real_read_len;
                    arvalid <= 1'b1;
                end
            end
        end
        STATE_READ_REQUEST_SENT: begin
            if (arready && arid[0]) begin
                current_read_state <= STATE_READ_IDLE;
                arvalid <= 1'b0;
            end
            else if (arready && !arid[0]) begin 
                current_read_state <= STATE_READ_IDLE;
                arvalid <= 1'b0;
            end
        end
    endcase

end

always @(posedge clk) begin


    if (reset) begin
        current_read_response_state <= STATE_READ_RESPONSE_IDLE;
        rready <= 1'b1;
    end
    else case (current_read_response_state)
        STATE_READ_RESPONSE_IDLE: begin
            if (rvalid && rready) begin 
                current_read_response_state <= STATE_READ_RESPONSE_ACTIVE;
            end
        end
        STATE_READ_RESPONSE_ACTIVE: begin
            if (rlast && rvalid) begin
                current_read_response_state <= STATE_READ_RESPONSE_IDLE;
            end
        end
    endcase
end

always @(posedge clk) begin

        if (reset) begin
        current_write_state <= STATE_WRITE_REQUEST_IDLE;
        awvalid <= 1'b0;
        wvalid  <= 1'b0;
        wlast   <= 1'b0;
        bready  <= 1'b0;
        
        write_buffer_num   <= 3'b0;
        write_buffer_data  <= 128'b0;
    end
    else case (current_write_state)
        STATE_WRITE_REQUEST_IDLE: begin
            if (data_wr_req) begin
                current_write_state <= STATE_WRITE_DATA_WAIT;
                //end
                awaddr  <= data_wr_addr;
                awsize  <= data_real_wr_size;
                awlen   <= data_real_wr_len;
                awvalid <= 1'b1;
                wdata   <= data_wr_data[31:0];  //from write 128 bit buffer
                wstrb   <= data_wr_wstrb;

                write_buffer_data <= {32'b0, data_wr_data[127:32]};

                if (data_wr_type == 3'b100) begin
                    write_buffer_num <= 3'b011;
                end
                else begin
                    write_buffer_num <= 3'b0;
                    wlast <= 1'b1;
                end
            end
        end
        STATE_WRITE_DATA_WAIT: begin
            if (awready) begin
                current_write_state <= STATE_WRITE_DATA_TRANSFORM;
                awvalid <= 1'b0;
		wvalid  <= 1'b1;
            end
        end 
        STATE_WRITE_DATA_TRANSFORM: begin
            if (wready) begin
                if (wlast) begin
                    current_write_state <= STATE_WRITE_WAIT_RESPONSE;
                    wvalid <= 1'b0;
                    wlast <= 1'b0;
        	    bready <= 1'b1;
                end
                else begin
                    if (write_buffer_last) begin
                        wlast <= 1'b1;
                    end
                
                    current_write_state <= STATE_WRITE_DATA_TRANSFORM;
    
                    wdata   <= write_buffer_data[31:0];
                    wvalid  <= 1'b1;
                    write_buffer_data <= {32'b0, write_buffer_data[127:32]};
                    write_buffer_num  <= write_buffer_num - 3'b1;
                end
            end
        end
	STATE_WRITE_WAIT_RESPONSE: begin
		if (bvalid && bready) begin
                    current_write_state <= STATE_WRITE_REQUEST_IDLE;
		    bready <= 1'b0;
		end
	end
        default: begin
            current_write_state <= STATE_WRITE_REQUEST_IDLE;
        end
    endcase
end

endmodule

