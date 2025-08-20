#!/bin/bash
# DESC: Interactive installer for optional applications from butterscripts and APT repositories

# Butter Applications Installer
# This script allows you to choose which applications to install from the
# butterscripts repository by drewgrif, and also provides APT-based installations.

# Define color codes
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Define package categories globally for reuse
declare -a PRINTER_PACKAGES=(
    "cups" 
    "cups-client" 
    "cups-filters" 
    "cups-pdf" 
    "printer-driver-all" 
    "printer-driver-cups-pdf" 
    "system-config-printer" 
    "hplip" 
    "sane-utils" 
    "xsane" 
    "simple-scan"
)

declare -a BLUETOOTH_PACKAGES=(
    "bluetooth" 
    "bluez" 
    "bluez-tools" 
    "bluez-cups" 
    "blueman" 
    "pulseaudio-module-bluetooth"
)

# Function to display script header
show_header() {
    clear
    echo -e "${CYAN}=========================================================${NC}"
    echo -e "${CYAN}           BUTTER APPLICATIONS INSTALLER                 ${NC}"
    echo -e "${CYAN}=========================================================${NC}"
    echo -e "${YELLOW}This script will help you install various applications${NC}"
    echo -e "${YELLOW}from the butterscripts repository and APT packages.${NC}"
    echo
}

# Function to pause
pause() {
    read -p "Press Enter to continue..." -r
}

# Function to ask yes/no questions
ask_yes_no() {
    local prompt="$1"
    local response
    
    while true; do
        read -p "$prompt [y/n]: " response
        case "${response,,}" in
            y|yes) return 0 ;;
            n|no) return 1 ;;
            *) echo -e "${RED}Please answer yes or no.${NC}" ;;
        esac
    done
}

# Common function to install a group of packages
install_package_group() {
    local packages=("$@")  # Accept all arguments as package names
    local enable_cups=false
    local enable_bluetooth=false
    
    # Check if we need to enable specific services
    for pkg in "${packages[@]}"; do
        if [[ "$pkg" == "cups" ]]; then
            enable_cups=true
        elif [[ "$pkg" == "bluetooth" ]] || [[ "$pkg" == "bluez" ]]; then
            enable_bluetooth=true
        fi
    done
    
    # Install packages
    echo -e "${YELLOW}Updating package lists...${NC}"
    sudo apt update
    
    echo -e "${YELLOW}Installing packages...${NC}"
    sudo apt install -y "${packages[@]}"
    
    # Enable and start services if needed
    if [[ "$enable_cups" == true ]]; then
        echo -e "${YELLOW}Enabling and starting CUPS service...${NC}"
        sudo systemctl enable cups
        sudo systemctl start cups
    fi
    
    if [[ "$enable_bluetooth" == true ]]; then
        echo -e "${YELLOW}Enabling and starting Bluetooth service...${NC}"
        sudo systemctl enable bluetooth
        sudo systemctl start bluetooth
    fi
    
    if [[ "$enable_cups" == true ]] || [[ "$enable_bluetooth" == true ]]; then
        echo -e "${YELLOW}NOTE: A system reboot is recommended to ensure all services start properly.${NC}"
    fi
}

# Function to download a script from GitHub
download_script() {
    local script_url="$1"
    local script_name="$2"
    
    echo -e "${YELLOW}Downloading $script_name...${NC}"
    wget -q "$script_url" -O "/tmp/$script_name"
    chmod +x "/tmp/$script_name"
    echo -e "${GREEN}Download complete.${NC}"
}


# Function to install Discord
install_discord() {
    show_header
    echo -e "${CYAN}Installing Discord...${NC}"
    echo -e "${YELLOW}Note: The Discord installer has various options${NC}"
    echo -e "${YELLOW}      (install, uninstall, setup, etc.)${NC}"
    echo
    
    # Download the script
    download_script "https://raw.githubusercontent.com/drewgrif/butterscripts/refs/heads/main/discord/discord" "discord"
    
    echo -e "${YELLOW}Starting Discord installer...${NC}"
    echo -e "${YELLOW}Follow the prompts during installation.${NC}"
    echo
    
    # Execute the script with install option
    bash "/tmp/discord" install
    
    echo -e "${GREEN}Discord installation process completed.${NC}"
    pause
}

