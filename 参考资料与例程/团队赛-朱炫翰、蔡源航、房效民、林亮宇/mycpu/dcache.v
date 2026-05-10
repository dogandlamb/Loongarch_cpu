module dcache(
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
    output wire [31: 0] rdata,

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
reg   [4:0]   cacop_next_status;
reg     [1:0]      reg_cacop_en;


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




//wire        cacop1_hit_write_conflict_block;
wire        cacop_status_enter_flag;
reg         [1:0] reg_cacop_hit;
wire       cacop_hit;
wire       cacop_ing;
reg         cacop_ok_r;
assign cacop_hit = (way0_hit || way1_hit || way2_hit || way3_hit) && (cacop_curr_status == `CACOP_MAIN_LOOKUP);
assign cacop_ok = cacop_curr_status == `CACOP_MAIN_LOOKUP && !cacop_hit
               || cacop_curr_status == `CACOP_MAIN_REFILL;
assign cacop_ing=cacop_curr_status==`CACOP_MAIN_LOOKUP || cacop_curr_status==`CACOP_MAIN_MISS || cacop_curr_status==`CACOP_MAIN_REFILL || cacop_curr_status==`CACOP_MAIN_REPLACE;

reg [ 1:0] reg_cacop_op;
reg [31:0] reg_cacop_pa;

always @(posedge clk) begin
    if(rst | cacop_ok_r) begin
        cacop_ok_r <= 1'b0;
    end else if(cacop_ok) begin
        cacop_ok_r <= 1'b1;
    end
end

assign cacop_ok_o = cacop_ok_r;

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
//assign cacop1_hit_write_conflict_block = hit_write && cacop_op == 2'h1 && cacop_pa[11:4] == reg_index;  // replace写ram的缓存行和未完成的cache写之间的冲突（因为没有lookup阶段，恰好差一周期没有冲突）
assign cacop_status_enter_flag = main_curr_state == `CACOP_MAIN_IDLE && cacop_curr_status == `CACOP_MAIN_IDLE
                    && ((cacop_en && (cacop_op == 2'h0 ||cacop_op == 2'h1 || cacop_op == 2'h2))
                    || (reg_cacop_en ==2'b10 && (reg_cacop_op == 2'h0 || reg_cacop_op ==2'h1 || reg_cacop_op ==2'h2)));






always @(posedge clk)begin
    if(rst)begin
        cacop_curr_status <=5'b0;
        //reg_cacop_hit <=1'b0;
    end
    else begin
        cacop_curr_status <=cacop_next_status;
    end
end


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
                    // no new req / new req conflict
                    cacop_next_status <= `CACOP_MAIN_MISS;
                    //reg_cacop_hit<= way1_hit;
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
wire fang_uncache_write;

assign fang_uncache_read =uncache_r && !op_r;//(tag_r[19:4] == 16'hbfaf) && !op_r;
assign fang_uncache_write =uncache_r && op_r;//(tag_r[19:4] == 16'hbfaf) && op_r;






//75




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
    .ena    (main_curr_state[`CACHE_MAIN_IS_IDLE] || main_curr_state[`CACHE_MAIN_IS_LOOKUP] || !(fang_uncache_read || fang_uncache_write)),
    .wea    (way0_tagv_we)
);

tagv_ram way1_tagv(
    .addra  (way1_tagv_addr),
    .clka   (clk),
    .dina   (way1_tagv_din),
    .douta  (way1_tagv_dout),
    .ena    (main_curr_state[`CACHE_MAIN_IS_IDLE] || main_curr_state[`CACHE_MAIN_IS_LOOKUP] || !(fang_uncache_read || fang_uncache_write)),
    .wea    (way1_tagv_we)
);


tagv_ram way2_tagv(
    .addra  (way2_tagv_addr),
    .clka   (clk),
    .dina   (way2_tagv_din),
    .douta  (way2_tagv_dout),
    .ena    (main_curr_state[`CACHE_MAIN_IS_IDLE] || main_curr_state[`CACHE_MAIN_IS_LOOKUP] || !(fang_uncache_read || fang_uncache_write)),
    .wea    (way2_tagv_we)
);

tagv_ram way3_tagv(
    .addra  (way3_tagv_addr),
    .clka   (clk),
    .dina   (way3_tagv_din),
    .douta  (way3_tagv_dout),
    .ena    (main_curr_state[`CACHE_MAIN_IS_IDLE] || main_curr_state[`CACHE_MAIN_IS_LOOKUP] || !(fang_uncache_read || fang_uncache_write)),
    .wea    (way3_tagv_we)
);


// dirty array

reg  [255:0] way0_d;
reg  [255:0] way1_d;
reg  [255:0] way2_d;
reg  [255:0] way3_d;


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


genvar i;
generate
    for (i=0;i<4;i=i+1) begin
        data_bank_ram way0_bank(
            .addra  (way0_bank_addr[i]),
            .clka   (clk),
            .dina   (way0_bank_din[i]),
            .douta  (way0_bank_dout[i]),
            .ena    (main_curr_state[`CACHE_MAIN_IS_IDLE] || main_curr_state[`CACHE_MAIN_IS_LOOKUP] || !(fang_uncache_read || fang_uncache_write)),
            .wea    (way0_bank_we[i])
        );

        data_bank_ram way1_bank(
            .addra  (way1_bank_addr[i]),
            .clka   (clk),
            .dina   (way1_bank_din[i]),
            .douta  (way1_bank_dout[i]),
            .ena    (main_curr_state[`CACHE_MAIN_IS_IDLE] || main_curr_state[`CACHE_MAIN_IS_LOOKUP] || !(fang_uncache_read || fang_uncache_write)),
            .wea    (way1_bank_we[i])
        );


        data_bank_ram way2_bank(
            .addra  (way2_bank_addr[i]),
            .clka   (clk),
            .dina   (way2_bank_din[i]),
            .douta  (way2_bank_dout[i]),
            .ena    (main_curr_state[`CACHE_MAIN_IS_IDLE] || main_curr_state[`CACHE_MAIN_IS_LOOKUP] || !(fang_uncache_read || fang_uncache_write)),
            .wea    (way2_bank_we[i])
        );

        data_bank_ram way3_bank(
            .addra  (way3_bank_addr[i]),
            .clka   (clk),
            .dina   (way3_bank_din[i]),
            .douta  (way3_bank_dout[i]),
            .ena    (main_curr_state[`CACHE_MAIN_IS_IDLE] || main_curr_state[`CACHE_MAIN_IS_LOOKUP] || !(fang_uncache_read || fang_uncache_write)),
            .wea    (way3_bank_we[i])
        );
    end
endgenerate


// todo

wire hit_write_conflict;
wire way0_hit;
wire way1_hit;
wire way2_hit;
wire way3_hit;
wire cache_hit;
wire hit_write;

reg  replace_req;
reg  [1:0] replace_way;

reg [1:0] ret_bank_cnt;


// fsm


//暂时不对cacop进行处理
reg  [4:0] main_curr_state;
reg  [4:0] main_next_state;
reg  [1:0] wbuf_curr_state;
reg  [1:0] wbuf_next_state;

always @ (posedge clk) begin
    if (rst) begin
        main_curr_state <= `CACHE_MAIN_IDLE;
        wbuf_curr_state <= `CACHE_WBUF_IDLE;
    end else begin
        main_curr_state <= main_next_state;
        wbuf_curr_state <= wbuf_next_state;
    end
end

always @ (*) begin
    if (rst) begin
        main_next_state <= `CACHE_MAIN_IDLE;
    end else begin
        case (main_curr_state)
            `CACHE_MAIN_IDLE: begin         //75
                if (valid && !hit_write_conflict &&!cacop_status_enter_flag && !cacop_ing) begin
                    main_next_state <= `CACHE_MAIN_LOOKUP;
                end else begin
                    main_next_state <= `CACHE_MAIN_IDLE;
                end
            end

            `CACHE_MAIN_LOOKUP: begin
            if (cache_hit && (!valid || hit_write_conflict)) begin 
                    // no new req / new req conflict
                    main_next_state <= `CACHE_MAIN_IDLE;
                 end else if (cache_hit && valid && !hit_write_conflict) begin
                //     // new req
                     main_next_state <= `CACHE_MAIN_LOOKUP;
                     //unable lookup to lookup 7/30
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

always @ (*) begin
    if (rst) begin
        wbuf_next_state <= `CACHE_WBUF_IDLE;
    end else begin
        case (wbuf_curr_state)
            `CACHE_WBUF_IDLE: begin
                if (hit_write) begin
                    wbuf_next_state <= `CACHE_WBUF_WRITE;
                end else begin
                    wbuf_next_state <= `CACHE_WBUF_IDLE;
                end
            end

            `CACHE_WBUF_WRITE: begin
                if (hit_write) begin
                    wbuf_next_state <= `CACHE_WBUF_WRITE;
                end else begin
                    wbuf_next_state <= `CACHE_WBUF_IDLE;
                end
            end

            default: begin
                wbuf_next_state <= `CACHE_WBUF_IDLE;
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
        end else if(main_curr_state == `CACHE_MAIN_REFILL && data_ok)begin
            uncache_r <=1'b0;
        end
    end
