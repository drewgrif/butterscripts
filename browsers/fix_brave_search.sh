#!/bin/bash
# DESC: Fix Brave custom search engines by modifying preferences directly

set -e

echo "Fixing Brave custom search engines..."

# Find Brave config directory
BRAVE_CONFIG_DIR="$HOME/.config/BraveSoftware/Brave-Browser"

if [[ ! -d "$BRAVE_CONFIG_DIR" ]]; then
    echo "Error: Brave config directory not found at $BRAVE_CONFIG_DIR"
    echo "Please ensure Brave is installed and has been run at least once."
    exit 1
fi

# Check if Brave is running
if pgrep -x "brave" > /dev/null || pgrep -x "brave-browser" > /dev/null; then
    echo "⚠️  Brave is currently running. Please close Brave before continuing."
    echo "Press Enter after closing Brave to continue, or Ctrl+C to cancel..."
    read
    
    # Check again
    if pgrep -x "brave" > /dev/null || pgrep -x "brave-browser" > /dev/null; then
        echo "Error: Brave is still running. Please close it first."
        exit 1
    fi
fi

# Find the Default profile preferences
PREFS_FILE="$BRAVE_CONFIG_DIR/Default/Preferences"

if [[ ! -f "$PREFS_FILE" ]]; then
    echo "Error: Preferences file not found at $PREFS_FILE"
    exit 1
fi

# Backup preferences
cp "$PREFS_FILE" "$PREFS_FILE.backup.$(date +%Y%m%d_%H%M%S)"
echo "✅ Backed up preferences"

# Use Python to modify JSON preferences
python3 << 'PYTHON_SCRIPT'
import json
import sys
import os

prefs_file = os.path.expanduser("~/.config/BraveSoftware/Brave-Browser/Default/Preferences")

# Read existing preferences
with open(prefs_file, 'r') as f:
    prefs = json.load(f)

# Custom search engines to add
custom_engines = [
    {
        "date_created": "13377777777000000",
        "favicon_url": "https://www.google.com/favicon.ico",
        "guid": "custom-google-web",
        "id": "101",
        "is_active": 1,
        "keyword": ":gw",
        "last_modified": "13377777777000000",
        "name": "Google Web (No AI)",
        "prepopulate_id": 0,
        "safe_for_autoreplace": False,
        "short_name": "Google Web",
        "synced_guid": "custom-google-web",
        "url": "https://www.google.com/search?udm=14&q={searchTerms}"
    },
    {
        "date_created": "13377777778000000",
        "favicon_url": "https://www.google.com/favicon.ico",
        "guid": "custom-google-images",
        "id": "102",
        "is_active": 1,
        "keyword": ":gi",
        "last_modified": "13377777778000000",
        "name": "Google Images",
        "prepopulate_id": 0,
        "safe_for_autoreplace": False,
        "short_name": "Google Images",
        "synced_guid": "custom-google-images",
        "url": "https://www.google.com/search?udm=2&q={searchTerms}"
    },
    {
        "date_created": "13377777779000000",
        "favicon_url": "https://www.google.com/favicon.ico",
        "guid": "custom-google-news",
        "id": "103",
        "is_active": 1,
        "keyword": ":gn",
        "last_modified": "13377777779000000",
        "name": "Google News",
        "prepopulate_id": 0,
        "safe_for_autoreplace": False,
        "short_name": "Google News",
        "synced_guid": "custom-google-news",
        "url": "https://www.google.com/search?udm=12&q={searchTerms}"
    },
    {
        "date_created": "13377777780000000",
        "favicon_url": "https://www.google.com/favicon.ico",
        "guid": "custom-google-maps",
        "id": "104",
        "is_active": 1,
        "keyword": ":gm",
        "last_modified": "13377777780000000",
        "name": "Google Maps",
        "prepopulate_id": 0,
        "safe_for_autoreplace": False,
        "short_name": "Google Maps",
        "synced_guid": "custom-google-maps",
        "url": "https://www.google.com/maps/search/{searchTerms}"
    }
]

# Ensure search provider data exists
if "default_search_provider_data" not in prefs:
    prefs["default_search_provider_data"] = {}

if "template_url_data" not in prefs["default_search_provider_data"]:
    prefs["default_search_provider_data"]["template_url_data"] = []

# Get existing search engines
existing = prefs["default_search_provider_data"]["template_url_data"]

# Remove any existing custom engines with same keywords
keywords_to_remove = {":gw", ":gi", ":gn", ":gm"}
existing = [e for e in existing if e.get("keyword") not in keywords_to_remove]

# Add our custom engines
existing.extend(custom_engines)

# Update preferences
prefs["default_search_provider_data"]["template_url_data"] = existing

# Write back
with open(prefs_file, 'w') as f:
    json.dump(prefs, f, separators=(',', ':'))

print("✅ Added custom search engines to Brave preferences")
PYTHON_SCRIPT

echo ""
echo "✅ Brave search engines have been fixed!"
echo ""
echo "Available shortcuts:"
echo "  :gw search term    -> Google Web (clean, no AI)"
echo "  :gi search term    -> Google Images"
echo "  :gn search term    -> Google News"
echo "  :gm search term    -> Google Maps"
echo ""
echo "Start Brave and the search engines should now work."
echo "You can test by typing ':gw test' in the address bar."