# Function to install Fastfetch
install_fastfetch() {
    show_header
    echo -e "${CYAN}Installing Fastfetch...${NC}"
    
    # Create a temporary directory for fastfetch configs
    mkdir -p /tmp/fastfetch-configs
    
    # Download the script
    download_script "https://raw.githubusercontent.com/drewgrif/butterscripts/refs/heads/main/fastfetch/install_fastfetch.sh" "install_fastfetch.sh"
    
    # Download config files needed by the script
    wget -q "https://raw.githubusercontent.com/drewgrif/butterscripts/refs/heads/main/fastfetch/config.jsonc" -O "/tmp/fastfetch-configs/config.jsonc"
    wget -q "https://raw.githubusercontent.com/drewgrif/butterscripts/refs/heads/main/fastfetch/minimal.jsonc" -O "/tmp/fastfetch-configs/minimal.jsonc"
    wget -q "https://raw.githubusercontent.com/drewgrif/butterscripts/refs/heads/main/fastfetch/server.jsonc" -O "/tmp/fastfetch-configs/server.jsonc"
    
    # Set script directory to the temporary location
    export script_dir="/tmp/fastfetch-configs"
    
    # Execute the script
    bash "/tmp/install_fastfetch.sh"
    
    echo -e "${GREEN}Fastfetch installation completed.${NC}"
    pause
}


# Function to install Printer Support
install_printer_support() {
    show_header
    echo -e "${CYAN}Installing Printer Support...${NC}"
    
    # Display the packages to be installed
    echo -e "${YELLOW}The following printer-related packages will be installed:${NC}"
    echo
    
    for pkg in "${PRINTER_PACKAGES[@]}"; do
        echo -e "- $pkg"
    done
    
    echo
    if ! ask_yes_no "Do you want to install these printer support packages?"; then
        echo -e "${YELLOW}Installation cancelled.${NC}"
        pause
        return
    fi
    
    # Use common function to install packages
    install_package_group "${PRINTER_PACKAGES[@]}"
    
    echo -e "${GREEN}Printer support installation completed.${NC}"
    echo -e "${YELLOW}You can access the CUPS web interface at http://localhost:631${NC}"
    echo -e "${YELLOW}or use system-config-printer to configure your printers.${NC}"
    pause
}

# Function to install Bluetooth Support
install_bluetooth_support() {
    show_header
    echo -e "${CYAN}Installing Bluetooth Support...${NC}"
    
    # Display the packages to be installed
    echo -e "${YELLOW}The following bluetooth-related packages will be installed:${NC}"
    echo
    
    for pkg in "${BLUETOOTH_PACKAGES[@]}"; do
        echo -e "- $pkg"
    done
    
    echo
    if ! ask_yes_no "Do you want to install these bluetooth support packages?"; then
        echo -e "${YELLOW}Installation cancelled.${NC}"
        pause
        return
    fi
    
    # Use common function to install packages
    install_package_group "${BLUETOOTH_PACKAGES[@]}"
    
    echo -e "${GREEN}Bluetooth support installation completed.${NC}"
    echo -e "${YELLOW}You can use the Bluetooth Manager (blueman) to connect devices.${NC}"
    pause
}

