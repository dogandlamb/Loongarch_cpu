set proj_dir [file normalize [file dirname [info script]]/project]
open_project $proj_dir/loongson.xpr
close_sim -quiet
launch_simulation -simset sim_1 -mode behavioral
restart
set cpu /tb_top/u_soc_top/u_cpu
set last_dis -1
for {set t 0} {$t < 15000} {incr t 100} {
    run 100ns
    set disv [get_value $cpu/u_rename/dis0_valid_o]
    set ft [get_value $cpu/u_rename/dis0_futype_o]
    set dpc [get_value $cpu/u_rename/dis0_pc_o]
    set cg [get_value $cpu/u_rename/can_go]
    set dr [get_value $cpu/u_dispatch/dispatch_ready_o]
    set mp [get_value $cpu/u_dispatch/rs_mem_push_valid_o]
    if {$disv != $last_dis || $cg == 1 || $mp == 1} {
        puts "[format %7d $t]ns dis=$disv ft=$ft pc=$dpc can_go=$cg dr=$dr mem_push=$mp"
        set last_dis $disv
    }
}
close_sim -force
quit
