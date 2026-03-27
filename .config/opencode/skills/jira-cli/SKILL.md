---
name: jira-cli
description: Use this skill when the user wants to inspect, search, summarize, or update Jira issues, epics, sprints, boards, projects, releases, or server metadata with the `jira` command-line tool (`jira-cli`, `ankitpokhrel/jira-cli`). Also use it when the prompt mentions Jira issue keys like `ABC-123`, JQL, assignees/reporters, sprint or board queries, release/version lists, or converting Jira's interactive output into script-friendly `--plain`, `--raw`, `--table`, or `-n` commands.
license: MIT
compatibility: Requires jira-cli installed and authenticated against a Jira instance.
metadata:
  tool: jira
  scope: jira
  content-style: procedural
---

# Jira CLI (`jira`)

Use this skill to work with Jira through `jira-cli` efficiently and safely. It is most valuable when the agent needs help choosing the right subcommand, avoiding the interactive TUI, or separating read-only inspection from mutating actions.

## When to use this skill

- the user explicitly mentions `jira`, `jira-cli`, or `ankitpokhrel/jira-cli`
- the task mentions Jira issue keys like `ABC-123` even if the user does not name the CLI
- the task involves JQL, issue search filters, assignee/reporter queries, boards, sprints, releases, or server metadata
- the user wants to summarize Jira data for the terminal instead of opening the browser UI
- the task may mutate Jira state and needs a safe command choice plus verification steps

## Default operating procedure

1. Classify the task as `read-only`, `browser side effect only`, or `mutating`.
2. If the exact subcommand is unclear, run the narrowest possible help command first, such as `jira issue move --help`.
3. Prefer non-interactive output modes unless the user explicitly wants the TUI:
   - `--raw` for machine-readable data
   - `--plain` with `--columns` for compact summaries
   - `--table` for sprint and epic listings when you want a table instead of the explorer UI
   - `-n` for `jira open` when you want the URL without launching the browser
4. Execute the smallest command that answers the question or performs the requested change.
5. After any mutation, verify the result with a follow-up read-only command.

## Fast routing

Use these defaults before exploring broader help.

- inspect one issue: `jira issue view ISSUE-123 --raw` or `jira issue view ISSUE-123 --plain`
- search issues: `jira issue list ... --plain --columns key,status,assignee --paginate 0:20`
- raw issue data for parsing: `jira issue list ... --raw --paginate 0:20`
- list boards: `jira board list`
- list projects: `jira project list`
- list releases: `jira release list`
- inspect sprints: `jira sprint list --table --plain --columns id,name,state`
- inspect epics: `jira epic list --table --plain --columns key,summary,status`
- current identity: `jira me`
- Jira instance metadata: `jira serverinfo`
- print browser URL only: `jira open ISSUE-123 -n`

## Command map

Top-level groups:

- `jira issue ...`
- `jira epic ...`
- `jira sprint ...`
- `jira board ...`
- `jira project ...`
- `jira release ...`
- `jira me`
- `jira serverinfo`
- `jira open`
- `jira init`
- `jira version`

High-value issue commands:

- read-only: `jira issue list`, `jira issue view`
- mutating: `jira issue create`, `jira issue edit`, `jira issue assign`, `jira issue move`, `jira issue link`, `jira issue unlink`, `jira issue clone`, `jira issue delete`, `jira issue watch`, `jira issue comment add`, `jira issue worklog add`

High-value planning commands:

- epics: `jira epic list`, `jira epic create`, `jira epic add`, `jira epic remove`
- sprints: `jira sprint list`, `jira sprint add`, `jira sprint close`
- boards: `jira board list`
- projects: `jira project list`
- releases: `jira release list`

## Read-only vs mutating model

Use this classifier unless the user explicitly wants a write operation.

- read-only: `version`, `me`, `serverinfo`, `project list`, `board list`, `release list`, `issue list`, `issue view`, `epic list`, `sprint list`, `help`
- browser side effect only: `open`; prefer `jira open -n` unless the user explicitly wants the browser opened
- mutating: `init`, `issue create|edit|assign|move|link|unlink|clone|delete|watch`, `issue comment add`, `issue worklog add`, `epic create|add|remove`, `sprint add|close`

