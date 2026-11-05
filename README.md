# my-skill-hub

个人技能集线器：学习、开发、写作与面试等可复用工作流。

---

## 技能清单

### 已有技能

| 技能 | 说明 |
|------|------|
| `agent-instructions` | 统一管理所有 AI harness 的全局与项目级指令文件（AGENTS.md / CLAUDE.md / GEMINI.md 等）。 |
| `ai-friends` | AI 友好化工程建设顾问。 |
| `bago-answers` | 面试八股文答案生成器。 |
| `brainstorming` | 在任何创意工作之前必须使用 - 创建功能、构建组件、添加功能或修改行为。 |
| `browser-use` | Automates browser interactions for web testing, form filling, screenshots, and data ext… |
| `code-study-doc` | 代码研读学习文档生成器。 |
| `codebase-onboarding` | Use when a developer (especially a new team member or intern) needs to systematically u… |
| `frontend-design` | Create distinctive, production-grade frontend interfaces with high design quality. Use … |
| `handoff` | 跨会话上下文接力。 |
| `humanizer` | Rewrite AI-sounding text so it reads like the writer without changing what it says. Use… |
| `interview-playbook-generator` | 项目/实习面试话术生成器。 |
| `learn-in-layers` | 分层学习法教练。 |
| `project-coach` | 项目面试辅导教练。 |
| `ptdd` | 帮助完成从方案设计到实施的完整流程。 |
| `resume-optimizer-java` | 专属简历优化器，面向大厂 Java 后端秋招。 |
| `retro` | 需求复盘文档生成。 |
| `web-design-guidelines` | Review UI code for Web Interface Guidelines compliance. Use when asked to "review my UI… |

---

## 文件结构

```
my-skill-hub/
├── README.md
└── <skill-name>/
    ├── SKILL.md
    └── references/ | scripts/ | assets/   （可选）
```

---

## 安装

把需要的技能目录软链到对应 harness 的 skills 目录，例如：

```bash
ln -s "$PWD/<skill-name>" ~/.claude/skills/<skill-name>
```
