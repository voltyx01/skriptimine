#!/usr/bin/env bash

BASE_DIR="$(cd "$(dirname "$0")/.." && pwd)"
source "$BASE_DIR/config/settings.conf"
source "$BASE_DIR/lib/common.sh" 2>/dev/null || true

archive="$1"
target_dir="$2"

# Kui arhiivi pole määratud, valitakse viimane varukoopia kaustast BACKUP_DIR
if [ -z "$archive" ]; then
    archive=$(ls -t "$BACKUP_DIR"/backup_*.tar.gz 2>/dev/null | head -n 1)
    if [ -z "$archive" ]; then
        echo "Viga: varukoopiaid ei leitud kaustast '$BACKUP_DIR'." >&2
        if type log_message &>/dev/null; then
            log_message "Taastamise viga: varukoopiaid ei leitud"
        fi
        exit 1
    fi
    echo "Kasutatakse viimast varukoopiat: $archive"
fi

if [ ! -f "$archive" ]; then
    echo "Viga: arhiivifaili '$archive' ei leitud." >&2
    if type log_message &>/dev/null; then
        log_message "Taastamise viga: arhiivifaili $archive ei leitud"
    fi
    exit 1
fi

# Kontrollime, et arhiiv on kehtiv gzip-pakitud tar arhiiv
if ! tar -tzf "$archive" &>/dev/null; then
    echo "Viga: fail '$archive' ei ole korrektne gzip tar arhiiv." >&2
    if type log_message &>/dev/null; then
        log_message "Taastamise viga: vigane arhiiv $archive"
    fi
    exit 1
fi

# Kui sihtkausta pole määratud, taastatakse kausta testdata/restore
if [ -z "$target_dir" ]; then
    target_dir="$BASE_DIR/testdata/restore"
fi

mkdir -p "$target_dir"

echo "Varukoopia taastamine kausta: $target_dir..."

if tar -xzf "$archive" -C "$target_dir"; then
    file_count=$(tar -tzf "$archive" | grep -v '/$' | wc -l)
    echo "Taastamine edukas."
    echo "Taastatud failide arv: $file_count"
    if type log_message &>/dev/null; then
        log_message "Varukoopia taastatud: $archive -> $target_dir ($file_count faili)"
    fi
    exit 0
else
    echo "Viga: varukoopia lahtipakkimine ebaõnnestus." >&2
    if type log_message &>/dev/null; then
        log_message "Taastamise viga: lahtipakkimine ebaõnnestus ($archive)"
    fi
    exit 1
fi
