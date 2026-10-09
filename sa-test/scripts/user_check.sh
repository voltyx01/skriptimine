#!/usr/bin/env bash

BASE_DIR="$(cd "$(dirname "$0")/.." && pwd)"
source "$BASE_DIR/config/settings.conf" 2>/dev/null || true
source "$BASE_DIR/lib/common.sh" 2>/dev/null || true

username="$1"

if [ -z "$username" ]; then
    echo "Viga: kasutajanimi on määramata." >&2
    echo "Kasutamine: $0 <kasutajanimi>" >&2
    exit 2
fi

if id "$username" &>/dev/null; then
    echo "Kasutaja $username eksisteerib."
    if type log_message &>/dev/null; then
        log_message "Kasutaja kontroll: $username eksisteerib"
    fi
    exit 0
else
    echo "Kasutajat $username ei leitud."
    if type log_message &>/dev/null; then
        log_message "Kasutaja kontroll: $username ei eksisteeri"
    fi
    exit 1
fi
