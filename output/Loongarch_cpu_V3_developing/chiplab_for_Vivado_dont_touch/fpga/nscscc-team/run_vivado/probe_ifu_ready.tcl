set proj_dir [file normalize [file dirname [info script]]/project]
open_project $proj_dir/loongson.xpr
close_sim -quiet
launch_simulation -simset sim_1 -mode behavioral
restart
set cpu /tb_top/u_soc_top/u_cpu
foreach t {3000 6000 8000 9000 9500 10000 10500 11000} {
    run ${t}ns
    puts "${t}ns if_v=[get_value $cpu/u_ifu/if_v] wait=[get_value $cpu/u_ifu/if_wait_data] ready=[get_value $cpu/u_ifu/if_ready_go] push0=[get_value $cpu/u_ifu/ib_push0_valid_o] ib=[get_value $cpu/u_inst_buffer/count] flush=[get_value $cpu/u_ctrl/flush_o]"
}
close_sim -force
quit
