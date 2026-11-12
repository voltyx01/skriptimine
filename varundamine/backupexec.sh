#!/usr/bin/env bash
# ==============================================================================
# Skript: backupexec.sh
# Kirjeldus: Kausta ~/praks2/src terviklik varundusskript koos kontrollide,
#            logimise, kontrollsummade ja rotatsiooniga (Ülesanded 1-12).
# Kasutamine: ./backupexec.sh [-c zstd|gzip|xz] [-d] [-k arv] [-s allikas] [-b sihtkoht]
# ==============================================================================

set -uo pipefail

# Vaikimisi teed ja seaded
SRC_DIR="${HOME}/praks2/src"
BACKUP_DIR="${HOME}/praks2/backup"
LOG_DIR="${HOME}/praks2/logs"
LOG_FILE="${LOG_DIR}/backup.log"
COMPRESSOR="zstd"      # zstd, gzip, xz
DRY_RUN=0              # 1 = kuiv jooks
KEEP_COPIES=3          # Mitu viimast koopiat alles hoida

# Kuva kasutusjuhend
usage() {
    cat << EOF
Kasutamine: $0 [VÕTMED]
Võtmed:
  -c, --compressor TÜÜP  Pakkija valik: zstd (vaikimisi), gzip, xz
  -d, --dry-run          Kuiv jooks: ei loo arhiivi, kuvab ainult failid
  -k, --keep ARV         Mitu viimast arhiivi alles hoida (vaikimisi: 3)
  -s, --source TEE       Lähtekaust (vaikimisi: ~/praks2/src)
  -b, --backup TEE       Varukoopiate kaust (vaikimisi: ~/praks2/backup)
  -l, --log TEE          Logifaili tee (vaikimisi: ~/praks2/logs/backup.log)
  -h, --help             Kuva see abiinfo
EOF
    exit 0
}

# Parameetrite parsimine
while [[ $# -gt 0 ]]; do
    case "$1" in
        -c|--compressor) COMPRESSOR="$2"; shift 2 ;;
        -d|--dry-run)    DRY_RUN=1; shift ;;
        -k|--keep)       KEEP_COPIES="$2"; shift 2 ;;
        -s|--source)     SRC_DIR="$2"; shift 2 ;;
        -b|--backup)     BACKUP_DIR="$2"; shift 2 ;;
        -l|--log)        LOG_FILE="$2"; shift 2 ;;
        -h|--help)       usage ;;
        *) echo "Tundmatu võti: $1" >&2; usage ;;
    esac
done

# Kontrollime vajalike kaustade olemasolu
mkdir -p "$BACKUP_DIR" "$(dirname "$LOG_FILE")"

# Logimisfunktsioon
log() {
    local msg="[ $(date '+%F %T') ] $1"
    echo "$msg"
    echo "$msg" >> "$LOG_FILE"
}

# Ajutine kataloog puhtuse tagamiseks (Ülesanne 12: mktemp ja trap)
TMP_DIR=$(mktemp -d /tmp/backup_tmp.XXXXXX)
cleanup() {
    rm -rf "$TMP_DIR"
}
trap cleanup EXIT

log "=== VARUNDAMINE ALGAB ==="

# Kontrollime lähtekausta olemasolu
if [[ ! -d "$SRC_DIR" ]]; then
    log "VIGA: Lähtekausta '$SRC_DIR' ei eksisteeri!"
    exit 1
fi

SRC_PARENT="$(dirname "$SRC_DIR")"
SRC_BASE="$(basename "$SRC_DIR")"

# Ülesanne 5 ja 11: Välistused (.backupignore tugi ja standardvälistused)
EXCLUDE_OPTS=()
if [[ -f "${SRC_DIR}/.backupignore" ]]; then
    log "Kasutan välistusfaili: ${SRC_DIR}/.backupignore"
    # Eemaldame reavahetuse lõpust kaldkriipsud, et tar sobiks ka kataloogide nimega
    sed 's#/\+$##' "${SRC_DIR}/.backupignore" > "${TMP_DIR}/clean_backupignore"
    EXCLUDE_OPTS+=(--exclude-from="${TMP_DIR}/clean_backupignore")
fi

# Ülesanne 6: „Kuiv jooks“ (Dry run)
if [[ $DRY_RUN -eq 1 ]]; then
    log "Käivitatud KUIV JOOKS (dry-run). Arhiivi ei looda."
    echo "--- Arhiivi lisatavad failid: ---"
    tar "${EXCLUDE_OPTS[@]}" -cf - -C "$SRC_PARENT" "$SRC_BASE" | tar -tvf -
    log "Kuiv jooks lõpetatud edukalt."
    log "=== VARUNDAMINE LÕPPENUD ==="
    exit 0
fi

# Ülesanne 8: Vaba ruumi kontroll
log "Kontrollin vaba kettaruumi..."
SRC_SIZE=$(du -sb "$SRC_DIR" | awk '{print $1}')
FREE_SPACE=$(df -B1 "$BACKUP_DIR" | awk 'NR==2 {print $4}')

