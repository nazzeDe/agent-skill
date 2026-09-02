# Assign

The **executor** implements the change. The **checker** verifies that change against the assignment. They are different subagents. Start the checker without the executor's chain — it must not inherit the executor's reasoning.

**Continue** the same subagent when the assignment is unchanged and you are sending more feedback (checker findings, extra evidence).
**Start a new** subagent when the work is new, or when behavior, scope, or stack pins changed.

The assignment (the document the subagent consumes) names:

- **seam** — where in the codebase to work
- **acceptance** — observable behavior that must hold
- **Validation** — the command that exercises that behavior
- **Quality gates** — from `constraints.md` when that heading exists

Done when the executor and the checker have each returned, and every acceptance item is met or raised to the user.
