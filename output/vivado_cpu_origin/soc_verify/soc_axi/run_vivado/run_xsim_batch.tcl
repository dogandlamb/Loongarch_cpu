# Batch: compile + elaborate + simulate tb_top, then exit (non-zero on sim failure if we detect)
set proj_dir [file normalize [file dirname [info script]]]
set proj_file [file join $proj_dir project loongson.xpr]

if {![file exists $proj_file]} {
    puts "Creating project (first run)..."
    source [file join $proj_dir create_project.tcl]
}

open_project $proj_file
catch { set_property source_mgmt_mode None [current_project] }

# 确保仿真桩在 sim_1 且 axi_ram.xci 不参与仿真 elaborate（避免与桩模块 axi_ram 重名）
set stub_v [file normalize [file join $proj_dir .. sim_stubs xsim_ip_stubs.v]]
if {[file exists $stub_v]} {
    set have_stub [get_files -quiet -of_objects [get_filesets sim_1] *xsim_ip_stubs.v]
    if {$have_stub eq ""} {
        add_files -fileset sim_1 $stub_v
    }
}
foreach xf [get_files -quiet -of_objects [get_filesets sources_1] *axi_ram.xci] {
    catch { set_property used_in_simulation false $xf }
}

set mem_f [file normalize [file join $proj_dir .. sim_stubs inst_ram.mem]]
if {[file exists $mem_f]} {
    set have_mem [get_files -quiet -of_objects [get_filesets sim_1] inst_ram.mem]
    if {$have_mem eq ""} {
        add_files -fileset sim_1 $mem_f
    }
}

set_property top tb_top [get_filesets sim_1]
set_property top_lib xil_defaultlib [get_filesets sim_1]

update_compile_order -fileset sources_1
update_compile_order -fileset sim_1

# Close any prior sim
catch {close_sim}

set rc [catch {
    launch_simulation
} err]
if {$rc} {
    puts "ERROR launch_simulation: $err"
    exit 1
}

# Run until $finish or timeout (tb uses # cycles)
run all

puts "Simulation finished."
exit 0
