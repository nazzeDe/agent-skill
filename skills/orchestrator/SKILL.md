---
name: orchestrator
description: Tickets, path-only dispatch, isolated workers and reviewers for production-code delivery. Load only when the user explicitly starts orchestration.
disable-model-invocation: true
---

# Orchestrator

This session does not modify production code. Documentation and agent-policy files stay here after user approval; they do not take tickets or workers.

Dispatch starts a fresh worker and a fresh reviewer. `Blocker` work resumes that pair; a follow-up starts a fresh pair. See Review And Complete. Spawn, resume, and follow-up: [pi.md](pi.md) when this session has `subagent` `workflowScript`; [claude.md](claude.md) when this session has the `Agent` tool. Another harness adds a sibling adapter.

This session talks to the user. The `verify` reviewer talks to the worker.

## 0. Select Artifact Backend

Read [ARTIFACT-BACKENDS.md](../../ARTIFACT-BACKENDS.md). Default to `.scratch`. Activate a project provider only through a valid `.agents/artifact-backend.json`; a tool-specific directory alone never activates one.

Select the backend once for the effort. Pass any provider-declared child context paths through dispatch `reads`, together with the ticket path and `.agents/constraints.md` when that file exists. `.agents/constraints.md` holds repo-wide pins (language/version, gate commands, forbidden stacks). Quality gates are the commands under a `Quality gates` heading in that file. Slice behavior stays in the ticket. Missing constraints file: ticket plus code closure only.

## 1. Resolve Decisions

Load `grill-me` for unclear requirements or design. Ask only user-owned questions: behavior, scope, public contracts, cost, compatibility, migration, security, and risk. Explore the repository for facts and routine engineering choices.

An approved ticket authorizes implementation within its stated behavior and boundaries. An approved spec authorizes ticketing, not implementation. Children choose internal structure, test level, fixtures, and seams. Escalate only when implementation requires a new user-owned decision.

## 2. Plan

- One clear delivery slice: use `to-tickets` directly.
- Multiple slices or important cross-boundary behavior: use `to-spec`, then `to-tickets`.
- Unresolved decisions: `grill-me`, and `research` or `prototype` when evidence is needed. Use `handoff` for multi-session continuity.

Show the user the behavior and scope they can judge before persisting a spec or ticket. The artifact is for the agent. Persist approved agent artifacts through the selected local backend. Never add agent-only material to public documentation or Git. Delete temporary artifacts when their work is complete or their durable content has been approved and moved into human-facing documentation.

Access remote collaboration systems only when the user explicitly requests or permits it this turn. Default is local git only. With authorization, the parent may push and open a PR per [GIT.md](../../GIT.md). The user still owns merge and, unless separately authorized, issue/label/reviewer changes.

## 3. Implement

After a ticket is approved and persisted, dispatch it. The harness adapter owns the child contract.

The child `reads` the ticket path, `.agents/constraints.md` when present, and backend-declared context paths. The ticket is the child's only planning document.

Default: shared repo, no worktree.

- one dispatch per executable ticket (`ready-for-agent`, blockers `done`);
- `Parallel: ok` + disjoint write surfaces -> may run more than one;
- possible contention (same files / generated artifacts / migrations / contract entrances / brittle fixtures) -> serial;
- worktree only when serial is clearly more expensive than isolation.

The first pair is fresh. Parent keeps Status, Blocked by, Parallel, and worktree decisions.

Worker skills: `tdd`, `code-quality`, and `deep-module-design` from the start. Reviewer skill: `verify`. Specialized Routes may add `diagnose-bug` to the worker. Use `tdd` when a valuable regression test exists. For wiring, formatting, declarative configuration, or behavior-free changes, use the strongest relevant validation instead.

## 4. Specialized Routes

- Ordinary reproducible bugs: the normal ticket path with a minimal failing signal and regression protection.
- Complex bugs meeting the `diagnose-bug` trigger: add that skill to the worker. The ticket is the problem statement; the worker runs the loop.
- Interface alternatives: load `design-an-interface`; it uses `deep-module-design` as its rubric.
- Logic or UI uncertainty that needs executable evidence: use `prototype`. Prototype code never becomes production code.
- Explicit architecture review: use `improve-codebase-architecture`.

## 5. Git

This session commits after a ticket is `done`. Dispatched children do not commit, push, or open PRs. Commits follow [GIT.md](../../GIT.md).

## 6. Review And Complete

Dispatch starts one fresh worker (`impl`) and one fresh, read-only reviewer (`review`). Keep those run ids. Specialist reviewers only for material risks such as security, performance, concurrency, complex UI, or migration. Specialist `Blocker`s use the same `impl` pair.

Tickets have only `ready-for-agent` and `done`. `Blocked by` is separate. Parent schedules from `Parallel` plus conflict judgment. `done` means this pair finished the ticket.

The worker generates a finished slice: Outcome, Contract, Acceptance, Validation, and a deep module. The reviewer **verifies** those claims and any pinned quality gates.

Reviewer findings stay `Correct` / `Blocker` / `Note`. A **Blocker** is only: a pinned quality gate exited non-zero; an Acceptance or Contract item has no test that pins it; a test cannot fail for the defect it claims; the Validation command does not exercise that behavior. Notes are residual risk. A user-owned decision (behavior, scope, public contract, cost, compatibility, migration, security, risk) is an escalate, not a private child choice.

Speak behaviors and user-owned questions. Leave verify output, worker residual risks, and diffs in the child transcripts.

Route on `Blocker` presence and _progress_. Resume the same pair only while the ticket contract is unchanged. If Outcome, Contract, or scope changed, dispatch a fresh pair.

1. No `Blocker` (clean or `Note` only): mark the ticket `done` and commit the files the worker listed per [GIT.md](../../GIT.md). Speak the user-observable behaviors this slice delivers — spec Acceptance for this slice, or the behavior and scope already confirmed when there is no spec. Then schedule from `Parallel` plus conflict judgment. Done when the ticket is `done`, those files are committed, and the user has been told those behaviors.
2. Any `Blocker`: `resume` `impl` with those Blockers and gate failure output, and the adapter resume-worker contract. Done when the worker accounts for every `Blocker` — fix, evidenced reject, or escalate.
3. After that worker return:
   - user-owned escalate → ask the user. Stop.
   - no changed files and no evidenced reject for each `Blocker` → ask the user. Stop.
   - otherwise `resume` `review` with the worker evidence and the adapter resume-reviewer contract. Done when that reviewer returns a new Correct / Blocker / Note list.
4. Still a `Blocker` and the pair made _progress_ → step 2. Progress is changed files, or an evidenced reject per `Blocker`.
5. Still a `Blocker` and no progress — the same `Blocker` stands after an evidenced reject, or step 3 already stopped → ask the user. The next writer is that same `impl` only after the user says so.

Reviewer output is findings only. Completion is those child signals plus [GIT.md](../../GIT.md) staging/message/hooks when committing.

### User report

A report after `done` is new work. Load `grill-me` for missing user-owned facts; explore the repository for the rest. After consensus on behavior and scope, write a new ticket (`to-tickets`) whose Outcome is that **problem statement**: symptom, expected vs actual, reproduction.

A **follow-up** is a report, in this conversation, that the behaviors just spoken did not hold. Every follow-up from that verification goes on one new ticket. Dispatch a **fresh** `impl` and `review` with the adapter fresh-pair contract. The new ticket is the planning document.

Any other report starts a fresh pair.
