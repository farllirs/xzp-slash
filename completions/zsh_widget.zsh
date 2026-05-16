# --- xzp-slash: Zsh Widget ---
# source desde .zshrc

# Resolve paths
# In zsh, ${(%):-%x} gives the script path
_SELF_DIR_Z="${${(%):-%x}:h}"
if [[ -f "$_SELF_DIR_Z/../lib/slash-env.sh" ]]; then
    source "$_SELF_DIR_Z/../lib/slash-env.sh"
elif [[ -f "/usr/lib/slash/slash-env.sh" ]]; then
    source "/usr/lib/slash/slash-env.sh"
elif [[ -f "/data/data/com.termux/files/usr/lib/slash/slash-env.sh" ]]; then
    source "/data/data/com.termux/files/usr/lib/slash/slash-env.sh"
fi

_SLASH_DIR="$SLASH_SHARE"
_SLASH_CMD_OUT="${TMPDIR:-/tmp}/slash_cmd_result"
_SLASH_MODE_OUT="${TMPDIR:-/tmp}/slash_mode_result"

xzp-slash-widget() {
    local pkgmgr=""
    for mgr in pacman apt dnf apk pkg; do
        command -v "$mgr" >/dev/null 2>&1 && pkgmgr="$mgr" && break
    done

    # Buffer con 'pkgmgr install ...' → buscar paquete
    if [[ -n "$pkgmgr" && "$LBUFFER" =~ "^$pkgmgr (install|add|show|info|reinstall|remove) " ]]; then
        local pkg
        pkg=$("$SLASH_BIN/slash" --packages)
        [[ -n "$pkg" ]] && LBUFFER+="$pkg"
        zle redisplay
        return
    fi

    # Buffer vacío → abrir menú principal
    if [[ -z "$BUFFER" ]]; then
        "$SLASH_BIN/slash"
        local cmd mode
        cmd=$(cat "$_SLASH_CMD_OUT" 2>/dev/null)
        mode=$(cat "$_SLASH_MODE_OUT" 2>/dev/null)
        [[ -z "$cmd" ]] && zle redisplay && return

        if [[ "$mode" == "2" ]]; then
            # Auto-execute
            BUFFER="$cmd"
            zle accept-line
        else
            # Paste
            LBUFFER="$cmd"
        fi
    else
        LBUFFER+="/"
    fi
    zle redisplay
}

zle -N xzp-slash-widget
bindkey "/" xzp-slash-widget
