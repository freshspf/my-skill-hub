# AGENTS.md 编写指南

## 定位

AGENTS.md 是 AI 与**项目**之间的协作契约——不是知识库，也不是个人偏好集合。

每次会话开始时，AI 会把 AGENTS.md 全部加载进上下文。文件越长，有效上下文越少，关键指令越容易被稀释。Anthropic 官方自己的 CLAUDE.md 大约只有 2.5K tokens（约 80 行），是很好的参照。

### 写作来源

所有内容都必须能在项目仓库里找到对应证据。优先读这些来源：

- `package.json` / `lerna.json`：取脚本命令、技术栈、包管理器
- `README.md`：取项目定位、启动流程
- 现有 `AGENTS.md` / `CLAUDE.md`：保留有效约定，剔除过期/重复内容
- 源码目录结构：判断模块边界、规范应该挂到哪个 rules 文件
- `git log` / `agent_docs/cases/`：识别真实事故，不要凭印象编

不要把以下内容拼进 AGENTS.md：

- 用户的全局个人配置（`~/.claude/CLAUDE.md`、`~/.config/codewiz/` 等）—— 个人偏好不属于项目契约
- 当前会话的环境注入（"今天是 2026/04/28" 之类的当前日期）—— AGENTS.md 是长期文件，不带绝对时间
- 训练数据里的"通用最佳实践"—— 仓库里没有依据就不写

### 与 CLAUDE.md 的关系

推荐 `AGENTS.md` 作为项目的 AI 指令主文件（工具中立的命名），`CLAUDE.md` 通过软链接指向它：

```bash
ln -s AGENTS.md CLAUDE.md
```

这样所有 AI 工具（Claude Code、Cursor、CodeWiz、OpenCode、Kiro 等）都使用同一份指令，一处维护、多端共享。

## 推荐结构与顺序

顺序很重要——越靠前的内容 AI 越重视：

```markdown
# 项目概述

一句话说清楚项目是什么，给谁用的。

## Build & Test

- 安装依赖：`yarn install`
- 开发启动：`yarn dev`
- Lint 修复（全量）：`npx formula lint --fix`
- Lint 修复（指定文件）：`npx formula lint --fix --file <文件1> <文件2> ...`
- 类型检查（全量）：`yarn type-check`（约 20-30s）
- 类型检查（指定文件）：`yarn type-check <文件1> <文件2> ...`（约 5-10s）

**验收标准**：每次任务完成后，对修改的文件跑指定文件版本的 lint 和 type-check 必须全部通过。

> 提供「全量」和「指定文件」两套命令很关键：AI 修改少量文件时跑指定文件版本节省时间，PR 提交前再跑全量。只给全量命令会让 AI 总是等几十秒。

## 技术栈

- 组件库：xxx
- 包管理器：xxx

## 开发工作流程

（如果有强制工作流，比如 ptdd，放这里）

## 事故案例库

（高风险场景的预警 + 链接，不要内联全文）

- 🔴 **P0**: [xxx事故](agent_docs/cases/xxx.md) - **处理 XX 时必须先看**

**沉淀触发**：当本次任务的**目标本身就是修复线上/已知 bug**（commit 类型为 fix，不是 feat / refactor / chore），完成后必须主动询问用户："这个 bug 是否要沉淀到 `agent_docs/cases/`？" 由用户决定写不写。

> 不适用场景：开发新需求过程中，用户口头纠正 AI 写错的代码——这类是协作过程的修正，不是真实事故，不要弹这个提醒。判断依据是**任务的初始目标**，不是过程中的修正动作。

## ALWAYS

（正向强约束，每条一行）

## NEVER

（禁止事项，每条一行）

## Git 合并冲突处理

（可选章节，如果项目有特殊的合并策略）

合并 master 分支遇到冲突时的处理原则：

- **环境配置冲突**：始终保留当前分支的配置
- **白名单/功能开关冲突**：合并双方的配置，保留两个功能都生效

## AI 文档规范

**所有 AI 生成或维护的文档统一写到 `agent_docs/` 目录下**，不要在其他位置新建 AI 文档目录。

| 子目录 | 用途 | 文件命名规范 |
|--------|------|------------|
| `agent_docs/handoffs/` | 会话交接快照 | `{分支名}.md`，与当前分支名一致 |
| `agent_docs/cases/` | 事故案例库 | 英文 kebab-case，便于代码中引用 |
| `agent_docs/plans/` | ptdd 工作流生成的实施计划 | `YYYY-MM-DD-<名称>.md` |
| `agent_docs/review/` | PR 代码审查报告 | `YYYY-MM-DD-<branch>.md` |
| `agent_docs/research/` | 技术调研报告、架构分析 | 中文名称，方便快速识别 |
| `agent_docs/draft/` | 临时草稿、未完成的设计文档 | 中文名称，方便快速识别 |
| `agent_docs/skills/` | 可复用技能模块 | 英文 kebab-case |
| `agent_docs/commands/` | 共享 slash 命令 | 英文 kebab-case |
| `agent_docs/rules/` | 模块级开发规范文档 | 英文 snake_case，与代码目录对应 |
| `agent_docs/redocs/` | 从 REDoc 获取的接口文档 | `redoc_<标题>.md` |

### 文档元信息

所有 `agent_docs/` 下的文档必须在 YAML frontmatter 中包含版本和日期，创建时 `v1.0`，每次修改递增并更新日期：

```yaml
---
version: v1.0
last_updated: 2026-04-20
---
```

如果文件已有 frontmatter（如 commands、skills 的 `SKILL.md`），在现有 frontmatter 中追加 `version` 和 `last_updated` 字段，不要新建第二个 frontmatter 块。

# 代码约定

## 命名规范

（简短的命名规则）

## 代码规范文档

（触发时机 → 规范文档 的对照表，详细内容在 rules 文件里）

| 场景 | 规范文档 | 何时阅读 |
|------|---------|---------|
| 编写 Vue 组件 | `agent_docs/rules/vue.md` | 动手前必读 |
```

