CFLAGS = -O3 -funroll-all-loops -falign-jumps=16 -falign-functions=16 -fgcse-sm -fgcse-las -finline-functions -finline-limit=1000 -msoft-float 
FLAGS_STR := $(CFLAGS)
CFLAGS += -DFLAGS_STR=\""$(FLAGS_STR)"\"
CFLAGS += -G8 -DTIME -DCOREMARK_LOOP=1 -fno-builtin -g

COMMON_DIR = ../../bsp
GCC_DIR=../../../toolchains/loongson-gnu-toolchain-8.3-x86_64-loongarch32r-linux-gnusf-v2.0
PICOLIBC_DIR=../../../toolchains/picolibc

INCLUDES += -I. \
			-I../../ \
			-I../../$(COMMON_DIR)/include \
			-I../../$(PICOLIBC_DIR)/include \
			-I../../$(GCC_DIR)/lib/gcc/loongarch32r-linux-gnusf/8.3.0/include \
			-I../../$(GCC_DIR)/lib/gcc/loongarch32r-linux-gnusf/8.3.0/include-fixed

all: $(patsubst %.c, %.o, $(wildcard *.c))
	$(CROSS_COMPILE)ar -cr coremark.a $^ 

%.o: %.c
	$(CROSS_COMPILE)gcc $(CFLAGS) $(INCLUDES) -c $<

clean:
	rm -f *.o
	rm -f *.a
