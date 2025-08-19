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
alias .....='cd ../../../..'
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
alias fullupgrade='sudo apt update && sudo apt full-upgrade && sudo apt autoremove --purge'
alias remove='sudo apt remove'
alias purge='sudo apt purge'
alias autoremove='sudo apt autoremove --purge'
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
alias gdc='git diff --cached'
alias gl='git log --oneline --graph --decorate'
alias gla='git log --oneline --graph --decorate --all'
alias gclone='git clone'
alias gsave='git add -A && git commit -m "Quick save $(date +%Y-%m-%d_%H:%M:%S)"'

# Docker (if available)
if command -v docker >/dev/null 2>&1; then
    alias d='docker'
    alias dc='docker-compose'
    alias dps='docker ps'
    alias dpsa='docker ps -a'
    alias dimg='docker images'
    alias dexec='docker exec -it'
    alias dlogs='docker logs -f'
    alias dprune='docker system prune -a'
fi

# Python
alias py='python3'
alias pip='pip3'
alias venv='python3 -m venv'
alias activate='source venv/bin/activate'

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
alias gp='cd ~/projects'
alias gt='cd /tmp'

# DWM aliases (keeping your originals)
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
alias rg='rg --color=auto'

# Find commands
alias fif='find . -type f -name'
alias fid='find . -type d -name'
alias biggest='du -h --max-depth=1 | sort -h'

# FZF-powered commands (if available)
if command -v fzf >/dev/null 2>&1; then
    # File and directory search
    alias fzff='fzf --preview "bat --color=always {} 2>/dev/null || cat {}"'
    alias fzfd='find . -type d | fzf --preview "ls -la {}"'
    
    # Change directory with fzf
    cdf() {
        local dir
        dir=$(find ${1:-.} -type d 2> /dev/null | fzf +m) && cd "$dir"
    }
    
    # Open file in editor with fzf
    vf() {
        local file
        file=$(fzf --preview "bat --color=always {} 2>/dev/null || cat {}") && ${EDITOR:-vim} "$file"
    }
    
    # Git branch switch with fzf
    gcof() {
        local branch
        branch=$(git branch -a | grep -v HEAD | fzf | sed 's/.* //') && git checkout "$branch"
    }
    
    # Kill process with fzf
    fkill() {
        local pid
        pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')
        if [ "x$pid" != "x" ]; then
            echo "$pid" | xargs kill -${1:-9}
        fi
    }
    
    # Search history with fzf
    fh() {
        eval $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed 's/ *[0-9]* *//')
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
alias weather='curl wttr.in/thonotosassa?u'

# Notification (keeping your original)
alias hi='pgrep -x dunst >/dev/null && notify-send "Hi there!" "Welcome to the enhanced bash environment!" -i ""'

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
    local note_file="$HOME/notes.md"
    if [ "$#" -eq 0 ]; then
        cat "$note_file"
    else
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" >> "$note_file"
        echo "Note added to $note_file"
    fi
}

# Quick server (Python)
serve() {
    local port="${1:-8000}"
    python3 -m http.server "$port"
}

# Countdown timer
countdown() {
    local seconds="${1:-60}"
    while [ "$seconds" -gt 0 ]; do
        echo -ne "$seconds\033[0K\r"
        sleep 1
        : $((seconds--))
    done
    echo "Time's up!"
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

# Git status for all repos in directory
gitall() {
    for dir in */; do
        if [ -d "$dir/.git" ]; then
            echo -e "\n\033[1;34m=== $dir ===\033[0m"
            (cd "$dir" && git status -s)
        fi
    done
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
# LOCAL OVERRIDES
# ============================================================================

# Source local bashrc if it exists (for machine-specific settings)
if [ -f "$HOME/.bashrc.local" ]; then
    . "$HOME/.bashrc.local"
fi
