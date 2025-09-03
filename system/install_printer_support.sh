#!/bin/bash
# DESC: Install CUPS printing and SANE scanning services

echo "Would you like to install printing and scanning services? (y/n)"
read -r response

if [[ "$response" =~ ^[Yy]$ ]]; then
    echo "Installing printing and scanning services..."
    
    # Install required packages for printing and scanning
    sudo apt update && sudo apt install -y cups cups-client cups-filters cups-bsd sane sane-utils simple-scan
    
    # Enable and start CUPS service
    sudo systemctl enable cups.service
    sudo systemctl start cups.service
    
    # Add current user to lpadmin group for printer admin rights
    sudo usermod -aG lpadmin "$USER"
    
    # Add current user to scanner group for scanner access
    sudo usermod -aG scanner "$USER"
    
    echo "CUPS installed at http://localhost:631"
    echo "Simple Scan application installed for scanning"
    echo "Log out and log back in for group changes to take effect"
    
elif [[ "$response" =~ ^[Nn]$ ]]; then
    echo "Printing and scanning services will not be installed."
else
    echo "Invalid input. Please enter 'y' or 'n'."
fi
