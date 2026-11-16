---
name: refine
description: 调度职责正交的独立审查子代理（根因减法、测试信噪比、规约保真、代码品味、注释可读性）并驱动修复闭环，直至全部 PASS。
---

# 多维独立代码审查与重构调度（Refine）

针对**已通过全部静态门禁**的代码变更，按严格优先级调度全新上下文（`defaultContext: "fresh"`）的只读 `reviewer` 子代理。

* **上下文隔离准则**：调度者自身不要读取同目录下的审查细则文件；派发每个 `reviewer` 子代理时，仅把对应那一个审查文件的路径传给它，确保每个审查者职责单一、互不干扰。

## 第一阶段：根因与代码减法审查（串行一票否决）

确定基准点 `<base>`（如 `main` 或任务起始 commit）：
* **派发审查**：启动单个高推理能力 `reviewer` 子代理，传入一句话需求意图与 `git diff <base>...HEAD` 获取命令，指令其读取并遵循 `/home/nazze/.agents/skills/refine/SUBTRACTION-REVIEW.md`。
* **一票否决闭环**：
  * 若返回 `PASS`：进入第二阶段。
  * 若未返回 `PASS`：在冗余补丁未化简前，不启动后续微观审查。立即将减法重构方案派发给 `worker` 子代理修改代码并重跑项目静态门禁（`./scripts/gate`），完成后重新执行本阶段审查，直至返回 `PASS`。
* **完成判据**：Subtraction Reviewer 返回 `PASS`，且静态门禁保持通过。

## 第二阶段：四路正交并行审查（Parallel Fanout）

使用并行子代理同时启动以下四个独立 `reviewer`（均传入 `<base>...HEAD` 范围）：
* **测试信噪比审查**：指令子代理读取并遵循 `/home/nazze/.agents/skills/refine/TEST-SNR-REVIEW.md`。
* **规约保真审查**：传入原始需求契约，指令子代理读取并遵循 `/home/nazze/.agents/skills/refine/SPEC-REVIEW.md`。
* **代码品味审查**：指令子代理读取并遵循 `/home/nazze/.agents/skills/refine/TASTE-NOISE-REVIEW.md`，只审查局部代码结构，不检查注释。
* **注释可读性审查**：启动轻量级 `reviewer`，要求以首次阅读代码的维护者视角审查新增或修改的注释，并读取、遵循 `/home/nazze/.agents/skills/refine/COMMENT-REVIEW.md`。只传入该文件路径与 `<base>...HEAD` 获取命令；只读报告具体问题和最小改写建议，不直接修改文件。

## 汇总与修复闭环（Fix & Re-verify Loop）

* 若四路全部返回 `PASS`：审查阶段正式结束。
* 若任意一路返回具体问题：按 `SPEC-REVIEW > TEST-SNR-REVIEW > TASTE-NOISE-REVIEW > COMMENT-REVIEW` 的优先级合并修改要求，派发 `worker` 子代理一次性修复并重跑静态门禁（`./scripts/gate`），随后仅对未通过的维度复检，直至全部返回 `PASS`。
* **完成判据**：五个审查维度全部返回 `PASS`，静态门禁退出码为 `0`，输出精简的最终变更摘要。
