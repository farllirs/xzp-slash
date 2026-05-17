#!/usr/bin/env bash
# uninstall.sh — xzp-slash safe uninstaller

# 1. Load Environment
SELF_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ -f "$SELF_DIR/lib/slash-env.sh" ]]; then
    source "$SELF_DIR/lib/slash-env.sh"
else
    # Fallback detection if env script is missing
    IS_TERMUX=false
    [[ -d "/data/data/com.termux" ]] && IS_TERMUX=true
    PREFIX="${PREFIX:-/usr}"
    [[ "$IS_TERMUX" == true ]] && PREFIX="/data/data/com.termux/files/usr"
    SUDO="sudo"; [[ "$IS_TERMUX" == true ]] && SUDO=""
    SLASH_BIN="$PREFIX/bin"
    SLASH_SHARE="$PREFIX/share/slash"
    SLASH_LIB="$PREFIX/lib/slash"
    SLASH_ETC="/etc/slash"; [[ "$IS_TERMUX" == true ]] && SLASH_ETC="$PREFIX/etc/slash"
fi

R=$'\033[1;31m' G=$'\033[1;32m' Y=$'\033[1;33m' C=$'\033[1;36m' N=$'\033[0m'
_ok()   { echo "${G}  ✓${N} $*"; }
_warn() { echo "${Y}  !${N} $*"; }

echo "${C}  xzp-slash — Desinstalador Seguro${N}"
echo "────────────────────────────────────"

# 2. Stop Daemon
PID_FILE="${TMPDIR:-/tmp}/slash_daemon.pid"
if [[ -f "$PID_FILE" ]]; then
    kill "$(cat "$PID_FILE")" 2>/dev/null && _ok "Daemon detenido"
    rm -f "$PID_FILE"
fi

# 3. Remove via Makefile (Global files)
if [[ -f "$SELF_DIR/Makefile" ]]; then
    make uninstall PREFIX="$PREFIX" SUDO="$SUDO" &>/dev/null
    _ok "Archivos globales eliminados"
fi

# 4. Clean Shell RC files (Carefully)
for rc in "$HOME/.bashrc" "$HOME/.zshrc"; do
    [[ ! -f "$rc" ]] && continue
    # Only remove lines specifically added by xzp-slash
    sed -i '/source.*slash.*widget/d' "$rc"
    sed -i '/source.*pkg_completion/d' "$rc"
    sed -i '/alias.*slash-run/d' "$rc"
    _ok "Configuración de shell limpiada: $rc"
done

# 5. Clean Cache and User Config
rm -rf "$HOME/.cache/slash"
_ok "Caché de usuario eliminada"

echo
_warn "La configuración en $SLASH_ETC no fue eliminada para proteger tus ajustes."
_warn "Si deseas borrarla: $SUDO rm -rf $SLASH_ETC"
echo
_ok "Desinstalación completada con éxito."
