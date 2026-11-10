---
name: retro
description: "对一次 coding session 做 retrospective。"
disable-model-invocation: true
---

用户要求做一次 **retrospective**。你要针对 coding agent 的 **environment** 提出改进建议，以改善未来的运行结果。

## 步骤

1. 调用 Skill 工具并指定 `writing-for-agents`，获取写作风格指南。

2. 阅读用户指定 session 的 primary sources。这可能意味着在本机搜索 session logs。如果用户没有指定 session，默认使用当前 session。

3. 在以下类别中寻找改进候选项。

- **Navigation**：agent 找到正确 files 有多容易？files 之间是否存在隐藏依赖？navigation pointer 能否让定位更容易？当 agent 花了很长时间才找到某段信息时使用。
- **Automated checks（Static Gate）**：是否有确定性静态检查可以捕获 agent 犯的错误？例如编译检查、linting、typing、tests、`crapper`、`dryer` 或 AST 规则？先阅读项目的 `./scripts/gate` 及 CI 配置。凡是能用确定性静态工具拦截的问题，一律优先写入 `./scripts/gate` 或 Linter 配置，绝不留给 AI 审查。
- **Code taste & Comment rules**：是否应该向 `docs/agents/taste.md`（见 `/taste` skill）或 `docs/agents/comment-guidelines.md` 沉淀新规则？先对问题分类：**mechanical** 违规（固定语法模式、被禁用的 API、死代码注释、分步解说注释）必须交给 `./scripts/gate` 中的静态工具处理；`docs/agents/taste.md` 只用于真正的 **语义表达与契约减法判断**（`when -> instead -> why`）。
- **AGENTS.md 污染清理**：检查项目的 `AGENTS.md` / `CLAUDE.md` 是否混入了工作流编排规则或冗长说明。`AGENTS.md` 只应保留指向 `./scripts/gate`、`GLOSSARY.md`、`docs/agents/taste.md` 的极简环境指针。
- **Tool economy**：agent 是否进行了可以简化的昂贵 tool calls？是否有特别消耗 tokens 的自定义 tooling（CLI、MCP 等）？当 agent 进行昂贵 tool call 时使用。
- **No-ops**：steering files 中是否有不改变 agent 行为的 instructions？当 steering files 庞大且难以维护时使用。
- **Information access**：是否有机会让 agent 获得更多信息？例如把 dev server logs tee 出来，或提供对 third-party services 的 read-only access。当关键的信息对 agent 不可用时使用。

4. 按严重程度顺序向用户呈现这些候选项。

## 参考

### Implementation 与 Review

记住，所有工作都经过两个阶段：implementation 和 review。implementation agent 承受最大的 **context pressure**，负责探索、编写代码和调试失败。

review agent 承受最小的 context pressure：它收到的是 diff，因此不需要探索。它通常也不需要编写代码或调试。

因此，review agent 应负责施加 coding standards，而不是 implementation agent。

### 文件

你可以访问 repo 中的几个 files：

- `CLAUDE.md`/`AGENTS.md`：会被推入在此 repo 工作的任何 agent 的 context window。必须极度克制，只放指向 `./scripts/gate`、`GLOSSARY.md`、`docs/agents/taste.md` 等环境事实的指针，绝不写入工作流编排规则。
- `docs/agents/taste.md`：在 `refine` 阶段由 Taste Reviewer 读取，而不在 implementation 时全量加载。
- Docs：把 docs 当作 reference files，由其他 files 通过 pointers 指向。写新 docs 前先查找已有 docs。
- Skills：用 skills 承载 docs（因为它们的 description 会进入 agent 的 context window），或用于 user-invoked commands。遵循 `writing-for-agents` skill 中的建议。
