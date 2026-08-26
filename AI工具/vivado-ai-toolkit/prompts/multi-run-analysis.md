# Prompt Library — 多轮实现分析

## 基本对比
列出所有实现运行，收集每轮的时序摘要、利用率、DRC、功耗报告，生成 QoR 排名表。推荐最佳综合+实现策略组合。

## 策略对比
对比不同综合/实现策略的效果。分别运行 synth_1 (Flow_PerfOptimized_high)、synth_2 (Performance_Explore)、synth_3 (Area_Optimized)，分析 WNS、LUT、FF、功耗的差异。

## 单轮深入分析
分析 impl_1 的完整报告集（时序、利用率、DRC、methodology、功耗），生成汇总仪表板。

## 异常检测
对比最近的两轮实现运行（如 run_1 vs run_2），高亮 WNS/TNS/利用率/功耗的异常变化，分析可能原因。
