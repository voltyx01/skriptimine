#!/usr/bin/env bash

log_message() {
    local message="$1"
    printf '%s - %s\n' "$(date '+%F %T')" "$message" >> "$LOG_FILE"
}
