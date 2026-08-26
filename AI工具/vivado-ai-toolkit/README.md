# Vivado AI 工具包

可以让 AI 助手直接操控 Vivado 完成 FPGA 设计的一些任务。

---

## 📦 工具包结构

```
vivado-ai-toolkit/
├── README.md                         # 本文件
├── .vscode/settings.json             # MCP 自动启动 + Vivado 路径配置
├── config/mcp.json                   # MCP 服务器连接
├── skills/                           # 所有 AI 技能（8 大类）
│   ├── axi4-debug-simulation/        # AXI4 仿真调试
│   │   └── SKILL.md
│   ├── bd-ila-insertion/             # ILA 在线逻辑分析插入
│   │   └── SKILL.md
│   ├── bd-vio-insertion/             # VIO 虚拟 IO 插入
│   │   └── SKILL.md
│   ├── multi-run-analysis/           # 多轮实现对比分析
│   │   └── SKILL.md
│   ├── opt-design-analysis/          # 设计优化分析
│   │   └── SKILL.md
│   ├── post-route-dcp-analysis/      # 布线后 DCP 分析 + GUI 高亮
│   │   └── SKILL.md
│   ├── rtl-lint/                     # RTL 代码 Lint 检查
│   │   └── SKILL.md
│   └── timing-closure-prototype/     # ⭐ 三阶段时序收敛（含 7 个参考文件）
│       ├── SKILL.md
│       └── reference/                # 分类、修复策略参考
│           ├── classification.md     # 违规分类规则
│           ├── cdc-fixes.md          # 跨时钟域修复
│           ├── slr-fixes.md          # SLR 穿越修复
│           ├── logic-fixes.md        # 长逻辑链修复
│           ├── fanout-fixes.md       # 高扇出修复
│           ├── rerun-strategy.md     # 重新运行策略
│           └── validate.md           # 验证方法
└── prompts/                          # 提示词库（复制即用）
    ├── timing-closure.md             # 时序收敛各种场景
    ├── rtl-lint.md                   # 代码检查
    ├── opt-design-analysis.md        # 优化分析
    ├── multi-run-analysis.md         # 多策略对比
    ├── axi4-debug.md                 # AXI4 仿真调试
    ├── ila-insertion.md              # ILA/VIO 在线调试
    └── design-creation.md            # 块设计创建
```

---

## 怎么上手？

### ① 复制 → ② 配置 Vivado 路径 → ③ 开聊

```powershell
# 1. 将 vivado-ai-toolkit/ 复制到任意 Vivado 工程根目录
# 2. 编辑 .vscode/settings.json，改这一行：
"vivadoTerminal.vivadoPath": "D:\\Xilinx\\Vivado\\2023.2\\bin\\vivado.bat"

# 3. code . 打开，对 AI 说话
```

---

## 可用的技能

对着 AI 说出关键词即可触发对应技能：

### 综合与实现
| 关键词 | AI 做什么 |
|--------|----------|
| "综合"、"run synthesis" | 运行 `synth_design` |
| "实现"、"run implementation" | 运行 `place_design` → `phys_opt_design` → `route_design` |
| "生成 bitstream" | 运行 `write_bitstream` |
| "完整构建"、"build" | 综合 → 实现 → bitstream 全流程 |

### 时序收敛 ⭐
| 关键词 | AI 做什么 |
|--------|----------|
| "达到100MHz"、"时序收敛"、"WNS>=0"、"fix timing" | 三阶段：分析→生成约束→重新实现→验证 |
| "报告时序"、"timing report" | 报告 WNS/TNS，列出最差路径 |
| "分析违规"、"classify violations" | 分类每条违规路径（CDC/高扇出/长逻辑等） |
| "生成时序约束" | 生成 timing_fixes.xdc |
| "时序可视化"、"highlight paths" | GUI 中按类别高亮关键路径 |

### RTL 代码质量
| 关键词 | AI 做什么 |
|--------|----------|
| "lint"、"检查代码"、"code check"、"RTL review" | 运行 Vivado Lint，列出 WARNING/CRITICAL WARNING |
| "修复 lint"、"fix warnings" | 自动修复所有可修复的 lint 问题 |
| "位宽检查"、"width check" | 检查位宽不匹配 |
| "多驱动检查" | 检测 multi-driver |

### 设计分析
| 关键词 | AI 做什么 |
|--------|----------|
| "利用率"、"utilization" | 报告 LUT/FF/BRAM/DSP/IO 使用率 |
| "功耗"、"power" | 报告功耗分析 |
| "opt_design 分析" | 分析优化日志，推荐 directive |
| "DRC 检查"、"设计规则检查" | 运行 report_drc |
| "methodology 检查" | 运行 report_methodology |

### 多策略探索
| 关键词 | AI 做什么 |
|--------|----------|
| "对比策略"、"compare runs"、"which strategy" | 对比多轮实现，排名推荐 |
| "尝试不同综合策略" | 运行多种综合策略并比较 |
| "QoR 排名"、"quality ranking" | 生成质量排名表 |

