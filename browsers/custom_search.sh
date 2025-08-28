#!/bin/bash
# DESC: Configure custom search engines in Firefox using policies.json
# Sets up privacy-focused search engines with keyboard shortcuts
# Removes default engines (Google, Bing, Wikipedia, Amazon, eBay, DuckDuckGo)
# Adds: Brave (:b), DuckDuckGo (:d), Google variants (:gw, :gi, :gn, :gm), and optional SearXNG (:sx)
# Supports local HTTP SearXNG instances (auto-detects localhost/private IPs)
# To reset: delete /usr/lib/firefox-esr/distribution/policies.json and restart Firefox

set -e

# Find Firefox installation directory
find_firefox_dir() {
    case "$(uname)" in
        Darwin)
            echo "/Applications/Firefox.app/Contents/Resources"
            ;;
        Linux)
            # Try common locations including Firefox ESR
            for dir in /usr/lib/firefox-esr /usr/lib/firefox /opt/firefox /usr/lib64/firefox-esr /usr/lib64/firefox /usr/share/firefox-esr /usr/share/firefox; do
                if [[ -d "$dir" ]]; then
                    echo "$dir"
                    return
                fi
            done
            # Fallback to system-wide config (works for both firefox and firefox-esr)
            if [[ -d "/etc/firefox-esr" ]]; then
                echo "/etc/firefox-esr"
            elif [[ -d "/etc/firefox" ]]; then
                echo "/etc/firefox"
            else
                echo "/etc/firefox"
            fi
            ;;
        *)
            echo "Unsupported OS"
            exit 1
            ;;
    esac
}

FIREFOX_DIR=$(find_firefox_dir)
DIST_DIR="$FIREFOX_DIR/distribution"

echo "Setting up Firefox search engines..."
echo "Firefox directory: $FIREFOX_DIR"

# Ask about SearXNG
echo
echo "SearXNG Setup (Optional)"
echo "========================"
echo "SearXNG is a privacy-focused metasearch engine."
echo "Would you like to add SearXNG search engines?"
read -p "Add SearXNG? (y/N): " -n 1 -r
echo