## 各章节写法细则

### Build & Test

必须包含：
- 所有常用命令（安装、启动、lint、typecheck、测试）
- 明确的验收标准（什么通过才算任务完成）

不要写：
- 命令的详细解释（AI 能理解）
- 可选参数列举

### ALWAYS / NEVER

每条规则一行，不超过 20 条总计。超过说明有内容应该拆到 rules 文件。

好的写法：
```
## ALWAYS
- 接口错误统一使用 `handleApiError(name, error)` 处理
- 白名单控制统一使用 `useWhiteList()`，详见 `agent_docs/rules/whitelist.md`

## NEVER
- 引用或修改 `packages/shared`（已废弃，如用户明确要求需提示）
- 在代码中使用 magic number，必须定义枚举
- 使用 `any` 类型，优先使用 `unknown`
- 在根目录生成 `HANDOFF.md`——必须生成到 `agent_docs/handoffs/{分支名}.md`
```

不好的写法（内容太多，应该拆到 rules 文件）：
```
- 白名单控制统一使用 `useWhiteList()`，在 composable 中调用，
  新增 key 需先与后端确认维度（by vSellerId 还是 by userId），
  再将 key 添加到 packages/shell/src/plugins/whiteListPlugin.ts 中
  对应的 checkNames 数组：payloadForVSellerId、payloadByUserIdForEffect...
```

### 事故案例库

只放**链接 + 触发时机**，不内联内容：

```markdown
## 事故案例库

- 🔴 [金额单位错误导致出价放大100倍](agent_docs/cases/money-handling.md) - **处理金额/出价/支付时必须先看**
- 🔴 [Pinia Store ID 重复](agent_docs/cases/pinia-collision.md) - **创建或修改 Pinia store 时必须先看**
- 🟡 [Grid 布局滚动问题](agent_docs/cases/grid-scroll.md) - 使用 Grid/Flex 展示列表时注意
```

触发时机必须具体，"处理相关代码时"太模糊，"处理金额/出价/支付时"才清晰。

### 代码规范文档

这张表是 AGENTS.md 中最重要的「按需加载」机制。格式：

| 场景描述（包含具体目录/文件） | 规范文档路径 | 何时阅读 |
|---|---|---|

「何时阅读」的表达：
- `动手前必读`：每次涉及该场景都要读
- `涉及该模块时必读`：只在修改特定目录时才读
- `涉及白名单时必读`：场景触发条件明确

## 常见反模式

| 反模式 | 症状 | 修复方向 |
|---|---|---|
| 当 wiki 用 | 文件超 150 行，有大段技术说明 | 把内容拆到 rules 文件，只保留引用 |
| NEVER 和正文重复 | 同一规则在多个章节出现 | 统一到 NEVER，其他地方删除 |
| 规范无触发时机 | 规范文档表格没有"何时阅读"列 | 补充明确的触发条件 |
| 顺序混乱 | 验收标准在文件末尾 | 高优先级内容靠前 |
| 大量 ALWAYS/NEVER | 超过 20 条 | 合并、删减或拆到 rules |
| 文档无版本信息 | 不知道何时创建、是否过期 | 添加版本和日期元信息 |
| 多工具各自维护 | skills/commands 在不同工具目录中重复 | 统一到 agent_docs/ 通过软链接共享 |
| HANDOFF 散落根目录 | 交接文档在项目根目录 | 统一到 `agent_docs/handoffs/{分支名}.md` |
