#!/usr/bin/env bash
# tikz-diagram 环境安装脚本
# 支持 macOS (Homebrew) 和 Ubuntu/Debian (apt)
set -euo pipefail

echo "=== TikZ Diagram 环境安装 ==="

detect_os() {
  case "$(uname -s)" in
    Darwin*)  echo "macos" ;;
    Linux*)   echo "linux" ;;
    *)        echo "unknown" ;;
  esac
}

OS=$(detect_os)
echo "检测到系统: $OS"

# 检查是否已安装
check_installed() {
  command -v xelatex >/dev/null 2>&1 || command -v pdflatex >/dev/null 2>&1
}

if check_installed; then
  echo "✅ LaTeX 已安装: $(which xelatex || which pdflatex)"
  # 检查 tikz
  if kpsewhich tikz.sty >/dev/null 2>&1; then
    echo "✅ TikZ (pgf) 宏包已安装"
  else
    echo "⚠️  TikZ 宏包未安装，正在安装..."
    install_tikz
  fi
  # 检查中文字体
  if fc-list :lang=zh >/dev/null 2>&1; then
    echo "✅ 中文字体可用"
  else
    echo "⚠️  未检测到中文字体，中文可能无法正常渲染"
  fi
  echo "=== 安装完成 ==="
  exit 0
fi

install_macos() {
  echo "📦 使用 Homebrew 安装 BasicTeX..."

  if ! command -v brew >/dev/null 2>&1; then
    echo "❌ 未检测到 Homebrew，请先安装: https://brew.sh"
    echo "   或手动安装 MacTeX: https://tug.org/mactex/"
    exit 1
  fi

  brew install --cask basictex

  echo "⏳ 等待 PATH 更新..."
  eval "$(/usr/libexec/path_helper -s)" 2>/dev/null || true

  echo "📦 安装 TikZ (pgf) 宏包..."
  sudo tlmgr update --self
  sudo tlmgr install pgf xcolor graphicx

  echo "📦 安装中文支持（可选）..."
  sudo tlmgr install ctex xecjk fontspec ucharcat || {
    echo "⚠️  部分中文宏包安装失败，如需中文请手动执行:"
    echo "   sudo tlmgr install ctex xecjk fontspec ucharcat"
  }

  echo "📦 安装中文字体..."
  echo "   推荐: 思源黑体 / 思源宋体"
  echo "   brew install --cask font-noto-sans-cjk-sc"
  echo "   或手动安装任意 .ttf/.otf 中文字体到 ~/Library/Fonts/"

  echo "=== 安装完成 ==="
  echo ""
  echo "后续如需补充宏包:"
  echo "  sudo tlmgr install <宏包名>"
  echo ""
  echo "卸载:"
  echo "  brew uninstall --cask basictex"
}

install_linux() {
  echo "📦 使用 apt 安装 TeX Live..."

  if ! command -v apt >/dev/null 2>&1; then
    echo "❌ 未检测到 apt，请手动安装 TeX Live: https://tug.org/texlive/"
    exit 1
  fi

  sudo apt update

  echo "📦 安装最小化 TeX Live（约 800MB）..."
  sudo apt install -y \
    texlive-latex-base \
    texlive-latex-extra \
    texlive-fonts-recommended \
    texlive-xetex \
    latexmk

  echo "📦 安装中文字体..."
  sudo apt install -y fonts-noto-cjk || {
    echo "⚠️  中文字体安装失败，如需中文请手动安装"
  }

  echo "=== 安装完成 ==="
  echo ""
  echo "卸载:"
  echo "  sudo apt remove texlive-* && sudo apt autoremove"
}

install_tikz() {
  case "$OS" in
    macos)  install_macos ;;
    linux)  install_linux ;;
    *)
      echo "❌ 不支持的系统: $OS"
      echo "请手动安装 TeX Live: https://tug.org/texlive/"
      exit 1
      ;;
  esac
}

install_tikz
