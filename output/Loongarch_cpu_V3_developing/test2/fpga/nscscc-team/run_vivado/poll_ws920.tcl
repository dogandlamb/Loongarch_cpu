set proj_dir [file normalize [file dirname [info script]]/project]
open_project $proj_dir/loongson.xpr
close_sim -quiet
launch_simulation -simset sim_1 -mode behavioral
restart
run 9180ns
set cpu /tb_top/u_soc_top/u_cpu
for {set i 0} {$i < 50} {incr i} {
    run 20ns
    set t [expr {9180 + $i * 20}]
    puts "${t}ns ws=[get_value $cpu/ws_valid] rob_v=[get_value $cpu/dbg_rob_cmt0_valid] cmt_pc=[get_value $cpu/dbg_rob_cmt0_pc] ib=[get_value $cpu/u_inst_buffer/count]"
}
close_sim -force
quit
