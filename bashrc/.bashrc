#!/usr/bin/env bash
# Enhanced .bashrc configuration

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# ============================================================================
# SHELL OPTIONS
# ============================================================================

# Disable ctrl-s and ctrl-q (terminal pause)
stty -ixon

# Better history management
shopt -s histappend              # Append to history, don't overwrite
shopt -s checkwinsize            # Check window size after each command
shopt -s cdspell                 # Autocorrect typos in path names when using cd
shopt -s dirspell                # Correct directory name typos
shopt -s autocd                  # Type directory name to cd
shopt -s globstar                # Allow ** for recursive matching
shopt -s nocaseglob              # Case-insensitive globbing
shopt -s extglob                 # Extended pattern matching

# History configuration
export HISTSIZE=10000
export HISTFILESIZE=20000
export HISTCONTROL=ignoreboth:erasedups
export HISTIGNORE="ls:ll:cd:pwd:exit:clear:history"
export HISTTIMEFORMAT="%F %T "

# Immediately write history
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

# ============================================================================
# ENVIRONMENT VARIABLES
# ============================================================================

# Path configuration
export PATH="$HOME/scripts:$HOME/.local/bin:/usr/local/go/bin:$HOME/.cargo/bin:$PATH"

# Default editors
export EDITOR=$(command -v nvim || command -v vim || command -v micro || echo nano)
export VISUAL="$EDITOR"

# Better less defaults
export LESS='-R -F -X -i -P %f (%i/%m) '
export LESSHISTFILE=/dev/null

# Colored man pages
export LESS_TERMCAP_mb=$'\e[1;32m'
export LESS_TERMCAP_md=$'\e[1;32m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;4;31m'

# Locale
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# ============================================================================
# COLORS AND PROMPT
# ============================================================================

# Color definitions
RED="\[\e[1;31m\]"
GREEN="\[\e[1;32m\]"
YELLOW="\[\e[1;33m\]"
BLUE="\[\e[1;34m\]"
MAGENTA="\[\e[1;35m\]"
CYAN="\[\e[1;36m\]"
WHITE="\[\e[1;37m\]"
GRAY="\[\e[1;90m\]"
ENDC="\[\e[0m\]"

# Git prompt function
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

# Set prompt with git branch
if [[ -n "$SSH_CLIENT" ]]; then 
    ssh_message="${RED}-ssh${ENDC}"
else
    ssh_message=""
fi

# Enhanced prompt with git branch
PS1="${GRAY}\t ${GREEN}\u${ssh_message} ${WHITE}at ${YELLOW}\h ${WHITE}in ${BLUE}\w${CYAN}\$(parse_git_branch)\n${CYAN}\$${ENDC} "

# ============================================================================
# ALIASES - CORE
# ============================================================================

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ~='cd ~'
alias -- -='cd -'

# ls variants with eza/exa fallback
if command -v eza >/dev/null 2>&1; then
    alias l='eza -ll --color=always --group-directories-first'
    alias ls='eza -al --header --icons --group-directories-first'
    alias ll='eza -la --icons --group-directories-first'
    alias la='eza -la --icons --group-directories-first'
    alias lt='eza --tree --level=2 --icons'
    alias lh='eza -la --sort=modified --reverse'
elif command -v exa >/dev/null 2>&1; then
    alias l='exa -l --color=always --group-directories-first'
    alias ls='exa -a --icons --group-directories-first'
    alias ll='exa -la --icons --group-directories-first'
    alias la='exa -la --icons --group-directories-first'
    alias lt='exa --tree --level=2 --icons'
    alias lh='exa -la --sort=modified --reverse'
else
    alias l='ls -lF'
    alias ll='ls -laF'
    alias la='ls -A'
    alias lt='tree -L 2'
    alias lh='ls -lath'
fi

# File operations with safety
alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -Iv'
alias mkdir='mkdir -pv'

# System info
alias df='df -h'
alias du='du -h'
alias free='free -h'
alias ps='ps auxf'
alias psg='ps aux | grep -v grep | grep -i -e VSZ -e'

# Network
alias myip="hostname -I | awk '{print \$1}' && echo -n 'External: ' && curl -s ifconfig.me && echo"
alias ports='netstat -tulanp'
alias listening='lsof -P -i -n'

# ============================================================================
# ALIASES - PACKAGE MANAGEMENT
# ============================================================================

