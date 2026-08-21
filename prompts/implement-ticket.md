---
description: Dispatch one approved ticket to a fresh worker, then a fresh reviewer
argument-hint: "<ticket-path>"
---

Run this as orchestrator. Do not implement in this session. Do not reload `to-tickets`, list agents, or pre-read framework APIs. Call `subagent` once with `workflowScript` below. Replace nothing except backend-declared extra `reads` when the selected artifact backend names them.

Ticket path: `$1`

Use `async: true` and `context: "fresh"`. Missing `.agents/constraints.md` is fine; `reads` skips absent files.

```javascript
const ticket = "$1";
const reads = [ticket, ".agents/constraints.md"];
const worker = await runs.run("impl", {
  agent: "worker",
  context: "fresh",
  skill: ["tdd", "code-quality"],
  reads,
  phase: "Implementation",
  task: [
    "Goal: implement the approved ticket.",
    "Context: read " + ticket + " first. Read .agents/constraints.md if it was provided for repo pins.",
    "Success: the ticket Outcome, Contract, and Acceptance hold. Run the Validation commands.",
    "Explore implementation, callers, and tests as needed.",
    "Boundaries: sibling tickets, engineering-workflow, to-spec, and to-tickets stay unread. Do not commit. Escalate unapproved user-owned decisions.",
    "Output: Implemented / Changed files / Validation / Residual risks.",
    "Stop when: acceptance is met, or a user-owned decision is required."
  ].join("\n")
});
const review = await runs.run("review", {
  agent: "reviewer",
  context: "fresh",
  skill: "code-quality",
  reads,
  phase: "Review",
  task: [
    "Goal: review the worker change against the ticket contract.",
    "Context: ticket " + ticket + ". Worker evidence:",
    worker.output,
    "Success: Correct / Blocker / Note with file evidence, ordered by impact.",
    "Start from the ticket and the files the worker changed. Read those files, their tests and callers, and definitions of changed symbols. Follow one more dependency hop if needed to verify a finding.",
    "Boundaries: sibling tickets, workflow skills, and modules the ticket and change do not couple to stay unread. Do not edit.",
    "Stop when: findings are evidence-backed, or the change matches the contract."
  ].join("\n")
});
return { worker: worker.output, review: review.output };
```

After it returns: inspect `git diff` yourself, disposition blockers, mark the ticket `done` only when validation and review pass, and commit per `engineering-workflow/GIT.md`. One writer for accepted fixes; re-review when those fixes are substantial.