SEARXNG_ENGINES=""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo
    echo "SearXNG Instance Options:"
    echo "1. Use public instance (searx.be)"
    echo "2. Enter custom instance URL"
    read -p "Choose option (1-2): " -n 1 -r
    echo
    
    case $REPLY in
        1)
            SEARXNG_URL="https://searx.be"
            echo "Using public instance: $SEARXNG_URL"
            ;;
        2)
            echo "Enter your SearXNG instance URL (e.g., https://searx.example.com or http://192.168.1.100:8888):"
            read -r SEARXNG_URL
            # Clean up URL
            SEARXNG_URL="${SEARXNG_URL%/}"  # Remove trailing slash
            
            # Check if URL has protocol
            if [[ ! "$SEARXNG_URL" =~ ^https?:// ]]; then
                # Check if it looks like a local/private IP or localhost
                if [[ "$SEARXNG_URL" =~ ^(localhost|127\.|10\.|172\.(1[6-9]|2[0-9]|3[0-1])\.|192\.168\.) ]]; then
                    SEARXNG_URL="http://$SEARXNG_URL"
                    echo "⚠️  Using HTTP for local instance. Note: Firefox may block HTTP search on HTTPS sites."
                else
                    SEARXNG_URL="https://$SEARXNG_URL"
                fi
            elif [[ "$SEARXNG_URL" =~ ^http:// ]]; then
                echo "⚠️  Warning: Using HTTP protocol. Firefox may block HTTP search on HTTPS sites."
                echo "    This may not work properly unless Firefox is configured to allow mixed content."
            fi
            echo "Using custom instance: $SEARXNG_URL"
            ;;
        *)
            echo "Invalid option, skipping SearXNG"
            ;;
    esac
    
    # Generate SearXNG engines JSON if URL is set
    if [[ -n "$SEARXNG_URL" ]]; then
        SEARXNG_ENGINES=",
        {
          \"Name\": \"SearXNG\",
          \"URLTemplate\": \"$SEARXNG_URL/search?q={searchTerms}\",
          \"Method\": \"GET\",
          \"IconURL\": \"$SEARXNG_URL/favicon.ico\",
          \"Alias\": \":sx\",
          \"Description\": \"SearXNG Privacy Search\"
        }"
        echo "✅ SearXNG engines configured for: $SEARXNG_URL"
    fi
else
    echo "Skipping SearXNG setup"
fi

# Set default search engine based on user choice
if [[ -n "$SEARXNG_URL" ]]; then
    DEFAULT_SEARCH="SearXNG"
    echo "Setting SearXNG as default search engine..."
else
    DEFAULT_SEARCH="DuckDuckGo Search"
    echo "Setting DuckDuckGo as default search engine..."
fi

# Create distribution directory if it doesn't exist
sudo mkdir -p "$DIST_DIR"

# Create policies.json with search engines
sudo tee "$DIST_DIR/policies.json" > /dev/null << EOF
{
  "policies": {
    "SearchEngines": {
      "Remove": ["Google", "Bing", "Wikipedia (en)", "Amazon.com", "eBay", "DuckDuckGo"],
      ${DEFAULT_SEARCH:+"\"Default\": \"$DEFAULT_SEARCH\","}
      "Add": [
        {
          "Name": "Brave Search",
          "URLTemplate": "https://search.brave.com/search?q={searchTerms}",
          "Method": "GET",
          "IconURL": "https://search.brave.com/favicon.ico",
          "Alias": ":b",
          "Description": "Brave Privacy Search"
        },
        {
          "Name": "DuckDuckGo Search",
          "URLTemplate": "https://duckduckgo.com/?q={searchTerms}",
          "Method": "GET",
          "IconURL": "https://duckduckgo.com/favicon.ico",
          "Alias": ":d", 
          "Description": "DuckDuckGo Privacy Search"
        },
        {
          "Name": "Google Web",
          "URLTemplate": "https://www.google.com/search?udm=14&q={searchTerms}",
          "Method": "GET",
          "IconURL": "https://www.google.com/favicon.ico",
          "Alias": ":gw",
          "Description": "Google Web Search (text only)"
        },
        {
          "Name": "Google Images", 
          "URLTemplate": "https://www.google.com/search?udm=2&q={searchTerms}",
          "Method": "GET",
          "IconURL": "https://www.google.com/favicon.ico",
          "Alias": ":gi",
          "Description": "Google Image Search"
        },
        {
          "Name": "Google News",
          "URLTemplate": "https://www.google.com/search?udm=12&q={searchTerms}",
          "Method": "GET", 
          "IconURL": "https://www.google.com/favicon.ico",
          "Alias": ":gn",
          "Description": "Google News Search"
        },
        {
          "Name": "Google Maps",
          "URLTemplate": "https://www.google.com/maps/search/{searchTerms}",
          "Method": "GET",
          "IconURL": "https://www.google.com/favicon.ico", 
          "Alias": ":gm",
          "Description": "Google Maps Search"
        }$SEARXNG_ENGINES
      ]
    }
  }
}
EOF

echo "✅ Firefox search engines configured!"
echo ""
echo "Restart Firefox to see the new search engines."
if [[ -n "$SEARXNG_URL" ]]; then
    echo "Default search engine: SearXNG ($SEARXNG_URL)"
else
    echo "Default search engine: DuckDuckGo (privacy-focused)"
fi
echo ""
echo "You can use them with keywords like:"
echo "  :b search term     -> Brave Search"
echo "  :d search term     -> DuckDuckGo"
echo "  :gw search term    -> Google Web"
echo "  :gi search term    -> Google Images" 
echo "  :gn search term    -> Google News"
echo "  :gm search term    -> Google Maps"

if [[ -n "$SEARXNG_URL" ]]; then
    echo "  :sx search term    -> SearXNG (default)"
fi

echo ""
echo "The search engines will appear in Settings > Search"
