---
name: ai-friends
description: AI 友好化工程建设顾问。帮助团队从零开始搭建或改善 AI 协作工程体系，包括 AGENTS.md 的诊断与优化、agent_docs 目录规划、多工具软链接架构、规范文档建设、事故案例库建立。当用户提到"让项目更 AI 友好"、"AI 协作工程"、"优化 AGENTS.md"、"Claude.md 怎么写"、"搭建 agent_docs"、"建设 AI 规范"、"提升 AI 编码效率"、"写 AI 规则"、"多工具共享"、"软链接架构"等时必须使用本 skill。
---

# AI 友好化工程建设

## 核心理念

AGENTS.md（或 CLAUDE.md）不是知识库，不是团队 wiki，而是**你和 AI 之间的协作契约**。里面只放那些每次会话都必须成立的约定。

AI 友好化工程的本质是六层系统的协同设计：

| 层 | 载体 | 作用 |
|---|---|---|
| 长期上下文 | AGENTS.md / rules | 告诉 AI "是什么、能做什么、不能做什么" |
| 按需知识 | Skills / Commands / agent_docs | 告诉 AI "怎么做"，用时再读 |
| 强制约束 | Hooks | 不依赖 AI 自己判断的行为 |
| 隔离执行 | Subagents | 需要独立上下文的任务 |
| 验证闭环 | Verifiers | lint、typecheck、测试 |
| 风险记忆 | 事故案例库 | 避免重复踩坑 |

只优化一层系统就会失衡。AGENTS.md 太长，上下文先污染自己；规范全堆在一起，AI 读不完也不知道何时该读；没有事故案例库，错误会重复发生。

### 多工具统一架构

现代项目通常同时使用多个 AI 编码工具（Claude Code、Cursor、CodeWiz、OpenCode、Kiro 等）。推荐通过**软链接架构**实现一处维护、多端共享：

- `AGENTS.md` 为唯一真实来源，`CLAUDE.md` 通过软链接指向它
- 各工具目录（`.claude/`、`.cursor/`、`.codewiz/` 等）的 `skills/` 和 `commands/` 通过软链接指向 `agent_docs/skills/` 和 `agent_docs/commands/`
- 新增 skill 或 command 后，所有工具自动生效，零额外维护

---

## 工作流程

收到用户的改进请求后，先**诊断现状**，再**分阶段建设**，不要一次性全部重写。

### 第一步：诊断现状

读取以下文件（如果存在）：
- 项目根目录的 `AGENTS.md` / `CLAUDE.md`（检查是否为软链接关系）
- `agent_docs/` 目录结构（含 skills/、commands/、rules/、cases/ 等子目录）
- 各 AI 工具目录（`.claude/`、`.cursor/`、`.codewiz/`、`.opencode/`、`.kiro/`、`.agents/` 等）的软链接情况
- 任意已有的 rules 文件
- 抽样若干 `agent_docs/` 下文档的前 5 行，确认是否使用 YAML frontmatter 元信息

完成后输出诊断报告，覆盖以下七个维度，每项给出具体问题（如有）：

1. **体积与噪声**：AGENTS.md 是否过长？是否把知识库内容混入了契约层？
2. **内容重复**：不同章节之间是否有冗余？NEVER/ALWAYS 与其他章节是否重叠？
3. **结构顺序**：高优先级内容是否在前？Build 命令、工作流、强约束应该靠前
4. **规范文档**：是否有按需加载的 rules 文件？是否在合适的时机引用而不是全部内联？
5. **风险覆盖**：是否有事故案例库？是否有高风险场景的预警机制？
6. **多工具架构**：是否有软链接统一多个 AI 工具的 skills 和 commands？`CLAUDE.md` 是否软链到 `AGENTS.md`？
7. **文档元信息**：所有 `agent_docs/` 下文档是否在 YAML frontmatter 中有 `version` / `last_updated`？命名是否符合子目录规范？

诊断完成后，向用户说明发现的问题，并询问优先从哪里开始。

### 第二步：优化 AGENTS.md

参考 `references/agents-md-guide.md` 执行优化。

**写作来源：基于当前项目仓库的真实状态**——读 `package.json`、`README.md`、现有 `AGENTS.md`、源码目录结构、`git log`，再下笔。不要从下面这些来源拼凑内容：

- 用户的全局个人配置（`~/.claude/CLAUDE.md`、`~/.config/codewiz/` 等）—— 那是用户的个人偏好，不是项目契约
- 当前会话的环境注入（`Today's date is ...` 之类）—— AGENTS.md 是长期契约，不带绝对时间
- 你训练时见过的"通用最佳实践"—— 必须在仓库里能找到对应证据，否则不写

**应该放什么：**
- Build / Test / Lint 命令 + 验收标准（从 `package.json scripts` 或 README 取）
- 技术栈简要说明（组件库、包管理器等，从 `package.json` 取）
- 开发工作流程（如强制使用 ptdd 等 skill）
- ALWAYS / NEVER 强约束（每条都能在一行内说清楚，每条都有项目内的真实依据）
- 事故案例库（链接 + 触发时机，不要内联全文）
- 规范文档引用表（场景 → 文档路径 → 何时阅读）
- AI 文档规范（agent_docs 目录说明）

**不应该放什么：**
- 详细的代码规范（放到 rules 文件里按需加载）
- 完整 API 文档或接口说明
- 空泛原则（"写高质量代码"之类）
- AI 通过读仓库就能推断的显然信息
- 大段背景介绍

