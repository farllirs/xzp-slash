# --- xzp-slash: ZSH Package Manager Completion ---

# Resolve paths
_SELF_DIR_P="${${(%):-%x}:h}"
if [[ -f "$_SELF_DIR_P/../lib/slash-env.sh" ]]; then
    source "$_SELF_DIR_P/../lib/slash-env.sh"
elif [[ -f "/usr/lib/slash/slash-env.sh" ]]; then
    source "/usr/lib/slash/slash-env.sh"
elif [[ -f "/data/data/com.termux/files/usr/lib/slash/slash-env.sh" ]]; then
    source "/data/data/com.termux/files/usr/lib/slash/slash-env.sh"
fi

# Detectar gestor de paquetes activo
_xzp_detect_pkgmgr() {
    for mgr in pacman apt dnf apk pkg; do
        command -v "$mgr" >/dev/null 2>&1 && echo "$mgr" && return
    done
}

_XZP_PKG_MGR=$(_xzp_detect_pkgmgr)

# Subcomandos por gestor
_xzp_pkg_subcmds() {
    case "$_XZP_PKG_MGR" in
        pacman) echo "-S\n-R\n-U\n-Q\n-Syu\n-Ss\n-Si\n-Ql\n-Sc" ;;
        apt)    echo "install\nremove\nupdate\nupgrade\nsearch\nshow\nlist\nautoremove\npurge" ;;
        dnf)    echo "install\nremove\nupdate\nsearch\ninfo\nlist\nautoremove\nclean" ;;
        apk)    echo "add\ndel\nupdate\nupgrade\nsearch\ninfo\nlist\nfix" ;;
        pkg)    echo "install\nuninstall\nupdate\nupgrade\nlist-all\nlist-installed\nsearch\nshow\nreinstall\nclean\nfiles" ;;
    esac
}

_xzp_pkg_completion() {
    if (( CURRENT == 2 )); then
        local -a subcmds
        subcmds=(${(f)"$(_xzp_pkg_subcmds)"})
        _describe -t commands "$_XZP_PKG_MGR commands" subcmds
    elif (( CURRENT >= 3 )); then
        # Completar nombres de paquetes desde caché
        if [[ -f "$PKG_CACHE" ]]; then
            local -a pkgs
            pkgs=(${(f)"$(cat "$PKG_CACHE")"})
            _describe -t packages 'packages' pkgs
        fi
    fi
}

# Registrar completador solo si está habilitado y se detectó un gestor
if [[ -n "$_XZP_PKG_MGR" ]] && grep -q '"completion_enabled": true' "$SETTINGS_JSON" 2>/dev/null; then
    compdef _xzp_pkg_completion "$_XZP_PKG_MGR"
fi
