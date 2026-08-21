---
name: engineering-workflow
description: Orchestrator for production-code delivery. Tickets, path-only dispatch, isolated workers and reviewers. Load only after the user switches this session to orchestrator.
disable-model-invocation: true
---

# Engineering Workflow

This skill is for the **orchestrator** identity only. Documentation and agent-policy files stay with the parent after user approval; they do not take tickets or workers.

The parent session does not modify production code. Implementation and independent review run in fresh child sessions via `/implement-ticket`.

## 0. Select Artifact Backend

Read [ARTIFACT-BACKENDS.md](ARTIFACT-BACKENDS.md). Default to `.scratch`. Activate a project provider only through a valid `.agents/artifact-backend.json`; a tool-specific directory alone never activates one.

Select the backend once for the effort. Pass any provider-declared child context paths through `/implement-ticket` `reads`, together with the ticket path and `.agents/constraints.md` when that file exists. `.agents/constraints.md` holds repo-wide pins (language/version, gate commands, forbidden stacks). Slice behavior stays in the ticket. Missing constraints file: ticket plus code closure only.

## 1. Resolve Decisions

Load `grill-me` for unclear requirements or design. Ask only user-owned questions: behavior, scope, public contracts, cost, compatibility, migration, security, and risk. Explore the repository for facts and routine engineering choices.

An approved ticket authorizes implementation within its stated behavior and boundaries. An approved spec authorizes ticketing, not implementation. Children choose internal structure, test level, fixtures, and seams. Escalate only when implementation requires a new user-owned decision.

## 2. Plan

- One clear delivery slice: use `to-tickets` directly.
- Multiple slices or important cross-boundary behavior: use `to-spec`, then `to-tickets`.
- Unresolved decisions: `grill-me`, and `research` or `prototype` when evidence is needed. Use `handoff` for multi-session continuity.

Show every proposed spec and ticket to the user before writing it. Persist approved agent artifacts through the selected local backend. Never add agent-only material to public documentation or Git. Delete temporary artifacts when their work is complete or their durable content has been approved and moved into human-facing documentation.

Access remote collaboration systems only when the user explicitly requests or permits it this turn. Default is local git only. With authorization, the parent may push and open a PR per [GIT.md](GIT.md). The user still owns merge and, unless separately authorized, issue/label/reviewer changes.

## 3. Implement

After a ticket is approved and persisted, run `/implement-ticket <ticket-path>`. Do not reload `to-tickets`. Do not inline the ticket body. Do not list agents or read pi-subagents reference manuals unless the template is not enough. Do not pre-read framework APIs for the worker. Do not give children sibling tickets, specs they do not need, or this workflow.

Default: shared repo, no worktree.

- one `/implement-ticket` per executable ticket (`ready-for-agent`, blockers `done`);
- `Parallel: ok` + disjoint write surfaces -> may run more than one;
- possible contention (same files / generated artifacts / migrations / contract entrances / brittle fixtures) -> serial;
- worktree only when serial is clearly more expensive than isolation.

Children are fresh via `agentOverrides`. The template passes `reads` for the ticket, `.agents/constraints.md` if present, and backend context paths. Board, siblings, parallel, and worktree decisions stay in the parent.

Use `tdd` in the worker when a valuable regression test exists. Do not manufacture tests for trivial wiring, formatting, declarative configuration, or behavior-free changes; use the strongest relevant validation instead.

## 4. Specialized Routes

- Ordinary reproducible bugs: the normal ticket path with a minimal failing signal and regression protection.
- Complex bugs meeting the `diagnose-bug` trigger: load that skill.
- Interface alternatives: load `design-an-interface`; it uses `deep-module-design` as its rubric.
- Logic or UI uncertainty that needs executable evidence: use `prototype`. Prototype code never becomes production code.
- Explicit architecture review: use `improve-codebase-architecture`.

## 5. Git

Source-code commits follow [GIT.md](GIT.md). Parent owns branch/commit/push/PR decisions. Child workers never commit.

## 6. Review And Complete

`/implement-ticket` already runs a fresh, read-only reviewer. That reviewer starts from the ticket and the worker's changed files, then reads tests, callers, and definitions of changed symbols. They may follow one more dependency hop to verify a finding. They do not read sibling tickets, this workflow, or modules the ticket and change do not couple to. They do not explain extra reads.

Add specialist reviewers only for material risks such as security, performance, concurrency, complex UI, or migration. Use one writer for accepted fixes. Re-review when fixes are substantial.

Tickets have only `ready-for-agent` and `done`. `Blocked by` is separate. Parent schedules from `Parallel` plus conflict judgment. The worker reports evidence; the parent marks `done` after inspecting the diff, validation, and review. Wait for user acceptance when the result depends on human judgment.

Completion requires approved behavior, valuable tests or the strongest alternative validation, final diff inspection, the `code-quality` completion signal, dispositioned review findings, explicit residual risks, and [GIT.md](GIT.md) staging/message/hooks when committing.
