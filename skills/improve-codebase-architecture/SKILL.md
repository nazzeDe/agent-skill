---
name: improve-codebase-architecture
description: Explicit architecture review that finds evidence-backed deepening opportunities, presents local visual comparisons, and routes a selected design back to the normal planning workflow.
disable-model-invocation: true
---

# Improve Codebase Architecture

Use only when the user explicitly requests architecture review. It proposes changes; it does not implement them.

## Scope

Start with the user-named subsystem or friction. If none is named, use recent change history to identify a narrow hotspot. Expand only when evidence shows the problem crosses that boundary.

Read relevant human-facing DDD documentation and ADRs. Use `deep-module-design` as the evaluation rubric. When breadth helps, use two or three scoped read-only agents; each must inspect the real code and report evidence.

Look for information leakage, pass-through layers, temporal decomposition, scattered domain knowledge, shallow interfaces, difficult test surfaces, and changes that require unrelated modules to move together. Prefer opportunities tied to observed maintenance cost, defects, or repeated change.

## Report

Write a self-contained report to `.scratch/<effort>/architecture-review.html` using [HTML-REPORT.md](HTML-REPORT.md). It may load Tailwind and Mermaid from read-only CDNs.

Each candidate includes:

- affected modules;
- observed friction and evidence;
- proposed interface and hidden knowledge;
- locality, leverage, testability, migration, and risk;
- before/after visualization;
- `Strong`, `Worth exploring`, or `Speculative` confidence;
- any conflict with an existing ADR.

Open the local report when possible. Do not publish it remotely or place it in public documentation.

## Selection

After the user selects a candidate:

1. use `grill-me` to resolve behavior, boundaries, compatibility, migration, and risk;
2. use `domain-modeling` for approved DDD changes;
3. use `design-an-interface` only when materially different interface shapes remain;
4. return to `to-spec` or `to-tickets` before implementation.

Keep the report as design evidence through formal implementation validation. Delete it and superseded `.scratch` material after acceptance.
