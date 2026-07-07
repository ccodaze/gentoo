#!/usr/bin/sh
# /etc/portage/bashrc.d/check-kernel-update.sh
# Checks for gentoo-kernel updates before each emerge, max once per day.
# Delete the lock file to force an immediate re-check.

# --- Configuration -----------------------------------------------------------
TARGET_PACKAGE="sys-kernel/gentoo-kernel"
LOCK_DIR="/var/cache/portage-kernel-check"
LOCK_FILE="${LOCK_DIR}/last_check.lock"
LOG_FILE="${LOCK_DIR}/kernel_check.log"
CHECK_INTERVAL=86400 # seconds (24 hours)

# Notification method: notify-send | wall | log | stderr
NOTIFY_METHOD="stderr"
# --- End Configuration -------------------------------------------------------

# Ensure lock directory exists
if ! mkdir -p "$LOCK_DIR" 2>/dev/null; then
    return 0 2>/dev/null || exit 0
fi

# Helper: send notification
notify_user() {
    local message="$1"
    case "$NOTIFY_METHOD" in
        notify-send)
            if command -v notify-send &>/
