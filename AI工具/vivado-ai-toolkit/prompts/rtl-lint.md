# Prompt Library — RTL 代码检查

## 基本 Lint 检查
对当前项目运行 Vivado RTL Lint 检查。列出所有 CRITICAL WARNING 和 WARNING，按严重度分类，给出修复建议。

## 全面代码质量检查
对 src/ 下所有 RTL 文件运行完整的代码质量分析：
1. Vivado Lint（综合前的语法/风格检查）
2. 检查多驱动、未连接端口、位宽不匹配
3. 检查隐式 latch、组合逻辑环路
4. 生成修复报告，包含每个问题的文件位置和修复代码

## 单文件检查
只检查 src/top_module.sv，列出该文件中的所有 lint 问题。

## 检查后自动修复
运行 Lint 检查后，自动修复所有 CRITICAL WARNING。对每个修复给出说明。
