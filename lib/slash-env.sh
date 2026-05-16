#!/bin/bash
# slash-env.sh — Environment and path resolution for xzp-slash

# Detect Termux prefix
if [[ -n "$TERMUX_VERSION" || -d "/data/data/com.termux" ]]; then
    PREFIX="${PREFIX:-/data/data/com.termux/files/usr}"
else
    PREFIX="${PREFIX:-/usr}"
fi

# Determine if we are running from a local install or a global one
# If the script being executed is in ~/xzp-slash/bin, we assume local.
# Otherwise, we check if /etc/slash exists.

SELF_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ -f "$SELF_DIR/../bin/slash" && -d "$SELF_DIR/../config" ]]; then
    # Running from source/local repo
    SLASH_BASE="$(cd "$SELF_DIR/.." && pwd)"
    SLASH_BIN="$SLASH_BASE/bin"
    SLASH_LIB="$SLASH_BASE/lib"
    SLASH_ETC="$SLASH_BASE/config"
    SLASH_SHARE="$SLASH_BASE"
    SLASH_CACHE="$SLASH_BASE"
else
    # Global installation
    SLASH_BIN="$PREFIX/bin"
    SLASH_LIB="$PREFIX/lib/slash"
    SLASH_ETC="/etc/slash"
    SLASH_SHARE="$PREFIX/share/slash"
    SLASH_CACHE="$HOME/.cache/slash"
fi

# User-specific config
SLASH_USER_CONFIG="$HOME/.config/slash"
mkdir -p "$SLASH_USER_CONFIG" "$SLASH_CACHE" 2>/dev/null

# Paths to key files
COMMANDS_JSON="$SLASH_USER_CONFIG/commands.json"
[[ ! -f "$COMMANDS_JSON" ]] && COMMANDS_JSON="$SLASH_ETC/commands.json"

SETTINGS_JSON="$SLASH_USER_CONFIG/settings.json"
[[ ! -f "$SETTINGS_JSON" ]] && SETTINGS_JSON="$SLASH_ETC/settings.json"

TOOL_REGISTRY="$SLASH_USER_CONFIG/tool_registry.json"
[[ ! -f "$TOOL_REGISTRY" ]] && TOOL_REGISTRY="$SLASH_ETC/tool_registry.json"

# Cache files
PKG_CACHE="$SLASH_CACHE/pkg_cache"
TOOLS_CACHE="$SLASH_CACHE/tools_cache"
PID_FILE="${TMPDIR:-/tmp}/slash_daemon.pid"

# Export variables for other scripts
export SLASH_BIN SLASH_LIB SLASH_ETC SLASH_SHARE SLASH_CACHE SLASH_USER_CONFIG
export COMMANDS_JSON SETTINGS_JSON TOOL_REGISTRY PKG_CACHE TOOLS_CACHE PID_FILE
