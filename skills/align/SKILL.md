---
name: align
description: 通过决策树追问对齐模糊想法、计划或需求，消除隐式假设。
disable-model-invocation: true
---

# 决策树追问与意图对齐（Align）

持续访谈用户，直到达成共同理解。把待澄清的主题映射为一棵 **design tree**：每个 decision 分支到依赖它的下游 decisions。

* **需求源加载（可选）**：若用户传入了本地草稿路径（如 `.scratch/*.md`）或 GitHub Issue（`#编号` 或 URL，用 `gh issue view` 获取），先读取全文作为起始意图。
* **领域模型协同（可选）**：若当前处于代码仓库中且涉及领域概念或架构决策，可按需配合 `/domain-modeling`（[`/home/nazze/.agents/skills/domain-modeling/SKILL.md`](/home/nazze/.agents/skills/domain-modeling/SKILL.md)）核对或更新术语与 ADR。

## 追问机制（Frontier Rounds）

按 **rounds** 逐轮处理这棵树。**frontier** 是那些前置条件（prerequisites）已经确定、现在就可以直接提问而无需猜测答案的问题集合。

* **事实归 Agent，决策归用户**：查证 **facts** 是 Agent 的职责，而非用户的职责。当某个 frontier 问题需要来自环境（文件系统、外部资料、工具等）的事实时，派发只读 `scout` 子代理查询，不向用户提问任何可自行查证的事实。先问当前 frontier 的其余部分，依赖探查结果的问题留到下一轮。
* **整轮并发提问**：在一轮里问完整条 frontier。依赖本轮未决问题答案的下游问题，属于更晚的一轮，不在本轮提前猜测提问。
* **自带推荐答案**：每个问题必须附带推荐答案，且措辞保证用户只需回复 `yes` 就是接受推荐方案。

每一轮提问格式：

```markdown
1. **<问题标题>**：<问题正文与背景/选项>

➡️ <推荐答案>

---

2. **<问题标题>**：<问题正文与背景/选项>

➡️ <推荐答案>
```

* **动态重算 Frontier**：每一轮用户的回答都会更新决策树——已确定的决策会将 frontier 向外推进，并解锁依赖它们的新问题。重新计算 frontier 后进入下一轮。

## 退出门禁（Ambiguity Gate）

当主会话认为 frontier 已清空时，**严禁自行直接宣布完成**：
* **派发独立门禁**：启动一个全新上下文（`defaultContext: "fresh"`）的只读 `reviewer` 子代理，传入当前整理好的需求契约摘要，并指令其读取 `/home/nazze/.agents/skills/align/AMBIGUITY-GATE.md` 执行审查（主会话不要读取该文件）。
* **门禁闭环过滤**：
  * 若子代理返回 `PASS`：向用户展示最终需求契约摘要并完成确认（若暂不进入编码或用户要求留档，将核心意图、边界条件与关键决策写入 `.scratch/<slug>.md` 或同步至 GitHub Issue）。
  * 若子代理返回歧义点：凡可通过环境/代码库查证的事实，由主会话自行查明补齐；凡属尚未确定的业务决策分叉，转化为带 `➡️ 推荐答案` 的新一轮 frontier 向用户追问，直至门禁返回 `PASS`。
* **完成判据**：frontier 为空，独立门禁子代理返回 `PASS`，且用户确认最终对齐契约。
