# 顶会论文配色方案

## CVPR / 计算机视觉风格

适合：系统架构图、pipeline 图、模型结构图

```latex
% CVPR 风格配色定义
\definecolor{cvprblue}{HTML}{2196F3}
\definecolor{cvprgreen}{HTML}{4CAF50}
\definecolor{cvprorange}{HTML}{FF9800}
\definecolor{cvprred}{HTML}{F44336}
\definecolor{cvprpurple}{HTML}{9C27B0}
\definecolor{cvprteal}{HTML}{009688}
\definecolor{cvprgray}{HTML}{9E9E9E}
\definecolor{cvprbg}{HTML}{F5F5F5}
```

| 元素 | 填充色 | 边框色 |
|------|--------|--------|
| 主模块 | `#2196F3` (蓝) | `#1976D2` |
| 处理模块 | `#4CAF50` (绿) | `#388E3C` |
| 数据/输入 | `#FF9800` (橙) | `#F57C00` |
| 输出/结果 | `#9C27B0` (紫) | `#7B1FA2` |
| 背景组 | `#E3F2FD` (浅蓝) | `#BBDEFB` |
| 辅助元素 | `#F5F5F5` (灰白) | `#E0E0E0` |

## NeurIPS / 学术极简风格

适合：理论推导图、算法流程图

```latex
% NeurIPS 风格：低饱和度、黑白灰为主、少量点缀
\definecolor{nipsblue}{HTML}{1E88E5}
\definecolor{nipsdark}{HTML}{212121}
\definecolor{nipsmid}{HTML}{757575}
\definecolor{nipslight}{HTML}{E0E0E0}
\definecolor{nipsbg}{HTML}{FAFAFA}
\definecolor{nipsaccent}{HTML}{FF6F00}
```

特点：大量留白、低饱和色、单色系为主、偶尔用橙色点缀

## Nature / Science 风格

适合：高质量学术期刊插图

```latex
% Nature 风格：典雅、专业
\definecolor{natureblue}{HTML}{005EB8}
\definecolor{naturered}{HTML}{E4002B}
\definecolor{naturegreen}{HTML}{009639}
\definecolor{natureorange}{HTML}{E87722}
\definecolor{naturepurple}{HTML}{8967B0}
\definecolor{naturegray}{HTML}{B5B5B5}
```

## 通用高质量配色

```latex
% 定义完整配色体系
\tikzset{
  % 模块颜色
  primary/.style = {fill=#1!20, draw=#1!80, text=#1!80!black},
  primary/.default = blue,

  % 预设模块
  blue box/.style = {primary=blue, rounded corners},
  green box/.style = {primary=green!70!black, rounded corners},
  orange box/.style = {primary=orange, rounded corners},
  red box/.style = {primary=red, rounded corners},
  purple box/.style = {primary=purple, rounded corners},
  teal box/.style = {primary=teal, rounded corners},

  % 连线
  solid arrow/.style = {->, >=Stealth, thick, draw=#1!80!black},
  solid arrow/.default = blue,
  dashed arrow/.style = {->, >=Stealth, thick, dashed, draw=gray},
  data flow/.style = {->, >=Stealth, thick, draw=orange!80!black},
  control flow/.style = {->, >=Stealth, thick, draw=blue!80!black},

  % 背景组
  group bg/.style = {fill=#1!8, draw=#1!30, rounded corners},
  group bg/.default = blue,

  % 标签
  label/.style = {font=\small, text=#1!80!black},
  label/.default = gray,
}
```

## 配色原则

1. **不超过 5 种主色** — 太多颜色会显得杂乱
2. **同色系渐变** — 用同一颜色的不同浓度表示层次
3. **低饱和背景 + 高饱和重点** — 背景用 `!10` ~ `!20`，重点用 `!60` ~ `!80`
4. **边框色 = 填充色加深** — `fill=blue!20, draw=blue!80`
5. **文字色 = 边框色再加深** — `text=blue!80!black`
6. **留白是关键** — `inner sep=8pt` 起步，组之间至少 1cm 间距

## 一键设置示例

```latex
\begin{tikzpicture}[
  >=Stealth,
  node distance=1.5cm,
  every node/.style={font=\small},
  box/.style={draw, rounded corners, fill=#1!15, minimum height=0.8cm, minimum width=2cm, text=#1!80!black},
  arrow/.style={->, thick, draw=#1!70!black},
]
```
