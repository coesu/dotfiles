# Lines configured by zsh-newuser-install
HISTFILE=~/.cache/zsh/history
HISTSIZE=10000
SAVEHIST=10000

export EDITOR="nvim"
bindkey -v

autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/lars/.config/zsh/.zshrc'

export PATH=$PATH:/home/lars/.cargo/bin
export PATH=$PATH:/home/lars/.local/bin
export PATH=$PATH:/home/lars/.juliaup/bin

alias pacman="sudo pacman"
alias vim="nvim"

alias drag="dragon-drop -a -x"

alias ls="exa"
alias ll="exa -l"
alias la="exa -la"

autoload -Uz compinit
compinit

source /home/lars/.config/zsh/skim/completion.zsh
source /home/lars/.config/zsh/skim/keybinds.zsh

source /home/lars/.config/zsh/zsh-completions/zsh-completions.plugin.zsh
source /home/lars/.config/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

eval "$(starship init zsh)"
source /home/lars/.config/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
