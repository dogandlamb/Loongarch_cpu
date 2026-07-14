set proj_dir [file normalize [file dirname [info script]]/project]
open_project $proj_dir/loongson.xpr
close_sim -quiet
launch_simulation -simset sim_1 -mode behavioral
restart
set cpu /tb_top/u_soc_top/u_cpu
for {set t 10000} {$t <= 25000} {incr t 1000} {
    run 1000ns
    puts "${t}ns ib=[get_value $cpu/u_inst_buffer/count] can_go=[get_value $cpu/u_rename/can_go] cmt_pc=[get_value $cpu/dbg_rob_cmt0_pc] cmt_v=[get_value $cpu/dbg_rob_cmt0_valid] dis0=[get_value $cpu/u_rename/dis0_valid_o] dis1=[get_value $cpu/u_rename/dis1_valid_o]"
}
close_sim -force
quit
