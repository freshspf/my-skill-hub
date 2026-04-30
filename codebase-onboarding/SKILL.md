---
name: codebase-onboarding
description: "Use when a developer (especially a new team member or intern) needs to systematically understand an unfamiliar Java/Spring Boot codebase. Guides the exploration order, document structure, and progress tracking to prevent context loss across sessions."
---

# codebase-onboarding

帮助开发者系统性地学习陌生 Java/Spring Boot 代码库，将探索过程沉淀为可复用的文档体系。

## When to Use

- 新入职开发者/实习生需要熟悉一个陌生项目
- 项目类型：**Java + Spring Boot**（其他技术栈不适用）
- 目标：快速理解项目定位、架构、核心链路，形成可持续查阅的文档

## Core Principles

1. **先读代码，再写文档** — 用 Bash/Read 工具实际探索，绝不凭空捏造
2. **progress.md 是防上下文超限的核心** — 每次 session 结束必须更新
3. **按固定顺序学习** — 从整体到局部，避免迷失在细节中
4. **文档编号累积** — 每篇文档有编号，便于跨 session 引用

## Learning Order

按以下顺序推进（不跳步骤）：

| 编号 | 主题 | 探索重点 |
|------|------|---------|
| 00 | 业务全景 | 这个服务是什么平台的哪个角色 / 上游调用方 / 下游依赖服务 / 核心业务节点 |
| 01 | 项目总览 | pom.xml / README / 顶层包结构 / 技术栈 |
| 02 | 分层架构 | 包结构分层 / 各层职责 / 对象流转规则 |
| 03 | 对外接口 | RPC/HTTP 接口入口文件 / 方法数量 / 业务域分组 |
| 04 | 核心业务链路 | 最重要业务的完整调用链 / 关键设计决策 |
| 05 | 数据层分工 | MySQL/Doris/ES/Redis 各自负责什么 / 查询路由规则 |
| 06 | 消息机制 | Kafka/RocketMQ 消费者 / Binlog 同步链路 |
| 07 | 定时任务 | job 目录 / 触发机制 / Apollo 动态开关 |
| 08+ | 子业务链路 | 根据项目选择：交易链路 / 创意中心 / 等 |

## Workflow

## 文档统一存放路径

所有项目的学习文档统一存放在：

```
~/Gitroom/项目理解/<项目名>/
```

例如：
- `~/Gitroom/项目理解/pgy_data_service/`
- `~/Gitroom/项目理解/note-trade-center/`

**不要**在项目代码仓库内创建 `learning-notes/` 目录。

### Step 1 — 初始化（仅第一次）

```bash
# 确定项目名（通常与 artifactId 或仓库名一致）
PROJECT_NAME="<项目名>"

# 创建学习文档目录（统一存放位置）
mkdir -p ~/Gitroom/项目理解/$PROJECT_NAME

# 查看项目顶层结构
ls -la
cat pom.xml | head -50

# 统计规模
find src/main/java -name "*.java" | wc -l
find src/main/java -name "*Service*.java" | wc -l
find src/main/java -name "*Repository*.java" | wc -l
```

创建 `~/Gitroom/项目理解/<项目名>/progress.md`（见下方模板）。

### Step 2 — 每次 Session 开始

**必须先读** `~/Gitroom/项目理解/<项目名>/progress.md`，了解：
- 已产出的文档
- 待探索的主题
- 关键路径速查

### Step 3 — 按编号探索并输出文档

每个主题探索完后，立即输出对应编号的文档到 `~/Gitroom/项目理解/<项目名>/` 目录。
文档结构见下方模板。

### Step 4 — Session 结束前更新 progress.md

更新以下内容：
- 文档索引表（新增行）
- 本次 Session 的关键结论
- 待探索清单（勾选已完成项，补充新发现的问题）
- 关键路径速查（新增重要类路径）

## Document Template

每篇文档（`~/Gitroom/项目理解/<项目名>/XX-topic.md`）的标准结构：

