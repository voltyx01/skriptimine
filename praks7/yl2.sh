#!/bin/bash

read -p "Sisesta ridade arv: " rida
read -p "Sisesta tarnide arv reas: " tarn

for (( i=1; i<=rida; i++ )); do
    echo -n "$i. "
    for (( j=1; j<=tarn; j++ )); do
        echo -n "* "
    done
    echo ""
done
