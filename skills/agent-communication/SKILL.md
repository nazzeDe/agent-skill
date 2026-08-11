---
name: agent-communication
description: Attention-stable communication for user questions, plans, Issues, subagent contracts, review requests, escalation, and handoffs. State desired behavior first, express success observably, and reserve negative wording for concise boundaries paired with a positive alternative.
---

# Agent Communication

Anchor attention on the target state. Tell the recipient what successful behavior looks like before describing exclusions. Long prohibition lists make the excluded concepts disproportionately salient and leave the intended action underspecified.

Negative wording remains useful for hard boundaries. Use it deliberately for scope, safety, compatibility, irreversible operations, mutation permissions, and security constraints. Follow every boundary with the action to take instead.

## Message Shape

Build consequential messages in this order, including only sections that add information:

1. **Goal:** one affirmative sentence naming the outcome.
2. **Context:** the evidence, approved decisions, files, issue, or behavior that grounds the work.
3. **Success:** observable acceptance criteria and priority order.
4. **Boundaries:** concise limits needed to protect scope or safety.
5. **Boundary action:** the positive fallback, escalation path, or stop condition.
6. **Validation:** checks to run and evidence to return.
7. **Output:** the expected response or artifact shape.
8. **Stop:** conditions that mean the task is complete or requires a decision.

Put the most important instruction first. Use one primary action per sentence or bullet. Resolve conflicting instructions explicitly by priority rather than adding more emphasis words.

## Affirmative-First Rewrites

Prefer:

- `Inspect the diff and return evidence-backed findings. Boundary: project files remain unchanged.`
- `Escalate unresolved product decisions to the parent and wait for the answer.`
- `Add tests that protect observable behavior through the public interface. Boundary: implementation-detail assertions are outside this test surface.`
- `Use existing repository patterns. Introduce an abstraction when it hides concrete complexity or serves a real boundary.`
- `Modify the authentication module only. Report payment-module implications to the parent for separate routing.`

These are stronger than prompts that only say `do not edit`, `do not guess`, `do not write bad tests`, or `do not over-engineer`, because the recipient receives an executable alternative.

## User Dialogue

When user input is required:

- state the current shared understanding briefly
- ask one decision question at a time
- give the recommended answer and its reason
- explain the consequence of each materially different option
- resume work from the approved answer

Use `grill-me` for design work and unresolved requirements. Repository-answerable questions belong to repository exploration; user-owned product, scope, taste, cost, and risk decisions belong to the user.

## Plans And Issues

Describe deliverable behavior as outcomes and vertical slices. Use acceptance criteria that can be observed by a user, caller, test, or operator. Put non-goals in a short boundary section after the solution. Give each dependency an owner and each unresolved decision an escalation path.

A plan should help the implementer choose correct actions when details differ from expectations. Avoid scripts that prescribe incidental implementation steps without explaining the invariant they protect.

## Subagent Contract

Use this compact structure for worker, reviewer, researcher, and validator prompts:

```text
Goal: <concrete outcome>
Context: <approved issue, evidence, relevant files or behavior>
Success: <observable acceptance criteria in priority order>
Boundaries: <only load-bearing scope/safety limits>
At a boundary: <stop, escalate, or return a finding>
Validation: <commands or user flows and required evidence>
Output: <handoff or finding format>
Stop when: <completion or decision condition>
```

For implementation workers, state the intended change before naming files that remain untouched. For reviewers, state the defects or qualities to detect before the read-only boundary. For escalation, ask for the smallest decision that unblocks progress and include a recommendation.

## Reviews And Handoffs

Request findings by impact and evidence, not by generic intensity. A strong review prompt names the contract being checked, the risk angles, severity threshold, file or behavior evidence, and disposition categories.

A useful completion handoff states:

- delivered behavior
- material design and quality decisions
- changed files or artifacts
- validation evidence and exit status
- residual risk, deferred work, and decisions still required

## Final Check

Before sending a consequential message, verify:

- the first instruction describes the desired target state
- success can be observed
- examples are treated as illustrative when the surrounding request implies more
- each negative boundary is necessary and has a positive fallback
- priorities and ownership are clear
- the recipient knows when to stop or escalate
- repeated warnings, double negatives, vague intensifiers, and incidental procedure have been removed
