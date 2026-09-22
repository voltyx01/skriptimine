#!/bin/bash
# Skript lahendab ruutvõrrandi Ax² + Bx + C = 0

# 1. Kontrollime, kas on antud täpselt 3 argumenti
if [ $# -ne 3 ]; then
    echo "Kasutamine: $0 A B C"
    echo "Näide: $0 1 -3 2"
    exit 1
fi

A=$1
B=$2
C=$3

# 2. Kontrollime, et A ei oleks 0
if [ $(echo "$A == 0" | bc -l) -eq 1 ]; then
    echo "Viga: Kordaja A ei tohi olla 0!"
    exit 1
fi

# 3. Arvutame diskriminandi D = B^2 - 4AC
D=$(echo "$B * $B - 4 * $A * $C" | bc -l)

# 4. Kontrollime diskriminandi väärtust
if [ $(echo "$D > 0" | bc -l) -eq 1 ]; then
    # Kaks lahendit
    X1=$(echo "(-($B) + sqrt($D)) / (2 * $A)" | bc -l)
    X2=$(echo "(-($B) - sqrt($D)) / (2 * $A)" | bc -l)
    
    echo "Võrrandil on kaks reaalarvulist lahendit:"
    printf "x1 = %.5f\n" "$X1"
    printf "x2 = %.5f\n" "$X2"

elif [ $(echo "$D == 0" | bc -l) -eq 1 ]; then
    # Üks lahend
    X=$(echo "(-($B)) / (2 * $A)" | bc -l)
    
    echo "Võrrandil on üks reaalarvuline lahend:"
    printf "x = %.5f\n" "$X"

else
    # Reaalarvulised lahendid puuduvad
    echo "Võrrandil puuduvad reaalarvulised lahendid (D < 0)."
fi