# Function to prompt for package selection from a category
prompt_category() {
    local -n category_array=$1
    local category_name=$2
    local -n selected_array=$3
    local choice
    
    show_header
    echo -e "${CYAN}Select ${category_name}:${NC}"
    echo -e "${YELLOW}Enter the numbers of the packages you want to install (space-separated)${NC}"
    echo -e "${YELLOW}or '0' to skip this category.${NC}"
    echo
    
    # Display the options
    for i in "${!category_array[@]}"; do
        echo -e "${CYAN}$((i+1)). ${NC}${category_array[$i]}"
    done
    
    echo -e "${CYAN}0. ${NC}Skip this category"
    echo
    
    read -p "Enter your choices (space-separated): " choice
    
    # Process the selection
    if [[ "$choice" != "0" ]]; then
        for num in $choice; do
            if [[ "$num" =~ ^[0-9]+$ ]] && [ "$num" -gt 0 ] && [ "$num" -le "${#category_array[@]}" ]; then
                selected_array+=("${category_array[$((num-1))]}")
            fi
        done
    fi
}

# Function to handle APT-based installations
# Function to handle APT-based installations
install_apt_packages() {
    # Define package categories
    local file_managers=("thunar" "pcmanfm" "krusader" "nautilus" "nemo" "dolphin" "ranger" "nnn" "lf")
    local graphics=("gimp" "flameshot" "eog" "sxiv" "qimgv" "inkscape" "maim")
    local terminals=("alacritty" "gnome-terminal" "kitty" "konsole" "terminator" "xfce4-terminal")
    local text_editors=("kate" "gedit" "l3afpad" "mousepad" "pluma")
    local multimedia=("mpv" "vlc" "audacity" "kdenlive" "obs-studio" "rhythmbox" "ncmpcpp" "mkvtoolnix-gui")
    local utilities=("gparted" "gnome-disk-utility" "nitrogen" "numlockx" "galculator" "cpu-x" "dnsutils" "whois" "curl" "tree" "btop" "htop" "bat" "brightnessctl")
    # Use global arrays for printer and bluetooth
    local printer=("${PRINTER_PACKAGES[@]}")
    local bluetooth=("${BLUETOOTH_PACKAGES[@]}")
    
    # Arrays to store selected packages
    declare -a selected_file_managers=()
    declare -a selected_graphics=()
    declare -a selected_terminals=()
    declare -a selected_text_editors=()
    declare -a selected_multimedia=()
    declare -a selected_utilities=()
    declare -a custom_packages=()
    declare -a all_selections=()
    
    # Prompt each category
    prompt_category file_managers "File Managers" selected_file_managers
    prompt_category graphics "Graphics Applications" selected_graphics
    prompt_category terminals "Terminal Emulators" selected_terminals
    prompt_category text_editors "Text Editors" selected_text_editors
    prompt_category multimedia "Multimedia Applications" selected_multimedia
    prompt_category utilities "Utilities" selected_utilities
    
    # Combine all selections
    all_selections=("${selected_file_managers[@]}" "${selected_graphics[@]}" "${selected_terminals[@]}" "${selected_text_editors[@]}" "${selected_multimedia[@]}" "${selected_utilities[@]}")
    
    # Ask about LibreOffice
    show_header
    echo -e "${CYAN}LibreOffice Installation:${NC}"
    echo -e "${YELLOW}LibreOffice is a complete office suite (Writer, Calc, Impress, Draw, Math, Base)${NC}"
    echo
    if ask_yes_no "Do you want to install LibreOffice?"; then
        all_selections+=("libreoffice")
    fi
    
    # Prompt for custom packages
    show_header
    echo -e "${CYAN}Custom Package Installation:${NC}"
    echo -e "${YELLOW}Enter any additional package names (space-separated) or press Enter to skip:${NC}"
    echo -e "${YELLOW}Example: neofetch tmux zsh${NC}"
    echo
    read -p "> " custom_input
    
    if [[ -n "$custom_input" ]]; then
        read -ra custom_packages <<< "$custom_input"
        all_selections+=("${custom_packages[@]}")
    fi
    
    # Display summary and confirm
    if [ ${#all_selections[@]} -eq 0 ]; then
        echo -e "${YELLOW}No packages selected for installation.${NC}"
        pause
        return
    fi
    
    show_header
    echo -e "${CYAN}Selected packages for installation:${NC}"
    echo
    for pkg in "${all_selections[@]}"; do
        echo -e "- $pkg"
    done
    echo
    echo -e "${YELLOW}Total packages: ${#all_selections[@]}${NC}"
    echo
    
    if ! ask_yes_no "Do you want to install these packages?"; then
        echo -e "${YELLOW}Installation cancelled.${NC}"
        pause
        return
    fi
    
    # Install all selected packages
    install_package_group "${all_selections[@]}"
    
    echo -e "${GREEN}APT package installation completed.${NC}"
    pause
}

# ButterScripts menu function
show_butterscripts_menu() {
    local choice
    
    while true; do
        show_header
        echo -e "${YELLOW}Select a ButterScript to install:${NC}"
        echo -e "${CYAN}1. ${NC}ButterBash - Modular bash configuration with note/todo functions ⭐"
        echo -e "${CYAN}2. ${NC}Geany - Text Editor with plugins (Latest version 2.1 from source)"
        echo -e "${CYAN}3. ${NC}Browsers - Firefox, LibreWolf, Brave, Floorp, Vivaldi, Chromium, Zen"
        echo -e "${CYAN}4. ${NC}Discord - Chat and Voice Application"
        echo -e "${CYAN}5. ${NC}Fastfetch - System Information Display Tool"
        echo -e "${CYAN}6. ${NC}Custom Neovim - JustAGuy Linux Pre-configured Editor"
        echo -e "${CYAN}7. ${NC}Vanilla Neovim (Latest Build) - Compiled from Source"
        echo -e "${CYAN}8. ${NC}Return to Main Menu"
        echo
        echo -e "${YELLOW}NOTE: Each installer has its own interactive options.${NC}"
        echo -e "${YELLOW}      It's recommended to install one at a time.${NC}"
        echo
        read -p "Enter your choice [1-8]: " choice
        
        case $choice in
            1)
                echo -e "${CYAN}Installing ButterBash...${NC}"
                echo -e "${YELLOW}ButterBash provides a modular bash configuration with note-taking and todo management.${NC}"
                echo -e "${YELLOW}This will backup your current .bashrc and install the full ButterBash configuration.${NC}"
                echo
                
                if ask_yes_no "Do you want to install ButterBash (will backup existing .bashrc)?"; then
                    # Clone the repository to temp location
                    temp_dir="/tmp/butterbash-$(date +%s)"
                    echo -e "${YELLOW}Cloning ButterBash repository...${NC}"
                    
                    if git clone --quiet https://github.com/drewgrif/butterbash.git "$temp_dir" 2>/dev/null; then
                        # Run installer from the cloned directory without confirmation
                        cd "$temp_dir"
                        export SKIP_CONFIRMATION=true
                        if bash install.sh; then
                            echo -e "${GREEN}ButterBash installation completed.${NC}"
                        else
                            echo -e "${RED}ButterBash installation failed or was cancelled.${NC}"
                        fi
                        cd - > /dev/null
                        rm -rf "$temp_dir"
                    else
                        echo -e "${RED}Failed to clone ButterBash repository${NC}"
                    fi
                else
                    echo -e "${YELLOW}ButterBash installation cancelled.${NC}"
                fi
                pause
                ;;
            2) 
                download_script "https://raw.githubusercontent.com/drewgrif/butterscripts/refs/heads/main/setup/install_geany.sh" "install_geany.sh"
                if bash "/tmp/install_geany.sh"; then
                    echo -e "${GREEN}Geany installation completed.${NC}"
                else
                    echo -e "${RED}Geany installation failed or was cancelled.${NC}"
                fi
                pause
                ;;
            3) 
                download_script "https://raw.githubusercontent.com/drewgrif/butterscripts/refs/heads/main/browsers/install_browsers.sh" "install_browsers.sh"
                if bash "/tmp/install_browsers.sh"; then
                    echo -e "${GREEN}Browsers installation process completed.${NC}"
                else
                    echo -e "${RED}Browsers installation failed or was cancelled.${NC}"
                fi
                pause
                ;;
            4) install_discord ;;  # This one is different, keep as is
            5) install_fastfetch ;; # This one needs config files, keep as is
            6) 
                download_script "https://raw.githubusercontent.com/drewgrif/butterscripts/refs/heads/main/neovim/buttervim.sh" "buttervim.sh"
                if bash "/tmp/buttervim.sh"; then
                    echo -e "${GREEN}Neovim installation process completed.${NC}"
                else
                    echo -e "${RED}Neovim installation failed or was cancelled.${NC}"
                fi
                pause
                ;;
            7) 
                download_script "https://raw.githubusercontent.com/drewgrif/butterscripts/refs/heads/main/neovim/build-neovim.sh" "build-neovim.sh"
                if bash "/tmp/build-neovim.sh"; then
                    echo -e "${GREEN}Neovim build and installation completed.${NC}"
                else
                    echo -e "${RED}Neovim build and installation failed or was cancelled.${NC}"
                fi
                pause
                ;;
            8) return ;;
            *)
                echo -e "${RED}Invalid option. Please try again.${NC}"
                pause
                ;;
        esac
    done
}

