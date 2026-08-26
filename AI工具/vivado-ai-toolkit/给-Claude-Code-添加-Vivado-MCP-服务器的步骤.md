# 给 Claude Code 添加 Vivado MCP 服务器的步骤

## 前置条件

| 组件 | 说明 |
|------|------|
| VS Code | 已安装 `vivado-ai-extension-0.6.8.vsix` 扩展 |
| Vivado | 2023.2+，安装在 Windows 上（WSL 路径：`/mnt/d/Xilinx/Vivado/2023.2/bin/vivado`） |
| Claude Code | VS Code 扩展版（`anthropic.claude-code`） |
| WSL | VS Code 通过 Remote-WSL 连接 |

---

## 第一步：确保 MCP 服务器在运行

Vivado 的 MCP 服务器由 VS Code 扩展自带的 `vivado-mcp-serv` 进程提供，监听 `127.0.0.1:18090`。

### 验证

```bash
ss -tlnp | grep 18090
```

预期输出：

```
LISTEN 0 4096  127.0.0.1:18090  0.0.0.0:*  users:(("vivado-mcp-serv",pid=14777,fd=8))
```

### 如果没在运行

在 VS Code 中打开包含 `vivado-ai-toolkit/` 的工程文件夹，扩展会自动启动。也可以检查 VS Code 底部状态栏是否有 Vivado 图标。

---

## 第二步：配置 WSL 下的 Vivado 路径

编辑 `vivado-ai-toolkit/.vscode/settings.json`：

```json
{
    "vivadoTerminal.vivadoPath": "/mnt/d/Xilinx/Vivado/2023.2/bin/vivado",
    "vivadoTerminal.defaultSessionType": "general",
    "vivadoTerminal.defaultGuiMode": false,
    "vivadoTerminal.autoConnect": true,
    "vivadoTerminal.autoRegisterMcp": true,
    "vivadoTerminal.autoShowTerminal": true,
    "vivadoTerminal.autoShowTodos": true
}
```

> **注意：** WSL 下必须用 `/mnt/d/...` 格式，不能用 `D:\...` 或 `C:\...`。去掉 `.bat` 后缀，WSL 可以直接调 Windows 可执行文件。

---

## 第三步：创建 `.mcp.json`（关键）

Claude Code 从 `.mcp.json` 文件加载 MCP 服务器配置。可以在**两个位置**创建（任选其一或两个都写）：

### 方案 A：用户级（所有项目通用）

文件路径：`~/.claude/.mcp.json`

```json
{
    "mcpServers": {
        "vivado-mcp-server": {
            "type": "http",
            "url": "http://127.0.0.1:18090/mcp"
        }
    }
}
```

### 方案 B：项目级（仅当前工程）

文件路径：`<工程根目录>/.mcp.json`

```json
{
    "mcpServers": {
        "vivado-mcp-server": {
            "type": "http",
            "url": "http://127.0.0.1:18090/mcp"
        }
    }
}
```

> ⚠️ **两个容易踩的坑：**
>
> 1. 文件名必须是 **`.mcp.json`**（前面有 `.`），**不能**是 `mcp.json`
> 2. **`"type": "http"` 必须写**，缺了这个字段 Claude Code 会跳过该服务器，报 `Skipped — has a "url" but no "type"`

---

## 第四步：（可选）自动批准项目级 MCP 服务器

在 `~/.claude/settings.json` 中添加：

```json
"enableAllProjectMcpServers": true
```

不加这行的话，每次打开项目 Claude Code 会弹窗询问是否信任该 MCP 服务器。

---

## 第五步：验证连接

```bash
# 找到 Claude Code 的二进制路径
CLAUDE_BIN=$(find /root/.vscode-server/extensions -name claude -path "*/native-binary/*" -type f | head -1)

# 验证 MCP 服务器状态
$CLAUDE_BIN mcp list
```

预期输出：

```
Checking MCP server health…

vivado-mcp-server: http://127.0.0.1:18090/mcp (HTTP) - ✔ Connected
```

### 也可以直接测试 MCP 协议握手

```bash
curl -s -X POST http://127.0.0.1:18090/mcp \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"test","version":"1.0.0"}},"id":1}'
```

成功的话返回 `serverInfo` 和可用能力列表。

---

## 第六步：重启 Claude Code

配置改动需要重启会话才能生效。在 VS Code 中关闭当前 Claude Code 面板，重新打开即可。

重启后，`vivado_*` 系列工具就会出现在可用工具列表中。

---

## 可用工具一览

| 工具 | 功能 |
|------|------|
| `vivado_start` | 启动 Vivado 会话（默认 TCL 模式，`session_type`: `general` 或 `ipi`） |
| `vivado_execute` | 执行 Tcl 命令（多个命令用 `;` 分隔） |
| `vivado_stop` | 关闭 Vivado 会话 |
| `vivado_status` | 监控综合/实现进度 |
| `vivado_log_messages` | 解析 vivado.log 中的 ERROR/CRITICAL WARNING/WARNING |
| `vivado_doc_search` | 搜索 AMD/Xilinx 官方文档 |
| `vivado_todos` | 任务进度跟踪（IDE 侧边栏可见） |
| `vivado_list_sessions` | 列出所有活跃会话 |
| `vivado_connect` | 重连已有 Vivado 会话 |
| `vivado_history` | 查询命令历史 |
| `vivado_display` | 管理显示/VNC/截图 |
| `vivado_feedback` | 收集用户反馈 |
| `vivado_cleanup` | 清理残留会话 |
| `vivado_client_info` | 获取客户端能力信息 |
| `vivado_ssh` | 管理远程 SSH 会话 |

---

## 整体架构

```
┌─────────────────────────────────────────────────┐
│ VS Code (WSL Remote)                            │
│                                                 │
│  vivado-ai-extension-0.6.8.vsix                 │
│  ├── 启动 Vivado (TCL 模式)                      │
│  │   路径: /mnt/d/Xilinx/Vivado/2023.2/bin/vivado│
│  └── 启动 MCP HTTP 服务器                        │
│      监听: 127.0.0.1:18090                       │
│      进程: vivado-mcp-serv                       │
│                                                 │
│  Claude Code Extension                          │
│  └── 读取 .mcp.json ──── HTTP ────► MCP Server   │
│      获得 vivado_* 工具                          │
└─────────────────────────────────────────────────┘
```

---

## 故障排查

| 现象 | 检查 |
|------|------|
| `claude mcp list` 输出 "No MCP servers configured" | `.mcp.json` 文件名是否正确（带 `.` 前缀） |
| 输出 "Skipped — has a 'url' but no 'type'" | 添加 `"type": "http"` 字段 |
| 输出 "✔ Connected" 但工具没出现 | 重启 Claude Code 会话 |
| `ss -tlnp` 看不到 18090 端口 | 确认 VS Code 扩展已安装并在该项目中激活 |
| curl 测试连接超时 | MCP 服务器已崩溃，重启 VS Code |
