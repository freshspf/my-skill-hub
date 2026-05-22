---
title: Kickoff 阶段规则
impact: CRITICAL
tags: kickoff, preparation
phase: 准备
---

# Kickoff 阶段规则

在进入需求澄清（Brainstorming）之前，完成所有前置准备工作。

---

## 步骤 1：探索项目状态

使用 `explore` subagent 探索当前项目状态，返回以下摘要：

- 项目类型和技术栈
- 目录结构概览（顶层 + 与本次需求相关的子目录）
- 最近 5 条 git commit（了解当前开发方向）
- 已有约定（AGENTS.md、README 等）

主线程只读摘要，不自己执行探索命令。

---

## 步骤 2：收集相关文档链接并下载

向用户一次性询问以下信息，**全部可选，没有可直接跳过**：

> "开始前请提供相关文档链接（均可选，没有直接回车跳过）：
> - PingCode 需求链接
> - 产品 PRD（红书文档链接）
> - 设计稿（Figma 链接）
> - 后端接口文档（红书文档链接）"

收到回复后，按以下规则处理：

### 红书文档下载

对用户提供的每个红书文档链接（PRD、接口文档），使用以下命令下载：

```bash
npx @xhs/redoc2md -d <docId> > redoc_<docId>.md
```

其中 `<docId>` 从链接中提取（`https://docs.xiaohongshu.com/doc/<docId>`）。

### 确定需求名称

**PRD 是命名基准**：
- 提供了 PRD 链接 → 下载后读取文档标题，将标题转为简短英文或拼音缩写作为 `{name}`
- 未提供 PRD → 根据用户描述的需求主题确定 `{name}`，并告知用户

### 文件命名规范

确定 `{name}` 后，所有相关文件统一按此命名：

| 文件 | 路径 |
|------|------|
| PRD 文档 | `agent_docs/redocs/{name}_prd.md` |
| 接口文档 | `agent_docs/redocs/{name}_接口文档.md` |
| 实施计划 | `agent_docs/plans/YYYY-MM-DD-{name}.md` |

下载完成后将原始 `redoc_<docId>.md` 重命名为对应路径。

### 记录到 meta

将所有链接和本地文件路径写入 plan 文件 meta 区，未提供的留空，**不追问**。

---

## 步骤 3：确认测试环境

检查 `agent_docs/rules/tdd_setup.md` 是否存在：

- **已存在**：直接读取，Kickoff 完成
- **不存在**：使用 `explore` subagent 探测项目测试环境，返回以下信息：
  - 包管理器（npm / yarn / pnpm / bun）
  - 单文件测试命令
  - 全量测试命令
  - 覆盖率命令
  - 测试框架（vitest / jest / 其他）

  获得结论后保存到 `agent_docs/rules/tdd_setup.md`：

  ````markdown
  # 测试环境配置

  **更新时间**：YYYY-MM-DD
  **测试框架**：[vitest / jest / ...]
  **包管理器**：[yarn / npm / pnpm / bun]

  ## 命令

  | 用途 | 命令 |
  |------|------|
  | 运行单个测试文件 | `yarn test:run src/foo.test.ts` |
  | 运行所有测试 | `yarn test:run` |
  | 覆盖率报告 | `yarn test:run --coverage` |
  ````

---

## Kickoff 完成信号

三个步骤全部完成后输出：

> "✅ Kickoff 完成，已了解项目现状、收集文档链接、确认测试环境，现在开始需求澄清..."

然后进入 Brainstorming 阶段。
