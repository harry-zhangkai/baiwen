#!/usr/bin/env bash
# 百问 macOS 一键安装脚本：自动识别芯片架构，关闭运行中的百问后覆盖安装最新版。
# 用法（终端里执行这一条即可）：
#   curl -fsSL https://raw.githubusercontent.com/harry-zhangkai/baiwen/main/install.sh | bash
set -euo pipefail

REPO="harry-zhangkai/baiwen"
APP_NAME="百问"
APP_PATH="/Applications/baiwen.app"

echo "==> 百问 macOS 安装开始"

# ---------- 系统 / 芯片 ----------
if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "✗ 本脚本仅支持 macOS。Windows 用户请到 https://github.com/$REPO/releases 下载 *-win-x64-setup.exe 安装。" >&2
  exit 1
fi
case "$(uname -m)" in
  arm64)  ARCH="arm64" ;;
  x86_64) ARCH="x64" ;;
  *) echo "✗ 不支持的芯片架构：$(uname -m)" >&2; exit 1 ;;
esac
echo "==> 芯片架构：$ARCH"

# ---------- 关闭运行中的百问 ----------
# 只匹配本安装位置的进程（主进程与 Helper 均在 baiwen.app 目录下），不影响其他程序
if pgrep -f "$APP_PATH" >/dev/null 2>&1; then
  echo "==> 检测到百问正在运行，请求正常退出…"
  osascript -e "tell application \"$APP_NAME\" to quit" >/dev/null 2>&1 &
  osa_pid=$!
  # 最多等 15 秒；osascript 卡住（应用无响应）也不影响超时判断
  quit_ok=0
  for _ in $(seq 1 15); do
    if ! pgrep -f "$APP_PATH" >/dev/null 2>&1; then quit_ok=1; break; fi
    sleep 1
  done
  kill "$osa_pid" 2>/dev/null || true
  if [[ "$quit_ok" -ne 1 ]]; then
    echo "✗ 百问无法自动退出（可能有弹窗，或正在执行任务）。" >&2
    echo "  请手动退出百问（右键 Dock 图标 → 退出）后重新运行本脚本。" >&2
    exit 1
  fi
  echo "==> 百问已退出"
fi

# ---------- 查询最新版安装包地址 ----------
echo "==> 查询最新版本…"
api_json="$(curl -fsSL "https://api.github.com/repos/$REPO/releases/latest" 2>/dev/null || true)"
dmg_url="$(printf '%s' "$api_json" | grep -o "https://[^\"]*baiwen-[0-9.]*-mac-$ARCH.dmg" | head -1 || true)"
if [[ -z "$dmg_url" ]]; then
  echo "✗ 未获取到最新版 mac 安装包地址（可能是网络问题或 GitHub 访问受限）。" >&2
  echo "  请到 https://github.com/$REPO/releases 手动下载 baiwen-*-mac-$ARCH.dmg。" >&2
  exit 1
fi
echo "==> 安装包：$dmg_url"

# ---------- 下载 ----------
tmp_dir="$(mktemp -d)"
dmg="$tmp_dir/baiwen.dmg"
trap 'rm -rf "$tmp_dir"' EXIT
echo "==> 下载中…"
curl -fL --progress-bar -o "$dmg" "$dmg_url"

# ---------- 清理历史残留挂载 ----------
# 同名安装卷残留多个挂载点时，复制会互相覆盖产生损坏（History 里 "baiwen 0.1.0-arm64 1/3" 即此问题）
for v in /Volumes/baiwen*; do
  [[ -e "$v" ]] || continue
  hdiutil detach "$v" -force >/dev/null 2>&1 || true
done

# ---------- 挂载并覆盖安装 ----------
echo "==> 安装到 $APP_PATH …"
mount_out="$(hdiutil attach -nobrowse "$dmg")"
mp="$(printf '%s\n' "$mount_out" | grep -o '/Volumes/.*' | tail -1)"
trap 'hdiutil detach "$mp" -force >/dev/null 2>&1 || true; rm -rf "$tmp_dir"' EXIT

if [[ ! -d "$mp/baiwen.app" ]]; then
  echo "✗ 安装包内容异常，请重新运行本脚本。" >&2
  exit 1
fi

rm -rf "$APP_PATH"
ditto "$mp/baiwen.app" "$APP_PATH"
hdiutil detach "$mp" -quiet >/dev/null 2>&1 || true

echo "✅ 安装完成：$APP_PATH"
open "$APP_PATH"
