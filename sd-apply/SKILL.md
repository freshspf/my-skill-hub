---
name: sd-apply
description: 按 plan.md 逐任务开发实现并自测。读取 docs/<feature>/plan.md 和 progress.md，参考 @FilePath:lineNumber 代码锚点实现每个任务，完成后逐条自测验证，并立即更新 progress.md。适用于用户说"开始开发"、"实现任务"、"sd-apply"、"继续做"、"开发下一个任务"等场景。
---

# SD-Apply：逐任务开发与自测

按 plan.md 逐任务实现，每完成一个任务立即更新 progress.md。

<HARD-GATE>
每完成一个任务后，必须先更新 progress.md（任务状态 → 设计决策 → 变更日志），才能开始下一个任务。绝不批量更新——每个任务独立更新，确保随时可安全中断。
</HARD-GATE>

## 执行流程

### Phase A：定位当前任务

**Step A1**：读取 `docs/<feature>/plan.md` 和 `docs/<feature>/progress.md`

如果文件不存在，提示用户先运行 `/sd-plan <feature>`。

**Step A2**：在 progress.md 任务进度表中找到第一个 `⬜ 未开始` 或 `🟡 实现中` 的任务

**Step A3**：读取该任务的"参考实现"锚点（`@FilePath:lineNumber`）

**Step A4**：打开每个参考文件，理解代码模式：
- 方法签名风格（参数类型、返回类型、异常声明）
- 参数处理方式（校验、转换、默认值）
- 异常处理模式（try-catch 位置、日志级别、错误码）
- 日志风格（log.info/warn/error，关键节点记录）

**Step A5**：如果存在 `HANDOFF.md`（上次中断恢复），先读取 HANDOFF.md 理解断点上下文

### Phase B：检查上下文余量

如果 context 接近压缩阈值（剩余 < 20%），执行以下操作：

1. 生成 `docs/<feature>/HANDOFF.md`，记录：
   - 当前任务的实现进度
   - 已读参考文件及关键模式
   - 下一个要写的类/方法
   - 尚未尝试的失败方案（如有）
2. 提示用户："当前任务尚未完成，已保存断点至 HANDOFF.md。新开会话后运行 `/sd-apply` 即可继续。"

### Phase C：实现

**Step C1**：按 plan.md 中该任务的"实现步骤"逐项实现

**Step C2**：严格遵循参考锚点中的代码风格：
- 命名规范（类名、方法名、变量名）
- 注解使用（@Service、@Resource、@RequestMapping 等）
- 异常处理模式
- 日志格式

**Step C3**：如果参考锚点不足以指导实现，先搜索更匹配的已有代码，将新的锚点追加到 plan.md

**Step C4**：新增的类/方法在完成后标注 `@anchor`，供后续任务参考

### Phase D：自测验证

**Step D1**：对照 plan.md 中该任务的"实现步骤"逐条检查：
- 每个步骤是否已完成？
- 参数校验是否覆盖边界情况（null、空串、格式错误）？
- 异常处理是否遵循参考代码模式？
- 日志是否记录关键节点（入口参数、RPC 调用结果、异常信息）？

**Step D2**：编译检查（`mvn compile`）
- 如果编译失败，修复后重新编译
- 在 progress.md 中注明编译结果

**Step D3**：如果有相关单元测试，运行 `mvn test -Dtest=<TestClass>`

**Step D4**：如果自测发现遗漏，回到 Phase C 补充

### Phase E：更新 progress.md（HARD GATE — 不可跳过）

**Step E1**：任务进度表 — 标记该任务：
- `✅ 已完成`（全部完成）
- `🟡 实现中`（部分完成，下次继续）
- `🔴 受阻`（有阻塞问题）

**Step E2**：设计决策与关键改动 — 追加本次实现要点：
- 参考了哪些代码模式（标注来源 `@FilePath:lineNumber`）
- 与 plan.md 不同的实现决策及原因
- Bug fix 或 Code Review 发现及修复内容（含代码片段）

**Step E3**：变更日志 — 追加一条 dated 记录：
```
### YYYY-MM-DD
- 任务 N 实现完成：<一句话说明做了什么>
```

**Step E4**：报告进度，提示下一个待实现任务

## 特殊场景处理

### plan.md 缺失或找不到

提示用户："未找到 `docs/<feature>/plan.md`。请先运行 `/sd-plan <feature>` 创建开发计划。如果已知道 feature 名称，也可以直接告诉我。"

### 所有任务已完成

更新 progress.md 总体状态为 `✅ 已完成`。提示用户：

> 所有开发任务已完成。可以运行 `/sd-verify` 进行联调验证。

### 服务不可用 / 需要远程环境

如果自测阶段遇到外部服务不可用（RPC 未部署、数据库未就绪等），在该任务的 progress.md 备注中注明，并将状态设为 `🟡 实现中`，备注"等待 <服务名> 就绪后联调验证"。

## 关键原则

- **一次只做一个任务**：不跨任务跳跃，确保 progress.md 始终反映真实状态
- **参考锚点是起点不是模板**：理解模式后按实际需求调整，不盲目复制
- **自测是开发的一部分**：每个任务完成后必须自测，不自测不算完成
- **progress.md 是唯一的进度真相**：任何状态变更必须反映到 progress.md