## Output mode defaults

- use `--raw` when you need structured data or expect to post-process the result
- use `--plain --columns ... --no-headers` when you need a compact, script-friendly summary
- use `--table` for `jira epic list` and `jira sprint list` when you want non-explorer table output
- use `PAGER=cat` or `--plain`/`--raw` for `jira issue view` in scripted contexts
- use `--paginate` intentionally on issue and epic lists to avoid oversized output; format is `<from>:<limit>` and `20` means the same as `0:20`

If you need more detail on output choices, read `references/output-modes.md`.

## Safe workflow for mutating tasks

Follow this plan-validate-execute pattern.

1. Inspect current state with a read-only command.
2. If the target value is ambiguous, gather context before mutating.
3. Use one mutating command at a time.
4. Re-run a read-only command to verify the change.
5. Report both the action and the observed post-change state.

Examples:

- assign an issue:
  1. `jira issue view ISSUE-123 --plain`
  2. `jira issue assign ISSUE-123 $(jira me)`
  3. `jira issue view ISSUE-123 --plain`
- move an issue:
  1. `jira issue view ISSUE-123 --plain`
  2. `jira issue move ISSUE-123 "In Progress"`
  3. `jira issue view ISSUE-123 --plain`
- add work to a sprint:
  1. `jira sprint list --table --plain --columns id,name,state`
  2. `jira sprint add SPRINT_ID ISSUE-123 ISSUE-456`
  3. `jira sprint list SPRINT_ID --plain --columns key,status,assignee`

For more detail, read `references/workflows.md`.

## Gotchas

- many `list` commands default to an interactive TUI; add `--plain`, `--raw`, or `--table` if you want deterministic terminal output
- `jira issue view` uses a pager by default; set `PAGER=cat` or use `--plain` or `--raw` in automation
- `jira open` opens a browser; use `jira open -n` to print the URL only
- `jira issue assign` expects an exact assignee name or email; `$(jira me)` assigns to the current user, `default` assigns to the default assignee, and `x` unassigns
- `jira issue move` can also set `--comment`, `-a/--assignee`, and `-R/--resolution` during transition
- top-level `-p/--project` changes project context; use it whenever the current config points at the wrong project
- top-level `-c/--config` or `JIRA_CONFIG_FILE` lets you switch between Jira configs
- README examples are useful, but local `jira ... --help` is the best source for the installed version

## Common task patterns

### Summarize recent issues

Default command:

```bash
jira issue list --plain --columns key,status,assignee --paginate 0:20
```

If the user names filters, convert them to flags first and only fall back to `-q/--jql` when flags are not expressive enough.

### Inspect one issue deeply

Start with:

```bash
jira issue view ISSUE-123 --raw
```

Use `--plain` when the user wants a terminal-friendly human summary instead of raw data.

### Translate interactive examples into automation-safe commands

If docs show `jira issue list` or `jira sprint list` without output flags, rewrite them to one of these forms before using them in scripted or tool-driven workflows:

- `--plain --columns ...`
- `--raw`
- `--table --plain`
- `-n` for `jira open`

### Discover exact flags

Use narrow help commands such as:

```bash
jira issue list --help
jira epic list --help
jira sprint close --help
```

Avoid broad `jira --help` unless you truly need the top-level command map.

## Validation loop

Before finalizing, check that you used the right mode for the task:

- if the task was read-only, confirm no mutating command ran
- if the task was mutating, confirm you inspected state before and after the change
- if the output was meant for summarization or parsing, confirm you avoided the interactive UI and pager
- if the user asked for a URL, confirm you used `jira open -n` unless they explicitly wanted the browser opened

## References

- read `references/commands-readonly.md` when you need safe default commands fast
- read `references/output-modes.md` when you need to choose between TUI, plain text, raw JSON, table output, pager behavior, or browser behavior
- read `references/workflows.md` when you need step-by-step procedures for searching, inspecting, or mutating Jira data
- GitHub README: <https://github.com/ankitpokhrel/jira-cli>
- Installation wiki: <https://github.com/ankitpokhrel/jira-cli/wiki/Installation>
