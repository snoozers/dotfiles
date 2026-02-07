#!/bin/bash

# Claude Code ステータスライン表示スクリプト
# Powerlevel10k の PS1 構成を参考に作成

# カラー定義（$'' で実際のエスケープ文字を格納）
ESC=$'\033'
C_RESET="${ESC}[0m"
C_DIM="${ESC}[2m"
C_USER="${ESC}[36m"       # シアン: ユーザー@ホスト
C_DIR="${ESC}[1;34m"      # 青太字: ディレクトリ
C_GIT="${ESC}[35m"        # マゼンタ: Git ブランチ
C_MODEL="${ESC}[32m"      # 緑: モデル名
C_CTX="${ESC}[33m"        # 黄: コンテキスト残量（警告時）
C_TIME="${ESC}[2;37m"     # 薄灰: 時刻
C_SEP="${ESC}[2;37m"      # 薄灰: 区切り文字

input=$(cat)

cwd=$(echo "$input" | jq -r '.workspace.current_dir')
remaining=$(echo "$input" | jq -r '.context_window.remaining_percentage // empty')
model=$(echo "$input" | jq -r '.model.display_name // .model.id // "unknown"')

user=$(whoami)
host=$(hostname -s)
dir=$(basename "$cwd")
time=$(date +%H:%M:%S)

# Git ブランチ
git_branch=$(cd "$cwd" 2>/dev/null && git --no-optional-locks symbolic-ref --short HEAD 2>/dev/null || echo '')

# コンテキスト残量
context_info=''
if [ -n "$remaining" ]; then
  if [ "$(echo "$remaining < 30" | bc -l 2>/dev/null)" = "1" ]; then
    context_info="${C_SEP} | ${C_CTX}Ctx:${remaining}%${C_RESET}"
  else
    context_info="${C_SEP} | ${C_DIM}Ctx:${remaining}%${C_RESET}"
  fi
fi

# Git ブランチ部分
git_info=''
if [ -n "$git_branch" ]; then
  git_info=" ${C_GIT}[${git_branch}]${C_RESET}"
fi

# 出力
printf "${C_USER}%s@%s${C_RESET}:${C_DIR}%s${C_RESET}%s ${C_SEP}|${C_RESET} ${C_MODEL}%s${C_RESET}%s ${C_SEP}|${C_RESET} ${C_TIME}%s${C_RESET}" \
  "$user" "$host" "$dir" "$git_info" "$model" "$context_info" "$time"
