# Lines configured by zsh-newuser-install
HISTFILE=~/.cache/zsh/history
HISTSIZE=10000
SAVEHIST=10000

export EDITOR=nvim
bindkey -v

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

alias pacman="sudo pacman"
alias vim="nvim"
alias svim='sudo -E nvim'

alias drag="dragon-drop -a -x"

alias ls="exa"
alias ll="exa -l"
alias la="exa -la"

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

eval "$(starship init zsh)"
source /home/lars/.config/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
