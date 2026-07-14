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

run 195us
puts "=== 195us ==="
catch { puts "if_v=[get_value $cpu/u_ifu/if_v] if_wait=[get_value $cpu/u_ifu/if_wait_data] pre_v=[get_value $cpu/u_ifu/pre_v] if_block=[get_value $cpu/u_ifu/if_block_ftq_o] ftq_acc=[get_value $cpu/u_ifu/ftq_accept_o]" }
catch { puts "ic_req=[get_value $cpu/u_icache/ic_req_o] ic_ok=[get_value $cpu/u_icache/ic_addr_ok_o] ic_data=[get_value $cpu/u_icache/ic_data_ok_o]" }
catch { puts "cmt_ptr=[get_value $cpu/u_ftq/cmt_ptr] bpu=[get_value $cpu/u_ftq/bpu_ptr] ifu=[get_value $cpu/u_ftq/ifu_ptr] cmt_rel=[get_value $cpu/u_commit/ftq_cmt_release_o]" }
catch { puts "ib=[get_value $cpu/u_inst_buffer/count_o]" }

run 10us
puts "=== 205us ==="
catch { puts "if_v=[get_value $cpu/u_ifu/if_v] if_wait=[get_value $cpu/u_ifu/if_wait_data] pre_v=[get_value $cpu/u_ifu/pre_v]" }
catch { puts "ic_req=[get_value $cpu/u_icache/ic_req_o] ic_data=[get_value $cpu/u_icache/ic_data_ok_o]" }
catch { puts "cmt_ptr=[get_value $cpu/u_ftq/cmt_ptr] rob_hv=[get_value $cpu/u_rob/cmt0_valid_o] rob_hc=[get_value $cpu/u_rob/cmt0_complete_o]" }

close_sim -force
quit
