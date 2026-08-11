# ADR Format

Follow the repository's existing ADR directory, numbering, naming, and metadata conventions. If none exist, propose `docs/adr/NNN-<slug>.md` and obtain user approval before creating the structure.

```markdown
# <Decision>

## Context
<The durable problem and constraints.>

## Decision
<What was chosen and why.>

## Consequences
<Only material tradeoffs or follow-on constraints.>

## Alternatives Considered
<Only alternatives whose rejection will matter to future maintainers.>
```

Keep an ADR short. Record the decision and its load-bearing reason, not implementation narration. Add status metadata only when the repository uses it or the decision is proposed, superseded, or deprecated. Write for human maintainers; exclude prompts, agent instructions, tickets, and workflow mechanics.
