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
