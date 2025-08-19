# Enhanced Bash Configuration

A comprehensive, modern bash configuration that transforms your terminal experience with productivity enhancements and thoughtful defaults.

## ✨ Key Features
- 🎨 **Git-aware prompt** with time, user, host, and branch info
- ⚡ **100+ time-saving aliases** for common tasks  
- 🔍 **FZF integration** for fuzzy searching (when installed)
- 🛠️ **Useful functions** for development and system management
- 📚 **Enhanced history** with 10,000 entries and deduplication
- 🎯 **Smart tool detection** with graceful fallbacks

## Installation

```bash
# Backup your current .bashrc
cp ~/.bashrc ~/.bashrc.backup

# Copy the enhanced configuration
cp .bashrc ~/.bashrc

# Reload your terminal
source ~/.bashrc

# Optional: Install recommended tools
install_tools  # Installs fzf and ripgrep
```

## 💡 Tips

1. Run `install_tools` after installation for FZF and ripgrep
2. Use `reload` to apply changes without restarting terminal
3. Check `alias` to see all available shortcuts
4. Use `type [command]` to see what a command does
5. Create `~/.bashrc.local` for personal additions

---

## 📁 Navigation & File Management

### Quick Navigation
| Command | Description |
|---------|-------------|
| `..` | Go up one directory |
| `...` | Go up two directories |
| `....` | Go up three directories |
| `-` | Go back to previous directory |

### Enhanced Listings
| Command | Description |
|---------|-------------|
| `ls` | All files with headers and icons |
| `l` | Detailed list with colors |
| `ll` | Long format with all files |
| `la` | All files including hidden |
| `lt` | Tree view (2 levels) |
| `lh` | Files sorted by modification time |

### Quick Directory Access
| Command | Description |
|---------|-------------|
| `g.` | Go to ~/.config |
| `gd` | Go to ~/Downloads |
| `gD` | Go to ~/Documents |
| `gv` | Go to ~/Videos |

---

## 📦 Package Management (Debian/Ubuntu)

| Command | Description |
|---------|-------------|
| `install [pkg]` | Install a package |
| `search [term]` | Search for packages |
| `update` | Update package lists |
| `upgrade` | Update system packages |
| `fullupgrade` | Full system upgrade with cleanup |
| `remove [pkg]` | Remove a package |
| `autoremove` | Clean up unused packages |

---

## 💻 Git Shortcuts

| Command | Description |
|---------|-------------|
| `gs` | Git status |
| `ga` | Git add |
| `gaa` | Git add all |
| `gc` | Git commit |
| `gcm` | Git commit with message |
| `gp` | Git push |
| `gpl` | Git pull |
| `gco` | Git checkout |
| `gb` | Git branch |
| `gd` | Git diff |
| `gl` | Git log (graph) |
| `gsave` | Quick commit with timestamp |

---

## 🛠️ Essential Functions

### File Operations
| Function | Description |
|---------|-------------|
| `mkcd [dir]` | Create directory and enter it |
| `backup [file]` | Create timestamped backup |
| `extract [archive]` | Smart archive extraction |
| `dirsize [dir]` | Get directory size |

### System Tools
| Function | Description |
|---------|-------------|
| `calc [expr]` | Quick calculator |
| `note [text]` | Add/view notes (~/.local/share/notes) |
| `todo [task]` | Task management (add/list/complete tasks) |
| `countdown [sec]` | Countdown timer |
| `sysinfo()` | System information summary |

### Todo Management
| Command | Description |
|---------|-------------|
| `todo` | List active tasks |
| `todo Buy milk` | Add a new task |
| `todo done 2` | Mark task #2 as complete |
| `todo all` | Show all tasks (including completed) |
| `todo remove 3` | Delete task #3 |
| `todo clear` | Remove all completed tasks |
| `todo help` | Show usage help |

Tasks are stored in `~/.local/share/todos/tasks.txt` as simple text.

---

## ⚡ Quick Commands

### System Shortcuts
| Command | Description |
|---------|-------------|
| `x` | Exit terminal |
| `c` | Clear screen |
| `h` | Show history |
| `reload` | Reload .bashrc |
| `now` | Current date/time |

