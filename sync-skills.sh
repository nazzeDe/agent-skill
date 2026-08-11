#!/usr/bin/env bash
set -euo pipefail

# 源目录：通用 skills 存放处；目标目录：Claude Code 读取处
SRC=~/.agents/skills DST=~/.claude/skills
mkdir -p "$DST"

for d in "$SRC"/*/; do
  n=$(basename "$d")   # 技能文件夹名，如 "caveman"
  t="$DST/$n"          # 对应的软链接路径

  [ -L "$t" ] && rm "$t"                           # 已有链接 → 删掉重建（允许更新）
  [ -d "$t" ] && ! [ -L "$t" ] && { echo "skip: $n"; continue; }  # 已有真实目录 → 跳过，不覆盖

  ln -s "$d" "$t" && echo "link: $n"               # 创建软链接
done
