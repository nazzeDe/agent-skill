---
name: to-tickets
description: Split approved production-code work into small, independent, vertical, verifiable local agent tickets; docs/chores stay with parent; user approves before persist via engineering-workflow artifact backend.
disable-model-invocation: true
---

# To Tickets

Short-lived agent execution contracts. Persist only via the backend selected by `engineering-workflow` (`../engineering-workflow/ARTIFACT-BACKENDS.md` if unresolved). Not remote trackers / public docs.

## Process

1. Start from approved conversation or spec. Missing user-owned decision -> `grill-me`.
2. Ticket only **production-code behavior** slices. Docs, agent-policy, process notes, and no-behavior chores -> parent handles after user approval; no ticket/worker. If a code slice needs a short human doc touch, keep it on the parent path or fold a one-line acceptance note into the code ticket; never a standalone doc ticket.
3. Split to the **smallest independently verifiable vertical behavior**. Cross only needed layers. Do not force schema/API/UI/tests into every ticket.
4. Context budget: aim **well below 150k**. Near/over 150k -> try further split if still independently verifiable. Cannot split -> keep one ticket, `Context risk: high` + reason.
5. Real `Blocked by` only. Prefer low write-conflict parallel frontier when no behavior dependency.
6. Show user: title, blockers, `Parallel`, high context risk, outcome, acceptance. Revise until approved, then persist. Scratch: `.scratch/<effort>/tickets/<NN>-<slug>.md`.

No file paths, line numbers, or impl scripts. Workers explore repo/callers/tests/domain docs/ADRs. Parent owns scheduling (which ticket, serial/parallel, worktree).

## Format

```markdown
# <NN> - <Title>

Status: ready-for-agent
Blocked by: None | <ticket numbers>
Parallel: ok | serial
Context risk: normal | high

## Outcome
<observable result>

## Contract
<behavior, invariants, errors, compatibility>

## Acceptance Criteria
- [ ] <independently verifiable>

## Validation
<evidence / commands / user flow>

## Boundaries
<out of scope>
```

- `Parallel: ok` -> parent may co-run with other `ok` tickets when write surfaces look disjoint.
- `serial` -> possible contention on same files / generated artifacts / migrations / contract entrances / brittle shared fixtures.
- Omit `Context risk` when normal. If `high`, say why it cannot shrink; fold impl-relevant limits into `Boundaries`/`Contract`.

## Dispatch

Frontier: `ready-for-agent` + all blockers `done`. No claim/in-progress.

Worker gets only: Outcome, Contract, Acceptance, Validation, Boundaries + needed user decisions / backend context paths.

Parent keeps: Status, Blocked by, Parallel, siblings, board/orchestration.

Worker returns evidence -> parent validates/reviews -> marks `done`. Keep done tickets until dependents finish; then backend cleanup.

Broad incompatible migrations -> expand-contract order, not broken vertical slices.
