set proj_dir [file normalize [file dirname [info script]]/project]
set _script_dir [file normalize [file dirname [info script]]]
set out_file [file normalize $_script_dir/probe_n2_tp02_out.txt]

open_project $proj_dir/loongson.xpr
catch { set_property verilog_define {CPU_2CMT} [get_filesets sim_1] }
reset_simulation sim_1
launch_simulation -simset sim_1 -mode behavioral
set func_bin [file normalize $_script_dir/../../../software/examples/nscscc_func/obj/main.bin]
set inst_bin [file normalize $_script_dir/../inst_data.bin]
file copy -force $func_bin $inst_bin
restart

set cpu /tb_top/u_soc_top/u_cpu
set soc /tb_top/u_soc_top
set rf $soc/u_cpu/u_regfile

set fp [open $out_file w]

proc snap {label} {
    global fp cpu soc rf
    puts $fp "=== $label ==="
    catch { puts $fp "  time=[current_time]" }
    catch { puts $fp "  num_data=[get_value $soc/u_confreg/num_data]" }
    catch { puts $fp "  debug0_pc=[get_value $soc/debug_wb_pc]" }
    catch { puts $fp "  debug1_pc=[get_value $soc/debug1_wb_pc]" }
    catch { puts $fp "  rf10(r10)=[get_value $rf/rf[10]]" }
    catch { puts $fp "  rf11(r11)=[get_value $rf/rf[11]]" }
    catch { puts $fp "  rf12(r12)=[get_value $rf/rf[12]]" }
    catch { puts $fp "  rf13(r13)=[get_value $rf/rf[13]]" }
    catch { puts $fp "  rf23(s0)=[get_value $rf/rf[23]]" }
    catch { puts $fp "  rf25(s2)=[get_value $rf/rf[25]]" }
    catch { puts $fp "  rf26(s3)=[get_value $rf/rf[26]]" }
    catch { puts $fp "  dbg0_v=[get_value $cpu/u_commit/debug0_valid_o] dbg0_pc=[get_value $cpu/u_commit/debug0_pc_o]" }
    catch { puts $fp "  dbg1_v=[get_value $cpu/u_commit/debug1_valid_o] dbg1_pc=[get_value $cpu/u_commit/debug1_pc_o]" }
    flush $fp
}

# #01 PASS ~393us, #02 Error ~422us
run 418us
snap "418us before #02 error"

run 3us
snap "421us"

run 2us
snap "423us after #02 error"

# Poll commits near first n2 add.w (1c04b2f8) / bne (1c04b2fc)
run 393us
for {set t 0} {$t < 60} {incr t} {
    run 500ns
    set v0 [get_value $cpu/u_commit/debug0_valid_o]
    set v1 [get_value $cpu/u_commit/debug1_valid_o]
    if {$v0 == 1} {
        set pc [get_value $cpu/u_commit/debug0_pc_o]
        if {[string match *4b2* $pc] || [string match *4b3* $pc] || [string match *4d8* $pc]} {
            set inst [get_value $cpu/u_commit/debug0_inst_o]
            set wd [get_value $cpu/u_commit/debug0_rf_wdata_o]
            set wn [get_value $cpu/u_commit/debug0_rf_wnum_o]
            puts $fp "cmt0 t=[current_time] pc=$pc inst=$inst wdata=$wd wnum=$wn"
            flush $fp
        }
    }
    if {$v1 == 1} {
        set pc [get_value $cpu/u_commit/debug1_pc_o]
        if {[string match *4b2* $pc] || [string match *4b3* $pc] || [string match *4d8* $pc]} {
            set inst [get_value $cpu/u_commit/debug1_inst_o]
            set wd [get_value $cpu/u_commit/debug1_rf_wdata_o]
            set wn [get_value $cpu/u_commit/debug1_rf_wnum_o]
            puts $fp "cmt1 t=[current_time] pc=$pc inst=$inst wdata=$wd wnum=$wn"
            flush $fp
        }
    }
}

close $fp
close_sim -force
quit
