open_hw_manager
connect_hw_server
open_hw_target

set_property PROBES.FILE [lindex $argv 1] [get_hw_devices xc7a200t_0]
set_property FULL_PROBES.FILE [lindex $argv 1] [get_hw_devices xc7a200t_0]
set_property PROGRAM.FILE [lindex $argv 0] [get_hw_devices xc7a200t_0]
program_hw_devices [get_hw_devices xc7a200t_0]
refresh_hw_device [lindex [get_hw_devices xc7a200t_0] 0]

source ../jtag_axi_master.tcl

set test [lindex $argv 2] 
switch $test {
    "perf" {
        set outfile [open "perf_vio.csv" w]
        puts $outfile "correct_flag,soc_count,cpu_count"
        # puts  $outfile \
        # "bitcount_flag,bitcount_soc,bitcount_cpu,buble_sort_flag,bubble_sort_soc,buble_sort_cpu,\
        # coremark_flag,coremark_soc,coremark_cpu,crc32_flag,crc32_soc,crc32_cpu,\
        # dhrystone_flag,dhrystone_soc,dhrystone_cpu,quick_sort_flag,quick_sort_soc,quick_sort_cpu,\
        # select_sort_flag,select_sort_soc,select_sort_cpu,sha_soc_flag,sha_soc,sha_cpu,\
        # stream_soc_flag,stream_soc,stream_cpu,stringsearch_flag,stringsearch_soc,stringsearch_cpu"
        close $outfile

        for {set index 126} { $index > 106 } {incr index -1 } {
            # puts "value of a: $index"
            #  1: 0111_1110 = 7E,  2: 0111_1101 = 7D,  3: 0111_1100 = 7C,  4: 0111_1011 = 7B,  5: 0111_1010 = 7A, 
            #  6: 0111_1001 = 79,  7: 0111_1000 = 78,  8: 0111_0111 = 77,  9: 0111_0110 = 76, 10: 0111_0101 = 75, 
            # 11: 0111_0100 = 74, 12: 0111_0011 = 73, 13: 0111_0010 = 72, 14: 0111_0001 = 71, 15: 0111_0000 = 70
            # 16: 0110_1111 = 6F, 17: 0110_1110 = 6E, 18: 0110_1101 = 6D, 19: 0110_1100 = 6C, 20: 0110_1011 = 6B,
            after 1000
            set_property OUTPUT_VALUE [format %02x $index] [get_hw_probes switch_vio] 
            commit_hw_vio [get_hw_probes switch_vio]

            # This script is used to reset the VIO core in the hardware design
            after 1000
            set_property OUTPUT_VALUE 0 [get_hw_probes resetn_vio]
            commit_hw_vio [get_hw_probes resetn_vio]
            after 1000
            set_property OUTPUT_VALUE 1 [get_hw_probes resetn_vio]
            commit_hw_vio [get_hw_probes resetn_vio]

            set timeout 10000
            set interval 100
            set elapsed 0
            set correct_flag "00000000"
            while {1} {
                refresh_hw_vio [get_hw_vios {hw_vio_1}]
                set led0 [get_property INPUT_VALUE [get_hw_probes led_rg0_OBUF]]
                set led1 [get_property INPUT_VALUE [get_hw_probes led_rg1_OBUF]]

                set led0_val 0
                set led1_val 0
                scan $led0 %x led0_val
                scan $led1 %x led1_val

                if { $led0_val != 0 && $led1_val != 0 } {
                    set correct_flag $led0
                    break
                }

                after $interval
                incr elapsed $interval
                if { $elapsed >= $timeout } {
                    set correct_flag $led0
                    break
                }
            }

            after 500
            refresh_hw_vio [get_hw_vios {hw_vio_1}]
            set soc_count [get_property INPUT_VALUE [get_hw_probes num_data]]

            puts $correct_flag
            puts $soc_count

            after 1000
            set_property OUTPUT_VALUE [format %02x [expr $index + 128]] [get_hw_probes switch_vio]
            commit_hw_vio [get_hw_probes switch_vio]

            after 1000
            refresh_hw_vio [get_hw_vios {hw_vio_1}]
            set cpu_count [get_property INPUT_VALUE [get_hw_probes num_data]]
            puts $cpu_count

            set outfile [open "perf_vio.csv" a]
            puts  $outfile "$correct_flag,$soc_count,$cpu_count"
            close $outfile
        }
    }

    "func" {
        set outfile [open "func_vio.csv" w]
        puts $outfile "func_result"

        # This script is used to reset the VIO core in the hardware design
        after 1000
        set_property OUTPUT_VALUE 0 [get_hw_probes resetn_vio]
        commit_hw_vio [get_hw_probes resetn_vio]
        after 1000
        set_property OUTPUT_VALUE 1 [get_hw_probes resetn_vio]
        commit_hw_vio [get_hw_probes resetn_vio]

        after 1000
        set_property OUTPUT_VALUE FF [get_hw_probes switch_vio] 
        commit_hw_vio [get_hw_probes switch_vio]

        after 1000
        refresh_hw_vio [get_hw_vios {hw_vio_1}]
        set func_result [get_property INPUT_VALUE [get_hw_probes num_data]]
        puts $func_result

        puts $outfile "$func_result"
        close $outfile
    }
}

close_hw_manager