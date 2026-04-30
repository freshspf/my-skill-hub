# TikZ 流程图模式

## 模式一：标准流程图

```latex
\begin{tikzpicture}[
  >=Stealth, node distance=1cm,
  startstop/.style={draw=#1!70, fill=#1!20, rounded rectangle, minimum width=2cm, minimum height=0.7cm, text=#1!80!black, font=\sffamily},
  process/.style={draw=#1!70, fill=#1!15, rectangle, rounded corners=3pt, minimum width=2.2cm, minimum height=0.7cm, text=#1!80!black, font=\sffamily},
  decision/.style={draw=#1!70, fill=#1!15, diamond, aspect=2.5, minimum width=2cm, text=#1!80!black, font=\sffamily, inner sep=1pt},
  io/.style={draw=#1!70, fill=#1!10, trapezium, trapezium left angle=70, trapezium right angle=110, minimum width=1.8cm, minimum height=0.6cm, text=#1!80!black, font=\sffamily},
  arrow/.style={->, >=Stealth, thick, draw=#1!70},
]

% 流程节点
\node[startstop=blue] (start) {开始};
\node[io=orange, below=of start] (input) {输入数据};
\node[process=green, below=of input] (process1) {数据预处理};
\node[decision=blue, below=of process1] (check) {质量合格?};
\node[process=green, below=of check] (process2) {模型推理};
\node[process=green, left=1.5cm of check] (retry) {重新采集};
\node[io=orange, below=of process2] (output) {输出结果};
\node[startstop=blue, below=of output] (end) {结束};

% 连线
\draw[arrow=cblue] (start) -- (input);
\draw[arrow=cblue] (input) -- (process1);
\draw[arrow=cblue] (process1) -- (check);
\draw[arrow=cgreen] (check) -- node[right, font=\sffamily\footnotesize, text=gray] {是} (process2);
\draw[arrow=cblue] (process2) -- (output);
\draw[arrow=cblue] (output) -- (end);

% 分支
\draw[arrow=cred] (check) -- node[above, font=\sffamily\footnotesize, text=gray] {否} (retry);
\draw[arrow=cred] (retry) |- (input);

\end{tikzpicture}
```

## 模式二：带泳道的流程图

```latex
\begin{tikzpicture}[
  >=Stealth,
  lane/.style={draw=gray!30, fill=#1!3, minimum width=10cm, minimum height=2cm},
  lane label/.style={font=\sffamily\bfseries, text=gray, rotate=90},
  process/.style={draw=#1!70, fill=#1!15, rounded corners=3pt, minimum height=0.5cm, minimum width=1.5cm, text=#1!80!black, font=\sffamily\footnotesize},
]

% 泳道
\node[lane=blue, minimum height=1.5cm] (client) {};
\node[lane label, anchor=south] at (client.west) {Client};
\node[lane=green, below=0cm of client, minimum height=1.5cm] (server) {};
\node[lane label, anchor=south] at (server.west) {Server};
\node[lane=orange, below=0cm of server, minimum height=1.5cm] (db) {};
\node[lane label, anchor=south] at (db.west) {Database};

% 节点
\node[process=blue] (req) at ($(client.center)$) {发送请求};
\node[process=green] (handle) at ($(server.center) + (2,0)$) {处理请求};
\node[process=orange] (query) at ($(db.center) + (2,0)$) {查询数据};
\node[process=green] (resp) at ($(server.center) + (-2,0)$) {返回响应};
\node[process=blue] (display) at ($(client.center) + (-2,0)$) {展示结果};

% 连线（跨泳道）
\draw[->, thick, cblue!60] (req) -- (handle);
\draw[->, thick, cgreen!60] (handle) -- (query);
\draw[->, thick, corange!60] (query) -- (resp);
\draw[->, thick, cgreen!60] (resp) -- (display);

\end{tikzpicture}
```

## 模式三：水平流程图

