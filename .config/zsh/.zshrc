# Created by Zap installer
[ -f "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh" ] && source "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh"
plug "zsh-users/zsh-autosuggestions"
# plug "zap-zsh/supercharge"
plug "zsh-users/zsh-syntax-highlighting"

# settings
bindkey -v

export EDITOR=nvim


export PATH=$HOME/.local/scripts:$PATH

bindkey -s '^f' "tmux-sessionizer\n"
bindkey -s '^n' "nvim +\"Telescope git_files cwd=.\"\n"
# aliases
#
alias nz='nvim ~/.config/zsh/.zshrc'
nn() {
	cd ~/.config/nvim
	nvim .
}
nh() {
	cd ~/.config/hypr
	nvim hyprland.conf
}

alias ls='exa'
alias la='exa -a'
alias ll='exa -la'
alias l='exa -l'

alias vim='nvim'
alias vi='nvim'
alias svim='sudo -E nvim'

alias pacman='sudo pacman'
alias update='sudo pacman -Syyu'

alias grep='grep --color=auto'

alias mv='mv -iv'
alias cp='cp -iv'
alias rm='rm -iv'

alias icat='kitten icat'

alias za='zathura'
alias ze='zellij'

alias :q='exit'

alias drag='dragon-drop -x -a'


# Load and initialise completion system
autoload -Uz compinit
compinit



. "$HOME/.cargo/env"
eval "$(direnv hook zsh)"
# eval "$(zoxide init --cmd cd zsh)"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

eval "$(starship init zsh)"
