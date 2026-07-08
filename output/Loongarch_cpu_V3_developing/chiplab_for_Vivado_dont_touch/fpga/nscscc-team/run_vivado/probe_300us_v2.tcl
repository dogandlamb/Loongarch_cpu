set proj_dir [file normalize [file dirname [info script]]/project]
set _script_dir [file normalize [file dirname [info script]]]
open_project $proj_dir/loongson.xpr
launch_simulation -simset sim_1 -mode behavioral
set func_bin [file normalize $_script_dir/../../../software/examples/nscscc_func/obj/main.bin]
set inst_bin [file normalize $_script_dir/../inst_data.bin]
file copy -force $func_bin $inst_bin
restart
set cpu /tb_top/u_soc_top/u_cpu
set soc /tb_top/u_soc_top

proc snap {label} {
    global cpu soc
    puts "=== $label ==="
    catch { puts "  pc=[get_value $soc/debug_wb_pc]" }
    catch { puts "  ftq cmt=[get_value $cpu/u_ftq/cmt_ptr] bpu=[get_value $cpu/u_ftq/bpu_ptr] ifu=[get_value $cpu/u_ftq/ifu_ptr] full=[get_value $cpu/u_ftq/ftq_full_o] ifu_valid=[get_value $cpu/u_ftq/ifu_valid_o]" }
    catch { puts "  ftq_ifu pc=[get_value $cpu/u_ftq/ifu_pc_o] len=[get_value $cpu/u_ftq/ifu_length_o]" }
    catch { puts "  ifu pre_v=[get_value $cpu/u_ifu/pre_v] pre_pc=[get_value $cpu/u_ifu/pre_pc] sent=[get_value $cpu/u_ifu/pre_ic_sent] pre_excp=[get_value $cpu/u_ifu/pre_excp]" }
    catch { puts "  ifu if_v=[get_value $cpu/u_ifu/if_v] if_pc=[get_value $cpu/u_ifu/if_pc] wait=[get_value $cpu/u_ifu/if_wait_data] outst=[get_value $cpu/u_ifu/ic_outstanding]" }
    catch { puts "  ifu accept=[get_value $cpu/u_ifu/ftq_accept_o] ic_req=[get_value $cpu/u_ifu/ic_req_o] replay=[get_value $cpu/u_ifu/if_replay_req] predec=[get_value $cpu/u_ifu/predec_redirect_o]" }
    catch { puts "  ib=[get_value $cpu/u_inst_buffer/count] canpush=[get_value $cpu/u_inst_buffer/can_push_o] pop0=[get_value $cpu/u_inst_buffer/pop0_valid_o]" }
    catch { puts "  dis0=[get_value $cpu/u_rename/dis0_valid_o] dis1=[get_value $cpu/u_rename/dis1_valid_o] dp_rdy=[get_value $cpu/u_dispatch/dispatch_ready_o]" }
    catch { puts "  rob head_v=[get_value $cpu/u_rob/cmt0_valid_o] head_c=[get_value $cpu/u_rob/cmt0_complete_o] head_pc=[get_value $cpu/u_rob/cmt0_pc_o] full=[get_value $cpu/u_rob/rob_full_o]" }
    catch { puts "  bpu pc=[get_value $cpu/u_bpu/pc] freeze=[get_value $cpu/u_bpu/ftq_freeze] p0v=[get_value $cpu/u_bpu/p0_valid_o]" }
    catch { puts "  num=[get_value $soc/u_confreg/num_data]" }
}

run 292us
snap "292us"
run 2us
snap "294us"
run 2us
snap "296us"
run 2us
snap "298us"
run 4us
snap "302us"
run 8us
snap "310us"
run 40us
snap "350us"

close_sim -force
quit
