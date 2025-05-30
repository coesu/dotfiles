# Lines configured by zsh-newuser-install
HISTFILE=~/.config/zsh/.histfile
HISTSIZE=10000
SAVEHIST=1000
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/lars/.config/zsh/.zshrc'

export PATH=$PATH:/home/lars/.cargo/bin
export PATH=$PATH:/home/lars/.local/bin
export PATH=$PATH:/home/lars/.juliaup/bin

alias pacman="sudo pacman"
alias vim="nvim"

alias ls="exa"
alias ll="exa -l"
alias la="exa -la"

autoload -Uz compinit
compinit

source /home/lars/.config/zsh/skim/completion.zsh
source /home/lars/.config/zsh/skim/keybinds.zsh

source /home/lars/.config/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /home/lars/.config/zsh/zsh-completions/zsh-completions.plugin.zsh
source /home/lars/.config/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# End of lines added by compinstall
eval "$(starship init zsh)"
source /home/lars/.config/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
