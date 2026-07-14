set proj_dir [file normalize [file dirname [info script]]/project]
open_project $proj_dir/loongson.xpr
close_sim -quiet
launch_simulation -simset sim_1 -mode behavioral
restart
run 15600ns
set cpu /tb_top/u_soc_top/u_cpu
puts "dis0_valid=[get_value $cpu/u_rename/dis0_valid_o]"
puts "dis1_valid=[get_value $cpu/u_rename/dis1_valid_o]"
puts "dis0_pc=[get_value $cpu/u_rename/dis0_pc_o]"
puts "dis1_pc=[get_value $cpu/u_rename/dis1_pc_o]"
puts "dis0_ft=[get_value $cpu/u_rename/dis0_futype_o]"
puts "dis1_ft=[get_value $cpu/u_rename/dis1_futype_o]"
puts "dispatch_ready=[get_value $cpu/u_dispatch/dispatch_ready_o]"
puts "rs_mem_can=[get_value $cpu/u_rs_mem/can_accept_o]"
puts "rs_mem_count=[get_value $cpu/u_rs_mem/count]"
close_sim -force
quit