### Network
| Command | Description |
|---------|-------------|
| `myip` | Show local and external IP |
| `ports` | Show network ports |
| `listening` | Show listening processes |

### System Info
| Command | Description |
|---------|-------------|
| `df` | Disk usage (human-readable) |
| `du` | Directory sizes |
| `free` | Memory usage |
| `top` | Process monitor (btop/htop/top) |
| `mem` | Top memory consumers |
| `cpu` | Top CPU consumers |

---

## 🔍 Search & Filter

### FZF Integration (when installed)
| Command | Description |
|---------|-------------|
| `vf()` | Find and open file in editor |
| `fkill()` | Find and kill process |
| `Ctrl-T` | Insert file path |
| `Alt-C` | Change directory |
| `Ctrl-R` | Search command history |

### System Search
| Command | Description |
|---------|-------------|
| `grep` | Colored grep |
| `biggest` | Show largest files/folders |

---

## 🎨 Terminal Appearance

### Enhanced Prompt
Shows:
- Current time (HH:MM:SS)
- Username with SSH indicator (red `-ssh` when connected remotely)
- Hostname
- Current directory path
- Git branch (when in a repository)
- Color-coded elements for easy reading

### Colored Output
- Man pages with syntax highlighting
- Grep results with color highlights
- File listings with type indicators (if eza/exa installed)

---

## 💻 Advanced Tools

### Docker (if installed)
| Command | Description |
|---------|-------------|
| `d` | Docker shortcut |
| `dc` | Docker-compose |
| `dps` | Show containers |
| `dpsa` | Show all containers |
| `dimg` | Show images |
| `dexec` | Execute in container |
| `dlogs` | Follow logs |
| `dprune` | Clean up system |

### Editors
| Command | Description |
|---------|-------------|
| `v` | Open nvim |
| `vv` | Open nvim in current directory |
| `e` | Open micro |
| `n` | Open nano |

### DWM Integration
| Command | Description |
|---------|-------------|
| `gdw` | Go to DWM directory |
| `gds` | Go to slstatus directory |
| `remake` | Rebuild and install DWM/slstatus |

---

## 🔧 Customization

### Config File Shortcuts
| Command | Description |
|---------|-------------|
| `bashrc` | Edit ~/.bashrc |
| `vimrc` | Edit ~/.vimrc |
| `nvimrc` | Edit nvim config |
| `tmuxconf` | Edit tmux config |

### Local Overrides
Create `~/.bashrc.local` for machine-specific settings that won't be overwritten.

---

## ⚙️ Technical Details

### Shell Options
- `histappend` - Append to history file
- `checkwinsize` - Update window size after commands
- `cdspell` - Autocorrect cd typos
- `dirspell` - Correct directory name typos
- `autocd` - Type directory name to cd
- `globstar` - Enable ** for recursive matching
- `nocaseglob` - Case-insensitive globbing
- `extglob` - Extended pattern matching

### History Configuration
- 10,000 command history
- 20,000 line history file
- Timestamps for all commands
- Duplicate removal
- Ignores common commands (ls, cd, pwd, etc.)
- Immediate history writes

### Key Bindings
- `Ctrl-L` - Clear screen
- `↑/↓` - Search history based on current input
- Terminal pause (Ctrl-S/Q) disabled

---

## 📋 Requirements

### Core (Always Available)
- Bash 4.0+
- Standard GNU coreutils

### Optional Enhancements
- `eza` or `exa` - Better ls replacement
- `fzf` - Fuzzy finder (install with `install_tools`)
- `ripgrep` - Fast grep (install with `install_tools`)
- `fd` - Fast find alternative
- `bat` - Better cat with syntax highlighting
- `btop` or `htop` - Better top
- `fastfetch` or `neofetch` - System info display

---

## 🚀 Performance

- Lazy loading for optional tools
- Conditional feature enabling
- Minimal startup overhead
- Smart caching where applicable

## 🔄 Maintenance

The configuration:
- Automatically detects available tools
- Gracefully falls back when tools are missing
- Preserves itself through updates
- Backs up files before operations

---

## 📄 License

This configuration is open source and available under the MIT License.

---

*A modern bash configuration that respects tradition while embracing productivity.*