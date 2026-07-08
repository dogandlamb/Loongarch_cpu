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
    catch { puts "  pc=[get_value $soc/debug_wb_pc]" }
    catch { puts "  ftq cmt=[get_value $cpu/u_ftq/cmt_ptr] bpu=[get_value $cpu/u_ftq/bpu_ptr] ifu=[get_value $cpu/u_ftq/ifu_ptr] full=[get_value $cpu/u_ftq/ftq_full_o]" }
    catch { puts "  ib=[get_value $cpu/u_inst_buffer/count] pop0=[get_value $cpu/u_inst_buffer/pop0_valid_o]" }
    catch { puts "  rob head_v=[get_value $cpu/u_rob/cmt0_valid_o] head_c=[get_value $cpu/u_rob/cmt0_complete_o] head_pc=[get_value $cpu/u_rob/cmt0_pc_o]" }
    catch { puts "  rs0=[get_value $cpu/u_rs_alu0/occupancy_o] rsm=[get_value $cpu/u_rs_mem/occupancy_o]" }
    catch { puts "  ifu pre_v=[get_value $cpu/u_ifu/pre_v] if_v=[get_value $cpu/u_ifu/if_v] wait=[get_value $cpu/u_ifu/if_wait_data]" }
    catch { puts "  bpu_pc=[get_value $cpu/u_bpu/pc]" }
    catch { puts "  num=[get_value $soc/u_confreg/num_data]" }
}

run 330us
snap "330us"
run 20us
snap "350us"
run 20us
snap "370us"

close_sim -force
quit
