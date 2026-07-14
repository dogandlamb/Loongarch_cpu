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
    catch { puts "  rob head_v=[get_value $cpu/u_rob/cmt0_valid_o] head_c=[get_value $cpu/u_rob/cmt0_complete_o] head_last=[get_value $cpu/u_rob/cmt0_is_last_o]" }
    catch { puts "  rs0=[get_value $cpu/u_rs_alu0/occupancy_o] rsm=[get_value $cpu/u_rs_mem/occupancy_o]" }
    catch { puts "  bpu_pc=[get_value $cpu/u_bpu/pc]" }
    catch { puts "  num=[get_value $soc/u_confreg/num_data]" }
}

run 3080us
snap "3080us"
run 40us
snap "3120us"

close_sim -force
quit
