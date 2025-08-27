# Firefox Custom Search Engine Configuration Guide

## What the Script Does

The `custom_search.sh` script automates adding custom search engines to Firefox/Firefox ESR by creating a `policies.json` file. This configures:

- **Removes** default search engines (Google, Bing, Wikipedia, Amazon, eBay, DuckDuckGo)
- **Adds** privacy-focused alternatives with keyboard shortcuts
- **Configures** Google searches to use clean `udm` parameters (no AI summaries)
- **Optionally sets up** SearXNG metasearch engine

## Why Custom Search Engines?

1. **Cleaner Google results** - The `udm=14` parameter gives traditional blue links without AI overviews, ads panels, or "People also ask" boxes
2. **Vim-like shortcuts** - Uses `:` prefix (like vim commands) for muscle memory - `:gw` for Google Web, `:gi` for images, etc.
3. **Privacy options** - DuckDuckGo and SearXNG don't track searches
4. **Specialized searches** - Direct shortcuts to images, news, maps, videos

## Recommended Default Search Engine

**For most users: Set DuckDuckGo as your default** - It's private, no tracking, and works immediately.

**For advanced users: Self-host SearXNG** on TrueNAS Scale or similar for maximum privacy and control. When running the script, choose option 2 for custom instance and enter your self-hosted URL:
- Local network: `http://192.168.1.100:8888`
- Custom domain: `https://search.justaguylinux.com`

## Configured Shortcuts

| Shortcut | Search Engine | Description |
|----------|--------------|-------------|
| `:b` | Brave Search | Privacy-focused search |
| `:d` | DuckDuckGo | Privacy-focused search |
| `:gw` | Google Web | Clean text-only results (no AI/widgets) |
| `:gi` | Google Images | Image search |
| `:gn` | Google News | News search |
| `:gm` | Google Maps | Maps/location search |
| `:sx` | SearXNG | Privacy metasearch (optional) |

## How to Use Search Shortcuts in the Omnibar

1. **Click in the address bar** (or press `Ctrl+L` or `F6`)
2. **Type the shortcut** followed by a space
3. **Enter your search terms**
4. **Press Enter**

### Examples:
- `:b privacy guide` → Searches Brave Search for "privacy guide"
- `:d linux tutorial` → Searches DuckDuckGo for "linux tutorial"
- `:gw linux kernel` → Searches Google Web for "linux kernel" 
- `:gi sunset wallpaper` → Searches Google Images for "sunset wallpaper"
- `:gm pizza near me` → Searches Google Maps for "pizza near me"
- Just type normally → Uses your default (ideally DuckDuckGo, Brave, or self-hosted SearXNG)

The `:` prefix makes it feel like entering command mode in vim - quick and distinctive from regular typing.

## Manual Configuration (GUI Method)

### To Add Custom Search Engines in Firefox:

1. **Open Firefox Settings**
   - Click hamburger menu (☰) → Settings
   - Or type `about:preferences#search` in address bar

2. **In the Search panel**:
   - Scroll down to "Search Shortcuts" section
   - You'll see existing search engines listed

3. **To add a search engine**:
   - Click "Find more search engines" link at bottom
   - OR use "Add" button if available
   - For custom URLs, you may need to:
     - Visit the search site
     - Right-click address bar
     - Select "Add [Site Name]" if offered

4. **To set keywords**:
   - Double-click the "Keyword" column for each engine
   - Enter shortcuts like `:gw`, `:d`, `:b`, etc. (the `:` prefix mimics vim command mode)

5. **To remove engines**:
   - Select the engine
   - Click "Remove" button

6. **To set default search**:
   - In Search settings, find "Default Search Engine" dropdown
   - Select DuckDuckGo (recommended for privacy)

### The Search URLs You'd Want:

- **Brave Search**: `https://search.brave.com/search?q=%s` (privacy-focused)
- **DuckDuckGo**: `https://duckduckgo.com/?q=%s` (RECOMMENDED as default)
- **Google Web (clean)**: `https://www.google.com/search?udm=14&q=%s`
- **Google Images**: `https://www.google.com/search?udm=2&q=%s`
- **Google News**: `https://www.google.com/search?udm=12&q=%s`
- **Google Maps**: `https://www.google.com/maps/search/%s`
- **Self-hosted SearXNG**: 
  - Local: `http://192.168.1.100:8888/search?q=%s`
  - Custom domain: `https://search.yourdomain.com/search?q=%s`

Note: `%s` is the search term placeholder in Firefox.

### What the Script Automates:

Instead of manually adding each engine through Settings, the script creates a system-wide policy file that automatically configures all search engines at once, including removing unwanted defaults and setting up keyboard shortcuts - essentially doing all the above steps programmatically on every Firefox restart.

## How to Reset to Default Search Engines

If you want to restore Firefox's original search engines:

1. **Quick method**: Delete the policies file
   ```bash
   sudo rm /usr/lib/firefox-esr/distribution/policies.json
   # or
   sudo rm /etc/firefox-esr/policies.json
   ```
   Then restart Firefox.

2. **Through Firefox Settings**:
   - Go to Settings → Search
   - Click "Restore Default Search Engines" button
   - Remove custom engines via the three-dot menu

## SearXNG Instance Options

The script supports various SearXNG configurations:

1. **Public instance**: Uses searx.be (default option 1)
2. **Local network instance**: Auto-detects private IPs and uses HTTP
   - Example: `http://192.168.1.100:30053`
3. **Custom domain via Cloudflare/reverse proxy**: Uses HTTPS
   - Example: `https://search.justaguylinux.com`

**Note**: For local HTTP instances, Firefox may block searches when on HTTPS sites due to mixed content restrictions. Custom domains with HTTPS work seamlessly.