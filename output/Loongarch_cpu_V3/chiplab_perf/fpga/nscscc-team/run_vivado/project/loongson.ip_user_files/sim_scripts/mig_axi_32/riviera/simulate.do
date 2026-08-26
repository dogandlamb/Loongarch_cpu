transcript off
onbreak {quit -force}
onerror {quit -force}
transcript on

asim +access +r +m+mig_axi_32  -L xpm -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.mig_axi_32 xil_defaultlib.glbl

do {mig_axi_32.udo}

run 1000ns

endsim

quit -force
