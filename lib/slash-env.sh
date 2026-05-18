#!/bin/bash
# slash-env.sh — Environment and path resolution for xzp-slash

# 1. Detect Environment
if [[ -n "$TERMUX_VERSION" || -d "/data/data/com.termux" ]]; then
    IS_TERMUX=true
    PREFIX="${PREFIX:-/data/data/com.termux/files/usr}"
    SUDO=""
else
    IS_TERMUX=false
    PREFIX="${PREFIX:-/usr}"
    SUDO="sudo"
fi

# 2. Resolve Base Paths
SELF_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ -f "$SELF_DIR/../bin/slash" && -d "$SELF_DIR/../config" ]]; then
    # Running from source/local repo
    SLASH_BASE="$(cd "$SELF_DIR/.." && pwd)"
    SLASH_BIN="$SLASH_BASE/bin"
    SLASH_LIB="$SLASH_BASE/lib"
    SLASH_ETC="$SLASH_BASE/config"
    SLASH_SHARE="$SLASH_BASE"
    SLASH_CACHE="$SLASH_BASE/.cache"
else
    # Global installation
    SLASH_BIN="$PREFIX/bin"
    SLASH_LIB="$PREFIX/lib/slash"
    SLASH_ETC="/etc/slash"; [[ "$IS_TERMUX" == true ]] && SLASH_ETC="$PREFIX/etc/slash"
    SLASH_SHARE="$PREFIX/share/slash"
    SLASH_CACHE="$HOME/.cache/slash"
fi

# 3. User-specific config (Overrides global)
SLASH_USER_CONFIG="$HOME/.config/slash"
mkdir -p "$SLASH_USER_CONFIG" "$SLASH_CACHE" 2>/dev/null

# 4. Config Files Resolution (Priority: User > Global)
resolve_config() {
    local file=$1
    if [[ -f "$SLASH_USER_CONFIG/$file" ]]; then
        echo "$SLASH_USER_CONFIG/$file"
    elif [[ -f "$SLASH_ETC/$file" ]]; then
        echo "$SLASH_ETC/$file"
    else
        # Fallback to global path even if file doesn't exist yet
        echo "$SLASH_ETC/$file"
    fi
}

COMMANDS_JSON=$(resolve_config "commands.json")
SETTINGS_JSON=$(resolve_config "settings.json")
TOOL_REGISTRY=$(resolve_config "tool_registry.json")

# 5. Runtime Files
PKG_CACHE="$SLASH_CACHE/pkg_cache"
TOOLS_CACHE="$SLASH_CACHE/tools_cache"
PID_FILE="${TMPDIR:-/tmp}/slash_daemon.pid"

# Export variables
export IS_TERMUX PREFIX SUDO
export SLASH_BIN SLASH_LIB SLASH_ETC SLASH_SHARE SLASH_CACHE SLASH_USER_CONFIG
export COMMANDS_JSON SETTINGS_JSON TOOL_REGISTRY PKG_CACHE TOOLS_CACHE PID_FILE
