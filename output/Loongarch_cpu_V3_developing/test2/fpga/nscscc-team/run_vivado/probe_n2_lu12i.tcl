set proj_dir [file normalize [file dirname [info script]]/project]
set _script_dir [file normalize [file dirname [info script]]]
set out_file [file normalize $_script_dir/probe_n2_lu12i_out.txt]

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

set fp [open $out_file w]

# n2 第 6 条微测：
#   1c04b380 lu12i.w r12,0xec050  -> r12 = 0xec050000
#   1c04b384 addi.w  r12,r12,0x1a1 -> r12 = 0xec0501a1
#   1c04b388 lu12i.w r13,0x18268
#   1c04b398 add.w   r10,r12,r13
# 目标：看 lu12i(1c04b380) commit 的 wdata 是否 = 0xec050000
#       看 addi(1c04b384) commit 的 src/结果

proc chk {fp cpu chan} {
    set pc [get_value $cpu/u_commit/debug${chan}_pc_o]
    # 关注 1c04b380/384/388/398 附近
    if {[string match *4b2* $pc] || [string match *4b3* $pc]} {
        set v    [get_value $cpu/u_commit/debug${chan}_valid_o]
        set inst [get_value $cpu/u_commit/debug${chan}_inst_o]
        set wd   [get_value $cpu/u_commit/debug${chan}_rf_wdata_o]
        set wn   [get_value $cpu/u_commit/debug${chan}_rf_wnum_o]
        set wen  [get_value $cpu/u_commit/debug${chan}_rf_wen_o]
        puts $fp "cmt${chan} t=[current_time] valid=$v pc=$pc inst=$inst wdata=$wd wnum=$wn wen=$wen"
        flush $fp
    }
}

proc snap_rename {fp cpu label} {
    puts $fp "=== $label ==="
    catch { puts $fp "rn can_go=[get_value $cpu/u_rename/can_go] dispatch_ready_i=[get_value $cpu/u_rename/dispatch_ready_i]" }
    catch { puts $fp "ib0 v=[get_value $cpu/u_rename/ib0_valid_i] rdy=[get_value $cpu/u_rename/ib0_ready_o] pc=[get_value $cpu/u_rename/ib0_pc_i] inst=[get_value $cpu/u_rename/ib0_inst_i] rd=[get_value $cpu/u_rename/ib0_rd_addr_i] use0=[get_value $cpu/u_rename/ib0_use_src0_i] use1=[get_value $cpu/u_rename/ib0_use_src1_i]" }
    catch { puts $fp "ib1 v=[get_value $cpu/u_rename/ib1_valid_i] rdy=[get_value $cpu/u_rename/ib1_ready_o] pc=[get_value $cpu/u_rename/ib1_pc_i] inst=[get_value $cpu/u_rename/ib1_inst_i] rd=[get_value $cpu/u_rename/ib1_rd_addr_i] use0=[get_value $cpu/u_rename/ib1_use_src0_i] use1=[get_value $cpu/u_rename/ib1_use_src1_i]" }
    catch { puts $fp "raw s0=[get_value $cpu/u_rename/ib1_src0_raw_from_ib0] s1=[get_value $cpu/u_rename/ib1_src1_raw_from_ib0] any=[get_value $cpu/u_rename/ib1_raw_from_ib0] dual=[get_value $cpu/u_rename/dual_issue_ok]" }
    catch { puts $fp "dis v0=[get_value $cpu/u_rename/dis0_valid_o] pc0=[get_value $cpu/u_rename/dis0_pc_o] v1=[get_value $cpu/u_rename/dis1_valid_o] pc1=[get_value $cpu/u_rename/dis1_pc_o]" }
    flush $fp
}

# 先跑到 416us（#02 在 422785ns），逐 10ns（每拍）抓 rename/commit
run 416us
puts $fp "=== poll from 416us step 10ns ==="
flush $fp
for {set t 0} {$t < 800} {incr t} {
    run 10ns
    chk $fp $cpu 0
    chk $fp $cpu 1
    set ib0pc [get_value $cpu/u_rename/ib0_pc_i]
    set ib1pc [get_value $cpu/u_rename/ib1_pc_i]
    if {[string match *4b2* $ib0pc] || [string match *4b3* $ib0pc] ||
        [string match *4b2* $ib1pc] || [string match *4b3* $ib1pc]} {
        snap_rename $fp $cpu "rename t=[current_time]"
    }
}

puts $fp "=== done ==="
close $fp
close_sim -force
quit
