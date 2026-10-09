#!/usr/bin/env bash

log_message() {
    local message="$1"
    mkdir -p "$(dirname "$LOG_FILE")"
    printf '%s - %s\n' "$(date '+%F %T')" "$message" >> "$LOG_FILE"
}
