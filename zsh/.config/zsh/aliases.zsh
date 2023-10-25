#!/bin/sh
alias f='z'
alias j='zi'
alias zsh-update-plugins="find "$ZDOTDIR/plugins" -type d -exec test -e '{}/.git' ';' -print0 | xargs -I {} -0 git -C {} pull -q"

# alias lvim='nvim -u ~/.local/share/lunarvim/lvim/init.lua --cmd "set runtimepath+=~/.local/share/lunarvim/lvim"'

# Colorize grep output (good for log files)
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

nh() {
    cd ~/.config/hypr   
    nvim hyprland.conf
}
alias nz='nvim ~/.config/zsh/.zshrc'
alias na='nvim ~/.config/zsh/aliases.zsh'

nn() {
    cd ~/dotfiles/nvim/.config/nvim
    nvim
}
#rwth cluster
scp_hpc() {
    scp -r nv340616@login18-2.hpc.itc.rwth-aachen.de:/home/nv340616/tbg-30/scripts/TBG/$1 .
}
alias sshfs_hpc='sshfs nv340616@login18-2.hpc.itc.rwth-aachen.de:/home/nv340616 hpc'
alias sshfs_hpc3='sshfs nv340616@login18-3.hpc.itc.rwth-aachen.de:/home/nv340616 hpc'

alias vim='nvim'
alias vi='nvim'
alias hx='helix'

# confirm before overwriting something
alias cp="cp -iv"
alias mv='mv -iv'
alias rm='rm -iv'

alias :q="exit"
alias :wq="exit"
alias cd..="cd .."
alias cd.="cd .."

alias za="zathura"

alias ze="zellij"

from_config_to_dotfiles() {
    mkdir -p $HOME/dotfiles/$1/.config/$1
    cp -r $HOME/.config/$1 $HOME/dotfiles/$1/.config
}

alias update="sudo nixos-rebuild switch"

full-update() {
    cd /etc/nixos 
    sudo nix flake update 
    sudo nixos-rebuild switch --flake .
}
