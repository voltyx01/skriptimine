#!/usr/bin/env bash

BASE_DIR="$(cd "$(dirname "$0")/.." && pwd)"
source "$BASE_DIR/config/settings.conf" 2>/dev/null || true
source "$BASE_DIR/lib/common.sh" 2>/dev/null || true

service="$1"

if [ -z "$service" ]; then
    echo "Viga: teenuse nimi on määramata." >&2
    echo "Kasutamine: $0 <teenuse_nimi>" >&2
    exit 2
fi

# Kontrollime, kas teenus on üldse süsteemi paigaldatud / eksisteerib
if ! systemctl cat "$service" &>/dev/null && ! systemctl list-unit-files "${service%.service}.service" 2>/dev/null | awk '{print $1}' | grep -qx "${service%.service}.service"; then
    echo "Teenust $service ei leitud (pole paigaldatud)."
    if type log_message &>/dev/null; then
        log_message "Teenuse kontroll: $service ei leitud (pole paigaldatud)"
    fi
    exit 1
fi

# Kontrollime, kas teenus hetkel aktiivselt töötab
if systemctl is-active --quiet "$service"; then
    echo "Teenus $service töötab."
    if type log_message &>/dev/null; then
        log_message "Teenuse kontroll: $service töötab"
    fi
    exit 0
else
    echo "Teenus $service ei tööta."
    if type log_message &>/dev/null; then
        log_message "Teenuse kontroll: $service ei tööta"
    fi
    exit 1
fi
