# Environment for all zsh shells (interactive and not). Sourced from ~/.zshenv.
# Interactive-only settings (aliases, keybindings, prompt) live in .zshrc.

# OS detection (exported so .zshrc can reuse it)
case "$(uname -s)" in
    Linux*)  export OS=linux;;
    Darwin*) export OS=macos;;
    *)       export OS=unknown;;
esac

# XDG Base Directory specification
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_DATA_DIRS="/usr/local/share:/usr/share"
export XDG_CONFIG_DIRS="/etc/xdg"

# XDG-compliant tool locations
export LESSHISTFILE="$XDG_STATE_HOME/less/history"
export WGETRC="$XDG_CONFIG_HOME/wget/wgetrc"
export PYTHON_HISTORY="$XDG_STATE_HOME/python/history"
export PYENV_ROOT="$XDG_DATA_HOME/pyenv"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export NPM_CONFIG_CACHE="$XDG_CACHE_HOME/npm"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export GOPATH="$XDG_DATA_HOME/go"
export GOBIN="$HOME/.local/bin"
export JULIA_DEPOT_PATH="$XDG_DATA_HOME/julia:"
export JULIAUP_DEPOT_PATH="$XDG_DATA_HOME/juliaup"
export BUN_INSTALL="$XDG_DATA_HOME/bun"
export MPLCONFIGDIR="$XDG_CONFIG_HOME/matplotlib"
export DOCKER_CONFIG="$XDG_CONFIG_HOME/docker"

# Misc environment
export EDITOR=nvim
export MANPAGER="nvim +Man!"
export GTK_THEME=adw-gtk3-dark
export ZK_NOTEBOOK_DIR="$HOME/Syncthing/notes"
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"

# PATH (built once here). Scripts are symlinked into ~/.local/bin by setup.sh.
typeset -U path   # keep PATH entries unique
path=(
    "$HOME/.local/bin"
    "$CARGO_HOME/bin"
    "$GOBIN"
    "$GOPATH/bin"
    "$HOME/.juliaup/bin"
    "$HOME/.local/juliaup/bin"
    $path
)
[[ "$OS" == "linux" ]] && path+=("$HOME/.pixi/bin")
export PATH
