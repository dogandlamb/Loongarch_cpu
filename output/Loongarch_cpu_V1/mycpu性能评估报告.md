# myCPU 性能评估报告

> 评估日期：2026-05-09
> 评估对象：`vivado_cpu_origin/myCPU`（5 级有序流水 LoongArch32 单核 + L1 I/D Cache + L2 Cache + AXI4 Master）
> 测试集：`soc_verify/soc_axi` 功能测试集（79 个 Functional Test Point）
> 仿真器：AMD Vivado XSim 2023.2
> 仿真脚本：`soc_verify/soc_axi/run_vivado/project/loongson.sim/sim_1/behav/xsim/{compile,elaborate,simulate}.bat`

---

## 一、评估方法

### 1.1 计数器位置

性能计数器作为**纯被动观测**追加在 `soc_verify/soc_axi/testbench/mycpu_tb.v` 末尾：

- 通过宏 `` `MYCPU = soc_lite.u_cpu`` 层级引用 `mycpu_top` 内部信号；
- 全部计数器为 64 bit reg，复位释放后开始计、`debug_end` 置 1 后停止；
- 不修改任何 RTL，不影响原有 golden trace 比对流程；
- 在 `Test end!` / `----PASS!!!` 之后调用 `print_perf_report` 打印。

### 1.2 关键观测信号（来自 `mycpu_top`）

| 类别 | 信号 | 含义 |
| --- | --- | --- |
| 提交 | `WB_valid` | WB 槽是否非空 |
| 提交 | `wb_valid_2csr` | 真正提交（已剔除 refetch squash） |
| 提交 | `wb_ex_2csr` | 当前提交是异常 |
| 阻塞 | `block_sig` | RAW + CSR RAW 主阻塞 |
| 阻塞 | `raw_block_sig` | 仅 RAW 阻塞 |
| 阻塞 | `csr_raw_stall` | 仅 CSR 写后读阻塞 |
| 阻塞 | `tlb_inst_stall` | TLBSRCH/TLBRD 引发的 ID 阻塞 |
| 冲刷 | `cancel_sig` | 分支冲刷或 csr_flush 相或 |
| 冲刷 | `csr_flush_pipeline` | 异常 / ERTN 冲刷 |
| 冲刷 | `wb_refetch_tag_to_npc` | WB cache 维护后的 refetch |
| 各级 | `IF/ID/EXE/MEM_valid` 与 `*_readyGo` | 用于推算前后端瓶颈占比 |

### 1.3 IPC 口径选择

- `debug_wb_pc` 在 WB 空泡时仍保留旧值，直接靠它数指令会**误统计**；
- `debug_wb_rf_we` 又会**漏统计** store / branch / syscall 等不写寄存器的指令；
- 因此采用 `wb_valid_2csr` 作为提交信号——这是 RTL 内部 WBport 给 CSR 的"真正提交"事件，与 store/branch 等是否写寄存器无关。

| 指标 | 计算方式 | 用途 |
| --- | --- | --- |
| **Retired insts** | `wb_valid_2csr` 计数 | 含异常提交，最贴近"指令完成" |
| **Committed insts** | `wb_valid_2csr & ~wb_ex_2csr` 计数 | 不含异常，最适合做 IPC |
| **IPC (commit)** | Committed / Cycles | **主推 IPC** |
| **CPI** | Cycles / Committed | IPC 的倒数 |

---

## 二、关键性能指标

### 2.1 吞吐量（Throughput）

| 指标 | 数值 |
| --- | ---: |
| Cycles | **564,086** |
| Retired insts (含异常) | 136,307 |
| Committed insts (不含异常) | **136,185** |
| **IPC (commit / cycle)** | **0.241** |
| IPC (retire / cycle) | 0.241 |
| **CPI (cycle / commit)** | **4.142** |

### 2.2 流水线空泡

| 指标 | 拍数 | 占比 |
| --- | ---: | ---: |
| WB bubble (`!WB_valid`) | 427,779 | **75.83%** |

### 2.3 ID 级阻塞（block_sig 系列）

| 指标 | 拍数 | 占比 |
| --- | ---: | ---: |
| `block_sig` (RAW+CSR_RAW) | 2,731 | 0.48% |
| └ pure RAW (`raw_block_sig`) | 2,653 | 0.47% |
| └ `csr_raw_stall` | 78 | 0.01% |
| `tlb_inst_stall` (TLBRD/SRCH) | 423 | 0.07% |

### 2.4 流水线冲刷（Flushes）

| 指标 | 事件数 | 拍数 | 占比 |
| --- | ---: | ---: | ---: |
| 总冲刷 | — | 21,814 | **3.86%** |
| 分支冲刷 (`cancel_sig`) | 20,355 | 21,176 | 3.75% |
| 异常 / ERTN (`csr_flush`) | 248 | 248 | 0.04% |
| WB refetch | 390 | 390 | 0.07% |

> 平均每条分支冲刷 `21,176 / 20,355 ≈ 1.04` 拍，说明 EXE 阶段一确认就 redirect，**分支本身的代价已经很小**；剩下的延迟全在"重定向后等新 PC 取指返回"上。

### 2.5 各级 readyGo 失败拍数

| 指标 | 拍数 | 占比 |
| --- | ---: | ---: |
| **IF stall**（前端 / icache） | **427,830** | **75.84%** |
| MEM stall（dcache / store buf） | 23,140 | 4.10% |

---

## 三、瓶颈分析

### 3.1 关键观察：`WB_bubble% (75.83) ≈ IF_stall% (75.84)`

两个数字几乎完全相等。这意味着：

> **WB 槽空泡 = 前端没把指令送下来**

换句话说，CPU 大部分时间都是"等指令"，而不是"等数据"。前端 fetch 是单点瓶颈。

### 3.2 各类瓶颈相对贡献

```
┌─────────────────────────────────────────────────┐
│   564,086 cycles 总分布（按贡献近似归一化）     │
├─────────────────────────────────────────────────┤
│   IF stall (front-end)        ████████ 75.84%   │
│   Branch flush                 ▍       3.75%    │
│   MEM stall (back-end)         ▌       4.10%    │
│   ID block_sig (RAW + CSR RAW) ▏       0.48%    │
│   tlb_inst_stall               ▏       0.07%    │
│   exception / refetch          ▏       0.11%    │
│   实际有指令提交 (≈ IPC)       ██▎     24.1%    │
└─────────────────────────────────────────────────┘
```

### 3.3 二级根因

前端 fetch 慢主要由两个因素叠加：

1. **ICache miss → AXI line bridge → L2 → AXI RAM** refill 链路延迟。
   当前 L1 ICache：`256 sets × 2 way × 16 B/line = 8 KB`，工作集（功能测试集 ~512 KB 链接体）明显放不下；每次 miss 要走 L2 → axi_ram，refill 一行 ~10+ 拍。

2. **没有分支预测**。
   `npc.v` 是顺序 PC（跳转直到 EXE 阶段才确定）。每条 taken 分支至少烧 1 拍 cancel；更糟的是分支 cancel 之后必须等新目标的 ICache 命中才能继续——这条延迟也算到 IF stall 里，相当于"分支 cancel + ICache miss"双重打击。

### 3.4 其他定性观测

- **数据通路前递做得非常干净**：纯 RAW stall 仅 0.47%，说明 ID/EXE/MEM/WB 的前递路径覆盖良好，load-use 等典型 hazard 没有产生大量冒泡。
- **CSR RAW 78 拍**（0.01%）：少量 CSR 写后读插泡是合理的（CSR 在 WB 写回，EXE 读）。
- **wb refetch 390 次**（0.07%）：cache 维护后的重取指频率不高。
- **异常 / ERTN 248 次**（0.04%）：测试集本身有 syscall / break / INT 等覆盖项，路径正常。
- **MEM stall 4.10%**：DCache 表现尚可，说明数据访存不是主要瓶颈。

---

## 四、优化建议（按预期 IPC 提升排序）

| 优先级 | 优化点 | 预期 IPC 收益 | 实施难度 | 影响指标 |
| :---: | --- | :---: | :---: | --- |
| **P0** | 加 **静态/动态分支预测**（最少做 BTB + 1-bit / 2-bit BHT） | **+50% ~ +100%** | 中 | branch flush ↓↓、IF stall ↓↓ |
| **P1** | **ICache 容量/相联度** 翻倍（256→512 set 或 2→4 way） | **+15% ~ +30%** | 低（加 IP） | IF stall ↓↓ |
| **P2** | **ICache 顺序下一行预取** prefetcher | +10% ~ +20% | 中 | IF stall ↓ |
| **P3** | L2 容量、replacement 策略调优 | +5% ~ +10% | 中 | IF/MEM stall ↓ |
| **P4** | 加 store buffer / 写聚合 | +1% ~ +3% | 中 | MEM stall ↓ |
| ❌ | 优化 RAW / CSR RAW 阻塞 | <1% | — | **不建议优先**（已只占 0.5%） |

### 推荐路线图

> **第一阶段（最大收益）**：在 `npc.v` 加 1-2 KB 的 BTB + 2-bit BHT。即便预测准确率只有 80%，按当前 ~15% 分支密度估计：
>
> - 现在每条分支烧 ~1.04 拍冲刷 + ~5–10 拍 IF stall（等新目标 fetch 返回）；
> - 预测命中后这部分都直接消除；
> - 预期 `IF stall` 从 75.84% 降到 50–60%，对应 **IPC 0.241 → 0.40 量级**。
>
> **第二阶段**：把 ICache 加到 16 KB（512 set × 2 way 或 256 set × 4 way），命中率从估计的 ~85% 提到 ~95%+，**IPC 进一步到 0.5–0.6**。
>
> **第三阶段**：如果还要继续榨，再做 L2 调优、prefetcher 等。

---

## 五、附录

### 5.1 重跑命令

```powershell
cd vivado_cpu_origin\soc_verify\soc_axi\run_vivado\project\loongson.sim\sim_1\behav\xsim
.\compile.bat ; .\elaborate.bat ; .\simulate.bat
# 完整日志在同目录 simulate.log，文件末尾就是 Performance Report
```

### 5.2 提取关键数据（用于对比表）

```powershell
# 简单 grep 关键行
Select-String -Path simulate.log -Pattern "IPC|CPI|stall|flush|bubble|Cycles\s*:|insts" -Context 0,0
```

### 5.3 计数器源码

性能计数器实现位于：

`vivado_cpu_origin/soc_verify/soc_axi/testbench/mycpu_tb.v` 末尾约 280–460 行，结构如下：

1. `wire perf_*` 层级引用（行 ~283–302）
2. `reg [63:0] perf_*_cnt` 计数寄存器（行 ~307–326）
3. 计数 always 块（行 ~328–391）
4. `print_perf_report` task（行 ~396–464）

### 5.4 计数口径备注

- **Cycles**：`resetn` 拉高之后开始计；`debug_end` 置 1（即 `Test end!` 那拍）停。
- **`%` 计算**：以 `Cycles` 为分母。
- **冲刷拍数 vs 事件数**：拍数按高电平统计（连续高若干拍计若干），事件数按上升沿统计；二者比值近似"每次冲刷的代价"。
- **整除精度**：Verilog 整除计算 IPC × 1000 / cycles，保留 3 位小数。

### 5.5 仿真元数据

- 仿真总时长：5,642,895 ns（≈ 5.64 ms）
- 墙钟耗时：约 8 分 02 秒（CPU time 3 分 16 秒，xsim 单线程）
- 内存峰值：xsim 254.281 MB
- `$finish` 调用位置：`mycpu_tb.v:275`

---

## 六、结论

myCPU 当前**功能正确性已 PASS（79 个测试点全过）**，但 IPC 偏低（0.241），距离 5 级有序流水的理论上限 1.0 还有较大空间。

**单点瓶颈非常明确：前端 fetch 占用了 75.84% 的总周期**，与 WB 槽空泡占比几乎完全吻合。继续优化 ID 级阻塞（RAW、CSR RAW、tlb stall 等）已无意义——这些项加起来只有 0.5%。

**最高优先级是分支预测 + ICache 升级**，预期能把 IPC 推到 0.5–0.6 量级；这两项搞定之前，做其他微观优化都收益甚微。
