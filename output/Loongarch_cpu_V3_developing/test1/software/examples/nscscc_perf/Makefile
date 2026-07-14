AFLAGS = -O2 -fno-pic -fno-builtin -I. -g
AFLAGS+=-Dhas_cache=1 -Dcache_index_depth=0x100 -Dcache_offset_width=0x4 -Dcache_way=2

export CROSS_COMPILE ?= loongarch32r-linux-gnusf-

COMMON_DIR = ../../bsp
GCC_DIR=../../../toolchains/loongson-gnu-toolchain-8.3-x86_64-loongarch32r-linux-gnusf-v2.0
PICOLIBC_DIR=../../../toolchains/picolibc
LINKER_SCRIPT := $(COMMON_DIR)/env/separate.lds

#若使用 newlib , 将下面的 -lsemihost 替换为 -lgloss
LDFLAGS +=  	-T $(LINKER_SCRIPT) \
				-Wl,--gc-sections -Wl,--check-sections \
				-lc -lm -lg -lsemihost -lgcc -L$(PICOLIBC_DIR)/lib

CFLAGS += -ffunction-sections -fdata-sections
CFLAGS += -nostartfiles -nostdlib -nostdinc -static -g
CFLAGS += -DCLOCKS_PER_SEC=CORE_CLOCKS_PER_SEC -D_CLOCKS_PER_SEC_=CORE_CLOCKS_PER_SEC -DCPU_COUNT_PER_US=100

INCLUDES += -I$(COMMON_DIR)/include \
			-I$(PICOLIBC_DIR)/include \
			-I$(GCC_DIR)/lib/gcc/loongarch32r-linux-gnusf/8.3.0/include \
			-I$(GCC_DIR)/lib/gcc/loongarch32r-linux-gnusf/8.3.0/include-fixed

OBJDIR = obj
ALLBENCH.a  = bench/bitcount/bitcount.a
ALLBENCH.a += bench/bubble_sort/bubble_sort.a
ALLBENCH.a += bench/coremark/coremark.a
ALLBENCH.a += bench/crc32/crc32.a
ALLBENCH.a += bench/dhrystone/dhrystone.a
ALLBENCH.a += bench/quick_sort/quick_sort.a
ALLBENCH.a += bench/select_sort/select_sort.a
ALLBENCH.a += bench/sha/sha.a
ALLBENCH.a += bench/stream_copy/stream_copy.a
ALLBENCH.a += bench/stringsearch/stringsearch.a
ALLBENCH.a += bench/fireye_A0/fireye_A0.a
ALLBENCH.a += bench/fireye_B2/fireye_B2.a
ALLBENCH.a += bench/fireye_C0/fireye_C0.a
ALLBENCH.a += bench/fireye_D1/fireye_D1.a
ALLBENCH.a += bench/fireye_I2/fireye_I2.a
ALLBENCH.a += bench/inner_product/inner_product.a
ALLBENCH.a += bench/lookup_table/lookup_table.a
ALLBENCH.a += bench/loop_induction/loop_induction.a
ALLBENCH.a += bench/my_memcmp/my_memcmp.a
ALLBENCH.a += bench/minmax_sequence/minmax_sequence.a

all: 
	make bitcount
	make bubble_sort
	make coremark
	make crc32
	make dhrystone
	make quick_sort
	make select_sort
	make sha
	make stream_copy
	make stringsearch
	make fireye_A0
	make fireye_B2
	make fireye_C0
	make fireye_D1
	make fireye_I2
	make inner_product
	make lookup_table
	make loop_induction
	make my_memcmp
	make minmax_sequence
	make allbench


bitcount: AFLAGS+=-DCMP_FUNC=1
bitcount: start.o
	$(eval export BENCH = $@)
	@echo $(AFLAGS)
	make target_bench

bubble_sort: AFLAGS+=-DCMP_FUNC=2
bubble_sort: start.o
	$(eval export BENCH = $@)
	@echo $(AFLAGS)
	make target_bench

coremark: AFLAGS+=-DCMP_FUNC=3
coremark: start.o
	$(eval export BENCH = $@)
	@echo $(AFLAGS)
	make target_bench

crc32: AFLAGS+=-DCMP_FUNC=4
crc32: start.o
	$(eval export BENCH = $@)
	@echo $(AFLAGS)
	make target_bench

dhrystone: AFLAGS+=-DCMP_FUNC=5
dhrystone: start.o
	$(eval export BENCH = $@)
	@echo $(AFLAGS)
	make target_bench

quick_sort: AFLAGS+=-DCMP_FUNC=6
quick_sort: start.o
	$(eval export BENCH = $@)
	@echo $(AFLAGS)
	make target_bench

select_sort: AFLAGS+=-DCMP_FUNC=7
select_sort: start.o
	$(eval export BENCH = $@)
	@echo $(AFLAGS)
	make target_bench

sha: AFLAGS+=-DCMP_FUNC=8
sha: start.o
	$(eval export BENCH = $@)
	@echo $(AFLAGS)
	make target_bench

stream_copy: AFLAGS+=-DCMP_FUNC=9
stream_copy: start.o
	$(eval export BENCH = $@)
	@echo $(AFLAGS)
	make target_bench

