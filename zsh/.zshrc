# /!\ otherwise overwrtitten by /etc/zshrc (macOS):
export HISTFILE="$ZDOTDIR/.zshhistory"
export HISTSIZE=10000
export SAVEHIST=10000

# zinit
ZINITDIR="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [[ ! -d "$ZINITDIR" ]]; then
   mkdir -p "$(dirname $ZINITDIR)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINITDIR"
fi

if command -v pyenv >/dev/null 2>&1; then
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PYENV_ROOT/shims:$PATH"
    eval "$(pyenv init --path)"
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
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
eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null)"

autoload -Uz compinit
compinit -d "$ZSH_COMPDUMP"

# Charger fzf (les bindings par défaut seront désactivés dans fzf.zsh)
source <(fzf --zsh)
source "$ZDOTDIR/config/fzf.zsh"
source "$ZINITDIR/zinit.zsh"
source "$ZDOTDIR/config/options.zsh"
source "$ZDOTDIR/config/plugins.zsh"
