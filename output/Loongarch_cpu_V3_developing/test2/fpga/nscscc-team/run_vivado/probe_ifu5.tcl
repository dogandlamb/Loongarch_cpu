set proj_dir [file normalize [file dirname [info script]]/project]
open_project $proj_dir/loongson.xpr
close_sim -quiet
launch_simulation -simset sim_1 -mode behavioral
restart
run 5us
set cpu /tb_top/u_soc_top/u_cpu
puts "if_v=[get_value $cpu/u_ifu/if_v]"
puts "if_wait=[get_value $cpu/u_ifu/if_wait_data]"
puts "ic_req=[get_value $cpu/u_ifu/ic_req_o]"
puts "ic_outstanding=[get_value $cpu/u_ifu/ic_outstanding]"
puts "if_pc=[get_value $cpu/u_ifu/if_pc]"
puts "pre_v=[get_value $cpu/u_ifu/pre_v]"
puts "ftq.ifu_ptr=[get_value $cpu/u_ftq/ifu_ptr]"
puts "ib.count=[get_value $cpu/u_inst_buffer/count]"
close_sim -force
quit
