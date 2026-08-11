# UI Prototype

Create structurally different UI variants when layout, hierarchy, or primary interaction needs user judgment.

## Shape

- Prefer the existing page and real surrounding shell. Replace only the subtree being evaluated.
- Use a local temporary branch or worktree when integration with the application is required.
- Default to three variants; use at most five. Variants must differ in structure or interaction, not only color or copy.
- Select variants with a shareable `?variant=` parameter and a small fixed switcher using the project's router and icon library.
- Preserve the loading contract and data shape, but use local or explicitly non-production data. Stub any loader that would access production, plus all mutations and remote side effects.
- Keep prototype controls visually distinct and absent from the formal implementation.

Provide the run command and variant URLs. Record the user's selected structure, combined elements, and acceptance behavior.

Keep all variants available while the formal UI is implemented from scratch and compared against the approved result. After implementation validation and user acceptance, delete the variants, switcher, temporary route, and other prototype material. Do not promote prototype components directly into production.
