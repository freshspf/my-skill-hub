# TikZ 架构图模式

## 模式一：分层架构（Layered Architecture）

最经典的论文架构图，适合展示系统的分层设计。

```latex
\begin{tikzpicture}[
  >=Stealth, node distance=1cm,
  layer/.style={draw=#1!50, fill=#1!8, rounded corners=4pt, inner sep=8pt},
  module/.style={draw=#1!70, fill=#1!20, rounded corners=3pt, 
                 minimum height=0.6cm, minimum width=1.8cm,
                 text=#1!80!black, font=\small\sffamily},
]

% 定义各层
\node[layer=blue, minimum width=8cm] (presentation) {
  \begin{tikzpicture}
    \node[module=blue] (web) {Web App};
    \node[module=blue, right=0.3cm of web] (mobile) {Mobile};
    \node[module=blue, right=0.3cm of mobile] (api) {API};
  \end{tikzpicture}
};
\node[layer=green, below=0.5cm of presentation, minimum width=8cm] (services) {
  \begin{tikzpicture}
    \node[module=green] (auth) {Auth};
    \node[module=green, right=0.3cm of auth] (logic) {Business Logic};
    \node[module=green, right=0.3cm of logic] (ml) {ML Engine};
  \end{tikzpicture}
};
\node[layer=orange, below=0.5cm of services, minimum width=8cm] (data) {
  \begin{tikzpicture}
    \node[module=orange] (db) {Database};
    \node[module=orange, right=0.3cm of db] (cache) {Cache};
    \node[module=orange, right=0.3cm of cache] (queue) {Message Queue};
  \end{tikzpicture}
};

% 层间连线
\draw[->, thick, blue!60] (logic|-presentation.south) -- (logic|-services.north);
\draw[->, thick, green!60] (logic|-services.south) -- (logic|-data.north);

\end{tikzpicture}
```

## 模式二：Pipeline / 数据流图

适合展示模型的训练流程、数据处理 pipeline。

```latex
\begin{tikzpicture}[
  >=Stealth, node distance=1.5cm,
  step/.style={draw=#1!70, fill=#1!15, rounded corners=4pt,
               minimum height=0.8cm, minimum width=2cm,
               text=#1!80!black, font=\small\sffamily,
               drop shadow={shadow xshift=1pt, shadow yshift=-1pt, opacity=0.2}},
  arrow/.style={->, >=Stealth, thick, draw=#1!70},
]

% 链式流程
\node[step=blue] (input) {Raw Input};
\node[step=green, right=of input] (preprocess) {Preprocessing};
\node[step=orange, right=of preprocess] (encoder) {Encoder};
\node[step=purple, right=of encoder] (model) {Model};
\node[step=red, right=of model] (output) {Prediction};

% 连线
\foreach \from/\to in {input/preprocess, preprocess/encoder, encoder/model, model/output} {
  \draw[arrow=cblue] (\from) -- (\to);
}

% 标注
\node[above=0.3cm of preprocess, font=\footnotesize, text=gray] {Step 1};
\node[above=0.3cm of encoder, font=\footnotesize, text=gray] {Step 2};
\node[above=0.3cm of model, font=\footnotesize, text=gray] {Step 3};

\end{tikzpicture}
```

## 模式三：神经网络架构图

适合展示深度学习模型的多层结构。

```latex
\begin{tikzpicture}[
  >=Stealth,
  neuron/.style={circle, draw=#1!70, fill=#1!20, minimum size=0.5cm},
  layer label/.style={font=\small\sffamily, text=gray},
]

\def\layersep{2.5cm}
\def\nodesp{0.4cm}

% 输入层
\foreach \y in {1,2,3} {
  \node[neuron=blue] (I\y) at (0, \y*\nodesp) {};
}
\node[layer label, below=0.3cm of I1] {Input};

% 隐藏层 1
\foreach \y in {1,2,3,4} {
  \node[neuron=green] (H1\y) at (\layersep, \y*\nodesp-\nodesp/2) {};
}
\node[layer label, below=0.3cm of H11] {Hidden 1};

% 隐藏层 2
\foreach \y in {1,2,3} {
  \node[neuron=orange] (H2\y) at (2*\layersep, \y*\nodesp) {};
}
\node[layer label, below=0.3cm of H21] {Hidden 2};

% 输出层
\node[neuron=red] (O1) at (3*\layersep, 2*\nodesp) {};
\node[layer label, below=0.3cm of O1] {Output};

% 全连接
\foreach \i in {1,2,3} \foreach \j in {1,2,3,4} {
  \draw[->, blue!20, thin] (I\i) -- (H1\j);
}
\foreach \i in {1,2,3,4} \foreach \j in {1,2,3} {
  \draw[->, green!20, thin] (H1\i) -- (H2\j);
}
\foreach \i in {1,2,3} {
  \draw[->, orange!40, thick] (H2\i) -- (O1);
}

\end{tikzpicture}
```

