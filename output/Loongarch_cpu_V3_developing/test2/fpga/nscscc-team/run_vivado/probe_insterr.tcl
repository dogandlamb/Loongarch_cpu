set proj_dir [file normalize [file dirname [info script]]/project]
set _script_dir [file normalize [file dirname [info script]]]
open_project $proj_dir/loongson.xpr
reset_simulation sim_1
launch_simulation -simset sim_1 -mode behavioral
set func_bin [file normalize $_script_dir/../../../software/examples/nscscc_func/obj/main.bin]
set inst_bin [file normalize $_script_dir/../inst_data.bin]
file copy -force $func_bin $inst_bin
restart
set cpu /tb_top/u_soc_top/u_cpu

run 42us
puts "=== 42us inst_error stall ==="
catch { puts "cmt=[get_value $cpu/u_ftq/cmt_ptr] bpu=[get_value $cpu/u_ftq/bpu_ptr] ifu=[get_value $cpu/u_ftq/ifu_ptr] full=[get_value $cpu/u_ftq/ftq_full_o]" }
catch { puts "ib=[get_value $cpu/u_inst_buffer/count_o] can_go=[get_value $cpu/u_rename/can_go] flush=[get_value $cpu/u_commit/flush_req_o]" }
catch { puts "rob hv=[get_value $cpu/u_rob/cmt0_valid_o] hc=[get_value $cpu/u_rob/cmt0_complete_o] rs0=[get_value $cpu/u_rs_alu0/occupancy_o]" }

close_sim -force
quit
