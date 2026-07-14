set proj_dir [file normalize [file dirname [info script]]/project]
open_project $proj_dir/loongson.xpr
close_sim -quiet
launch_simulation -simset sim_1 -mode behavioral
restart
set cpu /tb_top/u_soc_top/u_cpu
for {set t 0} {$t < 30000} {incr t 500} {
    run 500ns
    set cmt [get_value $cpu/dbg_rob_cmt0_pc]
    set ws [get_value $cpu/ws_valid]
    set ibc [get_value $cpu/u_inst_buffer/count]
    if {$ws == 1 || [string match *1c01* $cmt]} {
        puts "[format %7d $t]ns ws=$ws cmt=$cmt ib=$ibc"
    }
}
close_sim -force
quit
