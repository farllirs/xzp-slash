#!/usr/bin/env zsh

# Resolve slash-env.sh
_slash_load_env() {
    local self_dir="${${(%):-%x}:A:h}"
    local paths=(
        "$self_dir/../../lib/slash-env.sh"
        "$PREFIX/lib/slash/slash-env.sh"
        "/data/data/com.termux/files/usr/lib/slash/slash-env.sh"
        "/usr/lib/slash/slash-env.sh"
    )
    for p in "${paths[@]}"; do
        if [[ -f "$p" ]]; then source "$p"; return 0; fi
    done
}
_slash_load_env

xzp-slash-widget() {
    local enabled=$(jq -r '.widget_enabled // false' "$SETTINGS_JSON" 2>/dev/null)
    if [[ "$enabled" != "true" ]]; then
        LBUFFER+="/"
        return
    fi

    if [[ -z "$BUFFER" ]]; then
        local base_tmp="${TMPDIR:-/tmp}"
        local cmd_out="$base_tmp/slash_cmd_result"
        local mode_out="$base_tmp/slash_mode_result"
        
        rm -f "$cmd_out" "$mode_out"
        "$SLASH_BIN/slash"
        
        if [[ -f "$cmd_out" ]]; then
            local cmd=$(cat "$cmd_out")
            local mode=$(cat "$mode_out")
            BUFFER="$cmd"
            [[ "$mode" == "2" ]] && zle accept-line || CURSOR=${#BUFFER}
        fi
    else
        LBUFFER+="/"
    fi
}

zle -N xzp-slash-widget
bindkey "/" xzp-slash-widget
alias slash="$SLASH_BIN/slash-run"
alias xzp-slash="$SLASH_BIN/slash-run"
