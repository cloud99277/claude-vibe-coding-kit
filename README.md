# 🚀 Claude Code x 国产大模型：WSL 2 极速开发环境搭建指南

> **作者**：Cloud99277  
> **日期**：2026-02-01  
> **适用环境**：Windows 10/11 (WSL 2 - Ubuntu)

## 📖 简介

这是为 **Claude Code CLI** 打造的一套“外挂级”增强配置。它能让你在命令行中以 **0 Token 损耗** 快速切换使用 **DeepSeek / 智谱 GLM / MiniMax / Kimi** 等国产优质模型，并实现与 IDE (VS Code / Google Antigravity) 的无缝联动。

### ✨ 核心功能

| 功能 | 说明 |
| :--- | :--- |
| 💸 **省钱** | 用国产模型的 API 平替官方 Claude，成本降低 90%。 |
| ⚡️ **极速** | 国内直连节点，告别网络延迟。 |
| 🛠 **自动化** | 一键配置 (`setup-new`)，一键启动 (`cmm`, `czhipu`)。 |
| 🖥 **混合云** | WSL 命令行一键唤起 Windows GUI 编辑器。 |

---

## 🏗️ 第一步：基础环境准备

确保你已经安装了 WSL 2 和 Node.js。

### 1. 安装 Claude Code (官方 CLI)
```bash
npm install -g @anthropic-ai/claude-code
```
### 2. 获取本工具
```Bash
git clone [https://github.com/cloud99277/claude-vibe-coding-kit.git](https://github.com/cloud99277/claude-vibe-coding-kit.git)
cd claude-vibe-coding-kit
```
⚙️ 核心源码 (Core Logic)
如果你想了解自动化安装背后的原理，以下是 install.sh 的完整实现逻辑。

```Bash
#!/bin/bash
echo "🚀 开始安装 Claude Vibe Coding 增强包..."

# 定义安装路径
INSTALL_DIR="$HOME/claude_skills"
mkdir -p "$INSTALL_DIR/models"
mkdir -p "$INSTALL_DIR/switch_model"

# --- 1. 部署路由脚本 (switch.sh) ---
echo "📦 部署核心路由脚本..."
cat << 'SWITCH_SCRIPT' > "$INSTALL_DIR/switch_model/switch.sh"
#!/bin/bash
MODEL_NAME=$1
CONFIG_FILE="$HOME/claude_skills/models/${MODEL_NAME}.json"

if [ ! -f "$CONFIG_FILE" ]; then
    echo "❌ 错误：找不到模型配置文件: $CONFIG_FILE"
    echo "请先使用 'setup-new' 创建配置。"
    exit 1
fi

# 提取参数 (修复了正则匹配)
API_KEY=$(grep -o '"ANTHROPIC_AUTH_TOKEN": *"[^"]*"' "$CONFIG_FILE" | cut -d'"' -f4)
BASE_URL=$(grep -o '"ANTHROPIC_BASE_URL": *"[^"]*"' "$CONFIG_FILE" | cut -d'"' -f4)
MODEL_ID=$(grep -o '"ANTHROPIC_MODEL": *"[^"]*"' "$CONFIG_FILE" | cut -d'"' -f4)

# 导出环境变量
export ANTHROPIC_API_KEY="$API_KEY"
export ANTHROPIC_BASE_URL="$BASE_URL"
export ANTHROPIC_MODEL="$MODEL_ID"

# 视觉反馈
echo "🔮 Switched to: $MODEL_NAME ($MODEL_ID)"
SWITCH_SCRIPT

chmod +x "$INSTALL_DIR/switch_model/switch.sh"

# --- 2. 注入 Shell 函数到 .bashrc ---
echo "🔧 配置 Shell 环境..."

# 定义要注入的代码块
cat << 'BASH_FUNC' > /tmp/claude_vibe_rc

# --- 🚀 Vibe Coding Toolkit (Start) ---
# See: [https://github.com/cloud99277/claude-vibe-coding-kit](https://github.com/cloud99277/claude-vibe-coding-kit)

# [看板] 列出所有模型
models() {
    echo "----------------------------------------"
    echo "📜 Vibe Coding Models:"
    echo "----------------------------------------"
    if [ -d ~/claude_skills/models ]; then
        for file in ~/claude_skills/models/*.json; do
            if [ -f "$file" ]; then
                name=$(basename "$file" .json)
                # 读取模型ID用于展示
                mid=$(grep -o '"ANTHROPIC_MODEL": *"[^"]*"' "$file" | cut -d'"' -f4)
                printf "  c%-8s |  🚀 %s\n" "$name" "$mid"
            fi
        done
    else
        echo " ⚠️  No models found. Run 'setup-new' to add one."
    fi
    echo "----------------------------------------"
}

# [配置] 新增模型向导
setup-new() {
    echo "🛠️  Add New Model Config"
    read -p "1. Short Name (e.g., ds): " name
    read -p "2. API Key: " apikey
    read -p "3. Base URL: " baseurl
    read -p "4. Model ID: " modelid
    
    mkdir -p ~/claude_skills/models
    cat > ~/claude_skills/models/${name}.json <<JSON
{ "ANTHROPIC_AUTH_TOKEN": "${apikey}", "ANTHROPIC_BASE_URL": "${baseurl}", "ANTHROPIC_MODEL": "${modelid}" }
JSON
    
    if ! grep -q "alias c${name}=" ~/.bashrc; then
        echo "alias c${name}='~/claude_skills/switch_model/switch.sh ${name} && claude'" >> ~/.bashrc
    fi
    echo "✅ Config created! Run 'source ~/.bashrc' to refresh."
}

# --- 🚀 Vibe Coding Toolkit (End) ---
BASH_FUNC

# 检查并注入
if ! grep -q "Vibe Coding Toolkit" ~/.bashrc; then
    cat /tmp/claude_vibe_rc >> ~/.bashrc
    echo "✅ 已注入配置到 .bashrc"
fi
rm /tmp/claude_vibe_rc

echo "🎉 安装完成！请运行 'source ~/.bashrc' 使配置生效。"
```

