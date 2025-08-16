#!/bin/bash
# DESC: Install Geany text editor - choice of APT package (2.0) or source compilation (2.1)

# Geany Installation Script with Version Choice

set -e

# Color codes
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

GEANY_VERSION="2.1"
GEANY_PLUGINS_VERSION="2.1"

# Function to display header
show_header() {
    clear
    echo -e "${CYAN}=========================================================${NC}"
    echo -e "${CYAN}                  GEANY INSTALLER                        ${NC}"
    echo -e "${CYAN}=========================================================${NC}"
    echo
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

# Function to install Geany from APT
install_geany_apt() {
    echo -e "${CYAN}Installing Geany from APT repositories...${NC}"
    echo -e "${YELLOW}This will install the stable Debian package version.${NC}"
    echo -e "${YELLOW}Version 2.0 on Debian 13 (Trixie), 1.38 on Debian 12 (Bookworm)${NC}"
    echo
    
    # Update package lists
    echo -e "${YELLOW}Updating package lists...${NC}"
    sudo apt update
    
    # Install Geany and common plugins
    echo -e "${YELLOW}Installing Geany and plugins...${NC}"
    sudo apt install -y geany geany-plugins
    
    echo -e "${GREEN}Geany installation completed!${NC}"
    echo -e "${YELLOW}Geany has been installed from APT packages.${NC}"
    echo -e "${YELLOW}All plugins including markdown preview should work correctly.${NC}"
    
    # Ask about applying config
    echo
    if ask_yes_no "Apply butterscripts configuration?"; then
        apply_butterscripts_config
    fi
}

# Function to install Geany from source
install_geany_source() {
    echo -e "${CYAN}Installing Geany 2.1 from source...${NC}"
    echo -e "${YELLOW}This will compile the latest version with all features.${NC}"
    echo

    # Install build dependencies
    echo -e "${YELLOW}Installing build dependencies...${NC}"
    if command -v apt &> /dev/null; then
        sudo apt update
        sudo apt install -y build-essential autoconf automake libtool intltool \
            libgtk-3-dev libxml2-dev libxml2-utils python3-docutils \
            python3-lxml rst2pdf git meson ninja-build \
            libglib2.0-dev libgirepository1.0-dev \
            libenchant-2-dev libgit2-dev libgpgme-dev libsoup2.4-dev \
            libctpl-dev libmarkdown2-dev libwebkit2gtk-4.1-dev \
            check cppcheck valac
    elif command -v dnf &> /dev/null; then
        sudo dnf groupinstall -y "Development Tools"
        sudo dnf install -y gtk3-devel intltool python3-docutils \
            glib2-devel gobject-introspection-devel \
            enchant2-devel libgit2-devel gpgme-devel libsoup-devel \
            ctpl-devel libmarkdown-devel webkit2gtk3-devel \
            check cppcheck vala meson ninja-build
    else
        echo -e "${RED}Error: Unsupported package manager${NC}"
        exit 1
    fi

    # Build Geany
    BUILD_DIR="$HOME/build-geany-${GEANY_VERSION}"
    mkdir -p "$BUILD_DIR"
    cd "$BUILD_DIR"
    
    # Download with error handling
    echo -e "${YELLOW}Downloading Geany ${GEANY_VERSION}...${NC}"
    if ! wget -q --show-progress "https://download.geany.org/geany-${GEANY_VERSION}.tar.bz2"; then
        echo -e "${RED}Failed to download Geany source${NC}"
        cd "$HOME"
        rm -rf "$BUILD_DIR"
        exit 1
    fi
    
    echo -e "${YELLOW}Extracting source...${NC}"
    tar -xjf "geany-${GEANY_VERSION}.tar.bz2"
    cd "geany-${GEANY_VERSION}"
    
    echo -e "${YELLOW}Configuring build...${NC}"
    if ! ./configure --prefix="$HOME/.local" --enable-gtk3; then
        echo -e "${RED}Configuration failed${NC}"
        cd "$HOME"
        rm -rf "$BUILD_DIR"
        exit 1
    fi
    
    echo -e "${YELLOW}Building Geany (this may take a few minutes)...${NC}"
    if ! make -j$(nproc); then
        echo -e "${RED}Build failed${NC}"
        cd "$HOME"
        rm -rf "$BUILD_DIR"
        exit 1
    fi
    
    echo -e "${YELLOW}Installing Geany to ~/.local...${NC}"
    if ! make install; then
        echo -e "${RED}Installation failed${NC}"
        cd "$HOME"
        rm -rf "$BUILD_DIR"
        exit 1
    fi

    # Build plugins
    echo -e "${YELLOW}Building Geany plugins...${NC}"
    cd "$BUILD_DIR"
    
    # Try multiple download sources
    echo -e "${YELLOW}Downloading Geany plugins ${GEANY_PLUGINS_VERSION}...${NC}"
    if ! wget -q --show-progress "https://plugins.geany.org/geany-plugins/geany-plugins-${GEANY_PLUGINS_VERSION}.tar.bz2"; then
        echo -e "${YELLOW}Trying alternate download source...${NC}"
        if ! wget -q --show-progress "https://github.com/geany/geany-plugins/releases/download/${GEANY_PLUGINS_VERSION}/geany-plugins-${GEANY_PLUGINS_VERSION}.tar.bz2"; then
            echo -e "${YELLOW}Warning: Could not download plugins. Continuing without plugins...${NC}"
        fi
    fi
    
    if [ -f "geany-plugins-${GEANY_PLUGINS_VERSION}.tar.bz2" ]; then
        echo -e "${YELLOW}Extracting plugins...${NC}"
        tar -xjf "geany-plugins-${GEANY_PLUGINS_VERSION}.tar.bz2"
        cd "geany-plugins-${GEANY_PLUGINS_VERSION}"
        
        export PKG_CONFIG_PATH="$HOME/.local/lib/pkgconfig:$PKG_CONFIG_PATH"
        
        echo -e "${YELLOW}Configuring plugins build...${NC}"
        if ./configure --prefix="$HOME/.local" --with-geany-libdir="$HOME/.local/lib"; then
            echo -e "${YELLOW}Building plugins (this may take a few minutes)...${NC}"
            if make -j$(nproc); then
                echo -e "${YELLOW}Installing plugins...${NC}"
                make install
            else
                echo -e "${YELLOW}Warning: Plugin build failed. Continuing without plugins...${NC}"
            fi
        else
            echo -e "${YELLOW}Warning: Plugin configuration failed. Continuing without plugins...${NC}"
        fi
    fi

    # Create desktop file
    echo -e "${YELLOW}Creating desktop entry...${NC}"
    DESKTOP_DIR="$HOME/.local/share/applications"
    mkdir -p "$DESKTOP_DIR"

if command -v /usr/bin/geany &> /dev/null; then
    cat > "$DESKTOP_DIR/geany-2.1.desktop" << EOF
[Desktop Entry]
Type=Application
Version=1.0
Name=Geany 2.1
GenericName=Integrated Development Environment
Comment=A fast and lightweight IDE using GTK+
Exec=$HOME/.local/bin/geany %F
Icon=geany
Terminal=false
Categories=GTK;Development;IDE;TextEditor;
MimeType=text/plain;text/x-chdr;text/x-csrc;text/x-c++hdr;text/x-c++src;text/x-java;text/x-dsrc;text/x-pascal;text/x-perl;text/x-python;application/x-php;application/x-httpd-php3;application/x-httpd-php4;application/x-httpd-php5;application/xml;text/html;text/css;text/x-sql;text/x-diff;
StartupNotify=true
Keywords=Text;Editor;
EOF
else
    cat > "$DESKTOP_DIR/geany.desktop" << EOF
[Desktop Entry]
Type=Application
Version=1.0
Name=Geany
GenericName=Integrated Development Environment
Comment=A fast and lightweight IDE using GTK+
Exec=$HOME/.local/bin/geany %F
Icon=geany
Terminal=false
Categories=GTK;Development;IDE;TextEditor;
MimeType=text/plain;text/x-chdr;text/x-csrc;text/x-c++hdr;text/x-c++src;text/x-java;text/x-dsrc;text/x-pascal;text/x-perl;text/x-python;application/x-php;application/x-httpd-php3;application/x-httpd-php4;application/x-httpd-php5;application/xml;text/html;text/css;text/x-sql;text/x-diff;
StartupNotify=true
Keywords=Text;Editor;
EOF
fi

    # Clean up
    echo -e "${YELLOW}Cleaning up build files...${NC}"
    cd "$HOME"
    rm -rf "$BUILD_DIR"

    # Create system-wide symlink
    if [ ! -e /usr/local/bin/geany ]; then
        echo -e "${YELLOW}Creating system-wide symlink...${NC}"
        sudo ln -s "$HOME/.local/bin/geany" /usr/local/bin/geany
    fi

    # Update PATH if needed
    if ! echo "$PATH" | grep -q "$HOME/.local/bin"; then
        echo -e "${YELLOW}Adding ~/.local/bin to PATH...${NC}"
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
    fi

    echo -e "${GREEN}Geany 2.1 built from source successfully!${NC}"
    
    # Ask about applying config
    echo
    if ask_yes_no "Apply butterscripts configuration?"; then
        apply_butterscripts_config
    fi
}

# Function to apply butterscripts configuration
apply_butterscripts_config() {
    CONFIG_DIR="$HOME/.config/geany"
    mkdir -p "$CONFIG_DIR"
    
    [ -f "$CONFIG_DIR/geany.conf" ] && echo "Warning: Overwriting existing config" && sleep 2
    
    # Get color schemes
    COLORSCHEMES_DIR="$CONFIG_DIR/colorschemes"
    mkdir -p "$COLORSCHEMES_DIR"
    EXISTING_SCHEMES=$(ls "$COLORSCHEMES_DIR"/*.conf 2>/dev/null | wc -l)
    
    if [ "$EXISTING_SCHEMES" -lt 5 ]; then
        TEMP_THEMES_DIR="/tmp/geany-themes"
        [ -d "$TEMP_THEMES_DIR" ] && rm -rf "$TEMP_THEMES_DIR"
        git clone -q https://github.com/drewgrif/geany-themes.git "$TEMP_THEMES_DIR"
        [ -d "$TEMP_THEMES_DIR" ] && cp "$TEMP_THEMES_DIR/colorschemes"/*.conf "$COLORSCHEMES_DIR/" 2>/dev/null
        rm -rf "$TEMP_THEMES_DIR"
    fi
    
    # Detect plugins - check both system and local installations
    PLUGIN_PATHS=""
    PLUGIN_DIRS=("$HOME/.local/lib/geany" "/usr/lib/x86_64-linux-gnu/geany" "/usr/lib/geany")
    WANTED_PLUGINS=("addons" "automark" "git-changebar" "geanyinsertnum" "markdown" "spellcheck" "splitwindow" "treebrowser")
    
    for dir in "${PLUGIN_DIRS[@]}"; do
        if [ -d "$dir" ]; then
            for plugin in "${WANTED_PLUGINS[@]}"; do
                if [ -f "$dir/$plugin.so" ]; then
                    [ -n "$PLUGIN_PATHS" ] && PLUGIN_PATHS="$PLUGIN_PATHS;"
                    PLUGIN_PATHS="${PLUGIN_PATHS}$dir/$plugin.so"
                fi
            done
            # If we found plugins in this directory, stop searching
            [ -n "$PLUGIN_PATHS" ] && break
        fi
    done
    
    # Main config
    cat > "$CONFIG_DIR/geany.conf" << EOF
[geany]
default_open_path=
cmdline_new_files=true
notebook_double_click_hides_widgets=false
tab_close_switch_to_mru=false
tab_pos_sidebar=2
sidebar_pos=0
symbols_sort_mode=0
msgwin_orientation=0
highlighting_invert_all=false
pref_main_search_use_current_word=true
check_detect_indent=false
detect_indent_width=false
use_tab_to_indent=true
pref_editor_tab_width=4
indent_mode=2
indent_type=0
virtualspace=1
autocomplete_doc_words=false
completion_drops_rest_of_word=false
autocompletion_max_entries=30
autocompletion_update_freq=250
color_scheme=github-dark-default.conf
scroll_lines_around_cursor=0
mru_length=10
disk_check_timeout=30
show_editor_scrollbars=false
brace_match_ltgt=false
use_gtk_word_boundaries=true
complete_snippets_whilst_editing=false
indent_hard_tab_width=8
editor_ime_interaction=0
use_atomic_file_saving=false
gio_unsafe_save_backup=false
use_gio_unsafe_file_saving=true
keep_edit_history_on_reload=true
show_keep_edit_history_on_reload_msg=false
reload_clean_doc_on_file_change=false
save_config_on_file_change=true
extract_filetype_regex=-\\*-\\s*([^\\s]+)\\s*-\\*-
allow_always_save=false
find_selection_type=0
replace_and_find_by_default=true
show_symbol_list_expanders=true
compiler_tab_autoscroll=true
statusbar_template=line: %l / %L	 col: %c	 sel: %s	 %w      %t      %mmode: %M      encoding: %e      filetype: %f      scope: %S
new_document_after_close=false
msgwin_status_visible=true
msgwin_compiler_visible=true
msgwin_messages_visible=true
msgwin_scribble_visible=true
documents_show_paths=true
sidebar_page=2
pref_main_load_session=true
pref_main_project_session=true
pref_main_project_file_in_basedir=false
pref_main_save_winpos=true
pref_main_save_wingeom=true
pref_main_confirm_exit=false
pref_main_suppress_status_messages=false
switch_msgwin_pages=false
beep_on_errors=true
auto_focus=false
sidebar_symbol_visible=false
sidebar_openfiles_visible=false
editor_font=SauceCodePro Nerd Font Mono Regular 16
tagbar_font=Sans 9
msgwin_font=SauceCodePro Nerd Font Mono Regular 12
show_notebook_tabs=true
show_tab_cross=true
tab_order_ltr=true
tab_order_beside=false
tab_pos_editor=2
tab_pos_msgwin=0
use_native_windows_dialogs=false
show_indent_guide=false
show_white_space=false
show_line_endings=false
show_markers_margin=true
show_linenumber_margin=true
long_line_enabled=false
long_line_type=0
long_line_column=72
long_line_color=#C2EBC2
symbolcompletion_max_height=10
symbolcompletion_min_chars=4
use_folding=true
unfold_all_children=false
use_indicators=true
line_wrapping=true
auto_close_xml_tags=true
complete_snippets=true
auto_complete_symbols=true
pref_editor_disable_dnd=false
pref_editor_smart_home_key=true
pref_editor_newline_strip=false
line_break_column=72
auto_continue_multiline=true
comment_toggle_mark=~ 
scroll_stop_at_last_line=true
autoclose_chars=0
pref_editor_default_new_encoding=UTF-8
pref_editor_default_open_encoding=none
default_eol_character=2
pref_editor_new_line=true
pref_editor_ensure_convert_line_endings=false
pref_editor_replace_tabs=false
pref_editor_trail_space=false
pref_toolbar_show=false
pref_toolbar_append_to_menu=true
pref_toolbar_use_gtk_default_style=false
pref_toolbar_use_gtk_default_icon=false
pref_toolbar_icon_style=3
pref_toolbar_icon_size=0
pref_template_developer=
pref_template_company=
pref_template_mail=
pref_template_initial=
pref_template_version=1.0
pref_template_year=%Y
pref_template_date=%Y-%m-%d
pref_template_datetime=%d.%m.%Y %H:%M:%S %Z
context_action_cmd=
sidebar_visible=true
statusbar_visible=true
msgwindow_visible=false
fullscreen=false
color_picker_palette=
scribble_text=Type here what you want, use it as a notice/scratch board
scribble_pos=0
treeview_position=200
msgwindow_position=500
geometry=0;0;1200;800;0;
custom_date_format=

[build-menu]
number_ft_menu_items=0
number_non_ft_menu_items=0
number_exec_menu_items=0

[search]
pref_search_hide_find_dialog=false
pref_search_always_wrap=false
pref_search_current_file_dir=true
find_all_expanded=false
replace_all_expanded=true
position_find_x=-1
position_find_y=-1
position_replace_x=-1
position_replace_y=-1
position_fif_x=-1
position_fif_y=-1
fif_regexp=false
fif_case_sensitive=true
fif_match_whole_word=false
fif_invert_results=false
fif_recursive=false
fif_extra_options=
fif_use_extra_options=false
fif_files=
fif_files_mode=0
find_regexp=false
find_regexp_multiline=false
find_case_sensitive=false
find_escape_sequences=false
find_match_whole_word=false
find_match_word_start=false
find_close_dialog=true
replace_regexp=false
replace_regexp_multiline=false
replace_case_sensitive=false
replace_escape_sequences=false
replace_match_whole_word=false
replace_match_word_start=false
replace_search_backwards=false
replace_close_dialog=true

[plugins]
load_plugins=true
custom_plugin_path=
active_plugins=$PLUGIN_PATHS

[VTE]
send_cmd_prefix=
send_selection_unsafe=false
load_vte=true
font=SauceCodePro Nerd Font Mono Regular 14
scroll_on_key=true
scroll_on_out=true
enable_bash_keys=true
ignore_menu_bar_accel=false
follow_path=false
run_in_vte=false
skip_run_script=false
cursor_blinks=false
scrollback_lines=500
shell=/bin/bash
colour_fore=#FFFFFF
colour_back=#000000
last_dir=$HOME

[tools]
terminal_cmd=x-terminal-emulator -e "/bin/sh %c"
browser_cmd=sensible-browser
grep_cmd=grep

[printing]
print_cmd=
use_gtk_printing=true
print_line_numbers=true
print_page_numbers=true
print_page_header=true
page_header_basename=false
page_header_datefmt=%c

[project]
session_file=
project_file_path=$HOME/projects

[files]
recent_files=
recent_projects=
current_page=0
EOF

    # Keybindings
    cat > "$CONFIG_DIR/keybindings.conf" << 'EOF'
[Bindings]
menu_new=<Primary>n
menu_open=<Primary>o
menu_open_selected=<Primary><Shift>o
menu_save=<Primary>s
menu_saveas=
menu_saveall=<Primary><Shift>s
file_properties=<Primary><Shift>v
menu_print=<Primary>p
menu_close=<Primary>w
menu_closeall=<Primary><Shift>w
menu_reloadfile=<Primary>r
menu_reloadall=
file_openlasttab=
menu_quit=<Primary>q
menu_undo=<Primary>z
menu_redo=<Primary>y
edit_duplicateline=<Primary>d
edit_deleteline=<Primary>k
edit_deletelinetoend=<Primary><Shift>Delete
edit_deletelinetobegin=<Primary><Shift>BackSpace
edit_transposeline=
edit_scrolltoline=<Primary><Shift>l
edit_scrolllineup=<Alt>Up
edit_scrolllinedown=<Alt>Down
edit_completesnippet=Tab
move_snippetnextcursor=
edit_suppresssnippetcompletion=
popup_contextaction=
edit_autocomplete=<Primary>space
edit_calltip=<Primary><Shift>space
edit_wordpartcompletion=Tab
edit_movelineup=<Alt>Page_Up
edit_movelinedown=<Alt>Page_Down
menu_cut=<Primary>x
menu_copy=<Primary>c
menu_paste=<Primary>v
edit_copyline=<Primary><Shift>c
edit_cutline=<Primary><Shift>x
menu_selectall=<Primary>a
edit_selectword=<Shift><Alt>w
edit_selectline=<Shift><Alt>l
edit_selectparagraph=<Shift><Alt>p
edit_selectwordpartleft=
edit_selectwordpartright=
edit_togglecase=<Primary><Alt>u
edit_commentlinetoggle=<Primary>e
edit_commentline=
edit_uncommentline=
edit_increaseindent=<Primary>i
edit_decreaseindent=<Primary>u
edit_increaseindentbyspace=
edit_decreaseindentbyspace=
edit_autoindent=
edit_sendtocmd1=<Primary>1
edit_sendtocmd2=<Primary>2
edit_sendtocmd3=<Primary>3
edit_sendtocmd4=
edit_sendtocmd5=
edit_sendtocmd6=
edit_sendtocmd7=
edit_sendtocmd8=
edit_sendtocmd9=
edit_sendtovte=
format_reflowparagraph=<Primary>j
edit_joinlines=
menu_insert_date=<Shift><Alt>d
edit_insertwhitespace=
edit_insertlinebefore=
edit_insertlineafter=
menu_preferences=<Primary><Alt>p
menu_pluginpreferences=
menu_find=<Primary>f
menu_findnext=<Primary>g
menu_findprevious=<Primary><Shift>g
menu_findnextsel=
menu_findprevsel=
menu_replace=<Primary>h
menu_findinfiles=<Primary><Shift>f
menu_nextmessage=
menu_previousmessage=
popup_findusage=<Primary><Shift>e
popup_finddocumentusage=<Primary><Shift>d
find_markall=<Primary><Shift>m
nav_back=<Alt>Left
nav_forward=<Alt>Right
menu_gotoline=<Primary>l
edit_gotomatchingbrace=<Primary>b
edit_togglemarker=<Primary>m
edit_gotonextmarker=<Primary>period
edit_gotopreviousmarker=<Primary>comma
popup_gototagdefinition=<Primary>t
popup_gototagdeclaration=<Primary><Shift>t
edit_gotolinestart=Home
edit_gotolineend=End
edit_gotolinestartvisual=<Alt>Home
edit_gotolineendvisual=<Alt>End
edit_prevwordstart=<Primary>slash
edit_nextwordstart=<Primary>backslash
menu_toggleall=
menu_fullscreen=F11
menu_messagewindow=<Alt>period
toggle_sidebar=<Alt>comma
menu_zoomin=<Primary>plus
menu_zoomout=<Primary>minus
normal_size=<Primary>0
menu_linewrap=
menu_linebreak=
menu_clone=
menu_strip_trailing_spaces=
menu_replacetabs=
menu_replacespaces=
menu_togglefold=
menu_foldall=
menu_unfoldall=
reloadtaglist=<Primary><Shift>r
remove_markers=
remove_error_indicators=
remove_markers_and_indicators=
project_new=
project_open=
project_properties=
project_close=
build_compile=F8
build_link=F9
build_make=<Shift>F9
build_makeowntarget=<Primary><Shift>F9
build_makeobject=<Shift>F8
build_nexterror=
build_previouserror=
build_run=F5
build_options=
menu_opencolorchooser=
menu_help=F1
switch_editor=F2
switch_search_bar=F7
switch_message_window=
switch_compiler=
switch_messages=
switch_scribble=F6
switch_vte=F4
switch_sidebar=
switch_sidebar_symbol_list=
switch_sidebar_doc_list=
switch_tableft=<Primary>Page_Up
switch_tabright=<Primary>Page_Down
switch_tablastused=<Primary>Tab
move_tableft=<Primary><Shift>Page_Up
move_tabright=<Primary><Shift>Page_Down
move_tabfirst=
move_tablast=

[addons]
focus_bookmark_list=
focus_tasks=
update_tasks=
xml_tagging=
copy_file_path=
Enclose_1=
Enclose_2=
Enclose_3=
Enclose_4=
Enclose_5=
Enclose_6=
Enclose_7=
Enclose_8=

[git-changebar]
goto-prev-hunk=
goto-next-hunk=
undo-hunk=

[insert_numbers]
insert_numbers=

[spellcheck]
spell_check=
spell_toggle_typing=

[split_window]
split_horizontal=
split_vertical=
split_unsplit=

[file_browser]
focus_file_list=
focus_path_entry=
rename_object=
create_file=
create_dir=
rename_refresh=
track_current=
EOF

    # Plugin configs
    mkdir -p "$CONFIG_DIR/plugins/markdown"
    cat > "$CONFIG_DIR/plugins/markdown/markdown.conf" << 'EOF'
[markdown]
preview_in_msgwin=true
preview_in_sidebar=false

[general]
template=$CONFIG_DIR/plugins/markdown/template.html

[view]
position=1
font_name=Serif
code_font_name=Mono
font_point_size=12
code_font_point_size=12
bg_color=#ffffff
fg_color=#000000
EOF

    mkdir -p "$CONFIG_DIR/plugins/addons"
    cat > "$CONFIG_DIR/plugins/addons/addons.conf" << 'EOF'
[addons]
show_toolbar_doclist_item=true
doclist_sort_mode=2
enable_openuri=false
enable_tasks=true
tasks_token_list=TODO;FIXME
tasks_scan_all_documents=false
enable_systray=false
enable_bookmarklist=false
enable_markword=false
enable_markword_single_click_deselect=false
strip_trailing_blank_lines=false
enable_xmltagging=false
enable_enclose_words=false
enable_enclose_words_auto=false
enable_colortip=true
enable_double_click_color_chooser=false
EOF

    mkdir -p "$CONFIG_DIR/plugins/treebrowser"
    cat > "$CONFIG_DIR/plugins/treebrowser/treebrowser.conf" << 'EOF'
[treebrowser]
open_external_cmd=x-terminal-emulator -e nvim '%f'
open_terminal=x-terminal-emulator
reverse_filter=false
one_click_chdoc=false
show_hidden_files=true
hide_object_files=false
show_bars=2
chroot_on_dclick=false
follow_current_doc=true
on_delete_close_file=true
on_open_focus_editor=false
show_tree_lines=true
show_bookmarks=false
show_icons=2
open_new_files=true
EOF

    mkdir -p "$HOME/projects"
    
    echo -e "${GREEN}Butterscripts configuration applied!${NC}"
}

# Main menu
show_header
echo -e "${YELLOW}Choose your Geany installation method:${NC}"
echo
echo -e "${CYAN}1.${NC} Install from APT ${GREEN}(RECOMMENDED)${NC}"
echo -e "   - Geany 2.0 on Debian 13 (Trixie) / 1.38 on Debian 12"
echo -e "   - Quick installation with automatic updates"
echo -e "   - All plugins work correctly (including markdown preview)"
echo -e "   - Best stability and compatibility"
echo
echo -e "${CYAN}2.${NC} Compile from source (Geany 2.1 - Latest version)"
echo -e "   - Newest features (Dart, Docker, Zig language support)"
echo -e "   - Latest editor improvements"
echo -e "   ${YELLOW}⚠ Note: Markdown preview may not work on Debian 13${NC}"
echo
echo -e "${CYAN}3.${NC} Exit"
echo
read -p "Enter your choice [1-3]: " choice

case $choice in
    1)
        install_geany_apt
        ;;
    2)
        install_geany_source
        ;;
    3)
        echo -e "${YELLOW}Installation cancelled.${NC}"
        exit 0
        ;;
    *)
        echo -e "${RED}Invalid option. Exiting.${NC}"
        exit 1
        ;;
esac

echo
echo -e "${GREEN}Done!${NC}"
if [[ $choice == "2" ]]; then
    echo -e "${YELLOW}Run 'source ~/.bashrc' if needed for PATH updates.${NC}"
fi