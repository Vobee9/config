#!/bin/bash

MACOS="$(cd "$(dirname "$0")" && pwd)"
CONFIG="$(cd "$MACOS/.." && pwd)"

launchctl setenv CONFIG "$CONFIG"
launchctl setenv ZDOTDIR "$CONFIG/zsh"
launchctl setenv XDG_CONFIG_HOME "$CONFIG"
launchctl setenv XDG_CACHE_HOME "$HOME/.cache"
launchctl setenv XDG_DATA_HOME "$HOME/.local/share"
