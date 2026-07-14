#include "lightsss.h"
#include <cstring>
#include <cstdio>
#include <cstdlib>

ForkShareMemory::ForkShareMemory() {
#ifdef USE_SYSV_SHM
  // Linux: Use System V shared memory
  if ((key_n = ftok(".", 's')) < 0) {
    perror("Fail to ftok\n");
    FAIL_EXIT
  }
  if ((shm_id = shmget(key_n, 1024, 0666 | IPC_CREAT)) == -1) {
    perror("shmget failed...\n");
    FAIL_EXIT
  }
  void *ret = shmat(shm_id, NULL, 0);
  if (ret == (void *)-1) {
    perror("shmat failed...\n");
    FAIL_EXIT
  } else {
    info = (shinfo *)ret;
  }
#elif defined(USE_POSIX_SHM)
  // macOS: Use POSIX shared memory
  // Generate consistent name across all processes
  snprintf(shm_name, sizeof(shm_name), "/lightsss_shm_%d", 
           getenv("LIGHTSSS_MASTER_PID") ? atoi(getenv("LIGHTSSS_MASTER_PID")) : getpid());
  
  // Set environment variable for child processes if not already set
  if (!getenv("LIGHTSSS_MASTER_PID")) {
    char master_pid_str[32];
    sprintf(master_pid_str, "%d", getpid());
    setenv("LIGHTSSS_MASTER_PID", master_pid_str, 1);
  }
  
  bool is_creator = false;
  // Try to open existing shared memory first
  shm_fd = shm_open(shm_name, O_RDWR, 0666);
  if (shm_fd == -1) {
    // Create new shared memory object if it doesn't exist
    shm_fd = shm_open(shm_name, O_CREAT | O_RDWR, 0666);
    if (shm_fd == -1) {
      perror("shm_open failed...\n");
      FAIL_EXIT
    }
    is_creator = true;
    
    // Set size only if we created it
    if (ftruncate(shm_fd, 1024) == -1) {
      perror("ftruncate failed...\n");
      close(shm_fd);
      shm_unlink(shm_name);
      FAIL_EXIT
    }
  }
  
  // Map shared memory
  void *ret = mmap(NULL, 1024, PROT_READ | PROT_WRITE, MAP_SHARED, shm_fd, 0);
  if (ret == MAP_FAILED) {
    perror("mmap failed...\n");
    close(shm_fd);
    shm_unlink(shm_name);
    FAIL_EXIT
  } else {
    info = (shinfo *)ret;
  }
  
  // Initialize shared memory only if we created it (first process)
  if (is_creator) {
    info->flag = false;
    info->notgood = false;
    info->endCycles = 0;
    info->oldest = 0;
  }
#endif
}

ForkShareMemory::~ForkShareMemory() {
#ifdef USE_SYSV_SHM
  if (shmdt(info) == -1) {
    perror("detach error\n");
  }
  shmctl(shm_id, IPC_RMID, NULL);
#elif defined(USE_POSIX_SHM)
  // macOS cleanup
  if (munmap(info, 1024) == -1) {
    perror("munmap failed\n");
  }
  close(shm_fd);
  
  char master_pid_str[32];
  sprintf(master_pid_str, "%d", getpid());
  if (getenv("LIGHTSSS_MASTER_PID") && 
      strcmp(getenv("LIGHTSSS_MASTER_PID"), master_pid_str) == 0) {
    shm_unlink(shm_name);
    unsetenv("LIGHTSSS_MASTER_PID");
  }
#endif
}

void ForkShareMemory::shwait() {
  while (true) {
    if (info->flag) {
      if (info->notgood)
        break;
      else
        exit(0);
    } else {
      sleep(WAIT_INTERVAL);
    }
  }
}

int LightSSS::do_fork() {
  //kill the oldest blocked checkpoint process
  if (slotCnt == SLOT_SIZE) {
    pid_t temp = pidSlot.back();
    pidSlot.pop_back();
    kill(temp, SIGKILL);
    int status = 0;
    waitpid(temp, NULL, 0);
    slotCnt--;
  }
  // fork a new checkpoint process and block it
  if ((pid = fork()) < 0) {
    printf("[%d]Error: could not fork process!\n", getpid());
    return FORK_ERROR;
  }
  // the original process
  else if (pid != 0) {
    slotCnt++;
    pidSlot.push_front(pid);
    return FORK_OK;
  }
  // for the fork child
  waitProcess = 1;
  set_process_name("lightsss_child");
  forkshm.shwait();
  //checkpoint process wakes up
  //start wave dumping
  if (forkshm.info->oldest != getpid()) {
    FORK_PRINTF("Error, non-oldest process should not live. Parent Process should kill the process manually.\n")
    return FORK_ERROR;
  }
  return FORK_CHILD;
}

int LightSSS::wakeup_child(uint64_t cycles) {
  forkshm.info->endCycles = cycles;
  forkshm.info->oldest = pidSlot.back();

  // only the oldest is wantted, so kill others by parent process.
  for (auto pid: pidSlot) {
    if (pid != forkshm.info->oldest) {
      kill(pid, SIGKILL);
      waitpid(pid, NULL, 0);
    }
  }
  // flush before wake up child.
  fflush(stdout);
  fflush(stderr);

  forkshm.info->notgood = true;
  forkshm.info->flag = true;
  int status = -1;
  waitpid(pidSlot.back(), &status, 0);
  return 0;
}

bool LightSSS::is_child() {
  return waitProcess;
}

int LightSSS::do_clear() {
  FORK_PRINTF("clear processes...\n")
  while (!pidSlot.empty()) {
    pid_t temp = pidSlot.back();
    pidSlot.pop_back();
    kill(temp, SIGKILL);
    waitpid(temp, NULL, 0);
    slotCnt--;
  }
  return 0;
}

void LightSSS::set_process_name(const char* name) {
#ifdef __linux__
  // Linux: Use prctl
  if (prctl(PR_SET_NAME, name, 0, 0, 0) == -1) {
    perror("prctl PR_SET_NAME failed");
  }
#elif defined(__APPLE__) && defined(__MACH__)
  // macOS: Use setprogname or modify argv[0]
  static char process_name[256];
  strncpy(process_name, name, sizeof(process_name) - 1);
  process_name[sizeof(process_name) - 1] = '\0';
  
  // Note: On macOS, changing process name visible in ps/top is more complex
  // and might require modifying the original argv[0] passed to main()
#endif
}