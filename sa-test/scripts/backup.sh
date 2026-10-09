#!/usr/bin/env bash

BASE_DIR="$(cd "$(dirname "$0")/.." && pwd)"
source "$BASE_DIR/config/settings.conf"
source "$BASE_DIR/lib/common.sh" 2>/dev/null || true

if [ ! -d "$BACKUP_SOURCE" ]; then
    echo "Viga: varukoopia lähteallikat '$BACKUP_SOURCE' ei leitud." >&2
    if type log_message &>/dev/null; then
        log_message "Varukoopia viga: lähteallikat $BACKUP_SOURCE ei leitud"
    fi
    exit 1
fi

DATE=$(date '+%Y%m%d_%H%M%S')
ARCHIVE="$BACKUP_DIR/backup_$DATE.tar.gz"

mkdir -p "$BACKUP_DIR"

echo "Varukoopia loomine..."

# Luuakse reaalne gzip-pakitud tar arhiiv, säilitades failide sisu ja tühikutega nimed
if tar -czf "$ARCHIVE" -C "$BACKUP_SOURCE" .; then
    file_count=$(tar -tzf "$ARCHIVE" | grep -v '/$' | wc -l)
    echo "Varukoopia valmis: $ARCHIVE"
    echo "Failide arv: $file_count"
    if type log_message &>/dev/null; then
        log_message "Varukoopia loodud: $ARCHIVE ($file_count faili)"
    fi
    exit 0
else
    echo "Varukoopia ebaõnnestus." >&2
    if type log_message &>/dev/null; then
        log_message "Varukoopia ebaõnnestus: $ARCHIVE"
    fi
    exit 1
fi
