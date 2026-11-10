---
name: route
description: 编排 Agent 的开发工作流路由器与总控台。适用于接收开发需求、修复缺陷、重构代码、协助整理 GitHub Issue 或 .scratch 需求文档，或将任务分发给子代理按阶段执行时。
---

# 工作流路由与编排总控（Route）

本文件是**主控编排 Agent（Orchestrator）**与用户对话及调度子代理（Subagents）的操作手册。

## 编排者上下文隔离铁律

* **主控只做对齐与调度，绝不自读执行细则**：
  `skeleton`、`contract`、`work`、`refine` 四个阶段的 Skill 是写给执行子代理（`worker` / `reviewer`）看的。**主控编排 Agent 严禁在自己的上下文中用 `read` 读取这四个 `SKILL.md` 文件**，以防污染主会话窗口。
* **通过路径指针派单**：
  当推进到对应阶段时，主控通过 `subagent` 工具派生 `worker` 或 `reviewer`，并在子代理的 `task` 指令中附上对应 Skill 的绝对路径（如：`先读取并严格遵循 /home/nazze/.agents/skills/skeleton/SKILL.md`），让子代理在自己干净的独立上下文（`fresh`）中加载执行。

## 需求源协助（Requirement I/O）

编排者支持三种需求输入与留档方式，无需繁琐的工单流：
* **读取需求源**：
  * **直接对话**：用户直接在当前会话描述意图；
  * **本地草稿**：读取 `.scratch/<slug>.md` 或 `.scratch/issue.md`；
  * **GitHub Issue**：当用户提及 `#编号` 或 Issue URL 时，运行 `gh issue view <id>` 拉取正文与评论。
* **需求对齐与留档**：
  * 若需求存在模糊点或未决分支，主控在当前会话读取并运行 [`/align`](/home/nazze/.agents/skills/align/SKILL.md)，通过决策树问答与用户对齐（在代码库内自动维护 `GLOSSARY.md`）。
  * 对齐后若暂不编码或用户要求留档，将敲定的核心意图、边界与接口决策浓缩写入 `.scratch/<slug>.md`，或用 `gh issue create` / `gh issue edit` 同步至远端。

## 核心开发管道：`skeleton -> contract -> work -> refine`

根据初始需求的清晰度（分辨率），动态选择切入阶梯，按顺序调度子代理：

```text
[需求对齐 /align] ──> [1. skeleton 锁骨] ──(人类确认骨架)──> [2. contract 契约] ──> [3. work 填肉+门禁] ──> [4. refine 分权提纯]
```

### 动态切入判据
* **模糊新特性 / 跨模块改动**：先在主会话运行 `/align` 对齐意图，再从 `skeleton` 切入跑完全程。
* **意图明确的功能 / 需找根因支点的 Bug**：直接从派发 `skeleton` 子代理切入。
* **接口签名已存在且无需改动的局部修改**：直接从 `contract` 或 `work` 切入，后接 `refine`。

### 各阶段子代理调度契约

* **派发 `skeleton`（找上游支点 + 落盘代码骨架）**
  * **动作**：派生单个 `worker` 子代理（使用高推理能力模型），指令其读取 `/home/nazze/.agents/skills/skeleton/SKILL.md`，传入对齐后的需求描述。
  * **子代理产出**：返回一句话支点声明、源码中落盘的真实类型与空函数签名 Diff（已通过类型检查）、以及待实现函数的**单路/并行模块切分清单**。
  * **人类唯一常规确认点（Checkpoint）**：主控将“支点理由 + 骨架 Diff”展示给用户确认。**用户确认骨架后，主控应全自动连续驱动后续 `contract -> work -> refine` 阶段，中途不再打扰用户。**

* **派发 `contract`（编写高密度红灯测试 + 信噪比筛查）**
  * **动作**：派生 `worker` 子代理，指令其读取 `/home/nazze/.agents/skills/contract/SKILL.md`。
  * **子代理产出**：在公共入口与关键内部转换节点写好精准变红（Red）的高密度测试（表驱动优先），并完成测试信噪比筛查（无四类垃圾测试）。

* **派发 `work`（锁骨填肉 + 静态硬门禁自愈）**
  * **动作**：依据 `skeleton` 返回的模块切分清单：
    * **单模块**：派生单个 `worker` 子代理，指令其读取 `/home/nazze/.agents/skills/work/SKILL.md`；
    * **多正交模块**：使用并行 Worktrees（`worktree: true`）同时派生多个 `worker` 子代理，各自负责被分配的函数签名（严禁修改公共类型与签名），完成后合并回主工作树并执行一次项目静态门禁（`./scripts/gate`）。
  * **子代理产出**：所有契约测试变绿，且确定性静态门禁脚本（编译、Linter、测试、`crapper --no-coverage`、`dryer`、静态注释检查）退出码为 `0`。

* **派发 `refine`（正交分权审查 + 代数坍缩闭环）**
  * **动作**：派生子代理执行 `/home/nazze/.agents/skills/refine/SKILL.md` 的分权审查协议：
    * 先串行运行一票否决的 `Subtraction Reviewer`（砍除下游补丁、冗余防御、未请求镀金与腐烂文档）；
    * 通过后再三路并行运行 `Test SNR Reviewer`、`Spec Fidelity Reviewer`、`Taste & Noise Reviewer`；
    * 若有任何 Reviewer 未输出 `PASS`，主控立即派发 `worker` 修复并重跑静态门禁，直至全部达成 `PASS`。
  * **最终交付**：向用户汇报极简的最终变更摘要与 Diff 统计。

## 专用旁路与维护工具箱

当任务不属于常规编码主干流时，按以下路径路由：

* **项目首次接入工作流** $\to$ 引导用户运行 `/init-project`（`/home/nazze/.agents/skills/init-project/SKILL.md`），通过一轮问答生成项目的 `./scripts/gate` 静态门禁、配置 Linter 注释降噪与 Git Hook。
* **棘手 Bug 无法复现或根因不明** $\to$ 读取并运行 [`/diagnosing-bugs`](/home/nazze/.agents/skills/diagnosing-bugs/SKILL.md)，先建立能稳定变红的最小复现回路；定位根因后并入 `skeleton` 或 `work`。
* **需要可运行代码来回答 UI 或状态机设计问题** $\to$ 使用 [`/handoff`](/home/nazze/.agents/skills/handoff/SKILL.md) 与 [`/prototype`](/home/nazze/.agents/skills/prototype/SKILL.md) 在独立分支制作抛弃型原型，得出结论后带回 `/align` 或 `skeleton`。
* **用户亲手把代码改得更优雅后沉淀规律** $\to$ 运行 `/taste`（`/home/nazze/.agents/skills/taste/SKILL.md`），将改动提炼为 `when -> instead -> why` 记入 `docs/agents/taste.md`。
* **会话复盘与静态规则下沉** $\to$ 运行 `/retro`（`/home/nazze/.agents/skills/retro/SKILL.md`），将暴露出的问题下沉为 `./scripts/gate` 中的确定性检查或 `taste.md` 条目。
* **存量代码库深化与架构巡检** $\to$ 运行 `/improve-codebase-architecture`（配合 `/codebase-design` 词汇表）。

## 阶段边界与上下文卫生

关于何时留在当前会话（Continue）、何时清空（`/clear`）、何时派发 Subagent 或压缩（`/compact`），遵循 [`PHASE-BOUNDARIES.md`](PHASE-BOUNDARIES.md)。
