export BREW="/opt/homebrew/bin"
export SCRIPTS="$HOME/scripts"
export EXECUTABLES="$HOME/.local/bin"
export PLUGINS="$HOME/.vobee/plugins"
export PATH="$BREW:$SCRIPTS:$EXECUTABLES:$PLUGINS:$PATH"
export CONFIG="$HOME/.vconfig"
export HISTFILE="$ZDOTDIR/history"

# General
HISTSIZE=10000
HIST_STAMPS="dd.mm.yyyy"
COMPLETION_WAITING_DOTS="true"

if command -v pyenv >/dev/null 2>&1; then
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PYENV_ROOT/shims:$PATH"
  eval "$(pyenv init --path)"
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
fi

functions () {
    local dir="$ZDOTDIR/functions"
    fpath=("$dir" $fpath)
    local file
    for file in "$dir"/*(N); do
        autoload -Uz "${file:t}"
    done
}

functions
aliases
