open_project loongson.xpr
reset_target simulation [get_ips axi_ram]
generate_target simulation [get_ips axi_ram]
export_ip_user_files -of_objects [get_ips axi_ram] -no_script -sync -force
exit
