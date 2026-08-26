# Prompt Library — 时序收敛

## 完整三阶段时序收敛
打开我的设计（项目模式 open_run impl_1，或非项目 open_checkpoint），执行三阶段时序收敛：
1. 分析布线后时序，获取基线 WNS/TNS，分类所有违规路径
2. 为每类违规生成修复约束到 timing_fixes.xdc
3. 应用约束、重新运行实现（opt_design → place_design → phys_opt_design → route_design）、验证结果
目标：WNS >= 0，无时序违规。最多迭代 3 次。

## 快速时序检查
打开设计，报告时序摘要，列出 WNS 最差的 50 条路径。如果 WNS < 0，分类违规路径。

## 时序分析 + 可视化
打开布线后 DCP，分析时序违规，在 Vivado GUI 中按类别高亮显示关键路径。

## 针对性修复
**CDC 问题：** 检查跨时钟域路径，为异步时钟间添加 set_false_path 或 set_max_delay -datapath_only。

**高扇出：** 识别扇出 > 200 的网络，限制扇出或复制寄存器。

**长逻辑链：** 识别逻辑级数 > 15 的路径，应用 set_max_delay 或建议插入流水线。

## 仅分析不修复
分析当前设计的时序违规，分类但不生成约束。我需要先人工审查。

## 时钟报告
报告所有时钟、时钟组关系、时钟交互。检查是否有未约束的时钟。
