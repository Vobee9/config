#!/bin/bash

SCRIPTS="$(cd "$(dirname "$0")" && pwd)"
CONFIG="$(cd "$SCRIPTS/../.." && pwd)"

launchctl setenv CONFIG "$CONFIG"
launchctl setenv ZDOTDIR "$CONFIG/zsh"
