set proj_dir [file normalize [file dirname [info script]]/project]
open_project $proj_dir/loongson.xpr
close_sim -quiet
launch_simulation -simset sim_1 -mode behavioral
restart
run 9100ns
set cpu /tb_top/u_soc_top/u_cpu
for {set i 0} {$i < 50} {incr i} {
    run 20ns
    set t [expr {9100 + $i * 20}]
    set fl [get_value $cpu/u_ctrl/flush_o]
    set ibc [get_value $cpu/u_inst_buffer/count]
    set robv [get_value $cpu/dbg_rob_cmt0_valid]
    if {$fl == 1 || $ibc != 0 || $robv == 1} {
        puts "${t}ns flush=$fl ib=$ibc rob_v=$robv"
    }
}
close_sim -force
quit
