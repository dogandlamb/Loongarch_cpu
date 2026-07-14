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
set soc /tb_top/u_soc_top

run 38us
puts "=== 38us ==="
catch { puts "wb_pc=[get_value $soc/debug_wb_pc]" }
catch { puts "dbg0_v=[get_value $cpu/u_commit/debug0_valid_o] dbg0_pc=[get_value $cpu/u_commit/debug0_pc_o] dbg0_inst=[get_value $cpu/u_commit/debug0_inst_o]" }
catch { puts "dbg0_wdata=[get_value $cpu/u_commit/debug0_rf_wdata_o] wnum=[get_value $cpu/u_commit/debug0_rf_wnum_o]" }
catch { puts "num=[get_value $soc/u_confreg/num_data]" }
catch { puts "ib=[get_value $cpu/u_inst_buffer/count_o] can_go=[get_value $cpu/u_rename/can_go]" }

run 5us
puts "=== 43us ==="
catch { puts "wb_pc=[get_value $soc/debug_wb_pc]" }
catch { puts "dbg0_v=[get_value $cpu/u_commit/debug0_valid_o] dbg0_pc=[get_value $cpu/u_commit/debug0_pc_o] dbg0_inst=[get_value $cpu/u_commit/debug0_inst_o]" }
catch { puts "dbg0_wdata=[get_value $cpu/u_commit/debug0_rf_wdata_o] wnum=[get_value $cpu/u_commit/debug0_rf_wnum_o]" }
catch { puts "num=[get_value $soc/u_confreg/num_data]" }

close_sim -force
quit
