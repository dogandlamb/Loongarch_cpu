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

foreach t {25us 35us 50us 120us} {
    run $t
    puts "=== snapshot after $t total ==="
    catch { puts "  cmt_ptr=[get_value $cpu/u_ftq/cmt_ptr]" }
    catch { puts "  bpu_ptr=[get_value $cpu/u_ftq/bpu_ptr]" }
    catch { puts "  ifu_ptr=[get_value $cpu/u_ftq/ifu_ptr]" }
    catch { puts "  ftq_cmt_valid=[get_value $cpu/u_commit/ftq_cmt_valid_o]" }
    catch { puts "  ftq_cmt_is_last=[get_value $cpu/u_commit/ftq_cmt_is_last_o]" }
    catch { puts "  cmt0_valid=[get_value $cpu/u_rob/cmt0_valid_o]" }
    catch { puts "  cmt0_complete=[get_value $cpu/u_rob/cmt0_complete_o]" }
    catch { puts "  cmt0_is_last=[get_value $cpu/u_rob/cmt0_is_last_o]" }
    catch { puts "  cmt0_effect=[get_value $cpu/u_commit/cmt0_effect]" }
    catch { puts "  debug0_valid=[get_value $cpu/u_commit/debug0_valid_o]" }
    catch { puts "  debug_wb_pc=[get_value $soc/debug_wb_pc]" }
}

close_sim -force
quit
