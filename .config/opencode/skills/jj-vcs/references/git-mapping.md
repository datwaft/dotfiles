# Git to jj Command Mapping

Quick reference for translating Git commands to jj equivalents.

## Repository Setup

| Use Case | Git | jj |
|----------|-----|-----|
| Create new repo | `git init` | `jj git init` |
| Clone repo | `git clone <url>` | `jj git clone <url>` |
| Add remote | `git remote add <name> <url>` | `jj git remote add <name> <url>` |
| List remotes | `git remote -v` | `jj git remote list` |

## Viewing State

| Use Case | Git | jj |
|----------|-----|-----|
| Status | `git status` | `jj st` |
| Log (default) | `git log --oneline --graph` | `jj log` |
| Log all commits | `git log --oneline --graph --all` | `jj log -r ::` or `jj log -r 'all()'` |
| Diff working copy | `git diff HEAD` | `jj diff` |
| Diff staged | `git diff --cached` | N/A (no staging area) |
| Diff specific revision | `git diff <rev>^ <rev>` | `jj diff -r <rev>` |
| Diff between revisions | `git diff A B` | `jj diff --from A --to B` |
| Show commit | `git show <rev>` | `jj show <rev>` |
| Blame | `git blame <file>` | `jj file annotate <file>` |
| List files | `git ls-files` | `jj file list` |

## Making Changes

| Use Case | Git | jj |
|----------|-----|-----|
| Add file | `touch file; git add file` | `touch file` (auto-tracked) |
| Remove file | `git rm file` | `rm file` |
| Untrack file | `git rm --cached file` | `jj file untrack file` |
| Commit all | `git commit -a -m "msg"` | `jj commit -m "msg"` |
| Commit (start new change) | `git commit` | `jj new` or `jj commit` |
| Set commit message | N/A | `jj describe -m "msg"` |
| Amend | `git commit --amend` | `jj squash` (moves @ into parent) |
| Amend message only | `git commit --amend --only` | `jj describe @- -m "new msg"` |

## History Editing

| Use Case | Git | jj |
|----------|-----|-----|
| Amend older commit | `git commit --fixup=X; git rebase -i --autosquash` | `jj squash --into X` |
| Interactive rebase | `git rebase -i` | Use `jj squash`, `jj split`, `jj rebase` |
| Rebase onto | `git rebase B A` | `jj rebase -b A -d B` |
| Cherry-pick | `git cherry-pick <src>` | `jj duplicate <src> -d <dest>` |
| Revert commit | `git revert <rev>` | `jj revert -r <rev> -B @` |
| Reset hard | `git reset --hard` | `jj abandon` (abandon @, get new empty commit) |
| Reset soft | `git reset --soft HEAD~` | `jj squash --from @-` |
| Discard file changes | `git restore <file>` | `jj restore <file>` |
| Edit older commit | `git rebase -i` (edit) | `jj edit <change-id>` |
| Split commit | N/A (use rebase -i) | `jj split` |
| Auto-absorb fixups | `git commit --fixup; git rebase --autosquash` | `jj absorb` |

## Branches / Bookmarks

| Use Case | Git | jj |
|----------|-----|-----|
| List branches | `git branch` | `jj bookmark list` or `jj b l` |
| Create branch | `git branch <name>` | `jj bookmark create <name>` or `jj b c <name>` |
| Create branch at rev | `git branch <name> <rev>` | `jj bookmark create <name> -r <rev>` |
| Move branch | `git branch -f <name> <rev>` | `jj bookmark move <name> --to <rev>` |
| Delete branch | `git branch -d <name>` | `jj bookmark delete <name>` |
| Rename branch | `git branch -m <old> <new>` | `jj bookmark rename <old> <new>` |
| Switch to branch | `git checkout <branch>` | `jj new <bookmark>` |

## Remote Operations

| Use Case | Git | jj |
|----------|-----|-----|
| Fetch | `git fetch` | `jj git fetch` |
| Fetch specific remote | `git fetch <remote>` | `jj git fetch --remote <remote>` |
| Pull | `git pull` | `jj git fetch && jj rebase -d main` |
| Push all | `git push --all` | `jj git push --all` |
| Push specific branch | `git push origin <name>` | `jj git push --bookmark <name>` |
| Push and set upstream | `git push -u origin <name>` | `jj git push --bookmark <name>` (auto-tracks) |
| Track remote branch | `git branch --set-upstream-to` | `jj bookmark track <name>@<remote>` |

## Stashing

| Use Case | Git | jj |
|----------|-----|-----|
| Stash | `git stash` | `jj new @-` (old commit remains as sibling) |
| Stash pop | `git stash pop` | `jj edit <stashed-change>` or `jj squash --from <change>` |

Note: jj doesn't have a separate stash. Instead, create a new commit on the parent (`jj new @-`). The "stashed" changes remain in the original commit as a sibling. Return to them with `jj edit`.

## Undo / Recovery

| Use Case | Git | jj |
|----------|-----|-----|
| Undo last action | `git reflog; git reset` | `jj undo` |
| View history | `git reflog` | `jj op log` |
| Restore to state | `git reset --hard <ref>` | `jj op restore <op-id>` |
| View change evolution | N/A | `jj evolog` |

## Key Differences Summary

| Concept | Git | jj |
|---------|-----|-----|
| Staging area | Yes (`git add`) | No (auto-tracked) |
| Working copy | Separate from commits | Is a commit (`@`) |
| Branch naming | "branch" | "bookmark" |
| Current branch | Tracks HEAD | No current bookmark |
| Commit IDs | SHA only | Change ID + Commit ID |
| Conflicts | Block operations | Stored in commits |
| History rewrite | Requires care | Safe (descendants auto-rebase) |
