# 读取寄存器值
# 调用示例: ReadReg 1c000000
proc ReadReg { address } {
    create_hw_axi_txn read_txn [get_hw_axis hw_axi_1] -address $address -type read
    run_hw_axi  read_txn
    set read_value [lindex [report_hw_axi_txn  read_txn] 1];
    delete_hw_axi_txn read_txn
    set tmp addr=0x
    append tmp $address
    append tmp , data=0x
    append tmp $read_value
    return $tmp
}

# 写寄存器值
# 调用示例: WriteReg 1c000000 00000000
proc WriteReg { address data } {
    create_hw_axi_txn write_txn [get_hw_axis hw_axi_1] -address $address -data $data -type write
    run_hw_axi  write_txn
    set write_value [lindex [report_hw_axi_txn  write_txn] 1];
    delete_hw_axi_txn write_txn
}

# 读取寄存器值并写入文件的函数
# 调用示例: ReadRegsToFile 0x1c000000 10 ../log.txt 
proc ReadRegsToFile { start_addr num_regs filename } {
    # 检查文件是否存在,不存在则创建
    if {![file exists [file dirname $filename]]} {
        file mkdir [file dirname $filename]
        puts "Create a directory: [file dirname $filename]"
    }
    
    # 打开文件用于写入
    if {[catch {open $filename "w"} outfile]} {
        puts "Error: Unable to create or open a file $filename"
        return
    }
    
    # 从起始地址开始循环读取指定数量的寄存器
    for {set i 0} {$i < $num_regs} {incr i} {
        # 计算当前地址
        set curr_addr [format "0x%08x" [expr $start_addr + $i * 4]]
        
        # 读取当前地址的值
        create_hw_axi_txn read_txn [get_hw_axis hw_axi_1] -address $curr_addr -type read
        run_hw_axi read_txn
        set read_value [lindex [report_hw_axi_txn read_txn] 1]
        delete_hw_axi_txn read_txn
        
        # 写入文件:地址和数据
        puts $outfile [format "addr=%s, data=0x%s" $curr_addr $read_value]
    }
    
    # 关闭文件
    close $outfile
    puts "Finish"
}

# 打开二进制文件用于读取
# set bin_file [open "../inst_data.bin" "rb"]
# set bin_file [open "../../../../software/examples/nscscc_func/obj/main.bin" "rb"]
set bin_file [open "../../../../software/examples/nscscc_perf/obj/allbench/inst_data.bin" "rb"]
fconfigure $bin_file -translation binary

# 初始地址0x1c000000
set addr_d 469762048
set addr_h [format "%08x" $addr_d]
set addr $addr_h

# 复位处理器核
WriteReg 80000000 00000000

# 一次读取1024字节(256个字)
set chunk_size 1024
while {![eof $bin_file]} {
    set data [read $bin_file $chunk_size]
    set data_len [string length $data]
    if {$data_len == 0} break
    
    # 准备burst传输的数据
    set burst_data ""
    set temp_data [list]
    
    # 首先收集所有数据
    for {set i 0} {$i < $data_len} {incr i 4} {
        if {[expr $i + 3] >= $data_len} break
        
        # 提取4字节数据并调整字节顺序(大端转小端)
        set bytes_data [string range $data $i [expr $i + 3]]
        if {[string length $bytes_data] != 4} break
        
        # 使用二进制扫描获取无符号字节
        binary scan $bytes_data B* binary_data
        set bytes [list]
        for {set j 0} {$j < 32} {incr j 8} {
            set byte [string range $binary_data $j [expr $j + 7]]
            lappend bytes [expr "0b$byte"]
        }
        
        # 格式化数据并添加到临时列表
        lappend temp_data [format "%02X%02X%02X%02X" \
            [lindex $bytes 3] \
            [lindex $bytes 2] \
            [lindex $bytes 1] \
            [lindex $bytes 0]]
    }
    
    # 反转数据顺序并构建burst_data字符串
    set temp_data [lreverse $temp_data]
    append burst_data [join $temp_data "_"]
    
    # 创建并执行burst写传输
    create_hw_axi_txn burst_write_txn [get_hw_axis hw_axi_1] \
        -address $addr \
        -len [expr $data_len/4] \
        -type write \
        -data $burst_data
    run_hw_axi burst_write_txn
    delete_hw_axi_txn burst_write_txn
    
    # 更新地址
    incr addr_d $data_len
    set addr [format "%08x" $addr_d]
}

# 撤销复位
WriteReg 40000000 00000000

# 关闭文件
close $bin_file