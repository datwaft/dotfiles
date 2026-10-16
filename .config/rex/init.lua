-- Support for MacOS default navigation keybinds
rex.bind("cmd+left", "pane.send_key", { key = "home" })
rex.bind("cmd+right", "pane.send_key", { key = "end" })
rex.bind("cmd+backspace", "pane.send_key", { key = "ctrl+u" })

-- Use CMD+d for opening a pane with the optimal split size
rex.bind("cmd+d", "pane.split", { direction = "auto" })
-- Use CMD+s for switching between sessions
rex.bind("cmd+s", "session.switch")

-- Use CMD+OPT+Arrow to navigate between panes
rex.bind("cmd+opt+left", "pane.focus", { direction = "left" })
rex.bind("cmd+opt+right", "pane.focus", { direction = "right" })
rex.bind("cmd+opt+up", "pane.focus", { direction = "up" })
rex.bind("cmd+opt+down", "pane.focus", { direction = "down" })

-- Use CMD+SHIFT+[ and ] to navigate between tabs
rex.bind("cmd+shift+[", "client.tab.previous")
rex.bind("cmd+shift+]", "client.tab.next")

-- Use CMD+1..9 to navigate between tabs
for index = 1, 9 do
    rex.bind("cmd+" .. index, "client.tab.goto", { index = index })
end

-- On <C-w> enter navigation mode iff outside neovim
rex.action({
    name = "handle_ctrl_w",
    title = "Navigate Panes or Send Ctrl+W to Neovim",
    run = function ()
        local process = assert(rex.block.call("com.superlogical.terminal", "process", {}))
        if process.foreground and process.foreground.name == "nvim" then
            rex.client.queue("pane.send_key", { key = "ctrl+w" })
        else
            rex.client.queue("client.mode.enter", { name = "navigate", once = true })
        end
    end
})
rex.bind("ctrl+w", "handle_ctrl_w")

rex.mode("navigate", { exclusive = true })
-- In `navigate` mode move between panes with hjkl
rex.bind("navigate/h", "pane.focus", { direction = "left", wrap = false })
rex.bind("navigate/j", "pane.focus", { direction = "down", wrap = false })
rex.bind("navigate/k", "pane.focus", { direction = "up", wrap = false })
rex.bind("navigate/l", "pane.focus", { direction = "right", wrap = false })
-- <C-w>w and <C-w><C-w> pass <C-w> through
rex.bind("navigate/w", "pane.send_key", { key = "ctrl+w" })
rex.bind("navigate/ctrl+w", "pane.send_key", { key = "ctrl+w" })

-- Action called by `smart-splits.nvim` from neovim.
-- Returns whether Rex handled the move, as the plugin protocol expects.
rex.action({
    name = "smart_splits_move",
    title = "Move focus from a pane to another adjacent pane",
    args = {
        type = "object",
        properties = {
            direction = { type = "string", enum = { "left", "right", "up", "down" } },
            wrap = { type = "boolean" }
        },
        required = { "direction" },
        additionalProperties = false
    },
    run = function (ctx, args)
        local view = assert(rex.session.view({}))
        local result = assert(rex.session.focus_direction({
                direction = args.direction,
                wrap = args.wrap == true
            }))
        -- `revision` changes when the focus has moved to another pane
        return { handled = result.revision ~= view.revision }
    end
})
