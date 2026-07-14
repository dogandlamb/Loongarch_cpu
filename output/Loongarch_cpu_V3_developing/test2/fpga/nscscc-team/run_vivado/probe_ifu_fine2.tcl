set proj_dir [file normalize [file dirname [info script]]/project]
open_project $proj_dir/loongson.xpr
close_sim -quiet
launch_simulation -simset sim_1 -mode behavioral
restart
run 7900ns
set cpu /tb_top/u_soc_top/u_cpu
for {set i 0} {$i < 60} {incr i} {
    run 50ns
    set t [expr {7900 + $i * 50}]
    puts "${t}ns if_v=[get_value $cpu/u_ifu/if_v] wait=[get_value $cpu/u_ifu/if_wait_data] ready=[get_value $cpu/u_ifu/if_ready_go] push0=[get_value $cpu/u_ifu/ib_push0_valid_o] ib=[get_value $cpu/u_inst_buffer/count] data_ok=[get_value $cpu/ic_ifu_data_ok]"
}
close_sim -force
quit
