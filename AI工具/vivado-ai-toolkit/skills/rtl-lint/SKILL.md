---
name: rtl-lint
description: >
  运行 Vivado RTL Linter 在设计综合前检测 HDL 代码问题。
  当用户要求"检查RTL代码"、"lint检查"、"代码质量检查"时触发。
  支持 Vivado 2019.2+。
---

# RTL Lint 检查

## 适用版本
- Vivado 2023.2+：使用 `synth_design -lint` 命令
- Vivado 2019.2-2023.1：也可使用，部分 lint 规则可能不可用

## 执行步骤

### 1. 打开或创建项目
```tcl
# 如果有 .xpr 文件
open_project <project.xpr>
# 如果没有项目，读入 RTL
read_verilog -sv <rtl_files>
```

### 2. 运行 Lint
```tcl
# Vivado 2023.2+ 推荐
synth_design -top <top_module> -part <part> -lint -file lint_report.rpt

# 较旧版本的回退方式
synth_design -top <top_module> -part <part>
```

### 3. 分析报告
解析 lint 报告中的 WARNING、CRITICAL WARNING 和 INFO：
- **CRITICAL WARNING**：可能导致综合失败或功能错误
- **WARNING**：设计质量问题，建议修复
- **INFO**：参考信息

### 4. 分类问题
| 严重度 | 需修复 | 示例 |
|--------|--------|------|
| 🔴 致命 | 必须 | 多驱动、缺少端口连接 |
| 🟡 警告 | 建议 | 位宽不匹配、隐式 latch |
| 🔵 信息 | 可选 | 未使用的信号、冗余逻辑 |

### 5. 输出修复建议
对每个问题给出：
- 文件位置和行号
- 问题描述
- 修复代码
