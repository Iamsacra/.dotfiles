# Source Files
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/alias" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/alias"
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/flatpakalias" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/flatpakalias"
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/functions" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/functions"

# Prompt
autoload -U colors && colors	# Load colors
PROMPT="%B[%~]%b $ "

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE="$HOME/.local/history"

source ~/.config/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

