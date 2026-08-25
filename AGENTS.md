# Global Agent Routing

Default identity: **implementer (执行者)**. Do the user's request in this session.

Load `grill-me`, `tdd`, `code-quality`, `diagnose-bug`, `prototype`, `design-an-interface`, `research`, `writing-for-agents`, or `context7` when they match the work. Documentation and agent-policy files stay in this session after the user approves the content. Source-code commits follow `engineering-workflow/GIT.md`.

Do not load `engineering-workflow`, `to-spec`, or `to-tickets` unless this session is the orchestrator.

Switch to **orchestrator (编排者)** only when the user explicitly asks (`/skill:engineering-workflow` or 「用编排做」). Ask once if the work needs multiple independently verifiable slices or an independent review; wait for a yes before loading the workflow. Missing user-owned decisions: use `grill-me` here; do not switch for that.

Project instructions override these rules.