# System Support menu function
show_system_support_menu() {
    local choice
    
    while true; do
        show_header
        echo -e "${YELLOW}System Support Installations:${NC}"
        echo -e "${CYAN}1. ${NC}Printer Support - CUPS and related drivers"
        echo -e "${CYAN}2. ${NC}Bluetooth Support - BluezZ and related utilities"
        echo -e "${CYAN}3. ${NC}Return to Main Menu"
        echo
        read -p "Enter your choice [1-3]: " choice
        
        case $choice in
            1) install_printer_support ;;
            2) install_bluetooth_support ;;
            3) return ;;
            *)
                echo -e "${RED}Invalid option. Please try again.${NC}"
                pause
                ;;
        esac
    done
}

# Function to handle system reboot
reboot_system() {
    show_header
    echo -e "${CYAN}System Reboot${NC}"
    echo -e "${YELLOW}A reboot is recommended after installing system services${NC}"
    echo -e "${YELLOW}or drivers to ensure all changes take effect properly.${NC}"
    echo
    
    if ask_yes_no "Do you want to reboot the system now?"; then
        echo -e "${GREEN}Initiating system reboot...${NC}"
        sleep 2
        sudo reboot
    else
        echo -e "${YELLOW}Reboot cancelled. You can reboot manually later.${NC}"
        pause
    fi
}

# Main menu function
show_main_menu() {
    local choice
    
    while true; do
        show_header
        echo -e "${YELLOW}Please select an installation option:${NC}"
        echo -e "${CYAN}1. ${NC}Butterscripts Installers"
        echo -e "${CYAN}2. ${NC}APT Package Installation"
        echo -e "${CYAN}3. ${NC}System Support (Printer & Bluetooth)"
        echo -e "${CYAN}4. ${NC}Reboot System"
        echo -e "${CYAN}5. ${NC}Exit"
        echo
        read -p "Enter your choice [1-5]: " choice
        
        case $choice in
            1) show_butterscripts_menu ;;
            2) install_apt_packages ;;
            3) show_system_support_menu ;;
            4) reboot_system ;;
            5) 
                echo -e "${GREEN}Exiting installer. Thank you for using Butter Installer!${NC}"
                exit 0
                ;;
            *)
                echo -e "${RED}Invalid option. Please try again.${NC}"
                pause
                ;;
        esac
    done
}

# Ensure we have wget installed
if ! command -v wget &>/dev/null; then
    echo -e "${YELLOW}Installing wget, which is required for downloading scripts...${NC}"
    sudo apt update
    sudo apt install -y wget
fi

# Start the main menu
show_main_menu
