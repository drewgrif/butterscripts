# 🧈 Butter WezTerm
A simple WezTerm terminal emulator installer for Linux systems.
> **Note:** This script installs WezTerm terminal emulator on Debian-based systems.

## Features
- Installs WezTerm nightly build with a single command
- Custom configuration automatically applied
- Clean installation process

## Requirements
- Debian-based Linux distribution
- wget for downloading files
- sudo privileges for installation

## Installation
To install WezTerm:
```bash
# Clone repository
git clone https://github.com/drewgrif/butterscripts.git
# Navigate to wezterm directory
cd butterscripts/wezterm
# Make executable
chmod +x install_wezterm.sh
# Run the installer
./install_wezterm.sh
```

## How It Works
The script:
1. Adds the WezTerm repository and GPG key
2. Installs the latest WezTerm nightly build
3. Sets up configuration in ~/.config/wezterm
4. Uses the configuration from https://github.com/drewgrif/butterscripts/wezterm/wezterm.lua
5. **Sets WezTerm as the default terminal emulator** (Debian 13+) - Configures the system to use WezTerm when file managers like Thunar launch a terminal, replacing the default lxterminal

## Configuration Features
The included configuration provides:

### Color Scheme
- GitHub Dark theme with carefully selected colors
- 95% background opacity for subtle transparency
- Custom tab bar styling

### Keybindings (ALT + key)
**Pane Management:**
- `ALT + -` - Split pane right (30% width)
- `ALT + =` - Split pane down (30% height)
- `ALT + Enter` - Split horizontal (50/50)
- `ALT + \` - Split vertical (50/50)
- `ALT + w` - Close current pane
- `ALT + Arrow Keys` - Navigate between panes

**Tab Management:**
- `ALT + t` - New tab
- `ALT + q` - Close tab
- `ALT + 1-8` - Switch to tab 1-8
- `CTRL+ALT + Left/Right` - Move tab position
- `CTRL+ALT + Up/Down` - Switch to last tab

**Other:**
- `ALT + c` - Copy selection
- `ALT + v` - Paste from clipboard
- `ALT + +` - Increase font size
- `ALT + -` - Decrease font size
- `ALT + *` - Reset font size

### Font Settings
- Primary: SauceCodePro Nerd Font Mono (size 16)
- Fallback fonts for complete glyph coverage
- Optimized rendering with FreeType

### Performance
- 120 FPS max refresh rate
- OpenGL frontend with EGL preference
- Hardware acceleration enabled
- Optimized for responsiveness

### Mouse Bindings
- Right-click to copy selection
- Middle-click to split pane horizontally
- Shift + Middle-click to close pane

## Project Info
Made for Linux users who want a powerful terminal emulator with simple installation.

---
## 🧈 Built For
- **Butter Bean (butterbian) Linux** (and other Debian-based systems)
- Window manager setups (BSPWM, Openbox, etc.)
- Users who like things lightweight, modular, and fast
> Butterbian Linux is a joke... for now.

---
## 📫 Author
**JustAGuy Linux**  
🎥 [YouTube](https://youtube.com/@JustAGuyLinux)  

---
More scripts coming soon. Use what you need, fork what you like, tweak everything.
