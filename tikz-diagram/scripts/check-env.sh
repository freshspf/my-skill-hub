#!/usr/bin/env bash
# TikZ 环境快速诊断工具
set -euo pipefail

echo "=== TikZ 环境诊断 ==="

# 检查 LaTeX 引擎
check_engine() {
  for engine in xelatex pdflatex lualatex; do
    if command -v "$engine" >/dev/null 2>&1; then
      echo "✅ LaTeX 引擎: $engine"
      return 0
    fi
  done
  echo "❌ LaTeX 引擎未安装"
  return 1
}

# 检查宏包
check_packages() {
  local packages=(standalone ctex pgf xcolor graphicx)
  local missing=()

  for pkg in "${packages[@]}"; do
    if kpsewhich ${pkg}.sty >/dev/null 2>&1; then
      echo "✅ ${pkg}"
    else
      echo "❌ ${pkg} (缺失)"
      missing+=("$pkg")
    fi
  done

  if [ ${#missing[@]} -gt 0 ]; then
    echo ""
    echo "安装缺失宏包:"
    echo "sudo tlmgr install ${missing[*]}"
  fi
}

# 检查字体
check_fonts() {
  if fc-list :lang=zh >/dev/null 2>&1; then
    echo "✅ 中文字体可用"
  else
    echo "❌ 中文字体未安装"
  fi
}

# 检查转换工具
check_tools() {
  local tools=()
  command -v convert >/dev/null 2>&1 && tools+=("✅ ImageMagick") || tools+=("❌ ImageMagick")
  command -v pdf2svg >/dev/null 2>&1 && tools+=("✅ pdf2svg") || tools+=("❌ pdf2svg")
  command -v pdftoppm >/dev/null 2>&1 && tools+=("✅ pdftoppm") || tools+=("❌ pdftoppm")

  for tool in "${tools[@]}"; do
    echo "$tool"
  done
}

# 运行诊断
check_engine
echo ""
echo "宏包检查:"
check_packages
echo ""
echo "字体检查:"
check_fonts
echo ""
echo "转换工具:"
check_tools

echo ""
echo "=== 诊断完成 ==="