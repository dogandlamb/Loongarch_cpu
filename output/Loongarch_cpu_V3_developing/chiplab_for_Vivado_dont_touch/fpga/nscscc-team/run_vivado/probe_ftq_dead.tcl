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

proc dump_ftq {} {
    global cpu
    catch { puts "  ftq bpu=[get_value $cpu/u_ftq/bpu_ptr]" }
    catch { puts "  ftq ifu=[get_value $cpu/u_ftq/ifu_ptr]" }
    catch { puts "  ftq cmt=[get_value $cpu/u_ftq/cmt_ptr]" }
    catch { puts "  ftq_full=[get_value $cpu/u_ftq/ftq_full_o]" }
    catch { puts "  ifu_valid=[get_value $cpu/u_ftq/ifu_valid_o]" }
    catch { puts "  ifu_accept=[get_value $cpu/u_ifu/ifu_accept_o]" }
    catch { puts "  ib_count=[get_value $cpu/u_inst_buffer/count]" }
    catch { puts "  ib_pop0=[get_value $cpu/u_inst_buffer/pop0_valid_o]" }
    catch { puts "  rob_full=[get_value $cpu/u_rob/rob_full_o]" }
}

run 46.1us
puts "=== 46.1us after error ==="
catch { puts "  num_data=[get_value $soc/u_confreg/num_data]" }
catch { puts "  debug_wb_pc=[get_value $soc/debug_wb_pc]" }

run 53.9us
puts "=== 100us ==="
dump_ftq
catch { puts "  debug_wb_pc=[get_value $soc/debug_wb_pc]" }
catch { puts "  can_go=[get_value $cpu/u_rename/can_go]" }
catch { puts "  dis0=[get_value $cpu/u_rename/dis0_valid_o]" }

run 4100us
puts "=== 4.15ms pre-deadlock ==="
dump_ftq
catch { puts "  debug_wb_pc=[get_value $soc/debug_wb_pc]" }
catch { puts "  flush=[get_value $cpu/u_ctrl/flush_o]" }

close_sim -force
quit
