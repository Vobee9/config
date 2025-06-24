#!/usr/bin/env bash

app="$1"

osascript <<EOF
    tell application "$app"
    	reopen
    	activate
    end tell
EOF
