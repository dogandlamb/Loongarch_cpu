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

proc dump_state {label} {
    global cpu soc
    puts "=== $label ==="
    catch { puts "  debug_wb_pc=[get_value $soc/debug_wb_pc]" }
    catch { puts "  debug0_valid=[get_value $cpu/u_commit/debug0_valid_o]" }
    catch { puts "  debug0_inst=[get_value $cpu/u_commit/debug0_inst_o]" }
    catch { puts "  debug0_wdata=[get_value $cpu/u_commit/debug0_rf_wdata_o]" }
    catch { puts "  debug0_wnum=[get_value $cpu/u_commit/debug0_rf_wnum_o]" }
    catch { puts "  num_data=[get_value $soc/u_confreg/num_data]" }
    catch { puts "  dis0_valid=[get_value $cpu/u_rename/dis0_valid_o]" }
    catch { puts "  dis1_valid=[get_value $cpu/u_rename/dis1_valid_o]" }
    catch { puts "  dispatch_ready=[get_value $cpu/u_dispatch/dispatch_ready_o]" }
    catch { puts "  can_go=[get_value $cpu/u_rename/can_go]" }
    catch { puts "  ib_count=[get_value $cpu/u_inst_buffer/count_o]" }
    catch { puts "  rs_alu0_occ=[get_value $cpu/u_rs_alu0/occupancy_o]" }
    catch { puts "  rs_alu1_occ=[get_value $cpu/u_rs_alu1/occupancy_o]" }
    catch { puts "  rs_mem_occ=[get_value $cpu/u_rs_mem/occupancy_o]" }
    catch { puts "  rob_head=[get_value $cpu/u_rob/head_o]" }
    catch { puts "  rob_tail=[get_value $cpu/u_rob/tail_o]" }
    catch { puts "  ftq_full=[get_value $cpu/u_ftq/ftq_full_o]" }
    catch { puts "  ifu_block=[get_value $cpu/u_ifu/if_block_ftq_o]" }
}

run 44us
dump_state "44us before first error"
run 2us
dump_state "46us at first error"
run 54us
dump_state "100us"
run 4100us
dump_state "4.2ms deadlock"

close_sim -force
quit
