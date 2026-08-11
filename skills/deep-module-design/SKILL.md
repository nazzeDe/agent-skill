---
name: deep-module-design
description: Evaluation rubric for module depth, information hiding, locality, leverage, dependency seams, and tests. It does not generate competing designs or mandate an architecture pattern.
---

# Deep Module Design

Use this skill to evaluate a proposed or existing module. Use `design-an-interface` when competing interface designs are needed.

## Terms

- **Module:** a cohesive unit with a contract and hidden implementation. It may be a function, class, package, service, or vertical capability.
- **Interface:** everything a caller must know: operations, inputs, outputs, invariants, ordering, errors, side effects, configuration, compatibility, and relevant performance behavior.
- **Implementation:** knowledge and mechanics hidden behind the interface.
- **Depth:** useful capability and hidden complexity relative to interface complexity.
- **Leverage:** capability gained for the knowledge a caller must learn.
- **Locality:** related knowledge, changes, diagnosis, and verification stay together.
- **Seam:** a place where behavior or a dependency can be replaced without changing the caller.
- **Adapter:** an implementation that satisfies a boundary contract.

## Evaluation

Prefer modules that:

- expose the smallest useful contract for current needs;
- hide design decisions and pull complexity inward;
- keep common operations simple without blocking necessary special cases;
- concentrate domain knowledge and likely changes;
- avoid information leakage, temporal decomposition, pass-through wrappers, and classitis;
- make misuse, invalid states, ordering constraints, and failure behavior difficult to overlook;
- fit the repository's domain language and architecture.

A module may expose several cohesive operations. Method count and adapter count do not determine depth. Introduce a seam when a real variation source, external boundary, nondeterminism, expensive dependency, test-control need, or replacement requirement justifies it. Prefer real dependencies in tests when they are fast, deterministic, and simple.

YAGNI applies to speculative capabilities and extension points. It does not prohibit refactoring that makes current code easier to understand and change.

## Questions

- What unique value and knowledge does this module own?
- What must callers learn, and which parts can move behind the interface?
- Does the interface serve current use cases without exposing implementation decisions?
- Will a likely behavior change remain local?
- Is each seam justified by evidence rather than a pattern?
- Can tests use the same stable contract as real callers?
- Would removing this abstraction reduce or merely redistribute complexity?

## Tests

Test observable behavior through the module's stable contract. Prefer state and result verification over internal interactions. Before deleting lower-level tests, map their behaviors, invariants, and failure coverage to the replacement tests. Delete only tests proven redundant or brittle; some overlap is valuable for reusable modules.

## Output

Return the module's contract, hidden knowledge, depth and locality assessment, justified seams, misuse risks, test surface, and concrete changes worth considering. Keep this a rubric; do not start multi-agent design exploration.
