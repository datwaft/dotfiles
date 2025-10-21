# Global Agent Guidelines (AGENTS.md)

Global expectations for any agent operating on this machine. Treat this as the default contract unless a project defines additional constraints.

## Environment

- Default shell is `zsh`; assume shell snippets and scripts must be `zsh`-compatible.
- All work happens inside `tmux`, so be ready to inspect split panes or scrollback when diagnosing tooling output.
- The tools listed below are always installed and ready to use. If you rely on anything else, ask before installing or assuming availability.

## Tooling Access

### CLI Utilities

- `ripgrep` and `fd` for fast code and file search.
- `jq` / `yq` for structured JSON and YAML processing.
- `watchexec` for file watching and triggering actions.
- `tmux` for navigating panes, checking background processes, and reviewing scrollback.
- `gh`, `httpie`, and `curl` for interacting with remote services or APIs (subject to network policy).

## Collaboration Expectations

- Do not revert or overwrite changes that appear after your edits unless the user directs you to do so; assume they may come from linting, the user, or another developer. If you strongly disagree with an external change, ask for context or permission before altering it.
- Default to solutions that avoid `try`/`catch`/`except` constructs unless the user or project guidelines explicitly request them; failing loudly (especially in tests) is preferred to catching errors silently.
- Expect that all code will be reviewed and potentially reshaped by the user, who has strong stylistic and architectural opinions. If unsure about a direction, surface questions early instead of guessing.
- Preserve project-specific conventions, formatting, and tooling configurations. When in doubt, prefer the existing patterns observed in the repository.
- Avoid refactors unless the task explicitly requests them; if a refactor feels essential, ask for approval before proceeding.
- Validate significant changes (tests, lint, build) when feasible, and clearly report any gaps or assumptions back to the user.
