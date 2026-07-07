#include <time.h>
#include <machine.h>
#include "confreg_time.h"

extern unsigned long start_count_strsearch;
extern unsigned long stop_count_strsearch;
extern unsigned long total_count_strsearch;

extern unsigned long start_count_my_strsearch;
extern unsigned long stop_count_my_strsearch;
extern unsigned long total_count_my_strsearch;

void shell10(void)
{
    int err,i;

    //clear count
    SOC_TIMER = 0;
    // asm volatile("mtc0 $0, $9");


    err = 0;
    printf("string search test begin.\n");
    if(SIMU_FLAG){
        err = search_small();
    }else{
        for(i=0; i<LOOPTIMES; i++)
            err += search_small();
    }

	if(err == 0){
        printf("string search PASS!\n");
		*((int *)LED_RG1_ADDR) = 1;  
	    *((int *)LED_RG0_ADDR) = 1;  
    	*((int *)LED_ADDR)     = 0xffff;  
	}else{
        printf("string search ERROR!!!\n");
		*((int *)LED_RG1_ADDR) = 1;  
	    *((int *)LED_RG0_ADDR) = 2;  
    	*((int *)LED_ADDR)     = 0;
	}

    SOC_NUM = total_count_my_strsearch;  
    *((volatile unsigned *)CONFREG_CR0) = total_count_my_strsearch;  
    *((volatile unsigned *)CONFREG_CR1) = total_count_strsearch;  
    printf("string search: Total Count(SoC count) = 0x%x\n", total_count_strsearch);
    printf("string search: Total Count(CPU count) = 0x%x\n", total_count_my_strsearch);

    return;
}
