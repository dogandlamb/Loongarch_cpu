.PHONY: clean
IVERILOG_DIR = project/loongson.sim/sim_1/behav/iverilog

# myCPU 已按 frontend/backend/common/top 分层，需收集子目录下全部 .v（不能只写 myCPU/*.v）
MYCPU_ROOT   = ../../../myCPU
# iverilog 的 -I：相对 testbench 目录；加引号避免 Windows 下盘符被误解析
MYCPU_INC    = $(MYCPU_ROOT)/common
# 若以后再嵌套到第四层目录，可追加：$(wildcard $(MYCPU_ROOT)/*/*/*/*.v)
MYCPU_SRCS  := $(wildcard $(MYCPU_ROOT)/*.v) \
               $(wildcard $(MYCPU_ROOT)/*/*.v) \
               $(wildcard $(MYCPU_ROOT)/*/*/*.v)

# Windows 下命令行不展开 ../rtl/*/*.v，由 make 的 wildcard 收集
RTL_SRCS    := $(wildcard ../rtl/*.v) $(wildcard ../rtl/*/*.v)

# Windows 下 mingw32-make 常用 cmd 作 shell，mkdir -p 无效；用 cmd 递归建目录（不依赖 powershell 在 PATH）
ifeq ($(OS),Windows_NT)
  MKDIR_P = cmd /c "if not exist $(subst /,\,$(IVERILOG_DIR)) mkdir $(subst /,\,$(IVERILOG_DIR))"
else
  MKDIR_P = mkdir -p $(IVERILOG_DIR)
endif

iverilog : $(IVERILOG_DIR)/gettrace
	cd $(IVERILOG_DIR) && vvp ./gettrace

$(IVERILOG_DIR)/gettrace:
	$(MKDIR_P)
	iverilog -Wall -I "$(MYCPU_INC)" -o $(IVERILOG_DIR)/gettrace $(MYCPU_SRCS) $(RTL_SRCS) sync_ram.v mycpu_tb.v

clean :
	rm -rf ./project
