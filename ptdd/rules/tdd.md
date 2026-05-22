---
title: TDD 实施阶段规则
impact: CRITICAL
tags: tdd, testing, implementation
phase: TDD 实施
---

# TDD 实施阶段规则

TDD 实施阶段采用 **subagent per task** 模式。主线程只做协调，不直接执行任何实现任务。

---

## 主线程职责

**只做这三件事**：

1. **读取计划**：读取已保存的 plan 文件，提取所有任务，用 TodoWrite 建立任务清单
2. **协调执行**：按顺序 dispatch subagent，接收报告，处理异常，推进 TodoWrite
3. **任务间校验**：每个任务完成后确认 git log 有新 commit，再继续下一个

**禁止行为**：
- 主线程自己写代码
- 主线程自己运行测试
- 主线程读取实现细节（报错信息、完整测试输出等）

---

## 步骤 0：确认测试环境

正常情况下 Kickoff 阶段已完成此步骤，`tdd_setup.md` 应已存在。此处仅作兜底检查。

检查 `agent_docs/rules/tdd_setup.md` 是否存在：

- **已存在**：直接读取，继续步骤 1
- **不存在**：用 `explore` subagent 探测项目测试环境，按 `kickoff.md` 步骤 3 的格式保存，再继续

---

## 步骤 1：读取计划，建立任务清单

读取 plan 文件，提取所有任务，用 TodoWrite 创建清单。

**每个任务包含**：
- 任务标题
- 涉及文件列表
- 场景上下文

**不需要**把完整测试代码/实现代码加载进主线程，这些内容在 dispatch 时从 plan 文件直接提取传给 subagent。

---

## 步骤 2：逐任务执行（per task loop）

每个任务按以下流程执行，完成后再开始下一个，**不并行**。

```
标记任务为 in_progress
  ↓
dispatch implementer subagent（见 implementer-prompt.md）
  ↓
处理 implementer 返回状态
  ↓
dispatch spec compliance reviewer（见 task-reviewer-prompt.md 阶段一）
  ↓
dispatch code quality reviewer（见 task-reviewer-prompt.md 阶段二）
  ↓
确认 git 有新 commit
  ↓
标记任务为 completed
```

### Dispatch implementer

参考 [implementer-prompt.md](./implementer-prompt.md)，构造 prompt 时：
- 将该任务完整文本从 plan 文件提取后**直接粘贴**，不让 subagent 自己读 plan
- 粘贴 `agent_docs/rules/tdd_setup.md` 内容作为测试环境信息
- 说明已完成的前置任务（场景上下文）

### 处理 implementer 返回状态

| 状态 | 处理方式 |
|------|----------|
| `DONE` | 进入 review 阶段 |
| `DONE_WITH_CONCERNS` | 读取顾虑内容，判断是否影响正确性；若影响则让 implementer 修复后再 review，否则带着顾虑进入 review |
| `NEEDS_CONTEXT` | 补充缺失的上下文，重新 dispatch implementer |
| `BLOCKED` | 评估原因：上下文问题则补充后重新 dispatch；任务太大则拆分；计划有误则暂停并告知用户 |

### Dispatch reviewer

参考 [task-reviewer-prompt.md](./task-reviewer-prompt.md)：
- 阶段一（spec compliance）：传入任务要求 + implementer 报告
- 阶段二（code quality）：阶段一 Approved 后才执行，传入任务背景 + 修改文件列表

---

## 步骤 3：所有任务完成后

所有任务标记 completed 后，向用户汇报：

```
所有任务已完成。

已完成任务：[列表]
Git commits：[commit 列表]

是否需要我做最终的整体 review？
```

---

## Vue 项目说明

implementer subagent 在测试 Vue 组件时，如遇到 Vue 特定问题（Pinia、Teleport、Suspense 等），
在 dispatch prompt 中附加说明：参考项目中已有的测试写法，或查阅 vue-testing-best-practices skill。

---

## 禁止行为汇总

- 主线程直接写代码或测试
- 跳过任意一个 review 阶段
- 两个任务并行执行
- 让 subagent 自己去读 plan 文件（必须由主线程提取后传入）
- review 有未解决的重要问题时推进下一任务
- 未确认 git commit 就标记任务完成