end


// write buffer

reg         wbuf_way0_hit;
reg         wbuf_way1_hit;
reg         wbuf_way2_hit;
reg         wbuf_way3_hit;
reg  [ 7:0] wbuf_index;
reg  [ 3:0] wbuf_offset;
reg  [ 3:0] wbuf_wstrb;
reg  [31:0] wbuf_wdata;
//72
reg [1:0]    wbuf_size;
//72
reg [19:0]  wbuf_tag;//uncache用

always @ (posedge clk) begin
    if (rst) begin
        wbuf_way0_hit <= 1'b0;
        wbuf_way1_hit <= 1'b0;
        wbuf_way2_hit <= 1'b0;
        wbuf_way3_hit <= 1'b0;
        wbuf_index  <= 8'b0;
        wbuf_offset <= 4'b0;
        wbuf_wstrb  <= 4'b0;
        wbuf_wdata  <= 32'b0;
        wbuf_size   <= 2'b0;
        wbuf_tag    <=20'b0;
    end else begin
        if (hit_write) begin
            wbuf_way0_hit <= way0_hit;
            wbuf_way1_hit <= way1_hit;
            wbuf_way2_hit <= way2_hit;
            wbuf_way3_hit <= way3_hit;
            wbuf_index  <= index_r;
            wbuf_offset <= offset_r;
            wbuf_wstrb  <= wstrb_r;
            wbuf_wdata  <= wdata_r;
            //72
            wbuf_size   <=size_r;
            //72
            wbuf_tag    <=tag_r;
        end
        else begin
            wbuf_way0_hit <= 1'b0;
            wbuf_way1_hit <= 1'b0;
            wbuf_way2_hit <= 1'b0;
            wbuf_way3_hit <= 1'b0;
            wbuf_index  <= 8'b0;
            wbuf_offset <= 4'b0;
            wbuf_wstrb  <= 4'b0;
            wbuf_wdata  <= 32'b0;
            wbuf_size   <=2'b0;
            wbuf_tag   <=20'b0;
        end
    end
