# ST Terminal Patch Recommendations

## Current Patches Included

The current ST build includes the following patches:

1. **alpha** - Transparency support
2. **anysize** - Allows ST to be resized to any size, not just by cell increments
3. **bold-is-not-bright** - Prevents bold text from being displayed as bright colors
4. **clipboard** - Clipboard support improvements
5. **delkey** - Fixes delete key behavior
6. **font2** - Fallback font support
7. **scrollback** - Adds scrollback buffer functionality
8. **scrollback-mouse** - Mouse scrolling support

## Critical Missing Patches

### High Priority

1. **xresources** 
   - **Purpose**: Allows configuration via ~/.Xresources file
   - **Benefits**: Change colors, fonts, and other settings without recompiling
   - **Critical for**: User customization and theming
   - **Why important**: Users can personalize ST without modifying source code

2. **boxdraw**
   - **Purpose**: Proper rendering of box-drawing characters
   - **Benefits**: Clean borders and lines in TUI applications
   - **Critical for**: Applications like htop, ranger, ncurses-based tools
   - **Why important**: Without it, box characters often appear broken or misaligned

### Medium Priority

3. **ligatures**
   - **Purpose**: Font ligature support for programming
   - **Benefits**: Better code readability with fonts like Fira Code, JetBrains Mono
   - **Dependencies**: Requires Harfbuzz library
   - **Note**: Can be controversial; some users prefer no ligatures
   - **Compatibility**: Special version needed if using with boxdraw patch

4. **vertcenter**
   - **Purpose**: Vertically centers text lines
   - **Benefits**: Improved text readability and aesthetics
   - **Why useful**: Better visual balance, especially with certain fonts

### Optional Enhancements

5. **copyurl**
   - **Purpose**: Click or select URLs in terminal
   - **Benefits**: Quick URL opening from terminal output
   - **Why useful**: Convenient for development workflows

6. **w3m**
   - **Purpose**: Image preview support in terminal
   - **Benefits**: View images directly in ST
   - **Why useful**: Enhanced functionality for file managers like ranger

## Implementation Considerations

### Patch Compatibility
- The ligatures patch requires a special version to work with boxdraw
- When combining multiple patches, manual conflict resolution may be needed
- Order of patch application can matter

### Dependencies
- **ligatures**: Requires Harfbuzz library (`libharfbuzz-dev` on Debian)
- **w3m**: Requires w3m-img package

## Recommendation

At minimum, consider adding:
1. **xresources** - Essential for user customization
2. **boxdraw** - Critical for TUI applications

These two patches would significantly improve the ST user experience without adding controversial features or heavy dependencies.

## Resources

- [ST Patches Repository](https://st.suckless.org/patches/)
- [ST Flexipatch](https://github.com/bakkeby/st-flexipatch) - Configurable patch selection
- [Pre-patched ST builds](https://github.com/mcrute/st-patched) - Reference implementations