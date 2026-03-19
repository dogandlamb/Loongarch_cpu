`timescale 1ns / 1ps
`include "defines.vh"
`include "csr_defines.vh"

module dram_fifo (
    input wire clk,
    input wire rst,

    input wire flush,

    input wire [1:0] enqueue_en, //闂傚倷鑳舵灙缂佽鐗撳畷鏇㈡濞寸缍侀弫鍌炴嚍閵夈儺鈧捇姊洪崗鐓庡闁搞劋鍗冲畷銏ゅ级閹愁剙閰ｅ畷鍫曟晲閸屾矮澹曢梺鍛婂姈瑜板啴鍩㈤敓锟?
    input wire [`DECODE_DATA_WIDTH - 1:0] enqueue_data1, //闂傚倸鍊烽懗鑸电仚缂備浇顕ч悧鎾崇暦閺囥垺顥堟繛瀵割劜缂嶄線寮崘顔肩＜婵﹩鍘鹃埀顒夊墴濮婅櫣绱掑鍡樼暥闂佺粯顨呭Λ娑氬垝婵犲洦鏅搁柨鐕傛嫹
    input wire [`DECODE_DATA_WIDTH - 1:0] enqueue_data2, 

    input wire [1:0] invalid_en, // 闂傚倷娴囧銊╂嚄閼稿灚娅犳俊銈傚亾闁伙絽鐏氱粭鐔煎焵椤掆偓椤曪綁宕归銏㈢獮闁诲函缍嗛崑鍛存偟閳╁啰绠鹃弶鍫濆⒔缁夘剟鏌涙惔鈽嗙吋鐎规洘顨呰灒闁煎鍊愰弨鎶芥⒑閻愯棄鍔氶柛鐔稿缁绘盯鏁撻敓锟?
    output wire [`DECODE_DATA_WIDTH - 1:0] dequeue_data1, //闂傚倸鍊风粈渚€骞夐敓鐘插瀭閻犺桨璀﹀〒濠氭煢濡尨绱氶柨婵嗩槹閺呮繈鏌涚仦鍓ь暡闁诲寒鍓熷铏圭磼濮楀棙鐣堕梺缁橆殔濡稓鍒掓繝鍥ㄦ櫢闁跨噦鎷?
    output wire [`DECODE_DATA_WIDTH - 1:0] dequeue_data2,
    
    output wire get_data_req,
    output wire full,
    output wire empty
);

    reg [`DECODE_DATA_WIDTH - 1:0] ram [`DEPTH - 1:0];

    // 闂傚倸鍊搁崐鎼佸疮娴兼潙绐楅幖娣妽閸嬪嫭銇勯幒鎴濐仼缂佲偓閸愨晝绠鹃柛鈩兠慨鍫熺箾閸繄鍩ｉ柡宀€鍠撻幏鐘诲灳閾忣偆褰茬紓鍌欐祰妞村摜鎹㈤崼婵愭綎濠靛倸鎲￠崑鍕煛鐎ｉ潧浜楃紒顔芥崌閺岋綁鎮╅崣澶婄獩缂備緡鍣崹璺侯嚕閹惰姤鍋勯柣鎾虫捣椤斿姊虹捄銊ユ珢闁瑰嚖鎷?
    reg [$clog2(`DEPTH) - 1:0] head;    
    reg [$clog2(`DEPTH) - 1:0] tail;   

    reg [$clog2(`DEPTH) - 1:0] head_plus;   
    reg [$clog2(`DEPTH) - 1:0] tail_plus;  


    integer j;

    always @(posedge clk) 
    begin
        if(rst || flush)
        begin
            for(j=0;j<8;j=j+1)
            begin
                ram[j] <= 0;
            end
            tail <= 0;
            tail_plus <= 1;
            head <= 0;
            head_plus <= 1;
        end
        else 
        begin
            case({invalid_en,enqueue_en})
            4'b1111:begin
                tail <= tail + 2;
                tail_plus <= tail_plus + 2;
                head <= head + 2;
                head_plus <= head_plus + 2;
                ram[head][0] <= 0;
                ram[head_plus][0] <= 0;
                ram[tail] <= enqueue_data1;
                ram[tail_plus] <= enqueue_data2;
            end
            4'b1011:begin
                tail <= tail + 2;
                tail_plus <= tail_plus + 2;
                head <= head + 1;
                head_plus <= head_plus + 1;
                ram[head][0] <= 0;
                ram[tail] <= enqueue_data1;
                ram[tail_plus] <= enqueue_data2;
            end
            4'b0111:begin
                tail <= tail + 2;
                tail_plus <= tail_plus + 2;
                head <= head + 1;
                head_plus <= head_plus + 1;
                ram[head][0] <= 0;
                ram[tail]     <= enqueue_data1;
                ram[tail_plus] <= enqueue_data2;
            end
            4'b0011:begin
                tail <= tail + 2;
                tail_plus <= tail_plus + 2;
                ram[tail]     <= enqueue_data1;
                ram[tail_plus] <= enqueue_data2;
            end
            //*******************************
            4'b1101:begin
                tail <= tail + 1;
                tail_plus <= tail_plus + 1;
                head <= head + 2;
                head_plus <= head_plus + 2;
                ram[head][0] <= 0;
                ram[head_plus][0] <= 0;
                ram[tail] <= enqueue_data1;
            end
            4'b1001:begin
                tail <= tail + 1;
                tail_plus <= tail_plus + 1;
                head <= head + 1;
                head_plus <= head_plus + 1;
                ram[head][0] <= 0;
                ram[tail] <= enqueue_data1;
            end
            4'b0101:begin
                tail <= tail + 1;
                tail_plus <= tail_plus + 1;
                head <= head + 1;
                head_plus <= head_plus + 1;
                ram[head][0] <= 0;
                ram[tail]     <= enqueue_data1;
            end
            4'b0001:begin
                tail <= tail + 1;
                tail_plus <= tail_plus + 1;
                ram[tail]     <= enqueue_data1;
            end
            //*******************************
            4'b1100:begin
                head <= head + 2;
                head_plus <= head_plus + 2;
                ram[head][0] <= 0;
                ram[head_plus][0] <= 0;
            end
            4'b1000:begin
                head <= head + 1;
                head_plus <= head_plus + 1;
                ram[head][0] <= 0;
            end
            4'b0100:begin
                head <= head + 1;
                head_plus <= head_plus + 1;
                ram[head][0] <= 0;
            end
            default:;
            endcase
        end
    end


    // 闂傚倸鍊搁崐鎼佸磹瀹勬噴褰掑炊瑜夐弸鏍煛閸ャ儱鐏╃紒鎰殜閺岀喖鎮ч崼鐔哄嚒闂佸憡鍨规慨鎾煘閹达附鍋愰悗鍦Т椤ユ繄绱撴担鍝勵€岄柛銊ョ埣瀵鏁愭径濠勵吅闂佹寧绻傞幉娑㈠箻缂佹鍘搁梺鍛婁緱閸犳宕愰幇鐗堢厸鐎光偓鐎ｎ剛鐦堥悗瑙勬礃鐢帟鐏掗柣鐐寸▓閳ь剙鍘栨竟鏇㈡⒑閸濆嫮鈻夐柛瀣у亾闂佺?顑嗛幐鎼侊綖濠靛鍊锋い鎺嗗亾妞ゅ骏鎷?
    assign dequeue_data1 = ram[head];
    assign dequeue_data2 = ram[head_plus];



    // 闂傚倸鍊搁崐鎼佸磹瀹勬噴褰掑炊瑜夐弸鏍煛閸ャ儱鐏╃紒鎰殜楠炴牕菐椤掆偓閳ь剚鍨剁粋宥堛亹閹烘挾鍘繝鐢靛仧閸嬫挸鈻嶉崨顔荤箚妞ゆ劧缂夐幋锕€桅闁告洦鍨扮粻缁樸亜閺嶃劋绶辨繛鍏煎灴濮婃椽宕妷銉︾€诲┑鐐叉▕閸欏啫顕ｆ繝姘亜闁告挸寮舵晥闂佺鍋愮悰銉╁焵椤掆偓閸熻法绮婚敐澶嬧拻濞达綀濮ら妴鍐煟閹虹偟鐣垫鐐村灴瀹曟儼顧侀柛銈嗘礃閵囧嫰骞掗幋婵愪患闁搞儲鎸冲铏瑰寲閺囩偛鈷夊銈冨妼缁绘垹鈧潧銈搁獮妯肩磼濡攱瀚藉┑鐐舵彧缂嶁偓濠殿喓鍊楀☉鐢稿醇閺囩喓鍘遍梺缁樏崯鎸庢叏瀹ュ洠鍋撳▓鍨灈闁硅绱曢幑銏犫攽閸♀晜鍍靛銈嗗笒閸嬪棝宕悽鍛娾拻濞达綀娅ｇ敮娑㈡煕閵娿儱鎮戦柟渚垮姂婵¤埖寰勬繝鍕叄闂備礁缍婂Λ鍧楁倿閿曞倹鍋傛繛鎴欏灪閻撴洟鎮橀悙鎵暯妞ゅ繐鐗嗛悞鍨亜閹哄秷鍏屽褔浜堕弻宥堫檨闁告挻宀搁幊婵嬪礈瑜忕粈濠傗攽閻樺弶鎼愰柦鍐枛閺屾洘绻涢悙顒佺彆闂佺?顑呯€氫即寮婚敐澶婄厸闁稿本宀搁崵瀣磽娴ｅ搫校闁圭懓娲ら锝夘敃閿曗偓缁犳稒銇勯弽銊х煂闁哄鎮傚娲传閸曨偀鍋撹ぐ鎺濇晞婵炲棙鍔曢閬嶆煙閸撗呭笡闁抽攱甯掗湁闁挎繂鐗嗚缂佺虎鍘奸悥濂稿蓟濞戙垺鍋愰柛鎰絻椤帡鎮楀▓鍨灈闁硅绱曢幑銏犫攽閸♀晜鍍靛銈嗗笒閸嬪棝宕悽鍛娾拻濞达綀娅ｇ敮娑㈡煕閵娿儱鎮戦柟渚垮姂婵¤埖寰勬繝鍕叄闂備礁缍婂Λ鍧楁倿閿曞倹鍋傛繛鎴欏灪閻撴洟鎮橀悙鎵暯妞ゅ繐鐗嗛悞鍨亜閹哄秷鍏屽褔浜堕弻宥堫檨闁告挻宀搁幊婵嬪礈瑜忕粈濠傗攽閻樺弶鎼愰柦鍐枛閺屾洘绻涢悙顒佺彆闂佺?顑呯€氼剟濡撮幒鎴僵闁绘挸娴锋禒褔姊哄Ч鍥у姶濞存粎鍋熷Σ鎰板箳閺冨倻锛滈梺闈涚箳婵鐚惧澶嬧拺閻炴稈鈧厖澹曢梺鍝勵槸閻楀啴寮笟鈧畷鎴﹀箻閹颁焦鍍甸梺缁樺姦閸撴瑩顢旈敓锟?
    wire stall;
    assign stall = (head == (tail + 3) % `DEPTH);
    assign full = (head == (tail_plus + 1) % `DEPTH) || (head == tail_plus);
    assign empty = (head == tail) || (head == tail_plus);

    assign get_data_req = !(stall || full);

endmodule