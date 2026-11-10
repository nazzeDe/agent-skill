---
name: refine
description: 调度正交分权的独立审查子代理（根因减法、测试信噪比、规约保真、代码品味与降噪）并驱动修复闭环，直至全部 PASS。
disable-model-invocation: true
---

# 正交分权审查与代数坍缩调度（Refine）

针对**已通过全部静态硬门禁**的代码变更，按严格优先级调度全新上下文（`defaultContext: "fresh"`）的只读 `reviewer` 子代理。

* **隔离铁律**：调度者自身不要读取同目录下的四个 `*-REVIEW.md` 细则文件；派发每个 `reviewer` 子代理时，仅把对应那一个审查文件的路径传给它，确保每个审查者视角绝对单一、互不污染。

## 第一阶段：根因与减法审查（串行一票否决）

确定基准点 `<base>`（如 `main` 或任务起始 commit）：
* **派发审查**：启动单个高推理能力 `reviewer` 子代理，传入一句话需求意图与 `git diff <base>...HEAD` 获取命令，指令其读取并遵循 `/home/nazze/.agents/skills/refine/SUBTRACTION-REVIEW.md`。
* **一票否决闭环**：
  * 若返回 `PASS`：进入第二阶段。
  * 若未返回 `PASS`：在臃肿补丁未压缩前，绝不启动后续微观审查。立即将减法重构方案派发给 `worker` 子代理修改代码并重跑项目静态门禁（`./scripts/gate`），完成后重新执行本阶段审查，直至返回 `PASS`。
* **完成判据**：Subtraction Reviewer 返回 `PASS`，且静态门禁保持全绿。

## 第二阶段：三路正交并行审查（Parallel Fanout）

使用并行子代理同时启动以下三个独立 `reviewer`（均传入 `<base>...HEAD` 范围）：
* **测试信噪比审查**：指令子代理读取并遵循 `/home/nazze/.agents/skills/refine/TEST-SNR-REVIEW.md`。
* **规约保真审查**：传入原始需求契约，指令子代理读取并遵循 `/home/nazze/.agents/skills/refine/SPEC-REVIEW.md`。
* **代码品味与降噪审查**：指令子代理读取并遵循 `/home/nazze/.agents/skills/refine/TASTE-NOISE-REVIEW.md`。

## 汇总与自愈闭环

* 若三路全部返回 `PASS`：审查阶段正式结束。
* 若任意一路返回具体问题：按 `SPEC-REVIEW > TEST-SNR-REVIEW > TASTE-NOISE-REVIEW` 的优先级合并修改要求，派发 `worker` 子代理一次性修复并重跑静态门禁（`./scripts/gate`），随后仅对未通过的维度复检，直至全部返回 `PASS`。
* **完成判据**：四个审查维度全部返回 `PASS`，静态门禁退出码为 `0`，输出极简的最终变更摘要。
