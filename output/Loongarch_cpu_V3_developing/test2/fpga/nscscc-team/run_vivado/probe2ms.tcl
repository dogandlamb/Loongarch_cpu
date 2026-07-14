set proj_dir [file normalize [file dirname [info script]]/project]
open_project $proj_dir/loongson.xpr
close_sim -quiet
launch_simulation -simset sim_1 -mode behavioral
restart
run 2ms
set cpu /tb_top/u_soc_top/u_cpu
puts "ws_valid=[get_value $cpu/ws_valid]"
puts "debug0_wb_pc=[get_value $cpu/debug0_wb_pc]"
puts "cmt_ptr=[get_value $cpu/u_ftq/cmt_ptr]"
puts "cmt0_pc=[get_value $cpu/dbg_rob_cmt0_pc]"
puts "cmt0_complete=[get_value $cpu/dbg_rob_cmt0_complete]"
close_sim -force
quit
