---
description: Dispatch one approved ticket to a fresh worker, then a fresh reviewer
argument-hint: "<ticket-path>"
---

Run this as orchestrator. Production code stays in the child sessions. The ticket file is the child's planning document.

Read `writing-for-agents` before sending the child task. Goal names the ticket Outcome; Context names the seam; Success includes the worker command and a deep module. You may substitute those Goal/Context lines from the ticket; keep the rest of this contract. Call `subagent` once with `workflowScript` below. Add backend-declared extra `reads` when the selected artifact backend names them.

Ticket path: `$1`

Use `async: true` and `context: "fresh"`. Missing `.agents/constraints.md` is fine; `reads` skips absent files.

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

After it returns: take worker Validation and reviewer disposition as the acceptance evidence. When the reviewer reports no blockers, mark the ticket `done` and commit the files the worker listed per `engineering-workflow/GIT.md`. Run a parent-owned user-flow only when the ticket names one. Blockers go to one writer and then a fresh re-review.
