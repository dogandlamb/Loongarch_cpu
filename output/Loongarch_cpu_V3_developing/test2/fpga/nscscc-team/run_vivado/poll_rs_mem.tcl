set proj_dir [file normalize [file dirname [info script]]/project]
open_project $proj_dir/loongson.xpr
close_sim -quiet
launch_simulation -simset sim_1 -mode behavioral
restart
set cpu /tb_top/u_soc_top/u_cpu
set last_cnt -1
for {set t 0} {$t < 15000} {incr t 200} {
    run 200ns
    set cnt [get_value $cpu/u_rs_mem/count]
    set push [get_value $cpu/u_dispatch/rs_mem_push_valid_o]
    set disv [get_value $cpu/u_rename/dis0_valid_o]
    set cmtpc [get_value $cpu/dbg_rob_cmt0_pc]
    if {$cnt != $last_cnt || $push == 1} {
        puts "[format %7d $t]ns rs_mem=$cnt push=$push dis0=$disv cmt_pc=$cmtpc"
        set last_cnt $cnt
    }
}
close_sim -force
quit