## 模式四：模块交互图

适合展示微服务之间的调用关系、系统组件交互。

```latex
\begin{tikzpicture}[
  >=Stealth, node distance=1.5cm,
  service/.style={draw=#1!70, fill=#1!15, rounded corners=4pt,
                  minimum height=1cm, minimum width=2.2cm,
                  text=#1!80!black, font=\sffamily,
                  drop shadow={shadow xshift=1pt, shadow yshift=-1pt, opacity=0.3}},
  db/.style={draw=#1!70, fill=#1!10, 
             cylinder, shape border rotate=90, aspect=0.3,
             minimum height=0.8cm, minimum width=1.5cm,
             text=#1!80!black, font=\sffamily},
  arrow/.style={->, >=Stealth, thick, draw=#1!60},
]

% 服务节点
\node[service=blue] (gateway) {API Gateway};
\node[service=green, below right=of gateway] (auth) {Auth Service};
\node[service=green, below left=of gateway] (user) {User Service};
\node[service=orange, below=of auth] (order) {Order Service};

% 数据库
\node[db=cgray, below=of user] (userdb) {User DB};
\node[db=cgray, below=of order] (orderdb) {Order DB};

% 调用关系
\draw[arrow=blue] (gateway) -- node[above right, font=\footnotesize, text=gray] {HTTP} (auth);
\draw[arrow=blue] (gateway) -- node[above left, font=\footnotesize, text=gray] {HTTP} (user);
\draw[arrow=green] (auth) -- (order);
\draw[dashed, arrow=cgray] (user) -- (userdb);
\draw[dashed, arrow=cgray] (order) -- (orderdb);

\end{tikzpicture}
```

## 模式五：对比图（Before / After 或 Method A vs B）

适合论文中展示方法对比、消融实验设计。

```latex
\begin{tikzpicture}[
  >=Stealth,
  side/.style={draw=#1!50, fill=#1!5, rounded corners=6pt, inner sep=10pt, minimum width=5cm},
  block/.style={draw=#1!70, fill=#1!20, rounded corners=3pt,
                minimum height=0.5cm, minimum width=1.5cm,
                text=#1!80!black, font=\small\sffamily},
]

% 左侧：Baseline
\node[side=gray, minimum height=3cm] (left) {
  \begin{tikzpicture}
    \node[block=gray] (a) {Block A};
    \node[block=gray, right=0.3cm of a] (b) {Block B};
    \node[block=gray, below=0.5cm of a] (c) {Block C};
    \draw[->, thick, gray] (a) -- (b);
    \draw[->, thick, gray] (a) -- (c);
  \end{tikzpicture}
};
\node[font=\sffamily\bfseries, text=gray, above=0.2cm of left] {Baseline};

% 右侧：Ours
\node[side=blue, right=1cm of left, minimum height=3cm] (right) {
  \begin{tikzpicture}
    \node[block=blue] (a) {Block A};
    \node[block=blue, right=0.3cm of a] (b) {Block B};
    \node[block=blue, below=0.5cm of a] (c) {Block C};
    \node[block=orange, above=0.5cm of b] (new) {New Module};
    \draw[->, thick, blue] (a) -- (b);
    \draw[->, thick, blue] (a) -- (c);
    \draw[->, thick, orange] (new) -- (b);
    \draw[->, dashed, thick, orange] (new) to[out=180, in=90] (a);
  \end{tikzpicture}
};
\node[font=\sffamily\bfseries, text=blue, above=0.2cm of right] {Ours};

\end{tikzpicture}
```

## 设计技巧

1. **标题**：在图顶部用 `\node[font=\large\sffamily\bfseries]` 添加标题
2. **图注**：用 `label=above:xxx` 或单独节点添加说明
3. **编号**：论文中常用 `(a)`, `(b)` 标注子图，用 `\node at (x,y) {\textbf{(a)}};`
4. **对齐**：用 `positioning` 库的 `of` 语法，避免绝对坐标
5. **间距**：模块间至少 0.3cm，组间至少 0.5cm
6. **字号**：正文字号 `\small` 或 `\footnotesize`，标题 `\large`
