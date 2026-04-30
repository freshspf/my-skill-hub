---
name: tikz-diagram
description: >
  通用图表生成技能 - 从自然语言描述生成高质量 TikZ 矢量图。
  支持多种图表类型（架构图、流程图、系统图、数据流图、时序图等），
  提供多套专业配色方案和多场景模板，输出 PDF/PNG/SVG 格式。
  触发词：画图、架构图、流程图、系统图、tikz、图表、可视化、diagram。
  
## 环境自动检测与修复

**首次使用前，技能会自动检查并修复环境**：
```bash
# 自动检测 LaTeX 环境
if ! command -v xelatex >/dev/null 2>&1 && ! command -v pdflatex >/dev/null 2>&1; then
    echo "检测到未安装 LaTeX，开始自动安装..."
    bash <skill_dir>/scripts/auto-setup.sh
fi
```

如果编译失败，会自动诊断并提供修复建议：
- 缺少 standalone 宏包 → 自动安装
- 缺少 ctex 宏包 → 自动安装  
- 中文字体问题 → 安装 Noto Sans CJK
- ImageMagick 缺失 → 提供 brew install 命令
---

# TikZ Diagram Generator - 通用图表生成工具

从自然语言描述生成高质量 TikZ 矢量图，支持多种图表类型、配色方案和输出格式。

## 环境检测

首次使用时，检测 LaTeX 环境：
```bash
command -v xelatex >/dev/null 2>&1 || command -v pdflatex >/dev/null 2>&1
```
若未安装，引导用户运行：
```bash
# macOS (Homebrew)
bash <skill_dir>/scripts/setup.sh

# 手动安装
brew install --cask basictex
sudo tlmgr install pgf xcolor graphicx ctex xecjk fontspec
brew install --cask font-noto-sans-cjk-sc   # 中文字体
```

## 快速开始

**首次使用（3分钟配置）**：
```bash
# 1. 运行环境诊断
bash <skill_dir>/scripts/check-env.sh

# 2. 自动安装缺失组件
bash <skill_dir>/scripts/auto-setup.sh

# 3. 验证环境
bash <skill_dir>/scripts/check-env.sh
```

**日常使用（1步生成）**：
- 只需说出需求：`画个前端到后端到数据库的架构图`
- 技能自动生成 TikZ 代码 → 编译 → 输出 PDF + PNG

## 核心工作流程

### 0. 模板与配色选择

**首先询问用户需求**：
```bash
# 询问使用场景
"这个图表用于什么场景？学术论文、技术演讲、项目文档？"

# 推荐模板并确认
"根据场景，我推荐使用 [模板名称]，配色方案如下：
- [配色方案1] 
- [配色方案2]
请确认或提供自定义配色要求。"
```

**模板选择参考**：
- 学术论文 → `conference-paper` 模板
- 技术演讲 → `tech-presentation` 模板  
- 产品展示 → `futuristic-tech` 模板

### 1. 理解图表需求

从用户描述中提取：
- **图表类型**：架构图、流程图、时序图、ER图、思维导图等
- **内容元素**：节点、连接、层级、标注
- **设计要求**：尺寸、风格、特殊效果
- **输出格式**：PDF（打印）、PNG（预览）、SVG（网页/可缩放）

### 2. 选择合适的图表结构

| 图表需求 | TikZ 实现方式 |
|----------|---------------|
| 系统架构 | `positioning` 相对定位 + `fit` 分组 |
| 数据流程 | 链式节点 + 弯曲箭头路径 |
| 算法逻辑 | `decision` 菱形 + 分支条件 |
| 层次结构 | `matrix` 矩阵布局 + 背景分层 |
| 时间序列 | 水平链式 + 时间标注 |
| 组织关系 | 树状结构 + 层级连线 |

### 3. 应用模板生成代码

使用选定模板的配色和样式规范：
```latex
% 引入模板配色
\input <skill_dir>/templates/[template-name].sty

% 自适应大小设置
\usepackage[viewport={width=\maxwidth,height=\maxheight}]{geometry}
```

### 4. 智能编译与输出

支持多种输出格式：
```bash
# PDF + PNG (默认)
bash <skill_dir>/scripts/render.sh figure.tex

# SVG 矢量图 (可缩放)
bash <skill_dir>/scripts/render.sh figure.tex --format svg

# 高清输出 (600 DPI)
bash <skill_dir>/scripts/render.sh figure.tex --dpi 600

# 自适应大小
bash <skill_dir>/scripts/render.sh figure.tex --auto-scale
```

## 常见问题

### 编译报错 "Package pgf Error"
通常是语法错误。检查：括号配对、节点引用是否存在、库是否正确加载。

### 自动错误诊断与修复

**常见问题智能解决方案**：

#### 1. 编译报错自动修复
```bash
# 检查并安装缺失的宏包
check_and_install_package() {
    local package=$1
    if ! kpsewhich ${package}.sty >/dev/null 2>&1; then
        echo "安装 ${package}..."
        sudo tlmgr install ${package}
    fi
}

# 自动修复编译环境
auto_fix_environment() {
    check_and_install_package "standalone"
    check_and_install_package "ctex"
    check_and_install_package "tikz"
}
```

#### 2. 中文字体问题
- **检测**：`fc-list :lang=zh`
- **自动安装**：`brew install --cask font-noto-sans-cjk-sc`
- **配置优化**：自动添加 `\setCJKmainfont{Noto Sans CJK SC}` 到中文文档

#### 3. 图片尺寸调整
```bash
# 自动缩放算法
auto_scale() {
    local width=$(pdfinfo "$1" | grep "Page size" | awk '{print $3}')
    if [ ${width%.*} -gt 800 ]; then
        echo "使用 scale=0.6"
        return 0.6
    elif [ ${width%.*} -gt 400 ]; then
        echo "使用 scale=0.8"
        return 0.8
    else
        echo "使用 scale=1.0"
        return 1.0
    fi
}
```

#### 4. 布局优化建议
- 使用 `node distance=1.2cm` 统一间距
- 使用 `matrix` 做规则排列
- 使用 `fit` + `backgrounds` 做分组
- 自动计算节点位置，避免重叠

#### 5. 输出文件管理
- 自动清理临时文件
- 智能文件命名（基于内容哈希）
- 保留源码和输出文件的对应关系
