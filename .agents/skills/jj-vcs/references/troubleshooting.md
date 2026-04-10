# Troubleshooting and Recovery

## Conflict resolution

Conflicts in jj are stored in commits (they don't block operations). Conflicted files have markers in the working copy.

### Understanding conflict markers

jj uses a unique conflict marker format. Example:

```
<<<<<<< conflict 1 of 1
%%%%%%% diff from base to side #1
-grape
+grapefruit
+++++++ side #2
APPLE
GRAPE
ORANGE
>>>>>>> conflict 1 of 1 ends
```

Marker meanings:
- `<<<<<<<` / `>>>>>>>` - Start/end of conflict
- `+++++++` - **Snapshot**: one side's full content
- `%%%%%%%` - **Diff**: changes to apply to the snapshot

**To resolve**: Apply the diff to the snapshot. In the example above, change "GRAPE" to "GRAPEFRUIT" in the uppercase version:

```
APPLE
GRAPEFRUIT
ORANGE
```

For multi-sided conflicts (3+ sides), you'll see multiple diff sections - apply each one to the snapshot.

### Resolving conflicts

**Recommended approach** (easier to inspect changes):

```sh
# Create a new commit on top of the conflicted commit
jj new <conflicted-commit>

# Edit the conflicted files, removing conflict markers
# Then inspect your resolution
jj diff

# Squash the resolution into the conflicted commit
jj squash
```

**Alternative** (direct edit):

```sh
# Edit the conflicted commit directly
jj edit <conflicted-commit>

# Edit files to resolve conflicts
# Harder to see what you changed
```

### Choosing one side of the conflict

```sh
# Restore a file from a specific commit (e.g., take "their" version)
jj restore --from <commit> <file>
```

## Commit not visible in `jj log`

By default, `jj log` only shows local commits and their immediate parents. Remote commits are often hidden.

```sh
# See ALL commits in the repo
jj log -r 'all()'
# or equivalently
jj log -r ..

# Check if a specific commit exists (even if hidden/abandoned)
jj log -r <commit-id>
```

If a commit was abandoned (via `jj abandon`, rebase, etc.), it will show as "hidden" but is still accessible by commit ID.

## Viewing change history with `jj evolog`

Every jj command snapshots the working copy. `jj evolog` shows how a change evolved over time:

```sh
# Show evolution of current working copy
jj evolog

# Show evolution with diffs
jj evolog -p

# Show evolution of a specific change
jj evolog -r <change-id>
```

This is useful for:
- Finding the "last good version" of a commit before unwanted changes
- Understanding how a change was modified over time
- Recovery after accidental edits

Hidden commits in evolog can be referenced by their commit ID (not change ID).

## Divergent changes

A **divergent change** occurs when multiple visible commits share the same change ID. Divergent commits display with a **change offset** (e.g., `mzvwutvl/0`, `mzvwutvl/1`) and a "divergent" label in `jj log`.

### How divergence happens

- **Hidden commit becomes visible again**: Adding a descendant, fetching descendants from remote, or running `jj edit` on a hidden commit
- **Concurrent modifications**: Two users/processes amend the same change, creating two successors
- **IDE integration conflicts**: Running `jj describe` while an IDE fetches and rebases in the background

### Signs of divergence

- `jj log` shows commits with `/0`, `/1` suffixes and "(divergent)" label
- Commands using the change ID fail with "ambiguous" error
- Must use commit ID or change ID with offset (`xyz/0`) to reference

### Resolution strategies

**Strategy 1: Abandon unwanted commits** (simplest)
```sh
# Use commit ID or change ID with offset
jj abandon <unwanted-commit-id>

# Abandon multiple at once
jj abandon abc def 123
```

**Strategy 2: Generate new change ID** (keep both as separate changes)
```sh
jj metaedit --update-change-id <commit-id>
```

**Strategy 3: Squash together** (merge the content)
```sh
jj squash --from <source-commit-id> --into <target-commit-id>
```

**Strategy 4: Ignore it** - Divergence isn't an error. If both commits are immutable or the divergence doesn't cause problems, you can leave it. The inconvenience is that you can't reference by change ID alone.

## Conflicted bookmarks (`??` suffix)

A bookmark shows `??` (e.g., `main??`) when it points to multiple commits due to concurrent updates.

```sh
# See all targets of a conflicted bookmark
jj bookmark list

# Resolve by moving to the desired commit
jj bookmark move <name> --to <commit-id>

# Or fetch to resolve if it's a remote conflict
jj git fetch
```

## Accidentally changed the wrong commit

If you edited files but they went into the wrong commit:

### Option 1: Use `jj evolog` to find previous state

```sh
# Find the commit ID of the "good" version
jj evolog -p

# Create new commit from the good version
jj new <good-commit-id> -m "new work"

# Restore current (wrong) content into new commit
jj restore --from <wrong-commit-id>

# Abandon the wrong version
jj abandon <wrong-commit-id>
```

### Option 2: Use `jj undo` if it just happened

```sh
jj undo
```

### Option 3: Move changes between commits

```sh
# Squash working copy into a specific commit (not parent)
jj squash --into <target-commit>

# Or use jj new + jj squash for more control
jj new <correct-parent>
# ... make changes ...
jj squash
```

## Resuming work on an existing change

Two approaches:

### Recommended: `jj new` then `jj squash`

```sh
# Create child commit to work in
jj new <change-id>

# Make your edits, then squash back
jj squash
```

This preserves history of what you changed.

### Alternative: `jj edit`

```sh
# Directly edit the commit (changes amend it)
jj edit <change-id>

# When done, create new commit to stop editing
jj new
```

Simpler but less traceable. Avoid if the commit has conflicts.

## Recovering abandoned commits

Abandoned commits are hidden but not deleted. They can be restored:

```sh
# Find the abandoned commit in operation log
jj op log

# Restore to before the abandon
jj op restore <operation-id>

# Or just reference the commit directly if you know its ID
jj new <abandoned-commit-id>
```

## Operation log recovery

The operation log tracks every repo modification. Use it to recover from mistakes.

```sh
# View operation history
jj op log

# Undo the most recent operation
jj undo

# Revert a specific operation (not necessarily the most recent)
jj op revert <operation-id>

# Restore entire repo to a previous state
jj op restore <operation-id>
```

Operation references:
- `@` - Current operation
- `@-` - Previous operation (parent)
- `@--` - Two operations ago

Example: Undo the last two operations:
```sh
jj op restore @--
```

## Merge commits appear "(empty)"

This is normal. jj defines changes relative to auto-merged parents, so clean merges have no diff. Only conflict resolutions or additional changes make a merge non-empty.

To revert a merge (undo the merge of second parent):

```sh
jj new <merge-commit>
jj restore --from <first-parent>
jj describe -m "Revert merge of <second-parent>"
```
