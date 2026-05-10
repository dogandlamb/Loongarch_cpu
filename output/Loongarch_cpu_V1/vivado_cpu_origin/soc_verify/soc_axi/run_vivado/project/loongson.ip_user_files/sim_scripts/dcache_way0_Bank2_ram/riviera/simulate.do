transcript off
onbreak {quit -force}
onerror {quit -force}
transcript on

asim +access +r +m+dcache_way0_Bank2_ram  -L xpm -L blk_mem_gen_v8_4_7 -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.dcache_way0_Bank2_ram xil_defaultlib.glbl

do {dcache_way0_Bank2_ram.udo}

run 1000ns

endsim

quit -force
