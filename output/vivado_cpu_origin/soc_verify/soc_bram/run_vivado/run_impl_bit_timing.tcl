set script_dir [file dirname [file normalize [info script]]]
set project_xpr [file join $script_dir project loongson.xpr]
set report_dir [file join $script_dir project reports]

file mkdir $report_dir

if {![file exists $project_xpr]} {
    puts "INFO: project not found, recreating from create_project.tcl"
    cd $script_dir
    source [file join $script_dir create_project.tcl]
    close_project
}

open_project $project_xpr

puts "INFO: sources_1 top = [get_property top [get_filesets sources_1]]"
puts "INFO: sim_1 top     = [get_property top [get_filesets sim_1]]"

update_compile_order -fileset sources_1
update_compile_order -fileset sim_1

foreach run_name {impl_1 synth_1} {
    if {[llength [get_runs -quiet $run_name]]} {
        puts "INFO: resetting $run_name"
        reset_run $run_name
    }
}

puts "INFO: launching synth_1"
launch_runs synth_1 -jobs 4
wait_on_run synth_1
set synth_status [get_property STATUS [get_runs synth_1]]
puts "INFO: synth_1 status = $synth_status"
if {![string match "*Complete*" $synth_status]} {
    error "synth_1 did not complete successfully: $synth_status"
}

puts "INFO: launching impl_1 through write_bitstream"
launch_runs impl_1 -to_step write_bitstream -jobs 4
wait_on_run impl_1
set impl_status [get_property STATUS [get_runs impl_1]]
puts "INFO: impl_1 status = $impl_status"
if {![string match "*Complete*" $impl_status]} {
    error "impl_1 did not complete successfully: $impl_status"
}

open_run impl_1

set timing_summary_rpt [file join $report_dir timing_summary_impl_1.rpt]
set timing_paths_rpt   [file join $report_dir timing_paths_impl_1.rpt]
set util_rpt           [file join $report_dir utilization_impl_1.rpt]
set clock_rpt          [file join $report_dir clock_util_impl_1.rpt]
set route_rpt          [file join $report_dir route_status_impl_1.rpt]
set drc_rpt            [file join $report_dir drc_impl_1.rpt]

report_timing_summary -delay_type max -report_unconstrained -check_timing_verbose -max_paths 20 -input_pins -file $timing_summary_rpt
report_timing         -delay_type max -max_paths 50 -sort_by group -input_pins -file $timing_paths_rpt
report_utilization    -file $util_rpt
report_clock_utilization -file $clock_rpt
report_route_status   -file $route_rpt
report_drc            -file $drc_rpt

set bit_candidates [glob -nocomplain [file join $script_dir project loongson.runs impl_1 *.bit]]
if {[llength $bit_candidates] > 0} {
    puts "INFO: bitstream = [lindex $bit_candidates 0]"
} else {
    puts "WARNING: no .bit file found under [file join $script_dir project loongson.runs impl_1]"
}

puts "INFO: timing summary report = $timing_summary_rpt"
puts "INFO: timing paths report   = $timing_paths_rpt"
puts "INFO: utilization report    = $util_rpt"

close_project
