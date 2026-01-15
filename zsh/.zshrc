# Lines configured by zsh-newuser-install
HISTFILE=~/.cache/zsh/history
HISTSIZE=10000
SAVEHIST=10000

export XDG_CONFIG_HOME="$HOME/.config"

export EDITOR=nvim
bindkey -v

# OS detection
case "$(uname -s)" in
    Linux*)  OS=linux;;
    Darwin*) OS=macos;;
    *)       OS=unknown;;
esac

# SSH agent setup (Linux only - macOS handles this via Keychain)
# Skip in devcontainers (they handle SSH forwarding differently)
if [[ "$OS" == "linux" ]] && [[ -z "$REMOTE_CONTAINERS" ]] && [[ -z "$CODESPACES" ]] && [[ -z "$DEVCONTAINER" ]]; then
    if [[ -n "$XDG_RUNTIME_DIR" ]]; then
        if ! pgrep -u "$USER" ssh-agent > /dev/null; then
            ssh-agent -t 1h > "$XDG_RUNTIME_DIR/ssh-agent.env" >/dev/null 2>&1
        fi
        if [ -f "$XDG_RUNTIME_DIR/ssh-agent.env" ]; then
            eval "$(cat "$XDG_RUNTIME_DIR/ssh-agent.env")" >/dev/null
        fi
    fi
fi

if [ -f ~/.secrets/api-keys ]; then
    source ~/.secrets/api-keys
fi

autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line


bindkey -s '^n' "nvim +\"Telescope git_files cwd=.\"\n"
bindkey '^o' autosuggest-execute

# PATH setup (use $HOME instead of hardcoded paths)
export PATH=$PATH:$HOME/.cargo/bin
export PATH=$PATH:$HOME/.local/bin
export PATH=$PATH:$HOME/.juliaup/bin
export PATH=$PATH:$HOME/.local/juliaup/bin

# tmux-sessionizer (only if available)
if command -v tmux-sessionizer &> /dev/null; then
    bindkey -s ^f "tmux-sessionizer\n"
    # bindkey -s '\en' "tmux-sessionizer -s 0\n"
    # bindkey -s '\ee' "tmux-sessionizer -s 1\n"
    # bindkey -s '\ei' "tmux-sessionizer -s 2\n"
    # bindkey -s '\eo' "tmux-sessionizer -s 3\n"
fi

if [[ "$OS" == "linux" ]]; then
    export PATH=$PATH:$HOME/.pixi/bin
fi

if [[ "$OS" == "macos" ]]; then
    export PATH="$PATH:/opt/homebrew/opt/findutils/libexec/gnubin"
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

export MANPAGER="nvim +Man!"

alias pacman="sudo pacman"
alias vim="nvim"
alias svim='sudo -E nvim'

alias drag="dragon-drop -a -x"

# ls aliases - use eza if available, otherwise standard ls
if command -v eza &> /dev/null; then
    alias ls="eza --icons=auto"
    alias ll="eza -l --icons=auto"
    alias la="eza -la --icons=auto"
else
    alias ls="ls --color=auto"
    alias ll="ls -l --color=auto"
    alias la="ls -la --color=auto"
fi

alias mv='mv -iv'
alias cp='cp -iv'
alias rm='rm -iv'

# fabric AI query (only if available)
if command -v fabric &> /dev/null; then
    _ask() { fabric -p raw_query "$*"; }
    alias '?'='noglob _ask'
fi

# Clipboard copy function
copy() {
    if [[ "$OS" == "macos" ]]; then
        cat "$@" | pbcopy
    else
        cat "$@" | wl-copy
    fi
}

alias za=zathura

alias :q=exit

# skim keybinds (only if file exists)
[[ -f ~/.config/zsh/skim/keybinds.zsh ]] && source ~/.config/zsh/skim/keybinds.zsh

# --- Manual Plugin Management ---
ZPLUGINS_DIR="${HOME}/.local/share/zsh-plugins"
if [[ ! -d $ZPLUGINS_DIR ]]; then mkdir -p $ZPLUGINS_DIR; fi

# 1. zsh-autosuggestions
PLUGIN_PATH="${ZPLUGINS_DIR}/zsh-autosuggestions"
if [[ ! -d $PLUGIN_PATH ]]; then git clone https://github.com/zsh-users/zsh-autosuggestions.git $PLUGIN_PATH; fi
source "$PLUGIN_PATH/zsh-autosuggestions.zsh"

# 2. zsh-syntax-highlighting
PLUGIN_PATH="${ZPLUGINS_DIR}/zsh-syntax-highlighting"
if [[ ! -d $PLUGIN_PATH ]]; then git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $PLUGIN_PATH; fi
source "$PLUGIN_PATH/zsh-syntax-highlighting.zsh"

# 3. zsh-completions
PLUGIN_PATH="${ZPLUGINS_DIR}/zsh-completions"
if [[ ! -d $PLUGIN_PATH ]]; then git clone https://github.com/zsh-users/zsh-completions.git $PLUGIN_PATH; fi
fpath=($PLUGIN_PATH/src $fpath)

# Add platform-specific completion paths
if [[ "$OS" == "macos" ]]; then
    fpath=(/opt/homebrew/share/zsh/site-functions $fpath)
fi

autoload -Uz compinit
ZSH_COMPDUMP="${HOME}/.cache/zsh/compdump"
compinit -u -d $ZSH_COMPDUMP

# Micromamba (Linux only)
if [[ "$OS" == "linux" ]]; then
    export MAMBA_EXE="$HOME/.local/bin/micromamba"
    export MAMBA_ROOT_PREFIX="$HOME/.micromamba"
    if [[ -x "$MAMBA_EXE" ]]; then
        __mamba_setup="$("$MAMBA_EXE" shell hook --shell zsh --root-prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"
        if [ $? -eq 0 ]; then
            eval "$__mamba_setup"
        else
            alias micromamba="$MAMBA_EXE"
        fi
        unset __mamba_setup
    fi
fi

# Password copy function (macOS only - uses osascript for concealed clipboard)
if [[ "$OS" == "macos" ]]; then
    passc() {
        local PASSWORD=$(pass "$1" | head -n 1)
        if [ -n "$PASSWORD" ]; then
            osascript <<EOF
                set the clipboard to {«class priv»:"$PASSWORD", «class conc»:"$PASSWORD", string:"$PASSWORD"}
EOF
            echo "Password for '$1' copied as concealed data."
            (sleep 45 && pbcopy < /dev/null && echo "Clipboard cleared.") &!
        else
            echo "Error: Password not found."
        fi
    }
fi

# direnv
if command -v direnv &> /dev/null; then
    eval "$(direnv hook zsh)"
fi

# Starship prompt
if command -v starship &> /dev/null; then
    eval "$(starship init zsh)"
fi
