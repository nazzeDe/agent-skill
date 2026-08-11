# Trellis Local Artifact Backend

<!-- trellis-local-passive:v1 -->

This file is a persistence-provider contract for the global `engineering-workflow`. It is not a second development workflow.

## Authority

- `engineering-workflow` is the only production-code router and completion authority.
- Global skills own clarification, specification, ticketing, TDD, diagnosis, implementation, review, and quality gates.
- Trellis supplies local task storage, workspace memory, runtime task identity, project-specific specs, and Pi context injection.
- Native Trellis brainstorm, implement, check, update-spec, channel, continue, start, and finish flows are inactive.
- `pi-subagents` is the only sub-agent orchestrator. Do not call `trellis_subagent`.

## Local-Only Boundary

Everything under `.trellis/`, `.pi/`, `.agents/`, and `.scratch/`, plus root AI instruction files, is local agent infrastructure. Never stage or commit it. Source code, tests, and explicitly approved human documentation follow normal project Git policy.

`.trellis/config.yaml` must set `session_auto_commit: false`. Archive and journal commands must use their no-commit behavior. Do not run Trellis Phase 3 commit or native finish-work instructions.

## Effort Root

The active Trellis task directory is the provider effort root.

- Resolve it with `python3 ./.trellis/scripts/task.py current --source`.
- Create a task only after `engineering-workflow` authorizes persistent planning material.
- Task creation records planning state; it does not authorize implementation.
- Run `task.py start` only after the normal implementation approval gate.
- Archive only after the normal completion gate, with auto-commit disabled.

## Artifact Mapping

### Behavior Spec

The unified `to-spec` draft remains the user review surface. After approval:

- write problem, target behavior, scope, domain rules, acceptance criteria, validation, out of scope, and open decisions to `prd.md`;
- write approved technical contract decisions, compatibility, migration, boundaries, and tradeoffs to `design.md` only when those sections are material;
- do not duplicate the same rule across both files.

### Execution Tickets

Write approved `to-tickets` output to `implement.md` in the active task directory. Preserve each ticket's title, `Status`, `Blocked by`, outcome, contract, acceptance criteria, validation, and boundaries. The ticket state remains `ready-for-agent` or `done`; Trellis task status is only the overall effort projection.

### Research

Store reusable or cross-session task research under:

```text
<task>/research/<topic>.md
```

### Handoff

Store the current-session handoff at:

```text
<task>/handoff.md
```

The next session reads task artifacts first and the handoff second. Workspace journals provide background, not authority.

### Project Specs

`.trellis/spec/` contains only user-approved, project-specific executable conventions. Do not copy generic engineering principles from global skills into it. Human-facing domain documentation and ADRs remain in the repository's normal documentation locations after explicit approval.

## State Projection

- `planning`: persistent planning exists, but implementation is not approved.
- `in_progress`: the latest approved execution contract authorizes implementation.
- `completed` or archived: `engineering-workflow` completion gates passed.

Trellis status never substitutes for ticket blockers, worker evidence, review disposition, or user acceptance.

## Worker And Reviewer Context

When dispatching through `pi-subagents`, pass the active task's `prd.md`, optional `design.md`, `implement.md`, relevant research, and project-specific specs as explicit context paths. Workers still inspect implementation, callers, tests, and human documentation. Reviewers remain fresh-context and read-only; the single writer applies accepted fixes.

## Phase Index

```text
Engineering workflow: global engineering-workflow
Artifact backend: Trellis local
Sub-agent orchestrator: pi-subagents
Trellis role: persistence and context injection only
```

[workflow-state:no_task]
Trellis local storage is available, but no task is active. Follow `engineering-workflow`. Create a Trellis task only when that workflow authorizes persistent planning material.
[/workflow-state:no_task]

[workflow-state:planning]
The active Trellis task is local planning storage. Follow `engineering-workflow`; resolve decisions and obtain the required approval before implementation. Do not invoke native Trellis workflow skills or agents.
[/workflow-state:planning]

[workflow-state:in_progress]
The active Trellis task stores the approved execution contract. Follow `engineering-workflow`, use `pi-subagents` when delegation is required, and keep reviewers read-only. Do not invoke native Trellis workflow skills or agents.
[/workflow-state:in_progress]

[workflow-state:completed]
The engineering completion gate has passed. Keep all Trellis bookkeeping local and use no-commit archive or journal operations only when continuity value remains.
[/workflow-state:completed]

## Phase 1: Plan

Detailed planning, implementation, and completion behavior comes from the global skills. This heading exists only for Trellis context extraction compatibility.
