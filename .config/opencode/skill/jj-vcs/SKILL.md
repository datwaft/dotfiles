---
name: jj-vcs
description: Use jj (Jujutsu) version control system. Load this skill when the user wants to perform version control operations and the repository uses jj (check for .jj directory), or when the user explicitly mentions jj/jujutsu.
license: MIT
---

# jj (Jujutsu) Version Control

jj is a Git-compatible VCS with a different mental model. Most LLMs are trained primarily on git, so this skill provides the correct jj approach.

## Critical differences from git

1. **Working copy is always a commit** - Every file change automatically amends the current working copy commit. There is no staging area, no `git add`.

2. **Change ID vs Commit ID** - Every commit has two identifiers:
   - **Change ID** (e.g., `kntqzsqt`): Stable across rewrites, use this in commands
   - **Commit ID** (e.g., `d7439b06`): Changes when commit is modified (like git's SHA)

3. **No staging area** - Files are automatically tracked. Use `.gitignore` (jj uses git's ignore format) and `jj file untrack <path>` to untrack.

4. **Commits are mutable** - You can freely rewrite any commit. Rewriting pushed commits requires force push (`jj git push` handles this automatically with lease protection). Conflicts don't block operations - they're stored in the commit.

5. **Bookmarks, not branches** - jj uses "bookmarks" instead of git branches. They map 1:1 to git branches when pushing/fetching.

6. **Colocated repos** - When `.jj` and `.git` coexist, every jj command auto-syncs with git. Git stays in detached HEAD state. Tools like `gh` CLI work normally.

## Core workflow

```sh
# See current state
jj status  # or jj st
jj log     # view commit graph
jj diff    # see working copy changes

# Describe current commit (set message)
jj describe -m "commit message"

# Create new commit on top of current (signals "I'm done editing this commit")
jj new
jj new -m "message for the new commit"

# Squash working copy changes into parent
jj squash

# Squash into a specific ancestor (not just parent)
jj squash --into <change-id>

# Edit an existing commit (makes it the working copy)
jj edit <change-id>

# Auto-distribute working copy changes into the right commits in a stack
jj absorb
```

### Stack workflow with jj absorb

When working on a stack of commits, `jj absorb` automatically moves each change to the commit where that line was last modified:

```sh
# You have a stack and notice bugs in earlier commits
# Make fixes in working copy, then:
jj absorb

# Each fix is moved to the appropriate commit in the stack
# Review what happened:
jj op show -p
```

## Revsets (selecting commits)

Revsets are expressions for selecting commits. Use change IDs, not commit IDs.

| Revset | Meaning |
|--------|---------|
| `@` | Working copy commit |
| `@-` | Parent of working copy |
| `@--` | Grandparent |
| `root()` | Root commit |
| `bookmarks()` | All bookmarked commits |
| `trunk()` | Main branch (usually `main@origin`) |
| `::foo` | Ancestors of foo (inclusive) |
| `foo::` | Descendants of foo (inclusive) |
| `foo::bar` | DAG range (ancestry path) |
| `foo..bar` | Range (like git's) |
| `foo-` | Parents of foo |
| `foo+` | Children of foo |
| `foo \| bar` | Union |
| `foo & bar` | Intersection |
| `~foo` | Complement (not foo) |

## Rebase

**Use the direct flags, not longwinded approaches:**

```sh
# Rebase single commit to new destination
jj rebase -r '<revision>' -d '<destination>'

# Rebase commit and all descendants
jj rebase -s '<source>' -d '<destination>'

# Rebase entire branch (all commits reachable from <branch> but not from <destination>)
jj rebase -b '<branch>' -d '<destination>'
```

Examples:
```sh
# Move current commit onto main
jj rebase -r @ -d main

# Move a feature branch onto latest trunk
jj rebase -s feature-start -d trunk()
```

## Filesets (selecting files)

Filesets are expressions for selecting files. **Quote file names containing special characters** like `()`, `[]`, `~`, `&`, `|`, or whitespace.

| Pattern | Meaning |
|---------|---------|
| `"path"` | Prefix match (file or directory, default) |
| `file:"path"` | Exact file path only |
| `glob:"*.rs"` | Glob pattern (cwd-relative) |
| `root:"path"` | Workspace-relative prefix |
| `root-glob:"**/*.rs"` | Workspace-relative glob |

Operators:
- `~x` - Everything except x
- `x & y` - Both x and y
- `x | y` - Either x or y
- `x ~ y` - x but not y

Examples:
```sh
# Diff excluding a file
jj diff '~Cargo.lock'

# Files with special characters MUST be quoted
jj diff '"src/foo[1].txt"'
jj diff '"path with spaces/file.rs"'

# Glob patterns
jj diff 'glob:"**/*.test.ts"'

# Split excluding certain files
jj split '~glob:"**/*.generated.*"'
```

## Bookmarks and pushing

Bookmarks are named pointers to commits (like git branches). They auto-move when commits are rewritten, but **do not** auto-move to new commits after `jj new`/`jj commit` (unlike git branches).

### Understanding @ vs @- for bookmarks

After `jj new` or `jj commit`, your working copy (`@`) becomes an empty commit sitting on top of your actual changes (`@-`). When creating bookmarks for PRs:

- **Create bookmarks on `@-`** (the commit with your changes): `jj bookmark create feat/foo -r @-`
- **Not on `@`** (the empty working copy)

If you accidentally create a bookmark on `@` or try to push `@` directly, you'll get errors like "No commits between main and @" because the working copy is empty.

```sh
# Create bookmark (typically on @- after jj commit leaves you on empty commit)
jj bookmark create feat/foo -r @-

# List bookmarks
jj bookmark list        # or jj b l

# Move bookmark to different commit
jj bookmark move feat/foo --to <revision>

# Delete bookmark
jj bookmark delete feat/foo

# Push specific bookmark (safest for automation)
jj git push --bookmark feat/foo

# Push and auto-create bookmark from change ID
jj git push -c @-
```

Shorthand: `jj b` = `jj bookmark`, subcommands have single-letter shortcuts (`jj b c` = `jj bookmark create`).

Note: `jj git push --all` pushes all **bookmarks**, not all commits. Use `jj git push -c <change>` to auto-create and push a bookmark.

## Fetching and updating (no git pull)

There is no `jj git pull`. Instead, fetch and rebase separately:

```sh
# Fetch latest from remote
jj git fetch

# Update your work onto latest main (local bookmark syncs with remote on fetch)
jj rebase -d main

# Or rebase a specific branch
jj rebase -b my-feature -d main

# If starting fresh with no local changes, just create new commit on main
jj new main
```

## Undo and operation log

jj tracks all operations and allows easy undo:

```sh
jj undo              # Undo last operation
jj op log            # View operation history
jj op restore <op>   # Restore to specific operation
```

## Important flags for non-interactive use

Always use message flags instead of opening editors:
- `jj describe -m "message"` (not `jj describe` which opens editor)
- `jj new -m "message"`
- `jj commit -m "message"`

Avoid `-i` (interactive) flags:
- Do NOT use `jj squash -i` (interactive selection)
- Do NOT use `jj split -i`

## References

For detailed information on specific operations, see the reference files in `references/`:
- [cli-options.md](references/cli-options.md) - Understanding `-r`, `-s`, `-d`, `-A`, `-B`, `--from`, `--to` flag patterns
- [bookmarks.md](references/bookmarks.md) - Bookmarks, remote operations, GitHub/GitLab workflows
- [multiple-remotes.md](references/multiple-remotes.md) - Fork workflows, upstream integration, tracking configuration
- [troubleshooting.md](references/troubleshooting.md) - Debugging with `jj evolog`, divergent changes, conflicted bookmarks, recovery patterns
- [git-mapping.md](references/git-mapping.md) - Git to jj command mapping table
- [advanced-commands.md](references/advanced-commands.md) - Power commands: absorb, revert, duplicate, bisect, next/prev
- [revsets.md](references/revsets.md) - Complete revsets reference with all operators, functions, and patterns
