set proj_dir [file normalize [file dirname [info script]]/project]
set _script_dir [file normalize [file dirname [info script]]]

open_project $proj_dir/loongson.xpr
catch { set_property verilog_define {CPU_2CMT} [get_filesets sim_1] }

set func_bin [file normalize $_script_dir/../../../software/examples/nscscc_func/obj/main.bin]
set inst_bin [file normalize $_script_dir/../inst_data.bin]
if {[file exists $func_bin]} {
    file copy -force $func_bin $inst_bin
}

reset_simulation sim_1
launch_simulation -simset sim_1 -mode behavioral
restart

set rf /tb_top/u_soc_top/u_cpu/u_regfile
set soc /tb_top/u_soc_top

proc dump_n41 {label} {
    global rf soc
    puts "=== $label t=[get_value /tb_top/u_soc_top/u_cpu/u_commit/debug0_valid_o] ==="
    catch { puts "  time=[current_time]" }
    catch { puts "  wb_pc=[get_value $soc/debug_wb_pc]" }
    catch { puts "  arf_r4=[get_value $rf/rf[4]]" }
    catch { puts "  arf_r3=[get_value $rf/rf[3]]" }
    catch { puts "  num_data=[get_value $soc/u_confreg/num_data]" }
    catch { puts "  dis0_valid=[get_value /tb_top/u_soc_top/u_cpu/u_rename/dis0_valid_o]" }
    catch { puts "  dis0_pc=[get_value /tb_top/u_soc_top/u_cpu/u_rename/dis0_pc_o]" }
    catch { puts "  dis0_inst=[get_value /tb_top/u_soc_top/u_cpu/u_rename/dis0_inst_o]" }
    catch { puts "  dis0_src0_val=[get_value /tb_top/u_soc_top/u_cpu/u_rename/dis0_src0_val_o]" }
    catch { puts "  dis_arf0=[get_value /tb_top/u_soc_top/u_cpu/u_regfile/rdata0]" }
}

run 38936us
dump_n41 "after test40 pass"
run 600ns
dump_n41 "after return to start.S"
run 400us
dump_n41 "before/during n41"
run 500us
dump_n41 "n41 running"

close_sim -force
quit
