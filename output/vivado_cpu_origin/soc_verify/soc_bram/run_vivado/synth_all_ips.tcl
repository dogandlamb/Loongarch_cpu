set script_dir [file dirname [file normalize [info script]]]
set project_xpr [file join $script_dir project loongson.xpr]

open_project $project_xpr

set ips [get_ips]
puts "INFO: found [llength $ips] IP(s)"
foreach ip $ips {
    puts "INFO: generating targets for $ip"
    generate_target all [get_ips $ip]
}

if {[llength $ips] > 0} {
    export_ip_user_files -of_objects $ips -no_script -sync -force -quiet
    puts "INFO: starting synth_ip"
    synth_ip $ips
}

close_project
