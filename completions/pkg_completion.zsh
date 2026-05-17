#!/usr/bin/env zsh

# Resolve paths
_slash_load_env_p() {
    local self_dir="${${(%):-%x}:A:h}"
    if [[ -f "$self_dir/../../lib/slash-env.sh" ]]; then
        source "$self_dir/../../lib/slash-env.sh"
    elif [[ -f "/usr/lib/slash/slash-env.sh" ]]; then
        source "/usr/lib/slash/slash-env.sh"
    elif [[ -f "/data/data/com.termux/files/usr/lib/slash/slash-env.sh" ]]; then
        source "/data/data/com.termux/files/usr/lib/slash/slash-env.sh"
    fi
}
_slash_load_env_p

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
    # Check if completion is enabled in settings.json dynamically
    if [[ -f "$SETTINGS_JSON" ]]; then
        local enabled=$(jq -r '.completion_enabled // true' "$SETTINGS_JSON" 2>/dev/null)
        [[ "$enabled" != "true" ]] && return
    fi

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

# Register completion if manager is detected
if [[ -n "$_XZP_PKG_MGR" ]]; then
    compdef _xzp_pkg_completion "$_XZP_PKG_MGR"
fi
