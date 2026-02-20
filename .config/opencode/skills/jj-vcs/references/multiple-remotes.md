# Multiple Remotes

How to configure jj when working with multiple remote repositories.

## Nomenclature

- **`origin`**: Remote you have write access to, where you push changes
- **`upstream`**: The canonical/well-known repository (may be read-only)
- Remote bookmarks are referenced as `<bookmark>@<remote>` (e.g., `main@origin`, `main@upstream`)

## Adding remotes

```sh
# Add a remote
jj git remote add upstream https://github.com/org/repo.git

# List remotes
jj git remote list

# Remove a remote
jj git remote remove upstream
```

## Workflow 1: GitHub-style fork (contributing upstream)

You have a fork (`origin`) and want to contribute to the upstream repository.

**Setup:**
- `upstream` = canonical repo you're contributing to
- `origin` = your fork where you push branches for PRs
- Track both `main@upstream` and `main@origin`
- Set `trunk()` to `main@upstream` (the canonical source of truth)

```sh
# Fetch from both remotes by default
jj config set --repo git.fetch '["upstream", "origin"]'

# Push only to your fork by default
jj config set --repo git.push origin

# Track both remote bookmarks
jj bookmark track main@upstream
jj bookmark track main@origin

# Set upstream as the trunk (for immutability and rebasing)
jj config set --repo 'revset-aliases."trunk()"' main@upstream
```

**Daily workflow:**
```sh
# Fetch latest from upstream
jj git fetch

# Start new work based on upstream main
jj new main@upstream -m "feat: my feature"

# ... make changes ...
jj commit -m "feat: add new feature"

# Create bookmark and push to your fork
jj bookmark create my-feature -r @-
jj git push --bookmark my-feature

# Open PR from origin/my-feature to upstream/main
gh pr create --repo org/repo
```

**Keeping fork's main in sync:**
```sh
jj git fetch
# main@origin automatically updates when you push
jj git push --bookmark main
```

## Workflow 2: Independent repo (integrating from upstream)

Your `origin` has diverged from upstream and contains changes that won't be contributed back. You periodically integrate upstream changes.

**Setup:**
- `origin` = your main repository
- `upstream` = source you periodically pull changes from
- Track ONLY `main@origin`, NOT `main@upstream`
- Set `trunk()` to `main@origin`

```sh
# Fetch from origin by default (or both if you want)
jj config set --repo git.fetch '["origin"]'
# Or: jj config set --repo git.fetch '["upstream", "origin"]'

# Push only to origin
jj config set --repo git.push origin

# Track only origin's main
jj bookmark track main@origin
jj bookmark untrack main@upstream

# Your origin defines the trunk
jj config set --repo 'revset-aliases."trunk()"' main@origin
```

**Integrating upstream changes:**
```sh
# Fetch upstream
jj git fetch --remote upstream

# Option 1: Merge upstream into your main
jj new main@origin main@upstream -m "merge upstream"
jj bookmark move main --to @

# Option 2: Rebase your changes onto upstream
jj rebase -b main -d main@upstream

# Option 3: Cherry-pick specific commits
jj duplicate <upstream-change> -d main
```

## Configuration reference

### `git.fetch` - Default remotes to fetch from

```sh
# Fetch from single remote
jj config set --repo git.fetch origin

# Fetch from multiple remotes
jj config set --repo git.fetch '["upstream", "origin"]'

# Override at runtime
jj git fetch --remote upstream
jj git fetch --all-remotes
```

### `git.push` - Default remote to push to

```sh
# Set default push remote
jj config set --repo git.push origin

# Override at runtime
jj git push --remote upstream --bookmark my-feature
```

### Bookmark tracking

Tracking links a local bookmark to a remote bookmark. When the remote changes (via fetch), the local bookmark updates. When you push, the remote updates.

```sh
# Track a remote bookmark
jj bookmark track main@origin
jj bookmark track main@upstream

# Untrack (stop syncing)
jj bookmark untrack main@upstream

# List tracked bookmarks
jj bookmark list --tracked

# Track with specific remote flag
jj bookmark track main --remote=origin
```

**When to track:**
- Track `main@origin` if you want local `main` to stay in sync with your remote
- Track `main@upstream` if you want to automatically get upstream's main on fetch
- Don't track if you want the bookmarks to move independently

### `trunk()` alias

The `trunk()` revset determines what's considered immutable and is the default rebase target.

```sh
# Set trunk to upstream (for fork workflow)
jj config set --repo 'revset-aliases."trunk()"' main@upstream

# Set trunk to origin (for independent repo)
jj config set --repo 'revset-aliases."trunk()"' main@origin

# Check current trunk
jj log -r 'trunk()'
```

## Common multi-remote operations

```sh
# Fetch from specific remote
jj git fetch --remote upstream

# Fetch from all configured remotes
jj git fetch --all-remotes

# Push to specific remote
jj git push --remote upstream --bookmark release

# See all remote bookmarks
jj bookmark list --all

# Compare local vs remote
jj log -r 'main | main@origin | main@upstream'

# Commits on upstream not in origin
jj log -r 'main@upstream ~ main@origin'

# Your commits not yet upstream
jj log -r 'main@origin ~ main@upstream'
```
