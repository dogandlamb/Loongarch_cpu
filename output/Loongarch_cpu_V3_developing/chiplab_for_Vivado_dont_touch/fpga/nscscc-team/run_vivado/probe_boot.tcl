set proj_dir [file normalize [file dirname [info script]]/project]
open_project $proj_dir/loongson.xpr
close_sim -quiet
launch_simulation -simset sim_1 -mode behavioral
restart
set cpu /tb_top/u_soc_top/u_cpu
foreach t {500 1000 2000 5000 10000 15000} {
    run ${t}ns
    puts "=== ${t}ns ==="
    puts "  ib.count=[get_value $cpu/u_inst_buffer/count]"
    puts "  ifu.if_v=[get_value $cpu/u_ifu/if_v]"
    puts "  ifu.if_wait=[get_value $cpu/u_ifu/if_wait_data]"
    puts "  ifu.ic_req=[get_value $cpu/u_ifu/ic_req_o]"
    puts "  rn.can_go=[get_value $cpu/u_rename/can_go]"
    puts "  rob.cmt0_pc=[get_value $cpu/dbg_rob_cmt0_pc]"
}
close_sim -force
quit
