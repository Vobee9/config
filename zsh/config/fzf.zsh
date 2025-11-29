#!/bin/zsh

export FZF_DEFAULT_OPTS="
  --height 25%
  --info=hidden
  --layout=reverse
  --separator=""
  --scrollbar=""
"
export FZF_CTRL_R_OPTS="
  --preview 'echo {}'
  --preview-window down:5:wrap
  --bind '?:toggle-preview'
"
export FZF_CTRL_T_OPTS="
  --preview 'bat --color=always --style=numbers {}'
  --preview-window right:50%:wrap
  --bind '?:toggle-preview'
"
export FZF_ALT_C_OPTS="
  --preview 'tree -C {}'
  --preview-window right:50%:wrap
  --bind '?:toggle-preview'
"
export FZF_DEFAULT_COMMAND='fd --hidden --follow --exclude .git'
#export FZF_CTRL_R_COMMAND='fc -i -D -rl 1'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND --type f"
export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND --type d"
export FZF_COMPLETION_TRIGGER=''
export FZF_COMPLETION_OPTS='--multi'

_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"
}

_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude ".git" . "$1"
}

_fzf_complete_ssh() {
  _fzf_complete --prompt='' -- "$@" < <(
    grep -E '^[[:space:]]*Host[[:space:]]+' ~/.ssh/config 2>/dev/null | \
      grep -v '[*?]' | \
      awk '{for(i=2;i<=NF;i++) print $i}' | \
      sort -u
  )
}

bindkey -r '^R'
bindkey -r '^T'
bindkey '^H' fzf-history-widget
bindkey '^P' fzf-file-widget
