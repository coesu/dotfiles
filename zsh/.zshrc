# Lines configured by zsh-newuser-install
HISTFILE=~/.cache/zsh/history
HISTSIZE=10000
SAVEHIST=10000

export EDITOR=nvim
bindkey -v

# Start ssh-agent if not running
if ! pgrep -u "$USER" ssh-agent > /dev/null; then
  mkdir -p "$XDG_RUNTIME_DIR"
  ssh-agent -t 1h > "$XDG_RUNTIME_DIR/ssh-agent.env"
fi

# Source the environment if needed
if [ ! -S "$SSH_AUTH_SOCK" ] && [ -f "$XDG_RUNTIME_DIR/ssh-agent.env" ]; then
  source "$XDG_RUNTIME_DIR/ssh-agent.env" >/dev/null
fi

export GEMINI_API_KEY=$(cat ~/gemini-api)

autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line

bindkey -s '^f' "tmux-sessionizer\n"

bindkey -s '^n' "nvim +\"Telescope git_files cwd=.\"\n"
bindkey '^o' autosuggest-execute

zstyle :compinstall filename '/home/lars/.config/zsh/.zshrc'

export PATH=$PATH:/home/lars/.cargo/bin
export PATH=$PATH:/home/lars/.local/bin
export PATH=$PATH:/home/lars/.juliaup/bin
export PATH=$PATH:/home/lars/.local/juliaup/bin
export PATH=$PATH:/home/lars/.pixi/bin

alias pacman="sudo pacman"
alias vim="nvim"
alias svim='sudo -E nvim'

alias drag="dragon-drop -a -x"

alias ls="eza"
alias ll="eza -l"
alias la="eza -la"

alias mv='mv -iv'
alias cp='cp -iv'
alias rm='rm -iv'

alias za=zathura

alias :q=exit


autoload -Uz compinit
compinit

source /home/lars/.config/zsh/skim/completion.zsh
source /home/lars/.config/zsh/skim/keybinds.zsh

source /home/lars/.config/zsh/zsh-completions/zsh-completions.plugin.zsh
source /home/lars/.config/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

source /home/lars/.config/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# >>> mamba initialize >>>
# !! Contents within this block are managed by 'micromamba shell init' !!
export MAMBA_EXE='/home/lars/.local/bin/micromamba';
export MAMBA_ROOT_PREFIX='/home/lars/.micromamba';
__mamba_setup="$("$MAMBA_EXE" shell hook --shell zsh --root-prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__mamba_setup"
else
    alias micromamba="$MAMBA_EXE"  # Fallback on help from micromamba activate
fi
unset __mamba_setup
# <<< mamba initialize <<<
eval "$(starship init zsh)"
