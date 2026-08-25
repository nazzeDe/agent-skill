# Claude Code Dispatch

Harness adapter for [SKILL.md](SKILL.md). Read this when dispatching a ticket in a session that has the `Agent` tool ([sub-agents](https://code.claude.com/docs/en/sub-agents)). Substitute the approved ticket path for `TICKET_PATH`. Missing `.agents/constraints.md` is fine; skip it. When the ticket meets the `diagnose-bug` trigger, tell the worker to load `diagnose-bug` (Skill tool) in addition to the worker skills below.

Read `writing-for-agents` before sending the child task. Goal names the ticket Outcome; Context names the seam; Success includes the worker command and a deep module. You may substitute those Goal/Context lines from the ticket; keep the rest of this contract. Tell the child to read the ticket path, `.agents/constraints.md` when present, and backend-declared extra paths.

Do not `fork` the parent. Each child is a new `Agent` so the reviewer does not inherit the worker's reasoning.

**Fresh pair.** `run_in_background: false` on both calls: the reviewer needs the worker result. Omit `isolation` unless Review And Complete chose a worktree. Keep the `name` values `impl` and `review` for later `SendMessage`.

1. `Agent`: `name: impl`, `subagent_type: general-purpose`, `description: Implement ticket`. Worker loads skills `tdd`, `code-quality`, and `deep-module-design` via the Skill tool. Prompt:

```
Goal: implement the approved ticket Outcome as a deep module in the seam the ticket names.
Context: the ticket file is the planning document. Start in the named seam. Read TICKET_PATH. Read .agents/constraints.md when it exists for repo pins.
Success: Outcome, Contract, and Acceptance hold. The worker Validation command exits 0. Callers see a small contract; complexity stays inside; tests use that contract.
Work: read the ticket and the named seam. The next action is a _red_ test. A compile or test error names the next file. Shape the module with tdd, code-quality, and deep-module-design as you go.
At a boundary: escalate unapproved user-owned decisions; keep the diff on the ticket seam.
Validation: run the ticket worker command, package-scoped and quiet when the toolchain allows.
Output: Implemented / Changed files / Validation / Residual risks / Module depth.
Stop when: the Validation command exits 0, Acceptance holds, and the changed module is deep, or a user-owned decision is required.
```

2. `Agent`: `name: review`, `subagent_type: general-purpose`, `description: Review ticket`. Reviewer loads skills `code-quality` and `deep-module-design`. Prompt includes the worker output. If a project or user agent named `review` exists with Write/Edit denied, use that `subagent_type` instead of `general-purpose`. Prompt:

```
Goal: review the worker change against the ticket contract and module depth.
Context: ticket TICKET_PATH. Worker evidence: <worker output>
In-scope: the ticket and the files the worker changed.
Success: Correct / Blocker / Note with file evidence, ordered by impact. Depth: small contract, hidden complexity, tests through that contract.
Work: read those files, their tests, callers, and definitions of changed symbols. One hop follows a symbol the diff uses (or that uses the diff) to verify a finding.
At a boundary: return a finding. Project files stay unchanged. Do not call Write, Edit, or NotebookEdit.
Stop when: findings are evidence-backed, or the change matches the contract and is deep.
```

Keep those `name`s. After both return, follow Review And Complete.

**Blocker.** Review And Complete says resume `impl`: `SendMessage({to: "impl"})` with the resume-worker prompt. The stopped agent continues ([resume subagents](https://code.claude.com/docs/en/sub-agents#resume-subagents)). `run_in_background: false` is not a `SendMessage` field; wait for the reply.

```
Goal: account for every Blocker in the review. Fix a real defect, reject a misread with file evidence, or escalate a user-owned decision.
Context: the ticket is still the planning document. You already implemented this seam. Full review: <REVIEW_TEXT>
Success: each Blocker is fixed, rejected with file evidence, or escalated. If you changed code, the worker Validation command exits 0. Callers still see the same small contract.
Work: read each Blocker. The next action for a real defect is a _red_ test. Shape the fix with tdd, code-quality, and deep-module-design as you go.
At a boundary: escalate unapproved user-owned decisions; keep the diff on the ticket seam.
Validation: run the ticket worker command, package-scoped and quiet when the toolchain allows.
Output: Fixed / Rejected / Escalated / Changed files / Validation.
Stop when: every Blocker is accounted for, or a user-owned decision is required.
```

When the worker made progress, `SendMessage({to: "review"})`:

```
Goal: re-review the worker response against the ticket contract and the prior Blockers.
Context: ticket TICKET_PATH. Worker evidence: <WORKER_TEXT>
In-scope: the ticket, the prior Blockers, and the files the worker changed.
Success: Correct / Blocker / Note with file evidence, ordered by impact. Withdraw a Blocker the worker refuted. Keep a Blocker only with remaining file evidence. Depth: small contract, hidden complexity, tests through that contract.
Work: read those files, their tests, callers, and definitions of changed symbols. One hop follows a symbol the diff uses (or that uses the diff) to verify a finding.
At a boundary: return a finding. Project files stay unchanged. Do not call Write, Edit, or NotebookEdit.
Stop when: findings are evidence-backed, or the remaining change matches the contract and is deep.
```

**Follow-up.** Review And Complete names a follow-up: `SendMessage({to: "impl"})` then, after it returns, `SendMessage({to: "review"})`. New ticket path replaces `TICKET_PATH`. Worker Context becomes: `this ticket file is the planning document. You already implemented this seam. Start from that context and this problem statement.` Keep the rest of the fresh-pair prompts.
