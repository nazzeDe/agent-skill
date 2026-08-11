# CONTEXT.md Format

A context document is a concise, human-facing DDD reference. Use the repository's existing structure when present.

```markdown
# <Bounded Context Name>

<One or two sentences describing its purpose and boundary.>

## Ubiquitous Language

**<Term>**

<Precise domain meaning.>

_Avoid:_ <ambiguous synonym>, <overloaded synonym>

## Relationships

<Stable relationships between domain concepts or neighboring contexts.>

## Invariants

- <Business rule that must always hold.>

## State Meanings

**<State>**

<What this state means in the domain, not how it is implemented.>
```

Include only stable domain knowledge useful to human maintainers. Exclude code structure, database schema, API shape, temporary feature requirements, agent instructions, prompts, and workflow state.
