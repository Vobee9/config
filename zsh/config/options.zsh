#!/bin/zsh
# man zshoptions

# Completion
setopt   ALWAYS_TO_END
setopt   AUTO_LIST
setopt   AUTO_MENU
setopt   AUTO_PARAM_SLASH
setopt   AUTO_REMOVE_SLASH
setopt   COMPLETE_ALIASES
setopt   COMPLETE_IN_WORD
setopt   LIST_PACKED

# Expansion & Globbing
setopt   EXTENDED_GLOB
setopt   MARK_DIRS
unsetopt NULL_GLOB
setopt   NUMERIC_GLOB_SORT

# History
setopt   EXTENDED_HISTORY
setopt   HIST_EXPIRE_DUPS_FIRST
setopt   HIST_FIND_NO_DUPS
setopt   HIST_IGNORE_ALL_DUPS
setopt   HIST_IGNORE_DUPS
unsetopt HIST_IGNORE_SPACE
unsetopt HIST_NO_STORE
setopt   HIST_REDUCE_BLANKS
setopt   HIST_SAVE_NO_DUPS
setopt   HIST_VERIFY
setopt   INC_APPEND_HISTORY_TIME
unsetopt INC_APPEND_HISTORY
unsetopt SHARE_HISTORY

# I/O & Redirection
setopt   INTERACTIVE_COMMENTS
setopt   MULTIOS
unsetopt NO_CLOBBER
unsetopt RC_QUOTES

# Navigation
setopt   AUTO_CD
setopt   AUTO_PUSHD
unsetopt CDABLE_VARS
setopt   PUSHD_IGNORE_DUPS
setopt   PUSHD_SILENT

# Processus
setopt   CHECK_JOBS
setopt   LONG_LIST_JOBS
setopt   NOTIFY

# Shell
setopt   COMBINING_CHARS
setopt   NO_BEEP
setopt   NO_FLOW_CONTROL
setopt   PRINT_EXIT_VALUE
