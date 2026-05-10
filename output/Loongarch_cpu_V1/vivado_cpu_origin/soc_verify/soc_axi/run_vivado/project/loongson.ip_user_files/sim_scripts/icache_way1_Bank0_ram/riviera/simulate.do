transcript off
onbreak {quit -force}
onerror {quit -force}
transcript on

asim +access +r +m+icache_way1_Bank0_ram  -L xpm -L blk_mem_gen_v8_4_7 -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.icache_way1_Bank0_ram xil_defaultlib.glbl

do {icache_way1_Bank0_ram.udo}

run 1000ns

endsim

quit -force
