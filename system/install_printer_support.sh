#!/bin/bash
# DESC: Install CUPS and printing services

echo "Would you like to install printing services? (y/n)"
read -r response

if [[ "$response" =~ ^[Yy]$ ]]; then
    echo "Installing printing services..."
    
    # Install required packages
    sudo apt update && sudo apt install -y cups cups-client cups-filters
    
    # Enable and start CUPS service
    sudo systemctl enable cups.service
    sudo systemctl start cups.service
    
    # Add current user to lpadmin group for printer admin rights
    sudo usermod -aG lpadmin "$USER"
    
    echo "CUPS installed at http://localhost:631"
    echo "Log out and log back in for group changes to take effect"
    
elif [[ "$response" =~ ^[Nn]$ ]]; then
    echo "Printing services will not be installed."
else
    echo "Invalid input. Please enter 'y' or 'n'."
fi
