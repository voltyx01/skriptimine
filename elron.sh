#!/bin/bash
# Skript: Elroni rongiinfo päring ja väljumisaegade kuvamine

# ---------------------------------------------------------
# Värvide definitsioonid (ANSI escape codes)
# ---------------------------------------------------------
PUNANE='\033[0;31m'
ROHELINE='\033[0;32m'
LOHETUS='\033[0m' # Värvi lähtestamine (Reset)

# ---------------------------------------------------------
# 1. & 2. Marsruudi valimine ja sisendi kontroll
# ---------------------------------------------------------
echo "ELRONI RONGIINFO"
echo ""
echo "Vali marsruut:"
echo ""
echo "1 - Tartu → Tallinn"
echo "2 - Tartu → Valga"
echo "3 - Tartu → Koidula"
echo ""
read -p "Sisesta valik: " VALIK

# Kontrollime, kas sisend on tühi
if [ -z "$VALIK" ]; then
    echo "Valik jäi sisestamata."
    exit 1
fi

# Määrame lähte- ja sihtjaama vastavalt valikule
case $VALIK in
    1)
        LAHTEJAAM="Tartu"
        SIHTJAAM="Tallinn"
        ;;
    2)
        LAHTEJAAM="Tartu"
        SIHTJAAM="Valga"
        ;;
    3)
        LAHTEJAAM="Tartu"
        SIHTJAAM="Koidula"
        ;;
    *)
        echo "Vigane valik! Sellist marsruuti menüüs pole."
        exit 1
        ;;
esac

# ---------------------------------------------------------
# 3. Andmete pärimine Elroni API-st
# ---------------------------------------------------------
# API URL (peatuse nimi peab olema sobival kujul)
API_URL="https://elron.ee/live-map/stop/$LAHTEJAAM"

# Teeme HTTP päringu vaikimisi režiimis, salvestades vastuse muutujasse
API_VASTUS=$(curl -s "$API_URL")

# Kontrollime päringu õnnestumist (lõpetamiskood $?)
if [ $? -ne 0 ] || [ -z "$API_VASTUS" ]; then
    echo "Elroni API päring ebaõnnestus."
    exit 1
fi

# ---------------------------------------------------------
# 4. & 5. Filtreerimine sihtjaama järgi
# ---------------------------------------------------------
# Otsime API vastusest JSON-objektid / read, mis sisaldavad valitud sihtjaama
FILTREERITUD_RONGID=$(echo "$API_VASTUS" | grep -o '{[^}]*}' | grep "\"sihtjaam\":\"$SIHTJAAM\"")

# ---------------------------------------------------------
# 6. Kontrollime, kas sobivaid ronge leiti
# ---------------------------------------------------------
if [ -z "$FILTREERITUD_RONGID" ]; then
    echo "Sobivaid ronge ei leitud."
    exit 1
fi

# ---------------------------------------------------------
# 7. Väljumisaegade eraldamine (grep, sed, cut)
# ---------------------------------------------------------
# Eraldame plaanilised ajad (kujul HH:MM)
AJAD=$(echo "$FILTREERITUD_RONGID" | grep -o '"plaaniline_aeg":"[^"]*"' | cut -d'"' -f4)

# ---------------------------------------------------------
# 8. Praegune kellaaeg
# ---------------------------------------------------------
PRAEGUNE_AEG=$(date +"%H:%M")

echo ""
echo "$LAHTEJAAM → $SIHTJAAM"
echo "Praegune kellaaeg: $PRAEGUNE_AEG"
echo ""
echo "Väljumised:"
echo ""

# ---------------------------------------------------------
# 9. & 10. Väljumisaegade töötlemine ja värviline väljund
# (Kuna tsükleid ei tohi kasutada, eraldame kellaajad ridade kaupa)
# ---------------------------------------------------------
AEG1=$(echo "$AJAD" | sed -n '1p')
AEG2=$(echo "$AJAD" | sed -n '2p')
AEG3=$(echo "$AJAD" | sed -n '3p')
AEG4=$(echo "$AJAD" | sed -n '4p')
AEG5=$(echo "$AJAD" | sed -n '5p')

# 1. Rong
if [ -n "$AEG1" ]; then
    if [[ "$AEG1" < "$PRAEGUNE_AEG" ]]; then
        echo -e "${PUNANE}$AEG1  rong on juba väljunud${LOHETUS}"
    else
        echo -e "${ROHELINE}$AEG1  rong on veel ees${LOHETUS}"
    fi
fi

# 2. Rong
if [ -n "$AEG2" ]; then
    if [[ "$AEG2" < "$PRAEGUNE_AEG" ]]; then
        echo -e "${PUNANE}$AEG2  rong on juba väljunud${LOHETUS}"
    else
        echo -e "${ROHELINE}$AEG2  rong on veel ees${LOHETUS}"
    fi
fi

# 3. Rong
if [ -n "$AEG3" ]; then
    if [[ "$AEG3" < "$PRAEGUNE_AEG" ]]; then
        echo -e "${PUNANE}$AEG3  rong on juba väljunud${LOHETUS}"
    else
        echo -e "${ROHELINE}$AEG3  rong on veel ees${LOHETUS}"
    fi
fi

# 4. Rong
if [ -n "$AEG4" ]; then
    if [[ "$AEG4" < "$PRAEGUNE_AEG" ]]; then
        echo -e "${PUNANE}$AEG4  rong on juba väljunud${LOHETUS}"
    else
        echo -e "${ROHELINE}$AEG4  rong on veel ees${LOHETUS}"
    fi
fi

# 5. Rong
if [ -n "$AEG5" ]; then
    if [[ "$AEG5" < "$PRAEGUNE_AEG" ]]; then
        echo -e "${PUNANE}$AEG5  rong on juba väljunud${LOHETUS}"
    else
        echo -e "${ROHELINE}$AEG5  rong on veel ees${LOHETUS}"
    fi
fi
