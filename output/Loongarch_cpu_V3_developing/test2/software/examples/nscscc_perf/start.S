
#ifndef _KERNEL
#define _KERNEL
#endif

#include "asm.h"
#include "regdef.h"
#include "machine.h"

.extern UART_BASE

	.section .init
	.type _start,@function

	.globl	_start
	.globl	start
	.globl	__main
_start:
start:
    li.w t0, 0x10
    cpucfg t5, t0
    li.w t6, 0x1
    and t7, t5, t6
    bne t7, t6, 11f

    # init L1 I-Cache
    li.w t0, 0x11
    # t6 cache size
    cpucfg t6, t0
    # t0 WAY
    li.w t7, 0xffff
    and t0, t6, t7
    addi.w t0, t0, 0x1
    # t1 LINE
    srli.w t7, t6, 16
    andi t7, t7, 0xff
    li.w t1, 0x1
    sll.w t1, t1, t7
    # t8 OFFSET
    srli.w t8, t6, 24
    li.w t2, 0
1:  
    li.w t3, 0
2:
    sll.w t4, t3, t8
    or t4, t4, t2
    cacop 0x0, t4, 0
    addi.w t3, t3, 0x1
    bne t3, t1, 2b
    addi.w t2, t2, 0x1
    bne t2, t0, 1b

11:
    li.w t6, 0x4
    and t7, t5, t6
    bne t7, t6, 11f

    # init L1 D-Cache
    li.w t0, 0x12
    # t6 cache size
    cpucfg t6, t0
    # t0 WAY
    li.w t7, 0xffff
    and t0, t6, t7
    addi.w t0, t0, 0x1
    # t1 LINE
    srli.w t7, t6, 16
    andi t7, t7, 0xff
    li.w t1, 0x1
    sll.w t1, t1, t7
    # t8 OFFSET
    srli.w t8, t6, 24
    li.w t2, 0
1:  
    li.w t3, 0
2:
    sll.w t4, t3, t8
    or t4, t4, t2
    cacop 0x1, t4, 0
    addi.w t3, t3, 0x1
    bne t3, t1, 2b
    addi.w t2, t2, 0x1
    bne t2, t0, 1b

11:
    li.w t6, 0x18
    and t7, t5, t6
    bne t7, t6, 11f

    # init L2 Cache
    li.w t0, 0x13
    # t6 cache size
    cpucfg t6, t0
    # t0 WAY
    li.w t7, 0xffff
    and t0, t6, t7
    addi.w t0, t0, 0x1
    # t1 LINE
    srli.w t7, t6, 16
    andi t7, t7, 0xff
    li.w t1, 0x1
    sll.w t1, t1, t7
    # t8 OFFSET
    srli.w t8, t6, 24
    li.w t2, 0
1:  
    li.w t3, 0
2:
    sll.w t4, t3, t8
    or t4, t4, t2
    cacop 0x2, t4, 0
    addi.w t3, t3, 0x1
    bne t3, t1, 2b
    addi.w t2, t2, 0x1
    bne t2, t0, 1b

11:

    csrwr	$r0,0x180
    csrwr	$r0,0x181
    ori	    $r12,$r0,0x09
    csrwr	$r12,0x180
    li.w    $r12,0xa0000009
    csrwr	$r12,0x181

    ori	    $r12,$r0,0x10
    ori	    $r13,$r0,0x18
    csrxchg	$r12,$r13,0x0

    lu12i.w	$r12,114688
    ori	    $r12,$r12,0x380
    csrwr	$r12,0xc
    
    #disable_trace_cmp_s
    li.w $r25, 0xbfafff30  #OPEN_TRACE_ADDR
    st.w $r0, $r25, 0

    #disable_num_monitor_s
    li.w $r25, 0xbfafff40  #NUM_MONITOR_ADDR
    st.w $r0, $r25, 0

    /* Load data section */
	la.local t0, _data_lma
	la.local t1, _data
	la.local t2, _edata
	bgeu t1, t2, 2f
1:
	ld.w t3, t0, 0
	st.w t3, t1, 0
	addi.w t0, t0, 4
	addi.w t1, t1, 4
	bltu t1, t2, 1b
2:

	/* Clear bss section */
	la.local t0, __bss_start
	la.local t1, _end
	bgeu t0, t1, 2f
1:
	st.w $r0, t0, 0
	addi.w t0, t0, 4
	bltu t0, t1, 1b
2:

    ori	    $r12,$r0,0x19
    csrwr	$r12,0x180

	la.local	sp, _stack
    
    b run_test    #####          


.org 0x200
test_finish:
    addi.w    t0, t0, 1
    li.w      t2, UART_ADDR
    st.w      zero, t2, 0

1:
    li.w      t0, SWITCH_ADDR
    ld.w      t0, t0, 0
    andi      t0, t0, 0x80 #swith, up:0, down:1
    beq       zero, t0, 2f
    nop

    li.w     t0, CONFREG_CR0 # CPU count
    ld.w     t1, t0, 0
    b        3f
    nop
2:
    li.w     t0, CONFREG_CR1 # SoC COUNT
    ld.w     t1, t0, 0

3:
    li.w     t0, NUM_ADDR
    st.w     t1, t0, 0
    b        1b
    nop
##avoid cpu run error
    lu12i.w   t0, -0x80000
    addi.w    t1, t1, 1
    or        t2, t0, zero
    add.w     t3, t5, t6
    ld.w      t4, t0, 0

/*
 *  exception handle
 */
.org 0x380
1:  
    addi.w t0, t0, 1
    b 1b
    nop