stringsearch: AFLAGS+=-DCMP_FUNC=10
stringsearch: start.o
	$(eval export BENCH = $@)
	@echo $(AFLAGS)
	make target_bench

fireye_A0: AFLAGS+=-DCMP_FUNC=11
fireye_A0: start.o
	$(eval export BENCH = $@)
	@echo $(AFLAGS)
	make target_bench

fireye_B2: AFLAGS+=-DCMP_FUNC=12
fireye_B2: start.o
	$(eval export BENCH = $@)
	@echo $(AFLAGS)
	make target_bench

fireye_C0: AFLAGS+=-DCMP_FUNC=13
fireye_C0: start.o
	$(eval export BENCH = $@)
	@echo $(AFLAGS)
	make target_bench

fireye_D1: AFLAGS+=-DCMP_FUNC=14
fireye_D1: start.o
	$(eval export BENCH = $@)
	@echo $(AFLAGS)
	make target_bench

fireye_I2: AFLAGS+=-DCMP_FUNC=15
fireye_I2: start.o
	$(eval export BENCH = $@)
	@echo $(AFLAGS)
	make target_bench

inner_product: AFLAGS+=-DCMP_FUNC=16
inner_product: start.o
	$(eval export BENCH = $@)
	@echo $(AFLAGS)
	make target_bench

lookup_table: AFLAGS+=-DCMP_FUNC=17
lookup_table: start.o
	$(eval export BENCH = $@)
	@echo $(AFLAGS)
	make target_bench

loop_induction: AFLAGS+=-DCMP_FUNC=18
loop_induction: start.o
	$(eval export BENCH = $@)
	@echo $(AFLAGS)
	make target_bench

my_memcmp: AFLAGS+=-DCMP_FUNC=19
my_memcmp: start.o
	$(eval export BENCH = $@)
	@echo $(AFLAGS)
	make target_bench

minmax_sequence: AFLAGS+=-DCMP_FUNC=20
minmax_sequence: start.o
	$(eval export BENCH = $@)
	@echo $(AFLAGS)
	make target_bench

allbench: AFLAGS+=-DCMP_FUNC=0
allbench: start.o
	$(eval export BENCH_DIR = $@)
	$(eval export BENCH_LIB = $(ALLBENCH.a))
	make -C bench/bitcount
	make -C bench/bubble_sort
	make -C bench/coremark
	make -C bench/crc32
	make -C bench/dhrystone
	make -C bench/quick_sort
	make -C bench/select_sort
	make -C bench/sha
	make -C bench/stream_copy
	make -C bench/stringsearch
	make -C bench/fireye_A0
	make -C bench/fireye_B2
	make -C bench/fireye_C0
	make -C bench/fireye_D1
	make -C bench/fireye_I2
	make -C bench/inner_product
	make -C bench/lookup_table
	make -C bench/loop_induction
	make -C bench/my_memcmp
	make -C bench/minmax_sequence
	mkdir -p $(OBJDIR)/allbench
	make generate

target_bench:
	$(eval export BENCH_DIR = $(BENCH))
	$(eval export BENCH_LIB = bench/$(BENCH)/$(BENCH).a)
	make -C bench/$(BENCH_DIR)
	mkdir -p $(OBJDIR)/$(BENCH_DIR)
	make generate

generate: inst_data.bin convert
	./convert inst_data.bin $(OBJDIR)/$(BENCH_DIR)/
	rm start.o

inst_data.bin: main.elf
	${CROSS_COMPILE}objcopy -O binary $(OBJDIR)/$(BENCH_DIR)/$< $(OBJDIR)/$(BENCH_DIR)/$@ 

main.elf: start.o confreg_time.o global_var.o
	${CROSS_COMPILE}gcc $(CFLAGS) -g start.o confreg_time.o global_var.o $(BENCH_LIB) -o $(OBJDIR)/$(BENCH_DIR)/$@ $(LDFLAGS)
	${CROSS_COMPILE}objdump --disassemble-all -S $(OBJDIR)/$(BENCH_DIR)/$@ > $(OBJDIR)/$(BENCH_DIR)/test.s

start.o: start.S
	${CROSS_COMPILE}gcc $(AFLAGS) $(INCLUDES) -c $< -nostdinc -nostdlib

confreg_time.o: $(COMMON_DIR)/drivers/confreg_time.c
	${CROSS_COMPILE}gcc $(CFLAGS) $(INCLUDES) -c -o $@ $<

global_var.o: global_var.c
	${CROSS_COMPILE}gcc -c -o $@ $<

convert: convert.c
	gcc -o convert convert.c
clean:
	rm -f *.o *.bin *.elf *.a testbin *.s *.vlog *.coe *.data *.mif bin.lds convert
	rm -rf obj
	make -C bench clean
reset:
	make clean
	rm -f bin.lds convert

help:
	@echo "################################################################"
	@echo "### help for compiling memory game"
	@echo "################################################################"
	@echo "### options:"
	@echo "###     make      : get compiled result, which is saved in ./obj"
	@echo "###     make clean: remove *.o, *.a, and ./obj"
	@echo "###     make reset: "make clean" and remove convert, bin.lds"
	@echo "###     make help : show help information"
	@echo "###############################################################"
#-include rules.make
