/***************************************************************************************
* Copyright (c) 2020-2023 Institute of Computing Technology, Chinese Academy of Sciences
* Copyright (c) 2020-2021 Peng Cheng Laboratory
*
* DiffTest is licensed under Mulan PSL v2.
* You can use this software according to the terms and conditions of the Mulan PSL v2.
* You may obtain a copy of Mulan PSL v2 at:
*          http://license.coscl.org.cn/MulanPSL2
*
* THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
* EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
* MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
*
* See the Mulan PSL v2 for more details.
***************************************************************************************/

#ifndef __LIGHTSSS_H
#define __LIGHTSSS_H
#include "common.h"
#include <deque>
#include <list>
#include <signal.h>
#include <unistd.h>
#include <sys/wait.h>
#include <ctime>
#include <cstdlib>

// Platform detection
#ifdef __linux__
    #include <sys/ipc.h>
    #include <sys/shm.h>
    #include <sys/prctl.h>
    #define USE_SYSV_SHM 1
#elif defined(__APPLE__) && defined(__MACH__)
    #include <sys/mman.h>
    #include <fcntl.h>
    #include <errno.h>
    #define USE_POSIX_SHM 1
#else
    #error "Unsupported platform"
#endif

// Constants
#ifndef WAIT_INTERVAL
#define WAIT_INTERVAL 1  // seconds to wait in shwait()
#endif

#ifndef SLOT_SIZE
#define SLOT_SIZE 10     // maximum number of checkpoint processes
#endif

// exit when error when fork
#define FAIL_EXIT exit(EXIT_FAILURE);

typedef struct shinfo {
    bool flag;
    bool notgood;
    uint64_t endCycles;
    pid_t oldest;
} shinfo;

class ForkShareMemory {
private:
#ifdef USE_SYSV_SHM
    key_t key_n;
    int shm_id;
#elif defined(USE_POSIX_SHM)
    int shm_fd;
    char shm_name[256];
#endif
    
public:
    shinfo *info;
    ForkShareMemory();
    ~ForkShareMemory();
    void shwait();
};

const int FORK_OK = 0;
const int FORK_ERROR = 1;
const int FORK_CHILD = 2;

class LightSSS {
    pid_t pid = -1;
    int slotCnt = 0;
    int waitProcess = 0;
    // front() is the newest. back() is the oldest.
    std::deque<pid_t> pidSlot = {};
    ForkShareMemory forkshm;
    
public:
    int do_fork();
    int wakeup_child(uint64_t cycles);
    bool is_child();
    int do_clear();
    uint64_t get_end_cycles() {
        return forkshm.info->endCycles;
    }
    
private:
    // Platform-specific process naming (replaces prctl functionality)
    void set_process_name(const char* name);
};

#define FORK_PRINTF(format, args...) \
    do { \
        fprintf(stdout,"[FORK_INFO pid(%d)] " format, getpid(), ##args); \
        fflush(stdout); \
    } while (0);

#endif