# Batch: compile + elaborate + simulate tb_top, then exit (non-zero on sim failure if we detect)
# Derive the script directory from the raw script string and avoid Tcl path
# normalization, which breaks under this Windows username path.
set script_path [string map {\\ /} [info script]]
if {![regexp {^(.*)/[^/]+$} $script_path -> proj_dir]} {
    set proj_dir [file dirname [string map {\\ /} [file normalize [info script]]]]
}
set proj_file "$proj_dir/project/loongson.xpr"
set ::proj_dir_override $proj_dir

if {![file exists $proj_file]} {
    puts "Project missing, recreating for xsim..."
    source "$proj_dir/create_project.tcl"
} else {
    puts "Opening existing project for xsim..."
    open_project $proj_file
}
catch { set_property source_mgmt_mode None [current_project] }

# Ensure myCPU RTL is present in sources_1 when opening an existing project.
set cpu_root "$proj_dir/../../../myCPU"
proc add_glob_to_sources {pattern} {
    foreach f [glob -nocomplain $pattern] {
        set exists [get_files -quiet -of_objects [get_filesets sources_1] $f]
        if {$exists eq ""} {
            add_files -quiet -scan_for_includes $f
        }
    }
}
add_glob_to_sources "$cpu_root/top/*.v"
add_glob_to_sources "$cpu_root/common/*.v"
add_glob_to_sources "$cpu_root/frontend/fetch/*.v"
add_glob_to_sources "$cpu_root/backend/control/*.v"
add_glob_to_sources "$cpu_root/backend/decode/*.v"
add_glob_to_sources "$cpu_root/backend/execute/*.v"
add_glob_to_sources "$cpu_root/backend/hazard/*.v"
add_glob_to_sources "$cpu_root/backend/memory/*.v"
add_glob_to_sources "$cpu_root/backend/writeback/*.v"

# ????????? sim_1 ??axi_ram.xci ????????elaborate???????????axi_ram ?????
set stub_v "$proj_dir/../sim_stubs/xsim_ip_stubs.v"
if {[file exists $stub_v]} {
    set have_stub [get_files -quiet -of_objects [get_filesets sim_1] *xsim_ip_stubs.v]
    if {$have_stub eq ""} {
        add_files -fileset sim_1 $stub_v
    }
}
foreach xf [get_files -quiet -of_objects [get_filesets sources_1] *axi_ram.xci] {
    catch { set_property used_in_simulation false $xf }
}

set mem_f "$proj_dir/../sim_stubs/inst_ram.mem"
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
    puts "Recent tool messages:"
    foreach sev {ERROR CRITICAL_WARNING WARNING} {
        catch {
            foreach msg [get_messages -severity $sev] {
                puts "$sev: $msg"
            }
        }
    }
    exit 1
}

# Ensure trace reference file is visible from xsim runtime cwd.
set trace_src "$proj_dir/../../gettrace/golden_trace.txt"
set xsim_run_dir "$proj_dir/project/loongson.sim/sim_1/behav/xsim"
if {[file exists $trace_src]} {
    if {![file exists $xsim_run_dir]} {
        file mkdir $xsim_run_dir
    }
    file copy -force $trace_src "$xsim_run_dir/golden_trace.txt"
    puts "Copied trace ref to $xsim_run_dir/golden_trace.txt"
} else {
    puts "WARNING: trace ref file not found: $trace_src"
}

# Run until $finish or timeout (tb uses # cycles)
run 1000ns

puts "Simulation finished."
exit 0

