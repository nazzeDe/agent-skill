---
description: Parallel independent code review
argument-hint: "[focus]"
---

Run two independent reviews of the same target using the available review-capable agents.

Both reviewers must inspect the repository instructions, relevant files, tests, and actual diff directly. They must not edit files. Give them the same review target, but assign complementary focus areas:

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
