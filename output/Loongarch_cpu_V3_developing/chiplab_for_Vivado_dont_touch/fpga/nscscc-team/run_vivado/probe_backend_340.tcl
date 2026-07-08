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

proc snap {label} {
    global cpu soc
    puts "=== $label ==="
    catch { puts "  wb_pc=[get_value $soc/debug_wb_pc]" }
    catch { puts "  rob head=[get_value $cpu/u_rob/head] tail=[get_value $cpu/u_rob/tail] full=[get_value $cpu/u_rob/rob_full_o]" }
    catch { puts "  cmt0 v=[get_value $cpu/u_rob/cmt0_valid_o] c=[get_value $cpu/u_rob/cmt0_complete_o] pc=[get_value $cpu/u_rob/cmt0_pc_o]" }
    catch { puts "  dis0=[get_value $cpu/u_rename/dis0_valid_o] dis1=[get_value $cpu/u_rename/dis1_valid_o] can_go=[get_value $cpu/u_rename/can_go]" }
    catch { puts "  dp_rdy=[get_value $cpu/u_dispatch/dispatch_ready_o]" }
    catch { puts "  rs0=[get_value $cpu/u_rs_alu0/occupancy_o] rs1=[get_value $cpu/u_rs_alu1/occupancy_o]" }
    catch { puts "  alu0_issue=[get_value $cpu/u_fu_alu0/issue_valid_o] alu0_wb=[get_value $cpu/u_fu_alu0/wb_valid_o]" }
    catch { puts "  ib=[get_value $cpu/u_inst_buffer/count] pop0=[get_value $cpu/u_inst_buffer/pop0_valid_o]" }
    catch { puts "  ftq cmt=[get_value $cpu/u_ftq/cmt_ptr] bpu=[get_value $cpu/u_ftq/bpu_ptr] ifu=[get_value $cpu/u_ftq/ifu_ptr] full=[get_value $cpu/u_ftq/ftq_full_o]" }
    catch { puts "  ifu pre=[get_value $cpu/u_ifu/pre_v] if=[get_value $cpu/u_ifu/if_v] wait=[get_value $cpu/u_ifu/if_wait_data]" }
}

run 328us
snap "328us"
run 4us
snap "332us"
run 8us
snap "340us"

close_sim -force
quit
