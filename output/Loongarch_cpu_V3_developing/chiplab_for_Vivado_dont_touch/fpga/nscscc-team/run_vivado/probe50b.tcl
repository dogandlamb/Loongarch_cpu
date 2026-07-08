set proj_dir [file normalize [file dirname [info script]]/project]
open_project $proj_dir/loongson.xpr
close_sim -quiet
launch_simulation -simset sim_1 -mode behavioral
restart
run 50us
set cpu /tb_top/u_soc_top/u_cpu
puts "ws_valid = [get_value $cpu/ws_valid]"
puts "ftq_full = [get_value $cpu/ftq_full]"
puts "ftq.bpu_ptr = [get_value $cpu/u_ftq/bpu_ptr]"
puts "ftq.ifu_ptr = [get_value $cpu/u_ftq/ifu_ptr]"
puts "ftq.cmt_ptr = [get_value $cpu/u_ftq/cmt_ptr]"
puts "ib.count = [get_value $cpu/u_inst_buffer/count]"
puts "ib.pop0_pc = [get_value $cpu/u_inst_buffer/pop0_pc_o]"
puts "ib.pop0_inst = [get_value $cpu/u_inst_buffer/pop0_inst_o]"
puts "rn.can_go = [get_value $cpu/u_rename/can_go]"
puts "rn.dis0_valid = [get_value $cpu/u_rename/dis0_valid_o]"
puts "rn.dis0_pc = [get_value $cpu/u_rename/dis0_pc_o]"
puts "rn.dis0_futype = [get_value $cpu/u_rename/dis0_futype_o]"
puts "dp.dispatch_ready = [get_value $cpu/u_dispatch/dispatch_ready_o]"
puts "rob.rob_full = [get_value $cpu/u_rob/rob_full_o]"
puts "dbg_rob_cmt0_valid = [get_value $cpu/dbg_rob_cmt0_valid]"
puts "dbg_rob_cmt0_pc = [get_value $cpu/dbg_rob_cmt0_pc]"
puts "dbg_rob_cmt0_complete = [get_value $cpu/dbg_rob_cmt0_complete]"
close_sim -force
quit
