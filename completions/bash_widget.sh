#!/usr/bin/env bash

# Resolve slash-env.sh
_slash_load_env() {
    local self_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    if [[ -f "$self_dir/../../lib/slash-env.sh" ]]; then
        source "$self_dir/../../lib/slash-env.sh"
    elif [[ -f "/usr/lib/slash/slash-env.sh" ]]; then
        source "/usr/lib/slash/slash-env.sh"
    elif [[ -f "/data/data/com.termux/files/usr/lib/slash/slash-env.sh" ]]; then
        source "/data/data/com.termux/files/usr/lib/slash/slash-env.sh"
    fi
}
_slash_load_env

_xzp_run() {
    # Check if widget is enabled in settings.json
    if [[ -f "$SETTINGS_JSON" ]]; then
        local enabled=$(jq -r '.widget_enabled // false' "$SETTINGS_JSON")
        if [[ "$enabled" != "true" ]]; then
            # If not enabled, just insert the character
            READLINE_LINE="${READLINE_LINE:0:$READLINE_POINT}/${READLINE_LINE:$READLINE_POINT}"
            READLINE_POINT=$((READLINE_POINT + 1))
            return
        fi
    fi

    local base_tmp="${TMPDIR:-/tmp}"
    local cmd_out="$base_tmp/slash_cmd_result"
    local mode_out="$base_tmp/slash_mode_result"
    
    # Clear previous results
    rm -f "$cmd_out" "$mode_out"

    # Run slash
    "$SLASH_BIN/slash"
    local exit_code=$?

    if [[ $exit_code -eq 0 && -f "$cmd_out" ]]; then
        local cmd=$(cat "$cmd_out")
        local mode=$(cat "$mode_out")

        if [[ "$mode" == "2" ]]; then
            # Auto-execute mode
            READLINE_LINE="$cmd"
            READLINE_POINT=${#READLINE_LINE}
            # Note: In bash we can't easily trigger execution from a widget without 'accept-line'
            # but we can set the line and the user just presses Enter.
        else
            # Paste mode
            READLINE_LINE="${READLINE_LINE:0:$READLINE_POINT}$cmd${READLINE_LINE:$READLINE_POINT}"
            READLINE_POINT=$((READLINE_POINT + ${#cmd}))
        fi
    fi
}

# Bind the "/" key to our widget
bind -x '"/": _xzp_run'

# Aliases
alias slash="$SLASH_BIN/slash-run"
alias xzp-slash="$SLASH_BIN/slash-run"
