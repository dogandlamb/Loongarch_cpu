#ifndef _CONFREG_TIME_H_H
#define _CONFREG_TIME_H_H
#include <time.h>

extern unsigned long CONFREG_TIMER_BASE;
extern unsigned long CONFREG_CLOCKS_PER_SEC;
extern unsigned long CORE_CLOCKS_PER_SEC;

#define MSEC_PER_SEC 1000L
#define USEC_PER_MSEC 1000L
#define NSEC_PER_USEC 1000L
#define NSEC_PER_MSCEC 1000000L
#define USEC_PER_SEC 1000000L
#define NSEC_PER_SEC 1000000000L
#define FSEC_PER_SEC 1000000000000000LL

struct my_timespec{
	unsigned long tv_sec;
	unsigned long tv_nsec;
	unsigned long tv_usec;
	unsigned long tv_msec;
};

unsigned long get_cpu_clock_count();//获取处理器核统计的时钟周期数
unsigned long get_confreg_clock_count();//获取CONFREG的时钟周期数
unsigned long get_clock_count();//根据是否存在宏 USE_CPU_CLOCK_COUNT 输出 处理器核/CONFREG 的计数器值
unsigned long get_ns(void);//获取统计的纳秒数
unsigned long get_us(void);//获取统计的微秒数
unsigned long get_count(void);
unsigned long get_count_my(void);
unsigned long clock_gettime(struct my_timespec *tmp);

struct str_FILE{
	char* str;
	size_t pos;
};
typedef struct str_FILE str_FILE;

str_FILE* str_fopen(char* str);
size_t str_fread(void* ptr, size_t size, size_t nmemb, str_FILE* stream);
void str_fclose(str_FILE* stream);
char *str_fgets(char *s, int size, str_FILE *stream);
int str_getc(str_FILE* stream);

#endif
