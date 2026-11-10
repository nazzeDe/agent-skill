# 编程与代码仓库对齐扩展（Coding Context）

在软件项目或代码仓库中运行 `align` 时，叠加以下规则：

## 需求源读取与环境就绪

* **加载外部需求源**：若用户传入了本地草稿路径（如 `.scratch/*.md`）或 GitHub Issue（`#编号` 或 URL，用 `gh issue view` 获取），先读取全文作为起始意图。
* **读取既有领域契约**：检查并读取仓库中的 `GLOSSARY.md`（或 `GLOSSARY-MAP.md`）及相关 `docs/adr/`。

## 领域建模与代码交叉质询

在每一轮提问与整合回答时，主动保持领域模型与代码现状自洽：
* **对照术语表质询**：当用户用词与 `GLOSSARY.md` 既有定义冲突，或使用含糊过载词（如用“账户”混指 Customer 与 User）时，在当前轮次问题中直接指出，并给出精确的 canonical term 作为推荐答案。
* **对照代码现状质询**：派 `scout` 子代理核对代码实现。若用户的描述与现有代码行为矛盾，当场指出代码现状并请用户裁决。
* **边界场景探测**：讨论领域关系或状态流转时，构造具体的 edge-case 场景提问，迫使概念边界清晰化。
* **就地更新 `GLOSSARY.md`**：每当一个领域术语敲定，立即按 [`GLOSSARY-FORMAT.md`](GLOSSARY-FORMAT.md) 更新或懒创建 `GLOSSARY.md`（仅写纯领域定义，严禁混入实现细节）。
* **谨慎提议 ADR**：仅当某项决策同时满足 **难以逆转（Hard to reverse）**、**无背景则令人意外（Surprising without context）**、**真实权衡（Real trade-off）** 三项条件时，才提议按 [`ADR-FORMAT.md`](ADR-FORMAT.md) 写入 `docs/adr/`。

## 需求归档（按需执行）

当决策树全部敲定，若暂不立即进入 `skeleton` 编码阶段或用户要求留档：
* **本地归档（默认）**：将敲定的核心意图、边界条件与关键决策浓缩写入 `.scratch/<slug>.md`（或更新 `.scratch/issue.md`），不写冗余的 User Stories 模板。
* **远端同步**：若需求源自 GitHub Issue 或用户要求同步远端，使用 `gh issue edit` 或 `gh issue create` 更新。
