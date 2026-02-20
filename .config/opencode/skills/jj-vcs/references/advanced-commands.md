# Advanced Commands

Power-user commands for stack-based workflows, history investigation, and debugging.

## jj absorb

Automatically distribute working copy changes into the appropriate commits in your stack.

`jj absorb` analyzes each changed line in your working copy and moves it to the commit in your mutable history where that line was last modified. This is extremely useful for fixing up a stack of commits without manual squashing.

```sh
# Absorb all working copy changes into the stack
jj absorb

# Absorb only changes to specific files
jj absorb <paths>

# Absorb from a specific revision (default: @)
jj absorb -f <revision>

# Absorb into a limited set of destinations (default: mutable())
jj absorb -t 'trunk()..@'
```

### How it works

1. For each changed line in the source revision, jj finds where that line was last modified in the ancestor commits
2. If the destination is unambiguous (only one commit modified that line), the change moves there
3. If ambiguous (multiple commits touched the line), the change stays in the source
4. Descendants are automatically rebased
5. If all changes are absorbed and the source has no description, it's abandoned

### Example workflow

```sh
# You have a stack: A -> B -> C -> @ (working copy)
# You notice bugs in commits A and B while working

# Make fixes in your working copy
# ... edit files ...

# Absorb distributes each fix to the right commit
jj absorb

# Review what happened
jj op show -p
```

### Limitations

- Only works with line-based changes (not structural refactors)
- Cannot absorb if multiple ancestors modified the same line
- Remaining unabsorbed changes stay in the source commit

## jj revert

Create a new commit that cancels out the changes from another revision.

```sh
# Revert a revision, inserting the revert commit before @
jj revert -r <revision> -B @

# Revert onto a specific destination
jj revert -r <revision> -o <destination>

# Revert and insert after a commit
jj revert -r <revision> -A <after>

# Revert multiple revisions
jj revert -r 'X | Y | Z' -B @
```

The revert commit will have the inverse diff of the specified revision. The description can be customized via `templates.revert_description`.

## jj duplicate

Create copies of commits at a new location (like `git cherry-pick`).

```sh
# Duplicate a commit onto a destination
jj duplicate <revision> -d <destination>

# Duplicate onto current working copy parent
jj duplicate <revision> -d @-

# Insert after a specific commit
jj duplicate <revision> -A <after>

# Insert before a specific commit (rebases descendants)
jj duplicate <revision> -B <before>

# Duplicate multiple commits (preserves internal structure)
jj duplicate 'A | B | C' -d main
```

### Key differences from git cherry-pick

- Creates a new change ID (it's a copy, not the same change)
- Can duplicate multiple commits at once, preserving their relationships
- Doesn't modify the working copy commit by default

### Example: Backport a fix

```sh
# Duplicate a fix from main onto a release branch
jj duplicate <fix-change-id> -d release-1.0
jj bookmark move release-1.0 --to <new-change-id>
```

## jj file annotate

Show the origin of each line in a file (like `git blame`).

```sh
# Annotate a file at the working copy
jj file annotate <path>

# Annotate at a specific revision
jj file annotate -r <revision> <path>

# Custom output template
jj file annotate -T '<template>' <path>
```

## jj next / jj prev

Navigate through your commit stack by moving the working copy.

### jj next

Move the working copy to a child commit.

```sh
# Move to child (creates new empty commit on top of child)
jj next

# Move N commits forward
jj next 2

# Edit the child directly instead of creating new commit
jj next -e
jj next --edit

# Jump to next conflicted descendant
jj next --conflict
```

### jj prev

Move the working copy to a parent commit.

```sh
# Move to parent (creates new empty commit on top of parent)
jj prev

# Move N commits backward
jj prev 2

# Edit the parent directly instead of creating new commit
jj prev -e
jj prev --edit

# Jump to previous conflicted ancestor
jj prev --conflict
```

### Behavior modes

By default, `jj next` and `jj prev` create a new empty working copy commit at the destination (like `jj new`). With `--edit`, they switch to directly editing the destination commit (like `jj edit`).

Configure the default with `ui.movement.edit = true` in your config.

### Example: Review a stack

```sh
# Start at the top of a stack
jj log -r '@::'

# Move down through the stack, reviewing each commit
jj prev -e    # Now editing parent
jj diff       # See what this commit changed
jj prev -e    # Move to grandparent
# ...

# Return to top
jj next -e 3
```

## jj interdiff

Compare the changes between two commits (useful for reviewing how a commit evolved).

```sh
# Compare changes from commit A to commit B
jj interdiff --from <A> --to <B>

# Show summary only
jj interdiff --from <A> --to <B> -s

# Restrict to specific paths
jj interdiff --from <A> --to <B> <paths>
```

This is different from `jj diff --from A --to B` which shows the difference in content. `jj interdiff` shows how the *changes introduced* by A compare to the *changes introduced* by B.

For comparing how a single change evolved over time, use `jj evolog -p` instead.

## jj bisect

Find a bad revision using binary search.

```sh
# Run a command to find the first bad revision in a range
jj bisect run --range 'v1.0..main' -- <command>

# Example: Find which commit broke the tests
jj bisect run --range 'v1.0..main' -- cargo test

# Find the first good revision instead (inverted search)
jj bisect run --range 'v1.0..main' --find-good -- <command>
```

### Exit codes

The command's exit status determines how jj marks each revision:

| Exit Code | Meaning |
|-----------|---------|
| 0 | Good (no bug) |
| 125 | Skip this revision |
| 127 | Abort bisection (command not found) |
| Any other | Bad (has bug) |

### Example: Interactive bisection

```sh
# Use a shell for manual testing
jj bisect run --range 'v1.0..main' -- bash -c '
  # Run your manual test here
  cargo build && ./test-manually.sh
'

# Or use an interactive shell and exit with appropriate code
jj bisect run --range 'v1.0..main' -- bash
# In the shell: test manually, then `exit 0` (good) or `exit 1` (bad)
```

## jj parallelize

Make sequential commits into siblings (parallel branches).

```sh
# Make commits A, B, C into siblings instead of a chain
jj parallelize A::C
```

Before:
```
C
|
B
|
A
|
base
```

After:
```
  C
 /|\
A B |
 \|/
 base
```

This is useful when you realize commits are actually independent and don't need to be sequential.

## jj simplify-parents

Remove redundant parent edges from merge commits.

```sh
# Simplify the current commit
jj simplify-parents

# Simplify specific revisions
jj simplify-parents -r <revisions>

# Simplify a revision and all its descendants
jj simplify-parents -s <source>
```

This removes parent edges that are redundant (where one parent is an ancestor of another parent).