### AXI 总线调试
| 关键词 | AI 做什么 |
|--------|----------|
| "AXI 仿真"、"AXI debug"、"协议违规" | 运行 XSim，检测 AXI 协议违规 |
| "AXI 波形"、"waveform" | 打开波形，颜色标记 AXI 通道 |
| "AXI handshake"、"VALID/READY" | 分析握手时序 |

### 硬件调试（ILA/VIO）
| 关键词 | AI 做什么 |
|--------|----------|
| "插入 ILA"、"add ILA"、"debug core" | 在 BD 中插入 System ILA / ILA |
| "插入 VIO"、"add VIO" | 在 BD 中插入 VIO |
| "MARK_DEBUG"、"标记调试" | RTL 中添加 MARK_DEBUG 属性 |
| "硬件调试"、"Hardware Manager" | 打开 Hardware Manager，配置触发 |

### 设计创建
| 关键词 | AI 做什么 |
|--------|----------|
| "创建块设计"、"create block design" | 创建 IP Integrator 块设计 |
| "从规格创建设计" | 读取 spec，自动创建完整设计 |
| "连接 AXI"、"connect AXI" | 自动连接 AXI 接口 |
| "添加 IP"、"add IP core" | 从 IP 目录添加 IP 并配置 |

### 项目管理
| 关键词 | AI 做什么 |
|--------|----------|
| "创建项目"、"new project" | 创建 Vivado 项目 |
| "添加源文件"、"add sources" | 添加 RTL/约束文件 |
| "升级 IP"、"upgrade IP" | 升级项目中的 IP 核 |
| "生成块设计"、"generate BD" | 生成块设计的输出产品 |

---

## ⚙️ MCP 工具一览

| 工具 | 功能 |
|------|------|
| `vivado_start` | 启动 Vivado 会话（TCL 模式） |
| `vivado_execute` | 执行 Tcl 命令（批量用分号分隔） |
| `vivado_stop` | 关闭 Vivado 会话 |
| `vivado_list_sessions` | 列出所有活跃会话 |
| `vivado_status` | 监控综合/实现进度 |
| `vivado_log_messages` | 解析 vivado.log 中的错误/警告 |
| `vivado_doc_search` | 搜索 AMD/Xilinx 官方文档 |
| `vivado_history` | 查询命令历史 |
| `vivado_todos` | 任务进度跟踪（IDE 侧边栏可见） |
| `vivado_connect` | 重连已有 Vivado 会话 |

---

## 🔧 Vivado 路径配置

编辑 `.vscode/settings.json`：

```json
{
    "vivadoTerminal.vivadoPath": "C:\\Xilinx\\Vivado\\2023.2\\bin\\vivado.bat",
    "vivadoTerminal.defaultSessionType": "general",
    "vivadoTerminal.defaultGuiMode": false,
    "vivadoTerminal.licenseFile": "auto"
}
```

---

## 📝 使用示例

### 从头构建 + 时序收敛
```
打开项目 project/xxx.xpr。运行综合和实现。目标频率 100MHz。如果 WNS < 0，分析违规并生成修复约束。最多迭代 3 次直到 WNS >= 0。
```

### 只分析不修改
```
打开设计，报告时序摘要和利用率。分类所有时序违规但不生成约束。我先审查一遍再决定怎么修。
```

### RTL 代码检查 + 修复
```
对 src/ 目录下所有 SystemVerilog 文件运行 Vivado Lint。列出所有 CRITICAL WARNING，并自动修复可修复的问题。
```

### 多策略探索
```
对当前设计用 3 种不同综合策略运行实现：Flow_PerfOptimized_high、Performance_Explore、Area_Optimized。对比 WNS、TNS、LUT、FF、功耗，推荐最佳策略。
```

### AXI 仿真调试
```
打开项目，运行 sim_bugs 测试平台。检测 AXI4 协议违规，显示 FAIL 波形。等我确认后修复 RTL。
```

### 硬件调试设置
```
打开块设计，在 AXI-Stream 数据路径上插入 System ILA。监控 s_axis_tdata、s_axis_tvalid、s_axis_tready 信号。生成 bitstream 并打开 Hardware Manager。
```

### 设计创建
```
创建 Vivado 项目，目标器件 xc7a200tfbg676-2。添加 src/ 下所有 .sv 文件，设置 top_module 为顶层。创建块设计，添加 Zynq PS + AXI DMA + BRAM Controller。自动连接 AXI 接口并验证设计。
```

---

## 🛠️ 前置条件

1. **VS Code** 编辑器，cursor不行
2. **Vivado AI Extension** 用`.vsix`安装
3. **Vivado 2023.2+** 已安装
4. **MCP 服务器** 运行在 `127.0.0.1:18090`

### MCP 用户级配置（一次配置所有项目通用）
将 `config/mcp.json` 内容复制到：
- **Windows**: `%APPDATA%\Code\User\mcp.json`

---

## 📂 推荐项目结构

```
my_fpga_design/
├── project/                 # Vivado 项目文件
│   └── my_design.xpr
├── src/                     # RTL 源文件
├── constraints/             # 约束文件
└── vivado-ai-toolkit/       # ← 复制到这里
    ├── .vscode/
    │   └── settings.json    # ← 改 Vivado 路径
    ├── skills/              # ← AI 自动读取
    └── prompts/             # ← 参考提示词
```

