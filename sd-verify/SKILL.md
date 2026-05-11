---
name: sd-verify
description: 集成联调验证并生成 curl 测试文档。对 plan.md 接口汇总表中的每个接口构造 curl 命令进行联调测试，记录请求/响应样例，发现并修复集成问题，生成 docs/<feature>/curl-test.md。适用于用户说"联调"、"验证接口"、"写curl测试"、"sd-verify"、"integration test"等场景。
---

# SD-Verify：联调验证与 curl 测试

按 plan.md 接口汇总表逐接口联调测试，生成可复现的 curl 测试文档。

## 前置检查

1. 读取 `docs/<feature>/plan.md` → 获取接口汇总表
2. 读取 `docs/<feature>/progress.md` → 获取当前实现状态
3. 确认所有开发任务为 `✅ 已完成`

如果有开发任务未完成，提示用户："还有 N 个任务未完成，建议先运行 `/sd-apply` 完成开发，再进行联调验证。"

## 执行流程

### Step 1：确定测试环境

从 plan.md 或用户提供的测试信息中获取：
- 测试基础 URL（如 `https://xxx.devops.xiaohongshu.com`）
- 必要的 Header（认证 token、Source-Tag 等）
- 通用请求参数格式（Content-Type、参数嵌套规则等）

### Step 2：按接口逐条测试

对 plan.md 接口汇总表中的每个接口：

**Step 2a**：从 plan.md 获取接口信息（路径、HTTP 方法、apiKey、参数）

**Step 2b**：构造 curl 命令，包含：
- 请求方法和完整 URL
- 所有必要 Header
- 请求体（JSON 格式，使用有效测试数据）

**Step 2c**：在允许的情况下执行 curl 获取响应

**Step 2d**：检查响应：
- `success`/状态码是否正确
- 返回字段是否与 schema/设计预期匹配
- 业务逻辑是否正确（如品牌词是否被拦截、搜索指数数值是否合理）
- 异常情况是否有合理错误码和错误信息

**Step 2e**：记录到 `docs/<feature>/curl-test.md`：
- 编号接口名称 + 验证状态（✅ 已验证 / ⬜ 待验证）
- apiKey
- curl 命令（可直接复制执行）
- 返回示例（JSON 格式化）
- 参数说明表（参数名、类型、必填、说明）
- 判断逻辑说明（1-2 句）

模板引用：`references/templates/curl-test-template.md`

### Step 3：RPC 调用对照

如果接口涉及 RPC 调用（如 dataconsole 的 `requireApiDataWithoutAuth`），建立对照表：

| HTTP body | RPC DataApiRequest.paramsJson |
|-----------|------|
| `"params": {...}` | `"{\"key\": \"value\"}"` |

**规则**：RPC 的 `paramsJson` = HTTP body 的 `params` 对象 JSON.stringify 后的字符串。

### Step 4：集成问题修复

对测试中发现的每个问题：

**Step 4a**：定位根因（参数格式错误 / 字段映射遗漏 / 响应解析失败 / 上游超时等）

**Step 4b**：修复代码

**Step 4c**：在 progress.md 的"设计决策与关键改动"中记录：
- 问题描述（现象）
- 根因分析
- 修复方案（含代码片段）
- 验证结果（curl 命令 + 响应确认修复）

**Step 4d**：重新执行 curl 确认修复

### Step 5：收尾

- 更新 progress.md 总体状态为 `🟢 已联调验证`
- 变更日志追加：`联调验证完成，curl-test.md 已生成`
- 汇总测试结果：N 个接口中 M 个通过，K 个待确认

提示用户：

> 联调验证完成。curl-test.md 已生成在 `docs/<feature>/`。可以运行 `/retro` 生成复盘文档。

## curl 测试覆盖清单

每个接口至少覆盖以下场景：

| 场景 | 说明 |
|------|------|
| 正常请求 | 有效参数，预期成功响应 |
| 边界值 | 空列表、空字符串、最大/最小值 |
| 异常参数 | 缺少必填参数、格式错误、非法值 |
| 权限/业务拦截 | 无权限词、无合作品牌等 |

## 关键原则

- **curl 命令必须可复现**：任何人复制到终端就能执行，得到同样结果
- **响应样例必须真实**：使用实际返回的数据，不编造
- **修复后必须重新验证**：不假设修复有效，跑一遍 curl 确认
- **问题记录到 progress.md**：集成问题不是孤立事件，是交付物的一部分
