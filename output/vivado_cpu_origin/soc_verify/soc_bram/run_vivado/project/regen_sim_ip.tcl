open_project [file normalize "./loongson.xpr"]

set ip_files [list \
    [get_files [file normalize "./loongson.srcs/sources_1/ip/div_gen_0/div_gen_0.xci"]] \
    [get_files [file normalize "./loongson.srcs/sources_1/ip/mult_gen_0/mult_gen_0.xci"]] \
]

generate_target all $ip_files
export_ip_user_files -of_objects $ip_files -no_script -sync -force -quiet
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1
launch_simulation -simset sim_1 -mode behavioral -type functional -scripts_only
close_project
