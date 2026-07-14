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

# Poll every 500ns from 30us to 50us for commits near n1 test
run 30us
for {set t 0} {$t < 40} {incr t} {
    run 500ns
    set v [get_value $cpu/u_commit/debug0_valid_o]
    if {$v == 1} {
        set pc [get_value $cpu/u_commit/debug0_pc_o]
        set inst [get_value $cpu/u_commit/debug0_inst_o]
        set wd [get_value $cpu/u_commit/debug0_rf_wdata_o]
        set wn [get_value $cpu/u_commit/debug0_rf_wnum_o]
        set wen [get_value $cpu/u_commit/debug0_rf_wen_o]
        if {[string match *338* $pc] || [string match *347* $pc]} {
            puts "cmt pc=$pc inst=$inst wdata=$wd wnum=$wn wen=$wen"
        }
    }
}

puts "=== snap 46us ==="
catch { puts "num=[get_value $soc/u_confreg/num_data]" }
catch { puts "wb_pc=[get_value $soc/debug_wb_pc]" }

close_sim -force
quit