```latex
\begin{tikzpicture}[
  >=Stealth, node distance=1.5cm,
  step/.style={draw=#1!70, fill=#1!15, rounded corners=4pt,
               minimum height=0.7cm, minimum width=2cm,
               text=#1!80!black, font=\sffamily,
               drop shadow={shadow xshift=1pt, shadow yshift=-1pt, opacity=0.2}},
  arrow/.style={->, >=Stealth, thick, draw=#1!60},
]

\node[step=blue] (s1) {数据采集};
\node[step=blue, right=of s1] (s2) {数据清洗};
\node[step=green, right=of s2] (s3) {特征提取};
\node[step=orange, right=of s3] (s4) {模型训练};
\node[step=red, right=of s4] (s5) {结果评估};

\draw[arrow=cblue] (s1) -- (s2);
\draw[arrow=cblue] (s2) -- (s3);
\draw[arrow=cgreen] (s3) -- (s4);
\draw[arrow=corange] (s4) -- (s5);

% 编号
\node[above=0.3cm of s1, font=\footnotesize, text=gray] {1};
\node[above=0.3cm of s2, font=\footnotesize, text=gray] {2};
\node[above=0.3cm of s3, font=\footnotesize, text=gray] {3};
\node[above=0.3cm of s4, font=\footnotesize, text=gray] {4};
\node[above=0.3cm of s5, font=\footnotesize, text=gray] {5};

\end{tikzpicture}
```

## 模式四：带循环的流程图

```latex
\begin{tikzpicture}[
  >=Stealth, node distance=1.2cm,
  process/.style={draw=#1!70, fill=#1!15, rounded corners=3pt,
                  minimum height=0.6cm, minimum width=1.8cm,
                  text=#1!80!black, font=\sffamily},
  decision/.style={draw=#1!70, fill=#1!15, diamond, aspect=2,
                   text=#1!80!black, font=\sffamily, inner sep=2pt},
  arrow/.style={->, >=Stealth, thick, draw=#1!70},
]

\node[process=blue] (init) {初始化};
\node[process=green, below=of init] (train) {训练一轮};
\node[process=green, below=of train] (eval) {评估指标};
\node[decision=orange, below=of eval] (converged) {收敛?};
\node[process=blue, right=1.5cm of converged] (save) {保存模型};
\node[process=blue, below=of save] (done) {结束};

\draw[arrow=cblue] (init) -- (train);
\draw[arrow=cgreen] (train) -- (eval);
\draw[arrow=cgreen] (eval) -- (converged);
\draw[arrow=cblue] (converged) -- node[above, font=\sffamily\footnotesize] {是} (save);
\draw[arrow=cblue] (save) -- (done);

% 循环回路
\draw[arrow=cred] (converged) -- node[right, font=\sffamily\footnotesize] {否} ++(1.5,0) |- (train.east);

\end{tikzpicture}
```

## 快速模板

复制后改节点名称和文本即可：

```latex
\documentclass[tikz,border=10pt]{standalone}
\usepackage{ctex}
\usepackage{tikz}
\usetikzlibrary{positioning, arrows.meta, shapes, calc, backgrounds, fit, shadows}

\definecolor{cblue}{HTML}{2196F3}
\definecolor{cgreen}{HTML}{4CAF50}
\definecolor{corange}{HTML}{FF9800}

\tikzset{
  process/.style={draw=#1!70, fill=#1!15, rounded corners=3pt, minimum height=0.7cm, minimum width=2cm, text=#1!80!black, font=\sffamily},
  decision/.style={draw=#1!70, fill=#1!15, diamond, aspect=2, text=#1!80!black, font=\sffamily, inner sep=2pt},
  arrow/.style={->, >=Stealth, thick, draw=#1!70},
}

\begin{document}
\begin{tikzpicture}[>=Stealth, node distance=1.2cm]
  % 在这里写你的流程图
\end{tikzpicture}
\end{document}
```
