#!/bin/bash
#
#         )`-.--. .'(   .')       )\.---.    )\.--.
#         ) ,-._( \  ) ( /       (   ,-._(  (   ._.'
#         \ `-._  ) (   ))        \  '-,     `-.`.
#     ,_   ) ,_(  \  )  )'._.-.    ) ,-`    ,_ (  \
#    (  \ (  \     ) \ (       )  (  ``-.  (  '.)  )
#     ).'  ).'      )/  )/,__.'    )..-.(   '._,_.'
#

CONFIG="$HOME/.vconfig"

# ZSH
git clone git@github.com:Vobee9/config.git $CONFIG
echo "export ZDOTDIR=$CONFIG/zsh" | sudo tee -a /etc/zshrc

#SKHD
brew install koekeishiya/formulae/skhd
ln -s $CONFIG/skhd/skhd.plist ~/Library/LaunchAgents/skhd.plist


#-----------------------------------------------------------------------------------



# variables
version_python="3.10.12"

header() {
    printf $blue
    cat << EOF
             .' '.
🐝  .        .   .        .
     .         .        .
      ' .  . ' ' .  . '

EOF
    printf $reset
    printf "$yellow> vobee9 - MacOS setup script - v$version $reset\n"
}

title() {
    printf "\n$yellow> $1: $reset\n"
}
run() {
    local error=${2:-true}
    printf "$yellow|$reset $1\n"
    eval $1
    if [ "$error" = true ]; then
        if [ $? -ne 0 ]; then
            printf "$red/!\ Error occured during installation...$reset\n"
            exit 1
        fi
    fi
}

init() {
    title "Initialization"
    printf "$yellow|$reset curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh"
    bash -c $(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)
    run "git clone $repository $folder" false
    echo
}

setup_python() {
    title "Python"
    run "brew list | grep python | xargs brew uninstall --ignore-dependencies"
    run "brew install pyenv pyenv-virtualenv"
    run "pyenv install $version_python"
    run "pyenv global $version_python"
    run "pyenv versions"
    echo
}

yabai_skhd() {
    title "Yabai | Skhd"
    run "brew install koekeishiya/formulae/yabai"
    run "brew install koekeishiya/formulae/skhd"
    run "yabai --start-service"
    run "skhd --start-service"
    run "sudo nvram boot-args=-arm64e_preview_abi"
    run "csrutil status"
}

dotfiles() {
    title "Dotfiles"
    dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    for file in "$dir"/.*; do
        if [ -f "$file" ]; then
            run "ln -sf "$file" "$HOME/$(basename "$file")""
        fi
    done
}

header
#init
#setup_python
yabai_skhd
dotfiles
