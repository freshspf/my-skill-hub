---
name: sd-plan
description: 将需求设计转化为结构化开发计划。当需要根据需求文档/设计 spec 创建 docs/<feature>/plan.md 和 progress.md 时触发。适用于用户说"制定开发计划"、"任务拆解"、"sd-plan"、"写plan"、"拆分任务"等场景。会探索代码库寻找相似实现，在每个任务中标注 @FilePath:lineNumber 代码参考锚点。
---

# SD-Plan：任务拆解与开发计划制定

将 brainstorming 或需求文档的输出，转化为可执行的结构化开发计划。

<HARD-GATE>
在用户明确确认 plan.md 中的任务拆解、接口汇总和代码分层树之前，绝不生成最终文件。
</HARD-GATE>

## 执行流程

### Step 1：定位需求来源

确定需求输入来源，按优先级：

1. 读取 `docs/superpowers/specs/YYYY-MM-DD-<topic>-design.md`（brainstorming 输出）
2. 从当前会话上下文提取需求
3. 直接询问用户功能名和简要描述

如果找不到需求文档且用户也未提供，提示用户先运行 `/brainstorming` 梳理需求。

### Step 2：确定 feature 目录

- 与用户确认 `<feature-name>`（kebab-case，如 `hotword`、`search-hotword`）
- 创建 `docs/<feature>/` 目录
- 如果目录已存在，读取已有内容并询问是否覆盖

### Step 3：代码参考锚点探索

询问用户："哪些已有模块有相似实现可以参考？"

对用户指定的模块，搜索以下模式并记录 `@FilePath:lineNumber`：

| 锚点类型 | 搜索模式 | 记录格式 |
|----------|----------|----------|
| RPC Client | `*RpcClient.java` + `requireApi` 方法 | `@XxxRpcClient.java:lineStart-lineEnd` → RPC Client 封装模式 |
| Service 编排 | `*ServiceImpl.java`（非 application 层） | `@XxxServiceImpl.java:lineStart-lineEnd` → Service 编排模式 |
| Mapper 查询 | `*Mapper.java` + `@Select`/`select` | `@XxxMapper.java:lineStart-lineEnd` → Mapper 查询模式 |
| 参数校验 | `*ManagerImpl.java` + 校验方法 | `@XxxManagerImpl.java:lineStart-lineEnd` → 参数校验模式 |
| RPC 配置 | `*Config.java` + `@Bean` | `@XxxConfig.java:lineStart-lineEnd` → RPC Bean 配置模式 |
| Thrift 入口 | application 层 `*ServiceImpl.java` | `@XxxServiceImpl.java:lineStart-lineEnd` → Thrift 方法入口模式 |

### Step 4：任务拆解

将需求拆解为编号任务，每个任务包含：

1. **任务标题** + 工作量估算（pd）
2. **参考实现**：从 Step 3 的锚点列表中选取最相关的，用 `@FilePath:lineNumber` 格式标注
3. **实现步骤**：3-6 个具体步骤
4. **设计决策**：该任务涉及的关键设计选择及理由

拆解原则：
- 按依赖关系排序（基础设施 → 业务逻辑 → 接口暴露 → 联调）
- 每个任务对应 2-5 个文件的变更
- 核心任务标出，给出更详细的步骤说明
- 与用户确认拆解粒度，不符合需求则调整

### Step 5：生成 plan.md

按模板生成 `docs/<feature>/plan.md`，包含以下章节：

- **Context**：功能背景、目标、架构链路
- **接口汇总**：接口编号、名称、路径、数据来源、apiKey
- **开发任务**：Step 4 的所有任务（含参考锚点、步骤、决策）
- **基础设施**：已有能力（复用清单）+ 需新增 + 代码分层树
- **待确认事项**：表格形式，标注找谁、状态、备注
- **相关文档**：PRD、技术方案等链接

模板引用：`references/templates/plan-template.md`

### Step 6：生成 progress.md + 初始化

按模板生成 `docs/<feature>/progress.md`：

- 所有任务初始状态设为 `⬜ 未开始`
- 总体状态设为 `⬜ 待开发`
- 变更日志首条记录创建时间
- 待确认事项从 plan.md 同步，状态初始为 `🟡 待确认`

模板引用：`references/templates/progress-template.md`

完成后提示用户：

> plan.md 和 progress.md 已生成在 `docs/<feature>/`。确认无误后，运行 `/sd-apply` 开始开发。

## 关键原则

- **每次只问一个问题**：参考实现确认、feature 目录、拆解粒度，逐项确认
- **产出必须经用户确认**：plan.md 内容确认后才能写入文件
- **锚点优先**：宁可少标注，不编造 FilePath 和 lineNumber
- **沿用现有模式**：如果项目已有类似功能的 plan.md，参考其组织方式
