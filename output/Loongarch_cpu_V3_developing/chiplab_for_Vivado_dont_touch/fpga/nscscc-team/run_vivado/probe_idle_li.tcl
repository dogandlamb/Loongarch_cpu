# Trace r12 writes entering idle_1s (~0x1c010290)
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
set outf [open [file normalize [file dirname [info script]]/probe_idle_li_out.txt] w]

proc snap {} {
    global cpu outf
    set v0 [get_value $cpu/u_commit/debug0_valid_o]
    set p0 [get_value $cpu/u_commit/debug0_pc_o]
    set i0 [get_value $cpu/u_commit/debug0_inst_o]
    set n0 [get_value $cpu/u_commit/debug0_rf_wnum_o]
    set d0 [get_value $cpu/u_commit/debug0_rf_wdata_o]
    set e0 [get_value $cpu/u_commit/debug0_rf_wen_o]
    set v1 [get_value $cpu/u_commit/debug1_valid_o]
    set p1 [get_value $cpu/u_commit/debug1_pc_o]
    set i1 [get_value $cpu/u_commit/debug1_inst_o]
    set n1 [get_value $cpu/u_commit/debug1_rf_wnum_o]
    set d1 [get_value $cpu/u_commit/debug1_rf_wdata_o]
    set e1 [get_value $cpu/u_commit/debug1_rf_wen_o]
    set r12 [get_value $cpu/u_regfile/rf\[12\]]
    set dpch [scan [get_value /tb_top/u_soc_top/debug_wb_pc] %x]
    if {$dpch >= 0x1c010280 && $dpch <= 0x1c0102e0} {
        puts $outf "[current_time] wbpc=[format 0x%08x $dpch] r12=$r12 | C0 v=$v0 pc=$p0 i=$i0 en=$e0 r$n0=$d0 | C1 v=$v1 pc=$p1 i=$i1 en=$e1 r$n1=$d1"
        flush $outf
    }
    if {($v0 == 1 && ($n0 == 12 || $n0 == 13 || $n0 == 14 || $n0 == 15)) || ($v1 == 1 && ($n1 == 12 || $n1 == 13 || $n1 == 14 || $n1 == 15))} {
        puts $outf "[current_time] CMT r12-related | C0 v=$v0 pc=$p0 i=$i0 en=$e0 r$n0=$d0 | C1 v=$v1 pc=$p1 i=$i1 en=$e1 r$n1=$d1"
        flush $outf
    }
}

run 405us
for {set i 0} {$i < 500} {incr i} {
    run 10ns
    snap
}
close $outf
close_sim -force
quit
