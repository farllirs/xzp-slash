#!/bin/bash
# uninstall.sh — xzp-slash uninstaller

INSTALL_DIR="$(cd "$(dirname "$0")" && pwd)"

R=$'\033[1;31m' G=$'\033[1;32m' Y=$'\033[1;33m' C=$'\033[1;36m' N=$'\033[0m'
_ok()   { echo "${G}  ✓${N} $*"; }
_info() { echo "${Y}  →${N} $*"; }

echo "${C}  xzp-slash — Desinstalador${N}"
echo "────────────────────────────────────"

# Detener daemon
PID_FILE="${TMPDIR:-/tmp}/slash_daemon.pid"
if [[ -f "$PID_FILE" ]]; then
    kill "$(cat "$PID_FILE")" 2>/dev/null && _ok "Daemon detenido"
    rm -f "$PID_FILE"
fi

# Limpiar rc files
for rc in "$HOME/.bashrc" "$HOME/.zshrc"; do
    [[ ! -f "$rc" ]] && continue
    sed -i '/alias slash=/d' "$rc"
    sed -i '/alias xzp-slash=/d' "$rc"
    sed -i '/xzp-slash/d' "$rc"
    _ok "Limpiado: $rc"
done

# Eliminar cachés
rm -f "$INSTALL_DIR/.tools_cache" "$INSTALL_DIR/.pkg_cache"
_ok "Cachés eliminadas"

echo
_info "Archivos del proyecto en ${INSTALL_DIR} no eliminados."
_info "Para eliminar completamente: ${R}rm -rf $INSTALL_DIR${N}"
echo
