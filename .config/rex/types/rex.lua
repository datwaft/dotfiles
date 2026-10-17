---@meta
---@diagnostic disable: missing-fields -- stubs only declare the shape of what Rex injects

-- Types for the Lua API Rex injects into init.lua and `rex do` scripts.
-- Editor metadata only: do not require this file from init.lua.
-- https://www.superlogical.com/rex/docs/reference/lua
--
-- Action names, their arguments, and most API results vary by client and server version, so they are typed
-- loosely. Results this configuration reads have their own shapes; run `rex api describe METHOD` for the rest.

---@class Rex
_G.rex = {}

---@alias rex.Direction "left" | "right" | "up" | "down"

---@class rex.Context
---@field session_id? string The session the action applies to
---@field block_id?   string The block the action applies to, usually the focused one
---@field client_id?  string The client that asked for the action
---@field origin?     "key" | "palette" | "cli" | "api" | "script" | "timer" How the action was run
---@field server?     string The server that owns `session_id` and `block_id`, when it isn't this one

---@class rex.KeyEvent
---@field keybinding string    The key that was pressed; for a sequence, its last key
---@field prefix?    string[]  For a sequence, the keys before `keybinding`

-- Key bindings

--- Binds a key, a sequence written with `>`, or either prefixed with `mode/`, to an action by name.
--- A function binding returns `true` when it handled the key; otherwise the key falls through to the next
--- function bound to it, then to the focused terminal. Function bindings are not allowed in a mode.
---@param key    string
---@param action string
---@param args?  table<string, any>
---@overload fun(key: string, fn: fun(ctx: rex.Context, ev: rex.KeyEvent): boolean?)
function rex.bind(key, action, args) end

---@class rex.Binding
---@field key    string                The key or sequence, without its mode
---@field mode?  string
---@field action? string               `nil` for a function binding
---@field fn?    function              `nil` for an action binding
---@field args?  table<string, any>
---@field source string                Where it was bound, such as `keys.lua:3`

--- Removes the bindings of a key, limited to those targeting `target` when given, and returns how many of this
--- file's bindings it removed. `rex.unbind("mode/key")` also blocks the key in that mode.
---@param key     string
---@param target? string | function
---@return integer
---@overload fun(binding: rex.Binding): integer
---@overload fun(mode: { mode: string })
function rex.unbind(key, target) end

---@param name     string Lowercase letters, digits, underscores, and hyphens
---@param options? { exclusive?: boolean }
function rex.mode(name, options) end

---@param filter? { key?: string, mode?: string, action?: string }
---@return rex.Binding[]
function rex.bindings(filter) end

---@return { name: string, exclusive: boolean, source: string }[]
function rex.modes() end

-- Actions

---@class rex.ActionDefinition
---@field name         string  Lowercase letters, digits, and underscores
---@field title        string  Shown in the command palette
---@field run          fun(ctx: rex.Context, args: table<string, any>): any  The action's result; `nil` or `true` means none
---@field description? string
---@field category?    string
---@field keywords?    string
---@field args?        table<string, any> Argument types such as `"string?"`, or a JSON Schema
---@field repeats?     boolean Run again while the key is held

---@param definition rex.ActionDefinition
function rex.action(definition) end

--- Runs an action and returns its result, or `nil` and an error message.
---@param name  string
---@param args? table<string, any>
---@return any result
---@return string? error
function rex.invoke(name, args) end

rex.client = {}

--- Asks the client to perform one of its own actions, such as `pane.zoom`. In the configuration file this only
--- works inside an action; queued actions run after `run` returns. Raises an error when there is no client.
---@param name  string
---@param args? table<string, any>
function rex.client.queue(name, args) end

-- Calling Rex

---@class rex.SessionView
---@field session_id       string
---@field revision         integer Structural revision; changes with the layout and focus
---@field active_window_id string?
---@field label?           string
---@field windows          { window_id: string, focused_block_id?: string, zoomed_block_id?: string }[]

