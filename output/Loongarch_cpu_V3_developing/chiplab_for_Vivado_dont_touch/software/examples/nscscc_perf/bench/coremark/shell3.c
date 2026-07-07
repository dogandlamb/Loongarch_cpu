#include <machine.h>
#include <time.h>
#include <stdio.h>

extern unsigned long start_count_coremark;
extern unsigned long stop_count_coremark;
extern unsigned long total_count_coremark;

extern unsigned long start_count_my_coremark;
extern unsigned long stop_count_my_coremark;
extern unsigned long total_count_my_coremark;

void shell3(void)
{
    int err,i;

    //clear count
    SOC_TIMER = 0;
    // asm volatile("mtc0 $0, $9");


    err = 0;
    printf("coremark test begin.\n");
    if(SIMU_FLAG){
	    err = core_mark(0,0,0x66,COREMARK_LOOP,7,1,2000);
    }else{
	    err = core_mark(0,0,0x66,LOOPTIMES,7,1,2000);
    }

	if(err == 0){
        printf("coremark PASS!\n");
		*((int *)LED_RG1_ADDR) = 1;  
		*((int *)LED_RG0_ADDR) = 1;  
		*((int *)LED_ADDR)     = 0xffff;  
	}else{
        printf("coremark ERROR!!!\n");
		*((int *)LED_RG1_ADDR) = 1;  
		*((int *)LED_RG0_ADDR) = 2;  
		*((int *)LED_ADDR)     = 0;
	}

    SOC_NUM = total_count_my_coremark;  
    *((volatile unsigned *)CONFREG_CR0) = total_count_my_coremark;
    *((volatile unsigned *)CONFREG_CR1) = total_count_coremark;
	printf("coremark: Total Count(SoC count) = 0x%x\n", total_count_coremark);
	printf("coremark: Total Count(CPU count) = 0x%x\n", total_count_my_coremark);

    return;
}
