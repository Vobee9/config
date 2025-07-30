HISTFILE="$ZDOTDIR/.zshhistory"
HISTSIZE=50000
SAVEHIST=10000
HIST_STAMPS="dd.mm.yyyy"
COMPLETION_WAITING_DOTS="true"

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
    setopt extended_glob
    local file
    for file in "$dir"/*(N); do
      autoload -Uz "${file:t}"
    done
  fi
}

functions
aliases
eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null)"
