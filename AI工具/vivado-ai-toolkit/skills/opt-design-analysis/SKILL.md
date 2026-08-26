---
name: opt-design-analysis
description: >
  分析 Vivado opt_design 日志，提供优化建议。
  支持所有 Vivado 版本。
---

# 设计优化分析 (opt_design Analysis)

## 适用版本
- Vivado 2019.2+：所有版本均支持

## 执行步骤

### 1. 运行 opt_design（如果尚未运行）
```tcl
opt_design -verbose
```

### 2. 收集日志
从 Vivado 日志中提取：
```tcl
report_utilization
report_timing_summary
```

### 3. 分析关键指标
- **LUT/FF 利用率**：是否超过 80%
- **WNS**：是否满足时序要求
- **控制集数量**：是否过多（> 目标器件容量 50%）

### 4. 优化建议
根据分析结果，推荐：
- `opt_design -directive Explore`：探索更多优化
- `opt_design -directive AggressiveExplore`：激进优化
- `phys_opt_design`：物理优化
- 约束调整建议
