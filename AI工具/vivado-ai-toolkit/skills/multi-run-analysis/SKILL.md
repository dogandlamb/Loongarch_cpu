---
name: multi-run-analysis
description: >
  比较多个 Vivado 实现运行的结果（时序、利用率、DRC、功耗），
  生成 QoR 排名表并推荐最佳策略。
  支持 Vivado 2019.2+。
---

# 多轮实现分析 (Multi-Run Analysis)

## 适用版本
- Vivado 2023.2+：时序摘要格式兼容
- Vivado 2019.2-2023.1：部分报告格式可能不同

## 执行步骤

### 1. 列出所有实现运行
```tcl
get_runs -filter {IS_IMPLEMENTATION}
```

### 2. 收集每轮的指标
对每轮运行收集：
```tcl
# 时序
report_timing_summary -file <run>/timing_summary.rpt
# 利用率
report_utilization -file <run>/utilization.rpt
# DRC
report_drc -file <run>/drc.rpt
# 功耗
report_power -file <run>/power.rpt
```

### 3. 生成比较表
按以下维度排名：
- **WNS**（越高越好）
- **TNS**（越接近 0 越好）
- **LUT 利用率**（越低越好）
- **功耗**（越低越好）

### 4. 推荐
- 🥇 最佳综合策略
- 🥈 最佳实现策略
- ⚠️ 异常值标记
