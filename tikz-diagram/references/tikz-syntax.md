# TikZ 语法速查

## 基础结构

```latex
\documentclass[tikz,border=10pt]{standalone}
\usetikzlibrary{positioning, arrows.meta, shapes, calc, backgrounds, fit}
\begin{document}
\begin{tikzpicture}[>=Stealth]
  % 你的代码
\end{tikzpicture}
\end{document}
```

## 节点

```latex
% 基本节点
\node (A) {Text};

% 带样式
\node[draw, fill=blue!20, rounded corners, minimum width=2cm] (A) {Text};

% 常用形状
\node[circle, draw] (A) {A};
\node[rectangle, draw] (B) {B};
\node[ellipse, draw] (C) {C};
\node[diamond, draw] (D) {D};
\node[trapezium, draw] (E) {E};
\node[cylinder, draw, shape border rotate=90] (F) {F};

% 带多行文字
\node[text width=2cm, align=center] (A) {第一行\\第二行};

% 带图标/emoji（需要 fontawesome 宏包）
\node {\faCog};
```

## 定位

```latex
% 绝对坐标
\node (A) at (0,0) {A};
\node (B) at (3,2) {B};

% 相对定位（需 positioning 库）
\node[right=of A] (B) {B};
\node[below=1cm of A] (C) {C};
\node[above left=of A] (D) {D};

% 锚点定位
\node[below right=of A.south] (B) {B};
```

## 连线

```latex
% 基本连线
\draw (A) -- (B);

% 箭头
\draw[->] (A) -- (B);          % 单向
\draw[<->] (A) -- (B);         % 双向
\draw[->, dashed] (A) -- (B);  % 虚线箭头
\draw[->, dotted] (A) -- (B);  % 点线箭头
\draw[->, thick, red] (A) -- (B); % 粗红线

% 弯曲连线
\draw[->, bend left=30] (A) to (B);
\draw[->, bend right=45] (A) to (B);
\draw[->] (A) to[out=30, in=150] (B);

% 折线
\draw[->] (A) |- (B);  % 先垂直到B的y，再水平到B
\draw[->] (A) -| (B);  % 先水平到B的x，再垂直到B

% 连线加标签
\draw[->] (A) -- node[above] {label} (B);
\draw[->] (A) -- node[right, pos=0.3] {start} node[left, pos=0.7] {end} (B);
```

## 样式复用

```latex
% 定义样式
\tikzset{
  box/.style = {draw, fill=blue!20, rounded corners, minimum width=2cm, minimum height=1cm},
  decision/.style = {draw, fill=yellow!30, diamond, minimum width=1.5cm},
  arrow/.style = {->, thick, >=Stealth},
  dashed arrow/.style = {->, dashed, thick, >=Stealth, gray},
}

% 使用
\node[box] (A) {A};
\draw[arrow] (A) -- (B);
```

## 分组 / 背景

```latex
% 使用 fit 库创建包围框
\begin{scope}[on background layer]
  \node[draw, fill=gray!10, rounded corners, fit=(A) (B) (C), inner sep=10pt, label={above:Group}] {};
\end{scope}

% 带标题的背景
\node[draw=none, fill=blue!5, rounded corners, fit=(A) (B), inner sep=15pt] (group1) {};
\node[below right=0pt of group1.north west, fill=blue!20, text=blue!70!black, font=\small, inner sep=2pt] {模块 A};
```

## 矩阵布局

```latex
\usetikzlibrary{matrix}
\matrix (m) [matrix of nodes, row sep=1cm, column sep=1cm, nodes={draw, minimum size=1cm}] {
  A & B & C \\
  D & E & F \\
  G & H & I \\
};
```

## 常用库

```latex
\usetikzlibrary{
  positioning,    % 相对定位
  arrows.meta,    % 箭头样式
  shapes,         % 各种形状
  calc,           % 坐标计算
  backgrounds,    % 背景层
  fit,            % 包围框
  matrix,         % 矩阵布局
  decorations.pathreplacing, % 花括号标注
  patterns,       % 填充图案
  shadows,        % 阴影效果
  chains,         % 链式布局
}
```

## 花括号标注

```latex
\draw[decorate, decoration={brace, amplitude=10pt}] (A.north) -- (B.north)
  node[midway, above=10pt, font=\small] {标注文字};

% 反向花括号
\draw[decorate, decoration={brace, amplitude=10pt, mirror}] (A.south) -- (B.south)
  node[midway, below=10pt, font=\small] {标注文字};
```

## 阴影与渐变

```latex
% 阴影
\node[draw, fill=blue!20, drop shadow] (A) {A};

% 渐变填充
\usetikzlibrary{shadings}
\node[shade, top color=blue!50, bottom color=blue!10, draw] (A) {A};

% 圆角阴影
\node[draw, rounded corners, fill=blue!20, drop shadow={shadow xshift=2pt, shadow yshift=-2pt}] (A) {A};
```

## 中文支持

```latex
% 在导言区使用
\usepackage{ctex}
% 或
\usepackage{xeCJK}
\setCJKmainfont{Noto Sans CJK SC}  % 思源黑体
\setCJKsansfont{Noto Sans CJK SC}
```
