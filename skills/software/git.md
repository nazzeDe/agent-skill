# Git

## Branch

- One local topic branch per effort: `effort/<slug>`, or the repo's existing naming.
- Do not merge to the default branch unless the user explicitly asks.

## Commit

- Stage only files for that delivery. Exclude `.agents/`, agent-only artifacts, and unrelated dirty files. Suspicious extra changes -> ask the user.
- Message: follow repo convention (commitlint, CONTRIBUTING, recent style). If none: Conventional Commits `type(scope): summary` with optional body (why / ticket id). Types: `feat|fix|refactor|test|docs|perf|chore|...`. Breaking: `!` or footer.
- Run repo hooks. Hook failure -> fix or ask; do not `--no-verify` unless the user explicitly authorizes it.

## History

- Unpushed topic branch: rebase/amend OK to keep history readable.
- Pushed commits / default branch: no rewrite, no force-push, unless the user explicitly authorizes it this turn.

## Remote

- Default: local only. No push, PR, issue/label/reviewer changes.
- When the user explicitly authorizes remote write this turn: `push -u` the topic branch and open a PR with the repo's usual tool/template (`gh pr create`, etc.).
- PR body: behavior change + validation evidence.
- Do not merge the PR or edit labels/reviewers unless separately authorized.
