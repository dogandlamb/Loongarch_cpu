set proj_dir [file normalize [file dirname [info script]]/project]
open_project $proj_dir/loongson.xpr
close_sim -quiet
launch_simulation -simset sim_1 -mode behavioral
restart
run 50us
set cpu /tb_top/u_soc_top/u_cpu
puts "dbg_rob_cmt0_pc = [get_value $cpu/dbg_rob_cmt0_pc]"
puts "dbg_rob_cmt0_inst = [get_value $cpu/dbg_rob_cmt0_inst]"
puts "dbg_rob_cmt0_complete = [get_value $cpu/dbg_rob_cmt0_complete]"
puts "rs_mem.count = [get_value $cpu/u_rs_mem/count]"
puts "rs_mem.issue_valid = [get_value $cpu/u_rs_mem/issue_valid_o]"
puts "rs_mem.head_ready = [get_value $cpu/u_rs_mem/head_ready]"
puts "lsu.lsu_ready = [get_value $cpu/u_lsu/lsu_ready_o]"
puts "lsu.a_valid = [get_value $cpu/u_lsu/a_valid]"
puts "lsu.m_valid = [get_value $cpu/u_lsu/m_valid]"
puts "mem_wb_valid = [get_value $cpu/mem_wb_valid]"
close_sim -force
quit
