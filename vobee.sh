#!/bin/bash
#
#
#    ___    __     ______
#    __ |  / /________  /___________
#    __ | / /_  __ \_  __ \  _ \  _ \
#    __ |/ / / /_/ /  /_/ /  __/  __/
#    _____/  \____//_.___/\___/\___/
#
#
#--------------------------------------------------------------------------------------------------#
# GLOBALS                                                                                          #
#--------------------------------------------------------------------------------------------------#

version='1'
config="$HOME/.vconfig"
depends=(git uv)
pkg=''

blue='\033[0;35m'
green='\033[0;36m'
red='\033[0;31m'
redb='\033[1;33m'
reset='\033[0m'

set -e

#--------------------------------------------------------------------------------------------------#
# LOGS                                                                                             #
#--------------------------------------------------------------------------------------------------#

title() {
    printf "\n${blue}➤ $1${reset}\n"
}

info() {
    printf "• %-7s" "$1"
}

prompt() {
    info "$1" && printf " $red?$reset "
}

ask() {
    read -p "$(prompt "$1")" "$2"
}

option() {
    info "$1"
    printf " = %s\n" "${2:-"<none>"}"
}

success() {
    printf "${green}✓${reset} $1\n"
}

error() {
    printf "${red}✗${reset} $1\n"
}

run() {
    local msg=$1
    shift
    if "$@" > /dev/null 2>vobee.errlog; then
        success "$msg"
    else
        error "$msg"
        cat vobee.errlog
        rm -f vobee.errlog
        exit 1
    fi
    rm -f vobee.errlog
}

header() {
    echo
    printf "${red}___    __     ______             ${reset}\n"
    printf "${red}__ |  / /________  /___________  ${reset}\n"
    printf "${red}__ | / /_  __ \_  __ \  _ \  _ \ ${reset}\n"
    printf "${red}__ |/ / / /_/ /  /_/ /  __/  __/ ${reset}\n"
    printf "${red}_____/  \____//_.___/\___/\___/  ${reset}\n"
    title  "welcome to vobee.sh script - v$version"
}

#--------------------------------------------------------------------------------------------------#
# OPTIONS                                                                                          #
#--------------------------------------------------------------------------------------------------#

usage() {
    echo
    echo "usage: $0 [options]"
    echo
    echo "options:"
    echo "  -p | --pkg <name>   required on Linux {apt|dnf|pacman}"
    echo "                      optional on macOS (defaults to brew)"
    echo "  -h | --help         display this help message and quit"
    echo
    exit 0
}

options() {
    for arg in "$@"; do
        shift
        case "$arg" in
            --pkg) set -- "$@" "-p"  ;;
            *    ) set -- "$@" "$arg";;
        esac
    done
    while getopts ":p:h" opt; do
        case "$opt" in
            p) pkg="$OPTARG";;
            h) usage        ;;
            ?) usage        ;;
        esac
    done
}

pkg() {
    case "$(uname -s)" in
        Darwin)
            pkg=brew
            ;;
        Linux)
            while [[ -z "$pkg" || ! "$pkg" =~ ^(apt|dnf|pacman)$ ]]; do
                ask pkg pkg
            done
            ;;
        *)
            error "unsupported system: $(uname -s)"
            return 1
            ;;
    esac
    option pkg "$pkg"
}

#--------------------------------------------------------------------------------------------------#
# FUNCTIONS                                                                                        #
#--------------------------------------------------------------------------------------------------#

function aerospace() {
    local domain="gui/$(id -u)"
    local label="com.vobee.aerospace"
    local target="$HOME/Library/LaunchAgents/${label}.plist"
    title 'aerospace'
    option domain "$domain"
    option label "$label"
    option target "$target"
    if command brew list --cask aerospace &>/dev/null; then
        success "already installed"
    else
        run "install" brew install -y -q --cask nikitabobko/tap/aerospace
    fi
    run "cp aerospace.plist" bash -c \
        "sed \"s|__CONFIG__|${config}|g\" \"$config/aerospace/aerospace.plist\" > \"$target\""
    run "launchctl bootout" bash -c \
        "launchctl bootout '${domain}/${label}' 2>/dev/null || true"
    run "launchctl bootstrap" launchctl bootstrap "$domain" "$target"
    run "window drag gesture" defaults write -g NSWindowShouldDragOnGesture -bool true
    run "window animations" defaults write -g NSAutomaticWindowAnimationsEnabled -bool false
}

function brew() {
    local install='https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh'
    title 'brew'
    if command -v brew >/dev/null; then
        success "already installed"
    else
        run "install" /bin/bash -c "$(curl -fsSL "$install")"
    fi
    run "homebrew shellenv" eval "$(command brew shellenv)"
    export HOMEBREW_NO_AUTO_UPDATE=1 HOMEBREW_NO_ENV_HINTS=1
    unset -f brew
}

function dependencies() {
    title 'dependencies'
    case "$pkg" in
        brew)
            run "install ${depends[*]}" command brew install -y -q "${depends[@]}"
            ;;
        apt)
            run "apt update" sudo apt update
            run "install ${depends[*]}" sudo apt install -y "${depends[@]}"
            ;;
        dnf)
            run "install ${depends[*]}" sudo dnf install -y "${depends[@]}"
            ;;
        pacman)
            run "install ${depends[*]}" sudo pacman -S --noconfirm "${depends[@]}"
            ;;
        *)
            error "unknown package manager: $pkg"
            return 1
            ;;
    esac
}

function git() {
    title 'git'
    if [[ -d "$config/.git" ]]; then
        success "repository already cloned at $config"
        return 0
    fi
    run "git clone" command git clone git@github.com:Vobee9/config.git "$config"
}

function sudo_touchid() {
    local file=/etc/pam.d/sudo_local
    if [[ -f "$file" ]] && grep -qE '^auth[[:space:]]+sufficient[[:space:]]+pam_tid\.so' "$file"; then
        success "touch id already enabled"
        return 0
    fi
    title 'sudo touch id'
    if [[ -f "$file" ]]; then
        sudo sed -i.bak 's/^#auth[[:space:]]\+sufficient[[:space:]]\+pam_tid\.so/auth       sufficient     pam_tid.so/' "$file"
        sudo rm -f "${file}.bak"
    else
        printf '%s\n' \
            '# sudo_local: local config file which survives system update' \
            'auth       sufficient     pam_tid.so' | sudo tee "$file" > /dev/null
    fi
    success "touch id enabled"
}

function zshenv() {
    [[ "$(uname -s)" == Darwin ]] && sudo_touchid
    local src="$config/zsh/.zshenv.etc" dst=/etc/zshenv
    title 'zshenv'
    [[ -f "$src" ]] || { error "missing $src"; return 1; }
    option source "$src"
    option target "$dst"
    sudo -v
    if sudo test -f "$dst"; then
        run "remove #vobee" sudo sed -i.bak '/^# vobee$/,/^# \/vobee$/d' "$dst"
        run "remove .bak" sudo rm -f "${dst}.bak"
    else
        run "touch $dst" sudo touch "$dst"
    fi
    run "append .zshenv.etc" bash -c "
        {
            echo '# vobee'
            cat '$src'
            echo '# /vobee'
        } | sudo tee -a '$dst' >/dev/null
    "
}

#--------------------------------------------------------------------------------------------------#
# MAIN                                                                                             #
#--------------------------------------------------------------------------------------------------#

header
title 'init'
options "$@"
option config "$config"
option depends "${depends[*]}"
pkg
case "$(uname -s)" in
    Darwin)
        brew
        aerospace
        ;;
esac
dependencies
git
zshenv
title 'end'
