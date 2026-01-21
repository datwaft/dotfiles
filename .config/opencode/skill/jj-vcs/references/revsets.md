# Revsets Reference

Complete reference for jj's revset language - a functional language for selecting commits.

## Symbols

| Symbol | Meaning |
|--------|---------|
| `@` | Working copy commit (current workspace) |
| `<workspace>@` | Working copy in another workspace |
| `<name>@<remote>` | Remote-tracking bookmark (e.g., `main@origin`) |
| `<change-id>` | Commit by change ID (stable across rewrites) |
| `<commit-id>` | Commit by commit ID (SHA prefix) |
| `<bookmark>` | Bookmark name |
| `<tag>` | Tag name |

### Symbol priority

When a name could match multiple things, jj resolves in this order:
1. Tag name
2. Bookmark name
3. Git ref
4. Commit ID or change ID

To force a specific interpretation:
```sh
jj log -r 'commit_id(abc)'    # Force as commit ID
jj log -r 'change_id(abc)'    # Force as change ID
jj log -r 'bookmarks(main)'   # Force as bookmark
jj log -r 'tags(v1.0)'        # Force as tag
```

### Quoting symbols

Use quotes for symbols containing special characters:
```sh
jj log -r '"x-"'        # Symbol "x-", not parents of x
jj log -r '"my-branch"' # Bookmark with hyphen
```

## Operators

Listed in order of binding strength (strongest first).

### Parent/Child operators

| Operator | Meaning | Example |
|----------|---------|---------|
| `x-` | Parents of x | `@-` (parent of working copy) |
| `x+` | Children of x | `main+` (children of main) |
| `x--` | Grandparents | `@--` |
| `x++` | Grandchildren | `main++` |

### Ancestor/Descendant operators

| Operator | Meaning | Notes |
|----------|---------|-------|
| `::x` | Ancestors of x (inclusive) | Includes x itself |
| `x::` | Descendants of x (inclusive) | Includes x itself |
| `x::y` | Descendants of x that are ancestors of y | Ancestry path (like `git log --ancestry-path x..y`) |
| `..x` | Ancestors of x, excluding root | Same as `::x ~ root()` |
| `x..` | Non-ancestors of x | Same as `~::x` |
| `x..y` | Ancestors of y, not ancestors of x | Like Git's `x..y` |
| `::` | All visible commits | Same as `all()` |
| `..` | All visible commits except root | Same as `~root()` |

### Set operators

| Operator | Meaning | Example |
|----------|---------|---------|
| `~x` | Complement (not in x) | `~main` (not ancestors of main) |
| `x & y` | Intersection | `mine() & bookmarks()` |
| `x \| y` | Union | `main \| develop` |
| `x ~ y` | Difference (x but not y) | `@:: ~ main::` |

### Operator examples

Given this history:
```
o D
|\
| o C
| |
o | B
|/
o A
|
o root()
```

**Parents/Children:**
- `D-` → `{C, B}` (D has two parents)
- `A+` → `{B, C}` (A has two children)
- `D--` → `{A}` (grandparents)

**Ancestors/Descendants:**
- `::D` → `{D, C, B, A, root()}`
- `B::` → `{D, B}`
- `B::D` → `{D, B}` (ancestry path, excludes C)
- `B..D` → `{D, C}` (range, includes C, excludes B)

**Set operations:**
- `(C | B)-` → `{A}` (parents of either C or B)
- `::D ~ ::B` → `{D, C}` (ancestors of D not in ancestors of B)

## Functions

### Revision selection

| Function | Description |
|----------|-------------|
| `all()` | All visible commits |
| `none()` | Empty set |
| `root()` | Virtual root commit (ancestor of all) |
| `visible_heads()` | All visible head commits |
| `working_copies()` | Working copy commits across all workspaces |

### Ancestors and descendants

| Function | Description |
|----------|-------------|
| `parents(x)` | Same as `x-` |
| `parents(x, depth)` | Parents at given depth (e.g., `parents(x, 3)` = `x---`) |
| `children(x)` | Same as `x+` |
| `children(x, depth)` | Children at given depth |
| `ancestors(x)` | Same as `::x` |
| `ancestors(x, depth)` | Ancestors limited to depth |
| `descendants(x)` | Same as `x::` |
| `descendants(x, depth)` | Descendants limited to depth |
| `first_parent(x)` | First parent only (for merges) |
| `first_ancestors(x)` | Ancestors via first-parent only |

