# agent_docs 目录建设指南

## 设计原则

`agent_docs/` 是按需加载的知识层，对应 AGENTS.md 的"常驻契约层"。

- AGENTS.md 中放**索引和引用**
- agent_docs 中放**详细内容**
- AI 在遇到具体场景时才读对应的文件，不会每次全部加载

## 文档元信息

所有 `agent_docs/` 下的 `.md` 文件必须在 YAML frontmatter 中包含版本和日期：

```yaml
---
version: v1.0
last_updated: 2026-04-20
---
```

如果文件已有 frontmatter（如 commands、skills 的 `SKILL.md`），在现有 frontmatter 中追加 `version` 和 `last_updated` 字段，不要新建第二个 frontmatter 块。

创建时 `v1.0`，每次修改递增版本号并更新日期。这样可以判断文档是否过期。可以借助类似 `lint-agent-docs` 的 skill 做批量订正。

## 标准目录结构

```
agent_docs/
├── cases/          事故案例库（高风险场景预警）         ← 最高优先级
├── rules/          模块级规范文档                       ← 第二优先级
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

建议按需建设，不要一次性创建所有目录。优先级：`cases/` > `rules/` > 其他。

## cases/ 事故案例库

### 初始化方式

**只建空目录，不要预填案例**。案例库的价值来自真实事故沉淀，AI 凭空生成的"通用案例"会污染上下文，反而让真实案例淹没在噪声里。

### 何时写入案例

- 发生了真实的线上事故（P0/P1）
- 有高频重复出现的 Code Review 问题
- 某个场景存在容易踩的坑（即使没出过事故），且**用户明确要求**沉淀

### 命名规范

文件名描述问题本质，用 kebab-case：
- `money-handling-100x-amplification-accident.md`（好）
- `bug1.md`（差）

### 在 AGENTS.md 中引用

```markdown
## 事故案例库

- 🔴 [金额单位错误导致出价放大100倍](agent_docs/cases/money-handling-100x-amplification-accident.md) - **处理金额/出价/支付时必须先看**
- 🟡 [Grid 布局滚动问题](agent_docs/cases/grid-layout-scroll-issue.md) - 使用 Grid/Flex 展示列表时注意
```

严重程度标记：🔴 P0/P1、🟡 P2/常见问题。

## rules/ 规范文档

### 何时建立

- AGENTS.md 中某类规范内容超过 5 行
- 某个模块有超过 3 条独立的约定
- 有场景化的"何时该这样做"的判断逻辑

### 典型的 rules 文件类型

**通用技术规范**（适用全项目）：
- `vue.md` - Vue 组件/Composable 开发规范
- `style.md` - 样式、枚举、注释规范
- `typescript.md` - TS 类型使用规范

**业务机制规范**（特定功能相关）：
- `whitelist.md` - 白名单使用规范
- `api-error.md` - 接口错误处理规范

**模块规范**（特定目录相关）：
- `create2.md` - 标准投创编模块规范
- `create-simple.md` - 简单投创编模块规范

### rules 文件结构

```markdown
# XXX 规范

## 概述

一句话说清楚这个规范覆盖什么范围。

## 使用方式 / 核心约定

（主体内容：怎么做，代码示例）

## 常见错误

（NEVER 列表，附代码对比）

## 相关文件路径

（关键文件的位置）
```

### 在 AGENTS.md 中引用

用「代码规范文档」表格统一管理，包含触发时机：

```markdown
## 代码规范文档

| 场景 | 规范文档 | 何时阅读 |
|------|---------|---------|
| 编写 Vue 组件 / Composable | `agent_docs/rules/vue.md` | 动手前必读 |
| 使用或新增白名单 | `agent_docs/rules/whitelist.md` | 涉及白名单时必读 |
| 修改创编模块（`packages/shell/src/containers/Create2`） | `agent_docs/rules/create2/` | 涉及该模块时必读 |
```

触发时机的表达越具体越好，"动手前"优于"需要时"。

### 命名规范

文件名使用英文 snake_case，与代码目录对应（如 `vue.md`、`style.md`、`whitelist.md`）。

模块级规范可以使用子目录：
```
agent_docs/rules/
├── vue.md
├── style.md
├── whitelist.md
├── create2/
│   ├── index.md
│   └── add_new_optimize_target.md
└── create_simple/
    ├── index.md
    └── deep_optimize.md
