#!/bin/bash
CONFIG="$HOME/.vconfig"

# clone
git clone git@github.com:Vobee9/config.git $CONFIG

# brew
if ! command -v brew >/dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
eval "$(brew shellenv)"

brew install --cask nikitabobko/tap/aerospace
defaults write -g NSWindowShouldDragOnGesture -bool true
defaults write -g NSAutomaticWindowAnimationsEnabled -bool false

function macos_agent() {
CONFIG="$HOME/.vconfig"

    local template="$CONFIG/macos/vobee.plist"
    local target="$HOME/Library/LaunchAgents/com.vobee.plist"
    [ -f $target ] && rm $target
    sed "s|__CONFIG__|${CONFIG}|g" "$template" > "$target"
    launchctl unload "$target" 2>/dev/null
    launchctl load "$target"
}
macos_agent

brew install fzf bat fd rg

version_python="3.10.12"
setup_python() {
    title "Python"
    run "brew list | grep python | xargs brew uninstall --ignore-dependencies"
    run "brew install pyenv pyenv-virtualenv"
    run "pyenv install $version_python"
    run "pyenv global $version_python"
    run "pyenv versions"
    echo
}