### Graph operations

| Function | Description |
|----------|-------------|
| `heads(x)` | Commits in x not ancestors of others in x |
| `roots(x)` | Commits in x not descendants of others in x |
| `connected(x)` | Same as `x::x` (connects disconnected parts) |
| `reachable(srcs, domain)` | All commits reachable from srcs within domain |
| `fork_point(x)` | Common ancestor(s) of all commits in x |
| `latest(x, [count])` | Latest count commits by committer date (default: 1) |
| `bisect(x)` | Commits where ~half of x are descendants (for binary search) |

### Bookmarks and tags

| Function | Description |
|----------|-------------|
| `bookmarks([pattern])` | Local bookmark targets |
| `remote_bookmarks([pattern], [remote=pattern])` | Remote bookmark targets |
| `tracked_remote_bookmarks([pattern], [remote=pattern])` | Tracked remote bookmarks |
| `untracked_remote_bookmarks([pattern], [remote=pattern])` | Untracked remote bookmarks |
| `tags([pattern])` | Tag targets |

Examples:
```sh
jj log -r 'bookmarks()'                    # All local bookmarks
jj log -r 'bookmarks(feat/*)'              # Bookmarks matching glob
jj log -r 'remote_bookmarks(main, origin)' # main@origin
jj log -r 'remote_bookmarks(remote=origin)'# All bookmarks on origin
jj log -r 'tags(v1.*)'                     # Tags matching v1.*
```

### ID functions

| Function | Description |
|----------|-------------|
| `commit_id(prefix)` | Commit with given commit ID prefix |
| `change_id(prefix)` | Commit(s) with given change ID prefix |

### Commit properties

| Function | Description |
|----------|-------------|
| `description(pattern)` | Commits with description matching pattern |
| `subject(pattern)` | Commits with subject (first line) matching pattern |
| `author(pattern)` | Author name or email matches |
| `author_name(pattern)` | Author name matches |
| `author_email(pattern)` | Author email matches |
| `author_date(pattern)` | Author date matches |
| `committer(pattern)` | Committer name or email matches |
| `committer_name(pattern)` | Committer name matches |
| `committer_email(pattern)` | Committer email matches |
| `committer_date(pattern)` | Committer date matches |
| `mine()` | Commits authored by current user |
| `signed()` | Cryptographically signed commits |

### Content filters

| Function | Description |
|----------|-------------|
| `empty()` | Commits with no file changes |
| `files(expression)` | Commits modifying paths matching fileset |
| `diff_contains(text, [files])` | Commits with diffs containing text |
| `conflicts()` | Commits with unresolved conflicts |
| `merges()` | Merge commits (multiple parents) |

Examples:
```sh
jj log -r 'files(src/)'                     # Changed files under src/
jj log -r 'diff_contains("TODO")'           # Diffs mentioning TODO
jj log -r 'diff_contains("bug", "*.rs")'    # "bug" in Rust file diffs
jj log -r 'conflicts()'                     # Conflicted commits
```

### Utility functions

| Function | Description |
|----------|-------------|
| `present(x)` | Same as x, but returns none() if any commit doesn't exist |
| `coalesce(x, y, ...)` | First non-empty revset |
| `exactly(x, count)` | Error if x doesn't have exactly count commits |
| `at_operation(op, x)` | Evaluate x at a previous operation |

## String Patterns

Used in functions like `description()`, `author()`, `bookmarks()`.

| Pattern | Description |
|---------|-------------|
| `"string"` | Glob pattern (default) |
| `exact:"string"` | Exact match |
| `glob:"pattern"` | Unix glob (`*`, `**`, `?`, `[...]`) |
| `regex:"pattern"` | Regular expression |
| `substring:"string"` | Contains substring |

Add `-i` for case-insensitive: `glob-i:"*.RS"`, `regex-i:"fix.*bug"`

### Pattern operators

```sh
~x        # Not matching x
x & y     # Matching both
x | y     # Matching either
x ~ y     # Matching x but not y
```