---@class rex.Session
---@field view                  fun(args?: table): rex.SessionView?, string?
---@field focus_direction       fun(args: { direction: rex.Direction, wrap?: boolean, session_id?: string }): { revision: integer }?, string?
---@field list_blocks           fun(args?: table): table?, string?
---@field list_clients          fun(args?: table): table?, string?
---@field describe_block        fun(args: table): table?, string?
---@field new_window            fun(args: table): table?, string?
---@field new_split             fun(args: table): table?, string?
---@field new_block             fun(args: table): table?, string?
---@field new_layer             fun(args: table): table?, string?
---@field close_window          fun(args: table): table?, string?
---@field close_layer           fun(args: table): table?, string?
---@field move_block            fun(args: table): table?, string?
---@field swap_blocks           fun(args: table): table?, string?
---@field detach_block          fun(args: table): table?, string?
---@field float_block           fun(args: table): table?, string?
---@field zoom_block            fun(args?: table): table?, string?
---@field resize_pane           fun(args: table): table?, string?
---@field resize_layer          fun(args: table): table?, string?
---@field raise_layer           fun(args: table): table?, string?
---@field lower_layer           fun(args: table): table?, string?
---@field move_window           fun(args: table): table?, string?
---@field focus_block           fun(args: table): table?, string?
---@field focus_window          fun(args: table): table?, string?
---@field focus_next_pane       fun(args?: table): table?, string?
---@field focus_previous_pane   fun(args?: table): table?, string?
---@field focus_next_window     fun(args?: table): table?, string?
---@field focus_previous_window fun(args?: table): table?, string?
---@field set_label             fun(args: table): table?, string?
---@field set_window_label      fun(args: table): table?, string?
---@field set_block_label       fun(args: table): table?, string?
---@field attach                fun(args: table): table?, string?
---@field detach                fun(args?: table): table?, string?
---@field help                  fun(args?: table): table?, string?
---@field [string]              fun(args?: table): table?, string?

--- Session methods. Each returns a result table, or `nil` and an error message, and never raises an error.
--- `session_id` is filled in when left out; other IDs, such as `block_id`, are not.
---@type rex.Session
rex.session = {}

--- Calls any server method by its full name, such as `session.list`.
---@param method string
---@param args?  table
---@return table? result
---@return string? error
function rex.call(method, args) end

---@class rex.Process
---@field pid       integer
---@field name      string
---@field path?     string
---@field user?     string
---@field user_id?  integer
---@field cwd?      string

---@class rex.TerminalProcess
---@field child?      rex.Process
---@field foreground? rex.Process
---@field ancestors?  rex.Process[]
---@field last_exit?  table
---@field home?       string

rex.block = {}

--- Calls a method on a block. `block_id` is filled in from the current block when left out.
---@param creator "com.superlogical.terminal" | string The full name of the kind of block
---@param method  "process"
---@param args?   { block_id?: string }
---@return rex.TerminalProcess? result
---@return string? error
---@overload fun(creator: string, method: string, args?: table): table?, string?
function rex.block.call(creator, method, args) end

---@class rex.Layout

---@class rex.TerminalOptions
---@field command?       string[]  The program and its arguments; without it, an interactive shell starts
---@field shell?         string    `"none"` starts `command` directly
---@field cwd?           string
---@field initial_input? string
---@field exit?          { on_completion?: boolean }

rex.layout = {}

---@param block { flavor: string, options?: rex.TerminalOptions | table }
---@return rex.Layout
function rex.layout.block(block) end

---@param ratio number The share given to `a`, from 0 to 1
---@param a     rex.Layout
---@param b     rex.Layout
---@return rex.Layout
function rex.layout.horizontal(ratio, a, b) end

---@param ratio number The share given to `a`, from 0 to 1
---@param a     rex.Layout
---@param b     rex.Layout
---@return rex.Layout
function rex.layout.vertical(ratio, a, b) end

-- Events (scripts only)

--- Calls `fn` each time `event` happens. Scripts only.
---@param event string
---@param fn    fun(ctx: rex.Context, ev: table)
function rex.on(event, fn) end

