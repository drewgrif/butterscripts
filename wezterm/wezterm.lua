-- Streamlined WezTerm configuration - maintains all functionality
local wezterm = require "wezterm"
local act = wezterm.action
local config = wezterm.config_builder()

-- GitHub Dark color palette
local colors = {
  fg="#d0d7de", bg="#0d1117", comment="#8b949e", red="#ff7b72",
  green="#3fb950", yellow="#d29922", blue="#539bf5", magenta="#bc8cff",
  cyan="#39c5cf", selection="#415555", caret="#58a6ff", invisibles="#2f363d"
}

-- Keybindings
config.keys = {}
-- Pane management
for _, v in ipairs({
  {"-", act.SplitPane{direction="Right", size={Percent=30}}},
  {"=", act.SplitPane{direction="Down", size={Percent=30}}},
  {"Enter", act.SplitHorizontal{domain='CurrentPaneDomain'}},
  {"\\", act.SplitVertical{domain='CurrentPaneDomain'}},
  {"w", act.CloseCurrentPane{confirm=true}},
  {"LeftArrow", act.ActivatePaneDirection'Left'},
  {"RightArrow", act.ActivatePaneDirection'Right'},
  {"UpArrow", act.ActivatePaneDirection'Up'},
  {"DownArrow", act.ActivatePaneDirection'Down'},
  {"t", act.SpawnTab'CurrentPaneDomain'},
  {"q", act.CloseCurrentTab{confirm=true}},
  {"c", act.CopyTo'ClipboardAndPrimarySelection'},
  {"v", act.PasteFrom'Clipboard'},
  {"+", act.IncreaseFontSize},
  {"-", act.DecreaseFontSize},
  {"*", act.ResetFontSize}
}) do table.insert(config.keys, {mods="ALT", key=v[1], action=v[2]}) end

-- Tab navigation (ALT+1-8)
for i = 0, 7 do table.insert(config.keys, {mods="ALT", key=tostring(i+1), action=act.ActivateTab(i)}) end

-- Tab movement and last tab (CTRL+ALT)
for _, v in ipairs({
  {"UpArrow", act.ActivateLastTab}, {"DownArrow", act.ActivateLastTab},
  {"LeftArrow", act.MoveTabRelative(-1)}, {"RightArrow", act.MoveTabRelative(1)}
}) do table.insert(config.keys, {mods="CTRL|ALT", key=v[1], action=v[2]}) end
for i = 0, 7 do table.insert(config.keys, {mods="CTRL|ALT", key=tostring(i+1), action=act.MoveTab(i)}) end

-- Font configuration
config.font = wezterm.font_with_fallback({
  {family='SauceCodePro Nerd Font Mono', weight='Regular'},
  {family='FiraCode Nerd Font Mono', weight='Regular'},
  {family='Symbols Nerd Font Mono', weight='Regular'}
})
config.font_size = 16
config.line_height = 1.1
config.window_frame = {
  font = wezterm.font{family='FiraCode Nerd Font Mono', weight='Regular'},
  font_size = 12.0,
  active_titlebar_bg = colors.bg
}

-- Performance settings
config.max_fps = 120
config.animation_fps = 1
config.window_background_opacity = 0.95
config.enable_scroll_bar = false
config.use_fancy_tab_bar = true
config.term = "xterm-256color"
config.warn_about_missing_glyphs = false
config.enable_wayland = false
config.front_end = "OpenGL"
config.webgpu_power_preference = "HighPerformance"
config.prefer_egl = true
config.freetype_load_target = "Light"
config.freetype_render_target = "HorizontalLcd"
config.hide_tab_bar_if_only_one_tab = false

-- Color scheme
config.colors = {
  foreground=colors.fg, background=colors.bg,
  cursor_bg=colors.caret, cursor_fg=colors.bg, cursor_border=colors.caret,
  selection_fg=colors.fg, selection_bg=colors.selection,
  scrollbar_thumb=colors.invisibles, split=colors.invisibles,
  ansi = {colors.invisibles, colors.red, colors.green, colors.yellow,
          colors.blue, colors.magenta, colors.cyan, colors.fg},
  brights = {colors.comment, "#ff9790", "#6af28c", "#e3b341",
             "#79c0ff", "#d2a8ff", "#56d4dd", "#ffffff"},
  tab_bar = {
    background=colors.bg, inactive_tab_edge=colors.invisibles,
    active_tab={bg_color=colors.blue, fg_color=colors.bg, intensity="Bold"},
    inactive_tab={bg_color=colors.bg, fg_color=colors.comment},
    inactive_tab_hover={bg_color="#21262d", fg_color=colors.caret},
    new_tab={bg_color=colors.bg, fg_color=colors.caret, intensity="Bold"},
    new_tab_hover={bg_color="#21262d", fg_color=colors.red}
  }
}

-- Mouse bindings
config.mouse_bindings = {
  {event={Down={streak=1, button="Right"}}, mods="NONE", action=act.CopyTo("Clipboard")},
  {event={Down={streak=1, button="Middle"}}, mods="NONE", action=act.SplitHorizontal{domain="CurrentPaneDomain"}},
  {event={Down={streak=1, button="Middle"}}, mods="SHIFT", action=act.CloseCurrentPane{confirm=false}}
}

return config
