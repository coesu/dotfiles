# Environment shared by interactive and non-interactive Fish shells.
set -g fish_greeting

set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx XDG_DATA_HOME "$HOME/.local/share"
set -gx XDG_CACHE_HOME "$HOME/.cache"
set -gx XDG_STATE_HOME "$HOME/.local/state"
# XDG directory lists are colon-separated. Keep this as one exported string;
# otherwise Fish joins the list with spaces and launchers such as Rofi cannot
# find desktop entries under /usr/share/applications.
set -gx XDG_DATA_DIRS /usr/local/share:/usr/share
set -gx XDG_CONFIG_DIRS /etc/xdg

switch (uname -s)
    case Linux
        set -gx OS linux
    case Darwin
        set -gx OS macos
    case '*'
        set -gx OS unknown
end

set -gx LESSHISTFILE "$XDG_STATE_HOME/less/history"
set -gx WGETRC "$XDG_CONFIG_HOME/wget/wgetrc"
set -gx PYTHON_HISTORY "$XDG_STATE_HOME/python/history"
set -gx PYENV_ROOT "$XDG_DATA_HOME/pyenv"
set -gx NPM_CONFIG_USERCONFIG "$XDG_CONFIG_HOME/npm/npmrc"
set -gx NPM_CONFIG_CACHE "$XDG_CACHE_HOME/npm"
set -gx CARGO_HOME "$XDG_DATA_HOME/cargo"
set -gx RUSTUP_HOME "$XDG_DATA_HOME/rustup"
set -gx GOPATH "$XDG_DATA_HOME/go"
set -gx GOBIN "$HOME/.local/bin"
set -gx JULIA_DEPOT_PATH "$XDG_DATA_HOME/julia:"
set -gx JULIAUP_DEPOT_PATH "$XDG_DATA_HOME/juliaup"
set -gx BUN_INSTALL "$XDG_DATA_HOME/bun"
set -gx MPLCONFIGDIR "$XDG_CONFIG_HOME/matplotlib"
set -gx DOCKER_CONFIG "$XDG_CONFIG_HOME/docker"

set -gx EDITOR nvim
set -gx MANPAGER 'nvim +Man!'
set -gx GTK_THEME adw-gtk3-dark
set -gx ZK_NOTEBOOK_DIR "$HOME/Syncthing/notes"

fish_add_path --global --move \
    "$HOME/.local/bin" \
    "$CARGO_HOME/bin" \
    "$GOPATH/bin" \
    "$HOME/.juliaup/bin" \
    "$HOME/.local/juliaup/bin"

if test "$OS" = linux
    fish_add_path --global --append "$HOME/.pixi/bin"
    if set -q XDG_RUNTIME_DIR
        set -gx SSH_AUTH_SOCK "$XDG_RUNTIME_DIR/ssh-agent.socket"
    end
else if test "$OS" = macos; and test -x /opt/homebrew/bin/brew
    /opt/homebrew/bin/brew shellenv | source
    fish_add_path --global --append /opt/homebrew/opt/findutils/libexec/gnubin
end

# Most api-key files containing `export NAME=value` work in both Zsh and Fish.
# Avoid eval-based conversion when a file contains shell-specific syntax.
if test -f "$HOME/.secrets/api-keys"
    if fish --no-execute "$HOME/.secrets/api-keys" 2>/dev/null
        source "$HOME/.secrets/api-keys"
    else if status is-interactive
        echo 'fish: ~/.secrets/api-keys contains non-Fish syntax; not sourced' >&2
    end
end

status is-interactive; or return

# Fish provides autosuggestions, syntax highlighting, and completions itself.
fish_vi_key_bindings

# Use a non-blinking block cursor in every mode.
set -g fish_cursor_default block
set -g fish_cursor_insert block
set -g fish_cursor_replace_one block
set -g fish_cursor_replace block
set -g fish_cursor_visual block
set -g fish_cursor_external block

function __open_file_picker
    command nvim '+FzfLua files'
    commandline -f repaint
end

function __run_tmux_sessionizer
    command tmux-sessionizer
    commandline -f repaint
end

bind -M insert \ce edit_command_buffer
bind -M default \ce edit_command_buffer
bind -M insert \cn __open_file_picker
bind -M default \cn __open_file_picker
bind -M insert \co accept-autosuggestion execute
bind -M default \co accept-autosuggestion execute
if command -q tmux-sessionizer
    bind -M insert \cf __run_tmux_sessionizer
    bind -M default \cf __run_tmux_sessionizer
end

if command -q bat
    alias cat bat
end
if test "$OS" = linux; and command -q pacman
    alias pacman 'sudo pacman'
end
alias vim nvim
alias svim 'sudo -E nvim'
alias mv 'mv -iv'
alias cp 'cp -iv'
alias rm 'rm -iv'
alias za zathura
alias :q exit

if command -q dragon-drop
    alias drag 'dragon-drop -a -x'
end

if command -q eza
    alias ls 'eza --icons=auto'
    alias ll 'eza -l --icons=auto'
    alias la 'eza -la --icons=auto'
else
    alias ls 'ls --color=auto'
    alias ll 'ls -l --color=auto'
    alias la 'ls -la --color=auto'
end

if command -q ask
    function '?'
        command ask $argv
    end
end

function copy --description 'Copy files or stdin to the system clipboard'
    if test "$OS" = macos
        command cat $argv | pbcopy
    else
        command cat $argv | wl-copy
    end
end

function screencopy --description 'Copy the newest Desktop screenshot here'
    set -l newest
    for file in "$HOME"/Desktop/Screen*
        if test -z "$newest"; or test "$file" -nt "$newest"
            set newest "$file"
        end
    end

    if test -z "$newest"
        echo "No Desktop screenshot matching 'Screen*' found." >&2
        return 1
    end

    printf 'cp %s .\n' (string escape -- "$newest")
    command cp "$newest" .
end

if command -q direnv
    direnv hook fish | source
end

if command -q starship
    starship init fish | source
end
