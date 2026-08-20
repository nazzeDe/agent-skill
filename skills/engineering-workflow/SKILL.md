---
name: engineering-workflow
description: Mandatory router for production-code design, implementation, tests, bug fixes, and refactoring. Separates lightweight and heavy work, user decisions and engineering judgment, proportional implementation, testing, and review, with an optional local artifact backend.
disable-model-invocation: true
---

# Engineering Workflow

This workflow applies to production code. Documentation and agent-policy files are handled directly by the parent after user approval; they do not require tickets, workers, or TDD.

## 0. Select Artifact Backend

Read [ARTIFACT-BACKENDS.md](ARTIFACT-BACKENDS.md). Default to `.scratch`. Activate a project provider only through a valid `.agents/artifact-backend.json`; a tool-specific directory alone never activates one.

The backend controls local persistence and continuity only. This workflow remains authoritative for classification, decisions, approvals, implementation, review, and completion. Select the backend once for the effort and pass its declared context paths to delegated workers and reviewers.

## 1. Classify

Use the **heavy path** for public APIs, cross-module contracts, persistent or message schemas, compatibility, migrations, security boundaries, architecture changes, destructive operations, or other high-risk work.

Use the **lightweight path** only for narrow, low-risk, local changes that preserve public and cross-module contracts. Reclassify if the scope grows.

## 2. Resolve Decisions

Load `grill-me` for unclear requirements or design. Ask only user-owned questions: behavior, scope, public contracts, cost, compatibility, migration, security, and risk. Explore the repository for facts and routine engineering choices.

An approved lightweight direction or execution ticket authorizes implementation within its stated behavior and boundaries. An approved spec authorizes ticketing, not implementation. The agent chooses internal structure, test level, fixtures, and seams. Escalate only when implementation requires a new user-owned decision.

## 3. Plan

### Lightweight

State the intended behavior, implementation direction, validation, and whether a valuable test exists. Wait for explicit approval. Do not create a spec or ticket.

### Heavy

- One clear delivery slice that does not need a behavior spec: use `to-tickets` directly.
- Multiple slices or important cross-boundary behavior: use `to-spec`, then `to-tickets`.
- Unresolved decisions: use `grill-me`, and `research` or `prototype` when evidence is needed, until the work can become a spec or tickets. Use `handoff` for multi-session continuity.

Show every proposed spec and ticket to the user before writing it. Persist approved agent artifacts through the selected local backend. The default backend stores them under `.scratch/<effort>/`; an active provider supplies its own mapping and cleanup rules. Never add agent-only material to public documentation or Git. Delete temporary artifacts when their work is complete or their durable content has been approved and moved into human-facing documentation.

Access remote collaboration systems only when the user explicitly requests or permits it this turn. Default is local git only. With authorization, the parent may push and open a PR per [GIT.md](GIT.md). The user still owns merge and, unless separately authorized, issue/label/reviewer changes.

## 4. Implement

Use `tdd` when a valuable regression test exists. This applies to both paths. Do not manufacture tests for trivial wiring, formatting, declarative configuration, or behavior-free changes; use the strongest relevant validation instead.

### Lightweight

The parent implements after approval, then validates and applies `code-quality`.

### Heavy

Default: shared repo, no worktree. Parent schedules:

- one fresh-context worker per active ticket;
- `Parallel: ok` + disjoint write surfaces -> may same-repo parallel;
- possible contention (same files / generated artifacts / migrations / contract entrances / brittle fixtures) -> serial;
- worktree only when serial is clearly more expensive than isolation.

Worker prompt: Outcome, Contract, Acceptance, Validation, Boundaries + needed user decisions, validation expectations, repo access, backend context paths. Board/siblings/parallel/worktree decisions stay in parent context. Worker explores impl/callers/tests/docs; no file-path scripts.

## 5. Specialized Routes

- Ordinary reproducible bugs: use the normal path with a minimal failing signal and regression protection.
- Complex bugs meeting the `diagnose-bug` trigger: load that skill.
- Interface alternatives: load `design-an-interface`; it uses `deep-module-design` as its rubric.
- Logic or UI uncertainty that needs executable evidence: use `prototype`. Prototype code never becomes production code.
- Explicit architecture review: use `improve-codebase-architecture`.

## 6. Git

Source-code commits follow [GIT.md](GIT.md). Parent owns branch/commit/push/PR decisions. Workers never commit.

## 7. Review And Complete

Lightweight work needs parent diff inspection and `code-quality`; independent review is optional.

Heavy work needs at least one fresh-context, read-only reviewer covering correctness, regression risk, test value, and maintainability. Add specialist reviewers only for material risks such as security, performance, concurrency, complex UI, or migration. Use one writer for accepted fixes. Re-review when fixes are substantial.

Tickets have only `ready-for-agent` and `done`. `Blocked by` is separate. A ticket is executable only when it is `ready-for-agent` and all blockers are `done`. Parent schedules from `Parallel` + conflict judgment. Workers do not choose tickets or worktrees. The worker reports evidence; the parent marks `done` after inspecting the diff, validation, and review. Wait for user acceptance when the result depends on human judgment.

Completion requires approved behavior, valuable tests or the strongest alternative validation, final diff inspection, the `code-quality` completion signal, dispositioned review findings, explicit residual risks, and [GIT.md](GIT.md) staging/message/hooks when committing.
