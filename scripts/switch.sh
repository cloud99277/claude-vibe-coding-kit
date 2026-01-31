#!/bin/bash
# 获取目标模型名称（如 minimax 或 deepseek）
TARGET=$1
CONFIG_SRC="$HOME/claude_skills/models/${TARGET}.json"
CONFIG_DEST="$HOME/.claude/settings.json"

if [ -f "$CONFIG_SRC" ]; then
    cp "$CONFIG_SRC" "$CONFIG_DEST"
    echo "Successfully switched to $TARGET configuration."
else
    echo "Error: Configuration for $TARGET not found at $CONFIG_SRC"
    exit 1
fi
