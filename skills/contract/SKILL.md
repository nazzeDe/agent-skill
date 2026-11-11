---
name: contract
description: 基于已锁定的代码签名，编写高信息密度的行为契约测试（Contract Tests）与微观故障隔离测试（Fault-Isolation Tests），并剔除低价值冗余测试。
disable-model-invocation: true
---

# 行为契约与故障隔离测试（Contract）

以 **“少即是多（Less is More）”** 与 **“接口即程序，测试即程序”** 为准则，基于已定义的函数签名编写预期失败（Failing / Red）的高密度测试。

## 确定测试靶点（Macro Seam & Micro Fault-Isolation）

检查待实现的函数调用链（$F = f_c \circ f_b \circ f_a$），仅在以下两类位置放置测试：
* **宏观公共入口（Public Seam Contract）**：在模块对外暴露的公共接口上编写测试，使读者仅读测试即可理解该模块的输入输出契约与边界行为。
* **微观非平庸转换节点（Micro Fault-Isolation Tests）**：对内部承担独立算法、复杂分支或核心数据变换的子函数（$f_a, f_b$），编写轻量输入输出测试。当系统出错时，这些测试可直接在调用链上进行二分故障隔离（Binary Fault Isolation），避免全链路黑盒调试。
* **完成判据**：每个测试靶点均具有明确的接口契约描述价值或二分故障隔离价值。

## 编写高密度失败测试（Failing Tests / Red）

编写测试代码并遵守以下准则：
* **表驱动优先（Table-Driven）**：同一函数若有多个输入输出边界，合并为一张紧凑的输入输出映射表，严禁复制粘贴多个结构雷同的测试函数。
* **独立字面量断言（Literal Assertions）**：期望值（Expected Value）必须使用独立已知的字面量或具体样本，严禁在测试中将待测实现逻辑重写一遍来计算期望值（Tautological Test）。
* **严禁四类低价值测试**：
  * **不测平庸透传（Trivial Pass-Through）**：无实质逻辑的代码（简单数据组装、参数原样转发、getter/setter）不写测试。
  * **不与静态类型重复（Type-Redundant）**：静态类型系统已保证不可能发生的非法输入，不写运行时测试。
  * **不写耦合实现的交互 Mock（Implementation-Coupled Mocks）**：严禁 Mock 内部协作者并断言“先调用 A 再调用 B”；仅验证接口的输入与可观测输出。
  * **不写等价类冗余枚举（Redundant Enumeration）**：同一等价类仅保留边界代表（Boundary Representatives），剔除无信息增量的枚举样本。
* **验证预期失败（Red Verification）**：运行测试命令，确认所有新增测试均通过编译，且**因预期的业务逻辑尚未实现（如触发 `todo!()` 或断言失败）而失败**，而非因语法、类型或导入错误而失败。
* **完成判据**：新测试全部通过编译，且因预期业务未实现而失败（Red）。

## 测试信噪比审查（Test SNR Gate）

在交付测试前，对新增测试 Diff 执行信噪比筛查：
* 若当前执行环境允许派生子代理：启动一个全新上下文的只读 `reviewer` 子代理，指令其读取并遵循 `/home/nazze/.agents/skills/refine/TEST-SNR-REVIEW.md` 审查新增测试，根据返回结果删改直至 `PASS`。
* 若当前已是叶节点子代理：读取 `/home/nazze/.agents/skills/refine/TEST-SNR-REVIEW.md` 对照自检，剔除冗余测试并补齐缺失的微观故障隔离测试。
* **完成判据**：所有低信噪比测试已被剔除，剩余测试兼具最小体积与完整的故障隔离定位能力。
