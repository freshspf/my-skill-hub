# 多工具软链接架构指南

## 设计思路

现代项目通常同时使用多个 AI 编码工具。通过软链接架构，将 skills 和 commands 统一存储在 `agent_docs/` 中，各工具目录通过软链接指向同一来源，实现一处维护、多端共享。

## 架构图

```
project/
├── AGENTS.md                                       # AI 指令主文件（唯一真实来源）
├── CLAUDE.md          -> AGENTS.md                  # Claude Code 入口（软链接）
├── .agents/skills     -> ../agent_docs/skills       # Agents 扫描路径
├── .opencode/skills   -> ../agent_docs/skills       # OpenCode 扫描路径
├── .cursor/skills     -> ../agent_docs/skills       # Cursor 扫描路径
├── .codewiz/skills    -> ../agent_docs/skills       # CodeWiz 扫描路径
├── .claude/skills     -> ../agent_docs/skills       # Claude Code 扫描路径
├── .kiro/skills       -> ../agent_docs/skills       # Kiro 扫描路径
├── .agents/commands   -> ../agent_docs/commands     # Agents 命令路径
├── .opencode/commands -> ../agent_docs/commands     # OpenCode 命令路径
├── .cursor/commands   -> ../agent_docs/commands     # Cursor 命令路径
├── .codewiz/commands  -> ../agent_docs/commands     # CodeWiz 命令路径
├── .claude/commands   -> ../agent_docs/commands     # Claude Code 命令路径
├── .kiro/commands     -> ../agent_docs/commands     # Kiro 命令路径
├── agent_docs/skills/                               # Skills 实际存储位置
│   ├── ptdd/
│   │   ├── SKILL.md
│   │   └── rules/
│   └── vitest/
│       ├── SKILL.md
│       └── references/
└── agent_docs/commands/                             # Commands 实际存储位置
    ├── commit.md
    ├── fix-conflicts.md
    └── code-simplifier.md
```

## AGENTS.md 与 CLAUDE.md

`AGENTS.md` 是项目的 AI 指令主文件，所有 AI 工具的行为规范统一在此维护。

`CLAUDE.md` 是指向 `AGENTS.md` 的软链接，因为 Claude Code 默认读取 `CLAUDE.md` 作为项目指令。通过软链接保证两者内容始终一致，避免重复维护。

```bash
# 创建软链接（仅首次）
ln -s AGENTS.md CLAUDE.md
```

## 初始化软链接

一次性设置所有 AI 工具的 skills 和 commands 软链接：

```bash
for editor in .agents .opencode .cursor .codewiz .claude .kiro; do
  mkdir -p "${editor}"
  rm -rf "${editor}/skills"
  ln -sf ../agent_docs/skills "${editor}/skills"
  rm -rf "${editor}/commands"
  ln -sf ../agent_docs/commands "${editor}/commands"
  echo "Done: ${editor}/skills & ${editor}/commands"
done
```

## 验证软链接

```bash
ls -la \
  .agents/skills .opencode/skills .cursor/skills .codewiz/skills .claude/skills .kiro/skills \
  .agents/commands .opencode/commands .cursor/commands .codewiz/commands .claude/commands .kiro/commands

# 应该看到类似输出:
# lrwxr-xr-x .agents/skills     -> ../agent_docs/skills
# lrwxr-xr-x .claude/skills     -> ../agent_docs/skills
# ...
```

## 添加新 Skill

直接在 `agent_docs/skills/` 下创建子目录即可，所有工具自动生效：

```bash
# 例如: 从 GitHub 下载 vitest skill
cd /tmp
git clone --depth 1 --filter=blob:none --sparse https://github.com/antfu/skills.git
cd skills && git sparse-checkout set skills/vitest
cp -r skills/vitest ~/project/agent_docs/skills/
```

## 添加新 Command

直接将命令文件放入 `agent_docs/commands/`：

- 文件名使用 kebab-case，如 `fix-conflicts.md`
- 所有 command 文件末尾追加 `$ARGUMENTS` 占位符，支持工具传参

## 优势

1. **版本控制**：所有内容在 `agent_docs/` 下，可以被 git 追踪
2. **统一管理**：一个地方存储，多个入口共享
3. **零维护**：新增 skill/command 后无需手动更新软链，自动对所有入口生效
4. **跨工具复用**：支持 Claude Code、Cursor、CodeWiz、OpenCode、Kiro 等工具共享同一套 skills & commands

## Skill 来源

- [antfu/skills](https://github.com/antfu/skills) - 社区 skills 集合
- 自定义 skills - 在 `agent_docs/skills/` 中创建
