local wezterm = require 'wezterm';

-- wezterm.on("SpawnCommandInNewWindowInCurrentWorkingDirectory", function(window, pane)
--   current_directory = pane:get_current_working_dir():gsub("file://", "")
--   window:perform_action(wezterm.action{SpawnCommandInNewWindow={
--     args={ "wsl.exe", "--cd", current_directory, "--exec", "bash" }
--   }}, pane)
-- end)
--
-- wezterm.on("SpawnCommandInNewTabInCurrentWorkingDirectory", function(window, pane)
--   current_directory = pane:get_current_working_dir():gsub("file://", "")
--   window:perform_action(wezterm.action{SpawnCommandInNewTab={
--     args={ "wsl.exe", "--cd", current_directory, "--exec", "bash" }
--   }}, pane)
-- end)
--
-- wezterm.on("SplitVerticalInCurrentWorkingDirectory", function(window, pane)
--   current_directory = pane:get_current_working_dir():gsub("file://", "")
--   window:perform_action(wezterm.action{SplitVertical={
--     domain="CurrentPaneDomain",
--     args={ "wsl.exe", "--cd", current_directory, "--exec", "bash" }
--   }}, pane)
-- end)
--
-- wezterm.on("SplitHorizontalCurrentWorkingDirectory", function(window, pane)
--   current_directory = pane:get_current_working_dir():gsub("file://", "")
--   window:perform_action(wezterm.action{SplitHorizontal={
--     domain="CurrentPaneDomain",
--     args={ "wsl.exe", "--cd", current_directory, "--exec", "bash" }
--   }}, pane)
-- end)
--

-- local wsl_domains = wezterm.default_wsl_domains()
--
-- local home_dir = ""
-- for _, dom in ipairs(wsl_domains) do
--   if dom.name == "WSL:Ubuntu" then
--     home_dir = dom.default_cwd
--   end
-- end
--
-- wezterm.log_info(home_dir)

return {
  -- allow_win32_input_mode = true,
  -- enable_csi_u_key_encoding = false,
  font_size = 12,
  hide_tab_bar_if_only_one_tab = true,
  color_scheme = "iceberg-dark",
  default_prog = {"wsl.exe", "~", "-d", "Ubuntu"},
  font = wezterm.font("Cica", {weight="Regular", stretch="Normal", style="Normal"}),
  use_ime = true,
  window_padding = {
    left = 4,
    right = 4,
    top = 0,
    bottom = 0,
  },
  keys = {
    { key = "-",  mods = "ALT", action = wezterm.action({ SplitVertical = { domain = "CurrentPaneDomain" } }) },
    { key = "\\", mods = "ALT", action = wezterm.action({ SplitHorizontal = { domain = "CurrentPaneDomain" } }) },
    { key = "h",  mods = "ALT|SHIFT", action = wezterm.action({ ActivatePaneDirection = "Left" }) },
    { key = "l",  mods = "ALT|SHIFT", action = wezterm.action({ ActivatePaneDirection = "Right" }) },
    { key = "k",  mods = "ALT|SHIFT", action = wezterm.action({ ActivatePaneDirection = "Up" }) },
    { key = "j",  mods = "ALT|SHIFT", action = wezterm.action({ ActivatePaneDirection = "Down" }) },
    { key = "h",  mods = "ALT|SHIFT|CTRL", action = wezterm.action({ AdjustPaneSize = { "Left", 1 } }) },
    { key = "l",  mods = "ALT|SHIFT|CTRL", action = wezterm.action({ AdjustPaneSize = { "Right", 1 } }) },
    { key = "k",  mods = "ALT|SHIFT|CTRL", action = wezterm.action({ AdjustPaneSize = { "Up", 1 } }) },
    { key = "j",  mods = "ALT|SHIFT|CTRL", action = wezterm.action({ AdjustPaneSize = { "Down", 1 } }) },
    { key = "Enter", mods = "ALT", action = "QuickSelect" },
    { key="Enter", mods="CTRL", action=wezterm.action.SendString('\x1b[13;5u') },
    { key="Enter", mods="SHIFT", action=wezterm.action.SendString('\x1b[13;2u') },
  },
}

