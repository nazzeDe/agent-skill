---
name: research
description: Find first-party evidence for an engineering question. Return concise cited findings directly unless cross-session reuse justifies persistence through the selected local artifact backend.
---

# Research

Use official documentation, specifications, source code, standards, and first-party APIs. Use secondary sources only to locate or contrast primary evidence. Cite every material conclusion and separate evidence from inference.

## Output

Use the local artifact backend; read `../../ARTIFACT-BACKENDS.md` if it has not been resolved.

- Single-session lookup: return concise findings to the parent; do not create a file.
- Cross-session or repeatedly referenced work: persist a note through the selected backend. The scratch backend writes `.scratch/<effort>/research/<topic>.md`; a provider supplies its equivalent local path.

A saved note contains the question, conclusions, exact sources, confidence, conflicting evidence, and remaining gaps. Do not copy large source passages or commit agent-only research.

Use a read-only researcher when background work or source breadth warrants it. External systems remain read-only. Delete the note after its purpose ends or approved durable knowledge moves into human-facing documentation.
