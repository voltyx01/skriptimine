#!/bin/bash

read -p "Sisesta ridade arv: " rida
read -p "Sisesta tarnide arv reas: " tarn

for (( i=1; i<=rida; i++ )); do
    echo -n "$i. "
    for (( j=1; j<=tarn; j++ )); do
        if [[ $i -eq 1 || $i -eq $rida || $j -eq 1 || $j -eq $tarn ]]; then
            echo -n "* "
        else
            echo -n "  "
        fi
    done
    echo ""
done
