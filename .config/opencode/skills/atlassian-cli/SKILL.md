---
name: atlassian-cli
description: Use Atlassian CLI (acli) for Jira and Confluence operations. Load this skill when a task mentions Atlassian CLI/acli, Jira command-line workflows, or Confluence command-line workflows.
license: MIT
compatibility: Requires Atlassian CLI installed and authenticated.
metadata:
  tool: acli
  scope: jira-confluence
---

# Atlassian CLI (acli)

Use this skill to execute Jira and Confluence workflows through `acli` without repeatedly discovering command groups via `--help`.

## When to use this skill

- user explicitly mentions `acli`, Atlassian CLI, Jira CLI, or Confluence CLI
- task involves listing, searching, viewing, or inspecting Jira/Confluence resources
- task involves potentially mutating Atlassian resources and needs safe command selection

## Command map (high value paths)

Top-level groups:

- `acli jira ...`
- `acli confluence ...`
- `acli admin ...`
- `acli auth ...`
- `acli config ...`

Common Jira paths:

- work items: `acli jira workitem view|search|create|edit|delete|transition|assign|comment ...`
- boards: `acli jira board search|get|list-sprints|list-projects|create|delete`
- projects: `acli jira project list|view|create|update|archive|restore|delete`
- filters: `acli jira filter list|search|get|get-columns|add-favourite|change-owner|update|reset-columns`
- sprints: `acli jira sprint view|list-workitems|create|update|delete`
- dashboards: `acli jira dashboard search`

Common Confluence paths:

- pages: `acli confluence page view`
- blogs: `acli confluence blog list|view|create`
- spaces: `acli confluence space list|view|create|update|archive|restore`

## Read-only vs mutating model

Use this default classifier unless the user asks otherwise.

- read-only verbs: `view`, `get`, `list`, `search`, `type`, `visibility`
- mutating verbs: `create`, `update`, `edit`, `delete`, `archive`, `restore`, `assign`, `transition`, `clone`, `link create/delete`, `watcher remove`, `add-favourite`, `change-owner`, `reset-columns`

If a command has no obvious verb, inspect the command description before running it.

## Output defaults

- prefer `--json` when results may need parsing or summarization
- use `--csv` only when user asks for CSV/export behavior
- use pagination flags (`--paginate`, `--limit`) intentionally to avoid huge outputs

## Safety and execution guidance

- do not run mutating commands unless user intent is explicit
- do not assume online reference pages are complete; local `acli ... --help` may expose newer commands
- for unknown subcommands, run the narrowest help command (for example, `acli jira workitem comment --help`) rather than broad top-level help

## Practical templates

```bash
# Search Jira work items
acli jira workitem search --jql "project = TEAM ORDER BY updated DESC" --limit 20 --json

# View one work item
acli jira workitem view TEAM-123 --json

# List boards
acli jira board search --limit 50 --json

# List sprint issues
acli jira sprint list-workitems --board 6 --sprint 42 --json

# View Confluence page
acli confluence page view --id 123456 --json
```

## References

- Command quick reference: [commands-readonly.md](references/commands-readonly.md)
- Atlassian docs intro: https://developer.atlassian.com/cloud/acli/guides/introduction/
- Atlassian command reference index: https://developer.atlassian.com/cloud/acli/reference/commands/
