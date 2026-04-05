create_project -in_memory inspect_ip -part xc7a200tfbg676-1
read_ip -quiet D:/Loongarchcpu/Loongarch_cpu/output/vivado_cpu_origin/soc_verify/soc_bram/run_vivado/project/loongson.srcs/sources_1/ip/div_gen_0/div_gen_0.xci
read_ip -quiet D:/Loongarchcpu/Loongarch_cpu/output/vivado_cpu_origin/soc_verify/soc_bram/run_vivado/project/loongson.srcs/sources_1/ip/mult_gen_0/mult_gen_0.xci

puts "==== div_gen_0 properties ===="
report_property [get_ips div_gen_0]
puts "==== mult_gen_0 properties ===="
report_property [get_ips mult_gen_0]
