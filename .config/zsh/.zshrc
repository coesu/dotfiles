# Created by Zap installer
[ -f "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh" ] && source "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh"
plug "zsh-users/zsh-autosuggestions"
plug "zap-zsh/supercharge"
plug "zsh-users/zsh-syntax-highlighting"

# settings
bindkey -v

# aliases
#
alias nz='nvim ~/.config/zsh/.zshrc'
nn() {
	cd ~/.config/nvim
	nvim
}

alias ls='exa'
alias la='exa -a'
alias ll='exa -la'
alias l='exa -l'

alias vim='nvim'
alias vi='nvim'

alias pacman='sudo pacman'
alias update='sudo pacman -Syyu'

alias grep='grep --color=auto'

alias mv='mv -iv'
alias cp='cp -iv'
alias rm='rm -iv'

alias icat='kitten icat'

alias za='zathura'
alias ze='zellij'


# >>> mamba initialize >>>
# !! Contents within this block are managed by 'mamba init' !!
export MAMBA_EXE='/home/lars/.local/bin/micromamba';
export MAMBA_ROOT_PREFIX='/home/lars/.micromamba';
__mamba_setup="$("$MAMBA_EXE" shell hook --shell zsh --root-prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__mamba_setup"
else
    alias micromamba="$MAMBA_EXE"  # Fallback on help from mamba activate
fi
unset __mamba_setup
# <<< mamba initialize <<<

# Load and initialise completion system
autoload -Uz compinit
compinit



. "$HOME/.cargo/env"
eval "$(direnv hook zsh)"
eval "$(starship init zsh)"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh