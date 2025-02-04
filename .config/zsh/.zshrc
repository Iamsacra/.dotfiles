# Source Files
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/alias" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/alias"
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/flatpakalias" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/flatpakalias"
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/functions" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/functions"
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/prompt" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/prompt"

fetch.sh

autoload -U colors && colors	# Load colors



# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE="$HOME/.local/history"

source ~/.config/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.config/zsh/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh