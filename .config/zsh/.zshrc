# Set up the prompt

setopt histignorealldups sharehistory

# Use emacs keybindings even if our EDITOR is set to vi
bindkey -e

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE="$HOME/.cache/zsh/history"

# Use modern completion system
autoload -Uz compinit
compinit

autoload -U colors && colors	# Load colors
PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b "

# Alias
alias q='exit'
alias v='nvim'
alias up='sudo apt update && sudo apt upgrade -y && flatpak update -y'
alias update='sudo apt update'
alias upgrade='sudo apt upgrade'
alias autoremove='sudo apt autoremove'
alias remove='sudo apt remove'
alias install='sudo apt install'
alias neo='neofetch'
alias ls='exa'
alias la='ls -la'
alias ll='ls -l'
alias fltheme='sudo flatpak override --env=GTK_THEME='
alias backup='rsync -r -t -p -o -g -v --progress --delete -s /home/sacra/Applications /mnt/Backups/Backups/ && rsync -r -t -p -o -g -v --progress --delete -s /home/sacra/Documents /mnt/Backups/Backups/ && rsync -r -t -p -o -g -v --progress --delete -s /home/sacra/Music /mnt/Backups/Backups/ && rsync -r -t -p -o -g -v --progress --delete -s /home/sacra/Pictures /mnt/Backups/Backups/'
alias bat='upower -i /org/freedesktop/UPower/devices/battery_BAT0| grep -E "state|to\ full|percentage"'
alias flatpak='flatpak --user'

# Ranger
r() {
  ranger --choosedir=$HOME/.rangerdir;
  LASTDIR=`cat $HOME/.rangerdir`;
  cd "$LASTDIR";
  rm $HOME/.rangerdir
}
bindkey -s '^o' 'r\n'

# Edit lines in vim ctrl+e
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line
bindkey -M vicmd '^[[P' vi-delete-char
bindkey -M vicmd '^e' edit-command-line
bindkey -M visual '^[[P' vi-delete
