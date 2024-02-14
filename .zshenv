#!/bin/zsh

# Paths
export PATH="$HOME/.local/share/flatpak/exports/bin:$PATH"
export PATH="$HOME/.local/Applications:$PATH"
export PATH="/var/lib/flatpak/exports/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# Default programs
export EDITOR="nvim"
export TERMINAL="gnome-terminal"
export BROWSER="com.brave.Browser"

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export GTK2_RC_FILES="${XDG_CONFIG_HOME:-$HOME/.config}/gtk-2.0/gtkrc-2.0"
export LESSHISTFILE="-"
export ZDOTDIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"
#USERXSESSION="$XDG_CACHE_HOME/X11/xsession"
#USERXSESSIONRC="$XDG_CACHE_HOME/X11/xsessionrc"
#ALTUSERXSESSION="$XDG_CACHE_HOME/X11/Xsession"
export ERRFILE="$XDG_CACHE_HOME/X11/xsession-errors"
