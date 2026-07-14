set proj_dir [file normalize [file dirname [info script]]/project]
open_project $proj_dir/loongson.xpr
close_sim -quiet
launch_simulation -simset sim_1 -mode behavioral
restart
run 10us
set cpu /tb_top/u_soc_top/u_cpu
puts "rn.dis0_valid=[get_value $cpu/u_rename/dis0_valid_o]"
puts "rn.dis0_futype=[get_value $cpu/u_rename/dis0_futype_o]"
puts "rn.can_go=[get_value $cpu/u_rename/can_go]"
puts "dp.dispatch_ready=[get_value $cpu/u_dispatch/dispatch_ready_o]"
puts "dp.rs_mem_push_valid=[get_value $cpu/u_dispatch/rs_mem_push_valid_o]"
puts "ib.pop0_inst=[get_value $cpu/u_inst_buffer/pop0_inst_o]"
puts "ib.pop0_valid=[get_value $cpu/u_inst_buffer/pop0_valid_o]"
close_sim -force
quit
