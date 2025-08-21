#!/usr/bin/env bash
# DESC: Install WezTerm terminal emulator from official repository
# ============================================
# Install WezTerm - Terminal Emulator
# ============================================
set -e

# Helper functions
die() {
    echo "ERROR: $1"
    exit 1
}

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Main installation function
install_wezterm() {
    if command_exists wezterm; then
        echo "WezTerm is already installed. Skipping installation."
        return
    fi
    
    echo "Installing WezTerm nightly..."
    
    # Add WezTerm repository
    curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg || die "Failed to add WezTerm GPG key."
    echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list || die "Failed to add WezTerm repository."
    sudo chmod 644 /usr/share/keyrings/wezterm-fury.gpg
    
    # Update package list and install
    sudo apt update || die "Failed to update package list."
    sudo apt install -y wezterm-nightly || die "Failed to install WezTerm nightly."
    
    # Setup configuration
    echo "Setting up WezTerm configuration..."
    CONFIG_DIR="$HOME/.config/wezterm"
    mkdir -p "$CONFIG_DIR"
    
    # Updated configuration URL
    CONFIG_URL="https://github.com/drewgrif/butterscripts/raw/main/wezterm/wezterm.lua"
    wget -O "$CONFIG_DIR/wezterm.lua" "$CONFIG_URL" || die "Failed to download WezTerm config."
    
    echo "WezTerm installation and configuration complete."
}

# Run the installation
install_wezterm

    # Set wezterm as default terminal emulator (fixes Debian 13 defaulting to lxterminal)
    if command -v wezterm &> /dev/null && command -v update-alternatives &> /dev/null; then
        echo "Setting wezterm as default terminal emulator..."
        sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator /usr/bin/wezterm 50
        sudo update-alternatives --set x-terminal-emulator /usr/bin/wezterm
    fi
