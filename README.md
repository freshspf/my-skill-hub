# my-skill-hub

后端开发技能集线器，覆盖从需求梳理到复盘归档的完整 SDD（Spec-Driven Development）工作流。

---

## SDD 工作流

```
需求文档 / PRD
       ↓
/brainstorming    → 聊透需求，输出 spec 文档
       ↓
/sd-plan          → 拆解任务，输出 plan.md + progress.md
       ↓
/sd-apply         → 逐任务开发 + 自测，同步更新 progress.md
       ↓
/sd-verify        → 联调验证，输出 curl-test.md
       ↓
/retro            → 复盘归档，输出复盘文档
```

完整文档：[SDD 开发工作流：结构化开发全流程指南](https://docs.xiaohongshu.com/doc/11af0264c7934c2c183da6f206bd9bf5)

---

## 技能清单

### 核心开发流（SDD）

| 技能 | 命令 | 说明 |
|------|------|------|
| `sd-plan` | `/sd-plan` | 任务拆解：探索相似实现 → 标注 `@FilePath:lineNumber` → 生成 `plan.md` + `progress.md` |
| `sd-apply` | `/sd-apply` | 逐任务开发 + 自测，每完成一个任务立即更新 `progress.md` |
| `sd-verify` | `/sd-verify` | 联调验证：逐接口 curl 测试 → 生成 `curl-test.md` → 修复集成问题 |

### 已有技能

| 技能 | 说明 |
|------|------|
| `brainstorming` | 需求梳理：聊透接口、流程、数据来源、模糊点 |
| `retro` | 收尾复盘：提取会话上下文，生成结构化复盘文档 |
| `codebase-onboarding` | Java/Spring Boot 项目入门：自动分析生成 00-07 文档 |
| `kb-sync` | 知识库索引同步：扫描新模块，更新 CLAUDE.md + 个人画像.md |
| `handoff` | 跨会话上下文接力：生成 HANDOFF.md 保存断点 |
| `tikz-diagram` | TikZ 矢量图生成：架构图、流程图、神经网络图 |

---

## 文件结构

```
my-skill-hub/
├── README.md
├── sd-plan/
│   ├── SKILL.md
│   └── references/templates/
│       ├── plan-template.md
│       └── progress-template.md
├── sd-apply/
│   └── SKILL.md
├── sd-verify/
│   ├── SKILL.md
│   └── references/templates/
│       └── curl-test-template.md
├── retro/
│   └── SKILL.md
├── codebase-onboarding/
│   └── SKILL.md
├── kb-sync/
│   └── SKILL.md
├── handoff/
│   └── SKILL.md
└── tikz-diagram/
    ├── SKILL.md
    ├── references/
    ├── scripts/
    ├── templates/
    └── assets/
```

---

## 安装

将技能目录复制到 `~/.claude/skills/` 下：

```bash
cp -r sd-plan sd-apply sd-verify ~/.claude/skills/
```
