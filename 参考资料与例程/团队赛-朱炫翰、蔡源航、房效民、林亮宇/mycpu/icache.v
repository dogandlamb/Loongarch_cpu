module icache(
    input  wire         clk,
    input  wire         rst,

    // cache - cpu
    input  wire         valid,
    input  wire         op,
    input wire  [1:0]  size,
    input  wire [ 7: 0] index,
    input  wire [19: 0] tag,
    input  wire [ 3: 0] offset,
    input  wire [ 3: 0] wstrb,
    input  wire [31: 0] wdata,

    output wire         addr_ok,
    output wire         data_ok,
    //712
    output wire [127: 0] rdata,

    // cache - axi
    output wire         rd_req,
    output wire [ 2: 0] rd_type,
    output wire [31: 0] rd_addr,
    input  wire         rd_rdy,
    input  wire         ret_valid,
    input  wire         ret_last,
    input  wire [31: 0] ret_data,

    output wire         wr_req,
    output wire [ 2: 0] wr_type,
    output wire [31: 0] wr_addr,
    output wire [ 3: 0] wr_wstrb,
    output wire [127:0] wr_data,
    input  wire         wr_rdy,
    input  wire         uncache,
    //75
    input wire          cacop_en,
    input wire  [1:0]   cacop_op,
    output wire         cacop_ok_o,
    input wire  [31:0]  cacop_pa
);

reg [127:0] reg_rdata;

assign rdata = reg_rdata;




`define CACHE_MAIN_IDLE     5'b00001
`define CACHE_MAIN_LOOKUP   5'b00010
`define CACHE_MAIN_MISS     5'b00100
`define CACHE_MAIN_REPLACE  5'b01000
`define CACHE_MAIN_REFILL   5'b10000



`define CACHE_MAIN_IS_IDLE      0
`define CACHE_MAIN_IS_LOOKUP    1
`define CACHE_MAIN_IS_MISS      2
`define CACHE_MAIN_IS_REPLACE   3
`define CACHE_MAIN_IS_REFILL    4

`define CACHE_WBUF_IDLE     2'b01
`define CACHE_WBUF_WRITE    2'b10

`define CACHE_WBUF_IS_IDLE      0
`define CACHE_WBUF_IS_WRITE     1



//75


`define CACOP_MAIN_IDLE     5'b00001
`define CACOP_MAIN_LOOKUP   5'b00010
`define CACOP_MAIN_MISS     5'b00100
`define CACOP_MAIN_REPLACE  5'b01000
`define CACOP_MAIN_REFILL   5'b10000




reg    [4:0]   cacop_curr_status;
reg    [4:0]   cacop_next_status;
reg    [1:0]   reg_cacop_en;


always @(posedge clk)begin
    if(rst)begin
        reg_cacop_en <=2'b00;
    end else if(cacop_en && cacop_status_enter_flag)begin
        reg_cacop_en <=2'b01;
    end else if(cacop_en && !cacop_status_enter_flag)begin
        reg_cacop_en <=2'b10;
    end else if(cacop_curr_status ==`CACOP_MAIN_REFILL || cacop_curr_status == `CACOP_MAIN_LOOKUP && !cacop_hit)begin
        reg_cacop_en <=2'b00;
    end
end

//wire cacop_en_flag;
//assign cacop_en_flag = reg_cacop_en == 2'b01 || reg_cacop_en == 2'b10;


wire        cacop_status_enter_flag;
reg         [1:0] reg_cacop_hit;
wire       cacop_hit;
wire       cacop_ing;
reg        cacop_ok_r;
assign cacop_hit = (way0_hit || way1_hit || way2_hit || way3_hit) && (cacop_curr_status == `CACOP_MAIN_LOOKUP);
//assign cacop_hit = (way0_hit || way1_hit) && (main_curr_status == `CACOP_MAIN_LOOKUP) && cacop_en_flag;
assign cacop_ok = cacop_curr_status == `CACOP_MAIN_LOOKUP && !cacop_hit
               || cacop_curr_status == `CACOP_MAIN_REFILL;
//assign cacop_ok = (main_curr_status == `CACOP_MAIN_LOOKUP && !cacop_hit && cacop_en_flag 
//               || main_curr_status == `CACOP_MAIN_REFILL)&&cacop_en_flag;

assign cacop_ing=cacop_curr_status==`CACOP_MAIN_LOOKUP || cacop_curr_status==`CACOP_MAIN_MISS || cacop_curr_status==`CACOP_MAIN_REFILL || cacop_curr_status==`CACOP_MAIN_REPLACE;
//assign cacop_ing=(main_curr_status==`CACOP_MAIN_LOOKUP || main_curr_status==`CACOP_MAIN_MISS || main_curr_status==`CACOP_MAIN_REFILL || main_curr_status==`CACOP_MAIN_REPLACE) && cacop_en_flag;
reg [ 1:0] reg_cacop_op;
reg [31:0] reg_cacop_pa;

assign cacop_ok_o = cacop_ok_r;



always @(posedge clk)begin
    if(rst | cacop_ok_r)begin
        cacop_ok_r <=1'b0;
    end else if(cacop_ok)begin
        cacop_ok_r <=1'b1;
    end 
