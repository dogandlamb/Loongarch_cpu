create_project -force loongson ./project -part xc7a200tfbg676-1

# Keep manual source management so Vivado does not auto-disable unresolved
# hierarchy files while the project is being reconstructed for simulation.
set_property source_mgmt_mode None [current_project]

# Prefer the directory resolved by the batch launcher. When this file is sourced,
# [info script] can lose its directory component and fall back to the current cwd.
if {[info exists ::proj_dir_override]} {
    set script_dir $::proj_dir_override
} else {
    set script_path [string map {\\ /} [info script]]
    if {![regexp {^(.*)/[^/]+$} $script_path -> script_dir]} {
        set script_dir [file dirname [string map {\\ /} [file normalize [info script]]]]
    }
}
puts "create_project script_dir=$script_dir"

if {![regexp {^(.*)/[^/]+$} $script_dir -> soc_axi_dir]} {
    set soc_axi_dir $script_dir
}
if {![regexp {^(.*)/[^/]+$} $soc_axi_dir -> soc_verify_dir]} {
    set soc_verify_dir $soc_axi_dir
}
if {![regexp {^(.*)/[^/]+$} $soc_verify_dir -> vivado_cpu_dir]} {
    set vivado_cpu_dir $soc_verify_dir
}

set rtl_dir "$soc_axi_dir/rtl"
set tb_dir "$soc_axi_dir/testbench"
set sim_stub_dir "$soc_axi_dir/sim_stubs"
set cpu_root "$vivado_cpu_dir/myCPU"

proc add_files_if_any {args} {
    if {[llength $args] > 0} {
        uplevel 1 add_files {*}$args
    }
}

proc add_verilog_under {root} {
    foreach p [glob -nocomplain "$root/*"] {
        if {[file isdirectory $p]} {
            add_verilog_under $p
        } elseif {[string match "*.v" $p]} {
            add_files -quiet -scan_for_includes $p
        }
    }
}

add_verilog_under $rtl_dir

if {[file exists $tb_dir]} {
    add_files -fileset sim_1 $tb_dir
}

set mem_f "$sim_stub_dir/inst_ram.mem"
if {[file exists $mem_f]} {
    add_files -fileset sim_1 $mem_f
}

add_verilog_under $cpu_root
puts "sources_1_count=[llength [get_files -quiet -of_objects [get_filesets sources_1]]]"
puts "sim_1_count=[llength [get_files -quiet -of_objects [get_filesets sim_1]]]"

set stub_v "$sim_stub_dir/xsim_ip_stubs.v"
if {[file exists $stub_v]} {
    add_files -fileset sim_1 $stub_v
}

set constr_dir "$script_dir/constraints"
if {[file exists $constr_dir]} {
    add_files -fileset constrs_1 -quiet $constr_dir
}

set_property -name top -value tb_top -objects [get_filesets sim_1]
set_property -name xsim.simulate.log_all_signals -value 1 -objects [get_filesets sim_1]
