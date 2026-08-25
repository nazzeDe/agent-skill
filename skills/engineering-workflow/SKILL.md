---
name: engineering-workflow
description: Orchestrator for production-code delivery. Tickets, path-only dispatch, isolated workers and reviewers. Load only after the user switches this session to orchestrator.
disable-model-invocation: true
---

# Engineering Workflow

This skill is for the **orchestrator** identity only. Documentation and agent-policy files stay with the parent after user approval; they do not take tickets or workers.

The parent session does not modify production code. `/implement-ticket` starts a fresh worker and a fresh reviewer. Later `Blocker` work resumes that pair; see Review And Complete.

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

After a ticket is approved and persisted, run `/implement-ticket <ticket-path>`. That template owns the child contract.

The child `reads` the ticket path, `.agents/constraints.md` when present, and backend-declared context paths. The ticket is the child's only planning document.

Default: shared repo, no worktree.

- one `/implement-ticket` per executable ticket (`ready-for-agent`, blockers `done`);
- `Parallel: ok` + disjoint write surfaces -> may run more than one;
- possible contention (same files / generated artifacts / migrations / contract entrances / brittle fixtures) -> serial;
- worktree only when serial is clearly more expensive than isolation.

The first pair is fresh via `agentOverrides`. Parent keeps Status, Blocked by, Parallel, and worktree decisions.

Worker skills: `tdd`, `code-quality`, and `deep-module-design` from the start. Use `tdd` when a valuable regression test exists. For wiring, formatting, declarative configuration, or behavior-free changes, use the strongest relevant validation instead.

## 4. Specialized Routes

- Ordinary reproducible bugs: the normal ticket path with a minimal failing signal and regression protection.
- Complex bugs meeting the `diagnose-bug` trigger: load that skill.
- Interface alternatives: load `design-an-interface`; it uses `deep-module-design` as its rubric.
- Logic or UI uncertainty that needs executable evidence: use `prototype`. Prototype code never becomes production code.
- Explicit architecture review: use `improve-codebase-architecture`.

## 5. Git

Source-code commits follow [GIT.md](GIT.md). Parent owns branch/commit/push/PR decisions. Child workers never commit.

## 6. Review And Complete

`/implement-ticket` starts one fresh worker (`impl`) and one fresh, read-only reviewer (`review`). Keep those run ids. Specialist reviewers only for material risks such as security, performance, concurrency, complex UI, or migration. Specialist `Blocker`s use the same `impl` pair.

Tickets have only `ready-for-agent` and `done`. `Blocked by` is separate. Parent schedules from `Parallel` plus conflict judgment.

Route on `Blocker` presence and _progress_. Findings stay `Correct` / `Blocker` / `Note`. A user-owned decision (behavior, scope, public contract, cost, compatibility, migration, security, risk) is an escalate, not a private child choice.

1. No `Blocker` (clean or `Note` only): mark the ticket `done` and commit the files the worker listed per [GIT.md](GIT.md). Run a parent-owned user-flow only when the ticket names one. Wait for user acceptance when that flow is the acceptance criterion. Done when the reviewer reported no `Blocker`.
2. Any `Blocker`: `resume` `impl` with the full review text and the `/implement-ticket` resume-worker contract. Done when the worker accounts for every `Blocker` — fix, evidenced reject, or escalate.
3. After that worker return:
   - user-owned escalate → ask the user. Stop.
   - no changed files and no evidenced reject for each `Blocker` → ask the user. Stop.
   - otherwise `resume` `review` with the worker evidence and the `/implement-ticket` resume-reviewer contract. Done when that reviewer returns a new Correct / Blocker / Note list.
4. Still a `Blocker` and the pair made _progress_ → step 2. Progress is changed files, or an evidenced reject per `Blocker`.
5. Still a `Blocker` and no progress — the same `Blocker` stands after an evidenced reject, or step 3 already stopped → ask the user. The next writer is that same `impl` only after the user says so.

Reviewer output is findings only. Completion is those child signals plus [GIT.md](GIT.md) staging/message/hooks when committing.