end

always @(posedge clk) begin
    if (rst) begin
        reg_cacop_op  <= 0;
        reg_cacop_pa  <= 0;
    end
    else if (cacop_en) begin
        reg_cacop_op  <= cacop_op;
        reg_cacop_pa  <= cacop_pa;
    end
end




//cacop状态机
assign cacop_status_enter_flag = main_curr_state == `CACOP_MAIN_IDLE && cacop_curr_status == `CACOP_MAIN_IDLE
                    && ((cacop_en && (cacop_op == 2'h0 ||cacop_op == 2'h1 || cacop_op == 2'h2))
                    || (reg_cacop_en ==2'b10 && (reg_cacop_op == 2'h0 || reg_cacop_op ==2'h1 || reg_cacop_op ==2'h2)));


//assign cacop_status_enter_flag = main_curr_state == `CACOP_MAIN_IDLE
//                    && ((cacop_en && (cacop_op == 2'h0 ||cacop_op == 2'h1 || cacop_op == 2'h2))
//                    || (reg_cacop_en ==2'b10 && (reg_cacop_op == 2'h0 || reg_cacop_op ==2'h1 || reg_cacop_op ==2'h2)));


always @(posedge clk)begin
    if(rst)begin
        cacop_curr_status <=5'b0;
    end
    else begin
        cacop_curr_status <=cacop_next_status;
    end
end

//命中的路数
always @(posedge clk)begin
    if(rst)begin
        reg_cacop_hit <=2'b00;
    end else if(cacop_curr_status ==`CACOP_MAIN_LOOKUP && cacop_hit)begin
        reg_cacop_hit<= way0_hit ? 2'b00:way1_hit ? 2'b01 : way2_hit ?2'b10 :2'b11;
    end
end


//cacop状态机
always @ (*) begin
    if (rst) begin
        cacop_next_status <= `CACOP_MAIN_IDLE;
    end else begin
        case (cacop_curr_status)
            `CACOP_MAIN_IDLE: begin
                if (cacop_status_enter_flag) begin
                    case(cacop_en ? cacop_op : reg_cacop_op)
                        2'h0:cacop_next_status <= `CACOP_MAIN_REFILL;
                        2'h1:cacop_next_status <= `CACOP_MAIN_MISS;
                        2'h2:cacop_next_status <= `CACOP_MAIN_LOOKUP;
                    endcase
                end else begin
                    cacop_next_status <= `CACOP_MAIN_IDLE;
                end
            end

            `CACOP_MAIN_LOOKUP: begin
            if (cacop_hit) begin 
                    cacop_next_status <= `CACOP_MAIN_MISS;
                end else begin
                    cacop_next_status<= `CACOP_MAIN_IDLE;
                end
            end

            `CACOP_MAIN_MISS: begin
                if (!wr_rdy) begin
                    cacop_next_status <= `CACOP_MAIN_MISS;
                end else begin
                    cacop_next_status <= `CACOP_MAIN_REPLACE;
                end
            end

            `CACOP_MAIN_REPLACE: begin
                cacop_next_status <= `CACOP_MAIN_REFILL;
            end

            `CACOP_MAIN_REFILL: begin
                cacop_next_status <= `CACOP_MAIN_IDLE;
            end

            default: begin
                cacop_next_status <= `CACOP_MAIN_IDLE;
            end
        endcase
    end
end








//72
wire fang_uncache_read;

assign fang_uncache_read = uncache_r && !op_r;



// tagv ram

wire [ 7:0] way0_tagv_addr;
wire [20:0] way0_tagv_din;
wire [20:0] way0_tagv_dout;
wire        way0_tagv_we;

wire [ 7:0] way1_tagv_addr;
wire [20:0] way1_tagv_din;
wire [20:0] way1_tagv_dout;
wire        way1_tagv_we;

wire [ 7:0] way2_tagv_addr;
wire [20:0] way2_tagv_din;
wire [20:0] way2_tagv_dout;
wire        way2_tagv_we;


wire [ 7:0] way3_tagv_addr;
wire [20:0] way3_tagv_din;
wire [20:0] way3_tagv_dout;
wire        way3_tagv_we;

tagv_ram way0_tagv(
    .addra  (way0_tagv_addr),
    .clka   (clk),
    .dina   (way0_tagv_din),
    .douta  (way0_tagv_dout),
    .ena    (ena),
    .wea    (way0_tagv_we)
);

tagv_ram way1_tagv(
    .addra  (way1_tagv_addr),
    .clka   (clk),
    .dina   (way1_tagv_din),
    .douta  (way1_tagv_dout),
    .ena    (ena),
    .wea    (way1_tagv_we)
);



tagv_ram way2_tagv(
    .addra  (way2_tagv_addr),
    .clka   (clk),
    .dina   (way2_tagv_din),
    .douta  (way2_tagv_dout),
    .ena    (ena),
    .wea    (way2_tagv_we)
);


tagv_ram way3_tagv(
    .addra  (way3_tagv_addr),
    .clka   (clk),
    .dina   (way3_tagv_din),
    .douta  (way3_tagv_dout),
    .ena    (ena),
    .wea    (way3_tagv_we)
);


// data bank ram

wire [ 7:0] way0_bank_addr  [3:0];
wire [31:0] way0_bank_din   [3:0];
wire [31:0] way0_bank_dout  [3:0];
wire [ 3:0] way0_bank_we    [3:0];

wire [ 7:0] way1_bank_addr  [3:0];
wire [31:0] way1_bank_din   [3:0];
wire [31:0] way1_bank_dout  [3:0];
wire [ 3:0] way1_bank_we    [3:0];

wire [ 7:0] way2_bank_addr  [3:0];
wire [31:0] way2_bank_din   [3:0];
wire [31:0] way2_bank_dout  [3:0];
wire [ 3:0] way2_bank_we    [3:0];


wire [ 7:0] way3_bank_addr  [3:0];
wire [31:0] way3_bank_din   [3:0];
wire [31:0] way3_bank_dout  [3:0];
wire [ 3:0] way3_bank_we    [3:0];

assign ena = main_curr_state == `CACHE_MAIN_IDLE || main_curr_state == `CACHE_MAIN_LOOKUP || !fang_uncache_read;

genvar i;
generate
    for (i=0;i<4;i=i+1) begin
        data_bank_ram way0_bank(
            .addra  (way0_bank_addr[i]),
            .clka   (clk),
            .dina   (way0_bank_din[i]),
            .douta  (way0_bank_dout[i]),
            .ena    (ena),
            .wea    (way0_bank_we[i])
        );

        data_bank_ram way1_bank(
            .addra  (way1_bank_addr[i]),
            .clka   (clk),
            .dina   (way1_bank_din[i]),
            .douta  (way1_bank_dout[i]),
            .ena    (ena),
            .wea    (way1_bank_we[i])
        );

        data_bank_ram way2_bank(
            .addra  (way2_bank_addr[i]),
            .clka   (clk),
            .dina   (way2_bank_din[i]),
            .douta  (way2_bank_dout[i]),
            .ena    (ena),
            .wea    (way2_bank_we[i])
        );


        data_bank_ram way3_bank(
            .addra  (way3_bank_addr[i]),
            .clka   (clk),
            .dina   (way3_bank_din[i]),
            .douta  (way3_bank_dout[i]),
            .ena    (ena),
            .wea    (way3_bank_we[i])
        );
    end
endgenerate


// todo

wire way0_hit;
wire way1_hit;


wire way2_hit;
wire way3_hit;


wire cache_hit;

//712

wire check2_cache_hit;


reg  replace_req;
reg  [1:0] replace_way;

reg check2_replace_req;
reg [1:0] check2_replace_way;

reg [2:0] ret_bank_cnt;


// fsm


//暂时不对cacop进行处理
reg  [4:0] main_curr_state;
reg  [4:0] main_next_state;



always @ (posedge clk) begin
    if (rst) begin
        main_curr_state <= `CACHE_MAIN_IDLE;
    end else begin
        main_curr_state <= main_next_state;
    end
end



always @ (*) begin
    if (rst) begin
        main_next_state <= `CACHE_MAIN_IDLE;
    end else begin
        case (main_curr_state)
            `CACHE_MAIN_IDLE: begin         //75
                if (valid &&!cacop_status_enter_flag && !cacop_ing) begin
                    main_next_state <= `CACHE_MAIN_LOOKUP;
                end else begin
                    main_next_state <= `CACHE_MAIN_IDLE;
                end
            end

            `CACHE_MAIN_LOOKUP: begin
            if (cache_hit && !valid) begin 
                    // no new req / new req conflict
                    main_next_state <= `CACHE_MAIN_IDLE;
                 end else if (cache_hit && valid) begin
                     // new req
                     main_next_state <= `CACHE_MAIN_LOOKUP;
                end 
                else begin
                    main_next_state <= `CACHE_MAIN_MISS;
                end
            end

            `CACHE_MAIN_MISS: begin
                if (!wr_rdy) begin
                    main_next_state <= `CACHE_MAIN_MISS;
                end else begin
                    main_next_state <= `CACHE_MAIN_REPLACE;
                end
            end

            `CACHE_MAIN_REPLACE: begin
                if (!rd_rdy) begin
                    main_next_state <= `CACHE_MAIN_REPLACE;
                end else begin
                    main_next_state <= `CACHE_MAIN_REFILL;
                end
            end

            `CACHE_MAIN_REFILL: begin
                if (ret_valid && ret_last) begin
                    main_next_state <= `CACHE_MAIN_IDLE;
                end else begin
                    main_next_state <= `CACHE_MAIN_REFILL;
                end
            end

            default: begin
                main_next_state <= `CACHE_MAIN_IDLE;
            end
        endcase
    end
end



// request buffer

reg         op_r;
reg  [ 7:0] index_r;
reg  [19:0] tag_r;
reg  [ 3:0] offset_r;
reg  [ 3:0] wstrb_r;
reg  [31:0] wdata_r;
//72
reg  [1:0] size_r;



//712
reg  double_check_r;


//71
reg uncache_r;


always @ (posedge clk) begin
    if (rst) begin
        op_r     <= 1'b0;
        index_r  <= 8'b0;
        tag_r    <= 20'b0;
        offset_r <= 4'b0;
        wstrb_r  <= 4'b0;
        wdata_r  <= 32'b0;
        //71
        uncache_r <=1'b0;
        //72
        size_r   <=2'b0;
        //712
        double_check_r <=1'b0;
    end else begin
        if (valid && addr_ok) begin
            op_r     <= op;
            index_r  <= index;
            tag_r    <= tag;
            offset_r <= offset;
            wstrb_r  <= wstrb;
            wdata_r  <= wdata;
            //71
            uncache_r <=uncache;
            //72
            size_r  <=size;
            //712
            double_check_r <=index !=8'hff && !uncache;//这里改动是因为每次都要双取指
        end  else if(main_curr_state == `CACHE_MAIN_REFILL && data_ok)begin
            uncache_r <=1'b0;
        end
    end
end


// LOOKUP

//75
assign addr_ok = main_curr_state == `CACHE_MAIN_IDLE && valid && !cacop_ing && !cacop_status_enter_flag                   // IDLE -> LOOKUP
              || main_curr_state == `CACHE_MAIN_LOOKUP && cache_hit && valid;    // LOOKUP -> LOOKUP

wire reg_select;
assign reg_select = (cacop_status_enter_flag && reg_cacop_en == 2'b10)                  | (cacop_curr_status == `CACOP_MAIN_LOOKUP && reg_cacop_op == 2'h1) |
                    (cacop_curr_status == `CACOP_MAIN_LOOKUP && reg_cacop_op == 2'h2)   | (cacop_curr_status == `CACOP_MAIN_MISS && reg_cacop_op == 2'h1  ) |
                    (cacop_curr_status == `CACOP_MAIN_MISS && reg_cacop_op == 2'h2  )   | (cacop_curr_status == `CACOP_MAIN_REFILL                        ) ;

assign way0_tagv_addr = (cacop_status_enter_flag && cacop_en ) ? cacop_pa[11:4]     :
                        (reg_select                          ) ? reg_cacop_pa[11:4] :
                        (addr_ok                             ) ? index              :
                        (main_curr_state == `CACHE_MAIN_LOOKUP && double_check_r || main_curr_state == `CACHE_MAIN_REFILL && ret_bank_cnt == 3'b111) ? index_r+1'b1 : index_r;  

assign way1_tagv_addr = way0_tagv_addr;
assign way2_tagv_addr = way0_tagv_addr;
assign way3_tagv_addr = way0_tagv_addr;

// assign way0_tagv_addr =  {8{cacop_status_enter_flag && cacop_en}}      ?     cacop_pa[11:4] :
//                          {8{cacop_status_enter_flag && reg_cacop_en == 2'b10}}      ?     reg_cacop_pa[11:4] :
//                          {8{cacop_curr_status == `CACOP_MAIN_LOOKUP && reg_cacop_op == 2'h1}} ?     reg_cacop_pa[11:4]:
//                          {8{cacop_curr_status == `CACOP_MAIN_LOOKUP && reg_cacop_op == 2'h2}} ?     reg_cacop_pa[11:4]:
//                          {8{cacop_curr_status == `CACOP_MAIN_MISS && reg_cacop_op == 2'h1}} ?     reg_cacop_pa[11:4]:
//                          {8{cacop_curr_status == `CACOP_MAIN_MISS && reg_cacop_op == 2'h2}}  ? reg_cacop_pa[11:4]:
//                          {8{cacop_curr_status == `CACOP_MAIN_REFILL}}   ? reg_cacop_pa[11:4]:
//                          addr_ok ? index : (main_curr_state == `CACHE_MAIN_LOOKUP && double_check_r || main_curr_state == `CACHE_MAIN_REFILL && ret_bank_cnt == 3'b111) ? index_r+1'b1 : index_r;  
// assign way1_tagv_addr =  {8{cacop_status_enter_flag && cacop_en}}      ?     cacop_pa[11:4] :
//                          {8{cacop_status_enter_flag && reg_cacop_en == 2'b10}}      ?     reg_cacop_pa[11:4] :
//                          {8{cacop_curr_status == `CACOP_MAIN_LOOKUP && reg_cacop_op == 2'h1}} ?     reg_cacop_pa[11:4]:
//                          {8{cacop_curr_status == `CACOP_MAIN_LOOKUP && reg_cacop_op == 2'h2}} ?     reg_cacop_pa[11:4]:
//                          {8{cacop_curr_status == `CACOP_MAIN_MISS && reg_cacop_op == 2'h1}} ?     reg_cacop_pa[11:4]:
//                          {8{cacop_curr_status == `CACOP_MAIN_MISS && reg_cacop_op == 2'h2}}  ? reg_cacop_pa[11:4]:
//                          {8{cacop_curr_status == `CACOP_MAIN_REFILL}}   ? reg_cacop_pa[11:4]:
//                          addr_ok ? index : (main_curr_state == `CACHE_MAIN_LOOKUP && double_check_r || main_curr_state == `CACHE_MAIN_REFILL && ret_bank_cnt == 3'b111) ? index_r+1'b1 : index_r;

// assign way2_tagv_addr =  {8{cacop_status_enter_flag && cacop_en}}      ?     cacop_pa[11:4] :
//                          {8{cacop_status_enter_flag && reg_cacop_en == 2'b10}}      ?     reg_cacop_pa[11:4] :
//                          {8{cacop_curr_status == `CACOP_MAIN_LOOKUP && reg_cacop_op == 2'h1}} ?     reg_cacop_pa[11:4]:
//                          {8{cacop_curr_status == `CACOP_MAIN_LOOKUP && reg_cacop_op == 2'h2}} ?     reg_cacop_pa[11:4]:
//                          {8{cacop_curr_status == `CACOP_MAIN_MISS && reg_cacop_op == 2'h1}} ?     reg_cacop_pa[11:4]:
//                          {8{cacop_curr_status == `CACOP_MAIN_MISS && reg_cacop_op == 2'h2}}  ? reg_cacop_pa[11:4]:
//                          {8{cacop_curr_status == `CACOP_MAIN_REFILL}}   ? reg_cacop_pa[11:4]:
//                          addr_ok ? index : (main_curr_state == `CACHE_MAIN_LOOKUP && double_check_r || main_curr_state == `CACHE_MAIN_REFILL && ret_bank_cnt == 3'b111) ? index_r+1'b1 : index_r;  
// assign way3_tagv_addr =  {8{cacop_status_enter_flag && cacop_en}}      ?     cacop_pa[11:4] :
//                          {8{cacop_status_enter_flag && reg_cacop_en == 2'b10}}      ?     reg_cacop_pa[11:4] :
//                          {8{cacop_curr_status == `CACOP_MAIN_LOOKUP && reg_cacop_op == 2'h1}} ?     reg_cacop_pa[11:4]:
//                          {8{cacop_curr_status == `CACOP_MAIN_LOOKUP && reg_cacop_op == 2'h2}} ?     reg_cacop_pa[11:4]:
//                          {8{cacop_curr_status == `CACOP_MAIN_MISS && reg_cacop_op == 2'h1}} ?     reg_cacop_pa[11:4]:
//                          {8{cacop_curr_status == `CACOP_MAIN_MISS && reg_cacop_op == 2'h2}}  ? reg_cacop_pa[11:4]:
//                          {8{cacop_curr_status == `CACOP_MAIN_REFILL}}   ? reg_cacop_pa[11:4]:
//                          addr_ok ? index : (main_curr_state == `CACHE_MAIN_LOOKUP && double_check_r || main_curr_state == `CACHE_MAIN_REFILL && ret_bank_cnt == 3'b111) ? index_r+1'b1 : index_r;

generate
    for (i=0;i<4;i=i+1) begin
        assign way0_bank_addr[i] = 
    (cacop_curr_status == `CACOP_MAIN_MISS && reg_cacop_op == 2'h1) ? reg_cacop_pa[11:4] :
    (cacop_curr_status == `CACHE_MAIN_MISS && reg_cacop_op == 2'h2) ? reg_cacop_pa[11:4] :
    (addr_ok) ? index : 
    (main_curr_state == `CACHE_MAIN_LOOKUP && double_check_r || main_curr_state == `CACHE_MAIN_REFILL  && (ret_bank_cnt == 3'b100 || ret_bank_cnt == 3'b101 || ret_bank_cnt == 3'b110 || ret_bank_cnt == 3'b111)) ? index_r+1'b1 : index_r;

        assign way1_bank_addr[i] = 
    (cacop_curr_status == `CACOP_MAIN_MISS && reg_cacop_op == 2'h1) ? reg_cacop_pa[11:4] :
    (cacop_curr_status == `CACHE_MAIN_MISS && reg_cacop_op == 2'h2) ? reg_cacop_pa[11:4] :
    (addr_ok) ? index : 
    (main_curr_state == `CACHE_MAIN_LOOKUP && double_check_r || main_curr_state == `CACHE_MAIN_REFILL  && (ret_bank_cnt == 3'b100 || ret_bank_cnt == 3'b101 || ret_bank_cnt == 3'b110 || ret_bank_cnt == 3'b111)) ? index_r+1'b1 : index_r;

    assign way2_bank_addr[i] = 
    (cacop_curr_status == `CACOP_MAIN_MISS && reg_cacop_op == 2'h1) ? reg_cacop_pa[11:4] :
    (cacop_curr_status == `CACHE_MAIN_MISS && reg_cacop_op == 2'h2) ? reg_cacop_pa[11:4] :
    (addr_ok) ? index : 
    (main_curr_state == `CACHE_MAIN_LOOKUP && double_check_r || main_curr_state == `CACHE_MAIN_REFILL  && (ret_bank_cnt == 3'b100 || ret_bank_cnt == 3'b101 || ret_bank_cnt == 3'b110 || ret_bank_cnt == 3'b111)) ? index_r+1'b1 : index_r;

    assign way3_bank_addr[i] = 
    (cacop_curr_status == `CACOP_MAIN_MISS && reg_cacop_op == 2'h1) ? reg_cacop_pa[11:4] :
    (cacop_curr_status == `CACHE_MAIN_MISS && reg_cacop_op == 2'h2) ? reg_cacop_pa[11:4] :
    (addr_ok) ? index : 
    (main_curr_state == `CACHE_MAIN_LOOKUP && double_check_r || main_curr_state == `CACHE_MAIN_REFILL  && (ret_bank_cnt == 3'b100 || ret_bank_cnt == 3'b101 || ret_bank_cnt == 3'b110 || ret_bank_cnt == 3'b111)) ? index_r+1'b1 : index_r;
    end
endgenerate

wire [19:0] way0_tag;
wire        way0_v;
wire [19:0] way1_tag;
wire        way1_v;
assign {way0_tag, way0_v} = way0_tagv_dout;
assign {way1_tag, way1_v} = way1_tagv_dout;


wire [19:0] way2_tag;
wire        way2_v;
wire [19:0] way3_tag;
wire        way3_v;
assign {way2_tag, way2_v} = way2_tagv_dout;
assign {way3_tag, way3_v} = way3_tagv_dout;





assign way0_hit = way0_v && (
    (cacop_curr_status == `CACOP_MAIN_LOOKUP) ? 
        (way0_tag == reg_cacop_pa[31:12]) :  // CACOP模式下匹配PA[31:12]
        (way0_tag == tag_r)                   // 普通请求模式
);

assign way1_hit = way1_v && (
    (cacop_curr_status == `CACOP_MAIN_LOOKUP) ? 
        (way1_tag == reg_cacop_pa[31:12]) : 
        (way1_tag == tag_r)
);



assign way2_hit = way2_v && (
    (cacop_curr_status == `CACOP_MAIN_LOOKUP) ? 
        (way2_tag == reg_cacop_pa[31:12]) :  // CACOP模式下匹配PA[31:12]
        (way2_tag == tag_r)                   // 普通请求模式
);

assign way3_hit = way3_v && (
    (cacop_curr_status == `CACOP_MAIN_LOOKUP) ? 
        (way3_tag == reg_cacop_pa[31:12]) : 
        (way3_tag == tag_r)
);




//71
assign cache_hit = (way0_hit || way1_hit || way2_hit || way3_hit) && !fang_uncache_read;
assign check2_cache_hit = (way0_hit || way1_hit || way2_hit || way3_hit) && !fang_uncache_read;
//71

assign data_ok = main_curr_state ==`CACHE_MAIN_LOOKUP  && cache_hit   // LOOKUP -> LOOKUP/IDLE   
    //|| main_curr_state ==  `CACHE_MAIN_REFILL && (ret_valid && (ret_bank_cnt == 3'b011) && !double_check_r || ret_valid && (ret_bank_cnt == 3'b111) && double_check_r);
    || main_curr_state ==  `CACHE_MAIN_REFILL && ret_valid && ret_bank_cnt == 3'b011;


//712



//ret_data的生成逻辑
always @(*)begin
    case(main_curr_state)
    `CACHE_MAIN_LOOKUP:begin
        if(cache_hit)begin
            if(way0_hit) reg_rdata = {{way0_bank_dout[3],way0_bank_dout[2],way0_bank_dout[1],way0_bank_dout[0]}};
            else if(way1_hit)reg_rdata = {{way1_bank_dout[3],way1_bank_dout[2],way1_bank_dout[1],way1_bank_dout[0]}};
            else if(way2_hit)reg_rdata = {{way2_bank_dout[3],way2_bank_dout[2],way2_bank_dout[1],way2_bank_dout[0]}};
            else reg_rdata = {{way3_bank_dout[3],way3_bank_dout[2],way3_bank_dout[1],way3_bank_dout[0]}};
        end
    end
    `CACHE_MAIN_REFILL:begin
        //if(!double_check_r)begin
        //    reg_rdata = {ret_data,ret_cacheline_data[95:0]};
        //end else begin
        //    reg_rdata = {ret_cacheline_data[127:0]};
        //end
        reg_rdata = {ret_data,ret_cacheline_data[95:0]};
    end
    default:reg_rdata = 128'b0;
    endcase
end


// WRITE

generate
    for (i=0;i<4;i=i+1) begin
        assign way0_bank_we[i] =  {4{(main_curr_state == `CACHE_MAIN_REFILL)&& ret_valid && (i == ret_bank_cnt % 4) &&(replace_way == 0 && (ret_bank_cnt == 3'b000 || ret_bank_cnt == 3'b001 || ret_bank_cnt == 3'b010 || ret_bank_cnt == 3'b011) || check2_replace_way ==0 && (ret_bank_cnt == 3'b100 || ret_bank_cnt == 3'b101 || ret_bank_cnt == 3'b110 || ret_bank_cnt == 3'b111))}};
        assign way1_bank_we[i] =  {4{(main_curr_state == `CACHE_MAIN_REFILL)&& ret_valid && (i == ret_bank_cnt % 4) &&(replace_way == 1 && (ret_bank_cnt == 3'b000 || ret_bank_cnt == 3'b001 || ret_bank_cnt == 3'b010 || ret_bank_cnt == 3'b011) || check2_replace_way ==1 && (ret_bank_cnt == 3'b100 || ret_bank_cnt == 3'b101 || ret_bank_cnt == 3'b110 || ret_bank_cnt == 3'b111))}};

        assign way0_bank_din[i] = ret_data;
        assign way1_bank_din[i] = ret_data;



        assign way2_bank_we[i] =  {4{(main_curr_state == `CACHE_MAIN_REFILL)&& ret_valid && (i == ret_bank_cnt % 4) &&(replace_way == 2 && (ret_bank_cnt == 3'b000 || ret_bank_cnt == 3'b001 || ret_bank_cnt == 3'b010 || ret_bank_cnt == 3'b011) || check2_replace_way ==2 && (ret_bank_cnt == 3'b100 || ret_bank_cnt == 3'b101 || ret_bank_cnt == 3'b110 || ret_bank_cnt == 3'b111))}};
        assign way3_bank_we[i] =  {4{(main_curr_state == `CACHE_MAIN_REFILL)&& ret_valid && (i == ret_bank_cnt % 4) &&(replace_way == 3 && (ret_bank_cnt == 3'b000 || ret_bank_cnt == 3'b001 || ret_bank_cnt == 3'b010 || ret_bank_cnt == 3'b011) || check2_replace_way ==3 && (ret_bank_cnt == 3'b100 || ret_bank_cnt == 3'b101 || ret_bank_cnt == 3'b110 || ret_bank_cnt == 3'b111))}}; 

        assign way2_bank_din[i] = ret_data;
        assign way3_bank_din[i] = ret_data;
    end
endgenerate



wire [1:0] random_val;
reg [7:0] r_lfsr;

always @(posedge clk) begin
    if (rst) begin
        r_lfsr <= 8'b1;
    end
    else begin
        r_lfsr[0] <= r_lfsr[7];
        r_lfsr[1] <= r_lfsr[0];
        r_lfsr[2] <= r_lfsr[1];
        r_lfsr[3] <= r_lfsr[2];
        r_lfsr[4] <= r_lfsr[3] ^ r_lfsr[7];
        r_lfsr[5] <= r_lfsr[4] ^ r_lfsr[7];
        r_lfsr[6] <= r_lfsr[5] ^ r_lfsr[7];
        r_lfsr[7] <= r_lfsr[6];
    end
end

assign random_val = r_lfsr[7:6];



wire [1:0] unvalid_replaceway;
assign unvalid_replaceway = !way0_v ? 2'b00 : !way1_v ? 2'b01 : !way2_v ? 2'b10 : !way3_v ? 2'b11 :random_val;


reg [1:0] to_reg_replace_way;
always @(posedge clk)begin
    if(rst)begin
        to_reg_replace_way <=2'b00;
    end else begin
        to_reg_replace_way <=unvalid_replaceway;
    end
end

reg to_reg_cache_hit;

always @(posedge clk)begin
    if(rst)begin
        to_reg_cache_hit <=1'b0;
    end else begin
        to_reg_cache_hit <=cache_hit;
    end
end

//75
always @ (posedge clk) begin
    if (rst) begin
        replace_req <= 1'b0;
        replace_way <=2'b00;
        check2_replace_req <=1'b0;
        check2_replace_way <=2'b00;
    end else if (main_curr_state == `CACHE_MAIN_MISS && wr_rdy && fang_uncache_read) begin
        replace_way <= to_reg_replace_way;
        check2_replace_way <=check2_replace_way;
    end else if (main_curr_state == `CACHE_MAIN_MISS && wr_rdy) begin  // MISS -> REPLACE
        replace_way <= to_reg_replace_way;
        check2_replace_way <=unvalid_replaceway;
    end else if(cacop_curr_status == `CACOP_MAIN_MISS && wr_rdy && reg_cacop_op == 2'h1)begin
        replace_way <= reg_cacop_pa[1:0];
        check2_replace_way <=check2_replace_way;
    end else if(cacop_curr_status == `CACOP_MAIN_MISS && wr_rdy && reg_cacop_op == 2'h2)begin
        replace_way <= reg_cacop_hit;
        check2_replace_way <=check2_replace_way;
    end else begin
        replace_way <= replace_way;
        check2_replace_way <=check2_replace_way;
    end
end







// REPLACE
//72
assign rd_req = main_curr_state == `CACHE_MAIN_REPLACE;






//71
assign rd_type = /*fang_uncache_read? {1'b0,size_r} :*/ (!to_reg_cache_hit && double_check_r && main_curr_state == `CACHE_MAIN_REPLACE)? 3'b101 : 3'b100;
//71
assign rd_addr = /*fang_uncache_read? {tag_r, index_r, offset_r} : */{tag_r, index_r, 4'b0};


//712
reg [255:0] ret_cacheline_data;


always @(posedge clk)begin
    if(rst)begin
        ret_cacheline_data <=256'b0;
    end else if(main_curr_state == `CACHE_MAIN_REFILL && ret_valid)begin
        case(ret_bank_cnt)
        3'b000:ret_cacheline_data[31:0] <=ret_data;
        3'b001:ret_cacheline_data[63:32] <=ret_data;
        3'b010:ret_cacheline_data[95:64] <=ret_data;
        3'b011:ret_cacheline_data[127:96] <=ret_data;
        3'b100:ret_cacheline_data[159:128] <=ret_data;
        3'b101:ret_cacheline_data[191:160] <=ret_data;
        3'b110:ret_cacheline_data[223:192] <=ret_data;
        3'b111:ret_cacheline_data[255:224] <=ret_data;
        endcase
    end else if(main_curr_state == `CACHE_MAIN_IDLE)begin
        ret_cacheline_data <=256'b0;
    end
end



// REFILL

always @ (posedge clk) begin
    if (rst) begin
        ret_bank_cnt <= 3'b0;
    end else if (main_curr_state[`CACHE_MAIN_IS_REFILL] && ret_valid && ret_last) begin
        ret_bank_cnt <= 3'b0;
    end else if (main_curr_state[`CACHE_MAIN_IS_REFILL] && ret_valid && !ret_last) begin
        ret_bank_cnt <= ret_bank_cnt + 3'b1;
    end else begin
        ret_bank_cnt <= ret_bank_cnt;
    end
end

generate
    for (i=0;i<4;i=i+1) begin
        assign way0_tagv_we = main_curr_state == `CACHE_MAIN_REFILL && (replace_way == 0) && ret_valid && ret_bank_cnt == 3'b011
        || cacop_curr_status == `CACOP_MAIN_REFILL && (reg_cacop_op == 2'h0 || reg_cacop_op == 2'h1) && 0 == reg_cacop_pa[1:0]
        || cacop_curr_status == `CACOP_MAIN_REFILL &&  reg_cacop_op == 2'h2 && 0 == reg_cacop_hit
        || main_curr_state == `CACHE_MAIN_REFILL && (check2_replace_way == 0) && ret_valid && (ret_bank_cnt == 3'b111);

        assign way1_tagv_we = main_curr_state == `CACHE_MAIN_REFILL && (replace_way == 1) && ret_valid && ret_bank_cnt == 3'b011
        || cacop_curr_status == `CACOP_MAIN_REFILL && (reg_cacop_op == 2'h0 || reg_cacop_op == 2'h1) && 1 == reg_cacop_pa[1:0]
        || cacop_curr_status == `CACOP_MAIN_REFILL &&  reg_cacop_op == 2'h2 && 1 == reg_cacop_hit
        || main_curr_state == `CACHE_MAIN_REFILL && (check2_replace_way == 1) && ret_valid && (ret_bank_cnt == 3'b111);
        assign way0_tagv_din ={21{cacop_curr_status == `CACOP_MAIN_REFILL}}  ? 21'b0 :  {tag_r, 1'b1};
        assign way1_tagv_din ={21{cacop_curr_status == `CACOP_MAIN_REFILL}}  ? 21'b0 :  {tag_r, 1'b1};

        assign way2_tagv_we = main_curr_state == `CACHE_MAIN_REFILL && (replace_way == 2) && ret_valid && ret_bank_cnt == 3'b011
        || cacop_curr_status == `CACOP_MAIN_REFILL && (reg_cacop_op == 2'h0 || reg_cacop_op == 2'h1) && 2 == reg_cacop_pa[1:0]
        || cacop_curr_status == `CACOP_MAIN_REFILL &&  reg_cacop_op == 2'h2 && 2 == reg_cacop_hit
        || main_curr_state == `CACHE_MAIN_REFILL && (check2_replace_way == 2) && ret_valid && (ret_bank_cnt == 3'b111);

        assign way3_tagv_we = main_curr_state == `CACHE_MAIN_REFILL && (replace_way == 3) && ret_valid && ret_bank_cnt == 3'b011
        || cacop_curr_status == `CACOP_MAIN_REFILL && (reg_cacop_op == 2'h0 || reg_cacop_op == 2'h1) && 3 == reg_cacop_pa[1:0]
        || cacop_curr_status == `CACOP_MAIN_REFILL &&  reg_cacop_op == 2'h2 && 3 == reg_cacop_hit
        || main_curr_state == `CACHE_MAIN_REFILL && (check2_replace_way == 3) && ret_valid && (ret_bank_cnt == 3'b111);
        assign way2_tagv_din ={21{cacop_curr_status == `CACOP_MAIN_REFILL}}  ? 21'b0 :  {tag_r, 1'b1};
        assign way3_tagv_din ={21{cacop_curr_status == `CACOP_MAIN_REFILL}}  ? 21'b0 :  {tag_r, 1'b1};
    end
endgenerate

// debug for sim
reg [31:0] icache_replace_count;
always@(posedge clk) begin
    if(rst) icache_replace_count <= 32'b0;
    else if(main_curr_state == `CACHE_MAIN_LOOKUP && !cache_hit && !fang_uncache_read ) begin
        icache_replace_count <= icache_replace_count + 1;
    end
end


endmodule