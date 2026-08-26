---
name: tdd
description: Tests that protect behavior through a stable seam when a test can protect a regression.
---

# Tests That Protect Behavior

Use this when a test can protect observable behavior or a stable contract from a plausible regression. For wiring, formatting, declarative configuration, or behavior-free changes, use the strongest relevant validation instead.

## Test value

A valuable test:

- exercises behavior through the highest practical stable **seam**;
- fails for a plausible defect;
- remains valid across internal refactoring;
- is deterministic and adds coverage not already protected more effectively;
- communicates a behavior, invariant, or failure rule.

The test surface is that public seam. Production code hides complexity behind the same contract; apply `deep-module-design` when shaping the module.

## Seam

The ticket (or approved direction) defines behavior and boundaries. Choose test level, fixtures, and internal structure. Escalate only if testing needs a new public contract or other user-owned decision.

Start in the crate or module the ticket names. Read that seam and existing tests that already call the same public API. Reuse their fixtures. Internals are a deep module behind that seam.

If those tests already assert the behavior to keep, they are the _oracle_: those assertions still hold.

Prefer real collaborators when they are _tight_ (fast, deterministic, cheap to construct). Use a test double when the real dependency is external, slow, nondeterministic, destructive, expensive, or needed to reproduce a rare failure. Dependency injection and adapters are techniques, not defaults.

This step is done when the seam, oracle tests, and collaborators for the next behavior are identified.

## Tests

Work vertically, one approved behavior at a time. How tests are written is the agent's choice. Each behavior needs valuable tests through the seam before the slice is done.

While those tests pass, apply `code-quality` and `deep-module-design` to the seam, then rerun focused tests.

## Completion

Run the ticket Validation command, package-scoped and quiet when the toolchain allows it. Confirm tests protect public behavior through the module contract, the requested behavior is exercised, and an internal rewrite would leave those tests valid. If no valuable test exists, state why and use the strongest relevant validation instead.
