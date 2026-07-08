set proj_dir [file normalize [file dirname [info script]]/project]
open_project $proj_dir/loongson.xpr
close_sim -quiet
launch_simulation -simset sim_1 -mode behavioral
restart
run 15us
set cpu /tb_top/u_soc_top/u_cpu
foreach s {ftq_full ws_valid} { puts "$s=[get_value $cpu/$s]" }
foreach s {bpu_ptr ifu_ptr cmt_ptr} { puts "ftq.$s=[get_value $cpu/u_ftq/$s]" }
foreach s {if_v if_wait_data if_rline if_pc if_excp} { puts "ifu.$s=[get_value $cpu/u_ifu/$s]" }
foreach s {count can_push_o pop0_valid_o pop0_pc_o} { puts "ib.$s=[get_value $cpu/u_inst_buffer/$s]" }
foreach s {dis0_valid_o dis1_valid_o} { puts "rn.$s=[get_value $cpu/u_rename/$s]" }
foreach s {dispatch_ready_o} { puts "dp.$s=[get_value $cpu/u_dispatch/$s]" }
foreach s {occupancy} { puts "rsalu0.$s=[get_value $cpu/u_rs_alu0/$s]" }
foreach s {occupancy} { puts "rsalu1.$s=[get_value $cpu/u_rs_alu1/$s]" }
close_sim -force
quit
