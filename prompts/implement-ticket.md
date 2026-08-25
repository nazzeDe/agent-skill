---
description: Dispatch one approved ticket to a fresh pair, or resume the just-closed pair for a follow-up
argument-hint: "<ticket-path>"
---

Run this as orchestrator. Production code stays in the child sessions. The ticket file is the child's planning document.

Read `writing-for-agents` before sending the child task. Goal names the ticket Outcome; Context names the seam; Success includes the worker command and a deep module. You may substitute those Goal/Context lines from the ticket; keep the rest of this contract. Add backend-declared extra `reads` when the selected artifact backend names them. When the ticket meets the `diagnose-bug` trigger, append `diagnose-bug` to the worker `skill` array.

Ticket path: `$1`

**Fresh pair.** Call `subagent` once with `workflowScript` below. Use `async: true` and `context: "fresh"`. Missing `.agents/constraints.md` is fine; `reads` skips absent files.

```javascript
const ticket = "$1";
const reads = [ticket, ".agents/constraints.md"];
const worker = await runs.run("impl", {
  agent: "worker",
  context: "fresh",
  skill: ["tdd", "code-quality", "deep-module-design"],
  reads,
  phase: "Implementation",
  task: [
    "Goal: implement the approved ticket Outcome as a deep module in the seam the ticket names.",
    "Context: the ticket file is the planning document. Start in the named seam. Read .agents/constraints.md when it was provided for repo pins.",
    "Success: Outcome, Contract, and Acceptance hold. The worker Validation command exits 0. Callers see a small contract; complexity stays inside; tests use that contract.",
    "Work: read the ticket and the named seam. The next action is a _red_ test. A compile or test error names the next file. Shape the module with tdd, code-quality, and deep-module-design as you go.",
    "At a boundary: escalate unapproved user-owned decisions; keep the diff on the ticket seam.",
    "Validation: run the ticket worker command, package-scoped and quiet when the toolchain allows.",
    "Output: Implemented / Changed files / Validation / Residual risks / Module depth.",
    "Stop when: the Validation command exits 0, Acceptance holds, and the changed module is deep, or a user-owned decision is required."
  ].join("\n")
});
const review = await runs.run("review", {
  agent: "reviewer",
  context: "fresh",
  skill: ["code-quality", "deep-module-design"],
  reads,
  phase: "Review",
  task: [
    "Goal: review the worker change against the ticket contract and module depth.",
    "Context: ticket " + ticket + ". Worker evidence:",
    worker.output,
    "In-scope: the ticket and the files the worker changed.",
    "Success: Correct / Blocker / Note with file evidence, ordered by impact. Depth: small contract, hidden complexity, tests through that contract.",
    "Work: read those files, their tests, callers, and definitions of changed symbols. One hop follows a symbol the diff uses (or that uses the diff) to verify a finding.",
    "At a boundary: return a finding. Project files stay unchanged.",
    "Stop when: findings are evidence-backed, or the change matches the contract and is deep."
  ].join("\n")
});
return { worker: worker.output, review: review.output };
```

Keep the workflow's `impl` and `review` run ids. After it returns, follow `engineering-workflow` Review And Complete. `Blocker` work uses the contracts below.

Resume worker when Review And Complete says any `Blocker`. Interpolate the review text. `async: true`.

```javascript
return runs.run("impl", {
  resume: IMPL_RUN_ID,
  task: [
    "Goal: account for every Blocker in the review. Fix a real defect, reject a misread with file evidence, or escalate a user-owned decision.",
    "Context: the ticket is still the planning document. You already implemented this seam. Full review:",
    REVIEW_TEXT,
    "Success: each Blocker is fixed, rejected with file evidence, or escalated. If you changed code, the worker Validation command exits 0. Callers still see the same small contract.",
    "Work: read each Blocker. The next action for a real defect is a _red_ test. Shape the fix with tdd, code-quality, and deep-module-design as you go.",
    "At a boundary: escalate unapproved user-owned decisions; keep the diff on the ticket seam.",
    "Validation: run the ticket worker command, package-scoped and quiet when the toolchain allows.",
    "Output: Fixed / Rejected / Escalated / Changed files / Validation.",
    "Stop when: every Blocker is accounted for, or a user-owned decision is required."
  ].join("\n")
});
```

Resume the same reviewer when Review And Complete says the worker made _progress_. Interpolate the worker evidence. `async: true`.

```javascript
return runs.run("review", {
  resume: REVIEW_RUN_ID,
  task: [
    "Goal: re-review the worker response against the ticket contract and the prior Blockers.",
    "Context: ticket $1. Worker evidence:",
    WORKER_TEXT,
    "In-scope: the ticket, the prior Blockers, and the files the worker changed.",
    "Success: Correct / Blocker / Note with file evidence, ordered by impact. Withdraw a Blocker the worker refuted. Keep a Blocker only with remaining file evidence. Depth: small contract, hidden complexity, tests through that contract.",
    "Work: read those files, their tests, callers, and definitions of changed symbols. One hop follows a symbol the diff uses (or that uses the diff) to verify a finding.",
    "At a boundary: return a finding. Project files stay unchanged.",
    "Stop when: findings are evidence-backed, or the remaining change matches the contract and is deep."
  ].join("\n")
});
```

**Follow-up.** Review And Complete names a follow-up: call `subagent` once with the fresh-pair `workflowScript`, these substitutions applied. Resume the just-closed ids. Interpolate the new ticket path. `async: true`. After it returns, follow Review And Complete.

- `impl`: `resume: IMPL_RUN_ID`. Omit `agent`, `context`, and `phase`.
- `review`: `resume: REVIEW_RUN_ID`. Omit `agent`, `context`, and `phase`.
- Worker Context: `this ticket file is the planning document. You already implemented this seam. Start from that context and this problem statement.`
- Keep `reads`, `skill`, and the rest of each task.
