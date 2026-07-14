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

proc deep_snap {label} {
    global cpu soc
    puts "=== $label ==="
    catch { puts "  cmt_ptr=[get_value $cpu/u_ftq/cmt_ptr] bpu=[get_value $cpu/u_ftq/bpu_ptr] ifu=[get_value $cpu/u_ftq/ifu_ptr] full=[get_value $cpu/u_ftq/ftq_full_o]" }
    catch { puts "  ib_count=[get_value $cpu/u_inst_buffer/count_o] ib0_v=[get_value $cpu/u_inst_buffer/pop0_valid_o]" }
    catch { puts "  if_v=[get_value $cpu/u_ifu/if_v] if_wait=[get_value $cpu/u_ifu/if_wait_data] if_block=[get_value $cpu/u_ifu/if_block_ftq_o] ftq_acc=[get_value $cpu/u_ifu/ftq_accept_o]" }
    catch { puts "  rob_h=[get_value $cpu/u_rob/head_o] rob_t=[get_value $cpu/u_rob/tail_o] cmt0_v=[get_value $cpu/u_rob/cmt0_valid_o] cmt0_c=[get_value $cpu/u_rob/cmt0_complete_o] cmt0_last=[get_value $cpu/u_rob/cmt0_is_last_o]" }
    catch { puts "  cmt_rel=[get_value $cpu/u_commit/ftq_cmt_release_o] dbg0_v=[get_value $cpu/u_commit/debug0_valid_o] dbg0_pc=[get_value $cpu/u_commit/debug0_pc_o]" }
    catch { puts "  can_go=[get_value $cpu/u_rename/can_go] flush=[get_value $cpu/u_commit/flush_req_o] wb_pc=[get_value $soc/debug_wb_pc]" }
}

run 115us
deep_snap "115us"
run 10us
deep_snap "125us"
run 50us
deep_snap "175us"

close_sim -force
quit
