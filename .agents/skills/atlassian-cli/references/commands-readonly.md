# ACLI Read-Only Command Quick Reference

Use these as safe defaults for non-mutating Atlassian queries.

## Jira

- `acli jira board get`
- `acli jira board list-projects`
- `acli jira board list-sprints`
- `acli jira board search`
- `acli jira dashboard search`
- `acli jira filter get`
- `acli jira filter get-columns`
- `acli jira filter list`
- `acli jira filter search`
- `acli jira project list`
- `acli jira project view`
- `acli jira sprint list-workitems`
- `acli jira sprint view`
- `acli jira workitem view`
- `acli jira workitem search`
- `acli jira workitem attachment list`
- `acli jira workitem comment list`
- `acli jira workitem comment visibility`
- `acli jira workitem link list`
- `acli jira workitem link type`
- `acli jira workitem watcher list`

## Confluence

- `acli confluence blog list`
- `acli confluence blog view`
- `acli confluence page view`
- `acli confluence space list`
- `acli confluence space view`

## Notes

- Atlassian online reference pages can lag behind installed CLI versions.
- If a command exists in local help but not docs, treat local help text as canonical for that installed version.
- For automation and summarization, prefer adding `--json` where supported.
