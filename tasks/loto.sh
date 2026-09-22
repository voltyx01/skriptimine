#!/bin/bash
# Skript genereerib 5 erinevat pseudojuhuslikku arvu vahemikus 1–50

# Loomme ajutise faili genereeritud numbritest
TMP_FILE=$(mktemp)

# Kustutame ajutise faili automaatselt skripti töö lõppemisel
trap 'rm -f "$TMP_FILE"' EXIT

# Genereerime täpselt 5 erinevat numbrit
while [ $(wc -l < "$TMP_FILE") -lt 5 ]; do
    NR=$(( RANDOM % 50 + 1 ))
    
    # Kontrollime, kas arv on juba ajutises failis olemas
    if ! grep -x -q "$NR" "$TMP_FILE"; then
        echo "$NR" >> "$TMP_FILE"
    fi
done

# Sorteerime numbrid parema loetavuse huvides ja muudame need üherealiseks
NUMBRID=$(sort -n "$TMP_FILE" | tr '\n' ' ')
KUUPAEV=$(date +"%Y-%m-%d %H:%M:%S")

# Küsime kasutajalt väljundiviisi
echo "Genereeritud 5 lotonumbrit: $NUMBRID"
echo "Vali tegevus:"
echo "1 - Kuva terminalis"
echo "2 - Salvesta faili (loto_tulemused.txt)"
read -p "Sisesta valik (1 või 2): " VALIK

case $VALIK in
    1)
        echo ""
        echo "Kuupäev ja kellaaeg: $KUUPAEV"
        echo "Lotonumbrid: $NUMBRID"
        ;;
    2)
        echo "Kuupäev ja kellaaeg: $KUUPAEV | Lotonumbrid: $NUMBRID" >> loto_tulemused.txt
        echo "Tulemus on salvestatud faili loto_tulemused.txt"
        ;;
    *)
        echo "Vigane valik. Tulemusi ei salvestatud."
        ;;
esac