run_test:

    /* init UART */
	la.local    t0, UART_BASE
	ld.w        t1, t0, 0
	#WRITE(li.wne,OFS_FIFO,FIFO_ENABLE|FIFO_RCV_RST|FIFO_XMT_RST|FIFO_TRIGGER_0);
	li.w       t2, 0x07   
	st.b     t2, t1, 2
	#WRITE(li.wne,OFS_LINE_CONTROL, 0x80);
	li.w       t2, 0x80
	st.b     t2, t1, 3
	#WRITE(li.wne,OFS_DIVISOR_MSB, (divisor & 0xff00) >> 8); 
	li.w       t2, 0x00 
	st.b     t2, t1, 1 
	#WRITE(li.wne,OFS_DIVISOR_LSB, divisor & 0xff);
    li.w        t3, 0xbfafff20
    ld.w        t3, t3, 0
    li.w        t2, 0x36
    beq         zero, t3, 1f
    li.w        t2, 0x1
1:
	st.b     t2, t1, 0 
	#WRITE(li.wne,OFS_DATA_FORMAT, data | parity | stop);
	li.w       t2, 0x3 
	st.b     t2, t1, 3
	#WRITE(li.wne,OFS_MODEM_CONTROL,0);
	li.w       t2, 0x0 
	st.b     t2, t1, 4 

#if CMP_FUNC==1
	bl	shell1
	nop
#elif CMP_FUNC==2
	bl	shell2
	nop
#elif CMP_FUNC==3
	bl	shell3
	nop
#elif CMP_FUNC==4
	bl	shell4
	nop
#elif CMP_FUNC==5
	bl	shell5
	nop
#elif CMP_FUNC==6
	bl	shell6
	nop
#elif CMP_FUNC==7
	bl	shell7
	nop
#elif CMP_FUNC==8
	bl	shell8
	nop
#elif CMP_FUNC==9
	bl	shell9
	nop
#elif CMP_FUNC==10
	bl	shell10
	nop
#elif CMP_FUNC==11
	bl	shell11
	nop
#elif CMP_FUNC==12
	bl	shell12
	nop
#elif CMP_FUNC==13
	bl	shell13
	nop
#elif CMP_FUNC==14
	bl	shell14
	nop
#elif CMP_FUNC==15
	bl	shell15
	nop
#elif CMP_FUNC==16
	bl	shell16
	nop
#elif CMP_FUNC==17
	bl	shell17
	nop
#elif CMP_FUNC==18
	bl	shell18
	nop
#elif CMP_FUNC==19
	bl	shell19
	nop
#elif CMP_FUNC==20
	bl	shell20
	nop
#else
    li.w t0, SWITCH_ADDR
    ld.w t0, t0, 0
    andi t0, t0, 0x1f #swith, up:0, down:1
    xori t0, t0, 0x1f
1:
    li.w t1, 0x1
    bne t0, t1, 2f
	nop
    bl shell1
    nop
    b go_finish
    nop
2:
    li.w t1, 0x2
    bne t0, t1, 3f
	nop
    bl shell2
    nop
    b go_finish
    nop
3:
    li.w t1, 0x3
    bne t0, t1, 4f
	nop
    bl shell3
    nop
    b go_finish
    nop
4:
    li.w t1, 0x4
    bne t0, t1, 5f
	nop
    bl shell4
    nop
    b go_finish
    nop
5:
    li.w t1, 0x5
    bne t0, t1, 6f
	nop
    bl shell5
    nop
    b go_finish
    nop
6:
    li.w t1, 0x6
    bne t0, t1, 7f
	nop
    bl shell6
    nop
    b go_finish
    nop
7:
    li.w t1, 0x7
    bne t0, t1, 8f
	nop
    bl shell7
    nop
    b go_finish
    nop
8:
    li.w t1, 0x8
    bne t0, t1, 9f
	nop
    bl shell8
    nop
    b go_finish
    nop
9:
    li.w t1, 0x9
    bne t0, t1, 10f
	nop
    bl shell9
    nop
    b go_finish
    nop
10:
    li.w t1, 0xa
    bne t0, t1, 11f
	nop
    bl shell10
    nop
    b go_finish
    nop
11:
    li.w t1, 0xb
    bne t0, t1, 12f
	nop
    bl shell11
    nop
    b go_finish
    nop
12:
    li.w t1, 0xc
    bne t0, t1, 13f
	nop
    bl shell12
    nop
    b go_finish
    nop
13:
    li.w t1, 0xd
    bne t0, t1, 14f
	nop
    bl shell13
    nop
    b go_finish
    nop
14:
    li.w t1, 0xe
    bne t0, t1, 15f
	nop
    bl shell14
    nop
    b go_finish
    nop
15:
    li.w t1, 0xf
    bne t0, t1, 16f
	nop
    bl shell15
    nop
    b go_finish
    nop
16:
    li.w t1, 0x10
    bne t0, t1, 17f
	nop
    bl shell16
    nop
    b go_finish
    nop
17:
    li.w t1, 0x11
    bne t0, t1, 18f
	nop
    bl shell17
    nop
    b go_finish
    nop
18:
    li.w t1, 0x12
    bne t0, t1, 19f
	nop
    bl shell18
    nop
    b go_finish
    nop
19:
    li.w t1, 0x13
    bne t0, t1, 20f
	nop
    bl shell19
    nop
    b go_finish
    nop
20:
    li.w t1, 0x14
    bne t0, t1, 21f
	nop
    bl shell20
    nop
21:
    b go_finish
    nop
#endif
go_finish:
    b  test_finish

