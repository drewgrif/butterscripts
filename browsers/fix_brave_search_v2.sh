#!/bin/bash
# DESC: Fix Brave custom search engines by directly modifying Web Data SQLite database

set -e

echo "Fixing Brave custom search engines (v2)..."

# Check if sqlite3 is installed
if ! command -v sqlite3 &> /dev/null; then
    echo "Error: sqlite3 is required but not installed."
    echo "Please install it with: sudo apt-get install sqlite3"
    exit 1
fi

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

# Find the Web Data file
WEB_DATA="$BRAVE_CONFIG_DIR/Default/Web Data"

if [[ ! -f "$WEB_DATA" ]]; then
    echo "Error: Web Data file not found at $WEB_DATA"
    exit 1
fi

# Backup Web Data
cp "$WEB_DATA" "$WEB_DATA.backup.$(date +%Y%m%d_%H%M%S)"
echo "✅ Backed up Web Data"

# Add custom search engines to the SQLite database
echo "Adding custom search engines..."

# First, let's check the current max ID to avoid conflicts
MAX_ID=$(sqlite3 "$WEB_DATA" "SELECT MAX(id) FROM keywords;" 2>/dev/null || echo "100")
if [[ -z "$MAX_ID" ]] || [[ "$MAX_ID" == "NULL" ]]; then
    MAX_ID=100
fi

# Calculate new IDs
ID1=$((MAX_ID + 1))
ID2=$((MAX_ID + 2))
ID3=$((MAX_ID + 3))
ID4=$((MAX_ID + 4))

# Remove any existing custom search engines with our keywords
sqlite3 "$WEB_DATA" << EOF
DELETE FROM keywords WHERE keyword IN (':gw', ':gi', ':gn', ':gm');
EOF

# Add our custom search engines
sqlite3 "$WEB_DATA" << EOF
INSERT INTO keywords (id, short_name, keyword, favicon_url, url, safe_for_autoreplace, originating_url, date_created, usage_count, input_encodings, prepopulate_id, sync_guid, last_modified, created_from_play_api, is_active, created_by_policy)
VALUES 
($ID1, 'Google Web (No AI)', ':gw', 'https://www.google.com/favicon.ico', 'https://www.google.com/search?udm=14&q={searchTerms}', 0, '', 13377777777000000, 0, 'UTF-8', 0, 'custom-google-web', 13377777777000000, 0, 1, 0),
($ID2, 'Google Images', ':gi', 'https://www.google.com/favicon.ico', 'https://www.google.com/search?udm=2&q={searchTerms}', 0, '', 13377777778000000, 0, 'UTF-8', 0, 'custom-google-images', 13377777778000000, 0, 1, 0),
($ID3, 'Google News', ':gn', 'https://www.google.com/favicon.ico', 'https://www.google.com/search?udm=12&q={searchTerms}', 0, '', 13377777779000000, 0, 'UTF-8', 0, 'custom-google-news', 13377777779000000, 0, 1, 0),
($ID4, 'Google Maps', ':gm', 'https://www.google.com/favicon.ico', 'https://www.google.com/maps/search/{searchTerms}', 0, '', 13377777780000000, 0, 'UTF-8', 0, 'custom-google-maps', 13377777780000000, 0, 1, 0);
EOF

echo "✅ Added custom search engines to database"

# Verify they were added
echo ""
echo "Verifying custom search engines:"
sqlite3 "$WEB_DATA" "SELECT keyword, short_name FROM keywords WHERE keyword IN (':gw', ':gi', ':gn', ':gm');" | while IFS='|' read keyword name; do
    echo "  $keyword -> $name"
done

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