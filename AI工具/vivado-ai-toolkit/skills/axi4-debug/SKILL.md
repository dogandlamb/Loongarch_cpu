---
name: axi4-debug
description: >
  使用 Vivado 仿真调试 AXI4 DUT。当用户要求运行仿真、查找 Bug、修复 RTL、
  或调试 AXI 协议违规时触发——即使没有明确使用"仿真"一词。支持 Vivado 2019.2+。
---

# AXI4 仿真调试

## 适用版本
- Vivado 2019.2+：XSim 行为仿真
- 需要 AXI VIP + AXI Protocol Checker IP

---

## MCP 工具
| 工具 | 用途 |
|------|------|
| `vivado_start` | 启动 Vivado 会话 |
| `vivado_execute` | 执行 Tcl 命令 |
| `vivado_stop` | 关闭会话 |
| `vivado_log_messages` | 解析日志 |
| `vivado_doc_search` | 搜索 AMD 文档 |

---

## 工作流程

### 1. 启动 Vivado 会话
```tcl
open_project <project.xpr>
```

### 2. 列出仿真文件集
```tcl
get_filesets -filter {FILE_SET_TYPE == Simulation}
```

### 3. 启动仿真（阻塞式）
```tcl
set_property top <tb_name> [get_filesets <sim_set>]
launch_simulation -simset [get_filesets <sim_set>] -mode behavioral
```

### 4. 读取仿真日志
从 `simulate.log` 中提取断言名称、失败时间和违规通道。

### 5. 打开波形
```tcl
open_wave_config <tb>.wcfg
# 添加颜色编码的信号
add_wave {{/信号组}} -color <颜色>
```

### 6. 修复 RTL
- 读取对应 RTL 文件
- 应用最小一行修复
- 重新运行仿真验证

---

## 每轮检查清单
对每个测试平台，按顺序完成：
- [ ] 运行仿真 → 读取 simulate.log
- [ ] FAIL 波形 → 按断言通道添加颜色编码信号
- [ ] 暂停 → 展示断言+波形，等待用户确认
- [ ] 读取 RTL → 仅在用户说"修复"后
- [ ] 应用修复 → 最小改动
- [ ] 重新仿真 → 验证 PASS
- [ ] PASS 波形 → 相同信号/颜色

---

## AXI4 协议速查

| 通道 | 关键信号 |
|------|---------|
| 写地址 (AW) | AWVALID, AWREADY, AWADDR, AWLEN, AWSIZE, AWBURST |
| 写数据 (W) | WVALID, WREADY, WDATA, WSTRB, WLAST |
| 写响应 (B) | BVALID, BREADY, BRESP |
| 读地址 (AR) | ARVALID, ARREADY, ARADDR, ARLEN, ARSIZE, ARBURST |
| 读数据 (R) | RVALID, RREADY, RDATA, RRESP, RLAST |

**关键规则：**
- VALID 必须在 READY 之前或同时拉高
- Burst 不能跨 4KB 边界
- 写响应必须在最后一个写数据传输后
- AWBURST/ARBURST 类型（FIXED/INCR/WRAP）
