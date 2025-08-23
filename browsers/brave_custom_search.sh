#!/bin/bash
# DESC: Configure custom search engines in Brave browser using policies
# Note: Brave uses Chromium's policy system

set -e

# Find Brave installation directory and policy location
find_brave_policy_dir() {
    case "$(uname)" in
        Darwin)
            echo "/Library/Managed Preferences"
            ;;
        Linux)
            # Brave on Linux uses these policy directories
            if [[ -d "/etc/brave/policies/managed" ]]; then
                echo "/etc/brave/policies/managed"
            elif [[ -d "/etc/chromium-browser/policies/managed" ]]; then
                # Some distros use chromium policy dir for Brave
                echo "/etc/chromium-browser/policies/managed"
            else
                # Create the standard location
                echo "/etc/brave/policies/managed"
            fi
            ;;
        *)
            echo "Unsupported OS"
            exit 1
            ;;
    esac
}

POLICY_DIR=$(find_brave_policy_dir)

echo "Setting up Brave browser search engines..."
echo "Policy directory: $POLICY_DIR"

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
            echo "Enter your SearXNG instance URL (e.g., https://searx.example.com):"
            read -r SEARXNG_URL
            # Clean up URL
            SEARXNG_URL="${SEARXNG_URL%/}"  # Remove trailing slash
            if [[ ! "$SEARXNG_URL" =~ ^https?:// ]]; then
                SEARXNG_URL="https://$SEARXNG_URL"
            fi
            echo "Using custom instance: $SEARXNG_URL"
            ;;
        *)
            echo "Invalid option, skipping SearXNG"
            ;;
    esac
    
    # Generate SearXNG engines JSON if URL is set
    if [[ -n "$SEARXNG_URL" ]]; then
        SEARXNG_ENGINES=',
    {
      "name": "SearXNG",
      "keyword": ":sx",
      "url": "'$SEARXNG_URL'/search?q={searchTerms}"
    },
    {
      "name": "SearXNG Images",
      "keyword": ":sxi",
      "url": "'$SEARXNG_URL'/search?q={searchTerms}&categories=images"
    },
    {
      "name": "SearXNG News",
      "keyword": ":sxn",
      "url": "'$SEARXNG_URL'/search?q={searchTerms}&categories=news"
    },
    {
      "name": "SearXNG Videos",
      "keyword": ":sxv",
      "url": "'$SEARXNG_URL'/search?q={searchTerms}&categories=videos"
    }'
        echo "✅ SearXNG engines configured for: $SEARXNG_URL"
    fi
else
    echo "Skipping SearXNG setup"
fi

# Create policy directory if it doesn't exist
sudo mkdir -p "$POLICY_DIR"

# Create Brave/Chromium policy file
# Note: Brave uses the Chromium policy format
# Note: Brave and DuckDuckGo already have :br and :d shortcuts by default
sudo tee "$POLICY_DIR/managed_search_engines.json" > /dev/null << EOF
{
  "ManagedSearchEngines": [
    {
      "name": "Google Web",
      "keyword": ":gw",
      "url": "https://www.google.com/search?udm=14&q={searchTerms}"
    },
    {
      "name": "Google Images",
      "keyword": ":gi",
      "url": "https://www.google.com/search?udm=2&q={searchTerms}"
    },
    {
      "name": "Google News",
      "keyword": ":gn",
      "url": "https://www.google.com/search?udm=12&q={searchTerms}"
    },
    {
      "name": "Google Maps",
      "keyword": ":gm",
      "url": "https://www.google.com/maps/search/{searchTerms}"
    }$SEARXNG_ENGINES
  ],
  "DefaultSearchProviderEnabled": true,
  "DefaultSearchProviderSearchURL": "https://search.brave.com/search?q={searchTerms}",
  "DefaultSearchProviderName": "Brave",
  "ManagedSearchEnginesRemove": ["Qwant", "Bing", "Ecosia"]
}
EOF

echo "✅ Brave search engines configured!"
echo ""
echo "Restart Brave to see the new search engines."
echo ""
echo "Removed search engines: Qwant, Bing, Ecosia"
echo ""
echo "Available shortcuts:"
echo "  :b search term     -> Brave Search (was :br, now shorter!)"
echo "  :d search term     -> DuckDuckGo (existing)"
echo "  :gw search term    -> Google Web (clean, no AI)"
echo "  :gi search term    -> Google Images"
echo "  :gn search term    -> Google News"
echo "  :gm search term    -> Google Maps"

if [[ -n "$SEARXNG_URL" ]]; then
    echo "  :sx search term    -> SearXNG"
    echo "  :sxi search term   -> SearXNG Images"
    echo "  :sxn search term   -> SearXNG News"
    echo "  :sxv search term   -> SearXNG Videos"
fi

echo ""
echo "Note: The ':' prefix gives a vim-like feel for quick search access."
echo "The search engines will appear in Settings > Search engine > Manage search engines"