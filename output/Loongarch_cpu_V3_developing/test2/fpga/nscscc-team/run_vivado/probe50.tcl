set proj_dir [file normalize [file dirname [info script]]/project]
open_project $proj_dir/loongson.xpr
close_sim -quiet
launch_simulation -simset sim_1 -mode behavioral
restart
run 50us
set cpu /tb_top/u_soc_top/u_cpu
foreach s {ws_valid debug0_wb_pc ftq_full flush_i} {
    puts "$s = [get_value $cpu/$s]"
}
foreach s {bpu_ptr ifu_ptr cmt_ptr} { puts "ftq.$s = [get_value $cpu/u_ftq/$s]" }
foreach s {count pop0_valid_o pop0_pc_o pop0_inst_o} {
    puts "ib.$s = [get_value $cpu/u_inst_buffer/$s]"
}
foreach s {can_go dispatch_ready_i dis0_valid_o dis1_valid_o rob_full_i flush_i} {
    puts "rn.$s = [get_value $cpu/u_rename/$s]"
}
foreach s {rob_full_o rob_count_o} {
    catch { puts "rob.$s = [get_value $cpu/u_rob/$s]" }
}
foreach s {dispatch_ready_o rs_alu0_can_accept_i rs_alu1_can_accept_i rs_mem_can_accept_i rs_mdu_can_accept_i} {
    catch { puts "dp.$s = [get_value $cpu/u_dispatch/$s]" }
}
foreach s {dbg_rob_cmt0_valid dbg_rob_cmt0_pc dbg_rob_cmt0_complete} {
    puts "$s = [get_value $cpu/$s]"
}
close_sim -force
quit
