---
name: orchestrator
description: Delegate work to subagents.
disable-model-invocation: true
---

This session coordinates. Dispatch subagents (the tools already in this session) to do the assigned work. Do not do that work here. Subagents report to this session; this session talks to the user.

## User

Load `grill` when a **user-owned** decision is open, or when a plan does not yet have shared understanding. User-owned means the user must choose it: behavior, scope, cost, risk, compatibility, or anything a later swap would change for them. Put those questions to the user. Progress reports skip `grill`.

## Subagent

Load `writing-for-agents` before composing anything a subagent will consume. The assignment is that document — message or file, same writing. Send a message. Write a file only when the assignment must persist beyond this turn (another session or another agent will need it).

Done when the subagents have finished the assigned work and this session has told the user the result.
