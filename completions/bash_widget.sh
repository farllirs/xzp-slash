#!/usr/bin/env bash

# Resolve slash-env.sh
_slash_load_env() {
    local paths=(
        "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../../lib/slash-env.sh"
        "$PREFIX/lib/slash/slash-env.sh"
        "/data/data/com.termux/files/usr/lib/slash/slash-env.sh"
        "/usr/lib/slash/slash-env.sh"
    )
    for p in "${paths[@]}"; do
        if [[ -f "$p" ]]; then source "$p"; return 0; fi
    done
}
_slash_load_env

_xzp_run() {
    # Check if widget is enabled in settings.json
    local enabled=$(jq -r '.widget_enabled // false' "$SETTINGS_JSON" 2>/dev/null)
    if [[ "$enabled" != "true" ]]; then
        READLINE_LINE="${READLINE_LINE:0:$READLINE_POINT}/${READLINE_LINE:$READLINE_POINT}"
        READLINE_POINT=$((READLINE_POINT + 1))
        return
    fi

    local base_tmp="${TMPDIR:-/tmp}"
    local cmd_out="$base_tmp/slash_cmd_result"
    local mode_out="$base_tmp/slash_mode_result"
    
    rm -f "$cmd_out" "$mode_out"
    "$SLASH_BIN/slash"
    
    if [[ -f "$cmd_out" ]]; then
        local cmd=$(cat "$cmd_out")
        local mode=$(cat "$mode_out")
        if [[ "$mode" == "2" ]]; then
            READLINE_LINE="$cmd"
            READLINE_POINT=${#READLINE_LINE}
        else
            READLINE_LINE="${READLINE_LINE:0:$READLINE_POINT}$cmd${READLINE_LINE:$READLINE_POINT}"
            READLINE_POINT=$((READLINE_POINT + ${#cmd}))
        fi
    fi
}

bind -x '"/": _xzp_run'
alias slash="$SLASH_BIN/slash-run"
alias xzp-slash="$SLASH_BIN/slash-run"
