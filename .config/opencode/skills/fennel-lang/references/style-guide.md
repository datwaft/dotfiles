# Fennel Style Guide

Use this as the default style baseline for writing, reviewing, and refactoring Fennel code.

This guide is optimized for practical code quality in real projects: readability, maintainability, clear semantics, and predictable interop with Lua.

## Core principles

- Optimize for human scanning first. If indentation and naming are clear, the code is usually correct faster.
- Prefer explicit data flow over clever notation. Fennel is concise already; extra cleverness rarely pays off.
- Keep lexical scope obvious. Readers should not have to infer where values come from.
- Separate value-producing code from side effects when possible.
- Favor patterns that keep module APIs stable and internals replaceable.

## Formatting baseline

- Use spaces, not tabs.
- Use Unix newlines and no trailing whitespace.
- Keep most lines around 80 columns unless wrapping harms clarity.
- Keep closing delimiters with their surrounding form; avoid hanging stacks of `)` on separate lines.
- Separate most top-level forms with one blank line.
- Group related top-level `local` requires together without extra blank lines.

## Indentation and layout

- Let indentation communicate structure; readers should not need to count delimiters.
- Body forms (`fn`, `let`, `if`, `when`, `each`, `for`, `while`, `case`, `match`) indent body expressions one level.
- For non-body calls, align arguments consistently:
  - if first arg is on callee line, align remaining args with that first arg
  - if first arg starts next line, align remaining args under callee column
- For very large literal tables, opening/closing delimiters may sit on their own lines if it improves diff quality.

```fennel
;; Good body indentation
(when condition
  (log :starting)
  (run))

;; Good non-body alignment
(+ (sqrt -1)
   (* x y)
   (+ p q))
```

## Naming conventions

- Use lowercase kebab-case for identifiers.
- Prefer descriptive names for wide scope, shorter names for tight local scope.
- Use `_` or `_name` for intentionally ignored bindings.
- Use `?` suffix for predicates: `empty?`, `ready?`.
- Avoid `is-foo` names in Fennel-facing APIs.
- Use `!` suffix for destructive update or primarily I/O operations when it clarifies intent.
- Use `->` for conversion functions: `bytes->table`, `string->number`.
- Use `?name` prefix when a local may intentionally be nil.
- For method-style functions that consume table receiver, name first arg `self`.

### Lua interop naming

- Inside Fennel modules, keep idiomatic kebab-case names.
- For fields exported to Lua consumers, underscore names can be acceptable in the export table.

```fennel
(fn append-map [t f] ...)

{:append_map append-map}
```

## Comments and docstrings

- Prefer self-explanatory code; comment where intent is not obvious.
- Comments should explain why, constraints, invariants, or trade-offs; not line-by-line mechanics.
- Semicolon tiers:
  - `;;;` section headers
  - `;;` stand-alone explanatory comments
  - `;` inline comments
- Public API functions should include docstrings.
- Keep first docstring line short and task-focused; details and examples can follow.

```fennel
(fn parse-config [path]
  "Parse app config file and return normalized table."
  ...)
```

## Expression style and control flow

- Use `if` for value-returning branching.
- Use `when` for side-effecting conditionals.
- Treat `do` as a signal that multiple side effects are occurring.
- Prefer `case`/`match` when branching depends on structure, not just booleans.

```fennel
;; Good: `if` returns a value
(local status
  (if connected?
      :ready
      :offline))

;; Good: `when` used for effects
(when should-save?
  (persist! state)
  (log :saved))
```

## Locals, mutability, and scope

- Use `local` primarily at module top level.
- Use `let` inside function bodies for scoped immutable bindings.
- Use `var` only when reassignment is truly required.
- Keep mutable `var` lifetimes short and close to update sites.
- If you need `local` deep inside a function to reduce indentation, split the function.

## Data and table usage

- Prefer destructuring over repeated field lookup when it improves legibility.
- Prefer `foo.bar` / `foo:bar` when field/method is static.
- Use `(. foo key)` / `(: foo method ...)` for dynamic lookup only.
- Avoid sequential tables with nil gaps; length behavior is undefined around holes.
- Test table emptiness with `(= nil (next t))` rather than `(= 0 (length t))`.
- Use `:token-style` strings for opaque identifiers/keys and `"text"` for user-visible content.

```fennel
;; Prefer destructuring
(let [[box] (get-boxes)
      {: address} (get-label)]
  (deliver box address))
```

## Pipelines, shorthand, and concision

- Use `->` and `->>` for straightforward pipelines over one clear subject.
- If the subject changes mid-pipeline, switch to `let` with named intermediates.
- Keep hashfn shorthand (`#(...)`) to short one-liners.
- Prefer `partial` when it reads clearer than positional `$1`/$2 references.

## Module structure

- Place top-level `require` calls near the top.
- Keep module load side-effect free.
- Return a table from every module, even when only one function is currently exported.
- Build export table near the bottom so API surface is visible in one place.
- Export minimal surface area to keep internals changeable.
- Prefer relative requires for relocatable multi-file projects.
- Avoid top-level destructuring of required modules when hot-reload matters.

```fennel
(local json (require :dkjson))
(local path (require :my-lib.path))

(fn read-config [file] ...)
(fn write-config! [file cfg] ...)

{:read read-config
 :write! write-config!}
```

## Error handling conventions

- For expected failures, use `(values nil err)` and handle nearby with `case`/`case-try`.
- Use `assert`/`error` for unrecoverable conditions where propagating every step adds noise.
- Keep I/O and failure boundaries near program edges.
- Be explicit about whether a function returns single value vs multi-values.

```fennel
(fn load-user [id]
  (case (db:get id)
    (nil err) (values nil (.. "db lookup failed: " err))
    user user))
```

## Macro style in normal codebases

- Prefer functions over macros unless syntax transformation is necessary.
- Macros should preserve lexical clarity and minimize surprise.
- Do not introduce hidden locals unexpectedly.
- Prefer quote/unquote expansions over manual `list`/`sym` unless needed.
- If expansion needs runtime helpers, include explicit `require` in expansion.

## Avoid in new code

- `require-macros`
- `eval-compiler` (use normal macros instead)
- `lua` except as temporary migration or constrained interop escape hatch

When reviewing code, prioritize lexical clarity, intentional side effects, stable module exports, and safe table/multi-value behavior.
