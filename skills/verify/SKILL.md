---
name: verify
description: Read-only delivery verification of an implemented ticket against contract, acceptance, tests, and project-pinned quality gates.
---

# Verify

Use after a worker has implemented a ticket. Project files stay unchanged.

## 1. Read the claims

Read the ticket Outcome, Contract, Acceptance, and Validation command. Read `.agents/constraints.md` when present. Quality gates are the commands under a `Quality gates` heading there. No such heading means no extra gates.

This step is done when every Acceptance item, the Validation command, and every pinned gate command are listed.

## 2. Read the evidence

Read the tests that claim those behaviors and the production code needed to check the claims. Follow one hop along a symbol the diff uses (or that uses the diff) when a claim is otherwise unverifiable.

This step is done when each Acceptance item is paired with test evidence or marked missing.

## 3. Run the gates

Run the ticket Validation command. Run each pinned quality-gate command. Record exit codes and the failing output.

This step is done when every listed command has been run.

## 4. Classify

Findings are `Correct`, `Blocker`, or `Note`, ordered by impact, with file or command evidence.

A **Blocker** is only:

1. A pinned quality gate exited non-zero.
2. An Acceptance or Contract item has no test that pins it.
3. A test cannot fail for the defect it claims to catch.
4. The Validation command does not exercise that behavior.

A **Note** is residual risk only: unpinned gates, out-of-scope hazards.

**Correct** when every Acceptance item is pinned, Validation exercises those behaviors, and pinned gates exited 0.

Stop when every Acceptance item is Correct or a Blocker, and every pinned gate has a result.
