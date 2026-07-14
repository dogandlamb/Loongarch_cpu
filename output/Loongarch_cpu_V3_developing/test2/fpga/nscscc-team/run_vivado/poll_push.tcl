set proj_dir [file normalize [file dirname [info script]]/project]
open_project $proj_dir/loongson.xpr
close_sim -quiet
launch_simulation -simset sim_1 -mode behavioral
restart
set cpu /tb_top/u_soc_top/u_cpu
for {set t 0} {$t < 50000} {incr t 500} {
    run 500ns
    set cg [get_value $cpu/u_rename/can_go]
    set dis [get_value $cpu/u_rename/dis0_valid_o]
    set ap [get_value $cpu/u_dispatch/rs_alu0_push_valid_o]
    set mp [get_value $cpu/u_dispatch/rs_mem_push_valid_o]
    set ibc [get_value $cpu/u_inst_buffer/count]
    if {$cg == 1 || $ap == 1 || $mp == 1} {
        puts "[format %7d $t]ns can_go=$cg dis=$dis alu0_push=$ap mem_push=$mp ib=$ibc"
    }
}
close_sim -force
quit
