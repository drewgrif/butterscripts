# Brave Browser Custom Search Engine Configuration

## Key Differences from Firefox

1. **Supports `:` prefix** - Brave allows vim-like keywords like `:gw` (same as Firefox)
2. **Different policy system** - Uses Chromium's JSON policy format
3. **Built-in Brave Search** - Includes privacy-focused Brave Search by default
4. **GUI is more accessible** - Easier to add custom search engines manually

## Manual Configuration in Brave (Easier than Firefox!)

### Adding Custom Search Engines:

1. **Open Brave Settings**
   - Click hamburger menu (☰) → Settings
   - Or navigate to `brave://settings/searchEngines`

2. **In Search Engine settings**:
   - Click "Manage search engines and site search"
   - You'll see three sections: Search engines, Site search, Inactive shortcuts

3. **To add a custom search engine**:
   - Click "Add" button next to "Search engines"
   - Fill in:
     - **Search engine**: Name (e.g., "Google Web Clean")
     - **Keyword**: Shortcut (e.g., `:gw`)
     - **URL**: Search URL with `%s` placeholder

4. **Example entries**:
   ```
   Name: Google Web (Clean)
   Keyword: :gw
   URL: https://www.google.com/search?udm=14&q=%s
   
   Name: DuckDuckGo
   Keyword: :ddg
   URL: https://duckduckgo.com/?q=%s
   
   Name: Google Images
   Keyword: :gi
   URL: https://www.google.com/search?udm=2&q=%s
   ```

## Using Search Keywords in Brave

1. **Click in address bar** (or press `Ctrl+L`)
2. **Type the keyword** (with `:` prefix for vim-like feel)
3. **Press Space or Tab**
4. **Enter search terms**
5. **Press Enter**

### Examples:
- `:gw linux kernel` → Clean Google Web search
- `:ddg privacy tools` → DuckDuckGo search
- `:gi wallpaper` → Google Images search

## Recommended Search Engines for Brave

| Keyword | Search Engine | URL |
|---------|--------------|-----|
| `:b` | Brave Search | `https://search.brave.com/search?q=%s` |
| `:d` | DuckDuckGo | `https://duckduckgo.com/?q=%s` |
| `:gw` | Google Web (clean) | `https://www.google.com/search?udm=14&q=%s` |
| `:gi` | Google Images | `https://www.google.com/search?udm=2&q=%s` |
| `:gn` | Google News | `https://www.google.com/search?udm=12&q=%s` |
| `:gm` | Google Maps | `https://www.google.com/maps/search/%s` |
| `:sx` | SearXNG | `https://searx.be/search?q=%s` or your instance |

**Removed by script:** Qwant (`:q`), Bing (`:b` conflict), Ecosia (`:e`)

## Setting Default Search Engine

1. Go to `brave://settings/searchEngines`
2. Find your preferred search engine
3. Click the three dots menu
4. Select "Make default"

**Recommended defaults:**
- **For privacy**: Brave Search or DuckDuckGo
- **For self-hosters**: Your SearXNG instance

## Script vs Manual Configuration

The `brave_custom_search.sh` script automates this by creating a policy file, but honestly, **Brave's GUI is so straightforward that manual configuration might be easier** unless you're:
- Setting up multiple machines
- Want consistent configuration across systems
- Managing enterprise deployments

## Brave-Specific Privacy Features

Brave already includes:
- **Brave Search** - Their own privacy-focused search engine
- **No tracking** by default
- **Built-in ad blocking**
- **Tor integration** (Private Window with Tor)

So even without customization, Brave is more privacy-friendly than stock Firefox or Chrome.

## Policy File Location (for the script)

- **Linux**: `/etc/brave/policies/managed/`
- **macOS**: `/Library/Managed Preferences/`
- **Windows**: Registry or GPO

The script creates `managed_search_engines.json` in these directories.