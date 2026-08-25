# Task shape

The document-type branch of [`writing-for-agents`](SKILL.md) for a child task, review prompt, or other one-shot agent prompt. Ticket dispatch already fills this in the engineering-workflow harness adapter; use this file for ad-hoc tasks.

```text
Goal: <concrete outcome>
Context: <approved issue, evidence, relevant files or behavior>
Success: <observable acceptance criteria in priority order>
Boundaries: <only load-bearing scope/safety limits>
At a boundary: <stop, escalate, or return a finding>
Validation: <commands or user flows and required evidence>
Output: <handoff or finding format>
Stop when: <completion or decision condition>
```

Put the intended change first. Success is checkable. A boundary names the action to take instead.