end

// LOOKUP


//75
assign addr_ok = main_curr_state[`CACHE_MAIN_IS_IDLE] && valid && !hit_write_conflict && !cacop_ing && !cacop_status_enter_flag               // IDLE -> LOOKUP
               || main_curr_state[`CACHE_MAIN_IS_LOOKUP] && cache_hit && valid && !hit_write_conflict && !op    // LOOKUP -> LOOKUP unable 7/30
               || main_curr_state[`CACHE_MAIN_IS_LOOKUP] && cache_hit && valid && op;

wire reg_select;
assign reg_select = (cacop_status_enter_flag && reg_cacop_en == 2'b10)                  | (cacop_curr_status == `CACOP_MAIN_LOOKUP && reg_cacop_op == 2'h1) |
                    (cacop_curr_status == `CACOP_MAIN_LOOKUP && reg_cacop_op == 2'h2)   | (cacop_curr_status == `CACOP_MAIN_MISS && reg_cacop_op == 2'h1  ) |
                    (cacop_curr_status == `CACOP_MAIN_MISS && reg_cacop_op == 2'h2  )   | (cacop_curr_status == `CACOP_MAIN_REFILL                        ) ;

assign way0_tagv_addr =  (cacop_status_enter_flag && cacop_en)  ? cacop_pa[11:4]    :
                         reg_select                             ? reg_cacop_pa[11:4]:
                         addr_ok                                ? index :index_r    ;  
assign way1_tagv_addr = way0_tagv_addr;
assign way2_tagv_addr = way0_tagv_addr;
assign way3_tagv_addr = way0_tagv_addr;

// assign way0_tagv_addr =  
//                         {8{cacop_status_enter_flag && cacop_en}}      ?     cacop_pa[11:4] :
//                          {8{cacop_status_enter_flag && reg_cacop_en == 2'b10}}      ?     reg_cacop_pa[11:4] :
//                          {8{cacop_curr_status == `CACOP_MAIN_LOOKUP && reg_cacop_op == 2'h1}} ?     reg_cacop_pa[11:4]:
//                          {8{cacop_curr_status == `CACOP_MAIN_LOOKUP && reg_cacop_op == 2'h2}}  ? reg_cacop_pa[11:4]:
//                          {8{cacop_curr_status == `CACOP_MAIN_MISS && reg_cacop_op == 2'h1}} ?     reg_cacop_pa[11:4]:
//                          {8{cacop_curr_status == `CACOP_MAIN_MISS && reg_cacop_op == 2'h2}}  ? reg_cacop_pa[11:4]:
//                          {8{cacop_curr_status == `CACOP_MAIN_REFILL}}   ? reg_cacop_pa[11:4]:
//                          addr_ok ? index :index_r;  
// assign way1_tagv_addr = 
//                           {8{cacop_status_enter_flag && cacop_en}}      ?     cacop_pa[11:4] :
//                          {8{cacop_status_enter_flag && reg_cacop_en == 2'b10}}      ?     reg_cacop_pa[11:4] :
//                          {8{cacop_curr_status == `CACOP_MAIN_LOOKUP && reg_cacop_op == 2'h1}} ?     reg_cacop_pa[11:4]:
//                          {8{cacop_curr_status == `CACOP_MAIN_LOOKUP && reg_cacop_op == 2'h2}}  ? reg_cacop_pa[11:4]:
//                          {8{cacop_curr_status == `CACOP_MAIN_MISS && reg_cacop_op == 2'h1}} ?     reg_cacop_pa[11:4]:
//                          {8{cacop_curr_status == `CACOP_MAIN_MISS && reg_cacop_op == 2'h2}}  ? reg_cacop_pa[11:4]:
//                          {8{cacop_curr_status == `CACOP_MAIN_REFILL}}   ? reg_cacop_pa[11:4]:
//                          addr_ok ? index :index_r;


// assign way2_tagv_addr =  
//                         {8{cacop_status_enter_flag && cacop_en}}      ?     cacop_pa[11:4] :
//                          {8{cacop_status_enter_flag && reg_cacop_en == 2'b10}}      ?     reg_cacop_pa[11:4] :
//                          {8{cacop_curr_status == `CACOP_MAIN_LOOKUP && reg_cacop_op == 2'h1}} ?     reg_cacop_pa[11:4]:
//                          {8{cacop_curr_status == `CACOP_MAIN_LOOKUP && reg_cacop_op == 2'h2}}  ? reg_cacop_pa[11:4]:
//                          {8{cacop_curr_status == `CACOP_MAIN_MISS && reg_cacop_op == 2'h1}} ?     reg_cacop_pa[11:4]:
//                          {8{cacop_curr_status == `CACOP_MAIN_MISS && reg_cacop_op == 2'h2}}  ? reg_cacop_pa[11:4]:
//                          {8{cacop_curr_status == `CACOP_MAIN_REFILL}}   ? reg_cacop_pa[11:4]:
//                          addr_ok ? index :index_r;  
// assign way3_tagv_addr = 
//                           {8{cacop_status_enter_flag && cacop_en}}      ?     cacop_pa[11:4] :
//                          {8{cacop_status_enter_flag && reg_cacop_en == 2'b10}}      ?     reg_cacop_pa[11:4] :
//                          {8{cacop_curr_status == `CACOP_MAIN_LOOKUP && reg_cacop_op == 2'h1}} ?     reg_cacop_pa[11:4]:
//                          {8{cacop_curr_status == `CACOP_MAIN_LOOKUP && reg_cacop_op == 2'h2}}  ? reg_cacop_pa[11:4]:
//                          {8{cacop_curr_status == `CACOP_MAIN_MISS && reg_cacop_op == 2'h1}} ?     reg_cacop_pa[11:4]:
//                          {8{cacop_curr_status == `CACOP_MAIN_MISS && reg_cacop_op == 2'h2}}  ? reg_cacop_pa[11:4]:
//                          {8{cacop_curr_status == `CACOP_MAIN_REFILL}}   ? reg_cacop_pa[11:4]:
//                          addr_ok ? index :index_r;
generate
    for (i=0;i<4;i=i+1) begin
        assign way0_bank_addr[i] = 
    (cacop_curr_status == `CACOP_MAIN_MISS && reg_cacop_op == 2'h1) ? reg_cacop_pa[11:4] :
    (cacop_curr_status == `CACHE_MAIN_MISS && reg_cacop_op == 2'h2) ? reg_cacop_pa[11:4] :
    (wbuf_way0_hit && (wbuf_offset[3:2] == i)) ? wbuf_index : 
    (addr_ok) ? index : 
    index_r;

        assign way1_bank_addr[i] = 
    (cacop_curr_status == `CACOP_MAIN_MISS && reg_cacop_op == 2'h1) ? reg_cacop_pa[11:4] :
    (cacop_curr_status == `CACHE_MAIN_MISS && reg_cacop_op == 2'h2) ? reg_cacop_pa[11:4] :
    (wbuf_way1_hit && (wbuf_offset[3:2] == i)) ? wbuf_index : 
    (addr_ok) ? index : 
    index_r;


    assign way2_bank_addr[i] = 
    (cacop_curr_status == `CACOP_MAIN_MISS && reg_cacop_op == 2'h1) ? reg_cacop_pa[11:4] :
    (cacop_curr_status == `CACHE_MAIN_MISS && reg_cacop_op == 2'h2) ? reg_cacop_pa[11:4] :
    (wbuf_way2_hit && (wbuf_offset[3:2] == i)) ? wbuf_index : 
    (addr_ok) ? index : 
    index_r;

        assign way3_bank_addr[i] = 
    (cacop_curr_status == `CACOP_MAIN_MISS && reg_cacop_op == 2'h1) ? reg_cacop_pa[11:4] :
    (cacop_curr_status == `CACHE_MAIN_MISS && reg_cacop_op == 2'h2) ? reg_cacop_pa[11:4] :
    (wbuf_way3_hit && (wbuf_offset[3:2] == i)) ? wbuf_index : 
    (addr_ok) ? index : 
    index_r;


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



//75

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




assign cache_hit = (way0_hit || way1_hit || way2_hit || way3_hit) && !(fang_uncache_read || fang_uncache_write);

assign data_ok = main_curr_state[`CACHE_MAIN_IS_LOOKUP] && cache_hit    
    || main_curr_state[`CACHE_MAIN_IS_REFILL] && (ret_valid && ((ret_bank_cnt == offset_r[3:2])  || (fang_uncache_read || fang_uncache_write)));






assign rdata = {32{main_curr_state[`CACHE_MAIN_IS_LOOKUP] && way0_hit}} & way0_bank_dout[offset_r[3:2]]
             | {32{main_curr_state[`CACHE_MAIN_IS_LOOKUP] && way1_hit}} & way1_bank_dout[offset_r[3:2]]
             | {32{main_curr_state[`CACHE_MAIN_IS_LOOKUP] && way2_hit}} & way2_bank_dout[offset_r[3:2]]
             | {32{main_curr_state[`CACHE_MAIN_IS_LOOKUP] && way3_hit}} & way3_bank_dout[offset_r[3:2]]
             | {32{main_curr_state[`CACHE_MAIN_IS_REFILL]}} & ret_data;

assign hit_write = main_curr_state[`CACHE_MAIN_IS_LOOKUP] && cache_hit && op_r;    // LOOKUP -> LOOKUP/IDLE

assign hit_write_conflict = hit_write && valid && !op && (offset[3:2] == offset_r[3:2]) && (index == index_r)               // ??????????????д???
                         || wbuf_curr_state[`CACHE_WBUF_IS_WRITE] && valid && !op && (offset[3:2] == wbuf_offset[3:2]);     // ??д?????????bank

// WRITE

generate
    for (i=0;i<4;i=i+1) begin
        assign way0_bank_we[i] = {4{wbuf_curr_state[`CACHE_WBUF_IS_WRITE] && wbuf_way0_hit && wbuf_offset[3:2] == i}} & wbuf_wstrb
                               | {4{main_curr_state[`CACHE_MAIN_IS_REFILL] && (replace_way == 0) && ret_valid && (ret_bank_cnt == i)}};
        assign way1_bank_we[i] = {4{wbuf_curr_state[`CACHE_WBUF_IS_WRITE] && wbuf_way1_hit && wbuf_offset[3:2] == i}} & wbuf_wstrb
                               | {4{main_curr_state[`CACHE_MAIN_IS_REFILL] && (replace_way == 1) && ret_valid && (ret_bank_cnt == i)}}; 

        assign way2_bank_we[i] = {4{wbuf_curr_state[`CACHE_WBUF_IS_WRITE] && wbuf_way2_hit && wbuf_offset[3:2] == i}} & wbuf_wstrb
                               | {4{main_curr_state[`CACHE_MAIN_IS_REFILL] && (replace_way == 2) && ret_valid && (ret_bank_cnt == i)}};
        assign way3_bank_we[i] = {4{wbuf_curr_state[`CACHE_WBUF_IS_WRITE] && wbuf_way3_hit && wbuf_offset[3:2] == i}} & wbuf_wstrb
                               | {4{main_curr_state[`CACHE_MAIN_IS_REFILL] && (replace_way == 3) && ret_valid && (ret_bank_cnt == i)}}; 




        assign way0_bank_din[i] = {32{wbuf_curr_state[`CACHE_WBUF_IS_WRITE]}} & wbuf_wdata
                                | {32{main_curr_state[`CACHE_MAIN_IS_REFILL]}} & (
                                    offset_r[3:2] == i && op_r ? {
                                        wstrb_r[3] ? wdata_r[31:24] : ret_data[31:24],
                                        wstrb_r[2] ? wdata_r[23:16] : ret_data[23:16],
                                        wstrb_r[1] ? wdata_r[15: 8] : ret_data[15: 8],
                                        wstrb_r[0] ? wdata_r[ 7: 0] : ret_data[ 7: 0]
                                    } : ret_data
                                );
        assign way1_bank_din[i] = {32{wbuf_curr_state[`CACHE_WBUF_IS_WRITE]}} & wbuf_wdata
                                | {32{main_curr_state[`CACHE_MAIN_IS_REFILL]}} & (
                                    offset_r[3:2] == i && op_r ? {
                                        wstrb_r[3] ? wdata_r[31:24] : ret_data[31:24],
                                        wstrb_r[2] ? wdata_r[23:16] : ret_data[23:16],
                                        wstrb_r[1] ? wdata_r[15: 8] : ret_data[15: 8],
                                        wstrb_r[0] ? wdata_r[ 7: 0] : ret_data[ 7: 0]
                                    } : ret_data
                                );




        assign way2_bank_din[i] = {32{wbuf_curr_state[`CACHE_WBUF_IS_WRITE]}} & wbuf_wdata
                                | {32{main_curr_state[`CACHE_MAIN_IS_REFILL]}} & (
                                    offset_r[3:2] == i && op_r ? {
                                        wstrb_r[3] ? wdata_r[31:24] : ret_data[31:24],
                                        wstrb_r[2] ? wdata_r[23:16] : ret_data[23:16],
                                        wstrb_r[1] ? wdata_r[15: 8] : ret_data[15: 8],
                                        wstrb_r[0] ? wdata_r[ 7: 0] : ret_data[ 7: 0]
                                    } : ret_data
                                );
        assign way3_bank_din[i] = {32{wbuf_curr_state[`CACHE_WBUF_IS_WRITE]}} & wbuf_wdata
                                | {32{main_curr_state[`CACHE_MAIN_IS_REFILL]}} & (
                                    offset_r[3:2] == i && op_r ? {
                                        wstrb_r[3] ? wdata_r[31:24] : ret_data[31:24],
                                        wstrb_r[2] ? wdata_r[23:16] : ret_data[23:16],
                                        wstrb_r[1] ? wdata_r[15: 8] : ret_data[15: 8],
                                        wstrb_r[0] ? wdata_r[ 7: 0] : ret_data[ 7: 0]
                                    } : ret_data
                                );
    end
endgenerate



//75
always @ (posedge clk) begin
    if (rst) begin
        way0_d <= 256'b0;
        way1_d <= 256'b0;
        way2_d <= 256'b0;
        way3_d <= 256'b0;
    end else begin
        if (wbuf_curr_state[`CACHE_WBUF_IS_WRITE] && wbuf_way0_hit) begin
            way0_d[wbuf_index] <= 1'b1;
        end else if (main_curr_state[`CACHE_MAIN_IS_REFILL] && (replace_way == 0) && ret_valid && ret_last && op_r) begin
            way0_d[index_r] <= 1'b1;
        end else if (cacop_curr_status == `CACOP_MAIN_REFILL && (reg_cacop_op == 2'h0 || reg_cacop_op == 2'h1) && reg_cacop_pa[1:0] == 0)begin
            way0_d[reg_cacop_pa[11:4]] <=1'b0;
        end else if (cacop_curr_status == `CACOP_MAIN_REFILL &&  reg_cacop_op == 2'h2 && reg_cacop_hit == 0) begin
            way0_d[reg_cacop_pa[11:4]] <=1'b0;
        end

        if (wbuf_curr_state[`CACHE_WBUF_IS_WRITE] && wbuf_way1_hit) begin
            way1_d[wbuf_index] <= 1'b1;
        end else if (main_curr_state[`CACHE_MAIN_IS_REFILL] && (replace_way == 1) && ret_valid && ret_last && op_r) begin
            way1_d[index_r] <= 1'b1;
        end else if (cacop_curr_status == `CACOP_MAIN_REFILL && (reg_cacop_op == 2'h0 || reg_cacop_op == 2'h1) && reg_cacop_pa[1:0] == 1)begin
            way1_d[reg_cacop_pa[11:4]] <=1'b0;
        end else if (cacop_curr_status == `CACOP_MAIN_REFILL &&  reg_cacop_op == 2'h2 && reg_cacop_hit == 1) begin
            way1_d[reg_cacop_pa[11:4]] <=1'b0;
        end

        if (wbuf_curr_state[`CACHE_WBUF_IS_WRITE] && wbuf_way2_hit) begin
            way2_d[wbuf_index] <= 1'b1;
        end else if (main_curr_state[`CACHE_MAIN_IS_REFILL] && (replace_way == 2) && ret_valid && ret_last && op_r) begin
            way2_d[index_r] <= 1'b1;
        end else if (cacop_curr_status == `CACOP_MAIN_REFILL && (reg_cacop_op == 2'h0 || reg_cacop_op == 2'h1) && reg_cacop_pa[1:0] == 2)begin
            way2_d[reg_cacop_pa[11:4]] <=1'b0;
        end else if (cacop_curr_status == `CACOP_MAIN_REFILL &&  reg_cacop_op == 2'h2 && reg_cacop_hit == 2) begin
            way2_d[reg_cacop_pa[11:4]] <=1'b0;
        end

        if (wbuf_curr_state[`CACHE_WBUF_IS_WRITE] && wbuf_way3_hit) begin
            way3_d[wbuf_index] <= 1'b1;
        end else if (main_curr_state[`CACHE_MAIN_IS_REFILL] && (replace_way == 3) && ret_valid && ret_last && op_r) begin
            way3_d[index_r] <= 1'b1;
        end else if (cacop_curr_status == `CACOP_MAIN_REFILL && (reg_cacop_op == 2'h0 || reg_cacop_op == 2'h1) && reg_cacop_pa[1:0] == 3)begin
            way3_d[reg_cacop_pa[11:4]] <=1'b0;
        end else if (cacop_curr_status == `CACOP_MAIN_REFILL &&  reg_cacop_op == 2'h2 && reg_cacop_hit == 3) begin
            way3_d[reg_cacop_pa[11:4]] <=1'b0;
        end
    end
end

// miss buffer

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

always @ (posedge clk) begin
    if (rst) begin
        replace_req <= 1'b0;
        replace_way <=2'b00;
    end else if (main_curr_state[`CACHE_MAIN_IS_MISS] && wr_rdy  && (fang_uncache_write || fang_uncache_read)) begin
        replace_req <= fang_uncache_write ;
        replace_way <= unvalid_replaceway;
    end else if (main_curr_state[`CACHE_MAIN_IS_MISS] && wr_rdy) begin  // MISS -> REPLACE
        replace_req <= (unvalid_replaceway == 0) ? way0_v && way0_d[index_r] : (unvalid_replaceway == 1) ? way1_v && way1_d[index_r]: (unvalid_replaceway == 2) ? way2_v && way2_d[index_r]:way3_v && way3_d[index_r];
        replace_way <= unvalid_replaceway;
    end else if(cacop_curr_status == `CACOP_MAIN_MISS && wr_rdy && reg_cacop_op == 2'h1)begin
        replace_req <= (reg_cacop_pa[1:0] == 0) ? way0_v && way0_d[reg_cacop_pa[11:4]] : (reg_cacop_pa[1:0] == 1) ? way1_v && way1_d[reg_cacop_pa[11:4]] : (reg_cacop_pa[1:0] == 2) ? way2_v && way2_d[reg_cacop_pa[11:4]] : way3_v && way3_d[reg_cacop_pa[11:4]];
        replace_way <= reg_cacop_pa[1:0];
    end else if(cacop_curr_status == `CACOP_MAIN_MISS && wr_rdy && reg_cacop_op == 2'h2)begin
        replace_req <=(reg_cacop_hit == 0) ? way0_v && way0_d[reg_cacop_pa[11:4]] : (reg_cacop_hit == 1) ? way1_v && way1_d[reg_cacop_pa[11:4]] : (reg_cacop_hit == 2) ? way2_v && way2_d[reg_cacop_pa[11:4]] : way3_v && way3_d[reg_cacop_pa[11:4]];
        replace_way <= reg_cacop_hit;
    end else begin
        replace_req <= 1'b0;
        replace_way <= replace_way;
    end
end


//75

// MISS

assign wr_req = replace_req;
//72
//assign wr_type = ((fang_uncache_write || fang_uncache_read)|| cacop_curr_status == `CACHE_MAIN_REPLACE) ? {1'b0,size_r}:3'b100;
assign wr_type = ((fang_uncache_write || fang_uncache_read) && (reg_cacop_en == 2'b00)) ? {1'b0,size_r}:3'b100;
//72
assign wr_addr = cacop_curr_status == `CACOP_MAIN_REPLACE && replace_way==0? {way0_tag, reg_cacop_pa[11:4], 4'b0} : cacop_curr_status == `CACOP_MAIN_REPLACE && replace_way==1 ? {way1_tag, reg_cacop_pa[11:4], 4'b0} :cacop_curr_status == `CACOP_MAIN_REPLACE && replace_way==2? {way2_tag, reg_cacop_pa[11:4], 4'b0}:cacop_curr_status == `CACOP_MAIN_REPLACE && replace_way==3? {way3_tag, reg_cacop_pa[11:4], 4'b0} : (fang_uncache_write)? {tag_r,index_r,offset_r}:(replace_way == 0) ? {way0_tag, index_r, 4'b0} : (replace_way == 1) ? {way1_tag, index_r, 4'b0} : (replace_way == 2) ? {way2_tag, index_r, 4'b0}: {way3_tag, index_r, 4'b0};
//72
assign wr_wstrb = (fang_uncache_write || fang_uncache_read)? wstrb_r : 4'b1111;
assign wr_data = (fang_uncache_write || fang_uncache_read)? {96'b0,wdata_r}:(replace_way == 0) ? 
    {way0_bank_dout[3], way0_bank_dout[2], way0_bank_dout[1], way0_bank_dout[0]} : replace_way == 1 ?
    {way1_bank_dout[3], way1_bank_dout[2], way1_bank_dout[1], way1_bank_dout[0]} : replace_way == 2 ?
    {way2_bank_dout[3], way2_bank_dout[2], way2_bank_dout[1], way2_bank_dout[0]} : 
    {way3_bank_dout[3], way3_bank_dout[2], way3_bank_dout[1], way3_bank_dout[0]};

// REPLACE
//72
assign rd_req = main_curr_state[`CACHE_MAIN_IS_REPLACE];







//71
assign rd_type = (fang_uncache_read || fang_uncache_write)? {1'b0,size_r} : 3'b100;
//71
assign rd_addr = (fang_uncache_read || fang_uncache_write)? {tag_r, index_r, offset_r} : {tag_r, index_r, 4'b0};



// REFILL

always @ (posedge clk) begin
    if (rst) begin
        ret_bank_cnt <= 2'b0;
    end else if (main_curr_state[`CACHE_MAIN_IS_REFILL] && ret_valid && ret_last) begin
        ret_bank_cnt <= 2'b0;
    end else if (main_curr_state[`CACHE_MAIN_IS_REFILL] && ret_valid && !ret_last) begin
        ret_bank_cnt <= ret_bank_cnt + 2'b1;
    end else begin
        ret_bank_cnt <= ret_bank_cnt;
    end
end

generate
    for (i=0;i<4;i=i+1) begin
        assign way0_tagv_we = main_curr_state[`CACHE_MAIN_IS_REFILL] && (replace_way == 0) && ret_valid && ret_last
        || cacop_curr_status == `CACOP_MAIN_REFILL && (reg_cacop_op == 2'h0 || reg_cacop_op == 2'h1) && 0 == reg_cacop_pa[1:0]
        || cacop_curr_status == `CACOP_MAIN_REFILL &&  reg_cacop_op == 2'h2 && 0 == reg_cacop_hit;

        assign way1_tagv_we = main_curr_state[`CACHE_MAIN_IS_REFILL] && (replace_way == 1) && ret_valid && ret_last
        || cacop_curr_status == `CACOP_MAIN_REFILL && (reg_cacop_op == 2'h0 || reg_cacop_op == 2'h1) && 1 == reg_cacop_pa[1:0]
        || cacop_curr_status == `CACOP_MAIN_REFILL &&  reg_cacop_op == 2'h2 && 1 == reg_cacop_hit;



        assign way2_tagv_we = main_curr_state[`CACHE_MAIN_IS_REFILL] && (replace_way == 2) && ret_valid && ret_last
        || cacop_curr_status == `CACOP_MAIN_REFILL && (reg_cacop_op == 2'h0 || reg_cacop_op == 2'h1) && 2 == reg_cacop_pa[1:0]
        || cacop_curr_status == `CACOP_MAIN_REFILL &&  reg_cacop_op == 2'h2 && 2 == reg_cacop_hit;

        assign way3_tagv_we = main_curr_state[`CACHE_MAIN_IS_REFILL] && (replace_way == 3) && ret_valid && ret_last
        || cacop_curr_status == `CACOP_MAIN_REFILL && (reg_cacop_op == 2'h0 || reg_cacop_op == 2'h1) && 3 == reg_cacop_pa[1:0]
        || cacop_curr_status == `CACOP_MAIN_REFILL &&  reg_cacop_op == 2'h2 && 3 == reg_cacop_hit;


        assign way0_tagv_din ={21{cacop_curr_status == `CACOP_MAIN_REFILL}}  ? 21'b0 :  {tag_r, 1'b1};
        assign way1_tagv_din ={21{cacop_curr_status == `CACOP_MAIN_REFILL}}  ? 21'b0 :  {tag_r, 1'b1};

        assign way2_tagv_din ={21{cacop_curr_status == `CACOP_MAIN_REFILL}}  ? 21'b0 :  {tag_r, 1'b1};
        assign way3_tagv_din ={21{cacop_curr_status == `CACOP_MAIN_REFILL}}  ? 21'b0 :  {tag_r, 1'b1};
    end
endgenerate



// debug for sim
(* mark_debug="true", keep="true" *) reg [31:0] dcache_replace_count;
always@(posedge clk) begin
    if(rst) dcache_replace_count <= 32'b0;
    else if(!(fang_uncache_read || fang_uncache_write) && ((rd_req && rd_rdy)||(wr_req && wr_rdy))) begin
        dcache_replace_count <= dcache_replace_count + 1;
    end
end

endmodule