```markdown
# XX - [主题名称]

> **Session**: N | **日期**: YYYY-MM-DD
> **前置阅读**: [依赖的前置文档编号，如"00, 01"]
> **目标**: 理解 [本篇的具体学习目标]

---

## 1. 概览

[3-5句话总结本主题的核心结论]

## 2. [主体内容章节]

[实际代码探索结果，包含类路径、方法名、关键代码片段]

## 3. 关键设计决策

[为什么这样设计？有哪些值得注意的技术选型？]

## 4. 速查表

[本篇最常用的类路径、方法名、配置项]

---

> **下一步**: 建议探索 [XX+1 - 下一主题名称]
```

## progress.md Template

```markdown
# [项目名] 学习进度追踪

> **用途**: 防止上下文超限，每次对话开始前先读此文件。
> **更新规则**: 每次问答结束后更新本文档。
> **文档存放路径**: `~/Gitroom/项目理解/[项目名]/`

---

## 文档索引

| 编号 | 文件名 | 主题 | 状态 |
|------|--------|------|------|
| 00 | [00-business-context.md](./00-business-context.md) | 业务全景：平台定位与上下游关系 | 已完成 |
| 01 | [01-project-overview.md](./01-project-overview.md) | 项目总览 | 已完成 |

---

## 已掌握知识点

### [Session 0] - 业务全景

**关键结论**:
- 平台定位：
- 上游调用方：
- 下游依赖服务：
- 核心业务节点：

**产出**: [00-business-context.md](./00-business-context.md)

---

### [Session 1] - 项目总览

**关键结论**:
- 项目定位：
- 技术栈：
- 对外协议：
- 数据存储：
- 规模：

**产出**: [01-project-overview.md](./01-project-overview.md)

---

## 待探索清单

- [ ] 02 - 分层架构（各层职责 + 对象流转规则）
- [ ] 03 - 对外接口（RPC/HTTP 入口）
- [ ] 04 - 核心业务链路
- [ ] 05 - 数据层分工
- [ ] 06 - 消息机制
- [ ] 07 - 定时任务

---

## 关键路径速查

```
入口
├── RPC 入口   → [填写实际类路径]
├── HTTP 入口  → [填写实际类路径]
└── 定时任务   → [填写实际类路径]

核心包路径: [填写实际包名]
├── application/   接入层
├── service/       业务层
├── manager/       协调层（可选）
├── rpcclient/     下游客户端（可选）
└── dal/           数据访问层
    ├── repository/ ES
    ├── mapper/     Doris/MyBatis
    └── mysql/      MySQL
```

---

## 上下文续接指引

> 下次对话开始时，告诉 AI：
> "请先读 ~/Gitroom/项目理解/[项目名]/progress.md，然后继续帮我探索【待探索清单中的主题】"
```

## Exploration Commands

探索各主题时常用的 bash 命令：

```bash
# 顶层结构
ls src/main/java/com/[公司]/[项目]/

# 各层文件数
find src/main/java -path "*/service/impl/*.java" | wc -l
find src/main/java -path "*/dal/repository/impl/*.java" | wc -l
find src/main/java -path "*/application/job/*.java" | wc -l

# 读大文件入口（分段）
wc -l src/main/java/.../XxxServiceImpl.java
head -100 src/main/java/.../XxxServiceImpl.java

# 找对外接口入口
find src/main/java -name "*ServiceImpl.java" | grep -i "application\|thrift\|controller"

# 找 Kafka/RocketMQ 消费者
find src/main/java -name "*Consumer*.java" -o -name "*Listener*.java"

# 找定时任务
find src/main/java -name "*Job*.java" -o -name "*Task*.java" -o -name "*Scheduler*.java"

# 查看 application.yml 数据源配置
grep -n "datasource\|elasticsearch\|kafka\|rocketmq" src/main/resources/application.yml

# 统计 RPC 方法数量（Thrift 实现类的 @Override 方法）
grep -c "@Override" src/main/java/.../PgyDataServiceImpl.java
```

## Notes

- **上下文超限时的应对**：新开一个对话，第一句话告诉 AI "请先读 ~/Gitroom/项目理解/[项目名]/progress.md"
- **文档粒度**：每篇文档聚焦一个主题，宁可拆细也不要合并。单篇文档建议不超过 200 行
- **代码引用格式**：引用具体代码位置时使用 `文件路径:行号` 格式，便于跳转
- **适用范围**：仅限 Java/Spring Boot 项目。Go/Node.js 等其他技术栈请使用其他方法
