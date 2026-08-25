# Local Artifact Backends

Artifact backends persist agent-only planning and continuity material. They do not define the engineering workflow.

## Selection

1. Default to the scratch backend below.
2. A trusted project may opt into another backend by creating `.agents/artifact-backend.json` at the repository root.
3. The marker must contain:

```json
{
  "version": 1,
  "backend": "<backend-id>",
  "contract": "<repo-relative markdown path>",
  "localOnly": true
}
```

4. Read the declared contract before writing an agent artifact. Resolve the contract path from the repository root.
5. If the marker or contract is missing, invalid, outside the repository, or contradicts this protocol, report the problem and use the scratch backend. Do not infer a backend merely from a tool-specific directory such as `.trellis/`.

## Authority Boundary

A backend may define only:

- local paths for approved specs, tickets, research, and handoffs;
- how an effort is resumed across sessions;
- a projection of engineering-workflow state into backend metadata;
- local cleanup or archive commands;
- context files that a worker or reviewer must receive.

A backend must not change:

- implementer versus orchestrator identity, or ticket dispatch;
- user approval gates;
- public behavior or scope decisions;
- TDD and diagnostic routing;
- one-writer, read-only reviewer, and same-pair resume rules;
- validation, code-quality, or completion requirements;
- remote collaboration permissions;
- source-code commit policy.

When backend instructions conflict with `engineering-workflow` outside the allowed persistence boundary, `engineering-workflow` wins.

## Scratch Backend

When no valid marker is active:

- effort root: `.scratch/<effort>/`;
- spec: `.scratch/<effort>/spec.md`;
- tickets: `.scratch/<effort>/tickets/<NN>-<slug>.md`;
- research: `.scratch/<effort>/research/`;
- handoff: `.scratch/<effort>/handoff.md`.

Keep `.scratch/` local. Delete temporary artifacts after acceptance or after approved durable knowledge moves into human-facing documentation.

## Provider Use

- Select the backend once near the start of consequential work and keep it stable for that effort.
- Draft consequential artifacts in the conversation and obtain the same approval required by the owning skill before persisting them.
- A provider may map one logical artifact across several files, but the conversation draft remains the unified review surface.
- Pass provider-declared context paths to workers and reviewers explicitly. Backend context never replaces repository exploration.
- Disposable prototypes and generated review reports remain under `.scratch/` unless their specialized skill explicitly says otherwise.
- Agent-only artifacts remain local even when source code and approved human documentation are committed normally.