alias install='sudo apt install'
alias search='apt search'
alias update='sudo apt update'
alias upgrade='sudo apt update && sudo apt upgrade'
alias remove='sudo apt remove'
alias autoremove='sudo apt autoremove --purge'
alias fullupgrade='sudo apt update && sudo apt full-upgrade && sudo apt autoremove --purge'
alias purge='sudo apt purge'
alias uplist='apt list --upgradable'

# ============================================================================
# ALIASES - DEVELOPMENT
# ============================================================================

# Git
alias g='git'
alias gs='git status'
alias ga='git add'
alias gaa='git add -A'
alias gc='git commit'
alias gcm='git commit -m'
alias gp='git push'
alias gpu='git push -u origin main'
alias gpl='git pull'
alias gco='git checkout'
alias gb='git branch'
alias gd='git diff'
alias gl='git log --oneline --graph --decorate'
alias gclone='git clone'


# ============================================================================
# ALIASES - EDITORS AND CONFIG
# ============================================================================

# Editors
alias v='nvim'
alias vv='nvim .'
alias e='micro'
alias n='nano'

# Config files
alias bashrc='${EDITOR} ~/.bashrc'
alias reload='source ~/.bashrc && echo "Reloaded .bashrc"'
alias zshrc='${EDITOR} ~/.zshrc'
alias vimrc='${EDITOR} ~/.vimrc'
alias nvimrc='${EDITOR} ~/.config/nvim/init.vim'
alias tmuxconf='${EDITOR} ~/.tmux.conf'

# Quick directory access
alias g.='cd ~/.config'
alias gd='cd ~/Downloads'
alias gD='cd ~/Documents'
alias gv='cd ~/Videos'

# DWM aliases
alias gdw='cd ~/.config/suckless/dwm'
alias gds='cd ~/.config/suckless/slstatus'
alias remake='rm config.h && make && sudo make clean install'


# ============================================================================
# ALIASES - UTILITIES
# ============================================================================

# System
alias x='exit'
alias c='clear'
alias h='history'
alias j='jobs -l'
alias which='type -a'
alias now='date +"%Y-%m-%d %T"'
alias week='date +%V'

# File search and grep
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

# Disk usage
alias biggest='du -h --max-depth=1 | sort -h'

# FZF configuration (if available)
if command -v fzf >/dev/null 2>&1; then
    # Open file in editor with fzf
    vf() {
        local file
        file=$(fzf --preview "bat --color=always {} 2>/dev/null || cat {}") && ${EDITOR:-vim} "$file"
    }
    
    # Kill process with fzf
    fkill() {
        local pid
        pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')
        if [ "x$pid" != "x" ]; then
            echo "$pid" | xargs kill -${1:-9}
        fi
    }
    
    # FZF default options
    export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --info=inline"
    
    # Use fd if available for faster searching
    if command -v fd >/dev/null 2>&1; then
        export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
        export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
        export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
    fi
    
    # Source fzf key bindings if available
    [ -f /usr/share/fzf/key-bindings.bash ] && source /usr/share/fzf/key-bindings.bash
    [ -f /usr/share/fzf/completion.bash ] && source /usr/share/fzf/completion.bash
    [ -f ~/.fzf.bash ] && source ~/.fzf.bash
fi

# Process management
alias k9='kill -9'
alias killall='killall -v'

# Archive extraction
alias untar='tar -xvf'
alias ungz='tar -xzvf'
alias unbz2='tar -xjvf'

# System monitoring
alias top='btop || htop || top'
alias mem='free -h && echo && ps aux | head -1 && ps aux | sort -rnk 4 | head -5'
alias cpu='ps aux | head -1 && ps aux | sort -rnk 3 | head -5'

# Misc
alias ff='fastfetch || neofetch'

# ============================================================================
# FUNCTIONS
# ============================================================================

# Create directory and cd into it
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Backup file with timestamp
backup() {
    if [ -f "$1" ]; then
        cp "$1" "$1.backup.$(date +%Y%m%d_%H%M%S)"
        echo "Backup created: $1.backup.$(date +%Y%m%d_%H%M%S)"
    else
        echo "File not found: $1"
    fi
}

