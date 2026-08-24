---
name: code-quality
description: Holistic, risk-proportionate code-quality standard. Use during software design, the refactor phase after tests are green, implementation review, and final diff review. Covers more than explicitly listed examples without encouraging unrelated refactors or dogmatic patterns.
---

# Code Quality

Readable, maintainable code is part of correctness because it determines how reliably the next reviewer or maintainer can understand and change the system.

The user's named practices are examples, not an exhaustive checklist. When the user says "naming, SOLID, single responsibility, ...", inspect all quality dimensions relevant to the change. Do not turn this into permission for unrelated cleanup.

## Quality Model

Evaluate the changed files and the behavior they touch across the dimensions that materially apply:

- **Correctness and invariants:** behavior, edge cases, state transitions, validation, failure semantics, concurrency, and resource lifetime are explicit and defensible.
- **Clarity:** names reveal domain intent; control flow and data flow are easy to follow; abstraction levels are consistent; comments explain reasons and constraints rather than narrating code.
- **Cohesion and responsibility:** behavior that changes together lives together. A module has a coherent reason to change and does not mix unrelated policy, orchestration, storage, transport, or presentation concerns.
- **Coupling and locality:** dependencies are minimal and directional; business knowledge is not scattered; likely changes remain local.
- **Abstraction quality:** interfaces are smaller and simpler than their implementations. The changed module is **deep**: useful capability and hidden complexity relative to a small contract. Apply `deep-module-design` to that module.
- **API usability:** contracts, invariants, errors, side effects, ordering constraints, compatibility, and performance characteristics are difficult to misunderstand or misuse.
- **SOLID and other principles:** use them as diagnostic lenses, not goals. Apply a principle only when it reduces concrete coupling, ambiguity, duplication, or change cost.
- **Simplicity:** remove accidental complexity, dead paths, unnecessary state, redundant indirection, and duplication of knowledge. Do not collapse distinct concepts merely because code looks similar.
- **Test quality:** tests protect meaningful behavior through the module's stable contract, catch plausible regressions, remain deterministic, and stay valid across an internal rewrite. Prefer state and result verification over internal interactions.
- **Operational quality:** where relevant, errors preserve context, logs and metrics support diagnosis, retries and idempotency are intentional, and sensitive data is protected.
- **Security and privacy:** validate trust boundaries, authorization, injection surfaces, secret handling, data exposure, and unsafe defaults in proportion to risk.
- **Performance and resources:** address evident algorithmic, I/O, memory, network, or rendering costs when they matter; do not optimize without evidence.
- **Repository fit:** match domain language, idioms, formatting, and dependency choices already visible in the touched module and its neighbors.
- **Reviewability:** keep the diff focused, explain non-obvious decisions, and avoid mixing mechanical churn with behavioral changes.

## Design Heuristics

Ask questions rather than applying style rules mechanically:

- Can a new maintainer understand intent without reconstructing it from implementation details?
- Does each name distinguish the concept from nearby concepts?
- Is knowledge located where it is owned and most likely to change?
- Is the public interface the smallest useful contract that hides the implementation's complexity?
- Are side effects, errors, dependencies, and state transitions visible at the right boundary?
- Would an internal rewrite preserve the tests?
- Did the change make the system easier or harder to modify correctly next time?
- Is every new abstraction justified by real complexity, a real boundary, or multiple implementations?

Single responsibility does not mean one tiny function or class per action. Cohesive complexity may belong together behind a deep interface. SOLID does not require interfaces, dependency injection, factories, or layers without a concrete need.

## Refactor Decision

After tests are green, classify each material opportunity:

1. **Fix now:** behavior-preserving, low-risk, clearly reduces cognitive load or future defect risk, and stays in the touched area.
2. **Route through workflow:** worthwhile but changes an interface, module boundary, architecture, broad scope, migration, or risk profile.
3. **Defer:** useful but not necessary for the approved change; record the reason.
4. **Reject:** subjective, dogmatic, speculative, or likely to create shallow modules or extra indirection.

Run focused validation after each applied refactor. Never refactor while the suite is red.

## Completion Signal

Quality review is complete when the final diff is correct, tested through the module contract, understandable without avoidable reconstruction, **deep** (small interface, hidden complexity, local change), coherent with the touched module, and free of fixes worth doing now. Judge from the diff, its callers, and one hop along that dependency trail. Report material refactors, deliberate non-refactors, and residual risks.
