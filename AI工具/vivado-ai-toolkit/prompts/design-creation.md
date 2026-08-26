# Prompt Library — 设计创建

## 从规格创建块设计
根据硬件规格文件创建 Vivado 块设计。读取 spec/hardware_spec.md，按以下流程：
1. 创建项目
2. 添加 RTL 源文件
3. 创建块设计
4. 从 IP 目录添加所需 IP
5. 连接 AXI 接口
6. 验证设计
7. 生成输出产品

## 创建完整项目
创建 Vivado 项目，目标器件 xck26-sfvc784-2LV-c（KV260），添加 RTL 源文件，运行综合和实现。

## DMA 回环设计
创建一个包含 Zynq MPSoC + AXI DMA + AXI SmartConnect + BRAM 控制器的块设计，实现 DMA 数据回环。
