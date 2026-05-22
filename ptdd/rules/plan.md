---
title: Planning 阶段规则
impact: CRITICAL
tags: planning, documentation
phase: 生成计划
---

# Planning 阶段规则

本文档整合了生成实施计划（Planning）阶段的所有关键规则。

---

## 计划文档模板

### 头部

```markdown
# [功能名称] 实施计划

## Meta

| 项目 | 内容 |
|------|------|
| 创建时间 | YYYY-MM-DD |
| 需求名称 | {name} |
| 目标 | [一句话描述] |
| PingCode | [需求链接，无则留空] |
| PRD | [红书文档链接] → `agent_docs/redocs/{name}_prd.md` |
| 设计稿 | [Figma 链接，无则留空] |
| 接口文档 | [红书文档链接] → `agent_docs/redocs/{name}_接口文档.md` |

---

**架构**：[2-3 句技术方案]
**测试环境**：参见 `agent_docs/rules/tdd_setup.md`

---

## 文件结构总览

在拆分任务之前，先锁定所有涉及的文件及其职责：

| 操作 | 文件路径 | 职责说明 |
|------|----------|----------|
| 创建 | `path/to/file.ts` | [一句话描述该文件的唯一职责] |
| 修改 | `path/to/existing.ts` | [说明修改原因] |
| 测试 | `path/to/file.test.ts` | [对应被测文件] |

---
```

### 任务结构

每个任务描述**做什么**，不描述**怎么做**。TDD 执行过程（RED/GREEN/REFACTOR、commit）由 implementer subagent 负责，计划不重复约束。

测试代码和实现代码必须完整写出，subagent 拿到即可执行，无需额外查找。

```markdown
## 任务 N：[任务名称]

**目标**：[要实现什么]

**涉及文件**：
- 创建：`path/to/file.ts`
- 修改：`path/to/file.ts:10-15`
- 测试：`path/to/file.test.ts`

**场景上下文**：[该任务在整体功能中的位置，依赖哪些已完成的任务]

**测试代码**：
```typescript
// 完整测试文件内容
```

**实现代码**：
```typescript
// 完整实现文件内容
```

**验收标准**：
- [ ] 所有测试通过
- [ ] 覆盖率 ≥ 80%
- [ ] [功能层面的验收条件，描述"做对了"是什么样子]
```

---

## 规则 1：假设读者零上下文

**影响级别**：CRITICAL

编写实施计划时，**必须**假设读者对项目一无所知，提供精确的文件路径、关键代码结构和预期结果。

---

## 规则 2：计划必须自包含，代码和命令必须完整

**影响级别**：CRITICAL

TDD 实施阶段，主线程会把每个任务的完整文本从 plan 文件提取后**直接粘贴**给 implementer subagent——subagent 不读 plan 文件，也没有主线程的对话历史，它收到的 prompt 就是这个任务的全部信息。因此每个任务**必须**写完整的测试代码、实现代码、精确命令和预期输出，写得不完整，subagent 就会卡住。

### 错误示例（过于抽象，subagent 无法执行）

```markdown
**实现要点**：
- 从 `/api/user` 获取数据
- 使用 `transformUserData()` 转换响应

**代码示例**（关键结构）：
```typescript
export function useUserInfo() {
  const userInfo: Ref<UserInfo | null> = ref(null)
  async function fetchUser(): Promise<void> {
    // 实现数据获取逻辑
  }
  return { userInfo, isLoading, fetchUser }
}
```

### 正确示例（完整自包含）

```markdown
**测试代码**（先写，subagent 必须先让测试失败）：
```typescript
// src/composables/useUserInfo.test.ts
import { describe, it, expect, vi, beforeEach } from 'vitest'
import { useUserInfo } from './useUserInfo'

vi.mock('@/api/user', () => ({
  fetchUserApi: vi.fn()
}))

describe('useUserInfo', () => {
  beforeEach(() => vi.clearAllMocks())

  it('成功获取用户信息', async () => {
    const { fetchUserApi } = await import('@/api/user')
    vi.mocked(fetchUserApi).mockResolvedValue({ id: 1, name: '张三' })

    const { userInfo, fetchUser } = useUserInfo()
    await fetchUser()

    expect(userInfo.value).toEqual({ id: 1, name: '张三' })
  })

  it('处理请求失败', async () => {
    const { fetchUserApi } = await import('@/api/user')
    vi.mocked(fetchUserApi).mockRejectedValue(new Error('network error'))

    const { userInfo, fetchUser } = useUserInfo()
    await fetchUser()

    expect(userInfo.value).toBeNull()
  })
})
```

**实现代码**：
```typescript
// src/composables/useUserInfo.ts
import { ref } from 'vue'
import { fetchUserApi } from '@/api/user'
import type { UserInfo } from '@/types'

export function useUserInfo() {
  const userInfo = ref<UserInfo | null>(null)
  const isLoading = ref(false)

  async function fetchUser(): Promise<void> {
    isLoading.value = true
    try {
      userInfo.value = await fetchUserApi()
    } catch {
      userInfo.value = null
    } finally {
      isLoading.value = false
    }
  }

  return { userInfo, isLoading, fetchUser }
}
```

---



## 规则 3：计划写完后必须经过 Review Loop

**影响级别**：CRITICAL

计划文档完成后，**必须**用 `explore` subagent 做一轮审核，主线程只接收结论，不自己审查。

**dispatch 方式**：读取 [plan-reviewer-prompt.md](./plan-reviewer-prompt.md)，将其中 `[计划文件路径]` 替换为实际路径后，作为 subagent prompt 发出。

### Review Loop 规则

- **Approved ✅**：直接进入阶段 3（展示计划给用户）
- **Issues Found ❌**：修复问题后重新 dispatch reviewer，直到 Approved
- **超过 3 轮仍未 Approved**：暂停，向用户说明分歧，请用户决策
- reviewer 的建议（非问题）仅供参考，不强制修改

---
