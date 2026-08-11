---
name: to-tickets
description: Turn an approved spec or clear request into small local agent tickets with observable outcomes, explicit blockers, and user approval before persisting them through the selected artifact backend.
disable-model-invocation: true
---

# To Tickets

Tickets are short-lived execution contracts for agents. They live in the local artifact backend selected by `engineering-workflow`, not remote trackers or public documentation. Read `../engineering-workflow/ARTIFACT-BACKENDS.md` if the backend has not been resolved.

## Process

1. Start from the approved conversation or spec. Return to `grill-me` if a user-owned decision is missing.
2. Split work into the smallest independently verifiable vertical slices. A slice crosses only the layers needed for its behavior; do not force schema, API, UI, and tests into every ticket.
3. State real `Blocked by` edges. Prefer parallel frontier tickets when no dependency exists.
4. Present the numbered split to the user with title, blockers, outcome, and acceptance criteria.
5. Revise until the user approves. Only then persist the tickets through the selected backend. The scratch backend writes `.scratch/<effort>/tickets/<NN>-<slug>.md`; a provider may use another local representation while preserving the ticket contract below.

Do not include file paths, line numbers, or implementation scripts. The worker must explore the repository, callers, tests, domain documentation, and ADRs. Include stable domain concepts and contracts when they constrain behavior.

## Ticket Format

```markdown
# <NN> - <Title>

Status: ready-for-agent
Blocked by: None | <ticket numbers>

## Outcome
<What becomes observable when this ticket is complete.>

## Contract
<Behavior, invariants, errors, and compatibility constraints.>

## Acceptance Criteria
- [ ] <Independently verifiable criterion>

## Validation
<Required evidence, commands, or user flow.>

## Boundaries
<What this ticket does not change.>
```

The executable frontier contains tickets with `Status: ready-for-agent` whose blockers are all `done`. There is no claim or in-progress state. The worker returns evidence; the parent marks `done` after validation and review. Keep completed tickets until all dependents finish, then clean up through the selected backend when the remaining material has no value.

For broad incompatible migrations, use expand-contract ordering rather than forcing temporarily broken vertical slices.
