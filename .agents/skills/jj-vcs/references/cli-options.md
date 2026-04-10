# CLI Options for Specifying Revisions

jj uses consistent CLI option patterns across commands. Understanding these patterns helps predict how any command works.

## Source Options (what to operate on)

| Flag | Short | Meaning |
|------|-------|---------|
| `--revision` | `-r` | Exact revision(s) specified |
| `--source` | `-s` | Revision AND all its descendants (like `-r REV::`) |
| `--from` | `-f` | The *contents* of a revision (for diffs/moves) |
| `--branch` | `-b` | Whole branch relative to destination |

### When to use each

**`-r` (revision)**: Most common. Operates on exactly what you specify.
```sh
jj log -r @::         # Show these exact commits
jj split -r xyz       # Split this one commit
jj abandon -r 'empty()'  # Abandon these commits
```

**`-s` (source)**: When the operation must include descendants. The command enforces this because leaving descendants behind would be problematic.
```sh
jj rebase -s xyz -d main   # Rebase xyz AND all descendants
jj fix -s xyz              # Fix xyz AND all descendants
```

**`--from` / `--to`**: For operations on *contents*, not revisions themselves.
```sh
jj diff --from A --to B    # Compare contents of A vs B
jj restore --from A --to B # Copy file contents from A to B
jj squash --from A --into B  # Move changes from A into B
```

**`-b` (branch)**: Convenience for rebasing a topological branch. Rebases all commits reachable from the revision but not from the destination.
```sh
jj rebase -b @ -d main     # Rebase current branch onto main
# Equivalent to: jj rebase -s roots(main..@) -d main
```

## Destination Options (where to put things)

Used when commands need both source and destination.

| Flag | Short | Meaning |
|------|-------|---------|
| `--onto` | `-o` | Create as children of destination |
| `--insert-after` | `-A` | Insert between revision and its children |
| `--insert-before` | `-B` | Insert between revision and its parents |
| `--to` / `--into` | `-t` | Where to place contents |

### Destination behaviors

**`-d` / `--onto` (`-o`)**: Place as children of destination.
```sh
jj rebase -r xyz -d main   # xyz becomes child of main
jj duplicate abc -d main   # Copy abc as child of main
```

**`-A` (insert-after)**: Insert between a revision and its children. The revision's current children become children of the inserted commit.
```sh
jj rebase -r xyz -A main   # xyz inserted after main, before main's children
```

**`-B` (insert-before)**: Insert between a revision and its parents. The revision becomes a child of the inserted commit.
```sh
jj rebase -r xyz -B feature  # xyz inserted before feature
jj revert -r bad -B @        # Create revert commit as parent of @
```

### Visual example

Given: `A -> B -> C`

```sh
# -d / --onto: D becomes child of B
jj rebase -r D -d B
# Result: A -> B -> C
#              \-> D

# -A (insert-after): D inserted after B, C becomes child of D
jj rebase -r D -A B  
# Result: A -> B -> D -> C

# -B (insert-before): D inserted before C, D becomes parent of C
jj rebase -r D -B C
# Result: A -> B -> D -> C
```

## `-r` vs `--from` Distinction

This is the key semantic difference:

- **`-r`**: Operates on the revision as a unit (rebase it, abandon it, split it)
- **`--from`**: Operates on the *contents/changes* in the revision

```sh
# -r: "show me what this revision changed"
jj diff -r xyz           # Diff of xyz compared to its parent

# --from/--to: "compare contents between two revisions"
jj diff --from A --to B  # Diff between A and B (not relative to parents)
```

For `jj diff`, `-r xyz` is shorthand for `--from xyz- --to xyz`.

## Commands That Allow Omitting `-r`

These commands are so common that the `-r` flag is optional - you can pass revisions as positional arguments:

- `jj abandon xyz` (same as `jj abandon -r xyz`)
- `jj describe xyz` (same as `jj describe -r xyz`)
- `jj duplicate xyz` (same as `jj duplicate -r xyz`)
- `jj metaedit xyz`
- `jj new xyz` (same as `jj new -r xyz`)
- `jj parallelize A::C`
- `jj show xyz` (same as `jj show -r xyz`)

Most other commands require `-r` because they also accept paths as positional arguments:
```sh
jj diff -r xyz src/      # Diff of revision xyz, limited to src/
jj split -r xyz src/     # Split xyz, only moving src/ to new commit
```

## Special Cases

### `jj rebase -b` (branch)

The `-b` flag is a convenience for rebasing a "topological branch" - all commits between the destination and the specified revision.

```sh
jj rebase -b @ -d main
# Equivalent to:
jj rebase -s roots(main..@) -d main
# Also equivalent to:
jj rebase -r '(main..@)::' -d main
```

This is so common that `-b @` is the default source for rebase:
```sh
jj rebase -d main        # Implicitly uses -b @
```

### `jj git push -c` (change)

Creates a bookmark with auto-generated name and pushes immediately:
```sh
jj git push -c @-        # Create bookmark for parent, push it
```

### `jj restore -c` (changes-in)

Removes changes from a revision (opposite of what `-r` might imply):
```sh
jj restore -c xyz file   # Remove changes to file in xyz
# This is NOT "restore from xyz" - it undoes xyz's changes to file
```

## Pattern Summary

| Operation Type | Source Flag | Destination Flag |
|---------------|-------------|------------------|
| Move/rebase revisions | `-r`, `-s`, `-b` | `-d`, `-A`, `-B` |
| Move contents/changes | `--from` | `--to`, `--into` |
| View/operate on revision | `-r` | N/A |
| View/compare contents | `--from`, `--to` | N/A |
