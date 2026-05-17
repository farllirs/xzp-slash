#!/usr/bin/env zsh

# Resolve slash-env.sh
_slash_load_env() {
    local self_dir="${${(%):-%x}:A:h}"
    if [[ -f "$self_dir/../../lib/slash-env.sh" ]]; then
        source "$self_dir/../../lib/slash-env.sh"
    elif [[ -f "/usr/lib/slash/slash-env.sh" ]]; then
        source "/usr/lib/slash/slash-env.sh"
    elif [[ -f "/data/data/com.termux/files/usr/lib/slash/slash-env.sh" ]]; then
        source "/data/data/com.termux/files/usr/lib/slash/slash-env.sh"
    fi
}
_slash_load_env

xzp-slash-widget() {
    # Check if widget is enabled in settings.json
    if [[ -f "$SETTINGS_JSON" ]]; then
        local enabled=$(jq -r '.widget_enabled // false' "$SETTINGS_JSON")
        if [[ "$enabled" != "true" ]]; then
            LBUFFER+="/"
            return
        fi
    fi

    # Buffer empty -> menu
    if [[ -z "$BUFFER" ]]; then
        local base_tmp="${TMPDIR:-/tmp}"
        local cmd_out="$base_tmp/slash_cmd_result"
        local mode_out="$base_tmp/slash_mode_result"
        
        rm -f "$cmd_out" "$mode_out"
        "$SLASH_BIN/slash"
        
        if [[ -f "$cmd_out" ]]; then
            local cmd=$(cat "$cmd_out")
            local mode=$(cat "$mode_out")
            
            if [[ "$mode" == "2" ]]; then
                BUFFER="$cmd"
                zle accept-line
            else
                BUFFER="$cmd"
                CURSOR=${#BUFFER}
            fi
        fi
    else
        LBUFFER+="/"
    fi
}

zle -N xzp-slash-widget
bindkey "/" xzp-slash-widget

# Aliases
alias slash="$SLASH_BIN/slash-run"
alias xzp-slash="$SLASH_BIN/slash-run"
