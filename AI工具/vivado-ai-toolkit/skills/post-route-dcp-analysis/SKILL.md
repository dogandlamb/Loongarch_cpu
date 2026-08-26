---
name: post-route-dcp-analysis
description: >
  分析 Vivado 布线后设计检查点（DCP），分类时序违规路径，
  并在 Vivado GUI 中按类别用不同颜色高亮显示关键路径。
  适用于教程和设计审查场景。支持 Vivado 2019.2+。
---

# 布线后 DCP 分析

## 适用版本
- Vivado 2019.2+：`open_checkpoint` 支持
- Vivado GUI 需要 X 显示（Linux）或本地桌面（Windows）

## 双阶段分析流程

### 阶段 1：数据收集

```tcl
# 打开布线后 DCP
open_checkpoint <routed.dcp>

# 收集时序数据
set failing_paths [get_timing_paths -max_paths 200 -slack_lesser_than 0]
set wns [get_property SLACK [lindex $failing_paths 0]]
set tns 0.0
foreach p $failing_paths {
    set tns [expr {$tns + [get_property SLACK $p]}]
}
```

### 阶段 2：分类

按照 [classification.md](reference/classification.md) 中的规则分类每条路径：

| 类别 | 高亮颜色 | 判断条件 |
|------|---------|---------|
| 🔴 CDC | 红色 | clk_start != clk_end |
| 🟡 SLR | 黄色 | SLR 穿越 |
| 🟠 高扇出 | 橙色 | 扇出 > 200 |
| 🟢 长逻辑 | 绿色 | 逻辑级数 > 15 |
| ⚪ 未分类 | 白色 | 不符合以上 |

### 阶段 3：GUI 高亮

参考 [highlighting.md](reference/highlighting.md) 在 Vivado GUI 中按类别高亮关键路径。

## 输出
- 分类汇总表
- 每类一条代表性路径分析
- GUI 高亮截图说明
