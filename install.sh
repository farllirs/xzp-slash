#!/usr/bin/env bash
# install.sh — xzp-slash official installer (v2.0)

# ── Colores ────────────────────────────────────────────────────────────────
R=$'\033[1;31m' G=$'\033[1;32m' Y=$'\033[1;33m' B=$'\033[1;34m' C=$'\033[1;36m' N=$'\033[0m'

_ok()   { echo "${G}  ✓${N} $*"; }
_info() { echo "${B}  →${N} $*"; }
_warn() { echo "${Y}  !${N} $*"; }
_err()  { echo "${R}  ✗${N} $*"; }
_hdr()  { echo; echo "${C}$*${N}"; echo "────────────────────────────────────"; }

# ── Banner ─────────────────────────────────────────────────────────────────
clear
echo "${C}"
echo "  ╔═══════════════════════════════╗"
echo "  ║        xzp-slash              ║"
echo "  ║   Multi-platform Installer    ║"
echo "  ╚═══════════════════════════════╝"
echo "${N}"

# ── Detectar entorno ───────────────────────────────────────────────────────
_detect_pkgmgr() {
    for mgr in pacman apt dnf apk pkg; do
        command -v "$mgr" >/dev/null 2>&1 && echo "$mgr" && return
    done
    echo "unknown"
}

PKG_MGR=$(_detect_pkgmgr)
PREFIX="/usr"
[[ -d "/data/data/com.termux" ]] && PREFIX="/data/data/com.termux/files/usr"

_hdr "Entorno detectado"
_info "Gestor  : $PKG_MGR"
_info "Destino : $PREFIX"

# ── Instalar dependencias ──────────────────────────────────────────────────
_install_pkg() {
    case "$PKG_MGR" in
        pacman) sudo pacman -S --noconfirm "$1" ;;
        apt)    sudo apt-get update && sudo apt-get install -y "$1" ;;
        dnf)    sudo dnf install -y "$1" ;;
        apk)    sudo apk add "$1" ;;
        pkg)    pkg install -y "$1" ;;
        *)      _err "No se puede instalar '$1': gestor no detectado"; return 1 ;;
    esac
}

_hdr "Dependencias"
for dep in fzf jq python3 make; do
    if command -v "$dep" >/dev/null 2>&1; then
        _ok "$dep ya instalado"
    else
        _info "Instalando $dep..."
        _install_pkg "$dep" || { _err "Falló la instalación de $dep"; exit 1; }
    fi
done

# ── Descargar código si no existe ──────────────────────────────────────────
if [[ ! -f "Makefile" ]]; then
    _hdr "Descargando código"
    TEMP_DIR=$(mktemp -d)
    git clone https://github.com/farllirs/xzp-slash.git "$TEMP_DIR"
    cd "$TEMP_DIR" || exit 1
fi

# ── Instalación vía Makefile ───────────────────────────────────────────────
_hdr "Instalando archivos"
if [[ "$PKG_MGR" == "pkg" ]]; then
    # Termux no usa sudo
    make install PREFIX="$PREFIX"
else
    sudo make install PREFIX="$PREFIX"
fi

# ── Configuración de Shell ─────────────────────────────────────────────────
_hdr "Configurando shells"
SHELLS=()
[[ -f "$HOME/.bashrc" ]] && SHELLS+=("bash:$HOME/.bashrc")
[[ -f "$HOME/.zshrc" ]]  && SHELLS+=("zsh:$HOME/.zshrc")

for entry in "${SHELLS[@]}"; do
    shell="${entry%%:*}"
    rc="${entry##*:}"
    
    if [[ "$shell" == "zsh" ]]; then
        grep -q "zsh_widget.zsh" "$rc" || echo "source $PREFIX/share/slash/completions/zsh_widget.zsh" >> "$rc"
        grep -q "pkg_completion.zsh" "$rc" || echo "source $PREFIX/share/slash/completions/pkg_completion.zsh" >> "$rc"
        _ok "[zsh] configurado en $rc"
    fi

    if [[ "$shell" == "bash" ]]; then
        grep -q "bash_widget.sh" "$rc" || echo "source $PREFIX/share/slash/completions/bash_widget.sh" >> "$rc"
        _ok "[bash] configurado en $rc"
    fi
done

# ── Iniciar Daemon ─────────────────────────────────────────────────────────
_hdr "Iniciando servicios"
if command -v slash-daemon >/dev/null 2>&1; then
    slash-daemon &
    _ok "Daemon iniciado en segundo plano"
else
    _warn "No se pudo iniciar el daemon automáticamente"
fi

_hdr "Instalación completada"
_ok "Usa el comando: ${Y}slash${N}"
_info "Reinicia tu terminal para activar los widgets"
echo
