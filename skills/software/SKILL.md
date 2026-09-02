---
name: software
description: Norms for working in a software project.
disable-model-invocation: true
---

Norms for this session when the work is a software project. They apply whether this session writes the code or dispatches subagents.

## Git

When committing, follow [`git.md`](git.md). Subagents may commit; they follow it too.

## Docs

Human-facing documentation lives under `docs/` by default (a root `README` is fine). Before adding or changing those files: tell the user what you will write and wait for agreement. Write only facts that must persist. If the code already states the behavior, leave it in the code.

## Agent files

Project agent files live under `.agents/` (gitignored). Keep them out of `docs/`, `README`, and other human-facing trees.

## Assign

When dispatching subagents for this work, follow [`workflow.md`](workflow.md).
