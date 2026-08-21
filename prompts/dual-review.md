---
description: Parallel independent code review
argument-hint: "[focus]"
---

Run two independent reviews of the same target using the available review-capable agents.

Use `context: "fresh"`. Both reviewers start from the same target, the actual diff, and the files that changed. They read tests, callers, and definitions of changed symbols, and may follow one more dependency hop to verify a finding. They must not edit files. Sibling tickets, workflow skills, repository instruction routers, and uncoupled modules stay unread.

Give them complementary focus areas:

1. End-to-end correctness, contract integration, and behavioral regressions.
2. Edge cases, test gaps, security risks, and unnecessary complexity.

After both return:
- merge duplicate findings
- keep only evidence-backed issues
- identify disagreements and resolve them against the code
- order findings by severity
- separate fixes worth doing now from residual risks
- do not apply fixes unless the user explicitly requested autofix

Review target or focus:

$@
