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

Delegate work proactively when it does not require the main agent's broader context or full reasoning capability. Prefer delegation over spending main-agent compute on mechanical, repetitive, exploratory, or well-specified work.

When spawning sub-agents:

- Always use GPT-5.6 Luna.
- Never use GPT-5.6 Sol or GPT-5.6 Terra as a sub-agent.
- Always choose the reasoning effort explicitly for each sub-agent according to the work it is receiving.
- Use lower reasoning effort freely for mechanical or repetitive work.
- Increase reasoning effort when the delegated task genuinely requires more independent reasoning.
- Run independent work concurrently when useful.
- Keep architecture, high-level planning, difficult judgment calls, synthesis, and final review in the main agent when they benefit from Sol's capabilities.

Over-delegation is preferable to wasting main-agent compute on work that Luna can perform reliably.
