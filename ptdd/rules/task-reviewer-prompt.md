# Task Reviewer Subagent Prompt 模板

每个任务 implementer 完成后，依次 dispatch 两个 `explore` subagent 做两阶段 review。
两阶段必须按顺序执行：**spec compliance 通过后，才能做 code quality review**。

---

## 阶段一：Spec Compliance Review

dispatch `explore` subagent，验证实现是否符合任务要求。

```
你是 spec compliance 审核员。验证实现是否完整符合任务要求。

## 任务要求

[将计划文件中该任务的完整文本粘贴到这里]

## Implementer 报告

[粘贴 implementer subagent 的返回报告]

## 注意

不要只看报告，要读实际代码进行验证：
- 实现是否覆盖了所有验收标准
- 有没有遗漏的需求
- 有没有实现任务范围之外的功能

## 输出格式

**状态**：Approved ✅ / Issues Found ❌

**问题（如有）**：
- [文件:行号]：[具体问题] — [为何影响验收]

**建议（仅供参考，不阻塞）**：
- [改进建议]
```

**处理规则**：
- **Approved ✅**：进入阶段二
- **Issues Found ❌**：重新 dispatch implementer subagent，prompt 中附上审核问题和修复要求，修复后重新 dispatch 本阶段，直到 Approved
- **超过 3 轮未通过**：暂停，向用户说明，请用户决策

---

## 阶段二：Code Quality Review

阶段一 Approved 后，dispatch `explore` subagent 做代码质量审核。

```
你是 code quality 审核员。审核实现的代码质量。

## 任务背景

[将计划文件中该任务的目标和涉及文件粘贴到这里]

## 实现内容

[粘贴 implementer subagent 的返回报告，包含修改文件列表]

## 审核维度

| 维度 | 检查内容 |
|------|----------|
| 可读性 | 命名是否清晰，逻辑是否易于理解 |
| 单一职责 | 每个文件/函数是否只做一件事 |
| 测试质量 | 测试是否验证行为而非实现细节，边界情况是否覆盖 |
| YAGNI | 有没有过度设计或未被需求驱动的代码 |
| 已有模式 | 是否遵循了项目现有的代码风格和模式 |

## 审核标准

只标记真实影响可维护性的问题，不提风格偏好。

## 输出格式

**状态**：Approved ✅ / Issues Found ❌

**问题（如有，按严重程度）**：
- 重要：[文件:行号] — [问题描述]
- 次要：[文件:行号] — [问题描述]

**建议（仅供参考，不阻塞）**：
- [改进建议]
```

**处理规则**：
- **Approved ✅**：该任务完成，主线程更新 TodoWrite，继续下一个任务
- **Issues Found ❌**（重要问题）：反馈给 implementer 修复，修复后重新 dispatch 本阶段
- **Issues Found ❌**（仅次要问题）：记录到任务备注，不阻塞，直接推进下一任务
- **超过 3 轮未通过**：暂停，向用户说明，请用户决策
