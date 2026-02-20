# Workflows and Patterns

## Two Main Workflows: Squash vs Edit

jj supports two primary mental models for daily work. Choose based on your preference.

### The Squash Workflow (index-like)

Use the working copy as a "staging area" and squash changes into the real commit.

```sh
# 1. Describe what you want to do
jj describe -m "add feature X"

# 2. Create empty child commit as workspace
jj new

# 3. Work in the child (@ is now empty scratch space)
# ... edit files ...

# 4. Squash changes into the described commit
jj squash

# Repeat: make more changes, squash again
# When done, jj new to start next feature
```

**Key insight**: Like `git add -p && git commit --amend`, but on commits. `jj squash -i` opens a TUI for partial squashes.

**Advantages**:
- Review changes before committing them
- Easy to discard unwanted changes (`jj abandon`)
- Familiar if you liked git's index

### The Edit Workflow (direct editing)

Work directly in commits, inserting new ones when needed.

```sh
# 1. Start work (either jj new or jj describe on empty @)
jj new -m "add feature X"

# 2. Work directly in this commit
# ... edit files ...

# 3. If you realize you need a prior commit, insert one before
jj new -B @ -m "refactor needed for feature X"
# Descendants are auto-rebased

# 4. Make the refactor, then return to your feature
jj next --edit

# 5. When done, jj new to start next feature
```

**Key insight**: Use `jj new -B @` to insert commits into history. Children are automatically rebased.

**Advantages**:
- Simpler mental model (always editing a real commit)
- Great for realizing you need to split work mid-stream
- Natural for stack-based development

## Inserting Commits with `jj new -B`

Create a commit *before* the current one, automatically rebasing descendants.

```sh
# Insert empty commit before @ (current becomes child of new commit)
jj new -B @ -m "insert this before current"

# Insert before a specific revision
jj new -B <revision> -m "insert before this"

# This ALWAYS succeeds - conflicts are recorded, not blocking
```

Before:
```
A -> B -> @ (current)
```

After `jj new -B @ -m "new"`:
```
A -> B -> new -> @ (rebased)
            ^-- you are here
```

## Anonymous Branches

You don't need to name branches. jj tracks commits by change ID, and descriptions serve as identification.

### Creating branches without names

```sh
# Start two features from the same point
jj new main -m "feature A"
# ... work ...
jj new main -m "feature B"  # Creates sibling, not child
```

### Finding all branch heads

```sh
# Show heads of all anonymous branches
jj log -r 'heads(all())'

# Show heads excluding remote branches
jj log -r 'heads(mine())'
```

### When to use bookmarks

- When pushing to remotes (GitHub requires branch names)
- When you want a stable reference across sessions
- When collaborating with others on the same branch

## Multi-Parent Merges

Create merge commits by passing multiple parents to `jj new`.

```sh
# Merge two branches
jj new branchA branchB -m "merge A and B"

# Merge three or more
jj new A B C D -m "merge all features"

# Merge by change ID
jj new abc xyz -m "merge two changes"
```

`jj merge` is deprecated - use `jj new` with multiple parents instead.

## Working on Multiple Branches Simultaneously

A powerful pattern: create a merge commit from all your active branches to work on everything at once.

### Setup

```sh
# Assuming you have several branches off trunk
jj log
# Shows: branch1, branch2, branch3 all from trunk

# Create a merge of all branch heads
jj new branch1 branch2 branch3 -m "merge: my active work"

# Create workspace on top
jj new
```

### Workflow

```sh
# Work in @ - you can see/edit code from all branches
# ... make changes ...

# Squash fixes into the appropriate branch
jj squash --into branch1  # If change belongs to branch1

# Or use jj absorb to auto-distribute
jj absorb  # Moves each line to the commit that last touched it
```

### Rebasing all branches at once

When upstream changes:

```sh
jj git fetch

# Rebase ALL your branches onto updated trunk
jj rebase -s 'all:roots(trunk..@)' -d trunk

# Explanation:
# - trunk..@ : all commits between trunk and working copy
# - roots()  : just the root commits (your branch bases)
# - all:     : allow multiple revisions (required for multi-parent rebase)
```

## Automatic Rebasing Behavior

jj automatically rebases descendants when you modify a commit. This is safe because:

1. **Conflicts are stored, not blocking** - Rebase always succeeds
2. **Conflict resolution propagates** - Fix parent, children auto-update
3. **Change IDs are stable** - Even after rebase, same change ID

### Example: Edit in the middle of a stack

```sh
# Stack: A -> B -> C -> D (@ at D)
jj edit B

# Make changes to B
# ... edit files ...

# C and D are automatically rebased
jj log  # Shows all updated
```

If the edit creates conflicts in C or D, they're marked as conflicted but the operation succeeds. Fix at your leisure.

## PR Update Strategies

When responding to PR feedback, choose based on project preferences:

### Strategy 1: Add commits (history visible)

```sh
# Make fix
jj new -m "address review feedback"
# ... fix ...

# Update bookmark and push
jj bookmark set my-pr
jj git push --bookmark my-pr
```

### Strategy 2: Rewrite commits (clean history)

```sh
# Edit the commit that needs fixing
jj edit <commit-to-fix>
# ... make changes ...

# Descendants auto-rebase
# Update bookmark if needed
jj bookmark set my-pr --to <head-of-pr>
jj git push --bookmark my-pr
```

### Key difference from git

Bookmarks don't auto-move with `jj new`. Update them explicitly before pushing:

```sh
# Check where bookmark is
jj bookmark list

# Move to current position
jj bookmark set my-pr

# Or move to specific commit
jj bookmark set my-pr --to @-
```

## Navigation Commands

Move through your commit stack efficiently:

```sh
# Move to child commit
jj next           # Creates new empty commit on child
jj next --edit    # Edits child directly

# Move to parent commit
jj prev           # Creates new empty commit on parent  
jj prev --edit    # Edits parent directly

# Jump multiple levels
jj next 3
jj prev 2

# Jump to next/prev conflict
jj next --conflict
jj prev --conflict
```

Configure default behavior:
```toml
# In ~/.jjconfig.toml
[ui.movement]
edit = true  # Makes --edit the default
```
