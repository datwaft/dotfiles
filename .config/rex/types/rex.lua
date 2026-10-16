---@meta

-- Curated subset of the injected Rex API used by this configuration.
-- Editor metadata only: do not require this file from init.lua.
-- https://www.superlogical.com/rex/docs/reference/lua

---@class Rex
_G.rex = {}

--- Bind a shortcut to one of the client actions used by this configuration.
---@param key    string          A key chord or sequence in Rex's shortcut syntax.
---@param action "pane.send_key"
---@param args   { key: string }
---@overload fun(key: string, action: "pane.split", args: { direction: "left" | "right" | "up" | "down" | "auto" })
---@overload fun(key: string, action: "pane.focus", args: { direction: "left" | "right" | "up" | "down", wrap?: boolean })
---@overload fun(key: string, action: "session.switch" | "client.tab.previous" | "client.tab.next")
---@overload fun(key: string, action: "client.tab.goto", args: { index: integer })
function rex.bind(key, action, args) end
