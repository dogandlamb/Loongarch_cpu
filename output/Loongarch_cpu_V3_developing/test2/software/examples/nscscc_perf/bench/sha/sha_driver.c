/* NIST Secure Hash Algorithm */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include "sha.h"

unsigned long start_count_sha = 0;
unsigned long stop_count_sha = 0;
unsigned long total_count_sha = 0;

unsigned long start_count_my_sha = 0;
unsigned long stop_count_my_sha  = 0;
unsigned long total_count_my_sha = 0;

int sha_driver(char *str)
{
    str_FILE *fin;
    SHA_INFO sha_info;

	fin = str_fopen(str);
	
	start_count_sha = get_count();
    start_count_my_sha = get_count_my();
	sha_stream(&sha_info, fin);
	stop_count_my_sha  = get_count_my();
    stop_count_sha     = get_count();
    total_count_sha    += (stop_count_sha - start_count_sha);
    total_count_my_sha += (stop_count_my_sha - start_count_my_sha);

	sha_print(&sha_info);
	LONG ans[5] = {437358104, 2057077515, 2988414705, 3742976831, 2079096471};
	str_fclose(fin);
	int i;
	int r = 0;
	for(i=0;i<5;i++){
		printf("%lu : %lu\n", sha_info.digest[i], ans[i]);
		if(sha_info.digest[i] != ans[i]){
			r = 1;
			break;
		}
	}
	return r;
}
