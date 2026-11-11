---
name: domain-modeling
description: 构建并维护项目的领域模型。适用于讨论代码库领域术语、编写或编辑 GLOSSARY.md，或记录与更新架构决策记录（ADR）。
---

# 领域建模（Domain Modeling）

在设计或对齐过程中主动构建并维护项目的 domain model：统一领域术语（Canonical Terms）、通过边界场景验证概念定义，并在概念或架构决策确定时更新 `GLOSSARY.md` 与 `docs/adr/`。

## 文件结构

单一上下文（Single-context）仓库结构：

```text
/
|- GLOSSARY.md
|- docs/
|  `- adr/
|     |- 0001-event-sourced-orders.md
|     `- 0002-postgres-for-write-model.md
`- src/
```

若根目录存在 `GLOSSARY-MAP.md`，表示仓库包含多个限界上下文（Multiple Bounded Contexts）：

```text
/
|- GLOSSARY-MAP.md
|- docs/
|  `- adr/                          -> 全局架构决策
`- src/
   |- ordering/
   |  |- GLOSSARY.md
   |  `- docs/adr/                  -> 上下文专属决策
   `- billing/
      |- GLOSSARY.md
      `- docs/adr/
```

按需懒创建文件：仅在有实际内容需要写入时创建 `GLOSSARY.md` 或 `docs/adr/`。

## 执行准则

### 对照术语表核对（Check Against Glossary）

当用户使用的术语与 `GLOSSARY.md` 中既有定义冲突时，立即指出冲突并请用户确认采用哪一定名。

### 收敛模糊与过载术语（Refine Ambiguous Terms）

当用户使用含义模糊或过载的词汇（例如用“账户”混指 Customer 与 User）时，提出精确的 canonical term 区分概念边界。

### 边界场景验证（Edge-Case Scenario Testing）

讨论领域实体关系或状态转换时，构造具体的边界场景（Edge Cases）检验概念定义是否完备。

### 与代码现状交叉核对（Cross-Check with Codebase）

当用户描述业务规则或领域行为时，核对现有代码实现（必要时派发只读 `scout` 子代理查询）。若描述与代码现状矛盾，明确指出差异并请用户确认。

### 即时更新 `GLOSSARY.md`

当一个领域术语的定义确定后，立即按 [`GLOSSARY-FORMAT.md`](./GLOSSARY-FORMAT.md) 更新 `GLOSSARY.md`。`GLOSSARY.md` 仅记录纯领域概念定义，严禁写入具体实现细节或临时需求草稿。

### 按严格标准提议 ADR

仅当某项决策同时满足以下三项条件时，才提议按 [`ADR-FORMAT.md`](./ADR-FORMAT.md) 创建 ADR：

1. **Hard to reverse** — 后续逆转或替换该决策的工程成本高；
2. **Surprising without context** — 缺乏背景的后续维护者看到代码会难以理解为何采用该方案；
3. **The result of a real trade-off** — 存在可行的替代方案，且基于明确工程理由做出了取舍。

缺少任一条件则不创建 ADR。