Examples:
```sh
jj log -r 'bookmarks(~glob:"ci/*")'         # Bookmarks not starting with ci/
jj log -r 'description(regex:"fix|bug")'    # Contains "fix" or "bug"
jj log -r 'author(exact:"Alice")'           # Exactly "Alice"
```

## Date Patterns

Used in `author_date()` and `committer_date()`.

| Pattern | Description |
|---------|-------------|
| `after:"date"` | At or after date |
| `before:"date"` | Before date (exclusive) |

Date formats:
- `2024-02-01`
- `2024-02-01T12:00:00`
- `2024-02-01T12:00:00-08:00`
- `2 days ago`
- `yesterday`
- `yesterday 5pm`

Examples:
```sh
jj log -r 'author_date(after:"2024-01-01")'
jj log -r 'committer_date(before:"1 week ago")'
jj log -r 'author_date(after:"yesterday 9am") & author_date(before:"yesterday 5pm")'
```

## Built-in Aliases

These are defined by default and can be overridden in config.

| Alias | Default Definition |
|-------|-------------------|
| `trunk()` | Default branch of default remote (main, master, or trunk) |
| `immutable_heads()` | `present(trunk()) \| tags() \| untracked_remote_bookmarks()` |
| `immutable()` | `::(immutable_heads() \| root())` |
| `mutable()` | `~immutable()` |
| `visible()` | `::visible_heads()` |
| `hidden()` | `~visible()` |

Override in config:
```toml
[revset-aliases]
'trunk()' = 'main@origin'
'immutable_heads()' = 'trunk() | tags() | bookmarks(release-*)'
```

## Custom Aliases

Define in `~/.config/jj/config.toml`:

```toml
[revset-aliases]
# Simple alias
'HEAD' = '@-'

# Function with no arguments
'wip()' = 'description(regex:"^wip|^WIP")'

# Function with arguments (can be overloaded by arity)
'user()' = 'user("me@example.org")'
'user(x)' = 'author(x) | committer(x)'

# Stack-related
'stack()' = 'ancestors(reachable(@, mutable()), 2) & mutable()'
```

## Practical Examples

### Common queries

```sh
# Commits I made this week
jj log -r 'mine() & author_date(after:"1 week ago")'

# Unpushed local work
jj log -r 'remote_bookmarks()..'

# Commits not on origin
jj log -r 'remote_bookmarks(remote=origin)..'

# Merge commits in recent history
jj log -r 'merges() & @::'

# Conflicted commits in my stack
jj log -r 'conflicts() & mutable()'

# Commits touching specific files
jj log -r 'files("src/main.rs")'

# Empty commits (might want to abandon)
jj log -r 'empty() & mutable() & ~merges()'
```

### Stack operations

```sh
# My current stack (mutable ancestors of @)
jj log -r '::@ & mutable()'

# Full stack including descendants
jj log -r 'reachable(@, mutable())'

# Stack roots (where my work branched from trunk)
jj log -r 'roots(trunk()..@)'

# Commits between trunk and my bookmarks
jj log -r 'trunk()..bookmarks()'

# Rebase ALL branches onto updated trunk (use with jj rebase -s)
# all: prefix required for multiple revisions
jj rebase -s 'all:roots(trunk..@)' -d trunk
```

### Branch analysis

```sh
# All anonymous branch heads (working on multiple features)
jj log -r 'heads(all())'

# Heads of just my mutable work
jj log -r 'heads(mutable())'

# Bookmarks ahead of trunk
jj log -r 'bookmarks() ~ ::trunk()'

# Feature branches (bookmarks not on trunk)
jj log -r 'heads(bookmarks() ~ trunk()::)'

# Stale remote bookmarks (not in local)
jj log -r 'remote_bookmarks() ~ bookmarks()'
```

### Finding specific commits

```sh
# First commit mentioning a feature
jj log -r 'roots(description("feature-x"))' --limit 1

# Most recent release tag
jj log -r 'latest(tags(v*))' --limit 1

# Commits by author in date range
jj log -r 'author("alice") & author_date(after:"2024-01-01") & author_date(before:"2024-02-01")'
```
