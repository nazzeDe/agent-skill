---
name: tdd
description: Behavior-focused test-driven development for approved production-code changes when a test provides meaningful regression protection.
---

# Test-Driven Development

Use TDD when a test can protect observable behavior or a stable contract from a plausible regression. Do not add tests only to satisfy process.

## Test Value

A valuable test:

- exercises behavior through the highest practical stable interface;
- fails for a plausible defect;
- remains valid across internal refactoring;
- is deterministic and adds coverage not already protected more effectively;
- communicates a behavior, invariant, or failure rule.

Avoid tests of private helpers, getters, constants, type-system guarantees, framework behavior, exact internal call order, or production calculations copied into expected values.

## Before The Loop

Read the relevant implementation, callers, tests, human-facing domain documentation, and ADRs. The approved lightweight direction or execution ticket defines behavior and boundaries. The implementing agent chooses test level, fixtures, and internal seams; escalate only if testing requires a new public contract or other user-owned decision.

Prefer real collaborators when they are fast, deterministic, and easy to construct. Use a fake, stub, clock, filesystem substitute, or other test double when the real dependency is external, slow, nondeterministic, destructive, expensive, or needed to reproduce a rare failure. Dependency injection and adapters are techniques, not defaults.

## Red, Green, Refactor

Work vertically, one behavior at a time:

1. **Red:** add the smallest valuable test and observe the intended failure.
2. **Green:** make the minimum production change that satisfies that behavior.
3. Repeat for the next approved behavior.
4. **Refactor:** only while green; apply `code-quality` and rerun focused tests after each change.

A test should focus on one behavior. It may contain multiple related assertions needed to prove that behavior.

## Completion

Confirm that tests protect public behavior, the original failure or requested behavior is exercised, focused validation passes, and no brittle or redundant test was added. If no valuable test exists, state why and use the strongest relevant validation instead.
