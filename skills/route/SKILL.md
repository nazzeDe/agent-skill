---
name: route
description: 编排 Agent 的开发工作流路由器与总控台。适用于接收开发需求、修复缺陷、重构代码、协助整理 GitHub Issue 或 .scratch 需求文档，或将任务分发给子代理按阶段执行时。
---

# 工作流路由与编排总控（Route）

本文件是**主控编排 Agent（Orchestrator）**与用户对话及调度子代理（Subagents）的操作手册。

## 编排者上下文隔离准则

* **主控仅负责意图对齐与任务调度，不读取阶段执行细则**：
  `skeleton`、`contract`、`work`、`refine` 四个阶段的 Skill 是供执行子代理（`worker` / `reviewer`）读取的。**主控编排 Agent 严禁在自己的上下文中用 `read` 读取这四个 `SKILL.md` 文件**，以保持主会话上下文精简。
* **通过路径指针派发任务（Task Dispatch via Pointers）**：
  当推进到对应阶段时，主控通过 `subagent` 工具派生 `worker` 或 `reviewer`，并在子代理的 `task` 指令中附上对应 Skill 的绝对路径（如：`先读取并严格遵循 /home/nazze/.agents/skills/skeleton/SKILL.md`），让子代理在自己独立的全新上下文（`fresh`）中加载执行。
* **按任务特征自动选配子代理模型（Model Routing）**：
  当所处 harness 的 `subagent` 工具支持指定模型（如提供 `model` 参数）时，在首次派发子代理前读取 [`MODELS.md`](MODELS.md)，根据**阶段类型、前后端领域与任务周期长短**为每个子代理选配最合适的模型；若 harness 不支持指定模型，忽略该文件并使用默认配置。

## 需求源管理（Requirement I/O）

编排者支持三种需求输入与归档方式：
* **读取需求源**：
  * **直接对话**：用户直接在当前会话描述意图；
  * **本地草稿**：读取 `.scratch/<slug>.md` 或 `.scratch/issue.md`；
  * **GitHub Issue**：当用户提及 `#编号` 或 Issue URL 时，运行 `gh issue view <id>` 拉取正文与评论。
* **需求对齐与归档**：
  * 若需求存在模糊点或未决分支，主控在当前会话读取并运行 [`/align`](/home/nazze/.agents/skills/align/SKILL.md)，通过决策树问答与用户对齐（在代码库内自动维护 `GLOSSARY.md`）。
  * 对齐后若暂不编码或用户要求留档，将确定的核心意图、边界与接口决策写入 `.scratch/<slug>.md`，或用 `gh issue create` / `gh issue edit` 同步至远端。

## 核心开发管道：`skeleton -> contract -> work -> refine`

根据初始需求的明确程度，动态选择切入阶段，按顺序调度子代理：

```text
[需求对齐 /align] ──> [1. skeleton 签名与类型定义] ──(人类确认签名)──> [2. contract 契约测试] ──> [3. work 实现与静态门禁] ──> [4. refine 多维审查]
```

### 动态切入判据
* **模糊新特性 / 跨模块改动**：先在主会话运行 `/align` 对齐意图，再从 `skeleton` 切入执行完整流程。
* **意图明确的功能 / 需定位上游根因的缺陷**：直接从派发 `skeleton` 子代理切入。
* **接口签名已存在且无需改动的局部修改**：直接从 `contract` 或 `work` 切入，后接 `refine`。

### 各阶段子代理调度契约

* **派发 `skeleton`（上游修改点定位 + 类型与接口签名定义）**
  * **动作**：派生单个 `worker` 子代理（使用高推理能力模型），指令其读取 `/home/nazze/.agents/skills/skeleton/SKILL.md`，传入对齐后的需求描述。
  * **子代理产出**：返回一句话上游修改点声明、源码中定义的类型与空函数签名（Stubs）Diff（已通过类型检查）、以及待实现函数的**单路/并行模块切分清单**。
  * **人类唯一常规确认点（Checkpoint）**：主控将“修改点依据 + 签名 Diff”展示给用户确认。**用户确认后，主控应全自动连续驱动后续 `contract -> work -> refine` 阶段，中途不再打扰用户。**

