# Source Files
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/alias" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/alias"
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/functions" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/functions"
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/prompt" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/prompt"

show_prompt_header() {
  local time=$(date '+%A %H:%M %Z')
  local weather_raw=$(inxi -w | grep 'Report:' | sed 's/Report: //')
  local weather=$(echo "$weather_raw" | sed -E 's/ *temperature: *//; s/ *conditions: */ - /')

  printf "\n\e[1;34m────────── Time and Weather ─────────\e[0m\n"
  printf " Time:    %s\n" "$time"
  printf " Weather: %s\n" "$weather"
  printf "\e[1;34m─────────────────────────────────────\e[0m\n\n"
}

show_prompt_header

autoload -U colors && colors	# Load colors

# Load cached flatpak aliases
[[ -f ~/.cache/zsh_flatpak_cache.zsh ]] && source ~/.cache/zsh_flatpak_cache.zsh

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE="$HOME/.local/history"

source ~/.config/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.config/zsh/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
