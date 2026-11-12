#!/usr/bin/env bash
# ==============================================================================
# Skript: varunda_kodukataloogid.sh
# Kirjeldus: Kasutajate kodukataloogide varundamise skript.
#            Arhiveerib ja pakib iga kasutaja kodukataloogi kujul:
#            <kasutaja>.<kuupäev>.tar.gz
#            ja salvestab arhiivid sihtkataloogi (vaikimisi /home_bcp).
#
# NB! Skript töötab korrektselt sõltumata sellest, millisest kaustast
#     see käivitatakse (kasutades tar -C võtit ja absoluutseid teid).
#
# Kasutamine:
#   ./varunda_kodukataloogid.sh [-s allikas] [-d sihtkoht] [-u kasutaja]
# ==============================================================================

set -uo pipefail

SOURCE_DIR="/home"
TARGET_DIR="/home_bcp"
SINGLE_USER=""

# Kuva kasutusjuhend
usage() {
    cat << EOF
Kasutamine: $0 [VÕTMED]

Võtmed:
  -s, --source TEE    Kasutajate kodukaustade asukoht (vaikimisi: /home)
  -d, --dest TEE      Varukoopiate sihtkaust (vaikimisi: /home_bcp,
                      tavakontoga käivitamisel vajadusel ~/home_bcp)
  -u, --user NIMI     Varunda ainult üks kindel kasutaja
  -h, --help          Kuva see abiinfo

Näide:
  sudo $0
  $0 -d ~/home_bcp
EOF
    exit 0
}

# Parameetrite töötlemine
while [[ $# -gt 0 ]]; do
    case "$1" in
        -s|--source) SOURCE_DIR="$2"; shift 2 ;;
        -d|--dest)   TARGET_DIR="$2"; shift 2 ;;
        -u|--user)   SINGLE_USER="$2"; shift 2 ;;
        -h|--help)   usage ;;
        *) echo "Tundmatu võti: $1" >&2; usage ;;
    esac
done

# Kontrollime või kohandame sihtkataloogi
if ! mkdir -p "$TARGET_DIR" 2>/dev/null; then
    FALLBACK_DIR="${HOME}/home_bcp"
    echo "Hoiatus: Ei saanud luua kataloogi '$TARGET_DIR' (õigused puuduvad)."
    echo "Kasutan alternatiivset sihtkausta: $FALLBACK_DIR"
    TARGET_DIR="$FALLBACK_DIR"
    mkdir -p "$TARGET_DIR"
fi

if [[ ! -d "$SOURCE_DIR" ]]; then
    echo "VIGA: Lähtekataloogi '$SOURCE_DIR' ei leitud!" >&2
    exit 1
fi

KUUPAEV="$(date +%d.%m.%Y)"

echo "=========================================================="
echo "Kasutajate kodukataloogide varundamine"
echo "Allikas:     $SOURCE_DIR"
echo "Sihtkoht:    $TARGET_DIR"
echo "Kuupäev:     $KUUPAEV"
echo "=========================================================="

success_count=0
fail_count=0

varunda_kasutaja() {
    local user="$1"
    local user_home="${SOURCE_DIR}/${user}"
    local archive_name="${user}.${KUUPAEV}.tar.gz"
    local archive_path="${TARGET_DIR}/${archive_name}"

    if [[ ! -d "$user_home" ]]; then
        echo "HOIATUS: Kasutaja kausta '$user_home' ei eksisteeri, jätan vahele."
        return 1
    fi

    echo -n "Varundan kasutajat '$user' ... "

    # Töötab sõltumata asukohast tänu -C võtmele
    # Välistame sihtkausta, kui see peaks asuma kodukaustas, et vältida rekursiooni
    if tar --warning=no-file-changed \
           --exclude="home_bcp" \
           --exclude=".cache" \
           --exclude=".gemini" \
           -czf "$archive_path" -C "$SOURCE_DIR" "$user" 2>/dev/null; then
        local size
        size=$(du -h "$archive_path" | awk '{print $1}')
        echo "VALMIS! ($archive_name, suurus: $size)"
        return 0
    else
        echo "EBAÕNNESTUS!"
        return 1
    fi
}

if [[ -n "$SINGLE_USER" ]]; then
    if varunda_kasutaja "$SINGLE_USER"; then
        success_count=$((success_count + 1))
    else
        fail_count=$((fail_count + 1))
    fi
else
    # Käime läbi kõik kasutajate kataloogid lähtekaustas
    for user_path in "$SOURCE_DIR"/*; do
        [[ -e "$user_path" ]] || continue
        [[ -d "$user_path" ]] || continue

        user="$(basename "$user_path")"

        # Välistame süsteemsed/erikaustad
        if [[ "$user" == "lost+found" || "$user" == .* ]]; then
            continue
        fi

        if varunda_kasutaja "$user"; then
            success_count=$((success_count + 1))
        else
            fail_count=$((fail_count + 1))
        fi
    done
fi

echo "=========================================================="
echo "Kokkuvõte: edukalt varundatud: $success_count | ebaõnnestus: $fail_count"
echo "Varukoopiad asuvad kaustas: $TARGET_DIR"
ls -lh "$TARGET_DIR"/*."${KUUPAEV}".tar.gz 2>/dev/null || true
echo "=========================================================="

if [[ $fail_count -gt 0 ]]; then
    exit 1
fi
exit 0
