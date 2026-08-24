---
name: tdd
description: Behavior-focused test-driven development for approved production-code changes when a test can protect a regression.
---

# Test-Driven Development

Use TDD when a test can protect observable behavior or a stable contract from a plausible regression. For wiring, formatting, declarative configuration, or behavior-free changes, use the strongest relevant validation instead.

## Test Value

A valuable test:

- exercises behavior through the highest practical stable **seam**;
- fails for a plausible defect;
- remains valid across internal refactoring;
- is deterministic and adds coverage not already protected more effectively;
- communicates a behavior, invariant, or failure rule.

The test surface is that public seam. Production code hides complexity behind the same contract; apply `deep-module-design` when shaping or reviewing the module.

## Before The Loop

The ticket (or approved direction) defines behavior and boundaries. Choose test level, fixtures, and internal structure. Escalate only if testing needs a new public contract or other user-owned decision.

Start in the crate or module the ticket names. Read that seam and existing tests that already call the same public API. Reuse their fixtures. Internals are a deep module behind that seam.

If those tests already assert the behavior to keep, they are the _oracle_: Green is those assertions still true.

This step is done when the next action is a _red_ test. A compiler or test error then names the next unread file.

Prefer real collaborators when they are _tight_ (fast, deterministic, cheap to construct). Use a test double when the real dependency is external, slow, nondeterministic, destructive, expensive, or needed to reproduce a rare failure. Dependency injection and adapters are techniques, not defaults.

## Red, Green, Refactor

Work vertically, one behavior at a time. The loop starts when a test is _red_.

1. **Red:** add the smallest valuable test and observe the intended failure.
2. **Green:** make that behavior true. Shape internals as a deep module behind the seam.
3. Repeat for the next approved behavior.
4. **Refactor:** only while green; apply `code-quality` and `deep-module-design` to the seam, then rerun focused tests.

A test should focus on one behavior. It may contain multiple related assertions needed to prove that behavior.

## Completion

Run the ticket Validation command, package-scoped and quiet when the toolchain allows it. Confirm tests protect public behavior through the module contract, the requested behavior is exercised, and an internal rewrite would leave those tests valid. If no valuable test exists, state why and use the strongest relevant validation instead.
