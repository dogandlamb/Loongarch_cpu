#include <stdio.h> 
#include <stdlib.h>
#include <stdarg.h>
#include <string.h>
#include <stdint.h>
#include <time.h>

//BSP板级支持包所需全局变量
unsigned long UART_BASE = 0xbfe001e0;					//UART16550的虚地址
unsigned long CONFREG_UART_BASE = 0xbfafff10;			//CONFREG模拟UART的虚地址
unsigned long CONFREG_TIMER_BASE = 0xbfafe000;			//CONFREG计数器的虚地址
unsigned long CONFREG_CLOCKS_PER_SEC = 100000000L;		//CONFREG时钟频率
unsigned long CORE_CLOCKS_PER_SEC = 33000000L;			//处理器核时钟频率

int inst_lmadd(uint32_t addr1, uint32_t addr2, uint32_t waddr, uint32_t size) {
	int res;
	asm volatile (
		"move $r5, %[addr1]\n\t"
		"move $r6, %[addr2]\n\t"
		"move $r8, %[size]\n\t"
		"move $r9, %[waddr]\n\t"
		".word 0xc0402500\n\t"
		".word 0xc00018a7\n\t"
		"move %[res], $r7\n\t"
		:[res]"=r"(res):[addr1]"r"(addr1),[addr2]"r"(addr2), [size]"r"(size), [waddr]"r"(waddr)
	);
	return res;
}

const int TEST_NUM = 128;

int main(int argc, char** argv)
{
	srand(time(0));
	uint32_t a[TEST_NUM];
	uint32_t b[TEST_NUM];
	uint32_t golden_buf[TEST_NUM];
	uint32_t buf[TEST_NUM];
	uint32_t res = 0;
	uint32_t golden_res = 0;
	for (int i = 0; i < TEST_NUM; i++) {
		a[i] = rand();
		b[i] = rand();
	}
	uint32_t begin_time, end_time;

	begin_time = clock();
	for (int i = 0; i < TEST_NUM; i++) {
		uint32_t tmp = a[i] + b[i];
		golden_res += tmp;
		golden_buf[i] = tmp;

	}
	end_time = clock();
	uint32_t normal_time = end_time - begin_time;

	uint32_t size = 64;
	begin_time = clock();
	for (int i = 0; i < TEST_NUM; i += size) {
		res += inst_lmadd((uint32_t)&a[i], (uint32_t)&b[i], (uint32_t)&buf[i], size);
	}
	end_time = clock();

	for (int i = 0; i< TEST_NUM; i++) {
		if(buf[i] != golden_buf[i]) {
			printf("Error at index %d: golden_buf = %u, buf = %u\n", i, golden_buf[i], buf[i]);
			return -1;
		}
	}

	if (golden_res != res) {
		printf("Error: golden_res = %u, res = %u\n", golden_res, res);
		return -1;
	}

	printf("Normal time: %u clocks, LMADD time: %u clocks\n", normal_time, end_time - begin_time);
	return 0;
}