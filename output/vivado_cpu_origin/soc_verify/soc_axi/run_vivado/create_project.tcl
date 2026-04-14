create_project -force loongson ./project -part xc7a200tfbg676-1

# 禁止 Vivado 将未解析到的层次源文件标为 AutoDisabled（否则 sim 缺 IDport 等）
set_property source_mgmt_mode None [current_project]

set script_dir [file dirname [file normalize [info script]]]

# Add conventional sources
add_files -scan_for_includes [glob -nocomplain ../rtl/*.v]
add_files -scan_for_includes [glob -nocomplain ../rtl/*/*.v]

# Add IPs (axi_ram 等：仿真改用 verilog 桩，避免缺生成网表)
add_files -quiet [glob -nocomplain ../rtl/xilinx_ip/*/*.xci]

# Add simulation files
add_files -fileset sim_1 ../testbench
set mem_f [file normalize [file join $script_dir .. sim_stubs inst_ram.mem]]
if {[file exists $mem_f]} {
    add_files -fileset sim_1 $mem_f
}

# myCPU：递归加入所有 .v（单目录 add_files 会漏子目录，导致 elaborate 缺 IDport 等）
proc add_verilog_under {root} {
    foreach p [glob -nocomplain [file join $root *]] {
        if {[file isdirectory $p]} {
            add_verilog_under $p
        } elseif {[string match "*.v" $p]} {
            add_files -quiet -scan_for_includes $p
        }
    }
}
set cpu_root [file normalize [file join $script_dir .. .. .. myCPU]]
add_verilog_under $cpu_root

# XSim：乘除 / axi_ram 行为桩（与 xci 同名模块二选一：关闭 axi_ram 的 sim 使用桩）
set stub_v [file normalize [file join $script_dir .. sim_stubs xsim_ip_stubs.v]]
if {[file exists $stub_v]} {
    add_files -fileset sim_1 $stub_v
}
foreach xf [get_files -quiet -of_objects [get_filesets sources_1] *axi_ram.xci] {
    set_property used_in_simulation false $xf
}

# Add constraints
add_files -fileset constrs_1 -quiet ./constraints

set_property -name "top" -value "tb_top" -objects  [get_filesets sim_1]
set_property -name "xsim.simulate.log_all_signals" -value "1" -objects [get_filesets sim_1]
