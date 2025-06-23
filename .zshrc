#
#    .```./(      )\.--.       .'(
#    )_,-,  )    (   ._.'  ,') \  )
#        / / _    `-.`.   (  '-' (
#       / `-` )  ,_ (  \   ) .-.  )
#      (     (  (  '.)  ) (  ,  ) \
#       ).',,'   '._,_.'   )/    )/
#

# Configuration initiale du PATH pour garantir les commandes de base
export BREW="/opt/homebrew/bin"
export SCRIPTS="$HOME/scripts"
export EXECUTABLES="$HOME/.local/bin"
export PLUGINS="$HOME/.vobee/plugins"
export PATH="/usr/local/bin:/usr/bin:/bin:$BREW:$SCRIPTS:$EXECUTABLES:$PLUGINS:$HOME/.local/bin"

# General
HISTSIZE=3000
HIST_STAMPS="dd.mm.yyyy"
COMPLETION_WAITING_DOTS="true"

# Plugins
plugins=(
    sudo
)
# Variables
export ZSH_DIR='~/.vobee/'

export ZSH=~/.vobee/.oh-my-zsh
export DOCS=~/Library/CloudStorage/SynologyDrive-Documents
export ZSH_PLUGINS="$HOME/.oh-my-zsh/custom/plugins"

# Aliases
alias nano="/opt/homebrew/bin/nano"
alias reload="source $ZSH_DIR/.zshrc"
alias update="brew update && brew outdated && brew upgrade"
alias windows="yabai -m query --windows | grep title"
alias docs="cd $DOCS"

# Colors
# Sources
# source ~/.zle
source ~/.vobee/p10k

dockcl()
{
    docker kill $(docker ps -q)
    docker rm $(docker ps -a -q)
    docker rmi $(docker images -q)
    docker volume rm $(docker volume ls -q)
    docker network rm $(docker network ls -q)
    docker system prune
    docker system prune -af
}

setup_brew() {
    title "Brew"
    run   "brew update"
    run   "brew upgrade"
    run   "brew upgrade --cask"
    run   "brew cleanup"
    run   "brew autoremove"
    run   "brew doctor"
}

zenith() {
    set -a
    source api/.env
    source api/services/.env
    set +a
    export GPG_TTY=$(tty)
    export POSTGRES_HOST='localhost'
    export GDAL_LIBRARY_PATH=/opt/homebrew/lib/libgdal.dylib
    export GEOS_LIBRARY_PATH=/opt/homebrew/lib/libgeos_c.dylib
}

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PYENV_ROOT/shims:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

dockid() {
    docker ps -a | grep "$1" | awk '{print $1}'
}

restore() {
    ./scripts/dbmgr restore     \
        --truncate              \
        --anonymize             \
        --user $POSTGRES_USER   \
        --database $POSTGRES_DB \
        --file "$1"              \
        --container $(dockid post)
}
alias dc='docker compose'
alias dup='dc up --build'
alias dockredis='docker exec -it $(dockid redis) redis-cli -h cache -p 6379'
