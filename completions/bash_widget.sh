# --- xzp-slash: Bash Integration ---
# source desde .bashrc

# Resolve paths
_SELF_DIR_W="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ -f "$_SELF_DIR_W/../lib/slash-env.sh" ]]; then
    source "$_SELF_DIR_W/../lib/slash-env.sh"
elif [[ -f "/usr/lib/slash/slash-env.sh" ]]; then
    source "/usr/lib/slash/slash-env.sh"
elif [[ -f "/data/data/com.termux/files/usr/lib/slash/slash-env.sh" ]]; then
    source "/data/data/com.termux/files/usr/lib/slash/slash-env.sh"
fi

_SLASH_BIN="$SLASH_BIN/slash"
_SLASH_CMD_OUT="${TMPDIR:-/tmp}/slash_cmd_result"
_SLASH_MODE_OUT="${TMPDIR:-/tmp}/slash_mode_result"

_xzp_run() {
    "$_SLASH_BIN" </dev/tty >/dev/tty 2>/dev/null
    local cmd mode
    cmd=$(cat "$_SLASH_CMD_OUT" 2>/dev/null)
    mode=$(cat "$_SLASH_MODE_OUT" 2>/dev/null)
    [[ -z "$cmd" ]] && return 1

    if [[ "$mode" == "2" ]]; then
        # Auto-execute
        history -s "$cmd"
        eval "$cmd"
    else
        # Paste: pre-cargar en readline con read -e -i
        local edited
        read -e -i "$cmd" -p "" edited
        if [[ -n "$edited" ]]; then
            history -s "$edited"
            eval "$edited"
        fi
    fi
}

# Función slash invocable desde el prompt
slash() { _xzp_run; }
xzp-slash() { _xzp_run; }

# Widget para tecla /
_xzp_slash_widget() {
    local pkgmgr=""
    for mgr in pacman apt dnf apk pkg; do
        command -v "$mgr" >/dev/null 2>&1 && pkgmgr="$mgr" && break
    done

    # pkgmgr install ... → completar paquete
    if [[ -n "$pkgmgr" && "$READLINE_LINE" =~ ^$pkgmgr\ (install|add|show|info|reinstall|remove)\  ]]; then
        local pkg
        pkg=$("$_SLASH_BIN" --packages </dev/tty 2>/dev/null)
        if [[ -n "$pkg" ]]; then
            READLINE_LINE="${READLINE_LINE}${pkg}"
            READLINE_POINT=${#READLINE_LINE}
        fi
        return
    fi

    # Buffer vacío → menú
    if [[ -z "$READLINE_LINE" ]]; then
        "$_SLASH_BIN" </dev/tty >/dev/tty 2>/dev/null
        local cmd mode
        cmd=$(cat "$_SLASH_CMD_OUT" 2>/dev/null)
        mode=$(cat "$_SLASH_MODE_OUT" 2>/dev/null)
        [[ -z "$cmd" ]] && return

        if [[ "$mode" == "2" ]]; then
            history -s "$cmd"
            eval "$cmd"
            READLINE_LINE=""
            READLINE_POINT=0
        else
            READLINE_LINE="$cmd"
            READLINE_POINT=${#READLINE_LINE}
        fi
    else
        # Insertar / normalmente
        READLINE_LINE="${READLINE_LINE:0:$READLINE_POINT}/${READLINE_LINE:$READLINE_POINT}"
        READLINE_POINT=$(( READLINE_POINT + 1 ))
    fi
}

# Activar widget / según settings
if [[ "$(jq -r '.widget_enabled // false' "$SETTINGS_JSON" 2>/dev/null)" == "true" ]]; then
    bind -x '"/": _xzp_slash_widget'
fi
