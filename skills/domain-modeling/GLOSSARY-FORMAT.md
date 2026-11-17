# 领域术语表格式（`AGENTS.md` 的 `## Domain Glossary` 节）

术语表默认写在项目根目录 `AGENTS.md` 的 `## Domain Glossary` 节内。它与环境指针同处一个文件，因此整个文件仍需极度精简：只有该节承载内容，不写工作流编排规则。

## 结构

```md
## Domain Glossary

{One or two sentence description of what this context is and why it exists.}

**Order**:
{A one or two sentence description of the term}
_Avoid_: Purchase, transaction

**Invoice**:
A request for payment sent to a customer after delivery.
_Avoid_: Bill, payment request

**Customer**:
A person or organization that places orders.
_Avoid_: Client, buyer, account
```

## 规则

- **Be opinionated.** 当多个词指向同一概念时，选出最好的那个，并把其他词列在 `_Avoid_` 下。
- **Keep definitions tight.** 最多一两句话。定义它是什么，而不是它做什么。
- **Only include terms specific to this project's context.** 一般编程概念（timeouts、error types、utility patterns）不属于这里，即使项目大量使用它们。添加 term 前先问：这是该 context 独有的概念，还是通用编程概念？只有前者属于这里。
- **Group terms under subheadings** when natural clusters emerge. 如果所有 terms 都属于一个 cohesive area，平铺列表也可以。

## 单 context 与多 context repos

**Single context（多数 repos）：** 术语直接列在根 `AGENTS.md` 的 `## Domain Glossary` 节。

**Multiple contexts：** 根 `AGENTS.md` 的 `## Domain Glossary` 节改为 Glossary Map，列出 contexts、它们的位置和彼此关系；每个 context 各自维护一份 `GLOSSARY.md`（标题为该 context 名），不再另建 `GLOSSARY-MAP.md`。

```md
## Domain Glossary

## Contexts

- [Ordering](./src/ordering/GLOSSARY.md) - receives and tracks customer orders
- [Billing](./src/billing/GLOSSARY.md) - generates invoices and processes payments
- [Fulfillment](./src/fulfillment/GLOSSARY.md) - manages warehouse picking and shipping

## Relationships

- **Ordering -> Fulfillment**: Ordering emits `OrderPlaced` events; Fulfillment consumes them to start picking
- **Fulfillment -> Billing**: Fulfillment emits `ShipmentDispatched` events; Billing consumes them to generate invoices
- **Ordering -> Billing**: Shared types for `CustomerId` and `Money`
```

各 context 的 `GLOSSARY.md` 沿用同一结构，首行标题写作 `# {Context Name}`，直接以事实性描述开头，其余规则不变。

Skill 会推断应使用哪种结构：

- 如果根 `AGENTS.md` 的 `## Domain Glossary` 节已列出多个 context 指针（或仓库已有 `GLOSSARY-MAP.md`），按多 context 处理
- 如果该节直接列出术语，按 single context 处理
- 如果两者都没有，当第一个 term 被解决时懒创建根 `AGENTS.md` 的该节

存在多个 contexts 时，推断当前主题属于哪一个。如果不清楚，就询问。
