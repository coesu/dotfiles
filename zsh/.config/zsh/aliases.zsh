#!/bin/sh
alias j='z'
alias f='zi'
alias zsh-update-plugins="find "$ZDOTDIR/plugins" -type d -exec test -e '{}/.git' ';' -print0 | xargs -I {} -0 git -C {} pull -q"

# alias lvim='nvim -u ~/.local/share/lunarvim/lvim/init.lua --cmd "set runtimepath+=~/.local/share/lunarvim/lvim"'

# get fastest mirrors
alias mirror="sudo reflector -f 30 -l 30 --number 10 --verbose --save /etc/pacman.d/mirrorlist"
alias mirrord="sudo reflector --latest 50 --number 20 --sort delay --save /etc/pacman.d/mirrorlist"
alias mirrors="sudo reflector --latest 50 --number 20 --sort score --save /etc/pacman.d/mirrorlist"
alias mirrora="sudo reflector --latest 50 --number 20 --sort age --save /etc/pacman.d/mirrorlist"

# Colorize grep output (good for log files)
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

alias nh='nvim ~/.config/hypr/hyprland.conf'
alias nz='nvim ~/.config/zsh/.zshrc'
alias na='nvim ~/.config/zsh/aliases.zsh'
alias nt='$EDITOR ~/dotfiles/tmux/.config/tmux/tmux.conf'
alias nn='nvim ~/dotfiles/nvim/.config/nvim/'
alias nf='$EDITOR ~/dotfiles/foot/.config/foot/foot.ini'

alias update='sudo pacman -Syyu'
alias pacman='sudo pacman'

alias vim='nvim'
alias vi='nvim'

# confirm before overwriting something
alias cp="cp -iv"
alias mv='mv -iv'
alias rm='rm -iv'

alias :q="exit"
alias :wq="exit"
alias cd..="cd .."
alias cd.="cd .."

from_config_to_dotfiles() {
    mkdir -p $HOME/dotfiles/$1/.config/$1
    cp -r $HOME/.config/$1 $HOME/dotfiles/$1/.config
}

# easier to read disk
alias df='df -h'     # human-readable sizes
alias free='free -m' # show sizes in MB


# For when keys break
alias archlinx-fix-keys="sudo pacman-key --init && sudo pacman-key --populate archlinux && sudo pacman-key --refresh-keys"


