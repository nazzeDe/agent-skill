---
name: to-spec
description: Synthesize approved substantial or cross-boundary work into a concise behavior contract, show it to the user, then persist it through the selected local artifact backend.
disable-model-invocation: true
---

# To Spec

Use this for work with multiple delivery slices, important product behavior, or cross-boundary contracts. Use `to-tickets` directly only when one clear slice does not need a behavior spec. The spec is a document later tickets and workers will load; write it with `writing-for-agents`. Use the artifact backend already selected by `engineering-workflow`; read `../engineering-workflow/ARTIFACT-BACKENDS.md` if it has not been resolved.

## Process

1. Read the relevant code, tests, human-facing domain documentation, and ADRs.
2. Synthesize only decisions already made. Do not interview. If a required user-owned decision is missing, stop and return to `grill-me`.
3. Draft the spec in the conversation. Use the user's language and repository terminology.
4. After user approval, persist the unified spec through the selected backend. The scratch backend writes `.scratch/<effort>/spec.md`; a provider may map approved sections across its declared files without changing the conversation review surface.
5. After spec approval, use `to-tickets` to create one or more execution tickets through the same backend.

Do not publish remotely or commit agent-only artifacts. Do not place agent-only material in `docs/`. Delete the spec according to the selected backend after the effort completes or its durable human value has been approved and moved into public documentation.

## Format

```markdown
# <Title>

## Problem
<Current user or system problem.>

## Target Behavior
<Observable result.>

## Scope
<Approved capabilities and affected contracts.>

## Domain Rules And Invariants
<Stable rules needed for correct implementation.>

## Contract Decisions
<Public or cross-module behavior, errors, compatibility, and migration.>

## Acceptance Criteria
- [ ] <Observable criterion>

## Validation
<Tests, commands, or user flows that provide evidence.>

## Out Of Scope
<Explicit boundaries.>

## Open Decisions
None, or unresolved items that block ticketing.
```

Use user stories only when distinct roles or workflows make them clearer. Do not add exhaustive sections that do not change implementation behavior.
