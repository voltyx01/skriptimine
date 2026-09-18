#!/bin/bash

read -p "Sisesta ridade arv: " rida

for (( i=1; i<=rida; i++ )); do
    echo -n "$i. "
    for (( j=1; j<=rida; j++ )); do
        if (( j <= rida - i )); then
            echo -n "o "
        else
            echo -n "* "
        fi
    done
    echo ""
done
