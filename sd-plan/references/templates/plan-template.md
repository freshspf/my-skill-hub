# <feature-name> — 开发计划

> 最后更新：YYYY-MM-DD
> 实现位置：<service-name>

---

## Context

<2-3 段说明：功能是什么、为什么需要做、架构链路>

---

## 接口汇总

| # | 接口 | 路径 | 数据来源 | apiKey |
|---|------|------|----------|--------|
| 1 | ... | ... | ... | ... |

---

## 开发任务

### 任务 1：<任务名>（<人天>pd）

**参考实现**：
- <模式名称> @src/main/java/.../<ClassName>.java:<lineStart>-<lineEnd>

**实现步骤**：
1. <步骤描述>
2. <步骤描述>

**设计决策**：
- <关键决策及理由>

---

## 基础设施

### 已有能力（无需新增）

| 能力 | 类/配置 | 复用说明 |
|------|---------|---------|

### 需新增

| 能力 | 类型 | 说明 |
|------|------|------|

### 代码分层

```
application/thrift/.../XxxServiceImpl.java  ← 新增方法
service/.../XxxService.java                 ← 接口
service/impl/.../XxxServiceImpl.java        ← 业务编排
manager/.../XxxManager.java                 ← 接口
manager/impl/.../XxxManagerImpl.java        ← 编排逻辑
rpcclient/.../XxxRpcClient.java             ← RPC 封装
config/.../XxxConfig.java                   ← RPC 配置
dal/mapper/.../XxxMapper.java               ← 数据查询
```

---

## 待确认事项

| # | 事项 | 找谁 | 状态 | 备注 |
|---|------|------|------|------|
| 1 | ... | ... | 🟡 待确认 | |

---

## 相关文档

| 文档 | 链接 |
|------|------|
| PRD | <链接> |
| 技术方案 | <链接> |
