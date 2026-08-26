# Prompt Library — 设计优化分析

## opt_design 日志分析
分析 opt_design 日志：
1. 各阶段优化统计（retarget、propconst、sweep、BUFG、shift-reg、remap）
2. DONT_TOUCH/MARK_DEBUG 冲突
3. BRAM 功耗优化
4. 控制集合并
5. 给出可执行的优化建议

## 利用率分析
报告当前设计的资源利用率（LUT、FF、BRAM、DSP、IO），标识超过 80% 的资源，给出降低利用率的建议。

## 优化策略推荐
分析当前设计，推荐 opt_design / phys_opt_design 的最佳 directive 设置。比较 Explore、AggressiveExplore、Default 的适用场景。
