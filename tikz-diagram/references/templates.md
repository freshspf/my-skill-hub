# TikZ Diagram 通用图表生成模板

## 模板系统

### 模板一：顶会论文模板 (conference-paper)
**适用场景**：学术论文、技术报告、期刊投稿
**设计特点**：
- 简洁专业，重点突出
- 黑白为主，彩色点缀
- 适合黑白印刷
- 清晰的层次结构

**配色方案**：
```latex
\definecolor{primary}{HTML}{2C3E50}    % 深灰主色
\definecolor{accent1}{HTML}{3498DB}    % 蓝色强调
\definecolor{accent2}{HTML}{E74C3C}    % 红色强调  
\definecolor{accent3}{HTML}{27AE60}    % 绿色强调
\definecolor{lightbg}{HTML}{ECF0F1}    % 浅色背景
```

---

### 模板二：技术演讲模板 (tech-presentation)
**适用场景**：技术演讲、会议分享、产品展示
**设计特点**：
- 现代扁平风格
- 明亮配色，视觉冲击力强
- 大字体，易远距离观看
- 投影友好

**配色方案**：
```latex
\definecolor{primary}{HTML}{6366F1}    % 现代蓝
\definecolor{secondary}{HTML}{8B5CF6}  % 紫色
\definecolor{accent1}{HTML}{06B6D4}    % 青色
\definecolor{accent2}{HTML}{10B981}    % 绿色
\definecolor{accent3}{HTML}{F59E0B}    % 橙色
\definecolor{lightbg}{HTML}{F8FAFC}    % 极浅背景
```

---

### 模板三：科技未来模板 (futuristic-tech)
**适用场景**：前沿技术展示、AI/ML 系统架构
**设计特点**：
- 科技感强烈
- 渐变效果
- 深色背景
- 霓虹色调

**配色方案**：
```latex
\definecolor{primary}{HTML}{0EA5E9}    % 亮蓝
\definecolor{secondary}{HTML}{6366F1}  % 靛蓝
\definecolor{accent1}{HTML}{8B5CF6}    % 紫色
\definecolor{accent2}{HTML}{EC4899}    % 粉色
\definecolor{accent3}{HTML}{14B8A6}    % 青绿
\definecolor{darkbg}{HTML}{0F172A}     % 深色背景
```

---

## 模板选择流程

1. **分析用户需求**
   - 询问使用场景
   - 确定图表类型
   - 了解色彩偏好

2. **推荐模板**
   - 根据场景推荐最合适的模板
   - 展示模板特点
   - 提供配色方案预览

3. **用户确认**
   - 展示选定的模板配色
   - 等待用户确认
   - 支持用户自定义调整

4. **生成图表**
   - 应用确认的模板
   - 生成自适应大小的图表
   - 输出多种格式

## 图表类型支持

### 架构类
- 系统架构图
- 软件架构图  
- 网络拓扑图
- 分层架构图

### 流程类
- 业务流程图
- 算法流程图
- 数据流程图
- 时序图

### 结构类
- 类图
- ER 图
- 思维导图
- 组织结构图

### 数据类
- 统计图表
- 仪表盘
- 数据可视化
- 仪表板