--- Blocks until `event` happens, returning `ev` and `ctx`, or `nil` and `"timeout"`. Scripts only.
---@param event    string
---@param filter?  table | fun(ev: table, ctx: rex.Context): boolean
---@param timeout? number Seconds
---@return table? ev
---@return rex.Context | "timeout" | nil ctx
---@overload fun(event: string, timeout: number): table?, (rex.Context | "timeout" | nil)
function rex.wait(event, filter, timeout) end

--- Scripts only.
---@param seconds number
function rex.sleep(seconds) end

--- Ends the script immediately; `rex do` exits with `code`, or 0. Scripts only.
---@param code? integer
function rex.stop(code) end

-- Hosts and other servers

---@class rex.HostDefinition
---@field label      string
---@field endpoints? string[] Addresses, tried in order
---@field endpoint?  string   A single address, in place of `endpoints`
---@field id?        string   A stable ID, so the host keeps its identity when renamed
---@field icon?      string

--- Declares another Rex server. Configuration file only.
---@param definition rex.HostDefinition
function rex.host(definition) end

---@return string[]
function rex.servers() end

---@class rex.Server
---@field session rex.Session
---@field block   { call: fun(creator: string, method: string, args?: table): table?, string? }
---@field call    fun(method: string, args?: table): table?, string?

--- Raises an error for an unknown label. Calls through it don't fill in a `session_id` or `block_id`.
---@param label string
---@return rex.Server
function rex.server(label) end

-- Other functions

---@class rex.ExecOptions
---@field cwd?       string
---@field env?       table<string, string | false> `false` removes a variable
---@field clear_env? boolean
---@field stdin?     string
---@field timeout?   number Seconds until `SIGTERM`, then `SIGKILL` two seconds later
---@field stdout?    false
---@field stderr?    false
---@field text?      boolean

---@class rex.ExecResult
---@field code      integer `-1` if a signal ended the command
---@field signal?   string
---@field stdout    string
---@field stderr    string
---@field timed_out boolean
---@field ok        boolean `code` is 0 and the command didn't time out

---@class rex.ExecStartOptions: rex.ExecOptions
---@field stdin?  string | boolean `true` keeps standard input open for `h:write`
---@field stdout? false | fun(data: string)
---@field stderr? false | fun(data: string)
---@field detach? boolean Let the command outlive the work that started it

---@class rex.ExecHandle
---@field pid integer
local ExecHandle = {}

---@param seconds? number
---@return rex.ExecResult? result
---@return "timeout"? error
function ExecHandle:wait(seconds) end

---@param data string
---@return true? ok
---@return string? error
function ExecHandle:write(data) end

function ExecHandle:close_stdin() end

---@param signal? string | integer
function ExecHandle:kill(signal) end

---@return boolean
function ExecHandle:running() end

---@class rex.Exec
---@overload fun(argv: string[], opts?: rex.ExecOptions): rex.ExecResult?, string?
---@field start fun(argv: string[], opts?: rex.ExecStartOptions): rex.ExecHandle?, string?

--- Runs a command and waits for it to exit. Returns `nil` and an error message only when it never ran.
---@type rex.Exec
rex.exec = {}

---@class rex.Timer
local Timer = {}

function Timer:cancel() end

---@return boolean
function Timer:active() end

--- Scripts only.
---@param seconds number
---@param fn      fun(ctx: rex.Context)
---@return rex.Timer
function rex.after(seconds, fn) end

--- Scripts only.
---@param seconds number
---@param fn      fun(ctx: rex.Context)
---@return rex.Timer
function rex.every(seconds, fn) end

rex.json = {}

---@param value any
---@param opts? { indent?: boolean }
---@return string? text
---@return string? error
function rex.json.encode(value, opts) end

---@param text string
---@return any value
---@return string? error
function rex.json.decode(text) end

---@param level   "debug" | "info" | "warn" | "error"
---@param message string
---@overload fun(message: string)
function rex.log(level, message) end

-- Script values (scripts only)

---@type table<string, any>
rex.args = {}

---@type string
rex.session_id = ""

---@type string?
rex.block_id = nil
