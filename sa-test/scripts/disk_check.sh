#!/usr/bin/env bash

BASE_DIR="$(cd "$(dirname "$0")/.." && pwd)"
source "$BASE_DIR/config/settings.conf"
source "$BASE_DIR/lib/common.sh" 2>/dev/null || true

# Kasutame df -P standardset formaati ning võtame kasutusprotsendi (veerg 5)
usage=$(df -P / | awk 'NR==2 {print $5}' | tr -d '%')

if [ -z "$usage" ]; then
    echo "Viga: kettakasutuse tuvastamine ebaõnnestus." >&2
    exit 1
fi

echo "Kettakasutus: ${usage}%"

if [ "$usage" -lt "$DISK_LIMIT" ]; then
    echo "OK: kettaruumi kasutus on normis."
    if type log_message &>/dev/null; then
        log_message "Kettakontroll OK: kasutus ${usage}%, limiit ${DISK_LIMIT}%"
    fi
    exit 0
else
    echo "HOIATUS: kettaruumi kasutus on liiga suur."
    if type log_message &>/dev/null; then
        log_message "Kettakontroll HOIATUS: kasutus ${usage}%, limiit ${DISK_LIMIT}%"
    fi
    exit 1
fi
