# Pi Dispatch

Harness adapter for [SKILL.md](SKILL.md). Read this when dispatching a ticket in a session that can call `subagent` with `workflowScript`. Substitute the approved ticket path for `TICKET_PATH`. Missing `.agents/constraints.md` is fine; `reads` skips absent files. When the ticket meets the `diagnose-bug` trigger, append `diagnose-bug` to the worker `skill` array.

Read `writing-for-agents` before sending the child task. Goal names the ticket Outcome; Context names the seam; Success includes the worker command and a deep module. You may substitute those Goal/Context lines from the ticket; keep the rest of this contract. Add backend-declared extra `reads` when the selected artifact backend names them.

The reviewer must be able to run Validation and pinned quality gates (`bash`). If the `reviewer` agent cannot, use a read-only agent that can.

**Fresh pair.** Call `subagent` once with `workflowScript` below. `async: true`. `context: "fresh"`.

```javascript
const ticket = "TICKET_PATH";
const reads = [ticket, ".agents/constraints.md"];
const worker = await runs.run("impl", {
  agent: "worker",
  context: "fresh",
  skill: ["tdd", "code-quality", "deep-module-design"],
  reads,
  phase: "Implementation",
  task: [
    "Goal: implement the approved ticket Outcome as a deep module in the seam the ticket names.",
    "Context: the ticket file is the planning document. Start in the named seam. Read .agents/constraints.md when it was provided for repo pins.",
    "Success: Outcome, Contract, and Acceptance hold. The worker Validation command exits 0. When constraints.md names Quality gates, those commands exit 0. Callers see a small contract; complexity stays inside; tests use that contract.",
    "Work: read the ticket and the named seam. Tests through that contract fail for a plausible defect. Shape the module with tdd, code-quality, and deep-module-design as you go.",
    "At a boundary: escalate unapproved user-owned decisions; keep the diff on the ticket seam.",
    "Validation: run the ticket worker command, package-scoped and quiet when the toolchain allows. Run Quality gates from constraints.md when that heading exists.",
    "Output: Implemented / Changed files / Validation / Residual risks / Module depth.",
    "Stop when: the Validation command exits 0, Acceptance holds, pinned Quality gates exit 0, and the changed module is deep, or a user-owned decision is required."
  ].join("\n")
});
const review = await runs.run("review", {
  agent: "reviewer",
  context: "fresh",
  skill: ["verify"],
  reads,
  phase: "Review",
  task: [
    "Goal: verify the worker change against the ticket contract, acceptance, tests, and pinned quality gates.",
    "Context: ticket " + ticket + ". Worker evidence:",
    worker.output,
    "In-scope: the ticket and the files the worker changed.",
    "Success: Correct / Blocker / Note with file or command evidence, ordered by impact. A Blocker is only: a pinned quality gate exited non-zero; an Acceptance or Contract item has no test that pins it; a test cannot fail for the defect it claims; the Validation command does not exercise that behavior.",
    "Work: load verify. Read the ticket, the tests that claim those behaviors, and the code needed to check the claims. Run the ticket Validation command and every Quality gates command in constraints.md.",
    "At a boundary: return a finding. Project files stay unchanged.",
    "Validation: run the ticket worker command and pinned Quality gates.",
    "Output: Correct / Blocker / Note.",
    "Stop when: every Acceptance item is Correct or a Blocker, and every pinned gate has a result."
  ].join("\n")
});
return { worker: worker.output, review: review.output };
```

Keep the workflow's `impl` and `review` run ids. After it returns, follow Review And Complete. `Blocker` work uses the contracts below.

Resume worker when Review And Complete says any `Blocker`. Interpolate the Blockers and gate failure output. `async: true`.

```javascript
return runs.run("impl", {
  resume: IMPL_RUN_ID,
  task: [
    "Goal: account for every Blocker in the review. Fix a real defect, reject a misread with file evidence, or escalate a user-owned decision.",
    "Context: the ticket is still the planning document. You already implemented this seam. Blockers:",
    REVIEW_TEXT,
    "Success: each Blocker is fixed, rejected with file evidence, or escalated. If you changed code, the worker Validation command exits 0 and pinned Quality gates exit 0. Callers still see the same small contract.",
    "Work: read each Blocker. Tests through the seam fail for a plausible defect. Shape the fix with tdd, code-quality, and deep-module-design as you go.",
    "At a boundary: escalate unapproved user-owned decisions; keep the diff on the ticket seam.",
    "Validation: run the ticket worker command, package-scoped and quiet when the toolchain allows. Run Quality gates from constraints.md when that heading exists.",
    "Output: Fixed / Rejected / Escalated / Changed files / Validation.",
    "Stop when: every Blocker is accounted for, or a user-owned decision is required."
  ].join("\n")
});
```

Resume the same reviewer when Review And Complete says the worker made _progress_. Interpolate the worker evidence. `async: true`.

```javascript
return runs.run("review", {
  resume: REVIEW_RUN_ID,
  task: [
    "Goal: re-verify the worker response against the ticket contract, acceptance, tests, pinned quality gates, and the prior Blockers.",
    "Context: ticket TICKET_PATH. Worker evidence:",
    WORKER_TEXT,
    "In-scope: the ticket, the prior Blockers, and the files the worker changed.",
    "Success: Correct / Blocker / Note with file or command evidence, ordered by impact. Withdraw a Blocker the worker refuted. Keep a Blocker only with remaining file evidence. A Blocker is only: a pinned quality gate exited non-zero; an Acceptance or Contract item has no test that pins it; a test cannot fail for the defect it claims; the Validation command does not exercise that behavior.",
    "Work: load verify. Read the ticket, the tests that claim those behaviors, and the code needed to check the claims. Run the ticket Validation command and every Quality gates command in constraints.md.",
    "At a boundary: return a finding. Project files stay unchanged.",
    "Validation: run the ticket worker command and pinned Quality gates.",
    "Output: Correct / Blocker / Note.",
    "Stop when: every Acceptance item is Correct or a Blocker, and every pinned gate has a result."
  ].join("\n")
});
```

**Follow-up.** Review And Complete names a follow-up: call `subagent` once with the fresh-pair `workflowScript`. Substitute the new ticket path for `TICKET_PATH`. Do not resume the just-closed ids. `async: true`. After it returns, follow Review And Complete.
