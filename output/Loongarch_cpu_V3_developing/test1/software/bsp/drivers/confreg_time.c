#include "confreg_time.h"
#include "time.h"
#include <string.h>
#include <stdio.h>

unsigned long __attribute__((weak)) CONFREG_TIMER_BASE = 0xbfafe000;
unsigned long __attribute__((weak)) CONFREG_CLOCKS_PER_SEC = 100000000L;
unsigned long __attribute__((weak)) CORE_CLOCKS_PER_SEC = 33000000L;

unsigned long get_confreg_clock_count()
{
    unsigned long contval;
    asm volatile(
        "la.local $r25, CONFREG_TIMER_BASE\n\t"
        "ld.w $r25, $r25, 0\n\t"
        "ld.w %0,$r25,0\n\t"
        :"=r"(contval)
        :
        :"$r25"
    );
    return  contval;
}

unsigned long get_cpu_clock_count()
{
    unsigned long contval;
    asm volatile(
        "rdcntvl.w %0\n\t"
        :"=r"(contval)
    );
    return  contval;
}

unsigned long get_clock_count()
{
#ifdef USE_CPU_CLOCK_COUNT
    return  get_cpu_clock_count();
#else
    return get_confreg_clock_count();
#endif
}

unsigned long get_ns(void)
{
    unsigned long n=0;
    n = get_clock_count();
#ifdef USE_CPU_CLOCK_COUNT
    n=n*(NSEC_PER_USEC/(CORE_CLOCKS_PER_SEC/USEC_PER_SEC));
#else
    n=n*(NSEC_PER_USEC/(CONFREG_CLOCKS_PER_SEC/USEC_PER_SEC));
#endif
    return n;
}

unsigned long get_us(void)
{
    unsigned long n=0;
    n = get_clock_count();
#ifdef USE_CPU_CLOCK_COUNT
    n=n/(CORE_CLOCKS_PER_SEC/USEC_PER_SEC);
#else
    n=n/(CONFREG_CLOCKS_PER_SEC/USEC_PER_SEC);
#endif
    return n;
}

unsigned long get_count(void)
{
    return get_confreg_clock_count();
}

unsigned long get_count_my(void)
{
    return  get_cpu_clock_count();
}

unsigned long clock_gettime(struct my_timespec *tmp)
{
    unsigned long n = 0;
    n = get_cpu_clock_count();
    tmp->tv_nsec = n*(NSEC_PER_USEC/CPU_COUNT_PER_US)%NSEC_PER_USEC;
    tmp->tv_usec = (n/CPU_COUNT_PER_US)%USEC_PER_MSEC;
    tmp->tv_msec = (n/CPU_COUNT_PER_US/USEC_PER_MSEC)%MSEC_PER_SEC;
    tmp->tv_sec  = n/CPU_COUNT_PER_US/NSEC_PER_SEC;
    //printf("clock ns=%d,sec=%d\n",tmp->tv_nsec,tmp->tv_sec);
    return 0;
}

#define SIZE 10
str_FILE files[SIZE] = {0};

str_FILE* str_fopen(char* str){
	int i;
	for(i=0;i<SIZE;i++){
		if(files[i].str == NULL){
			break;
		}
	}
	files[i].str = str;
	files[i].pos = 0;
	return &files[i];
}

size_t str_fread(void* ptr, size_t size, size_t nmemb, str_FILE* stream){
	char* out = (char*)ptr;
	char* str = stream->str;
	size_t total = strlen(str);
	if(stream->pos == total){
		return 0;
	}
	size_t c = 0;
	for(c=0;c<size*nmemb; ){
		out[c++] = str[stream->pos++];
		if(stream->pos == total){
			break;
		}
	}
	return c;
}

void str_fclose(str_FILE* stream){
	int i;
	for(i=0;i<SIZE;i++){
		if(&files[i] == stream){
			break;
		}
	}
	stream->str = NULL;
	stream->pos = 0;
}

char *str_fgets(char *s, int size, str_FILE *stream){
	char* str = stream->str;
	size_t total = strlen(str);
	size_t c = 0;
	char* r = NULL;
	while(stream->pos != total){
		if(str[stream->pos] == '\n'){
			s[c++] = str[stream->pos++];
			break;
		}else{
			s[c++] = str[stream->pos++];
		}
	}
	return r;
}

int str_getc(str_FILE* stream){
	char* str = stream->str;
	size_t total = strlen(str);
	if(stream->pos == total){
		return EOF;
	}else{
		return (unsigned char)str[stream->pos++];
	}
	
}

