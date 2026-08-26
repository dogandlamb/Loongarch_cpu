# Prompt Library — ILA 在线调试

## ILA 插入流程
**块设计 (Block Design) 中插入 ILA：**
打开块设计，在 AXI 接口路径上插入 System ILA 以监控 AXI-Stream 数据。

**标记调试信号：**
在 RTL 中用 HDL_ATTRIBUTE.DEBUG 标记关键信号，综合后自动插入 ILA 核。

**指定信号监控：**
监控 s_axis_tdata、s_axis_tvalid、s_axis_tready、m_axis_tdata、m_axis_tvalid、m_axis_tready 信号。

## VIO 插入流程
在块设计中插入 VIO (Virtual Input/Output) 核，用于 JTAG 实时控制和监控内部信号。

## 硬件调试
打开 Hardware Manager，连接目标设备，配置 ILA 触发条件，捕获波形数据。

## 触发设置
设置 ILA 触发条件为：当 s_axis_tvalid = 1 且 s_axis_tready = 0 时触发，捕获 1024 个样本。
