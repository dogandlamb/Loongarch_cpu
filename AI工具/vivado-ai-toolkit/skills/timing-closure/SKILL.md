---
name: timing-closure
description: >
  分析 Vivado 布线后设计、分类时序违规、生成修复约束、重新运行实现并验证结果。
  最多迭代 3 次直到时序收敛。当用户要求修复时序违规、达到目标频率（如100MHz）、
  或 WNS ≥ 0 时触发。支持 Vivado 2019.2+。
---

# 时序收敛 (Timing Closure)

三阶段迭代流程，通过 Vivado MCP 工具执行。

## 适用版本
- Vivado 2019.2 到 2025.x 均可使用
- 此技能使用 `vivado_execute` MCP 工具与 Vivado 交互

```
进度：
- [ ] 阶段 1：分析布线后设计
- [ ] 阶段 2：生成 timing_fixes.xdc
- [ ] 阶段 3：重新运行实现并验证
```

---

## 阶段 1 — 分析

### 1.1 打开设计
```tcl
# 项目模式
open_run impl_1
# 或非项目模式
# open_checkpoint <routed.dcp 路径>
```

### 1.2 获取基线指标
```tcl
set baseline_wns  [get_property SLACK [get_timing_paths -max_paths 1]]
set paths_neg [get_timing_paths -max_paths 1000 -slack_lesser_than 0]
set baseline_fail [llength $paths_neg]
set baseline_tns 0.0
foreach p $paths_neg {
    set baseline_tns [expr {$baseline_tns + [get_property SLACK $p]}]
}
```

如果 `baseline_wns >= 0` → 报告"无时序违规"，停止。

### 1.3 报告收集
```tcl
report_timing_summary -file timing_summary.rpt
report_timing -max_paths 100 -slack_lesser_than 0 -file worst_paths.rpt
report_clock_interaction -file clock_interaction.rpt
report_high_fanout_nets -fanout_greater_than 100 -file high_fanout.rpt
```

### 1.4 分类违规路径

分析每条违规路径，归入以下类别：

| 类别 | 判断标准 | 修复策略 |
|------|---------|---------|
| **跨时钟域 (CDC)** | 起点和终点时钟不同且非同步 | `set_false_path` 或 `set_max_delay -datapath_only` |
| **高扇出 (High Fanout)** | 扇出 > 200 的控制/复位信号 | `set_max_fanout`、复制寄存器 |
| **长组合逻辑 (Long Logic)** | 逻辑级数 > 15 | `set_max_delay`、插入流水线 |
| **未分类 (Unclassified)** | 不符合以上类别 | 提交用户人工审查 |

### 用户确认点 1
向用户呈现：
- 基线指标（WNS、TNS、违规路径数）
- 分类汇总表
- 询问："是否继续生成约束？"

---

## 阶段 2 — 生成约束

### 2.1 针对每类违规生成修复约束

**CDC 修复：**
```tcl
# 异步时钟之间
set_false_path -from [get_clocks <clock_a>] -to [get_clocks <clock_b>]
# 或特定路径
set_max_delay -datapath_only 5.0 -from [get_pins ...] -to [get_pins ...]
```

**高扇出修复：**
```tcl
# 限制扇出
set_max_fanout 100 [get_nets <net_name>]
# 在关键路径上复制高扇出网络
# 使用 phys_opt_design -force_replication_on_nets
```

**长逻辑修复：**
```tcl
# 关键路径上的组合逻辑约束
set_max_delay 5.0 -from [get_pins ...] -to [get_pins ...]
# 启用重定时/重映射
set_property BLOCK_SRAM_CRC TRUE [current_design]
```

### 2.2 写入 timing_fixes.xdc
```tcl
# ==============================================================================
# timing_fixes.xdc — 时序收敛约束
# 基线: WNS=<值> | TNS=<值> | 违规路径=<数量>
# 迭代: <N>/3
# ==============================================================================
```

### 用户确认点 2
向用户呈现 `timing_fixes.xdc` 的完整内容，询问是否继续。

---

## 阶段 3 — 重新运行并验证

### 3.1 应用约束并重新实现
```tcl
read_xdc timing_fixes.xdc
opt_design
place_design
phys_opt_design
route_design
```

### 3.2 验证结果
```tcl
report_timing_summary
```

### 3.3 判断
- **时序满足** → 报告成功
- **改善但仍有违规** → 迭代（最多 3 次）
- **无改善或退步** → 提交用户人工决策

---

## 关键规则

1. **DONT_TOUCH**：使用 `set_property DONT_TOUCH FALSE`，不用 `reset_property`
2. **KEEP 是综合专用**：布局布线后无法移除
3. **CDC 优先**：异步时钟间的约束优先处理
4. **同步时钟**：频率相关的时钟之间不要用异步例外
5. **最多迭代 3 次**
6. **不生成占位符**：所有约束必须使用真实设计名称
