# Global Agent Guidelines

Global expectations for any agent operating on this machine. Treat this as the default contract unless a project defines additional constraints.

## Environment

- Default shell is `zsh`.
- Assume `jj-vcs` for all version control unless told otherwise. Load the skill proactively - don't check for `.jj` first.

## Tooling Access

### CLI Utilities

- `ast-grep` for structural code search and refactoring.
- `jq` / `yq` for structured JSON and YAML processing.
- `gh`, `httpie`, and `curl` for interacting with remote services or APIs (subject to network policy).

## Collaboration Expectations

- Select the base revision that the task requires within the current checkout or workspace. Do not create or request creation of an additional Git worktree or jj workspace unless the user explicitly authorizes it.
- Do not revert or overwrite changes that appear after your edits unless the user directs you to do so; assume they may come from linting, the user, or another developer. If you strongly disagree with an external change, ask for context or permission before altering it.
- If unsure about a direction, surface questions early instead of guessing.
- Preserve project-specific conventions, formatting, and tooling configurations. When in doubt, prefer the existing patterns observed in the repository.
- Avoid refactors unless the task explicitly requests them; if a refactor feels essential, ask for approval before proceeding.

### Testing-specific Behaviour

- Default to solutions that avoid `try`/`catch`/`except` constructs unless the user or project guidelines explicitly request them; failing loudly is preferred to catching errors silently.
- Validate changes by running type checks (e.g., `tsc`) and relevant unit tests (not E2E) to verify behavior. Report any gaps or assumptions back to the user.

## Code Style

- Prefer concrete, top-down code over speculative abstractions.
- Helpers and named types must earn their existence through reuse, domain meaning, isolation of fragile logic or side effects, meaningful nesting reduction, or independent testability.
- Keep trivial expressions and local object shapes inline.
- Avoid functions that merely rename a single call or expression.
- Avoid small type aliases that obscure an otherwise readable inline shape. Use named types for stable domain concepts, shared or large shapes, recursive types, and discriminated unions.
- Treat the common "three uses before extracting" preference as a heuristic, not a rigid rule. A one-off abstraction is appropriate when it provides one of the benefits above.
- Organize code around clear ownership and keep shared modules limited to genuinely shared behavior. Do not create generic utility dumping grounds.
- Prefer explicit classification and validation. Unknown input formats and values should fail loudly rather than silently falling through to a default.
- Test observable behavior and public contracts rather than implementation details or every small helper.

## Sub-agent Delegation

Use sub-agents when delegation can improve speed or quality. Decide based on the work's complexity, independence, context needs, and coordination cost. A fresh context can itself improve quality by isolating noisy work or providing an independent perspective. Run independent work concurrently when useful.

Choose the model based on the role:

- Use GPT-5.6 Luna for bounded execution and support work that does not require stronger judgment.
- A Sol agent keeps planning, architecture, difficult judgment, synthesis, and final review in its main thread and delegates suitable execution work to Luna.
- A Luna agent may coordinate the task in its main thread. It creates Luna sub-agents only to parallelize independent work and delegates bounded planning, difficult judgment, or review to GPT-5.6 Sol when stronger reasoning would materially improve the outcome.
- Do not use Sol when Luna can perform the delegated task reliably.

Choose each sub-agent's reasoning effort explicitly and proportionately. Use lower effort for straightforward work and increase it when the delegated task requires deeper independent reasoning.

Pass only the context the sub-agent needs. Include broader or recent conversation context when the task depends on prior decisions, user constraints, or surrounding work. Omit inherited context for self-contained tasks and state the objective, constraints, and expected result directly in the delegation prompt.

The delegating agent remains responsible for integrating the results and completing the user's task.