```

## skills/ 项目级技能

项目特有的可复用 skill 模块，每个 skill 一个子目录，包含 `SKILL.md` 入口文件。

通过软链接架构（见下文），这些 skill 可以被所有 AI 工具共享。

## commands/ 共享命令

跨 AI 工具共享的 slash 命令，每个命令一个 `.md` 文件。

命名规范：英文 kebab-case，如 `fix-conflicts.md`、`code-simplifier.md`。

所有 command 文件末尾追加 `$ARGUMENTS` 占位符，支持工具传参：

```markdown
（命令正文）

$ARGUMENTS
```

## plans/ 实施计划

AI 在执行 ptdd 工作流时自动生成，无需手动维护结构。

命名规范：`YYYY-MM-DD-<功能描述>.md`，日期取创建日，方便按时间排序。

## review/ 代码审查报告

AI 在做 PR 审查时自动生成。

命名规范：`YYYY-MM-DD-<branch-name>.md`

## handoffs/ 会话交接

跨会话传递上下文的交接文档，与分支绑定。

命名规范：`{分支名}.md`，与当前 git 分支名一致。

**重要**：HANDOFF 文档必须生成到 `agent_docs/handoffs/` 下，禁止放在项目根目录。这一点应在 AGENTS.md 的 NEVER 规则中明确约定。

## research/ 技术调研

技术调研报告、架构分析文档，比 draft 更正式。

命名规范：**中文名称**，方便快速识别内容（如 `AI工作流升级方案.md`）。

## draft/ 研究草稿

AI 在做调研、分析时存放中间产物。用完可以删除，不需要长期维护。

命名规范：**中文名称**，方便快速识别内容。

## todos/ 功能跟踪

功能级的 TODO 跟踪文件，比代码中的 TODO 注释更系统化。

命名规范：英文 kebab-case，描述功能名称（如 `note-exclude-refinement.md`）。

## redocs/ 接口文档

从接口文档平台（如 REDoc）获取的文档，通常是临时性的。

获取流程：
```bash
npx @xhs/redoc2md -d <docId> > agent_docs/redocs/redoc_<docId>.md
```

获取后：
1. 读取文档标题，重命名为有意义的文件名
2. 任务完成后询问用户是否需要删除（这类文档通常较大，不宜长期留存）
3. **不要完整阅读**，优先用 grep 搜索关键内容

---

## 软链接架构

如果项目使用多个 AI 工具，推荐通过软链接让所有工具共享同一套 skills 和 commands：

```bash
# 初始化软链接（仅首次）
for editor in .agents .opencode .cursor .codewiz .claude .kiro; do
  mkdir -p "${editor}"
  rm -rf "${editor}/skills"
  ln -sf ../agent_docs/skills "${editor}/skills"
  rm -rf "${editor}/commands"
  ln -sf ../agent_docs/commands "${editor}/commands"
done

# CLAUDE.md 软链接到 AGENTS.md
ln -s AGENTS.md CLAUDE.md
```

这样新增 skill 或 command 到 `agent_docs/` 后，所有工具自动生效，零额外维护。

详细指南参考 `references/symlink-guide.md`。

---

## 注意事项

- 所有 AI 生成的文档统一写到 `agent_docs/` 下，不在其他位置建目录
- `draft/` 和 `redocs/` 中的文件是临时产物，定期清理
- `cases/` 和 `rules/` 中的文件是长期资产，应该随项目演进持续维护
- 所有文档必须包含版本和日期元信息
- HANDOFF 文档禁止放在根目录，必须在 `agent_docs/handoffs/` 下
