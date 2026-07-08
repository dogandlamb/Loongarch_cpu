set proj_dir [file normalize [file dirname [info script]]/project]
open_project $proj_dir/loongson.xpr
close_sim -quiet
launch_simulation -simset sim_1 -mode behavioral
restart
run 15us
set cpu /tb_top/u_soc_top/u_cpu
foreach s {ftq_full ws_valid debug0_wb_pc dbg_rob_cmt0_valid dbg_rob_cmt0_pc} {
    puts "$s = [get_value $cpu/$s]"
}
foreach s {bpu_ptr ifu_ptr cmt_ptr ifu_valid_o ftq_full_o} {
    puts "ftq.$s = [get_value $cpu/u_ftq/$s]"
}
foreach s {pre_v if_v if_wait_data ftq_accept_o ic_req_o} {
    puts "ifu.$s = [get_value $cpu/u_ifu/$s]"
}
foreach s {count can_push_o pop0_valid_o} {
    puts "ib.$s = [get_value $cpu/u_inst_buffer/$s]"
}
foreach s {rob_full_o can_go dispatch_ready_i} {
    catch { puts "rn.$s = [get_value $cpu/u_rename/$s]" }
}
catch { puts "rob_full = [get_value $cpu/u_rob/rob_full_o]" }
close_sim -force
quit
