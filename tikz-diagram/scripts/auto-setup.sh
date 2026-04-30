#!/usr/bin/env bash
# TikZ Diagram 自动环境设置脚本
# 智能检测并修复缺失的组件
set -euo pipefail

echo "=== TikZ Diagram 自动环境设置 ==="

# 获取脚本所在目录
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILL_DIR="$(dirname "$SCRIPT_DIR")"

# 检测系统
detect_os() {
  case "$(uname -s)" in
    Darwin*)  echo "macos" ;;
    Linux*)   echo "linux" ;;
    *)        echo "unknown" ;;
  esac
}

OS=$(detect_os)
echo "检测到系统: $OS"

# 检查 LaTeX 引擎
check_latex() {
  for engine in xelatex pdflatex lualatex; do
    if command -v "$engine" >/dev/null 2>&1; then
      echo "✅ LaTeX 引擎可用: $engine"
      return 0
    fi
  done
  echo "❌ 未找到 LaTeX 引擎"
  return 1
}

# 安装 LaTeX 和必要组件
install_latex() {
  case "$OS" in
    macos)
      if ! command -v brew >/dev/null 2>&1; then
        echo "❌ 请先安装 Homebrew: https://brew.sh"
        return 1
      fi

      echo "📦 安装 BasicTeX..."
      brew install --cask basictex

      echo "⏳ 更新 PATH..."
      eval "$(/usr/libexec/path_helper -s)"

      echo "📦 安装 TikZ 宏包..."
      sudo tlmgr update --self
      sudo tlmgr install standalone ctex pgf xcolor graphicx

      echo "📦 安装中文字体..."
      brew install --cask font-noto-sans-cjk-sc

      ;;
    linux)
      echo "📦 使用 apt 安装 TeX Live..."
      sudo apt update

      sudo apt install -y \
        texlive-latex-base \
        texlive-latex-extra \
        texlive-fonts-recommended \
        texlive-xetex \
        latexmk

      echo "📦 安装中文字体..."
      sudo apt install -y fonts-noto-cjk

      ;;
    *)
      echo "❌ 不支持的系统: $OS"
      return 1
      ;;
  esac
}

# 检查并安装 ImageMagick
check_imagemagick() {
  if ! command -v convert >/dev/null 2>&1; then
    echo "⚠️  ImageMagick 未安装，将跳过 PNG 转换"
    echo "   安装命令: brew install imagemagick"
  else
    echo "✅ ImageMagick 可用"
  fi
}

# 验证安装
verify_installation() {
  echo "🔍 验证安装..."

  # 检查 LaTeX
  if ! check_latex; then
    echo "❌ LaTeX 安装失败"
    return 1
  fi

  # 检查关键宏包
  for pkg in standalone ctex pgf; do
    if kpsewhich ${pkg}.sty >/dev/null 2>&1; then
      echo "✅ ${pkg} 宏包已安装"
    else
      echo "❌ ${pkg} 宏包未找到"
    fi
  done

  # 检查中文字体
  if fc-list :lang=zh >/dev/null 2>&1; then
    echo "✅ 中文字体可用"
  else
    echo "⚠️  未检测到中文字体"
  fi

  # 检查转换工具
  check_imagemagick

  echo "=== 设置完成 ==="
}

# 主流程
if check_latex; then
  echo "✅ LaTeX 环境已就绪"
else
  echo "需要安装 LaTeX 环境..."
  if ! install_latex; then
    echo "❌ LaTeX 安装失败，请手动安装"
    exit 1
  fi
fi

verify_installation

# 输出使用说明
echo ""
echo "使用方法："
echo "1. 运行: bash $SKILL_DIR/scripts/render.sh figure.tex"
echo "2. 支持: --format png svg --dpi 600"
echo ""
echo "常见问题修复："
echo "- 如果编译报错，会自动尝试安装缺失宏包"
echo "- 如果中文字体显示异常，确保安装了 Noto Sans CJK"