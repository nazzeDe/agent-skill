---
name: to-tickets
description: Split approved production-code work into small, independent, vertical, verifiable local agent tickets; docs/chores stay with parent; user approves before persist via engineering-workflow artifact backend.
disable-model-invocation: true
---

# To Tickets

Short-lived agent execution contracts. Persist only via the backend selected by `engineering-workflow` (`../engineering-workflow/ARTIFACT-BACKENDS.md` if unresolved). Not remote trackers / public docs. The ticket is a document the worker will load; write it with `writing-for-agents`.

## Process

1. Start from approved conversation or spec. Missing user-owned decision -> `grill-me`.
2. Ticket only **production-code behavior** slices. Docs, agent-policy, process notes, and no-behavior chores -> parent handles after user approval; no ticket/worker. If a code slice needs a short human doc touch, keep it on the parent path or fold a one-line acceptance note into the code ticket.
3. Split to the **smallest independently verifiable vertical behavior**. Cross only needed layers. A follow-up named by engineering-workflow Review And Complete stays one ticket.
4. Name the **seam** in Contract: the crate or module that owns the behavior and the public operations to call. If tests already assert that behavior, name them — they are the _oracle_. Omit line numbers and implementation scripts. Workers close from that seam; after reading it they write a _red_ test.
5. Context budget: aim **well below 150k**. Near/over 150k -> try further split if still independently verifiable. Cannot split -> keep one ticket, `Context risk: high` + reason.
6. Real `Blocked by` only. Prefer low write-conflict parallel frontier when no behavior dependency.
7. Show the user the behavior and scope they can judge: title, outcome, acceptance, and any user-owned boundary. Revise until they confirm, then persist. The ticket is for the worker. Scratch: `.scratch/<effort>/tickets/<NN>-<slug>.md`.

Parent owns scheduling (which ticket, serial/parallel, worktree).

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
<behavior, invariants, errors, compatibility, seam>

## Acceptance Criteria
- [ ] <independently verifiable>

## Validation
<worker command with exit code>

## Boundaries
<work that remains on later tickets or the parent>
```

- `Parallel: ok` -> parent may co-run with other `ok` tickets when write surfaces look disjoint.
- `serial` -> possible contention on same files / generated artifacts / migrations / contract entrances / brittle shared fixtures.
- Omit `Context risk` when normal. If `high`, say why it cannot shrink; fold impl-relevant limits into `Boundaries`/`Contract`.
- Worker Validation is a package-scoped command, quiet when the toolchain allows. The worker stops on that command.

## Dispatch

Frontier: `ready-for-agent` + all blockers `done`. Status is only those two values.

After persist, dispatch per engineering-workflow Implement and Review And Complete. A follow-up uses the adapter follow-up resume. Pass the path through `reads`. Also `reads`: `.agents/constraints.md` when present, plus backend-declared context paths.

Children read the ticket file. Parent keeps Status, Blocked by, Parallel, siblings, and board/orchestration out of the child prompt.

Broad incompatible migrations -> expand-contract order, not broken vertical slices.