### 第三步：建设 agent_docs 目录

参考 `references/agent-docs-guide.md`，按需规划以下子目录：

```
agent_docs/
├── cases/          事故案例库（高风险场景预警）
├── rules/          模块级规范文档，按需加载
├── skills/         项目内可复用的 skill 模块
├── commands/       共享的 slash 命令（多工具复用）
├── plans/          AI 生成的实施计划（ptdd 工作流）
├── review/         PR 代码审查报告
├── handoffs/       会话交接快照（跨会话上下文传递）
├── research/       技术调研报告、架构分析文档
├── draft/          临时草稿、未完成的设计文档
├── todos/          功能级 TODO 跟踪
└── redocs/         从接口文档平台获取的文档
```

优先建设 `cases/` 和 `rules/`，其他目录用到再建。

如果项目使用多个 AI 工具，同步建设软链接架构——参考 `references/symlink-guide.md`。

### 第四步：写 rules 规范文档

从 AGENTS.md 中提取详细规范内容，拆分到独立的 rules 文件。每个 rules 文件应覆盖：
- 这个模块/场景的核心约定
- 正确用法示例（代码片段）
- 常见错误模式（NEVER 列表）
- 相关文件路径

规范文档引用格式写入 AGENTS.md 的「代码规范文档」表格：

| 场景 | 规范文档 | 何时阅读 |
|------|---------|---------|
| 编写 Vue 组件 | `agent_docs/rules/vue.md` | 动手前必读 |

### 第五步：建立事故案例库

**默认只建空骨架**：创建 `agent_docs/cases/` 空目录即可，不要代用户预填案例文件，也不要把模板复制成 `_template.md`。案例库的价值在于真实事故沉淀，AI 凭空生成的"通用案例"只会污染上下文。

等用户遇到真实事故、或者明确要求"把 XX 这个坑写成案例"时，再参考 `references/case-template.md` 落到 `agent_docs/cases/<问题描述>.md`。

每个案例包含：
- 事故级别（P0/P1/P2）和触发时机说明
- 问题描述和技术根因
- 错误代码和正确代码对比
- 强制检查清单

在 AGENTS.md 中用链接引用，附上**触发时机**（"处理 XX 时必须先看"），不要内联全文。

---

## 常见优化场景

### AGENTS.md 太长、规则没人遵守

症状：文件超过 150 行，充满详细规范，但 AI 经常违反。

原因：信息密度过高，关键约束被稀释；详细规范每次都加载，上下文被占满。

解法：
1. 把详细规范抽到 `agent_docs/rules/` 下的独立文件
2. AGENTS.md 只保留一行引用 + 触发时机
3. NEVER/ALWAYS 每条都精简到一行，不超过 20 条

### NEVER 和其他章节重复

把重复的内容统一到 NEVER，其他章节删掉。如果某个 NEVER 条目背后有复杂的上下文（如事故案例），改为链接引用而不是内联说明。

### 规范文档没有触发时机

AI 不知道什么时候该读哪个文档，就不会主动读。在 AGENTS.md 的规范文档表格里明确写"何时阅读"，如"动手前必读"、"涉及该模块时必读"。

### 没有事故案例库

从现有 bug 记录、Code Review 评论中提炼 3-5 个高频问题，写成案例文件。格式参考 `references/case-template.md`。

### 没有多工具统一架构

症状：不同 AI 工具各自维护独立的 skills 和 commands，内容不同步。

解法：
1. 将 skills 和 commands 统一存放到 `agent_docs/skills/` 和 `agent_docs/commands/`
2. 通过软链接让各工具目录指向同一来源
3. `CLAUDE.md` 软链接到 `AGENTS.md`，确保一处维护

### 文档没有版本和日期

症状：不知道文档何时创建、是否过期。

解法：所有 `agent_docs/` 下的 `.md` 文件必须在 YAML frontmatter 中包含版本和日期：
```yaml
---
version: v1.0
last_updated: 2026-04-20
---
```
创建时 `v1.0`，每次修改递增版本号并更新日期。

如果文件已有 frontmatter（如 commands、skills 的 `SKILL.md`），在现有 frontmatter 中追加 `version` 和 `last_updated` 字段，不要新建第二个 frontmatter 块。

### agent_docs 命名/版本不规范

症状：文件名不符合子目录命名规范（kebab-case / snake_case / 中文 / 日期前缀），或缺失版本元信息。

解法：在项目内构建 `lint-agent-docs` skill（或参考 aurora-trees 实现）做全量订正：
- 只读取每个文件前 5 行检查元信息，不读全文，节省 token
- 规则来源唯一——AGENTS.md 中的「AI 文档规范」章节
- 先报告再修复，等用户确认后批量改名/补 frontmatter

---

## 输出规范

- 所有 AI 生成的文档写到 `agent_docs/` 目录下，不在其他位置建目录
- 优化 AGENTS.md 时先读完再修改，不要凭印象改
- 每次修改后说明改了什么、为什么改，让用户确认后再继续
- 涉及删除内容时，先确认信息是否已经在其他地方保留
- 所有 `agent_docs/` 下的文档必须包含版本和日期元信息

Base directory for this skill: file:///Users/fengyu3/.config/codewiz/skills/ai-friends
Relative paths in this skill (e.g., references/) are relative to this base directory.
