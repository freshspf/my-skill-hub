---
name: agent-instructions
description: 统一管理所有 AI harness 的全局与项目级指令文件（AGENTS.md / CLAUDE.md / GEMINI.md 等）。当用户说"配置新 harness 的规则"、"AGENTS.md 和 CLAUDE.md 怎么放"、"全局规则同步"、"把某工具接入我的全局配置"、"我的规则没生效"时使用。规则：一个真身 + 多条软链，只编辑真身，绝不复制。
---

# Agent Instructions 布局与同步规则

把所有 harness 的全局指令收敛成 **一个真身 + 多条软链**。本 skill 只讲规则，不附带脚本；按下面的步骤直接操作即可。

## 固定布局

```
~/.config/shared-agents/AGENTS.md          # 唯一真身，mode 600
        ↑
        ├── ~/.claude/CLAUDE.md            # Claude Code
        ├── ~/.codex/AGENTS.md             # Codex
        ├── ~/.zcode/AGENTS.md             # ZCode
        └── ~/.config/opencode/AGENTS.md   # opencode
```

项目级（每个仓库）：

```
<repo>/AGENTS.md                            # 真身
<repo>/CLAUDE.md -> AGENTS.md               # 相对软链
```

真身可能含凭据，必须 `chmod 600`。

## 配置顺序（照这个做，不要跳）

1. **确认真身**：`~/.config/shared-agents/AGENTS.md`；不存在就创建并 `chmod 600`
2. **合并内容**（从旧文件迁移时）：把各 harness 的旧规则按主题合并成一份，不丢任何小节
3. **全局接入**：让每个 harness 的全局指令路径成为指向真身的绝对软链
4. **项目规范化**：每个仓库用真 `AGENTS.md`，`CLAUDE.md` 为相对软链
5. **校验**：所有链接指向真身，`shasum -a 256` 全部相等
6. **告知用户**：下个会话才生效；真身含凭据时会进入所有 harness 的上下文

### 第 3 步的具体做法

```sh
CANON=~/.config/shared-agents/AGENTS.md
chmod 600 "$CANON"

# 目标已存在且是软链：改指向
ln -sfn "$CANON" ~/.claude/CLAUDE.md

# 目标是真文件：先看内容，一致就直接换链；不同则先合并，备份后再换
cmp -s ~/.codex/AGENTS.md "$CANON" && ln -sfn "$CANON" ~/.codex/AGENTS.md

# 目标不存在：直接建链
ln -s "$CANON" ~/.zcode/AGENTS.md
```

不要用 `cp` 制造第二份；不要再维护某一份“主文件”的例外。

### 第 4 步的具体做法

```sh
# 只有 CLAUDE.md 真文件：改名后建相对软链
mv repo/CLAUDE.md repo/AGENTS.md
ln -s AGENTS.md repo/CLAUDE.md

# 只有 AGENTS.md：补软链
ln -s AGENTS.md repo/CLAUDE.md

# 两者都是真文件：先 diff；内容相同才换链，不同则人工合并后再换
diff repo/AGENTS.md repo/CLAUDE.md
```

方向永远是 `CLAUDE.md -> AGENTS.md`，用相对路径。子目录里已有的独立 `AGENTS.md` 保持真文件，不用补 `CLAUDE.md`（它只影响该子树）。

## 接入一个新 harness

1. 查该工具的全局指令路径（文档里的 global instructions / user rules / memory）。常见位置：
   - `~/.<tool>/AGENTS.md`
   - `~/.<tool>/CLAUDE.md`
   - `~/.config/<tool>/AGENTS.md`
   - Gemini CLI：`~/.gemini/GEMINI.md`
2. 不确定就先看配置目录：`ls -la ~/.<tool>/ ~/.config/<tool>/ | grep -iE '\.md|rules|memory'`
3. 建绝对软链到真身：`ln -s ~/.config/shared-agents/AGENTS.md <path>`
4. 如果目标已有真文件：先 `diff`，内容不同就合并；需要保留旧文件时备份为 `<path>.bak.<时间>`
5. `readlink <path>` 和 `shasum -a 256` 校验
6. 查文档确认该工具真的读这个路径，不要假设

## 校验清单

```sh
readlink ~/.claude/CLAUDE.md ~/.codex/AGENTS.md ~/.zcode/AGENTS.md
shasum -a 256 ~/.config/shared-agents/AGENTS.md ~/.claude/CLAUDE.md ~/.codex/AGENTS.md ~/.zcode/AGENTS.md
```

全部 hash 相同、全部指向真身才算完成。

## 硬性规则

1. **只编辑真身**；任何 harness 路径都是软链，不改内容。
2. 新增 harness = 加一条软链，不新建副本。
3. 内容冲突先合并再建链；合并前把 `diff` 给人看，不自动选一边。
4. 纯改名/迁移要校验前后 hash，确认内容零变化。
5. 不提交、不推送，除非用户明确要求。
6. 真身含凭据时提醒一次：它现在会进入所有 harness 的每次会话。
7. skills 与 instructions 分开：`~/.config/shared-skills/` 放技能，`~/.config/shared-agents/` 放指令。

## 排障

- **规则没生效**：先 `readlink` 看是否指向真身；再看真身内容；最后确认是否新会话（当前会话加载的是旧内容）。
- **某工具读不到**：确认该工具的实际路径（不同版本可能改名），用最小改动测试一次。
- **链接指错/嵌套**：删掉重链，不要用 `ln -sf` 覆盖软链所在的目录。
- **两份内容分叉**：以真身为准合并，删除多余副本前先备份。
