---
name: domain-modeling
description: 构建并维护项目的领域模型。适用于讨论代码库领域术语、编写或编辑 AGENTS.md 中的领域术语表。
---

# 领域建模（Domain Modeling）

在设计或对齐过程中主动构建并维护项目的 domain model：统一领域术语（Canonical Terms）、通过边界场景验证概念定义，并在概念或架构决策确定时更新项目 `AGENTS.md` 中的 `## Domain Glossary` 节。

## 文件结构

术语表默认与 agent 环境指针同居一处：写在项目根目录 `AGENTS.md` 的 `## Domain Glossary` 节，不单独创建 `GLOSSARY.md`。

```text
/
|- AGENTS.md   # 含 ## Domain Glossary 节
- src/
```

若仓库包含多个限界上下文（Multiple Bounded Contexts），根 `AGENTS.md` 的 `## Domain Glossary` 节不再列具体术语，而是充当 Glossary Map，指向各上下文自己的 `GLOSSARY.md`：

```text
/
|- AGENTS.md       # ## Domain Glossary 节 -> Glossary Map
|- docs/
`- src/
   |- ordering/
   |  |- GLOSSARY.md
   `- billing/
      |- GLOSSARY.md
```

不再新建 `GLOSSARY-MAP.md`；已有该文件的仓库可直接沿用，只把根 `AGENTS.md` 视为权威入口。

按需懒创建：仅在有实际术语需要写入时才创建 `AGENTS.md`（或仅补上该节），不留空标题占位。

## 执行准则

### 对照术语表核对（Check Against Glossary）

当用户使用的术语与 `AGENTS.md` 中既有定义冲突时，立即指出冲突并请用户确认采用哪一定名。

### 收敛模糊与过载术语（Refine Ambiguous Terms）

当用户使用含义模糊或过载的词汇（例如用“账户”混指 Customer 与 User）时，提出精确的 canonical term 区分概念边界。

### 边界场景验证（Edge-Case Scenario Testing）

讨论领域实体关系或状态转换时，构造具体的边界场景（Edge Cases）检验概念定义是否完备。

### 与代码现状交叉核对（Cross-Check with Codebase）

当用户描述业务规则或领域行为时，核对现有代码实现（必要时派发只读 `scout` 子代理查询）。若描述与代码现状矛盾，明确指出差异并请用户确认。

### 即时更新术语表

当一个领域术语的定义确定后，立即按 [`GLOSSARY-FORMAT.md`](./GLOSSARY-FORMAT.md) 更新 `AGENTS.md` 的 `## Domain Glossary` 节。术语表仅记录纯领域概念定义，严禁写入具体实现细节或临时需求草稿。