* **派发 `contract`（编写高密度失败测试 + 信噪比审查）**
  * **动作**：派生 `worker` 子代理，指令其读取 `/home/nazze/.agents/skills/contract/SKILL.md`。
  * **子代理产出**：在公共接口与关键内部转换节点编写预期失败（Red）的高密度测试（表驱动优先），并完成测试信噪比筛查（剔除四类低价值测试）。

* **派发 `work`（函数体实现 + 静态门禁校验与修复）**
  * **动作**：依据 `skeleton` 返回的模块切分清单：
    * **单模块**：派生单个 `worker` 子代理，指令其读取 `/home/nazze/.agents/skills/work/SKILL.md`；
    * **多正交模块**：使用并行 Worktrees（`worktree: true`）同时派生多个 `worker` 子代理，各自负责被分配的函数签名（严禁修改公共类型与签名），完成后合并回主工作树并执行一次项目静态门禁（`./scripts/gate`）。
  * **子代理产出**：所有契约测试通过（Green），且确定性静态门禁脚本（编译、Linter、测试、`crapper --no-coverage`、`dryer`、静态注释检查）退出码为 `0`。

* **派发 `refine`（多维独立审查 + 重构修复闭环）**
  * **动作**：派生子代理执行 `/home/nazze/.agents/skills/refine/SKILL.md` 的独立审查协议：
    * 先串行运行一票否决的 `Subtraction Reviewer`（消除下游局部补丁、冗余防御、范围外扩写与冗余文档）；
    * 通过后再三路并行运行 `Test SNR Reviewer`、`Spec Fidelity Reviewer`、`Taste & Comment Reviewer`；
    * 若有任何 Reviewer 未输出 `PASS`，主控立即派发 `worker` 修复并重跑静态门禁，直至全部达成 `PASS`。
  * **最终交付**：向用户汇报精简的最终变更摘要与 Diff 统计。

## 专用分支与维护工具

当任务不属于常规编码主流程时，按以下路径路由：

* **项目首次接入工作流** $\to$ 引导用户运行 `/init-project`（`/home/nazze/.agents/skills/init-project/SKILL.md`），通过一轮问答生成项目的 `./scripts/gate` 静态门禁、配置 Linter 注释规则与 Git Hook。
* **复杂缺陷无法复现或根因不明** $\to$ 读取并运行 [`/diagnosing-bugs`](/home/nazze/.agents/skills/diagnosing-bugs/SKILL.md)，先建立能稳定复现失败的最小回路；定位根因后转入 `skeleton` 或 `work`。
* **需要可运行代码来验证 UI 或状态机设计** $\to$ 使用 [`/handoff`](/home/nazze/.agents/skills/handoff/SKILL.md) 与 [`/prototype`](/home/nazze/.agents/skills/prototype/SKILL.md) 在独立分支制作一次性验证原型，得出结论后带回 `/align` 或 `skeleton`。
* **用户手动重构代码后沉淀规律** $\to$ 运行 `/taste`（`/home/nazze/.agents/skills/taste/SKILL.md`），将改动提炼为 `when -> instead -> why` 记入 `docs/agents/taste.md`。
* **会话复盘与静态规则沉淀** $\to$ 运行 `/retro`（`/home/nazze/.agents/skills/retro/SKILL.md`），将暴露出的问题转化为 `./scripts/gate` 中的确定性检查或 `taste.md` 条目。
* **存量代码库架构深化与巡检** $\to$ 运行 `/improve-codebase-architecture`（配合 `/codebase-design` 词汇表）。

## 阶段边界与上下文管理

关于何时留在当前会话（Continue）、何时清空（`/clear`）、何时派发 Subagent 或压缩（`/compact`），遵循 [`PHASE-BOUNDARIES.md`](PHASE-BOUNDARIES.md)。
