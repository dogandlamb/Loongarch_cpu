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

proc ftq_snap {label} {
    global cpu soc
    puts "=== $label ==="
    catch { puts "  cmt_ptr=[get_value $cpu/u_ftq/cmt_ptr]" }
    catch { puts "  cmt_squash=[get_value $cpu/u_ftq/cmt_squash_rel]" }
    catch { puts "  bpu_ptr=[get_value $cpu/u_ftq/bpu_ptr]" }
    catch { puts "  ifu_ptr=[get_value $cpu/u_ftq/ifu_ptr]" }
    catch { puts "  ftq_full=[get_value $cpu/u_ftq/ftq_full_o]" }
    catch { puts "  ifu_valid=[get_value $cpu/u_ftq/ifu_valid_o]" }
    catch { puts "  ib_count=[get_value $cpu/u_inst_buffer/count_o]" }
    catch { puts "  ib_can_push=[get_value $cpu/u_inst_buffer/can_push_o]" }
    catch { puts "  if_block_ftq=[get_value $cpu/u_ifu/if_block_ftq_o]" }
    catch { puts "  if_v=[get_value $cpu/u_ifu/if_v]" }
    catch { puts "  can_go=[get_value $cpu/u_rename/can_go]" }
    catch { puts "  flush=[get_value $cpu/u_commit/flush_req_o]" }
    catch { puts "  debug_wb_pc=[get_value $soc/debug_wb_pc]" }
    catch { puts "  cmt_release=[get_value $cpu/u_commit/ftq_cmt_release_o]" }
}

run 20us
ftq_snap "20us"
run 26us
ftq_snap "46us"
run 54us
ftq_snap "100us"
run 22us
ftq_snap "122us EENTRY"

close_sim -force
quit
