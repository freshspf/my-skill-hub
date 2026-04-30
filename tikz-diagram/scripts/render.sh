#!/usr/bin/env bash
# TikZ 渲染脚本：.tex → PDF → PNG/SVG
# 用法:
#   ./render.sh input.tex                     # 生成 PDF + PNG
#   ./render.sh input.tex --format svg        # 生成 PDF + SVG
#   ./render.sh input.tex --format png svg    # 生成 PDF + PNG + SVG
#   ./render.sh input.tex --dpi 600           # 指定 PNG 分辨率
#   ./render.sh input.tex --standalone        # 独立编译（默认）
#   ./render.sh input.tex --template paper    # 使用论文模板编译
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILL_DIR="$(dirname "$SCRIPT_DIR")"

# 默认参数
INPUT=""
FORMATS=("png")
DPI=300
STANDALONE=1
TEMPLATE=""

# 解析参数
while [[ $# -gt 0 ]]; do
  case "$1" in
    --format) shift; FORMATS=(); while [[ $# -gt 0 && ! "$1" =~ ^-- ]]; do FORMATS+=("$1"); shift; done; continue ;;
    --dpi)    shift; DPI="$1" ;;
    --standalone) STANDALONE=1 ;;
    --template) shift; TEMPLATE="$1" ;;
    --help|-h)
      echo "用法: $(basename "$0") <input.tex> [选项]"
      echo "选项:"
      echo "  --format png|svg|pdf    输出格式（默认 png，可指定多个）"
      echo "  --dpi N                 PNG 分辨率（默认 300）"
      echo "  --standalone            使用 standalone 类（默认）"
      echo "  --template <name>       使用模板编译: paper"
      echo "  --help                  显示帮助"
      exit 0
      ;;
    -*) echo "未知参数: $1"; exit 1 ;;
    *)  INPUT="$1" ;;
  esac
  shift
done

if [[ -z "$INPUT" ]]; then
  echo "错误: 请指定 .tex 文件"
  echo "用法: $(basename "$0") <input.tex>"
  exit 1
fi

if [[ ! -f "$INPUT" ]]; then
  echo "错误: 文件不存在: $INPUT"
  exit 1
fi

INPUT_DIR="$(cd "$(dirname "$INPUT")" && pwd)"
BASENAME="$(basename "$INPUT" .tex)"
WORK_DIR="$(mktemp -d)"
trap "rm -rf $WORK_DIR" EXIT

echo "=== TikZ 渲染 ==="
echo "输入: $INPUT"

# 检查 LaTeX 引擎
LATEX_ENGINE=""
for engine in xelatex pdflatex lualatex; do
  if command -v "$engine" >/dev/null 2>&1; then
    LATEX_ENGINE="$engine"
    break
  fi
done

if [[ -z "$LATEX_ENGINE" ]]; then
  echo "❌ 未检测到 LaTeX 引擎，请先运行环境安装:"
  echo "   bash $SCRIPT_DIR/setup.sh"
  exit 1
fi

echo "引擎: $LATEX_ENGINE"

# 判断是否需要 standalone
HEAD=$(head -5 "$INPUT")
if echo "$HEAD" | grep -q "standalone"; then
  STANDALONE=1
fi

# 准备编译文件
if [[ $STANDALONE -eq 1 ]]; then
  # standalone 模式，直接编译
  cp "$INPUT" "$WORK_DIR/$BASENAME.tex"
else
  # 非 standalone，包裹在 standalone 类中
  cat > "$WORK_DIR/$BASENAME.tex" << EOF
\documentclass[border=10pt]{standalone}
\usepackage{tikz}
\begin{document}
$(cat "$INPUT")
\end{document}
EOF
fi

# 编译 PDF
echo "编译 PDF..."
cd "$WORK_DIR"
$LATEX_ENGINE -interaction=nonstopmode "$BASENAME.tex" >/dev/null 2>&1 || {
  echo "❌ 编译失败，完整日志:"
  $LATEX_ENGINE -interaction=nonstopmode "$BASENAME.tex" 2>&1 | tail -30
  echo ""
  echo "提示: 检查 TikZ 语法错误，或添加 --template paper 使用论文模板"
  exit 1
}

# 尝试第二次编译（处理交叉引用）
if grep -q "Rerun" "$BASENAME.log" 2>/dev/null; then
  $LATEX_ENGINE -interaction=nonstopmode "$BASENAME.tex" >/dev/null 2>&1
fi

if [[ ! -f "$BASENAME.pdf" ]]; then
  echo "❌ 未生成 PDF 文件"
  exit 1
fi

echo "✅ PDF: $WORK_DIR/$BASENAME.pdf"

# 复制到输出目录
cp "$BASENAME.pdf" "$INPUT_DIR/$BASENAME.pdf"
echo "✅ 已保存: $INPUT_DIR/$BASENAME.pdf"

# 转换格式
for fmt in "${FORMATS[@]}"; do
  case "$fmt" in
    png)
      if command -v pdftoppm >/dev/null 2>&1; then
        pdftoppm -png -r "$DPI" "$BASENAME.pdf" "$BASENAME"
        mv "$BASENAME-1.png" "$INPUT_DIR/$BASENAME.png" 2>/dev/null || \
        mv "$BASENAME.png" "$INPUT_DIR/$BASENAME.png" 2>/dev/null || true
        echo "✅ PNG: $INPUT_DIR/$BASENAME.png (DPI=$DPI)"
      elif command -v convert >/dev/null 2>&1; then
        convert -density "$DPI" "$BASENAME.pdf" "$INPUT_DIR/$BASENAME.png"
        echo "✅ PNG: $INPUT_DIR/$BASENAME.png (ImageMagick)"
      else
        echo "⚠️  无 pdftoppm 或 ImageMagick，跳过 PNG 转换"
      fi
      ;;
    svg)
      if command -v pdf2svg >/dev/null 2>&1; then
        pdf2svg "$BASENAME.pdf" "$INPUT_DIR/$BASENAME.svg"
        echo "✅ SVG: $INPUT_DIR/$BASENAME.svg"
      elif command -v pdftocairo >/dev/null 2>&1; then
        pdftocairo -svg "$BASENAME.pdf" "$INPUT_DIR/$BASENAME.svg"
        echo "✅ SVG: $INPUT_DIR/$BASENAME.svg"
      else
        echo "⚠️  无 pdf2svg 或 pdftocairo，跳过 SVG 转换"
        echo "   安装: brew install pdf2svg  或  apt install pdf2svg"
      fi
      ;;
    pdf)
      # 已生成
      ;;
    *)
      echo "⚠️  未知格式: $fmt"
      ;;
  esac
done

echo "=== 渲染完成 ==="
