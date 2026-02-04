# Global Agent Guidelines

Global expectations for any agent operating on this machine. Treat this as the default contract unless a project defines additional constraints.

## Environment

- Default shell is `zsh`.
- Work happens inside `tmux`. Use `tmux capture-pane` or similar commands when you need to inspect other panes or scrollback.
- The tools listed below are always installed and ready to use. If you rely on anything else, ask before installing or assuming availability.
- Assume `jj-vcs` for all version control unless told otherwise. Load the skill proactively - don't check for `.jj` first.

## Tooling Access

### CLI Utilities

- `ripgrep` and `fd` for fast code and file search.
- `ast-grep` for structural code search and refactoring.
- `jq` / `yq` for structured JSON and YAML processing.
- `gh`, `httpie`, and `curl` for interacting with remote services or APIs (subject to network policy).

## Collaboration Expectations

- Do not revert or overwrite changes that appear after your edits unless the user directs you to do so; assume they may come from linting, the user, or another developer. If you strongly disagree with an external change, ask for context or permission before altering it.
- Default to solutions that avoid `try`/`catch`/`except` constructs unless the user or project guidelines explicitly request them; failing loudly (especially in tests) is preferred to catching errors silently.
- If unsure about a direction, surface questions early instead of guessing.
- Preserve project-specific conventions, formatting, and tooling configurations. When in doubt, prefer the existing patterns observed in the repository.
- Avoid refactors unless the task explicitly requests them; if a refactor feels essential, ask for approval before proceeding.
- Validate changes by running type checks (e.g., `tsc`) and relevant unit tests (not E2E) to verify behavior. Report any gaps or assumptions back to the user.
