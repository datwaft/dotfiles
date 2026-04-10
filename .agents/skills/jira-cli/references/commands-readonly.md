# Jira CLI Read-Only Command Quick Reference

Use this file when you need safe, non-mutating defaults quickly.

## Safe command families

These commands do not change Jira state:

- `jira version`
- `jira me`
- `jira serverinfo`
- `jira project list`
- `jira board list`
- `jira release list`
- `jira issue list`
- `jira issue view`
- `jira epic list`
- `jira sprint list`
- `jira help`
- `jira <command> --help`

## Identity and environment

```bash
jira version
jira me
jira serverinfo
```

Use these first when you need to confirm installation, authentication, or the Jira instance.

## Projects, boards, releases

```bash
jira project list
jira board list
jira release list
```

If the user names a project, add `-p PROJECT_KEY` at the top level.

Examples:

```bash
jira -p ABC board list
jira -p ABC release list
```

## Issue search defaults

Use this as the default compact issue summary:

```bash
jira issue list --plain --columns key,status,assignee --paginate 0:20
```

Useful read-only filters:

- assigned to current user: `-a$(jira me)`
- status: `-s"In Progress"`
- priority: `-yHigh`
- reporter: `-r"User Name"`
- label: `-lbackend`
- recent work: `--updated -7d`
- created this week: `--created week`
- watched issues: `-w`
- recent history: `--history`

Examples:

```bash
jira issue list -a$(jira me) --plain --columns key,status,summary --paginate 0:10
jira issue list -s"In Progress" -yHigh --plain --columns key,assignee,status --paginate 0:20
jira issue list -q "project = ABC ORDER BY updated DESC" --raw --paginate 0:20
```

## Issue inspection defaults

Choose one of these based on the task:

```bash
jira issue view ISSUE-123 --raw
jira issue view ISSUE-123 --plain
PAGER=cat jira issue view ISSUE-123 --comments 3
```

- use `--raw` for structured inspection
- use `--plain` for compact terminal output
- use `PAGER=cat` only when the rendered view matters more than structured output

## Epic and sprint inspection

Safe defaults:

```bash
jira epic list --table --plain --columns key,summary,status
jira sprint list --table --plain --columns id,name,state
```

Inspect issues inside a specific epic or sprint:

```bash
jira epic list EPIC-123 --plain --columns key,status,assignee
jira sprint list 123 --plain --columns key,status,assignee
```

## Browser-safe URL lookup

`jira open` normally launches a browser. Use `-n` to keep it read-only from the terminal's perspective.

```bash
jira open -n
jira open ISSUE-123 -n
```

## Help-first discovery

When you know the area but not the exact syntax, prefer narrow help commands:

```bash
jira issue list --help
jira issue view --help
jira epic list --help
jira sprint list --help
```

## Notes

- many read-only commands default to an interactive UI; add `--plain`, `--raw`, or `--table` when you need deterministic output
- `jira open -n` is safer than `jira open` when the user did not ask to launch a browser
- local `jira ... --help` output is the best source for the installed version
