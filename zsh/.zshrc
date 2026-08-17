# /!\ otherwise overwrtitten by /etc/zshrc:
export HISTFILE="$XDG_CACHE_HOME/zsh/history"
export HISTSIZE=10000
export SAVEHIST=10000

# zinit
ZINITDIR="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [[ ! -d "$ZINITDIR" ]]; then
   mkdir -p "$(dirname $ZINITDIR)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINITDIR"
fi

functions() {
    local dir="$ZDOTDIR/functions"
    fpath=("$dir" $fpath)
    if [[ -d "$dir" ]]; then
        local file
        for file in "$dir"/*(N); do
            autoload -Uz "${file:t}"
        done
    fi
}

functions
aliases
command -v brew >/dev/null && eval "$(brew shellenv)"
autoload -Uz compinit
compinit -d "$ZSH_COMPDUMP"
source "$ZINITDIR/zinit.zsh"
source "$ZDOTDIR/config/plugins.zsh"
source "$ZDOTDIR/config/options.zsh"
source "$ZDOTDIR/config/fzf.zsh"
source <(fzf --zsh)
