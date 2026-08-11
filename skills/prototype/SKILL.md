---
name: prototype
description: Build disposable executable evidence for an unresolved logic, state-model, or UI design question. Prototype code is never promoted directly to production.
---

# Prototype

A prototype answers one approved design question. Use [LOGIC.md](LOGIC.md) for logic or state models and [UI.md](UI.md) for visual or interaction alternatives.

## Rules

- State the question before writing code.
- Prefer `.scratch/<effort>/prototype/` for standalone work. If the prototype must integrate with the application, use a local temporary branch or worktree and keep it out of the main branch.
- Use the repository's existing language, runtime, components, and task runner.
- Keep state local and disposable. Do not connect real writes, production data, or remote side effects.
- Implement only what is needed to answer the question. Prototype code does not need production abstractions, exhaustive errors, or its own test suite.
- Make the relevant state or UI variants directly observable and runnable with one command or URL.

## Lifecycle

1. The user evaluates the prototype and approves a conclusion.
2. Record the conclusion as a design contract or acceptance behavior.
3. Keep the prototype runnable while production code is implemented from scratch.
4. Use the prototype as comparison evidence; do not copy, promote, or directly convert its code into production code.
5. After the formal implementation passes validation and any required user acceptance, delete the prototype and superseded `.scratch` material.
