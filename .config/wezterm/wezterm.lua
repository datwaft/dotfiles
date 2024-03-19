local wezterm = require("wezterm")
local act = wezterm.action

local config = wezterm.config_builder()
config.keys = {}
config.key_tables = {}

-- Set colorscheme to Catppuccin
config.color_scheme = "Catppuccin Mocha"
-- Configure font
config.font = wezterm.font_with_fallback({ "Iosevka", "Symbols Nerd Font" })
config.underline_position = "200%"
-- Configure tab bar appearance
config.window_frame = {
  -- Set font to SF Compact Text
  font = wezterm.font("SF Compact Text"),
}
-- Hide tab bar if there is only 1 tab
config.hide_tab_bar_if_only_one_tab = true
-- Close current pane instead of window with CMD+w and CTRL+SHIFT+w and do not ask for confirmation
config.keys = {
  { key = "w", mods = "CMD", action = act.CloseCurrentPane({ confirm = false }) },
  { key = "w", mods = "CTRL|SHIFT", action = act.CloseCurrentPane({ confirm = false }) },
  table.unpack(config.keys),
}
-- Never ask for confirmation when closing a window
config.window_close_confirmation = "NeverPrompt"
-- Add additional pane manipulation keybinds
if wezterm.target_triple:find("darwin") then
  config.keys = {
    { key = "v", mods = "CMD|SHIFT", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
    { key = "s", mods = "CMD|SHIFT", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
    table.unpack(config.keys),
  }
else
  config.keys = {
    { key = "v", mods = "CTRL|SHIFT", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
    { key = "s", mods = "CTRL|SHIFT", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
    table.unpack(config.keys),
  }
end
-- Add MacOS keybinds
if wezterm.target_triple:find("darwin") then
  config.keys = {
    { key = "LeftArrow", mods = "CMD", action = act.SendKey({ key = "Home" }) },
    { key = "RightArrow", mods = "CMD", action = act.SendKey({ key = "End" }) },
    { key = "Backspace", mods = "CMD", action = act.SendKey({ key = "u", mods = "CTRL" }) },
    { key = "Backspace", mods = "OPT", action = act.SendKey({ key = "w", mods = "CTRL" }) },
    table.unpack(config.keys),
  }
end
-- Add list workspaces keybind
if wezterm.target_triple:find("darwin") then
  config.keys = {
    { key = "s", mods = "CMD", action = act.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }) },
    table.unpack(config.keys),
  }
else
  config.keys = {
    { key = "s", mods = "CTRL|SHIFT", action = act.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }) },
    table.unpack(config.keys),
  }
end
-- Always start with tmux in the default session
if wezterm.target_triple:find("darwin") then
  config.default_prog = { "/opt/homebrew/bin/tmux", "new-session", "-A", "-s", "default" }
elseif wezterm.target_triple:find("windows") then
  config.default_prog = { "wsl", "tmux", "new-session", "-A", "-s", "default" }
else
  config.default_prog = { "tmux", "new-session", "-A", "-s", "default" }
end

return config
