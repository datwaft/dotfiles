# Jira CLI Output Modes

Use this file when you need to choose a non-interactive output mode or explain why a default command should be rewritten.

## Default behavior

Many `jira-cli` commands are optimized for interactive terminal use:

- `jira issue list` defaults to an interactive issue explorer
- `jira epic list` defaults to an explorer view
- `jira sprint list` defaults to an explorer view
- `jira issue view` uses a pager by default
- `jira open` opens a browser unless `-n` is set

These defaults are fine for a human in a terminal, but they are often the wrong choice for scripted or tool-driven workflows.

## Preferred modes by task

### `--raw`

Use `--raw` when you need structured output or want the fullest machine-readable response.

Best for:

- inspecting one issue in detail
- extracting fields for post-processing
- preserving more structure than plain text output

Examples:

```bash
jira issue view ISSUE-123 --raw
jira issue list --raw --paginate 0:20
```

### `--plain`

Use `--plain` when you want deterministic text output that is easy to summarize or pipe into other tools.

Best for:

- short terminal summaries
- compact list output
- shell-oriented workflows

Recommended flags to combine with `--plain`:

- `--columns` to limit fields
- `--no-headers` for script output
- `--delimiter` for custom separators
- `--no-truncate` when full values matter

Examples:

```bash
jira issue list --plain --columns key,status,assignee --paginate 0:20
jira issue list --plain --no-headers --columns key,summary
jira sprint list 970 --plain --columns key,status,assignee
```

### `--table`

Use `--table` with sprint and epic commands when you want a table instead of the explorer UI.

Examples:

```bash
jira epic list --table --plain --columns key,summary,status
jira sprint list --table --plain --columns id,name,state
```

### Pager control for `jira issue view`

If you need the normal rendered view but do not want an interactive pager, use:

```bash
PAGER=cat jira issue view ISSUE-123 --comments 1
```

Prefer `--plain` or `--raw` when possible.

### `jira open -n`

Use `-n` when the user wants the Jira URL or when you need a browser-safe read-only variant.

```bash
jira open ISSUE-123 -n
jira open -n
```

## Selection rules

- choose `--raw` for parsing or field extraction
- choose `--plain` for concise summaries and shell workflows
- choose `--table` for sprint and epic listings when tabular output is enough
- choose `PAGER=cat` only when the rendered issue view matters more than structured output
- choose `-n` for `jira open` unless the user explicitly wants the browser launched

## Common rewrites

- rewrite `jira issue list` to `jira issue list --plain --columns key,status,assignee --paginate 0:20`
- rewrite `jira issue view ISSUE-123` to `jira issue view ISSUE-123 --raw` for machine-readable inspection
- rewrite `jira sprint list` to `jira sprint list --table --plain --columns id,name,state`
- rewrite `jira epic list` to `jira epic list --table --plain --columns key,summary,status`

## Gotchas

- `--raw` exists on `jira issue list` and `jira issue view`, but not every command family has an equivalent
- `--table` changes the presentation mode for sprint and epic list commands, not the underlying data scope
- `--paginate` is especially important with `issue list` and `epic list`; the default can still be more output than you want
- `--delimiter` is spelled correctly in help output even though some README examples say `delimeter`
