set proj_dir [file normalize [file dirname [info script]]/project]
open_project $proj_dir/loongson.xpr
close_sim -quiet
launch_simulation -simset sim_1 -mode behavioral
restart
run 9100ns
set cpu /tb_top/u_soc_top/u_cpu
for {set i 0} {$i < 30} {incr i} {
    run 10ns
    set t [expr {9100 + $i * 10}]
    puts "${t}ns push0=[get_value $cpu/u_ifu/ib_push0_valid_o] ib=[get_value $cpu/u_inst_buffer/count] canpush=[get_value $cpu/u_inst_buffer/can_push_o] flush=[get_value $cpu/u_ctrl/flush_o]"
}
close_sim -force
quit
