---
name: domain-modeling
description: Refine DDD boundaries, ubiquitous language, relationships, invariants, and durable decisions while keeping public documentation human-first.
---

# Domain Modeling

Use this while design work changes the domain model. Resolve user-owned meaning and boundaries with `grill-me`; verify repository facts directly.

## During Design

- Challenge ambiguous or overloaded terms.
- Use concrete scenarios and edge cases to distinguish concepts.
- Compare proposed language and rules with the code and existing human documentation.
- Keep unsettled working notes under `.scratch/<effort>/`; do not update public docs before approval.

## CONTEXT.md

A context document is public, human-facing DDD documentation. Follow the repository's existing location and format. If none exists, propose `docs/CONTEXT.md` and obtain approval before creating it.

Use [CONTEXT-FORMAT.md](CONTEXT-FORMAT.md). Record:

- bounded-context purpose and boundary;
- ubiquitous language and avoided synonyms;
- stable domain relationships;
- core business invariants and important state meanings.

Exclude implementation structure, database schema, API details, temporary requirements, prompts, skill instructions, and other agent-only content.

When a public update is warranted, show the exact proposed content and obtain user approval. After writing it, delete duplicate working notes from `.scratch`.

## ADRs

Follow the repository's existing ADR convention. If none exists, propose `docs/adr/` and obtain approval before creating it. Use [ADR-FORMAT.md](ADR-FORMAT.md).

Propose an ADR only when all are true:

1. changing the decision later would be costly;
2. future maintainers will need to know why;
3. real alternatives existed and were rejected for load-bearing reasons.

ADRs target human readers and contain no agent workflow instructions.
