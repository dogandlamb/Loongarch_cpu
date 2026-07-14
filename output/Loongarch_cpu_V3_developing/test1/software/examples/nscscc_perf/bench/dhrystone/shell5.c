#include <machine.h>
#include <time.h>

extern unsigned long start_count_dhry;
extern unsigned long stop_count_dhry;
extern unsigned long total_count_dhry;

extern unsigned long start_count_my_dhry;
extern unsigned long stop_count_my_dhry;
extern unsigned long total_count_my_dhry;

void shell5(void)
{
    int i,err;

    //clear count
    SOC_TIMER = 0;
    // asm volatile("mtc0 $0, $9");

    err = 0;
    printf("dhrystone test begin.\n");
    if(SIMU_FLAG){
        err = dhrystone(RUNNUMBERS);
    }else{
        err = dhrystone(LOOPTIMES*RUNNUMBERS);
    }

	if(err == 0){
        printf("dhrystone PASS!\n");
		*((int *)LED_RG1_ADDR) = 1;  
		*((int *)LED_RG0_ADDR) = 1;  
		*((int *)LED_ADDR)     = 0xffff;  
	}else{
        printf("dhrystone ERROR!!!\n");
		*((int *)LED_RG1_ADDR) = 1;  
		*((int *)LED_RG0_ADDR) = 2;  
		*((int *)LED_ADDR)     = 0;

	}

    SOC_NUM = total_count_my_dhry;  
    *((volatile unsigned *)CONFREG_CR0) = total_count_my_dhry;  
    *((volatile unsigned *)CONFREG_CR1) = total_count_dhry;  
	printf("dhrystone: Total Count(SoC count) = 0x%x\n", total_count_dhry);
	printf("dhrystone: Total Count(CPU count) = 0x%x\n", total_count_my_dhry);

    return;
}