# Extract archives
extract() {
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.bz2)   tar xjf "$1"     ;;
            *.tar.gz)    tar xzf "$1"     ;;
            *.tar.xz)    tar xJf "$1"     ;;
            *.bz2)       bunzip2 "$1"     ;;
            *.rar)       unrar x "$1"     ;;
            *.gz)        gunzip "$1"      ;;
            *.tar)       tar xf "$1"      ;;
            *.tbz2)      tar xjf "$1"     ;;
            *.tgz)       tar xzf "$1"     ;;
            *.zip)       unzip "$1"       ;;
            *.Z)         uncompress "$1"  ;;
            *.7z)        7z x "$1"        ;;
            *)           echo "'$1' cannot be extracted" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Search history
hgrep() {
    history | grep -i "$1"
}

# Get size of directory
dirsize() {
    du -sh "${1:-.}" 2>/dev/null | awk '{print $1}'
}

# Simple calculator
calc() {
    echo "scale=2; $*" | bc -l
}

# Show PATH in readable format
path() {
    echo "$PATH" | tr ':' '\n' | nl
}

# Quick note taking
note() {
    local note_dir="$HOME/.local/share/notes"
    local note_file="$note_dir/notes.md"
    
    # Create directory if it doesn't exist
    [ ! -d "$note_dir" ] && mkdir -p "$note_dir"
    
    if [ "$#" -eq 0 ]; then
        if [ -f "$note_file" ]; then
            cat "$note_file"
        else
            echo "No notes yet. Use 'note <text>' to add your first note."
        fi
    else
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" >> "$note_file"
        echo "Note added to $note_file"
    fi
}

# Task/Todo management
todo() {
    local todo_dir="$HOME/.local/share/todos"
    local todo_file="$todo_dir/tasks.txt"
    
    # Create directory if it doesn't exist
    [ ! -d "$todo_dir" ] && mkdir -p "$todo_dir"
    
    # Initialize file if it doesn't exist
    [ ! -f "$todo_file" ] && touch "$todo_file"
    
    case "$1" in
        ""|list)
            # List active tasks
            if [ -s "$todo_file" ]; then
                echo "📋 Tasks:"
                local count=1
                while IFS= read -r line; do
                    if [[ "$line" == "[ ]"* ]]; then
                        echo -e "  \033[1;33m[$count]\033[0m ☐ ${line:4}"
                        ((count++))
                    fi
                done < "$todo_file"
                
                # Count summary
                local active=$(grep -c "^\[ \]" "$todo_file" 2>/dev/null || echo 0)
                local done=$(grep -c "^\[x\]" "$todo_file" 2>/dev/null || echo 0)
                echo -e "\n  \033[90m$active active, $done completed\033[0m"
            else
                echo "No tasks yet. Use 'todo <task>' to add your first task."
            fi
            ;;
        
        done|complete|finish)
            # Mark task as complete
            if [ -z "$2" ]; then
                echo "Usage: todo done <number>"
                return 1
            fi
            
            local task_num="$2"
            local count=1
            local temp_file="$todo_file.tmp"
            local found=false
            
            while IFS= read -r line; do
                if [[ "$line" == "[ ]"* ]] && [ "$count" -eq "$task_num" ]; then
                    echo "[x] ${line:4} ($(date '+%Y-%m-%d'))" >> "$temp_file"
                    echo "✓ Completed: ${line:4}"
                    found=true
                else
                    echo "$line" >> "$temp_file"
                    [[ "$line" == "[ ]"* ]] && ((count++))
                fi
            done < "$todo_file"
            
            if [ "$found" = true ]; then
                mv "$temp_file" "$todo_file"
            else
                rm -f "$temp_file"
                echo "Task #$task_num not found"
                return 1
            fi
            ;;
        
        all)
            # Show all tasks including completed
            if [ -s "$todo_file" ]; then
                echo "📋 All Tasks:"
                local count=1
                while IFS= read -r line; do
                    if [[ "$line" == "[ ]"* ]]; then
                        echo -e "  \033[1;33m[$count]\033[0m ☐ ${line:4}"
                        ((count++))
                    elif [[ "$line" == "[x]"* ]]; then
                        echo -e "  \033[90m[✓] ${line:4}\033[0m"
                    fi
                done < "$todo_file"
            else
                echo "No tasks yet."
            fi
            ;;
        
        clear|clean)
            # Remove completed tasks
            local temp_file="$todo_file.tmp"
            grep "^\[ \]" "$todo_file" > "$temp_file" 2>/dev/null || true
            mv "$temp_file" "$todo_file"
            echo "Cleared completed tasks"
            ;;
        
        remove|delete|rm)
            # Remove a specific task
            if [ -z "$2" ]; then
                echo "Usage: todo remove <number>"
                return 1
            fi
            
            local task_num="$2"
            local count=1
            local temp_file="$todo_file.tmp"
            local found=false
            
            while IFS= read -r line; do
                if [[ "$line" == "[ ]"* ]] && [ "$count" -eq "$task_num" ]; then
                    echo "✗ Removed: ${line:4}"
                    found=true
                else
                    echo "$line" >> "$temp_file"
                    [[ "$line" == "[ ]"* ]] && ((count++))
                fi
            done < "$todo_file"
            
            if [ "$found" = true ]; then
                mv "$temp_file" "$todo_file"
            else
                rm -f "$temp_file"
                echo "Task #$task_num not found"
                return 1
            fi
            ;;
        
        help)
            echo "Usage:"
            echo "  todo              - List active tasks"
            echo "  todo <task>       - Add a new task"
            echo "  todo done <n>     - Mark task #n as complete"
            echo "  todo all          - Show all tasks (including completed)"
            echo "  todo remove <n>   - Delete task #n"
            echo "  todo clear        - Remove all completed tasks"
            echo "  todo help         - Show this help"
            ;;
        
        *)
            # Add new task
            echo "[ ] $*" >> "$todo_file"
            echo "✓ Added: $*"
            ;;
    esac
}



# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# System information
sysinfo() {
    echo "=== System Information ==="
    echo "Hostname: $(hostname)"
    echo "Kernel: $(uname -r)"
    echo "Uptime: $(uptime -p)"
    echo "Memory: $(free -h | awk '/^Mem:/ {print $3 "/" $2}')"
    echo "Load: $(uptime | awk -F'load average:' '{print $2}')"
    echo "Disk: $(df -h / | awk 'NR==2 {print $3 "/" $2 " (" $5 ")"}')"
}


# Colored man pages function
man() {
    LESS_TERMCAP_mb=$'\e[1;32m' \
    LESS_TERMCAP_md=$'\e[1;32m' \
    LESS_TERMCAP_me=$'\e[0m' \
    LESS_TERMCAP_se=$'\e[0m' \
    LESS_TERMCAP_so=$'\e[01;33m' \
    LESS_TERMCAP_ue=$'\e[0m' \
    LESS_TERMCAP_us=$'\e[1;4;31m' \
    command man "$@"
}

# ============================================================================
# COMPLETION
# ============================================================================

# Enable programmable completion
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

# Git completion
if [ -f /usr/share/bash-completion/completions/git ]; then
    . /usr/share/bash-completion/completions/git
fi

# ============================================================================
# CUSTOM KEYBINDINGS
# ============================================================================

# Ctrl+L to clear screen
bind '"\C-l": clear-screen'

# Up/Down arrow for history search
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

# ============================================================================
# WELCOME MESSAGE
# ============================================================================

# Display system info on login (optional - comment out if not wanted)
if [ -n "$PS1" ]; then
    echo -e "\033[1;34m=== Welcome back, $USER! ===\033[0m"
    echo -e "Date: $(date '+%A, %B %d, %Y - %H:%M:%S')"
    echo -e "Uptime:$(uptime -p | sed 's/up //')"
    echo -e "Load: $(uptime | awk -F'load average:' '{print $2}')"
    echo
fi

# ============================================================================
# TOOL INSTALLERS
# ============================================================================

# Install useful tools (fzf and ripgrep)
install_tools() {
    echo "Installing fzf and ripgrep..."
    
    # Install fzf
    if ! command -v fzf >/dev/null 2>&1; then
        echo "Installing fzf..."
        sudo apt update && sudo apt install -y fzf
    else
        echo "fzf already installed"
    fi
    
    # Install ripgrep
    if ! command -v rg >/dev/null 2>&1; then
        echo "Installing ripgrep..."
        sudo apt update && sudo apt install -y ripgrep
    else
        echo "ripgrep already installed"
    fi
    
    echo "Tools installation complete!"
    echo "Reload your shell with: source ~/.bashrc"
}

# ============================================================================
# LOCAL OVERRIDES
# ============================================================================

# Source local bashrc if it exists (for machine-specific settings)
if [ -f "$HOME/.bashrc.local" ]; then
    . "$HOME/.bashrc.local"
fi
