#!/bin/bash

echo "🚀 开始安装 Claude Vibe Coding 增强包..."

# 定义安装路径
INSTALL_DIR="$HOME/claude_skills"
mkdir -p "$INSTALL_DIR/models"
mkdir -p "$INSTALL_DIR/switch_model"

# 复制核心切换脚本
cp ./scripts/switch.sh "$INSTALL_DIR/switch_model/"
chmod +x "$INSTALL_DIR/switch_model/switch.sh"

# 将函数注入到 .bashrc (如果尚未存在)
if ! grep -q "Claude Vibe Coding 增强工具箱" ~/.bashrc; then
    echo "正在将工具函数写入 ~/.bashrc ..."
    
    cat << 'BASH_FUNC' >> ~/.bashrc

# --- 🚀 Vibe Coding 增强工具箱 ---
# 包含 models, setup-*, cmm, czhipu 等命令
# 详细文档：https://github.com/YOUR_GITHUB_ID/claude-vibe-coding-kit

# (此处省略具体函数实现，建议用户查看 GitHub 源码)
# ... [这里为了简洁，实际开源时我们可以把之前 .bashrc 里的那一大段 setup-xxx 代码放进一个 separate file source 进来，或者让用户复制]
BASH_FUNC
    
    echo "✅ 注入完成！"
else
    echo "⚠️  检测到 .bashrc 中已存在相关配置，跳过注入。"
fi

echo "🎉 安装完成！请运行 'source ~/.bashrc' 生效。"
