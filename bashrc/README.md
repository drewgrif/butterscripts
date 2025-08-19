# Enhanced Bash Configuration

A comprehensive bash configuration with productivity enhancements, git-aware prompt, 100+ aliases, and smart tool detection.

## Installation

```bash
cp ~/.bashrc ~/.bashrc.backup
cp .bashrc ~/.bashrc
source ~/.bashrc
```

## Key Features

- **Git-aware prompt** with time, user, host, and branch info
- **100+ aliases** for navigation, git, package management
- **FZF integration** for fuzzy searching (when installed)
- **Enhanced history** with 10,000 entries and deduplication
- **Smart tool detection** with graceful fallbacks

## Customization

- Create `~/.bashrc.local` for personal additions
- Run `alias` to see all available shortcuts  
- Use `type [command]` to see what commands do

## Optional Tools

| Command | Description |
|---------|-------------|
| `install_tools` | Install fzf and ripgrep for enhanced features |

## Navigation & Files

| Command | Description |
|---------|-------------|
| `..` `...` `....` | Go up 1, 2, 3 directories |
| `ls` `ll` `la` `lt` | Enhanced listings with colors/icons |
| `mkcd [dir]` | Create directory and enter it |
| `backup [file]` | Create timestamped backup |
| `extract [archive]` | Smart archive extraction |
| `dirsize [dir]` | Get directory size |
| `biggest` | Show largest files/folders |

## Git Shortcuts

| Command | Description |
|---------|-------------|
| `gs` `ga` `gc` `gp` `gpl` | status, add, commit, push, pull |
| `gaa` `gcm` `gco` `gb` `gd` | add all, commit -m, checkout, branch, diff |
| `gl` `gsave` | log graph, quick commit with timestamp |

## Package Management

| Command | Description |
|---------|-------------|
| `install` `search` `remove` | Package operations |
| `update` `upgrade` `fullupgrade` | System updates |

## Essential Tools

| Command | Description |
|---------|-------------|
| `calc [expr]` | Calculator |
| `sysinfo` | System information summary |
| `myip` `ports` | Network info |
| `x` `c` `reload` | Exit, clear, reload bashrc |

### Note Management
| Command | Description |
|---------|-------------|
| `note` | View all notes |
| `note [text]` | Add new note with timestamp |
| `note clear` | Remove all notes |

Notes are stored in `~/.local/share/notes` with timestamps.

### Todo Management
| Command | Description |
|---------|-------------|
| `todo` | List active tasks |
| `todo [task]` | Add new task |
| `todo done [#]` | Mark task as complete |
| `todo remove [#]` | Delete task |
| `todo all` | Show all tasks (including completed) |
| `todo clear` | Remove completed tasks |

Tasks stored in `~/.local/share/todos/tasks.txt` as simple text.

## FZF Integration (when installed)

| Command | Description |
|---------|-------------|
| `vf` | Find and edit file |
| `fkill` | Find and kill process |
| `Ctrl-R` | Search command history |
| `Ctrl-T` | Insert file path |
| `Alt-C` | Change directory |

---

*Modern bash configuration with smart defaults and optional tool integration.*