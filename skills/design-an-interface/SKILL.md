---
name: design-an-interface
description: Bounded multi-design exploration for a public or cross-module interface when materially different interface shapes need comparison.
---

# Design An Interface

Use this only when the user requests alternatives or at least two materially different interface shapes could satisfy an approved problem. For routine interface judgment, use `deep-module-design` without fanout.

## Prepare

Resolve the problem, callers, current use cases, public contract constraints, compatibility, errors, performance, migration cost, and dependencies. Use `grill-me` for missing user-owned decisions and inspect the repository for facts.

Load `deep-module-design` as the shared evaluation rubric.

## Generate

Run one bounded parallel round with two or three fresh-context design agents. Give each the same approved problem and a distinct objective, such as:

- minimum caller knowledge;
- simplest common case with explicit advanced capability;
- strongest compatibility or migration path.

Each design returns:

1. complete contract, including invariants, errors, side effects, and ordering;
2. caller examples;
3. complexity hidden behind the interface;
4. dependency and seam strategy;
5. strengths, misuse risks, and costs.

## Compare

The parent compares interface complexity, hidden functionality, locality, compatibility, implementation feasibility, performance, testability, and misuse risk. Recommend one design or a justified synthesis.

Run at most one focused adversarial review round against the recommended design. If no design satisfies the approved constraints, report the blocking constraint or missing decision instead of launching more rounds.

The user selects the contract. If `orchestrator` is loaded, continue from its spec or ticket path.
