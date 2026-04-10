# Jira CLI Workflows

Use this file when the task needs a repeatable procedure rather than just a command lookup.

## Workflow: inspect and summarize one issue

1. Start with raw or plain issue data:

   ```bash
   jira issue view ISSUE-123 --raw
   ```

   or

   ```bash
   jira issue view ISSUE-123 --plain
   ```

2. Extract the fields the user cares about: status, assignee, priority, summary, comments, linked issues, watchers.
3. If you need a richer human view instead of structured output, use:

   ```bash
   PAGER=cat jira issue view ISSUE-123 --comments 3
   ```

4. Summarize the issue in plain language rather than dumping raw output.

## Workflow: search for issues

1. Prefer first-class flags over raw JQL when the request maps cleanly to built-in filters.
2. Start with a compact command shape:

   ```bash
   jira issue list --plain --columns key,status,assignee --paginate 0:20
   ```

3. Add filters as needed:

- status: `-s"In Progress"`
- priority: `-yHigh`
- assignee: `-a$(jira me)` or a specific user
- reporter: `-r"User Name"`
- labels: `-lbackend`
- created window: `--created week`
- updated window: `--updated -7d`

4. Only switch to `-q/--jql` when the request is easier to express in JQL than in flags.
5. If the result set is large, tighten `--paginate` before adding more tools.

## Workflow: discover boards, sprints, and releases

Use these commands in order of increasing specificity:

```bash
jira board list
jira sprint list --table --plain --columns id,name,state
jira release list
```

If the user names a project, add `-p PROJECT_KEY` at the top level.

## Workflow: assign an issue safely

1. Inspect current issue state:

   ```bash
   jira issue view ISSUE-123 --plain
   ```

2. Choose the assignee form:

- current user: `$(jira me)`
- exact user: `"Full Name"` or email
- default assignee: `default`
- unassign: `x`

3. Run the mutation:

   ```bash
   jira issue assign ISSUE-123 $(jira me)
   ```

4. Verify:

   ```bash
   jira issue view ISSUE-123 --plain
   ```

## Workflow: move an issue safely

1. Inspect current issue state:

   ```bash
   jira issue view ISSUE-123 --plain
   ```

2. If needed, inspect move syntax first:

   ```bash
   jira issue move --help
   ```

3. Run the transition:

   ```bash
   jira issue move ISSUE-123 "In Progress"
   ```

4. Optional extras supported by the command:

- `--comment "Started work"`
- `-a $(jira me)`
- `-R Fixed`

5. Verify with another `jira issue view`.

## Workflow: work with sprint membership

1. Discover the sprint ID:

   ```bash
   jira sprint list --table --plain --columns id,name,state
   ```

2. Add issues if explicitly requested:

   ```bash
   jira sprint add SPRINT_ID ISSUE-123 ISSUE-456
   ```

3. Verify by listing sprint issues:

   ```bash
   jira sprint list SPRINT_ID --plain --columns key,status,assignee
   ```

4. Closing a sprint is mutating and should only happen on explicit user request:

   ```bash
   jira sprint close SPRINT_ID
   ```

## Workflow: turn a doc example into a safe agent command

When the README shows a human-oriented command, rewrite it before execution.

- from `jira issue list`
- to `jira issue list --plain --columns key,status,assignee --paginate 0:20`

- from `jira sprint list`
- to `jira sprint list --table --plain --columns id,name,state`

- from `jira issue view ISSUE-123`
- to `jira issue view ISSUE-123 --raw` or `PAGER=cat jira issue view ISSUE-123`

## Verification checklist

- confirm whether the task was read-only or mutating
- confirm the command mode avoided TUI or pager surprises
- confirm project context with `-p` if the task named a project
- confirm post-mutation state with a read-only follow-up command
- confirm the final response summarizes results instead of dumping raw terminal output
