local wezterm = require 'wezterm'
local act = wezterm.action

-- Function to get current directory and spawn tab there
local function spawn_tab_in_cwd(window, pane)
  local cwd = pane:get_current_working_dir()
  if cwd then
    if type(cwd) == "userdata" then
      cwd = cwd.file_path
    end
    window:perform_action(
      act.SpawnCommandInNewTab { cwd = cwd },
      pane
    )
  else
    window:perform_action(act.SpawnTab 'CurrentPaneDomain', pane)
  end
end

return {
  -- Font (critical)
  font = wezterm.font_with_fallback({
    "JetBrains Mono",
    "Noto Sans CJK JP",
    "Noto Color Emoji",
  }),
  font_size = 12.0,

  -- Cursor & scroll
  hide_tab_bar_if_only_one_tab = true,
  use_fancy_tab_bar = true,
  enable_scroll_bar = true,

  -- Colorscheme (pick one)
  -- color_scheme = "Catppuccin Mocha",
  color_scheme = "Tokyo Night",
  -- color_scheme = "Gruvbox Dark (Hard)",

  -- Window chrome
  window_decorations = "RESIZE",
  window_padding = {
    left = 6,
    right = 6,
    top = 6,
    bottom = 6,
  },

  -- Rendering
  front_end = "WebGpu", -- fast, modern
  animation_fps = 60,
  max_fps = 120,

  -- Behavior
  check_for_updates = false,
  audible_bell = "Disabled",

  -- Emacs friendliness
  enable_kitty_keyboard = false,

  -- Open new tabs in same directory as current tab
  keys = {
    {
      key = 't',
      mods = 'CTRL|SHIFT',
      action = wezterm.action_callback(spawn_tab_in_cwd),
    },
    {
      key = 't',
      mods = 'SUPER',
      action = wezterm.action_callback(spawn_tab_in_cwd),
    },
  },

  window_background_opacity = 0.95,
  inactive_pane_hsb = {
    saturation = 1.0,
    brightness = 0.85,
  },

  -- Color
  colors = {
    background = "#1b1e28"
  }}