log "Lähtekausta suurus: $((SRC_SIZE / 1024)) KB | Vaba ruumi: $((FREE_SPACE / 1024)) KB"

if [[ $SRC_SIZE -gt $FREE_SPACE ]]; then
    log "VIGA: Pole piisavalt kettaruumi! Vaja vähemalt $SRC_SIZE baiti, saadaval $FREE_SPACE baiti."
    exit 2
fi

# Kuupäeva ja kellaajaga failinimi (Ülesanne 1)
TIMESTAMP=$(date '+%Y-%m-%d_%H-%M-%S')

# Ülesanne 10: Kompressori valik
case "$COMPRESSOR" in
    zstd)
        EXT="tar.zst"
        TAR_COMPRESS_OPT=(-I 'zstd -19 -T0')
        TAR_DECOMPRESS_OPT=(-I 'zstd -d')
        ;;
    gzip)
        EXT="tar.gz"
        TAR_COMPRESS_OPT=(-z)
        TAR_DECOMPRESS_OPT=(-z)
        ;;
    xz)
        EXT="tar.xz"
        TAR_COMPRESS_OPT=(-J)
        TAR_DECOMPRESS_OPT=(-J)
        ;;
    *)
        log "VIGA: Tundmatu kompressor '$COMPRESSOR' (lubatud: zstd, gzip, xz)."
        exit 3
        ;;
esac

ARCHIVE_NAME="${SRC_BASE}_${TIMESTAMP}.${EXT}"
ARCHIVE_PATH="${BACKUP_DIR}/${ARCHIVE_NAME}"

# Ülesanne 1: Arhiivi loomine
log "Loon arhiivi (${COMPRESSOR}): $ARCHIVE_NAME ..."
tar "${TAR_COMPRESS_OPT[@]}" "${EXCLUDE_OPTS[@]}" -cf "$ARCHIVE_PATH" -C "$SRC_PARENT" "$SRC_BASE"

# Ülesanne 2: Arhiivi kontrollimine (kas arhiiv avaneb ja sisaldab sisu)
log "Kontrollin arhiivi terviklikkust..."
if ! tar "${TAR_DECOMPRESS_OPT[@]}" -tf "$ARCHIVE_PATH" > /dev/null 2>&1; then
    log "VIGA: Arhiiv on vigane või ei avane!"
    rm -f "$ARCHIVE_PATH"
    exit 4
fi

# Kuvame esimesed 5 rida arhiivist (Ülesanne 2)
echo "Arhiivi sisu (esimesed 5 kirjet):"
tar "${TAR_DECOMPRESS_OPT[@]}" -tf "$ARCHIVE_PATH" | head -n 5

# Ülesanne 3: Varukoopia suurus
ARCHIVE_SIZE=$(du -h "$ARCHIVE_PATH" | awk '{print $1}')
log "Arhiiv edukalt loodud. Suurus: $ARCHIVE_SIZE ($ARCHIVE_PATH)"

# Ülesanne 9: SHA-256 kontrollsumma arvutamine ja kontroll
log "Arvutan SHA-256 kontrollsumma..."
(cd "$BACKUP_DIR" && sha256sum "$ARCHIVE_NAME" > "${ARCHIVE_NAME}.sha256")
log "Kontrollin SHA-256 kontrollsummat..."
(cd "$BACKUP_DIR" && sha256sum -c "${ARCHIVE_NAME}.sha256")

# Uuendame ka koondkontrollsummade faili checksums.txt
(cd "$BACKUP_DIR" && find . -maxdepth 1 -type f -name "${SRC_BASE}_*.tar.*" ! -name "*.sha256" -print0 | xargs -0 sha256sum > checksums.txt)

# Ülesanne 4: Ainult viimaste koopiate hoidmine (rotatsioon)
log "Kontrollin vanu koopiaid (hoian alles viimased $KEEP_COPIES tk)..."
# Leiame kustutatavad failid
OLD_FILES=$(cd "$BACKUP_DIR" && ls -1t "${SRC_BASE}_"*.tar.* 2>/dev/null | grep -v '\.sha256$' | tail -n +$((KEEP_COPIES + 1)) || true)

if [[ -n "$OLD_FILES" ]]; then
    while IFS= read -r old_file; do
        [[ -n "$old_file" ]] || continue
        log "Eemaldan vana arhiivi: $old_file"
        rm -f "${BACKUP_DIR}/${old_file}"
        rm -f "${BACKUP_DIR}/${old_file}.sha256"
    done <<< "$OLD_FILES"
else
    log "Vanu arhiive eemaldada polnud vaja (alles on <= $KEEP_COPIES koopiat)."
fi

log "Allesolevad arhiivid kaustas $BACKUP_DIR:"
(cd "$BACKUP_DIR" && ls -lh "${SRC_BASE}_"*.tar.* 2>/dev/null | grep -v '\.sha256$' || true)

log "=== VARUNDAMINE ÕNNESTUS EDUKALT ==="
