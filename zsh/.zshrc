# Lines configured by zsh-newuser-install
HISTFILE=~/.cache/zsh/history
HISTSIZE=10000
SAVEHIST=10000

export EDITOR=nvim
bindkey -v

if ! pgrep -u "$USER" ssh-agent > /dev/null; then
    ssh-agent -t 1h > "$XDG_RUNTIME_DIR/ssh-agent.env" >/dev/null
fi

if [ -f "$XDG_RUNTIME_DIR/ssh-agent.env" ]; then
    eval "$(cat "$XDG_RUNTIME_DIR/ssh-agent.env")" >/dev/null
fi

if [ -f ~/.secrets/api-keys ]; then
    source ~/.secrets/api-keys
fi

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

export MANPAGER="nvim +Man!"

alias pacman="sudo pacman"
alias vim="nvim"
alias svim='sudo -E nvim'

alias drag="dragon-drop -a -x"

alias ls="eza --icons=auto"
alias ll="eza -l --icons=auto"
alias la="eza -la --icons=auto"

alias mv='mv -iv'
alias cp='cp -iv'
alias rm='rm -iv'

copy() {
    cat "$@" | wl-copy
}

alias za=zathura

alias :q=exit


autoload -Uz compinit
compinit

source /home/lars/.config/zsh/skim/completion.zsh
source /home/lars/.config/zsh/skim/keybinds.zsh

### Zinit ###
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [[ ! -d $ZINIT_HOME ]]; then
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "${ZINIT_HOME}/zinit.zsh"

zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-syntax-highlighting

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
# source /usr/share/nvm/init-nvm.sh
