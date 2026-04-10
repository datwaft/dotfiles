# Bookmarks and Remote Operations

## Bookmarks overview

Bookmarks are named pointers to revisions, equivalent to Git branches. They:
- Map 1:1 to Git branches when pushing/fetching
- Auto-move when the commit they point to is rewritten (rebase, squash, etc.)
- Are deleted when their target commit is abandoned

## Basic commands

```sh
# Create bookmark on a revision
jj bookmark create <name> -r <revision>
jj b c <name> -r <revision>  # shorthand

# Common pattern: create on parent after jj commit
jj bookmark create feat/foo -r @-

# List bookmarks
jj bookmark list           # local bookmarks
jj bookmark list --all     # include remote bookmarks
jj b l -a                  # shorthand

# Move bookmark to different commit
jj bookmark move <name> --to <revision>
jj b m <name> --to @-

# Delete bookmark
jj bookmark delete <name>
jj b d <name>

# Rename bookmark
jj bookmark rename <old> <new>
```

## Remote bookmarks

Remote bookmarks are stored as `<name>@<remote>` (e.g., `main@origin`).

```sh
# Reference remote bookmark
jj new main@origin

# Track a remote bookmark (sync on fetch)
jj bookmark track <name>@<remote>

# Untrack a remote bookmark
jj bookmark untrack <name>@<remote>

# List tracked bookmarks
jj bookmark list --tracked
```

## Pushing to remotes

```sh
# Push specific bookmark (explicit, safe for automation)
jj git push --bookmark <name>

# Push all tracked bookmarks that have changes
jj git push

# Create bookmark from change ID and push (auto-generates name like "push-mwmpwkwknuz")
jj git push -c <change-id>
jj git push -c @-  # common: push parent of working copy

# Push to specific remote
jj git push --remote origin --bookmark feat/foo
```

Push safety: `jj git push` has built-in `--force-with-lease` behavior - it checks the remote state matches jj's record before pushing.

## Fetching from remotes

```sh
# Fetch from default remote
jj git fetch

# Fetch from specific remote
jj git fetch --remote upstream

# Fetch all remotes
jj git fetch --all-remotes
```

Note: There's no `jj git pull`. Use `jj git fetch` then `jj rebase -d main@origin` to update.

## GitHub/GitLab workflow

### Creating a PR (explicit bookmark)

```sh
# Do work
jj new main
# ... make changes ...
jj commit -m "feat: add new feature"

# Create and push bookmark
jj bookmark create feat/my-feature -r @-
jj git push --bookmark feat/my-feature

# Create PR with gh CLI
gh pr create
```

### Creating a PR (auto-generated bookmark)

```sh
# Do work
jj new main
# ... make changes ...
jj commit -m "feat: add new feature"

# Push with auto-generated bookmark name
jj git push -c @-
```

### Addressing PR feedback (add commits)

```sh
# Start new commit on the bookmark
jj new feat/my-feature
# ... make changes ...
jj commit -m "address review feedback"

# Move bookmark to include new commit
jj bookmark move feat/my-feature --to @-
jj git push --bookmark feat/my-feature
```

### Addressing PR feedback (rewrite commits)

```sh
# Edit a commit in the stack (e.g., parent of bookmark)
jj new feat/my-feature-  # note the trailing hyphen = parent
# ... make changes ...
jj squash  # squash into parent

# Push (force push happens automatically)
jj git push --bookmark feat/my-feature
```

## Bookmark conflicts

If local and remote bookmarks diverge, you'll see `main??` in the log.

```sh
# Resolve by fetching and rebasing
jj git fetch
jj rebase -d main@origin

# Or force move the bookmark
jj bookmark move main --to <revision>
```

## Useful revsets for bookmarks

```sh
# All local bookmarks not on any remote
jj log -r 'bookmarks() & ~remote_bookmarks()'

# Your commits on bookmarks not pushed
jj log -r 'mine() & bookmarks() & ~remote_bookmarks()'

# Ancestors of current commit not on remote
jj log -r 'remote_bookmarks()..@'
```
