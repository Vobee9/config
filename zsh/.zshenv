[[ -n "$ZSHENV_LOADED" ]] && return
export ZSHENV_LOADED=1

# General
export LANG="fr_FR.UTF-8"
export LC_ALL="fr_FR.UTF-8"
export TZ="Europe/Paris"
export EDITOR="nano"
export VISUAL="$EDITOR"

# XDG
export XDG_CONFIG_HOME="$CONFIG"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"

# ZSH
export ZSH_SESSION_SAVE_FILE="$ZDOTDIR/.zshsessions"
